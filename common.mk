# Copyright 2023 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

QCOM_COMMON_PATH := device/qcom/common

ifeq ($(TARGET_BOARD_PLATFORM),)
$(error "TARGET_BOARD_PLATFORM is not defined yet, please define in your device makefile so it's accessible to QCOM common.")
endif

# Board defs
include $(QCOM_COMMON_PATH)/defs.mk

# List of targets that use video hardware.
MSM_VIDC_TARGET_LIST ?= \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    kona \
    lito \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845

ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
# List of targets that use master side content protection.
MASTER_SIDE_CP_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    kona \
    lito \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845
endif

# Include QCOM board utilities.
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
include vendor/qcom/opensource/core-utils/build/utils.mk
endif

ifeq ($(call is-board-platform-in-list,$(6_1_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 6.1
QCOM_HARDWARE_VARIANT := sm8650
else ifeq ($(call is-board-platform-in-list,$(5_15_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.15
QCOM_HARDWARE_VARIANT := sm8550
else ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.10
QCOM_HARDWARE_VARIANT := sm8450
else ifeq ($(call is-board-platform-in-list,$(5_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.4
QCOM_HARDWARE_VARIANT := sm8350
else ifeq ($(call is-board-platform-in-list,$(4_19_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.19
QCOM_HARDWARE_VARIANT := sm8250
else ifeq ($(call is-board-platform-in-list,$(4_14_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.14
QCOM_HARDWARE_VARIANT := sm8150
else ifeq ($(call is-board-platform-in-list,$(4_9_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.9
QCOM_HARDWARE_VARIANT := sdm845
else ifeq ($(call is-board-platform-in-list,$(4_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.4
QCOM_HARDWARE_VARIANT := msm8998
else ifeq ($(call is-board-platform-in-list,$(3_18_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 3.18
QCOM_HARDWARE_VARIANT := msm8996
else
QCOM_HARDWARE_VARIANT := $(TARGET_BOARD_PLATFORM)
endif

# Enable DRM PP driver on UM platforms that support it
ifeq (,$(filter 3.18 4.4, $(TARGET_KERNEL_VERSION)))
    SOONG_CONFIG_qtidisplay_drmpp := true
    TARGET_USES_DRM_PP := true
endif

# Enable Gralloc4 on UM platforms that support it
ifeq (,$(filter 3.18 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
    SOONG_CONFIG_qtidisplay_gralloc4 := true
endif

# Enable displayconfig on every UM platform
SOONG_CONFIG_qtidisplay_displayconfig_enabled := true

ifeq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
    TARGET_USES_QCOM_AUDIO_AR ?= true
endif

# Allow a device to opt-out hardset of PRODUCT_SOONG_NAMESPACES
QCOM_SOONG_NAMESPACE ?= hardware/qcom-caf/$(QCOM_HARDWARE_VARIANT)
PRODUCT_SOONG_NAMESPACES += $(QCOM_SOONG_NAMESPACE)

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys/display \
    vendor/qcom/opensource/commonsys-intf/display

ifeq ($(call is-board-platform-in-list,$(QCOM_BOARD_PLATFORMS)),true)
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
# Compatibility matrix
DEVICE_MATRIX_FILE += \
    device/qcom/vendor-common/compatibility_matrix.xml

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml

DEVICE_FRAMEWORK_MANIFEST_FILE += \
    device/qcom/qssi/framework_manifest.xml
endif

# Opt out of 16K alignment changes
PRODUCT_MAX_PAGE_SIZE_SUPPORTED ?= 4096

# Components
include $(QCOM_COMMON_PATH)/components.mk

# Configstore
PRODUCT_PACKAGES += \
    vendor.qti.hardware.capabilityconfigstore@1.0 \
    vendor.qti.hardware.capabilityconfigstore@1.0.vendor

# Filesystem
TARGET_FS_CONFIG_GEN += $(QCOM_COMMON_PATH)/config.fs

# GPS
PRODUCT_PACKAGES += \
    libcurl \
    libcurl.vendor

# Media
TARGET_DYNAMIC_64_32_MEDIASERVER := true

# Partition source order for Product/Build properties pickup.
PRODUCT_SYSTEM_PROPERTIES += \
    ro.product.property_source_order=odm,vendor,product,system_ext,system

# Power
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
$(call inherit-product-if-exists, vendor/qcom/opensource/power/power-vendor-product.mk)
endif

# Public Libraries
PRODUCT_COPY_FILES += \
    device/qcom/qssi/public.libraries.product-qti.txt:$(TARGET_COPY_OUT_PRODUCT)/etc/public.libraries-qti.txt \
    device/qcom/qssi/public.libraries.system_ext-qti.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-qti.txt

# Permissions
PRODUCT_COPY_FILES += \
    device/qcom/qssi/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-qti.xml \
    device/qcom/qssi/privapp-permissions-qti-system-ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-system-ext.xml \
    device/qcom/qssi/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml \
    device/qcom/qssi/qti_whitelist_system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/qti_whitelist_system_ext.xml

# QSPA
PRODUCT_PACKAGES += \
    qspa_system.rc \
    qspa_default.rc

# Thermal
ifeq ($(shell expr $(TARGET_KERNEL_VERSION) \<= 5.4), 1)
    $(call soong_config_set,qti_thermal,netlink,false)
else
    $(call soong_config_set,qti_thermal,netlink,true)
endif

# Trusted User Interface
PRODUCT_PACKAGES += \
    android.hidl.memory.block@1.0.vendor

# usbudev service for usb ip assigment
PRODUCT_PACKAGES += \
    usbudev

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# VNDK
PRODUCT_PACKAGES += \
    libjsoncpp.vendor \
    libpng.vendor \
    libsqlite.vendor \
    libutilscallstack.vendor

# SoC
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=QTI

# WiFi Display
PRODUCT_PACKAGES += \
    libwfdaac_vendor

# RFS APQ GNSS symlinks
PRODUCT_PACKAGES += \
    rfs_apq_gnss_hlos_symlink \
    rfs_apq_gnss_ramdumps_symlink \
    rfs_apq_gnss_readonly_firmware_symlink \
    rfs_apq_gnss_readonly_vendor_firmware_symlink \
    rfs_apq_gnss_readwrite_symlink \
    rfs_apq_gnss_shared_symlink

# RFS MDM ADSP symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_adsp_hlos_symlink \
    rfs_mdm_adsp_ramdumps_symlink \
    rfs_mdm_adsp_readonly_firmware_symlink \
    rfs_mdm_adsp_readonly_vendor_firmware_symlink \
    rfs_mdm_adsp_readwrite_symlink \
    rfs_mdm_adsp_shared_symlink

# RFS MDM CDSP symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_cdsp_hlos_symlink \
    rfs_mdm_cdsp_ramdumps_symlink \
    rfs_mdm_cdsp_readonly_firmware_symlink \
    rfs_mdm_cdsp_readonly_vendor_firmware_symlink \
    rfs_mdm_cdsp_readwrite_symlink \
    rfs_mdm_cdsp_shared_symlink

# RFS MDM MPSS symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_mpss_hlos_symlink \
    rfs_mdm_mpss_ramdumps_symlink \
    rfs_mdm_mpss_readonly_firmware_symlink \
    rfs_mdm_mpss_readonly_vendor_firmware_symlink \
    rfs_mdm_mpss_readwrite_symlink \
    rfs_mdm_mpss_shared_symlink

# RFS MDM SLPI symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_slpi_hlos_symlink \
    rfs_mdm_slpi_ramdumps_symlink \
    rfs_mdm_slpi_readonly_firmware_symlink \
    rfs_mdm_slpi_readonly_vendor_firmware_symlink \
    rfs_mdm_slpi_readwrite_symlink \
    rfs_mdm_slpi_shared_symlink

# RFS MDM TN symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_tn_hlos_symlink \
    rfs_mdm_tn_ramdumps_symlink \
    rfs_mdm_tn_readonly_firmware_symlink \
    rfs_mdm_tn_readonly_vendor_firmware_symlink \
    rfs_mdm_tn_readwrite_symlink \
    rfs_mdm_tn_shared_symlink

# RFS MDM WPSS symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_wpss_hlos_symlink \
    rfs_mdm_wpss_ramdumps_symlink \
    rfs_mdm_wpss_readonly_firmware_symlink \
    rfs_mdm_wpss_readonly_vendor_firmware_symlink \
    rfs_mdm_wpss_readwrite_symlink \
    rfs_mdm_wpss_shared_symlink

# RFS MSM ADSP symlinks
PRODUCT_PACKAGES += \
    rfs_msm_adsp_hlos_symlink \
    rfs_msm_adsp_ramdumps_symlink \
    rfs_msm_adsp_readonly_firmware_symlink \
    rfs_msm_adsp_readonly_vendor_firmware_symlink \
    rfs_msm_adsp_readwrite_symlink \
    rfs_msm_adsp_shared_symlink

# RFS MSM CDSP symlinks
PRODUCT_PACKAGES += \
    rfs_msm_cdsp_hlos_symlink \
    rfs_msm_cdsp_ramdumps_symlink \
    rfs_msm_cdsp_readonly_firmware_symlink \
    rfs_msm_cdsp_readonly_vendor_firmware_symlink \
    rfs_msm_cdsp_readwrite_symlink \
    rfs_msm_cdsp_shared_symlink

# RFS MSM MPSS symlinks
PRODUCT_PACKAGES += \
    rfs_msm_mpss_hlos_symlink \
    rfs_msm_mpss_ramdumps_symlink \
    rfs_msm_mpss_readonly_firmware_symlink \
    rfs_msm_mpss_readonly_vendor_firmware_symlink \
    rfs_msm_mpss_readwrite_symlink \
    rfs_msm_mpss_shared_symlink

# RFS MSM SLPI symlinks
PRODUCT_PACKAGES += \
    rfs_msm_slpi_hlos_symlink \
    rfs_msm_slpi_ramdumps_symlink \
    rfs_msm_slpi_readonly_firmware_symlink \
    rfs_msm_slpi_readonly_vendor_firmware_symlink \
    rfs_msm_slpi_readwrite_symlink \
    rfs_msm_slpi_shared_symlink

# RFS MSM WPSS symlinks
PRODUCT_PACKAGES += \
    rfs_msm_wpss_hlos_symlink \
    rfs_msm_wpss_ramdumps_symlink \
    rfs_msm_wpss_readonly_firmware_symlink \
    rfs_msm_wpss_readonly_vendor_firmware_symlink \
    rfs_msm_wpss_readwrite_symlink \
    rfs_msm_wpss_shared_symlink

endif # QCOM_BOARD_PLATFORMS
