from PIL import Image,ImageDraw,ImageFont

if __name__ == '__main__':

	img=Image.new(mode="RGB",size=(400,400),color=(255,255,255))
 
	font=ImageFont.truetype("msyh.ttf",28)
	
	draw=ImageDraw.Draw(img,mode="RGB")
	draw.text([200,200],"python","blue")
	draw.text([300,300],"linux","red",font)
	
	with open("pic.png","wb") as f:
		img.save(f,format="png")
	
	img.show()
