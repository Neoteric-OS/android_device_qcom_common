include device/qcom/common/defs.mk

ifeq ($(call is-board-platform-in-list, $(4_9_FAMILY) $(4_14_FAMILY) $(4_19_FAMILY) $(5_4_FAMILY)),true)
    include device/qcom/sepolicy_vndr/legacy-um/SEPolicy.mk
else ifeq ($(call is-board-platform-in-list, $(5_10_FAMILY)), true)
    include device/qcom/sepolicy_vndr/sm8450/SEPolicy.mk
else ifeq ($(call is-board-platform-in-list, $(5_15_FAMILY)), true)
    include device/qcom/sepolicy_vndr/sm8550/SEPolicy.mk
else ifeq ($(call is-board-platform-in-list, $(6_1_FAMILY)), true)
    include device/qcom/sepolicy_vndr/sm8650/SEPolicy.mk
endif
