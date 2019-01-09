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

excelname="角色主将数据.xlsx".encode('gbk')
excelnameout="角色主将数据_精确到人.xls".encode('gbk')


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
		
		lenth = len(heroCounts[2])
		#print heroCounts[2][1]
		lenth2 =len(heroCounts[2][0])
		for i in range(0,lenth):
			for j in range(0,lenth2-1):
				worksheet2.write(i,j,heroCounts[2][i][j])
			
			x = len(heroCounts[2][i][lenth2-1])
			for m in range(0,x):
				worksheet2.write(i,lenth2-1+m,heroCounts[2][i][lenth2-1][m])
					
			worksheet2.write(i,11,heroCounts[1][heroCounts[0].index(heroCounts[2][i][lenth2-1])])
		
		worksheet2.write(0,0,"pid")
		worksheet2.write(0,1,"等级")
		worksheet2.write(0,2,"付费等级")
		worksheet2.write(0,3,"活跃天数")
		worksheet2.write(0,4,"钻石总量")
		worksheet2.write(0,5,"战力等级")
		worksheet2.write(0,6,"武将1")
		worksheet2.write(0,7,"武将2")
		worksheet2.write(0,8,"武将3")
		worksheet2.write(0,9,"武将4")
		worksheet2.write(0,10,"武将5")
		worksheet2.write(0,11,"同阵容玩家总数")
		workbook2.save(excelnameout)


#整理玩家的阵容情况
def SetPlayerHeros(sheet,row,col):
	setHeros=[]
	hero = []
	counts=[]
	players=[]
	# 获取整行和整列的值（数组）
	cols_player_id = sheet.col_values(0) # 获取第1列的角色id
	cols_player_type = sheet.col_values(1) # 获取第2列的角色付费类型
	cols_hero_id = sheet.col_values(4) # 获取第5列的武将id
	cols_hero_level = sheet.col_values(6) # 获取第7列的武将的等级
	cols_zhanli = sheet.col_values(11) # 获取第12列的玩家战力
	cols_days = sheet.col_values(12) # 获取第13列的玩家活跃天数
	cols_zuanshi = sheet.col_values(13) # 获取第14列的玩家累计充值
	
	for i in range(0,row):
		#rows = sheet.row_values(i)  # 获取第i+1行内容
		if i == 0:
			hero.append(Change_NUM(cols_hero_id[i]))
			players.append(SetPlayers(cols_player_id[i],cols_player_type[i],cols_hero_level[i],cols_days[i],cols_zuanshi[i],cols_zhanli[i],hero))
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
						counts[setHeros.index(hero)] += 1

				hero = []
				hero.append(Change_NUM(cols_hero_id[i]))
				players.append(SetPlayers(cols_player_id[i],cols_player_type[i],cols_hero_level[i],cols_days[i],cols_zuanshi[i],cols_zhanli[i],hero))
			else:
				hero.append(Change_NUM(cols_hero_id[i]))
				if i == row-1:
					hero = OrderList(hero)
					if CheckHeros(hero,setHeros):
						setHeros.append(hero)
						counts.append(1)
					else:
						counts[setHeros.index(hero)] += 1
	
	return setHeros,counts,players

	
#设置玩家的数据
def SetPlayers(player_id,player_type,hero_level,days,zuanshi,zhanli,hero_list):
	list=[]
	list.append(Change_NUM(player_id))
	list.append(Change_NUM(player_type))
	list.append(Change_NUM(hero_level))
	list.append(Change_NUM(days))
	list.append(Change_NUM(zuanshi))
	list.append(Change_NUM(zhanli))
	list.append(hero_list)
	
	return list
	
	
	
	
	

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
		
#主程序
if __name__ == '__main__':
	CountHeros()
	#print [[1,2,3],[4,5,6]].index([1,2,3])
