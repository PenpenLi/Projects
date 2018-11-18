local lfs = require"lfs"
function attrdir (filename)

	local file=io.open(filename,"r")
    for line in file:lines() do
		if line~="" then
			i=string.find(line,",")
			j=string.len(line)
			test_a=string.sub(line,i+1,j)
			test_b=string.sub(line,1,i-1)
			--print(test_a,test_b)
			--（b，a）
			--a：读取数据的源文件     b：转化的目标文件，需要保存的文件
			json_a=readfile(test_a.."_fight.json")
			writefile(test_b.."_fight.json",json_a)
		end
    end
end

function readfile(testname)
	test=""
	file=io.open(testname,"r")
	test=file:read("*a")
	file:close()
	return test
end

function writefile(testname,test)
	file=io.open(testname,"w")
	file:write(test)
	file:close()
end

attrdir("1_config.txt")
