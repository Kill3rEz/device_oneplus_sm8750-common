#
# Copyright (C) 2021-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Add common definitions for Qualcomm
$(call inherit-product, hardware/qcom-caf/common/common.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_odm=true \
    POSTINSTALL_PATH_odm=bin/xbl_config_arb_check \
    FILESYSTEM_TYPE_odm=erofs \
    POSTINSTALL_OPTIONAL_odm=false

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script \
    xbl_config_arb_check

# Alert slider
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    DeviceSettings \
    tri-state-key-calibrate
endif

# Audio
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usb.default \
    audioadsprpcd \
    audiohalservice.qti \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libagmipcservice \
    libaudiochargerlistener \
    libbatterylistener \
    libcustomva_intf \
    libfmpal \
    libhfp_pal \
    libhotword_intf \
    libpaleventnotifier \
    libpalipcservice \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libsoundtriggerhal.qti \
    libvolumelistener \
    qtiaudiohalvendorextn \
    libaudiohalvendorextn

# PenguinOS: the prebuilt /vendor/lib64/hw/libaudioeffecthal.qti.so (DISABLE_DEPS, mandatory in
# vendor_audio_interfaces.xml) links android.hardware.audio.effect-V3-ndk. On A16 V3 was the current
# version and got pulled in by the source effects; on A17 they link V4, so V3 must be installed
# explicitly or audiohalservice.qti never registers IModule/IConfig -> boot hangs in StartAudioService.
PRODUCT_PACKAGES += \
    android.hardware.audio.effect-V3-ndk.vendor

PRODUCT_PACKAGES += \
    libbundleaidl \
    libdownmixaidl \
    libdynamicsprocessingaidl \
    libloudnessenhanceraidl \
    libreverbaidl \
    libvisualizeraidl

PRODUCT_PACKAGES += \
    android.hardware.audio.common-V1-ndk.vendor \
    android.hardware.audio.core-V2-ndk.vendor \
    android.hardware.audio.core.sounddose-V1-ndk.vendor \
    android.hardware.audio.core.sounddose-V2-ndk.vendor \
    android.media.audio.common.types-V3-ndk.vendor \
    android.media.audio.common.types-V4-ndk.vendor \
    libalsautilsv2.vendor \
    libaudioaidlcommon.vendor \
    libaudioutils_shim \
    libmediautils_vendor.vendor \
    libmemunreachable.vendor

AUDIO_HAL_DIR := hardware/qcom-caf/sm8750/audio/primary-hal
CONFIG_HAL_SRC_DIR := $(AUDIO_HAL_DIR)/configs/sun
CONFIG_PAL_SRC_DIR := $(AUDIO_HAL_DIR)/../pal/configs/sun
CONFIG_SKU_OUT_DIR := $(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_sun

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_module_config_primary.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_module_config_primary.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_ODM)/etc/audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    $(CONFIG_HAL_SRC_DIR)/audio_effects_config.xml:$(CONFIG_SKU_OUT_DIR)/audio_effects_config.xml \
    $(CONFIG_HAL_SRC_DIR)/mem_logger_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mem_logger_config.xml \
    $(CONFIG_HAL_SRC_DIR)/microphone_characteristics.xml:$(TARGET_COPY_OUT_VENDOR)/etc/microphone_characteristics.xml \
    $(CONFIG_HAL_SRC_DIR)/quasar_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/quasar_config.xml \
    $(CONFIG_HAL_SRC_DIR)/vendor_audio_interfaces.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vendor_audio_interfaces.xml \
    $(CONFIG_PAL_SRC_DIR)/Hapticsconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/Hapticsconfig.xml \
    $(CONFIG_PAL_SRC_DIR)/card-defs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/card-defs.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/stub_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/stub_audio_policy_configuration.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    hardware/interfaces/audio/aidl/default/audio_effects_config.xml:$(CONFIG_SKU_OUT_DIR)/audio_effects_config_stub.xml

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl \
    lib_bt_aptx \
    lib_bt_ble \
    lib_bt_bundle

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

# Camera
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# Context Hub
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.context_hub.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/android.hardware.context_hub.xml
endif

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# DebugFS
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    init.qti.display_boot.rc \
    init.qti.display_boot.sh \
    libfilefinder \
    mapper.qti \
    vendor.qti.hardware.display.allocator-service \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.display.demura-service \
    vendor.qti.hardware.display.snapalloc-impl

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# Doze
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    OPlusFrameworksResPhoneCommon \
    OPlusSettingsResPhoneCommon
endif

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Fastboot
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Fingerprint
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    IFAAService

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml
endif

# GPS
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps/gps.conf:$(TARGET_COPY_OUT_ODM)/etc/gps.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml
endif

# Graphics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_3.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2024-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2024-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery

# Hotword enrollment
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

# HWUI
TARGET_USES_VULKAN := true

# IPACM
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    ipacm \
    IPACM_cfg.xml \
    IPACM_Filter_cfg.xml
endif

# IR
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    android.hardware.ir-service.oplus

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/oplus-hiddenapi-package-allowlist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/oplus-hiddenapi-package-allowlist.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/android.hardware.consumerir.xml
endif

# Init
PRODUCT_PACKAGES += \
    fstab.default \
    fstab.default.vendor_ramdisk \
    init.class_main.sh \
    init.kernel.post_boot-memory.sh \
    init.kernel.post_boot-sun.sh \
    init.kernel.post_boot-sun_default_6_2.sh \
    init.oplus.rc \
    init.qcom.early_boot.sh \
    init.qcom.rc \
    init.qcom.recovery.rc \
    init.qcom.sh \
    init.target.rc \
    ueventd.oplus.rc \
    ueventd.qcom.rc

$(call soong_config_set,libinit,vendor_init_lib,//$(LOCAL_PATH):libinit_oplus)

# Kernel
PRODUCT_ENABLE_UFFD_GC := true

PRODUCT_COPY_FILES += \
    kernel/oneplus/sm8750/modules.systemdlkm_blocklist.msm.sun:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore_V3.xml

ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    android.hardware.security.keymint3-service.strongbox.nxp \
    android.hardware.weaver-service.nxp
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

# Lineage Health
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

$(call soong_config_set,lineage_health,charging_control_charging_path,/sys/class/oplus_chg/battery/mmi_charging_enable)

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay-service.oplus

$(call soong_config_set_bool,OPLUS_LINEAGE_LIVEDISPLAY_HAL,ENABLE_SE,false)

# PenguinOS: select composer3 V3 (v3_3 = V3 + AIQE) for the SM8750 display HAL.
# The build links android.hardware.graphics.composer3-V3 (A17), whose
# IComposerClient adds getDisplayConfigurations()/notifyExpectedPresent(); those
# are only compiled in when COMPOSER3_V3 is defined, which the qtidisplay
# composer_version=v3_3 case provides (code + composer3-V3-ndk + v3 VINTF xml).
# QCOM's display-product.mk only sets v3_3 up to A15 and its qtidisplay namespace
# isn't inherited here, so set it explicitly.
$(call soong_config_set,qtidisplay,composer_version,v3_3)

# mapper_ext gates QtiMapperExtensions2.cpp (which defines IQtiMapperExt_loadIMapperExt)
# into mapper.qti. QCOM's display-product.mk defaults it to true (A15+), but that
# namespace file isn't inherited here, so mapper.qti ships without the extension
# symbol and vendor prebuilts (e.g. libqcodec2_utils) fail to resolve it. Enable it.
$(call soong_config_set,qtidisplay,mapper_ext,true)

# Logging
SPAMMY_LOG_TAGS := \
    AAL \
    AALLightSensor \
    ACDB \
    AGM \
    AdnRecord \
    AdnRecordCache \
    AdnRecordLoader \
    AirplaneHandler \
    AT \
    APM-KpiMonitor \
    APM-ServiceJ \
    APM-SessionJ \
    APM-SessionN \
    APM-Subscriber \
    C2K_RIL-DATA \
    C2MtkBufferManager \
    C2Store \
    CapaSwitch \
    CarrierExpressServiceImpl \
    CarrierExpressServiceImplExt \
    CCodec \
    CCodecBuffers \
    ConstraintSet \
    CountryDetector \
    CwbService \
    DataDispatcher \
    DcFcMgr \
    DisplayModeController \
    DMC-ApmService \
    DMC-Core \
    DMC-DmcService \
    DMC-EventsSubscriber \
    DMC-ReqQManager \
    DMC-SessionManager \
    DMC-TranslatorLoader \
    DMC-TranslatorUtils \
    DSSelector \
    DSSelectorOP01 \
    DSSelectorOP02 \
    DSSelectorOP09 \
    DSSelectorOP18 \
    DSSelectorOm \
    DSSelectorUtil \
    ExternalSimMgr \
    FrameTracker \
    gsl \
    GsmCallTkrHlpr \
    GsmCdmaConn \
    GsmCdmaPhone \
    HWUI \
    hwcomposer \
    IccCardProxy \
    IccPhoneBookIM \
    IccProvider \
    IMS_RILA \
    IMSRILRequest \
    ImsApp \
    ImsBaseCommands \
    ImsCall \
    ImsCallProfile \
    ImsCallSession \
    ImsEcbm \
    ImsEcbmProxy \
    ImsManager \
    ImsPhone \
    ImsPhoneBase \
    ImsPhoneCall \
    ImsService \
    ImsVTProvider \
    IRIS_LOG_SERV_I7 \
    IsimFileHandler \
    IsimRecords \
    LCM-Subscriber \
    Light \
    libPowerHal \
    MAPI-CommandProcessor \
    MAPI-MdiRedirector \
    MAPI-MdiRedirectorCtrl \
    MAPI-NetworkSocketConnection \
    MAPI-SocketConnection \
    MAPI-SocketListener \
    MAPI-TranslatorManager \
    MDM-Subscriber \
    MwiRIL \
    NetAgentService \
    NetAgent_IO \
    NetLnkEventHdlr \
    NetworkPolicy \
    NetworkStats \
    occe_create \
    OplusTouchDaemon \
    OpenGLRenderer \
    OperatorUtils \
    PKM-Lib \
    PKM-MDM \
    PKM-Monitor \
    PKM-SA \
    PKM-Service \
    Phone \
    PhoneConfigurationSettings \
    PhoneFactory \
    PowerHalAddressUitls \
    PowerHalMgrImpl \
    PowerHalMgrServiceImpl \
    PowerHalWifiMonitor \
    PQ \
    PQ_DS \
    ProxyController \
    QTI PowerHAL \
    RadioManager \
    RFX \
    RfxAction \
    RfxChannelMgr \
    RfxCloneMgr \
    RfxContFactory \
    RfxController \
    RfxDebugInfo \
    RfxDisThread \
    RfxFragEnc \
    RfxHandlerMgr \
    RfxIdToMsgId \
    RfxIdToStr \
    RfxMainThread \
    RfxMclDisThread \
    RfxMclMessenger \
    RfxMclStatusMgr \
    RfxMessage \
    RfxObject \
    RfxOpUtils \
    RfxRilAdapter \
    RfxRilUtils \
    RfxRoot \
    RfxStatusMgr \
    RfxTimer \
    RIL \
    RIL-Fusion \
    RIL-Netlink \
    RIL-Parcel \
    RIL-SocListen \
    RIL-Socket \
    RIL_UIM_SOCKET \
    RILC \
    RILC-OP \
    RILD \
    RILMD2-SS \
    RILMUXD \
    RilClient \
    RilOemClient \
    RilOpProxy \
    RmcCapa \
    RmcCdmaSimRequest \
    RmcCdmaSimUrc \
    RmcCommSimOpReq \
    RmcCommSimReq \
    RmcCommSimUrc \
    RmcDcCommon \
    RmcDcPdnManager \
    RmcDcReqHandler \
    RmcDcUtility \
    RmcEccNumberUrcHandler \
    RmcEmbmsReq \
    RmcEmbmsUrc \
    RmcGsmSimRequest \
    RmcGsmSimUrc \
    RmcImsCtlReqHdl \
    RmcImsCtlUrcHdl \
    RmcNwHdlr \
    RmcNwRTReqHdlr \
    RmcNwReqHdlr \
    RmcOemHandler \
    RmcOpRadioReq \
    RmcPhbReq \
    RmcPhbUrc \
    RmcRadioReq \
    RmcRatSwHdlr \
    RmcWp \
    RTC_DAC \
    RtcCapa \
    RtcCommSimCtrl \
    RtcDC \
    RtcEccNumberController \
    RtcEmbmsAt \
    RtcEmbmsUtil \
    RtcIms \
    RtcImsConference \
    RtcImsConfigController \
    SDM \
    StatsLog \
    synaLib \
    thermal_src \
    TRS \
    vendor.qti.bluetooth@1.1-ibs_handler \
    vendor.qti.bluetooth@1.1-wake_lock \
    vendor.qti.vibrator \
    VPUD

ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_VENDOR_PROPERTIES += \
    $(foreach tag,$(SPAMMY_LOG_TAGS),log.tag.$(tag)=S)
endif

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_codecs_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2_audio.xml \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.base-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.base-arm64.policy \
    $(AUDIO_HAL_DIR)/configs/common/codec2/service/1.0/c2audio.vendor.ext-arm64.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy

# PenguinOS: AOSPA/QTI builds the dynamic mediaserver (TARGET_DYNAMIC_64_32_MEDIASERVER,
# device/qcom/common/common.mk): mediaserver_dynamic.rc imports
# mediaserver.64bit_${ro.mediaserver.64b.enable:-false}.rc. dodge is 64-bit only, so only
# mediaserver64 is installed; without this prop init picks the 32-bit variant
# (/system/bin/mediaserver32, absent) -> no media.player / media.resource_manager -> the
# setup wizard blocks waiting for media.player (black screen after boot). AOSPA sets this in
# device/qcom/common/vendor/media/qti-media.mk, which dodge doesn't include (no QTI "media"
# component).
PRODUCT_VENDOR_PROPERTIES += \
    ro.mediaserver.64b.enable=true

# Memtrack
PRODUCT_PACKAGES += \
    vendor.qti.hardware.memtrack-service

# NFC
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    com.android.nfc_extras \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml
endif

# OPlus dummy services
PRODUCT_PACKAGES += \
    vendor.oplus.hardware.commondcs-service \
    vendor.oplus.hardware.osense.client-service \
    vendor.oplus.hardware.performance-service

# Overlays
$(call inherit-product, hardware/oplus/overlay/generic/generic.mk)
$(call inherit-product, hardware/oplus/overlay/qssi/qssi.mk)

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    FrameworksResTargetCommon \
    NcmTetheringOverlay \
    OPlusFrameworksResCommon \
    OPlusSettingsResCommon \
    OPlusSystemUIResCommon \
    WifiResTarget

ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    CarrierConfigResCommon \
    FrameworksResTargetPhone
endif

# Partitions
# NB: the mount-point dirs (firmware_mnt, bt_firmware, dsp) are already created
# — with their /firmware-style symlinks — by QCOM's legacy AndroidBoardCommon.mk,
# which AOSPA always pulls in via device/qcom/common/Android.mk. Keeping the
# soong mkdir modules here (a Lineage-base habit) produced duplicate make rules
# for those dirs. Dropped; the legacy path handles them.

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr \
    libperfmgr.vendor \
    libqti-perfd-client

# NOTE: The conflicting QCOM power HAL (android.hardware.power-service + power-v6.xml)
# is prevented at the source via TARGET_PROVIDES_POWERHAL := true in
# device/oneplus/dodge/aospa_dodge.mk, which makes device/qcom/common/common.mk skip
# inheriting vendor/qcom/opensource/power/power-vendor-product.mk. PRODUCT_PACKAGES_REMOVE
# is NOT honored by this build tree, so it cannot be used here.

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# QSPA
PRODUCT_PACKAGES += \
    qspa_vendor.rc \
    vendor.qti.qspa-service

# Recovery
$(call soong_config_set_bool,recovery,target_recovery_uses_qti_drm,true)

# SecureElement
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    SecureElementResTarget_Vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/com.android.se.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.se.xml
endif

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.oplus-multihal \
    sensors.dynamic_sensor_hal \
    sensors.qsh_wrapper

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml
endif

# Shipping API
BOARD_SHIPPING_API_LEVEL := 202404
PRODUCT_SHIPPING_API_LEVEL := 35

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/google/pixel/power-libperfmgr \
    hardware/google/pixel/kernel_headers \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/oplus \
    hardware/qcom-caf/common/libqti-perfd-client \
    hardware/qcom-caf/sm8750 \
    hardware/qcom/wlan/qcwcn/wpa_supplicant_8_lib

# Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Telephony
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    nrmodeswitcher \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml \
    telephony-ext

# NB: telephony-ext is already added to PRODUCT_BOOT_JARS by AOSPA's
# aospa-target.mk; re-adding it here (as the Lineage-based osm tree does)
# produces a duplicate boot-telephony-ext.art rule. Dropped.

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.telephony.mbms.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.mbms.xml

$(call inherit-product, hardware/oplus/oplus-fwk/oplus-fwk.mk)
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti

# Touch
ifneq ($(TARGET_IS_TABLET),true)
PRODUCT_PACKAGES += \
    vendor.lineage.touch-service.oplus

$(call soong_config_set,OPLUS_LINEAGE_TOUCH_HAL,INCLUDE_DIR,$(LOCAL_PATH)/touch/include)
$(call soong_config_set_bool,OPLUS_LINEAGE_TOUCH_HAL,USE_OPLUSTOUCH,true)
endif

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.qti \
    android.hardware.usb.gadget-service.qti \
    init.qcom.usb.rc \
    init.qcom.usb.sh \
    oplus_usb_compositions.conf

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Vibrator
ifneq ($(TARGET_IS_TABLET),true)
ifneq ($(TARGET_USES_OPLUS_VIBRATOR_BLOBS),true)
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service.oplus_sm8750
endif

PRODUCT_PACKAGES += \
    HapticsPolicy.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vibrator/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml
endif

# VINTF
# The device ships the LineageOS vendor HALs (livedisplay, powershare, touch) from
# hardware/lineage/interfaces. AOSPA's framework compatibility matrix doesn't know
# them, so VINTF fails ("in device manifest but not in framework compatibility
# matrix"). Add LineageOS' own framework matrix, which declares all vendor.lineage.*
# HAL interfaces, so the device manifest stays compatible.
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/lineage/interfaces/compatibility_matrices/compatibility_matrix.lineage.xml \
    hardware/oplus/vintf/device_framework_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml
DEVICE_MATRIX_FILE := hardware/qcom-caf/common/compatibility_matrix_aidl.xml
DEVICE_MANIFEST_FILE := \
    $(AUDIO_HAL_DIR)/configs/sun/manifest_audio_qti_services.xml \
    $(LOCAL_PATH)/vintf/manifest_sun.xml

ifneq ($(TARGET_IS_TABLET),true)
DEVICE_MANIFEST_FILE += \
    $(LOCAL_PATH)/vintf/network_manifest.xml

ODM_MANIFEST_FILES := \
    $(LOCAL_PATH)/vintf/network_manifest_odm.xml
endif

# Virtualization service
# PenguinOS/AOSPA: la Virtualization CLO non fornisce apex/product_packages.mk
# (struttura diversa dall'AOSP/Lineage). AVF non necessario -> disabilitato.
# $(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

# Dolby
# Must stay below the VINTF block above, which assigns DEVICE_MANIFEST_FILE with
# := and would otherwise drop the HIDL fragments this appends.
$(call inherit-product, vendor/oneplus/dolby/config.mk)

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/oneplus/sm8750-common/sm8750-common-vendor.mk)
