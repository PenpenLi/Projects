local lfs = require"lfs"
function attrdir (path)
	test=""
    for line in lfs.dir(path) do
        if line ~= "." and line ~= ".." then
			local file=Readtxt(path.."\\"..line)
			txtlist={"res_id"}
			--txtlist={"back_legionCross.png","back_mainhy.png","back_zrbt.png","back_zrhy.png","bg_login.png","bg_pick3.png","bg_wanfa.png","bg_zhanchong.png","guoguanzhanjiang.png","juezhanhulaoguan.png","juntuan_qunyinzhan.png","panjun.png","zhuangbeifenjie_bg1.png"}
			if strfind(file,txtlist) then
				test=test..line..'\n'
			end
        end
    end
	if test~="" then
		writefile(test)
	end
end

function writefile(test)
	file=io.open("2_LM.txt","w")
	file:write(test)
	file:close()
end

function Readtxt(txt)
	local file=io.open(txt,"r")
	local data=file:read("*a")
	file:close()
	return data
end

function strfind(file,txtlist)
	list=0
	--print(table.getn(txtlist))
	for i=1,table.getn(txtlist) do
		if string.find(file,txtlist[i])~=nil then
			list=list+1
		end
	end

	if list>0 then
		return true
	else
		return false
	end

end


attrdir("client")

