#coding:utf-8
import time
import xlrd
import datetime
import sys
reload(sys)
sys.setdefaultencoding('utf8')

# 读取config.txt中需要打包的excel文件
def Read_config():
	alltime_start = datetime.datetime.now()
	print "开始生成配置文件：".encode('gbk')
	config = open("1_config.txt","r")
	error_excel = []
	for line in open("1_config.txt"):
		line = config.readline()
		if line != "":
			starttime = datetime.datetime.now()
			excelname = line.rstrip('\n')
			try:
				# 打开文件
				workbook = xlrd.open_workbook(excelname)
				# 根据sheet索引或者名称获取sheet内容
				sheet = workbook.sheet_by_index(0) # sheet索引从0开始
				sheetname = excelname.rstrip(".xlsx")
				# sheet的名称，行数，列数
				#print sheet.name,sheet.nrows,sheet.ncols
				row = sheet.nrows
				col = sheet.ncols
				cout_type = sheet.row_values(3)
				words = sheet.row_values(4)
				findtype = str(cout_type)

				if findstr(findtype,"Client") or findstr(findtype,"Both"):
					Cleanfile(sheetname,"","client",".lua")
				if findstr(findtype,"Server") or findstr(findtype,"Both"):
					Cleanfile(sheetname,"","server",".xml")

				if findstr(findtype,"Client") or findstr(findtype,"Both") or findstr(findtype,"Server"):
					title = WriteTitle(sheetname,sheet,col)
					if findstr(findtype,"Client") or findstr(findtype,"Both"):
						Cleanfile(sheetname,title[0],"client",".lua")

					file = Read_excel(excelname,sheet,cout_type,words,row,col)

					kmap = Key_map(sheet,col)
					test_a = local_m(sheetname)
					test_b = Sheetname_getlength(sheetname)
					test_c = Sheetname_haskey(sheetname)
					test_d = Sheetname_indexOf(sheetname)
					test_e = Sheetname_get(sheetname,sheet)
					test_f = Sheetname_set(sheetname,sheet)
					test_g = Sheetname_get_index_data(sheetname,sheet)
					test_h = Sheetname_return(sheetname)
					if findstr(findtype,"Client") or findstr(findtype,"Both"):
						Writefile(sheetname,kmap,"client",".lua")
						Writefile(sheetname,test_a,"client",".lua")
						Writefile(sheetname,test_b,"client",".lua")
						Writefile(sheetname,test_c,"client",".lua")
						Writefile(sheetname,test_d,"client",".lua")
						Writefile(sheetname,test_e,"client",".lua")
						Writefile(sheetname,test_f,"client",".lua")
						Writefile(sheetname,test_g,"client",".lua")
						Writefile(sheetname,test_h,"client",".lua")
				endtime = datetime.datetime.now()-starttime
				list = excelname + Autospace(40,len(excelname)) + str(endtime)
				print list
			except:
				if excelname != "":
					print excelname + "     未找到！".encode('gbk')
					error_excel.append(excelname)

	if str(error_excel)!="[]":
		print "失败的文件分别为：".encode('gbk') + str(error_excel)
		Writefile("2_ErrorExcel",Error_out(error_excel),"",".txt")
	alltime_end = datetime.datetime.now()-alltime_start
	config.close
	print "总耗时：".encode('gbk') + str(alltime_end)
	time.sleep(5)

def Autospace(a,b):
	space=""
	for i in range(a-b):
		space = space + " "
	return space
	
def findstr(a,b):
	a=a.lower()
	b=b.lower()
	if a.find(b)>=0:
		return True
	else:
		return False

def Error_out(list):
	test=""
	for line in list:
		test = test + line + '\n'
	return test
	
def Read_excel(excelname,sheet,cout_type,words,row,col):
	sheetname = excelname[0:-5]
	testtitle = 'local ' + sheetname + ' = {\n    ' + '_data = {\n'
	filelist_s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!-- "
	words_str = sheet.row_values(2)
	for i in range(col):
		wordstype =cout_type[i]
		if wordstype in ["both","Both","server","Server"]:
			filelist_s = filelist_s + words[i] +"=" + words_str[i] + " "
	filelist_s = filelist_s + "-->\n<root>\n"
	typeid = sheet.row_values(0)[0]
	num_typeid = typeid.count(',')
	type_id_list = Index_id_type(num_typeid,typeid,words)
	index_list = "local __index_"  + typeid.replace(",","_")+ " = {" + '\n'
	if findstr(str(cout_type),"Client") or findstr(str(cout_type),"Both"):
		Writefile(sheetname,testtitle,"client",".lua")
	if findstr(str(cout_type),"Server") or findstr(str(cout_type),"Both"):
		Writefile(sheetname,filelist_s,"server",".xml")
	
	index_id_list=""
	# 获取整行和整列的值（数组）
	for i in range(5,row):
		#print "行：".encode('gbk') + str(i+1)
		test_c=""
		test_s=""
		rows = sheet.row_values(i)  # 获取第i+1行内容
		words_type = sheet.row_values(1)
		#cols = sheet.col_values(3) # 获取第4列内容
		key = Change_NUM(cout_type,words,rows,col,words_type)
		key_c = str(''.join(key[0]))
		key_s = str(''.join(key[1]))
		test_c = '    [' + str(i-4) + "] = {" + test_c + key_c +'},\n'
		test_s = ''.join(["    <data " , key_s , "/>\n"])
		index_id_list += Index_id(type_id_list,rows,i-4)
		if findstr(str(cout_type),"Client") or findstr(str(cout_type),"Both"):
			Writefile(sheetname,test_c,"client",".lua")
		if findstr(str(cout_type),"Server") or findstr(str(cout_type),"Both"):
			Writefile(sheetname,test_s,"server",".xml")
		
	if findstr(str(cout_type),"Client") or findstr(str(cout_type),"Both"):
		Writefile(sheetname,'    }\n}\n\n',"client",".lua")
		Writefile(sheetname,index_list,"client",".lua")
		Writefile(sheetname,index_id_list,"client",".lua")
		Writefile(sheetname,'}\n\n',"client",".lua")
	if findstr(str(cout_type),"Server") or findstr(str(cout_type),"Both"):
		Writefile(sheetname,"</root>","server",".xml")


def Change_NUM(cout_type,words,value,num,words_type):
	test_c = []
	test_s = []
	for i in range(num):
		str_type = str(cout_type[i])
		if str_type.lower() in ["both","client","server"]:
			value_c = ""
			value_s = ""
			word_type = str(words_type[i])
			if word_type in ["int","Int",""]:
				value_c = str(int(value[i]))
				value_s = value_c
			elif word_type in ["string","String"]:
				if type(value[i]) == type(1.1) or type(value[i]) == type(1):
					value_c = '\"' + str(int(value[i])) + '\"'
					value_s = str(int(value[i]))
				else:
					value_c = '\"' + value[i] + '\"'
					value_s = value[i]
					
			if str_type in ["Both","both"]:
				test_c.append(value_c + ",")
				test_s.append(words[i] + '=\"' + value_s + '\" ')
			elif str_type in ["Client","client"]:
				test_c.append(value_c + ",")
			elif str_type in ["Server","server"]:
				test_s.append(words[i] + '=\"' + value_s + '\" ')
	return test_c,test_s

def Cleanfile(lua_name,test,path,type):
	if path !="":
		lua_name = path + "\\" + lua_name + type
	else:
		lua_name = lua_name + type
	test = str(test)
	file = open(lua_name,"w")
	file.write(str(test))
	file.close()


def Writefile(lua_name,test,path,type):
	if path !="":
		lua_name = path + "\\" + lua_name + type
	else:
		lua_name = lua_name + type
	test = str(test)
	file = open(lua_name,"a+")
	file.write(str(test))
	file.close()


def WriteTitle(titlename,sheet,col):
	Title =""
	Test_C=""
	Test_S = ""
	Title = "record_"+titlename
	Test_C = "local " + Title + " = {}" + '\n\n'
	Test_S = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!-- "
	for i in range(col):
		Words = sheet.cell(4,i).value
		WordsType = sheet.cell(1,i).value
		Class = sheet.cell(3,i).value
		str_c = sheet.cell(2,i).value
		str_s=""
		sign=""
		
		if Class in ["Both","both","Client","client"]:
			Test_C += Title + "." + Words + " = "
			if WordsType == "string":
				sign = '\"\"' 
			else:
				sign = "0"
			Test_C += sign + " --" + str_c + '\n'
		elif Class in ["Both","both","Server","server"]:
			str_s = Words + "=" + str_c +" "
		Test_S += str_s
		
	Test_C = Test_C + '\n\n'
	Test_S = Test_S + "-->\n"
	return Test_C,Test_S


def Index_id_type(num,test,words):
	numlist=[]
	num_words = len(words)
	if num >=0:
		plist = test.split(',')
		for i in range(num+1):
			for j in range(num_words+1):
				if plist[i] == words[j]:
					numlist.append(j)
					break
	return numlist
	
def Index_id(numlist,row,order):
	test = ""
	num = len(numlist)
	indexid = ""
	blank = ""
	if num > 1:
		for i in range(num):
			if i==num-1:
				if type(row[int(numlist[i])]) == type(1.0):
					indexid = indexid + str(int(row[int(numlist[i])]))
				else:
					indexid = indexid + str(row[int(numlist[i])])
			else:
				if type(row[int(numlist[i])]) == type(1.0):
					indexid = indexid + str(int(row[int(numlist[i])])) + "_"
				else:
					indexid = indexid + str(row[int(numlist[i])]) + "_"
		blank='\"'
	else:
		indexid = str(int(row[numlist[0]]))
	test = '    [' + blank + indexid + blank + '] = ' + str(order) + ',\n'
	return test
	


def Key_map(sheet,col):
	words= sheet.row_values(4)
	words_class = sheet.row_values(3)
	Key_map_list = ""
	x = 0
	test=""
	for i in range(col):
		Key_map = ""
		if words_class[i] in ["Both","both","Client","client"]:
			x = x+1
			Key_map = '    ' + words[i] + " = "+ str(x) + "," +'\n'
		Key_map_list = Key_map_list + Key_map
	test = "local __key_map = {" + '\n' + Key_map_list + "}" + '\n\n'
	return test


def local_m(sheetname):
	test = ""
	test = test + "local m = {" + '\n    ' + "__index = function(t,k)" + '\n        ' + "if k == " + '\"' + "toObject" + '\"' + "then" + '\n'
	test = test + '            ' + "return function()" + '\n' + '                ' + "local o = {}" + '\n        '+'        ' + "for key, v in pairs (__key_map) do" + '\n'
	test = test + '                    '+"o[key] = t._raw[v]" + '\n' + '                ' + "end" + '\n' + '                ' + "return o" + '\n            ' + "end" + '\n        ' + "end" + '\n\n'
	test = test + '        ' + "assert(__key_map[k], " + '\"' + "cannot find " + '\"' + " .. k .. " + '\"' + " in record_" + sheetname + '\"' + ")" + '\n'
	test = test + '        ' + "return t._raw[__key_map[k]]" + '\n    ' + "end" + '\n' + "}" + '\n\n'
	return test

def Sheetname_getlength(sheetname):
	test=""
	test = test + "function " + sheetname + ".getLength()" + '\n    ' + "return #" + sheetname + "._data" + '\n' + "end" + '\n\n'
	return test


def Sheetname_haskey(sheetname):
	test=""
	test = test + "function " + sheetname + ".hasKey(k)" + '\n    ' + "if __key_map[k] == nil then" + '\n        ' + "return false\n    " + "else" + '\n        ' + "return true" + '\n    ' + "end" + '\n' + "end" + '\n\n'
	return test

def Sheetname_indexOf(sheetname):
	test = ""
	test = test + "function " + sheetname + ".indexOf(index)" + '\n    ' + "if index == nil then" + '\n        ' + "return nil" + '\n    ' + "end" + '\n    ' + "return setmetatable({_raw = " + sheetname + "._data[index]}, m)" + '\n' + "end" + '\n\n'
	return test

def Sheetname_get(sheetname,sheet):
	test=""
	typelist = sheet.row_values(0)[0].split(',')
	typeid = sheet.row_values(0)[0]
	num = len(typelist)
	indexid = _type_id(typelist,num)
	test = test + "function " + sheetname + ".get(" + typeid + ')\n    ' + "local k = " + indexid + '\n    ' + "return " + sheetname + ".indexOf(__index_" + typeid.replace(",","_") + '[k])\n' + "end" + '\n\n'
	return test

def Sheetname_set(sheetname,sheet):
	test = ""
	typeid = sheet.row_values(0)[0]
	test = test + "function " + sheetname + ".set(" + typeid +", key, value)" + '\n    ' + "local record = " + sheetname + ".get("+ typeid +")" + '\n    ' + "if record then" + '\n        ' + "local keyIndex = __key_map[key]" + '\n        ' +"if keyIndex then" + '\n            ' + "record._raw[keyIndex] = value" + '\n        ' + "end" + '\n    ' + "end" + '\n' + "end" + '\n\n'
	return test

def Sheetname_get_index_data(sheetname,sheet):
	test = ""
	typeid = sheet.row_values(0)[0]
	test = test + "function " + sheetname + ".get_index_data()" + '\n' + "    return __index_" + typeid.replace(",","_") + '\n' + "end" + '\n\n'
	return test

def _type_id(typelist,num):
	indexid = ""
	for i in range(num):
		if i == num-1:
			indexid = indexid + str(typelist[i])
		else:
			indexid = indexid + str(typelist[i]) + " .. " + "\'_\'" + ".. "
	return indexid

def Sheetname_return(sheetname):
	test=""
	test = test + "return  " + sheetname
	return test



if __name__ == '__main__':
	Read_config()

