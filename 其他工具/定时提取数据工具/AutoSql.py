# -*- coding: utf-8 -*-
#import pandas as pd
import pandas
import pymysql
import time
import sys
reload(sys)
sys.setdefaultencoding('utf_8_sig')


def ReadMysqlCon():
	#mysql数据库的配置
	con=pymysql.connect(
	host="128.1.131.143",
	database="papa2sm_game",
	user="pengzigeng",
	password="pengzigeng123",
	port=3306,
	charset='utf8'
	)

	#用Python执行的sql语句
	sqlcmd="SELECT server_id,COUNT(DISTINCT player_id)AS renshu FROM log_logout WHERE zhanli_level>45 and log_time>='2019-02-10 0' and log_time<'2019-02-11 0' GROUP BY server_id"

	#用pandas.read_sql的读取mysql的数据
	a=pandas.read_sql(sqlcmd,con)
	#取前5行数据
	#b=a.head()
	#print(a)
	a.to_csv('服务器战力45级以上的玩家.csv'.encode('gbk'),index=False)

	
def	TimeSleepTask(howlong):
	time.sleep(howlong)

if __name__ == '__main__':
	print "任务开始...".encode('gbk')
	TimeSleepTask(10)
	ReadMysqlCon()
	print "任务结束...".encode('gbk')
	