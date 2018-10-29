#coding:utf-8
import time
import xlrd
import datetime
import sys
import os
reload(sys)
sys.setdefaultencoding('utf-8')

DataConfig="config.txt"
DataConfigPath="pathconfig.txt"

# 读取config.txt中需要打包的excel文件
def Read_config():
	alltime_start = datetime.datetime.now()
	path=GetFilePath(DataConfigPath)
	print "开始生成配置文件：".encode('gbk')
	config = open(DataConfig,"r")
	error_excel = []
	for line in open(DataConfig):
		line = config.readline().decode('gb2312')
		if line != "":
			starttime = datetime.datetime.now()
			excelname = line.rstrip('\n')
			try:
				# 打开文件
				workbook = xlrd.open_workbook(excelname)
				# 根据sheet索引或者名称获取sheet内容
				sheet = workbook.sheet_by_index(0) # sheet索引从0开始
				sheetname = excelname[0:-5]
				# sheet的名称，行数，列数
				#print sheet.name,sheet.nrows,sheet.ncols
				row = sheet.nrows
				col = sheet.ncols
				words_type = sheet.row_values(0)
				cout_type = sheet.row_values(2)
				words = sheet.row_values(3)
				findtype = str(cout_type)
				if findstr(findtype,"Client") or findstr(findtype,"Both") or findstr(findtype,"Server"):
					#title = WriteTitle(sheetname,sheet,col)
					file = Read_excel(line[0:-1],sheet,words_type,cout_type,words,row,col)
					#file_c = file[0]
					file_s = file[1] + "</root>"
					file_j = file[2] + "}"
					
					if findstr(findtype,"Server") or findstr(findtype,"Both"):
						#Writefile(line[0:-6],file_s,"xml",".xml")
						Writefile(line[0:-6],file_j,"json",".json")
			
						#Writefile(line[0:-6],file_s,path[1],".xml")
						Writefile(line[0:-6],file_j,path[2],".json")

				endtime = datetime.datetime.now()-starttime
				list = excelname + Autospace(40,len(excelname)) + str(endtime)
				print list
			except:
				if excelname != "":
					print excelname.encode('gbk') + "     未找到！".encode('gbk')
					error_excel.append(excelname)
	if str(error_excel)!="[]":
		print "失败的文件分别为：".encode('gbk') + str(error_excel)
	alltime_end = datetime.datetime.now()-alltime_start
	config.close
	print "总耗时：".encode('gbk') + str(alltime_end)
	#time.sleep(3)


#读取excel中的内容
def Read_excel(excelname,sheet,words_type,cout_type,words,row,col):
	sheetname = excelname[0:-5]
	testtitle = sheetname + ' = {\n\t' + '_data = {\n'
	filelist_c = ""
	filelist_s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
	filelist_j="{\n"
	index_list = "local __index_id = {" + '\n'
	words_str = sheet.row_values(1)
	filelist_s = filelist_s + "<root>\n"
	
	# 获取整行和整列的值（数组）
	for i in range(4,row):
		test_c=""
		test_s=""
		test_j=""
		rows = sheet.row_values(i)  # 获取第i+1行内容
		#cols = sheet.col_values(3) # 获取第4列内容
		try:
			key = Change_NUM(words_type,cout_type,words,rows,col)
			key_c = key[0]
			key_s = key[1]
			key_j = key[2]

			test_c = '\t[' + str(i-4) + "] = {" + test_c + key_c +'},\n'
			filelist_c += test_c
			test_s = "\t\t<data "+ key_s + "/>\n"
			filelist_s += test_s
			test_j =  '\t' + str(rows[0]) + ":{\n" + key_j +"\t},\n"
			filelist_j += test_j
			index_list = index_list + Index_id(rows[0],i-4)
		except:
			print "转换数据失败~！".encode("gbk")

	index_list = index_list + '}\n\n'
	filelist_c = testtitle + filelist_c + '\t}\n}\n\n' + index_list
	return filelist_c,filelist_s,filelist_j


#将Excel中的数值格式转换成不带小数的格式（默认转化出来的数值是带小数的）
def Change_NUM(words_type,cout_type,words,value,num):
	test_c=""
	test_s=""
	test_j=""
	value_c=""
	for i in range(num):
		str_type = cout_type[i]

		if type(value[i]) == type(1.1):
			value_c = str(int(value[i]))
			value[i] = '\"' + value_c + '\"'
		else:
			if str(words_type[i]) in ["array","Array","array1","Array1","array2","Array2"]:
				if str(value[i]) == "0":
					value_c = 0
				else:
					value_c = str(value[i]).replace(",","],[")
					value_c = value_c.replace("|",",")
					value_c = "[" + value_c + "]"
					if str(words_type[i]) in ["array2","Array2"]:
						value_c = "[" + value_c + "]"
			else:
				value_c = '\"' + value[i] + '\"'
			value[i]= '\"' + value[i] + '\"'

		if str_type in ["Both","both"]:
			test_c=test_c + value[i] + ","
			test_s=test_s + words[i] + '=' + value[i] + ' '
			test_j=test_j + '\t\t\"' + words[i] + '\":' + value_c + ',\n'
		elif str_type in ["Client","client"]:
			test_c=test_c + value[i] + ","
		elif str_type in ["Server","server"]:
			test_s=test_s + words[i] + '=' + value[i] + ' '
			test_j=test_j + '\t\t\"' + words[i] + '\":' + '' + value_c + ',\n'

	return test_c.encode('utf-8'),test_s,test_j

	

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


#根据路径进行存储数据文件
def GetFilePath(filename):
	lua=""
	xml=""
	json=""
	config=open(filename,"r")
	for line in open(filename,"r"):
		line = config.readline()
		if findstr(line,"lua"):
			lua=line.split('=')[1].rstrip('\n').rstrip(' ')
		if findstr(line,"xml"):
			xml=line.split('=')[1].rstrip('\n').rstrip(' ')
		if findstr(line,"json"):
			json=line.split('=')[1].rstrip('\n').rstrip(' ')
	return lua,xml,json
	
#存储文本内容到文本文件
def Writefile(test_name,test,path,endname):
	if check_contain_chinese(test_name):
		test_name=test_name[test_name.find("_")+1:]
	#当不存在对应的文件夹时，自动创建对应的文件夹
	if not os.path.exists(path):
		os.makedirs(path)
	test_name = path + "\\" + test_name + endname
	test = str(test)
	file = open(test_name,"w")
	file.write(str(test))
	file.close()

#存储文本内容的表头
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
			#elif WordsType in ["array","Array"]:
			#	sign = "0"
			else:
				sign = "0"
			Test_C += sign + " --" + str_c + '\n'
		elif Class in ["Both","both","Server","server"]:
			str_s = Words + "=" + str_c +" "
		Test_S += str_s
		
	Test_C = Test_C + '\n\n'
	Test_S = Test_S + "-->\n"
	return Test_C,Test_S

#判断字符串中是否有中文
def check_contain_chinese(check_str):
    for ch in check_str.decode('utf-8'):
        if u'\u4e00' <= ch <= u'\u9fff':
            return True
    return False

#处理array类型的字段格式为数组格式
def splitArray(strdata):
	datas = ""
	dataArray = ""
	strdataLen=0
	print strdata
	if not findstr(strdata,"|"):
		dataArray = strdata
	else:
		if findstr(strdata,","):
			datas = splitString(strdata,",")
			strdataLen = len(datas)
			print 2
		else:
			datas = strdata
			strdataLen = 1
			print 3

		'''
		for i in range(0,strdataLen):
			print i
			print 4
			print datas[i]
			strArrayList=""
			strArray = splitString(datas[i],"|")
			for j in range(0,len(strArray)):
				strArrayList = strArrayList + strArray[j] + ","
				if j == len(strArray)-1:
					strArrayList = strArrayList[0:-1]

			dataArray = dataArray + "[" + strArrayList + "],"
			if i == len(datas)-1:
				dataArray = dataArray [0:-1]
			'''
		dataArray = "[" + dataArray + "]"
	print dataArray
	return dataArray


#使用固定符号拆分字符串成数组
def splitString(strdata,symbol):
	print strdata
	if findstr(strdata,symbol):
		strdata=strdata.split(symbol)
	return strdata


#转换数组（将数组中的数值和字符类型进行区分存储，例如：[1,'a',2]）
def arrayToStr(array):
	arrayLen = len(array)
	for i in range(0,arrayLen):
		try:
			array[i]=int(array[i])
		except:
			pass
	return array


def Index_id(indexid,order):
	test = ""
	test = '\t[' + str(indexid) + "] = " + str(order) + ',\n'
	return test
	


def Key_map(sheet,col):
	words= sheet.row_values(4)
	words_class = sheet.row_values(3)
	Key_map_list = ""
	x=0
	test=""
	for i in range(col):
		Key_map = ""
		if words_class[i] in ["Both","both","Client","client"]:
			x=x+1
			Key_map = '\t' + words[i] + " = "+ str(x) + "," +'\n'
		Key_map_list = Key_map_list + Key_map
	test = "local __key_map = {" + '\n' + Key_map_list + "}" + '\n\n'
	return test


def local_m(sheetname):
	test = ""
	test = test + "local m = {" + '\n\t\t' + "__index = function(t,k)" + '\n\t\t\t' + "if k == " + '\"' + "toObject" + '\"' + "then" + '\n'
	test = test + '\t\t\t' + "return function()" + '\n' + '\t\t\t\t' + "local o = {}" + '\n\t\t'+'\t\t' + "for key, v in pairs (__key_map) do" + '\n'
	test = test + '\t\t\t\t\t'+"o[key] = t._raw[v]" + '\n' + '\t\t\t\t' + "end" + '\n' + '\t\t\t\t' + "return o" + '\n\t\t\t' + "end" + '\n\t\t' + "end" + '\n\n'
	test = test + '\t\t' + "assert(__key_map[k], " + '\"' + "cannot find " + '\"' + ".. k .. " + '\"' + " in record_" + sheetname + '\"' + ")" + '\n'
	test = test + '\t\t' + "return t._raw[__key_map[k]]" + '\n\t\t' + "end" + '\n' + "}" + '\n\n'
	return test

def Sheetname_getlength(sheetname):
	test=""
	test = test + "function " + sheetname + ".getLength()" + '\n\t\t' + "return #" + sheetname + "._data" + '\n' + "end" + '\n'
	return test


def Sheetname_haskey(sheetname):
	test=""
	test = test + "function " + sheetname + ".hasKey(k)" + '\n\t' + "if __key_map[k] == nil then" + '\n\t\t' + "return false" + "  else" + '\n\t' + "return true" + '\n\t' + "end" + '\n' + "end" + '\n\n'
	return test

def Sheetname_indexOf(sheetname):
	test = ""
	test = test + "function " + sheetname + ".indexOf(index)" + '\n\t\t' + "if index == nil then" + '\n\t\t\t' + "return nil" + '\n\t\t' + "end" + '\n' + "return setmetatable({_raw = " + sheetname + "._data[index]}, m)" + '\n' + "end" + '\n\n'
	return test

def Sheetname_get(sheetname):
	test=""
	test = test + "function " + sheetname + ".get(id)" + '\n\t\t' + "return " + sheetname + ".indexOf(__index_id[id])" + '\n' + "end" + '\n\n'
	return test

def Sheetname_set(sheetname):
	test = ""
	test = test + "function " + sheetname + ".set(id, key, value)" + '\n\t\t' + "local record = " + sheetname + ".get(id)" + '\n\t\t' + "if record then" + '\n\t\t\t' + "local keyIndex = __key_map[key]" + '\n\t\t\t' +"if keyIndex then" + '\n\t\t\t\t' + "record._raw[keyIndex] = value" + '\n\t\t\t' + "end" + '\n\t\t' + "end" + '\n' + "end" + '\n\n'
	return test

def Sheetname_get_index_data(sheetname):
	test = ""
	test = test + "function " + sheetname + ".get_index_data()" + '\n' + "    return __index_id" + '\n' + "end" + '\n\n'
	return test



if __name__ == '__main__':
	Read_config()
	os.remove("config.txt")
	#a=""
	#c="1|1|1|2|a|4"
	#a=splitString(c,"|")
	#a=arrayToStr(a)

	#Writefile("xxxx",a,"s",".json")