LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_CPP_EXTENSION := .mm .cpp .cc
LOCAL_CFLAGS += -x c++

LOCAL_SRC_FILES := \
../../Classes/CrashReport.mm \
../../Classes/AppDelegate.cpp \
../../Classes/ide-support/SimpleConfigParser.cpp \
hellolua/main.cpp

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../Classes/protobuf-lite \
$(LOCAL_PATH)/../../Classes/runtime \
$(LOCAL_PATH)/../../Classes \
$(LOCAL_PATH)/../../../cocos2d-x/external \
$(LOCAL_PATH)/../../../cocos2d-x/tools/simulator/libsimulator/lib

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static
LOCAL_STATIC_LIBRARIES += protobuf

# _COCOS_LIB_ANDROID_BEGIN
LOCAL_STATIC_LIBRARIES += quick_libs_static
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := Bugly
LOCAL_SRC_FILES := prebuilt/$(TARGET_ARCH_ABI)/libBugly.so
include $(PREBUILT_SHARED_LIBRARY)


$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)
$(call import-module,external/pbc/pbc-master)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
$(call import-module,proj.android)
# _COCOS_LIB_IMPORT_ANDROID_END
