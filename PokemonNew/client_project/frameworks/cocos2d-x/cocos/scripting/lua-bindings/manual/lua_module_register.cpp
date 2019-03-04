#include "scripting/lua-bindings/manual/lua_module_register.h"

#include "scripting/lua-bindings/manual/cocosdenshion/lua_cocos2dx_cocosdenshion_manual.h"
#include "scripting/lua-bindings/manual/network/lua_cocos2dx_network_manual.h"
#include "scripting/lua-bindings/manual/cocosbuilder/lua_cocos2dx_cocosbuilder_manual.h"
#include "scripting/lua-bindings/manual/cocostudio/lua_cocos2dx_coco_studio_manual.hpp"
#include "scripting/lua-bindings/manual/extension/lua_cocos2dx_extension_manual.h"
#include "scripting/lua-bindings/manual/ui/lua_cocos2dx_ui_manual.hpp"
#include "scripting/lua-bindings/manual/spine/lua_cocos2dx_spine_manual.hpp"
#include "scripting/lua-bindings/manual/3d/lua_cocos2dx_3d_manual.h"
#include "scripting/lua-bindings/manual/audioengine/lua_cocos2dx_audioengine_manual.h"
#include "scripting/lua-bindings/manual/physics3d/lua_cocos2dx_physics3d_manual.h"
#include "scripting/lua-bindings/manual/navmesh/lua_cocos2dx_navmesh_manual.h"

#include "CCLuaEngine.h"
#include "CCLuaValue.h"


//游戏扩展库
#include "lua/ex/lua_cocos2dx_ex_manual.hpp"
#include "../../pbc/pbc-master/pub-lua.h"
#include "lua/lpeg-0.12/lptree.h"

int lua_module_register(lua_State* L)
{
    // Don't change the module register order unless you know what your are doing
    register_cocosdenshion_module(L);
    register_network_module(L);
    register_cocosbuilder_module(L);
    register_cocostudio_module(L);
    register_ui_moudle(L);
    register_extension_module(L);
    register_spine_module(L);
    register_cocos3d_module(L);
    register_audioengine_module(L);
	
	//for ex extension
	register_ex_module(L);

	//for pbc 在这里注册打包apk的时候无法获取到引用
	/*auto engine = LuaEngine::getInstance();
	lua_State* L2 = engine->getLuaStack()->getLuaState();

	lua_getglobal(L2, "_G");
	if (lua_istable(L2, -1))//stack:...,_G,
	{
		luaopen_protobuf_c(L2);
	}
	lua_pop(L2, 1);*/

	//lpeg
	luaopen_lpeg(L);
#if CC_USE_3D_PHYSICS && CC_ENABLE_BULLET_INTEGRATION
    register_physics3d_module(L);
#endif
#if CC_USE_NAVMESH
    register_navmesh_module(L);
#endif
    return 1;
}