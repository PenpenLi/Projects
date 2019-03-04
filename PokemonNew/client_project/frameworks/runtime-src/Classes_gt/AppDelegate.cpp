#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "audio/include/SimpleAudioEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"

#include "../../pbc/pbc-master/pub-lua.h"

// 导入头文件 CrashReport.h 和 BuglyLuaAgent.h
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "bugly/CrashReport.h"
#include "bugly/lua/BuglyLuaAgent.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "CrashReport.h"
#include "BuglyLuaAgent.h"
#endif



using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
	extern void package_quick_register();
	package_quick_register();
    return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // Init the Bugly
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
        CrashReport::initCrashReport("c68da4a340", false);
    #elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        CrashReport::initCrashReport("2800b8316e", false);
    #endif

    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);

	#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)||(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		BuglyLuaAgent::registerLuaExceptionHandler(engine);
	#endif

	lua_getglobal(L, "_G");
	luaopen_protobuf_c(L);
	lua_pop(L, 1);
    register_all_packages();

    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("#Potian-0907#", strlen("#Potian-0907#"), "potian", strlen("potian"));

    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());

    if (engine->executeScriptFile("src/main.lua"))
    {
        return false;
    }

    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
