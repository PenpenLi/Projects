#coding:utf-8
import os
import re
import glob

def read_config(txt):
	config = open(txt,"r")
	name_oldfile=[]
	name_newfile=[]
	for line in open(txt):
		line = config.readline()
		line_name = line.rstrip('\n')
		if line_name!="":
			file_name=line_name.split(',')
			name_newfile.append(file_name[0])
			name_oldfile.append(file_name[1])
	rename_file(name_oldfile,name_newfile)

def rename_file(name_oldfile,name_newfile):
	#��õ�ǰ·��
	path = os.path.abspath('.')
	error_file=""
	file_name_list=[]
	for infile in glob.glob(os.path.join('*.*')):
		file_name_list.append(infile)
	if len(file_name_list)==0:
		print "δ�ҵ���ظ�ʽ���ļ�~��"
	else:
		for change_name in file_name_list:
			for i in range(0,len(name_oldfile)):
				if name_oldfile[i] in file_name_list:
					if name_oldfile[i] == change_name:
						#print type(name_oldfile[i])
						try:
							os.rename(change_name, name_newfile[i])
							print name_oldfile[i] + Autospace(40,len(name_oldfile[i])) + "�������ɹ�"
						except:
							if error_file.find(name_oldfile[i])==-1:
								print name_oldfile[i] + Autospace(40,len(name_oldfile[i])) + "��������������~��"
								error_file = error_file + name_oldfile[i] + "\n"
				else:
					if error_file.find(name_oldfile[i])==-1:
						print name_oldfile[i] + Autospace(40,len(name_oldfile[i])) + "������~��"
						error_file = error_file + name_oldfile[i] + "\n"
	if error_file!="":
		Writefile("2_�����������ļ�",error_file,".txt")


def Autospace(a,b):
	space=""
	for i in range(a-b):
		space = space + " "
	return space


def Writefile(txtname,test,type):
	txtname = txtname + type
	test = str(test)
	file = open(txtname,"w")
	file.write(test)
	file.close()
	
if __name__ == "__main__":
	read_config("1_rename.txt")
	#��ͣ����
	os.system("pause") 