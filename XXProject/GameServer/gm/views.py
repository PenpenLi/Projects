from django.shortcuts import render
from django.http import  HttpResponse
import datetime


# Create your views here.
def sayHello(request):
    s = "Hello World~！"
    current_time = datetime.datetime.now()
    html = "<html><head></head><body><h1> %s </h1><p> %s </p></body></html>" % (s,current_time)
    return  HttpResponse(html)


def showStudents(request):
    list = [{'id': 1, 'name': 'Jack','age':18,}, {'id': 2, 'name': 'Rose','age':16,}]
    return render(request,'student.html', {'students': list})