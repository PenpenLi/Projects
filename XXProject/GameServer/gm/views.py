from django.shortcuts import render
from django.http import  HttpResponse
import datetime


# Create your views here.
def sayHello(request):
    s = "Hello World~！"
    current_time = datetime.datetime.now()
    html = "<html><head></head><body><h1> %s </h1><p> %s </p></body></html>" % (s,current_time)
    return  HttpResponse(html)
