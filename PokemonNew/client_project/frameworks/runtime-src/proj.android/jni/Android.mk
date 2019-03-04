LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := bugly_native_prebuilt
# 可在Application.mk添加APP_ABI := armeabi armeabi-v7a 指定集成对应架构的.so文件
LOCAL_SRC_FILES := prebuilt/$(TARGET_ARCH_ABI)/libBugly.so

include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_CFLAGS += -x c++

LOCAL_SRC_FILES := \
../../Classes/AppDelegate.cpp \
../../Classes/umeng/analytics/MobClickCpp.cpp \
../../Classes/umeng/analytics/DplusMobClickCpp.cpp \
../../Classes/umeng/Common/UMCCCommon.cpp \
../../Classes/umeng/analytics/lua_binding.cpp \
../../Classes/umeng/push/CCUMPushSDK.cpp \
../../Classes/umeng/push/lua_push_binding.cpp \
crypto/CCCrypto.cpp \
crypto/md5/md5.c \
hellolua/main.cpp \

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../Classes/protobuf-lite \
$(LOCAL_PATH)/../../Classes/runtime \
$(LOCAL_PATH)/../../Classes \
$(LOCAL_PATH)/../../../cocos2d-x/external \

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += protobuf

# _COCOS_LIB_ANDROID_BEGIN
LOCAL_STATIC_LIBRARIES += quick_libs_static
# _COCOS_LIB_ANDROID_END

# 引用 bugly/Android.mk 定义的Module
LOCAL_STATIC_LIBRARIES += bugly_crashreport_cocos_static
# 引用 bugly/lua/Android.mk 定义的Module
LOCAL_STATIC_LIBRARIES += bugly_agent_cocos_static_lua

include $(BUILD_SHARED_LIBRARY)


$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,external/pbc/pbc-master)
$(call import-module,quick_libs/proj.android)
$(call import-module,external/bugly)
$(call import-module,external/bugly/lua)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
