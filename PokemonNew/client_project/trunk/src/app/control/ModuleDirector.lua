
-- ModuleDirector

--[==================[
	
	模块导演类

	主要负责模块的层级关系（堆栈）显示，并提供多种加载及卸载的接口

]==================]

local LoadingCloud = require "app.scenes.common.LoadingCloud"
local SchedulerHelper = require "app.common.SchedulerHelper"
local director = cc.Director:getInstance()

local ModuleDirector = class("ModuleDirector")

function ModuleDirector:addSceneRecord()
	local scenesStr = "|"
	for i=1,#self._stack.container do
		if self._stack.container[i] and self._stack.container[i].module and self._stack.container[i].module.__cname then
			scenesStr = scenesStr .. self._stack.container[i].module.__cname .. "|"
		else
			scenesStr = scenesStr .. "unknown|"
		end
	end
	scenesStr = scenesStr .. os.time() .. "|"
	table.insert(self._recordScene,scenesStr)
	if #self._recordScene > 5 then
		table.remove(self._recordScene,1)
	end
end

function ModuleDirector:getSceneRecord()
	local scenesStrs = "#"
	for i=1,#self._recordScene do
		scenesStrs = scenesStrs .. self._recordScene[i] .. "#"
	end
	return scenesStrs
end

function ModuleDirector:ctor()

	-- 资源池，主要是为了在模块过度的时候加载的资源做保存的
	self._loadIdentitys = {}

	self._recordScene = {}--记录场景切换的过程  最多三个

	-- 管理模块用的堆栈，内部有一个实际存储显示节点的容器
	local stack = {
		container = {}
	}
	
	-- 提供一组API对堆栈进行操作。这里其实是简易实现一个堆栈
	
	stack.push = function(module)

		stack.container[#stack.container+1] = module

		local nodeName = "Unknown"
		local moduleNode = module.module
		if moduleNode.name ~= nil then
			nodeName = tostring(moduleNode.name)
		elseif moduleNode.__cname ~= nil then 
			nodeName = tostring(moduleNode.__cname)
		end
		buglyPrint("Push Name: " .. nodeName, 3, "ModuleDirector")

		self:addSceneRecord()

		moduleNode:addNodeEvent("enter",
			function()
				if not module.isLayer then
					-- 如果是场景，则发送场景切换事件，主要是新手引导要知道，其他地方也可以用这个消息
					uf_eventManager:dispatchEvent(G_EVENTMSGID.EVENT_CHANGE_SCENE, nil, false)

					-- local DebugTestLayer = require "app.debug.DebugTestLayer"
					-- moduleNode:addToTopLayer(DebugTestLayer.new())

					-- 清理资源
					--self:_clearCaches()

					-- 清理资源池
					for i=1, #self._loadIdentitys do
				        local identity = self._loadIdentitys[i]
				        G_ResourceManager:cancelLoader(identity)
				    end

				    self._loadIdentitys = {}

				end
			end
		)
		moduleNode:addNodeEvent("cleanup",
			function()
				local contain, index = stack.contain(module)
				if contain and index == stack.nums() then
					-- 栈顶的退出了
					self:popModule()

					--self:_clearCaches()
				end

				self:_clearCaches()
				-- self:_clearCachesDelay(0)--延时会导致把下一个场景的资源给删除了
			end
		)

	end

	stack.clear = function()
		for i=1, #stack.container do
			local tModule = stack.container[i]
			local moduleNode = tModule.module
			moduleNode:release()
		end

		stack.container = {}
		self:addSceneRecord()
	end

	stack.pop = function()
		local result = table.remove(stack.container, #stack.container)
		self:addSceneRecord()
		return result
	end

	stack.contain = function(module)
		for i=1, #stack.container do
			local tModule = stack.container[i]
			if tModule == module then
				return true, i
			end
		end
		return false
	end

	stack.nums = function()
		return #stack.container
	end

	stack.at = function(index)
		return stack.container[index]
	end

	self._stack = stack

	self._moduleFunctionId = nil

end

--是否是当前模块
--@param funcId 功能id，对应function_level_info表中的功能id，可选
function ModuleDirector:_isSameWithCurModule( funcId )
	
	-- if funcId and funcId == self._moduleFunctionId  then
	-- 	local ConfigHelper = require "app.common.ConfigHelper"
	-- 	local funcLevelInfo = ConfigHelper.find("function_level_info", "function_id", funcId)
	-- 	G_Popup.tip("已在"..funcLevelInfo.name.."系统")

	-- 	return true
	-- end

	self._moduleFunctionId  = funcId

	return false

end

--[==================[
	
	添加一个模块（压栈）
	这里的模块必须是从CCNode继承而来
	
	@param funcId 功能id，对应function_level_info表中的功能id，可选，如果传递则添加功能是否开启
	@param createModule 创建模块的函数
	@param isLayer 是否是层，布尔值，层在模块中的显示和场景不同

]==================]

function ModuleDirector:pushModule(funcId, createModule, isLayer)
	isLayer = isLayer or false

	-- 要先检查功能是否开启了
	G_Responder.funcIsOpened(funcId, function()

		if self:_isSameWithCurModule(funcId) then return end

		-- 调用createModule函数创建对象
		local module, name = createModule()

		if not self._stack.contain(module) then

			self._stack.push({isLayer = isLayer, module = module, name = name})
			module:retain()

			if not isLayer then
				director:pushScene(module)
				self:_printSceneName(module)
			else
				G_Popup.newPopup(function()
					return module
				end, true)
			end
		end
	end)
end

--[==================[
	
	添加一个模块（压栈）并且使用过渡动画
	这里的模块必须是从CCNode继承而来
	
	@param funcId 功能id，对应function_level_info表中的功能id，可选，如果传递则判断该功能是否开启
	@param createModule 创建模块的函数
	@param isLayer 是否是层，布尔值，层在模块中的显示和场景不同

]==================]

function ModuleDirector:pushModuleWithAni(funcId, createModule, isLayer)

	isLayer = isLayer or false

	G_Responder.funcIsOpened(funcId, function()

		local loading = LoadingCloud.new()
		-- 云层要被加到通知节点当中
		director:getNotificationNode():addChild(loading)

		loading:showLoading(
			-- showfunc
			function()
				-- 调用createModule函数创建对象
				local module, name = createModule()

				if not self._stack.contain(module) then
					self._stack.push({isLayer = isLayer, module = module, name = name})
					module:retain()

					if not isLayer then
						director:pushScene(module)
						self:_printSceneName(module)
					else
						G_Popup.newPopup(function()
							return module
						end, true)
					end
				end
			end,
			-- finishfunc
			function()
				-- 下一帧移除
				loading:runAction(cc.RemoveSelf:create())
			end
		)
	end)

end

--[==================[
	
	添加一个战斗场景，默认是push
	之所以专门开是因为战斗比较特殊，需要加载的资源比较多，必须在云开始播放的时候就开始加载了
	
	@param funcId 功能id，对应function_level_info表中的功能id，可选，如果传递则判断该功能是否开启
	@param createModule 创建模块的函数

]==================]

function ModuleDirector:pushBattleModuleWithAni(funcId, createModule, mapId)

	G_Responder.funcIsOpened(funcId, function()

		local loading = LoadingCloud.new()
		-- 云层要被加到通知节点当中
		director:getNotificationNode():addChild(loading)

		local loaderIdentity = nil
		-- 先加载地图，这主要指跑图配置，异步加载
		if string.find(mapId, ".json") then
			loaderIdentity = G_ResourceManager:addSpImageAsync({"sp_paotu_tianjie_down"}, 1)
			G_ResourceManager:addAlwayExistLoaderByIdentity(loaderIdentity)
	    end

	    -- 加入到模块管理持有的资源池里
	    if loaderIdentity then
	    	self._loadIdentitys[#self._loadIdentitys + 1] = loaderIdentity
	    end

		loading:showLoading(
			-- showfunc
			function()
				-- 调用createModule函数创建对象
				local module, name = createModule()

				if not self._stack.contain(module) then
					self._stack.push({isLayer = false, module = module, name = name})
					module:retain()

					director:pushScene(module)
					self:_printSceneName(module)
				end
			end,
			-- finishfunc
			function()
				-- 下一帧移除
				loading:runAction(cc.RemoveSelf:create())
			end
		)

	end)

end

--[==================[
	
	替换当前栈顶的模块
	这里的模块必须是从CCNode继承而来
	
	@param funcId 功能id，对应function_level_info表中的功能id，可选，如果传递则添加功能是否开启
	@param createModule 创建模块的函数
	@param isLayer 是否是层，布尔值，层在模块中的显示和场景不同

]==================]

function ModuleDirector:replaceModule(funcId, createModule, isLayer)

	isLayer = isLayer or false

	-- 要先检查功能是否开启了
	G_Responder.funcIsOpened(funcId, function()

		if self:_isSameWithCurModule(funcId) then return end

		-- 调用createModule函数创建对象
		local module, name = createModule()
		print2("module, name:",module.__cname)
		if not self._stack.contain(module) then

			-- 删除之前一个模块
			local oldModule = self._stack.pop()
			
			if oldModule then
				local moduleNode = oldModule.module
				moduleNode:release()
			end

			self._stack.push({isLayer = isLayer, module = module, name = name})
			module:retain()

			if not isLayer then
				director:replaceScene(module)
				self:_printSceneName(module)
			else
				if oldModule then
					moduleNode:removeFromParent()
				end
				G_Popup.newPopup(function()
					return module
				end, true)
			end

		end
	end)
	
end

--[==================[
	
	替换一个模块并且使用过渡动画
	这里的模块必须是从CCNode继承而来
	
	@param funcId 功能id，对应function_level_info表中的功能id，可选，如果传递则判断该功能是否开启
	@param createModule 创建模块的函数
	@param isLayer 是否是层，布尔值，层在模块中的显示和场景不同

]==================]

function ModuleDirector:replaceModuleWithAni(funcId, createModule, isLayer)

	isLayer = isLayer or false

	G_Responder.funcIsOpened(funcId, function()

		if self:_isSameWithCurModule(funcId) then return end

		local loading = LoadingCloud.new()
		-- 云层要被加到通知节点当中
		director:getNotificationNode():addChild(loading)

		loading:showLoading(
			-- showfunc
			function()

				-- 调用createModule函数创建对象
				local module, name = createModule()

				if not self._stack.contain(module) then

					-- 删除之前一个模块
					local oldModule = self._stack.pop()
					
					if oldModule then
						local moduleNode = oldModule.module
						moduleNode:release()
					end

					self._stack.push({isLayer = isLayer, module = module, name = name})
					module:retain()

					if not isLayer then
						director:replaceScene(module)
						self:_printSceneName(module)
					else
						if oldModule then
							moduleNode:removeFromParent()
						end
						G_Popup.newPopup(function()
							return module
						end, true)
					end

				end

			end,
			-- finishfunc
			function()
				-- 下一帧移除
				loading:runAction(cc.RemoveSelf:create())
			end
		)
	end)

end

--[==================[
	
	删除一个模块（出栈）
	
	@param times 出栈几次

]==================]

function ModuleDirector:popModule(times)
	times = times or 1
	local size = self._stack.nums()
	times = math.min(times, size)

	self._moduleFunctionId = nil  --模块变更重置

	local sceneSum = 0

	-- 统计有几个场景
	for i = 1, size do
		local module = self._stack.at(i)
		if not module.isLayer then
			sceneSum = sceneSum + 1
		end
	end

	local popSceneNum = 0

	for i = 1, times do
		local module = self._stack.pop()
		local moduleNode = module.module
		if not module.isLayer then
			popSceneNum = popSceneNum + 1
		else
			if moduleNode:isRunning() and moduleNode:getParent() then
				moduleNode:removeFromParent()
			end
		end
		moduleNode:release()
	end

	if popSceneNum > 0 then
		if sceneSum - popSceneNum <= 0 and buglyReportLuaException then
	        buglyReportLuaException("ModuleDirector:popModule :".."sceneSum - popSceneNum <= 0 " .. self:getRuningScene().__cname .. " times:" .. times .. " stack:" .. self:getSceneRecord())
	    end
		--assert(sceneSum - popSceneNum > 0, "popToSceneStackLevel == 0? level is 0, it will end the director")
		director:popToSceneStackLevel(math.max(sceneSum - popSceneNum,1))
		self:_printSceneName(self:getRuningScene())
	end
end

--[==================[
	
	出栈到栈底

]==================]

function ModuleDirector:popToRootModule()

	if self._stack.nums() > 1 then
		self:popModule(self._stack.nums() - 1)
	end

end

--[==================[
	
	出栈到栈底并替换栈底的场景

]==================]

function ModuleDirector:popToRootAndReplaceModule(...)

	if self._stack.nums() > 1 then
		self:popModule(self._stack.nums() - 1)
	end

	cc.Director:getInstance():getTextureCache():removeAllTextures()

	self:replaceModule(...)

end

--[==================[
	
	获得当前模块的数据
	
	@return 返回当前模块的数据

]==================]

function ModuleDirector:getRunningModule()

	return self._stack.at(self._stack.nums())

end

function ModuleDirector:getRuningScene()
	local curScene = director:getRunningScene()
	return curScene
end

function ModuleDirector:printStackSceneInfo()
	if self._stack == nil then
		return nil
	end

	local leftStackNums = self._stack.nums()

	local sceneNums = 0
	local curScene = nil
	for i = leftStackNums, 1, -1 do
		curScene = self._stack.at(i)
		if not curScene.isLayer then
			sceneNums = sceneNums + 1
		end
	end
end

--[==================[
	
	获得指定层级的模块
	
	@param level 指定的层级，这里是从栈顶开始算1

	@return 返回当前模块的数据

]==================]

function ModuleDirector:getModuleByLevel(level)

	return self._stack.at(self._stack.nums() - (level-1))

end

function ModuleDirector:_printSceneName(module)
	
end

function ModuleDirector:_clearCachesDelay(delay)
	--
	if self._clearScheduler ~= nil then
		SchedulerHelper.cancelSchedule(self._clearScheduler)
		self._clearScheduler = nil
	end

	--
	self._clearScheduler = SchedulerHelper.newSchedule(function ()
		self:_clearCaches()
		SchedulerHelper.cancelSchedule(self._clearScheduler)
		self._clearScheduler = nil
	end, delay)
end
-- 清理资源
function ModuleDirector:_clearCaches()
	-- 清理资源
	--cc.CSLoader:getInstance():removeCacheReaders()
	--sp.SpineCache:getInstance():removeUnusedSpines()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()

    collectgarbage("collect")
end

function ModuleDirector:clear()
	self._stack.clear()
end

return ModuleDirector