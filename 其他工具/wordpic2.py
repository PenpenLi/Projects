#导入词云的包
from wordcloud import WordCloud
#导入matplotlib作图的包
import matplotlib.pyplot as plt
import jieba
import sys
reload(sys)
sys.setdefaultencoding('utf8')



#f="李小璐给王思聪买了微博热搜"
#print f
#f=f.encode('utf8')
#print f

#读取文件,返回一个字符串，使用utf-8编码方式读取，该文档位于此python同以及目录下
f = open('myyuntext.txt','r')
text=""
for line in f:
	text=text+line

segs=jieba.cut(text)
#print unicode(segs)
mytext_list=[]

#文本清洗
for seg in segs:
	#if seg not in stopwords and seg!=" " and len(seg)!=1:
	print seg.encode('utf8')
	if seg!=" " and len(seg)>=3:
		mytext_list.append(seg.replace(" ",""))
cloud_text=",".join(mytext_list)


#生成一个词云对象
wordcloud = WordCloud(
        background_color="white", #设置背景为白色，默认为黑色
        width=1500,              #设置图片的宽度
        height=960,              #设置图片的高度
        margin=10               #设置图片的边缘
        )
wordcloud = wordcloud.generate(text)
# 绘制图片
plt.imshow(wordcloud)
# 消除坐标轴
plt.axis("off")
# 展示图片
plt.show()
# 保存图片
wordcloud.to_file('my_test2.png')
