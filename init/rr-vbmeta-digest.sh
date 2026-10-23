#!/vendor/bin/sh
# Publish the AVB vbmeta digest for the Duck software CSR. dodge runs this when
# a KeyMint 3 TEE rejects generateCertificateRequestV2. The digest is SHA-256
# of the top-level vbmeta struct followed by each chained vbmeta struct, which
# is what the bootloader puts in androidboot.vbmeta.digest.
set -u
if [ -d /vendor/bin ]; then
    export PATH="/vendor/bin:${PATH}"
fi

BLOCK="${RR_VBMETA_BLOCK:-/dev/block/by-name}"
WORKDIR="${RR_VBMETA_WORKDIR:-/data/vendor/rr-vbmeta}"
mkdir -p "$WORKDIR" || exit 1
trap 'rm -rf "$WORKDIR"' EXIT

be64() {
    # $1 file, $2 offset. The sizes in a vbmeta header fit in 32 bits.
    set -- "$1" "$2" $(od -An -tx1 -j "$2" -N 8 "$1")
    hi=$((0x$3$4$5$6))
    lo=$((0x$7$8$9${10}))
    if [ "$hi" -ne 0 ]; then
        return 1
    fi
    echo "$lo"
}

be32() {
    set -- "$1" "$2" $(od -An -tx1 -j "$2" -N 4 "$1")
    echo $((0x$3$4$5$6))
}

part_size() {
    if [ -b "$1" ]; then
        blockdev --getsize64 "$1"
    else
        wc -c < "$1"
    fi
}

# Copy vbmeta bytes from a vbmeta partition (AVB0 at offset 0) or from the
# footer of a chained partition such as boot.
extract_vbmeta() {
    part="$1"
    out="$2"
    magic=$(dd if="$part" bs=4 count=1 status=none 2>/dev/null)
    if [ "$magic" = "AVB0" ]; then
        dd if="$part" of="$WORKDIR/hdr" bs=256 count=1 status=none 2>/dev/null || return 1
        auth=$(be64 "$WORKDIR/hdr" 12) || return 1
        aux=$(be64 "$WORKDIR/hdr" 20) || return 1
        size=$((256 + auth + aux))
        offset=0
    else
        total=$(part_size "$part") || return 1
        dd if="$part" of="$WORKDIR/footer" bs=64 count=1 skip="$((total / 64 - 1))" status=none 2>/dev/null || return 1
        magic=$(dd if="$WORKDIR/footer" bs=4 count=1 status=none 2>/dev/null)
        if [ "$magic" != "AVBf" ]; then
            return 1
        fi
        offset=$(be64 "$WORKDIR/footer" 20) || return 1
        size=$(be64 "$WORKDIR/footer" 28) || return 1
    fi
    if [ "$size" -le 256 ] || [ "$size" -gt 1048576 ]; then
        return 1
    fi
    align=4096
    skip_blocks=$((offset / align))
    skip_rem=$((offset % align))
    need=$((skip_rem + size))
    dd if="$part" bs="$align" skip="$skip_blocks" count="$(((need + align - 1) / align))" status=none 2>/dev/null \
        | dd bs=1 skip="$skip_rem" count="$size" of="$out" status=none 2>/dev/null || return 1
}

SLOT=$(getprop ro.boot.slot_suffix)
extract_vbmeta "$BLOCK/vbmeta${SLOT}" "$WORKDIR/main" || exit 1

desc_off=$(be64 "$WORKDIR/main" 96) || exit 1
desc_size=$(be64 "$WORKDIR/main" 104) || exit 1
auth=$(be64 "$WORKDIR/main" 12) || exit 1
pos=$((256 + auth + desc_off))
end=$((pos + desc_size))
: > "$WORKDIR/chains"
while [ "$pos" -lt "$end" ]; do
    tag=$(be64 "$WORKDIR/main" "$pos") || exit 1
    follow=$(be64 "$WORKDIR/main" $((pos + 8))) || exit 1
    if [ "$tag" -eq 4 ]; then
        name_len=$(be32 "$WORKDIR/main" $((pos + 20)))
        flags=$(be32 "$WORKDIR/main" $((pos + 28)))
        name=$(dd if="$WORKDIR/main" bs=1 skip=$((pos + 92)) count="$name_len" status=none 2>/dev/null | tr -d '\000')
        suffix="$SLOT"
        if [ $((flags & 1)) -ne 0 ]; then
            suffix=""
        fi
        echo "$BLOCK/${name}${suffix}" >> "$WORKDIR/chains"
    fi
    pos=$((pos + 16 + follow))
done

{
    cat "$WORKDIR/main"
    while read -r part; do
        [ -n "$part" ] || continue
        base=$(basename "$part")
        extract_vbmeta "$part" "$WORKDIR/$base" || exit 1
        cat "$WORKDIR/$base"
    done < "$WORKDIR/chains"
} | sha256sum > "$WORKDIR/digest"

digest=$(cat "$WORKDIR/digest")
digest=${digest%% *}
if [ "$(printf '%s' "$digest" | wc -c)" -ne 64 ]; then
    exit 1
fi
setprop vendor.rr.vbmeta_digest "$digest"
