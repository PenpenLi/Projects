#!/usr/bin/env python  
#encoding: utf-8 
import Image
import sys
reload(sys)
sys.setdefaultencoding('utf8')

class myimg: 
  def __init__(self, open_file, save_file): 
    self.img = Image.open(open_file) 
    self.save_file = save_file 
	
  def Change_Size(self, percent=100, height=None, width=None): 
    '''
    percent：以百分比来决定大小 
    height， width:以指定的高、宽来决定大小 
    '''
    if not (height and width): 
      width,height = self.img.size   
    new_img = self.img.resize((width*percent/100,height*percent/100),Image.BILINEAR) 
    new_img.save(self.save_file) 
	
  def Rotation(self, angle): 
    '''
    angle： 旋转的度数 
    '''
    rot_img = self.img.rotate(angle) #旋转 
    rot_img.save(self.save_file) 
	
  def Save_as(self, filename): 
    '''
    filename: 另存为图片格式，直接根据后缀名来 
    '''
    self.img.save(filename) 
	
  def Draw_Something(self): 
    ''''' 
        利用ImageDraw来画图形 
    '''
    import ImageDraw 
    draw = ImageDraw.Draw(self.img) 
    width,height = self.img.size 
    draw.line(((0,0),(width-1,height-1)),fill=255) #画直线 
    draw.line(((0,height-1),(width-1,0)),fill=255) 
    draw.arc((0,0,width-1,height-1),0,360,fill=255) #画椭圆 
    self.img.save(self.save_file) 
	
  def Enhance_Something(self): 
    '''
        利用 ImageEnhance来增强图片效果 
    '''
    import ImageEnhance 
    brightness = ImageEnhance.Brightness(self.img) 
    bright_img = brightness.enhance(2.0) ##亮度增强 
    bright_img.save(self.save_file) 
    sharpness = ImageEnhance.Sharpness(self.img) 
    sharp_img = sharpness.enhance(7.0) #锐度增强 
    sharp_img.save(self.save_file) 
    contrast = ImageEnhance.Contrast(self.img) #对比度增强 
    contrast_img = contrast.enhance(2.0)  
    contrast_img.save(self.save_file) 

def read_config(txt):
	config = open(txt,"r")
	error_pic = ""
	for line in open(txt):
		line = config.readline()
		if line != "":
			line_name = line.rstrip('\n')
			if line_name!="":
				pic_name=line_name.split(',')
				try:
					try:
						file_name = pic_name[1]+".png"
						save_file = "0.png"
						saveas_file = pic_name[0]+".png"
						oimg = myimg(file_name, save_file) 
						oimg.Save_as(saveas_file) 
						print pic_name[0]+"  复制完成".encode('gbk')
					except:
						file_name = pic_name[1]+"s.png"
						save_file = "0.png"
						saveas_file = pic_name[0]+".png"
						oimg = myimg(file_name, save_file) 
						oimg.Save_as(saveas_file) 
						print pic_name[0]+"  复制完成".encode('gbk')
				except:
					print pic_name[0]+"  出错！！！！！！".encode('gbk')
					error_pic = error_pic + pic_name[0] + "," + pic_name[1] +"\n"
					Writefile("2_error_pic",error_pic,".txt")
	print "复制完成".encode('gbk')


def Writefile(txtname,test,type):
	txtname = txtname + type
	test = str(test)
	file = open(txtname,"w")
	file.write(test)
	file.close()
	
if __name__ == "__main__": 
  read_config("1_pic.txt")
