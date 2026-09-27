# Copyright (C) 2023 Paranoid Android
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

# AV
BOARD_USES_ADRENO := true
TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_MM_AUDIO := true
TARGET_USES_ION := true

# Enable Media Extensions for HAL1 on Legacy Devices
ifeq ($(call is-board-platform-in-list, msm8937 msm8953 msm8996 msm8998 sdm660),true)
  TARGET_USES_MEDIA_EXTENSIONS := true
endif

# Qualcomm kernel.
ifeq ($(TARGET_PREBUILT_KERNEL),)
TARGET_COMPILE_WITH_MSM_KERNEL := true
endif

# Default mount point symlinks to false
# since they are not used on 8998 and up
TARGET_MOUNT_POINTS_SYMLINKS ?= false

# Configure audio HAL features
ifeq ($(AUDIO_FEATURE_ENABLED_CIRRUS_CALIBRATION_RESISTANCE),true)
    $(call soong_config_set,qtiaudio,cirrus_calibration_resistance,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_AGM_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_agm_hidl,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLE_BT_A2DP_LPI),true)
    $(call soong_config_set,qtiaudio,feature_bt_a2dp_lpi,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_DEVICE_PREPARE_SEQ),true)
    $(call soong_config_set,qtiaudio,feature_device_prepare_seq,true)
endif

ifeq ($(AUDIO_FEATURE_DISABLED_DTS_EAGLE),true)
    $(call soong_config_set,qtiaudio,feature_disabled_dts_eagle,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_DYNAMIC_SR),true)
    $(call soong_config_set,qtiaudio,feature_dynamic_sr,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_EC_REF_CAPTURE),true)
    $(call soong_config_set,qtiaudio,feature_ec_ref_capture,true)
endif

ifeq ($(AUDIO_FEATURE_ELLIPTIC_ULTRASOUND_SUPPORT),true)
    $(call soong_config_set,qtiaudio,feature_elliptic_ultrasound,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_EXT_AMPLIFIER),true)
    $(call soong_config_set,qtiaudio,feature_ext_amplifier,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT),true)
    $(call soong_config_set,qtiaudio,feature_extended_compress_format,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_GEF_SUPPORT),true)
    $(call soong_config_set,qtiaudio,feature_gef_support,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_GKI),true)
    $(call soong_config_set,qtiaudio,feature_gki,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_HAL_V7), true)
    $(call soong_config_set,qtiaudio,feature_hal_v7,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_INSTANCE_ID),true)
    $(call soong_config_set,qtiaudio,feature_instance_id,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_KEEP_ALIVE),true)
    $(call soong_config_set,qtiaudio,feature_keep_alive,true)
endif

ifeq ($(SOUND_TRIGGER_FEATURE_LPMA_ENABLED),true)
    $(call soong_config_set,qtiaudio,feature_lpma,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_LSM_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_lsm_hidl,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_MCS),true)
    $(call soong_config_set,qtiaudio,feature_mcs,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_PAL_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_pal_hidl,true)
endif

ifeq ($(BOARD_SUPPORTS_QSTHW_API),true)
    $(call soong_config_set,qtiaudio,feature_qsthw_api,true)
endif

ifeq ($(BOARD_SUPPORTS_SOUND_TRIGGER),true)
    $(call soong_config_set,qtiaudio,feature_sound_trigger,true)
endif

ifeq ($(BOARD_SUPPORTS_SOUND_TRIGGER_HAL),true)
    $(call soong_config_set,qtiaudio,feature_sound_trigger,true)
endif

ifeq ($(BOARD_SUPPORTS_SOUND_TRIGGER_CPU_AFFINITY_SET),true)
    $(call soong_config_set,qtiaudio,feature_sound_trigger_cpu_affinity_set,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_SVA_MULTI_STAGE),true)
    $(call soong_config_set,qtiaudio,feature_sva_multi_stage,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_TRUE_STEREO),true)
    $(call soong_config_set,qtiaudio,feature_true_stereo,true)
endif

ifneq ($(TARGET_PAL_SPKR_PROTECTION_PATH),)
    $(call soong_config_set,qtiaudio,pal_spkr_protection_path,$(TARGET_PAL_SPKR_PROTECTION_PATH))
endif

ifeq ($(AUDIO_FEATURE_ENABLED_ULTRASOUND_PROXIMITY),true)
    $(call soong_config_set,qtiaudio,ultrasound_proximity,true)
endif

# Add qtidisplay to soong config namespaces
SOONG_CONFIG_NAMESPACES += qtidisplay

# Add supported variables to qtidisplay config
SOONG_CONFIG_qtidisplay += \
    composer_version \
    drmpp \
    headless \
    llvmsa \
    gralloc4 \
    displayconfig_enabled \
    udfps \
    default \
    master_side_cp \
    shift_horizontal \
    shift_vertical \
    smmu_proxy \
    var1 \
    var2 \
    var3 \
    hwasan \
    llvmcov \
    mapper_ext \
    ubwcp_headers \
    wide_color \
    target_kernel_version \
    target_no_raw10_custom_format \
    target_uses_aligned_ycbcr_height \
    target_uses_aligned_ycrcb_height \
    target_uses_unaligned_nv21_zsl \
    target_uses_unaligned_ycrcb \
    target_uses_ycrcb_camera_preview \
    target_uses_ycrcb_venus_camera_preview

# Set default values for qtidisplay config
SOONG_CONFIG_qtidisplay_composer_version ?= v3_3
SOONG_CONFIG_qtidisplay_drmpp ?= false
SOONG_CONFIG_qtidisplay_headless ?= false
SOONG_CONFIG_qtidisplay_llvmsa ?= false
SOONG_CONFIG_qtidisplay_gralloc4 ?= false
SOONG_CONFIG_qtidisplay_displayconfig_enabled ?= false
SOONG_CONFIG_qtidisplay_udfps ?= false
SOONG_CONFIG_qtidisplay_default ?= true
SOONG_CONFIG_qtidisplay_master_side_cp ?= false
SOONG_CONFIG_qtidisplay_shift_horizontal ?= 0
SOONG_CONFIG_qtidisplay_shift_vertical ?= 0
SOONG_CONFIG_qtidisplay_smmu_proxy ?= false
SOONG_CONFIG_qtidisplay_var1 ?= false
SOONG_CONFIG_qtidisplay_var2 ?= false
SOONG_CONFIG_qtidisplay_var3 ?= false
SOONG_CONFIG_qtidisplay_hwasan ?= false
SOONG_CONFIG_qtidisplay_llvmcov ?= false
SOONG_CONFIG_qtidisplay_mapper_ext ?= true
SOONG_CONFIG_qtidisplay_ubwcp_headers ?= false
SOONG_CONFIG_qtidisplay_wide_color ?= false
SOONG_CONFIG_qtidisplay_target_kernel_version ?= 0
SOONG_CONFIG_qtidisplay_target_no_raw10_custom_format ?= false
SOONG_CONFIG_qtidisplay_target_uses_aligned_ycbcr_height ?= false
SOONG_CONFIG_qtidisplay_target_uses_aligned_ycrcb_height ?= false
SOONG_CONFIG_qtidisplay_target_uses_unaligned_nv21_zsl ?= false
SOONG_CONFIG_qtidisplay_target_uses_unaligned_ycrcb ?= false
SOONG_CONFIG_qtidisplay_target_uses_ycrcb_camera_preview ?= false
SOONG_CONFIG_qtidisplay_target_uses_ycrcb_venus_camera_preview ?= false

ifneq ($(TARGET_DISPLAY_SHIFT_HORIZONTAL),)
    SOONG_CONFIG_qtidisplay_shift_horizontal := $(TARGET_DISPLAY_SHIFT_HORIZONTAL)
endif

ifneq ($(TARGET_DISPLAY_SHIFT_VERTICAL),)
    SOONG_CONFIG_qtidisplay_shift_vertical := $(TARGET_DISPLAY_SHIFT_VERTICAL)
endif

ifeq ($(TARGET_HAS_WIDE_COLOR_DISPLAY), true)
    SOONG_CONFIG_qtidisplay_wide_color := true
endif

ifeq ($(TARGET_USES_FOD_ZPOS),true)
    SOONG_CONFIG_qtidisplay_udfps := true
endif

ifneq ($(TARGET_KERNEL_VERSION),)
    SOONG_CONFIG_qtidisplay_target_kernel_version := $(TARGET_KERNEL_VERSION)
endif

# For libgrallocutils features
ifeq ($(TARGET_NO_RAW10_CUSTOM_FORMAT),true)
    SOONG_CONFIG_qtidisplay_target_no_raw10_custom_format := true
endif

ifeq ($(TARGET_USES_ALIGNED_YCBCR_HEIGHT),true)
    SOONG_CONFIG_qtidisplay_target_uses_aligned_ycbcr_height := true
endif

ifeq ($(TARGET_USES_ALIGNED_YCRCB_HEIGHT),true)
    SOONG_CONFIG_qtidisplay_target_uses_aligned_ycrcb_height := true
endif

ifeq ($(TARGET_USES_UNALIGNED_NV21_ZSL),true)
    SOONG_CONFIG_qtidisplay_target_uses_unaligned_nv21_zsl := true
endif

ifeq ($(TARGET_USES_UNALIGNED_YCRCB),true)
    SOONG_CONFIG_qtidisplay_target_uses_unaligned_ycrcb := true
endif

ifeq ($(TARGET_USES_YCRCB_CAMERA_PREVIEW),true)
    SOONG_CONFIG_qtidisplay_target_uses_ycrcb_camera_preview := true
else ifeq ($(TARGET_USES_YCRCB_VENUS_CAMERA_PREVIEW),true)
    SOONG_CONFIG_qtidisplay_target_uses_ycrcb_venus_camera_preview := true
endif

# SEPolicy
ifneq ($(TARGET_EXCLUDE_QCOM_SEPOLICY),true)
ifneq ($(call is-board-platform-in-list, msm8937 msm8953 msm8998 sdm660),true)
include device/qcom/sepolicy_vndr/SEPolicy.mk
else # if (8937 || 8953 || 8998 || 660)
include device/qcom/sepolicy/SEPolicy.mk
endif # !(8937 || 8953 || 8998 || 660)
include device/qcom/common/sepolicy/SEPolicy.mk
endif # Exclude QCOM SEPolicy
