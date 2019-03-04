#coding:utf-8
import time
import xlrd
import datetime
import sys
import os
reload(sys)
#sys.setdefaultencoding('utf_8')  UTF-8 无BOM格式
#UTF-8 带BOM格式
sys.setdefaultencoding('utf_8_sig')

DataConfig="config.txt"
DataConfigPath="pathconfig.txt"

# 读取config.txt中需要打包的excel文件
def Read_config():

	alltime_start = datetime.datetime.now()
	#path=GetFilePath(DataConfigPath)
	
	print "开始生成配置文件：".encode('gbk')
	config = open(DataConfig,"r")
	error_excel = []
	for line in open(DataConfig):
		#line = config.readline().decode('gb2312')
		#line = config.readline().encode('gbk')
		line = ReadConfig(config.readline())
		#print line
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

				#判断列数，最后一列如果为空，防止最后加上,
				for i in range(0,col):
					#print i , sheet.row_values(1)[i]
					if sheet.row_values(1)[i] == "":
						col = i
				#print col
				#words_desc = Change_NUM(sheet.row_values(0),col)
				#words_name = Change_NUM(sheet.row_values(1),col)
				#words_type = Change_NUM(sheet.row_values(2),col)
				
				file = Read_excel(line[0:-1],sheet,row,col)

				#Writefile(line[0:-6],file,"CSV",".csv")
				try:
					Writefile(sheetname.encode('gbk'),file,SetCSVPath(),".csv")
				except:		
					Writefile(sheetname,file,SetCSVPath(),".csv")

				#print file
				endtime = datetime.datetime.now()-starttime
				list = excelname + Autospace(60,len(excelname)) + str(endtime)
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
	#time.sleep(10)

#读取config文本中的内容
def ReadConfig(line):
	try:
		line = line.encode('gbk')
	except:
		line = line.decode('gb2312')
	return line
	
#读取excel中的内容
def Read_excel(excelname,sheet,row,col):
	sheetname = excelname[0:-5]
	test = ""
	
	# 获取整行和整列的值（数组）
	for i in range(0,row):
		rows = sheet.row_values(i)  # 获取第i+1行内容
		#cols = sheet.col_values(3) # 获取第4列内容
		try:
			key = Change_NUM(rows,col)
			test += key

		except:
			print "转换数据失败~！".encode("gbk")
			
	return test


#将Excel中的数值格式转换成不带小数的格式（默认转化出来的数值是带小数的）
def Change_NUM(value,count):

	test=""
	for i in range(count):
		if type(value[i]) == type(1.1):
			if value[i]-int(value[i])==0:
				value[i] = str(int(value[i]))
			else:
				value[i] = str(value[i])
		else:
			if findstr(value[i],","):
				value[i] = '\"' + value[i] + '\"'
		
		if findstr(value[i],"\n"):
			value[i] = value[i].replace("\n","")
		
		if i==count-1:
			test = test + value[i] + "\n"
		else:
			test = test + value[i] + ","
		
		
	return test

	

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

		
#自动设置csv文件的保存路径
def SetCSVPath():
	path=os.getcwd()
	pathlist=path.rsplit("\\")
	lenth = path.find("ExcelConfig")
	path = path[0:lenth]
	DataPath = "Client\Assets\AssetResources\ExternalResource"
	path = path + DataPath + "\\" + pathlist[-1] + "\\CSV"

	return path
	

#根据路径进行存储数据文件
def GetFilePath(filename):
	path=""
	config=open(filename,"r")
	for line in open(filename,"r"):
		line = config.readline()
		print line
		if findstr(line,"csv"):
			path=line.split('=')[1].rstrip('\n').rstrip(' ')

	return path


#存储文本内容到文本文件（文件名，文件内容，保存路径，后缀名）
def Writefile(test_name,test,path,endname):

	'''
	if check_contain_chinese(test_name):
		test_name=str(test_name[test_name.find("_")+1:]).encode('gbk')
	else:
		test_name=str(test_name)
	'''
	if findstr(test_name,"_"):
		test_name=str(test_name[test_name.find("_")+1:]).encode('gbk')
	else:
		test_name=str(test_name)
		
	#当不存在对应的文件夹时，自动创建对应的文件夹
	if not os.path.exists(path):
		os.makedirs(path)

	test_name = path + "\\" + test_name + endname
	test = str(test)
	file = open(test_name,"w")
	file.write(str(test))
	file.close()


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



if __name__ == '__main__':
	Read_config()
	os.remove("config.txt")
	#a=""
	#c="1|1|1|2|a|4"
	#a=splitString(c,"|")
	#a=arrayToStr(a)

	#Writefile("xxxx",a,"s",".json")