from django.db import models

# Create your models here.

class person_info(models.Model):
    name = models.CharField(max_length=30)


class book_info(models.Model):
    fromuser = models.CharField(max_length=30, default='WYS')
    fromsite = models.CharField(max_length=50)
    bookname = models.CharField(max_length=50)
    #updatetime = models.DateTimeField()
    #lastchapter = models.CharField(max_length=100)

class site_info(models.Model):
    sitename = models.CharField(max_length=50)
    bookname = models.CharField(max_length=50)
    url = models.CharField(max_length=200)
    updatetime = models.DateTimeField()
    lastchapter = models.CharField(max_length=100)