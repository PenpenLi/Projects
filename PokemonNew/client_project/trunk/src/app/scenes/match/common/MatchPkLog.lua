local PkLogPop = require("app.scenes.common.PkLog.PkLogPop")

local MatchPkLog=class("MatchPkLog",PkLogPop)

function MatchPkLog:ctor( ... )
	self.PkLogCell = require("app.scenes.match.common.MatchPkLogCell")
	MatchPkLog.super.ctor(self,PkLogPop.TYPE_MATCH)
	self._cellExtendH = 480
end

--缓存排名变化数据
function MatchPkLog:_setRankChangeData( dataList )
	self._RankChangeList = {}

	for i,data in ipairs(dataList) do
		local result = {}
		result["time"] = data.fight_time
		result["name"] = data.name
		result["baseId"] = data.base_id
		result["level"] = data.level
		-- result["changeRank"] = data.change_rank
		-- result["changeScore"] = data.change_score
		--result["rankLv"] = data.rank_lv
		result["reportId"] = data.report_id
		result["userId"] = data.uid
		result["win"] = data.win
		result["cellType"] = ID_PANEL_RANKLIST
		result["power"] = data.power

		table.insert(self._RankChangeList, result)
	end

	table.sort(self._RankChangeList,function( l,r )
		return l.time > r.time
	end)
end

--排名变化协议
function MatchPkLog:_onRankChange(buffData)
	dump(buffData)
	local dataList = buffData.arena_reports or {}
	self:_updateRankChange(dataList)
end

--获取战报协议
function MatchPkLog:_onReportBattel( bufferData )
	G_ModuleDirector:pushModule(nil, function()
        return require("app.scenes.match.sea.MatchBattleScene").new(bufferData.battle_report,true)
    end)
end

return MatchPkLog