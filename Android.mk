#
# Copyright (C) 2021-2023 The LineageOS Project
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
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
RTL8822CS_PATH    := $(abspath $(call my-dir))/rtl88x2CS
RTL8822CS_CONFIGS := CONFIG_RTL8822CS=m

include $(CLEAR_VARS)

LOCAL_MODULE        := 8822cs
LOCAL_MODULE_SUFFIX := .ko
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := $(TARGET_OUT_VENDOR)/lib/modules

_rtl8822cs_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_rtl8822cs_ko := $(_rtl8822cs_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ

$(_rtl8822cs_ko): $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)
	@mkdir -p $(dir $@)
	@cp -R $(RTL8822CS_PATH)/* $(_rtl8822cs_intermediates)/
	$(PATH_OVERRIDE) $(KERNEL_MAKE_CMD) $(KERNEL_MAKE_FLAGS) -C $(KERNEL_OUT) M=$(abspath $(_rtl8822cs_intermediates)) ARCH=$(TARGET_KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(RTL8822CS_CONFIGS) $(KERNEL_CLANG_TRIPLE) $(KERNEL_CC) modules
	$(TARGET_KERNEL_CLANG_PATH)/bin/llvm-strip --strip-unneeded $@;

include $(BUILD_SYSTEM)/base_rules.mk
endif
