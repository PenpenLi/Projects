#coding:utf-8
import time
import xlrd
import datetime
import sys
import re
reload(sys)
sys.setdefaultencoding('utf8')

# 读取config.txt中需要打包的excel文件
def Read_config():
	alltime_start = datetime.datetime.now()
	print "开始生成配置文件：".encode('gbk')
	config = open("xml.txt","r")
	error_excel = []
	for line in open("xml.txt"):
		line = config.readline()
		if line != "":
			starttime = datetime.datetime.now()
			excelname = line.rstrip('\n')
			try:
				# 打开文件
				workbook = xlrd.open_workbook(excelname.decode())
				xml_name = excelname[0:-5]
				sheets = workbook.sheet_names()	
				file = ""
				sheetlist=""
				# 根据sheet索引或者名称获取sheet内容
				for i in range(0,len(sheets)):
					if sheets[i].find("Sheet")<0:
						sheet = workbook.sheet_by_index(i) # sheet索引从0开始
						# sheet的名称，行数，列数
						#print sheet.name,sheet.nrows,sheet.ncols
						words = sheet.row_values(2)
						row = sheet.nrows
						col = sheet.ncols
						file_s = ""
						if sheet and words[0] != "":
							file_s += Read_excel(sheet,words,row,col)
						sheetlist += file_s
				file = file + "<XmlCustomActivityInfo>\n" + sheetlist + "</XmlCustomActivityInfo>"
				Writefile(xml_name,file,"xml",".xml")
				endtime = datetime.datetime.now() - starttime
				list = excelname + Autospace(excelname) + str(endtime)
				print list.decode()
			except:
				if excelname != "":
					print excelname.decode() + Autospace(excelname) + "出现问题！".decode()
					error_excel.append(excelname)

	if str(error_excel)!="[]":
		'''print "失败的文件分别为：".encode('gbk') + str(error_excel)'''
		Writefile("2_ErrorExcel",Error_out(error_excel),"",".txt")
	alltime_end = datetime.datetime.now() - alltime_start
	config.close()
	print "总耗时：".decode() + str(alltime_end)
	time.sleep(3)

def Autospace(s):
	space=""
	a = s.find('_')
	s_c = s[0:a]
	s_e = s[a:len(s)]
	num_e = re.compile(r'[^a-z^A-Z]').sub("|",s_c)
	b = (num_e.count("|"))/3
	for i in range(0,35-(len(s)-b)):
		space += " "
	return space
	
def findstr(a,b):
	lenth_b = a.find(b)+1
	lenth_a = len(a)
	if lenth_b >0:
		return a[lenth_b:lenth_a]
	else:
		return a

def Error_out(list):
	test=""
	for line in list:
		test = test + line + '\n'
	return test
	
def Read_excel(sheet,words,row,col):
	filelist_s = ""
	# 获取整行和整列的值（数组）
	for i in range(3,row):
		#print "行：".encode('gbk') + str(i+1)
		test_s=""
		rows = sheet.row_values(i)  # 获取第i+1行内容
		#cols = sheet.col_values(3) # 获取第4列内容
		key = str(Change_NUM(words,rows,col))
		test_s = ''.join(["    <data " , key , "></data>\n"])
		filelist_s += test_s
	return filelist_s


def Change_NUM(words,value,num):
	test_s = ""
	for i in range(num):
		if words[i]!="":
			value_s = ""
			if type(value[i]) == type(1.1) or type(value[i]) == type(1):
				value_s = str(int(value[i]))
			else:
				value_s = value[i]
			test_s = ''.join([test_s , words[i] , '=\"' , value_s , '\" '])
	return test_s

def Writefile(xml_name,test,path,type):
	if path !="":
		xml_name = path + "\\" + xml_name.decode() + type
	else:
		xml_name = xml_name + type
	test = str(test)
	file = open(xml_name,"w")
	file.write(str(test))
	file.close()


if __name__ == '__main__':
	Read_config()

