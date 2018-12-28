from wordcloud import WordCloud
import jieba


text="李小璐给王思聪买了微博热搜"

#强调特殊名词
jieba.suggest_freq(('微博'), True)
jieba.suggest_freq(('热搜'), True)
result=jieba.cut(text)
print(",".join(result))


#读取标点符号库
#f=open("utils/stopwords.txt","r")
#stopwords={}.fromkeys(f.read().split("\n"))
#f.close()
#加载用户自定义词典
#jieba.load_userdict("mytext.txt")
segs=jieba.cut(text)
mytext_list=[]
#文本清洗
for seg in segs:
	#if seg not in stopwords and seg!=" " and len(seg)!=1:
	if seg!=" " and len(seg)!=1:
		mytext_list.append(seg.replace(" ",""))
cloud_text=",".join(mytext_list)
print unicode(cloud_text)
wc = WordCloud(
    background_color="white", #背景颜色
    max_words=200, #显示最大词数
    font_path="./font/wb.ttf",  #使用字体
    min_font_size=15,
    max_font_size=50, 
    width=400
    )
	
wc.generate(unicode(cloud_text))
wc.to_file("pic.png")
