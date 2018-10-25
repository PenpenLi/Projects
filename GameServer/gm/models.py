from __future__ import unicode_literals
from django.db import models        #导入models对象

# Create your models here.

class userinfo(models.Model):       #创建类必须继承models.Model，类名将是在数据库里的表名称
    #不设置主键id将自动创建
    anem = models.CharField("用户名",max_length=50)       #设置一个anem名称的字符串字段,最大长度50位，在django后台显示名称为：用户名
    address = models.CharField("地址", max_length=50)
    city = models.CharField('城市', max_length=60)
    country = models.CharField(max_length=50)

    class Meta:
        verbose_name = '用户表'                           #设置表名称在django后台显示的中文名称
        verbose_name_plural = verbose_name

    def __str__(self):                                   #设置在django后台显示字段名称
        return self.anem