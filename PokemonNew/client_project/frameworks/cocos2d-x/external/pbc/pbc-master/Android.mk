LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := protobuf

LOCAL_MODULE_FILENAME := libprotobuf

LOCAL_SRC_FILES := \
 src/alloc.c \
src/array.c \
src/bootstrap.c \
src/context.c \
src/decode.c \
src/map.c \
src/pattern.c \
src/proto.c \
src/register.c \
src/rmessage.c \
src/stringpool.c \
src/varint.c \
src/wmessage.c \
binding/lua/pbc-lua.c \


LOCAL_C_INCLUDES+= src\
					$(LOCAL_PATH)/../../lua/luajit/include


include $(BUILD_STATIC_LIBRARY)
