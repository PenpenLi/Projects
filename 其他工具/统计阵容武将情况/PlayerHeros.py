#coding:utf-8
import time
import xlrd
import xlwt
import datetime
import sys
import os
reload(sys)
#sys.setdefaultencoding('utf_8')  UTF-8 无BOM格式
#UTF-8 带BOM格式
sys.setdefaultencoding('utf_8_sig')

excelname="角色主将数据1.xlsx".encode('gbk')
excelnameout="角色主将数据1.xls".encode('gbk')


# 读取config.txt中需要打包的excel文件
def CountHeros():

	#alltime_start = datetime.datetime.now()

	#try:
		# 打开文件
		workbook = xlrd.open_workbook(excelname)
		# 根据sheet索引或者名称获取sheet内容
		sheet = workbook.sheet_by_index(0) # sheet索引从0开始
		#sheetname = excelname[0:-5]
		# sheet的名称，行数，列数
		#print sheet.name,sheet.nrows,sheet.ncols
		#print sheetname
		row = sheet.nrows
		col = sheet.ncols
		
		heroCounts=SetPlayerHeros(sheet,row,col)
		
		#创建workbook
		workbook2 = xlwt.Workbook(encoding = 'utf-8', style_compression=0)
		#创建表
		worksheet2 = workbook2.add_sheet('Sheet1', cell_overwrite_ok=True)
		#worksheet2.write(0, 0, label = 'Row 0, Column 0 Value')
		
		lenth = len(heroCounts[0])
		for i in range(0,lenth):
			#print heroCounts[0][i]
			lenth2 =len(heroCounts[0][i])
			for j in range(0,lenth2):
				worksheet2.write(i,j,heroCounts[0][i][j])
			worksheet2.write(i,5,heroCounts[1][i])
		
		workbook2.save(excelnameout)


#整理玩家的阵容情况
def SetPlayerHeros(sheet,row,col):
	setHeros=[]
	hero = []
	counts=[]
	# 获取整行和整列的值（数组）
	cols_player_id = sheet.col_values(0) # 获取第1列的角色id
	cols_hero_id = sheet.col_values(4) # 获取第5列的武将id
	
	for i in range(0,row):
		#rows = sheet.row_values(i)  # 获取第i+1行内容
		if i == 0:
			hero.append(Change_NUM(cols_hero_id[i]))
			#print Change_NUM(cols_hero_id[i])
		else:
			if cols_player_id[i]!=cols_player_id[i-1]:
				hero = OrderList(hero)
				if len(setHeros) == 0:
					setHeros.append(hero)
					counts.append(1)
				else:
					if CheckHeros(hero,setHeros):
						setHeros.append(hero)
						counts.append(1)
					else:
						#print hero
						#print setHeros.index(hero)
						counts[setHeros.index(hero)] += 1
				hero = []
				hero.append(Change_NUM(cols_hero_id[i]))
			else:
				hero.append(Change_NUM(cols_hero_id[i]))
				if i == row-1:
					hero = OrderList(hero)
					if CheckHeros(hero,setHeros):
						setHeros.append(hero)
						counts.append(1)
					else:
						counts[setHeros.index(hero)] += 1
		#print i,hero
	#print len(setHeros)
	#print len(counts)
	#print setHeros,counts
	return setHeros,counts
	
#冒泡法对数组进行排序
def OrderList(nums):
	lenth=len(nums)
	for i in range(0,lenth-1):
		for j in range(0,lenth-i-1):
			if nums[j] > nums[j+1]:
				nums[j], nums[j+1] = nums[j+1], nums[j]
	return nums
		
	
	
#将Excel中的数值格式转换成不带小数的格式（默认转化出来的数值是带小数的）
def Change_NUM(value):

	if type(value) == type(1.1):
		if value-int(value)==0:
			value = int(value)
		else:
			value = int(value)
	return value
	
	
#检查组合是否已经存在
def CheckHeros(heros,playe_heros):
	if heros not in playe_heros:
		return True
	else:
		return False
			
			
			
			
			
			
	
if __name__ == '__main__':
	CountHeros()
	#print [[1,2,3],[4,5,6]].index([1,2,3])
