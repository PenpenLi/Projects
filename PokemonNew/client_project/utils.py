#!/usr/bin/env python
# coding=utf-8

import os
import zipfile
import shutil
import hashlib
import platform
import re
import StringIO
import collections
import ConfigParser
import subprocess
import sys
import getopt
import uuid
import json

def getuuid(name):
    return uuid.uuid3(uuid.NAMESPACE_DNS, name)

def getConfig(cfgPath):
    # opts, args = getopt.getopt(sys.argv[1:], "c:")
    # cfgName = "config"
    # for op, value in opts:
    #     if op == "-c":
    #         cfgName = value

    # bname = os.path.basename(cfgName)
    # iniName = os.path.splitext(bname)[0] + ".ini"
    # cfgPath = os.path.join(DIR, iniName)
    cfg = ConfigParser.ConfigParser()
    cfg.read(cfgPath)
    return cfg

def getConfigJson(DIR):
    opts, args = getopt.getopt(sys.argv[1:], "c:")
    cfgName = "config"
    for op, value in opts:
        if op == "-c":
            cfgName = value

    bname = os.path.basename(cfgName)
    iniName = os.path.splitext(bname)[0] + ".json"
    cfg = json.load(open(iniName, 'r'))
    return cfg, cfgName




def getSubDir(ROOT, path):
    if ROOT == path:
        return ""
    return path[len(ROOT) + 1:]

def removeDir(DIR):
    if os.path.exists(DIR):
        shutil.rmtree(DIR)
        
def copyDir(olddir, newdir):
    if os.path.exists(newdir):
        shutil.rmtree(newdir)
    shutil.copytree(olddir,newdir)  
        
def copyDir2(olddir, newdir):
    for olddirpath, olddirnames, oldfilenames in os.walk(olddir):
        for oldfilename in oldfilenames:
            oldfilenameFullPath           = os.path.join(olddirpath,oldfilename)
            newfilenameFullPath           = os.path.join(olddirpath,oldfilename).replace(olddir,newdir)
            newfilenameDirFullPath           = os.path.join(olddirpath,"").replace(olddir,newdir)
            if os.path.exists(newfilenameFullPath):
                os.remove(newfilenameFullPath)
            if not os.path.exists(newfilenameDirFullPath):
                os.makedirs(newfilenameDirFullPath)
            shutil.copyfile(oldfilenameFullPath,newfilenameFullPath)

def cleanDir(DIR, ignores):
    lists = os.walk(DIR)
    for root, dirs, files in lists:
        for f in files:
            path = os.path.join(root, f)
            tmp = getSubDir(DIR, path)
            finded = False
            for v in ignores:
                if tmp.startswith(v):
                    finded = True
                    break
            if finded:
                continue
            os.remove(path)
        for d in dirs:
            path = os.path.join(root, d)
            tmp = getSubDir(DIR, path)
            finded = False
            for v in ignores:
                if tmp.startswith(v):
                    finded = True
                    break
            if finded:
                continue
            shutil.rmtree(path)
def removeFile(full_path):
    if os.path.isfile(full_path):
        os.remove(full_path)

def checkFileByExtention(ext, path):
    filelist = os.listdir(path)
    for fullname in filelist:
        name, extention = os.path.splitext(fullname)
        if extention == ext:
            return name, fullname
    return (None, None)

def removeFileWithExt(work_dir, ext):
    file_list = os.listdir(work_dir)
    for f in file_list:
        full_path = os.path.join(work_dir, f)
        if os.path.isdir(full_path):
            removeFileWithExt(full_path, ext)
        elif os.path.isfile(full_path):
            name, cur_ext = os.path.splitext(f)
            if cur_ext == ext:
                os.remove(full_path)

def mkOutDir(DIR_OUT, CLEANUP_FIRST, ignores=[]):
    if os.path.exists(DIR_OUT):
        if CLEANUP_FIRST:
            cleanDir(DIR_OUT, ignores)
            # shutil.rmtree(DIR_OUT)
            # os.makedirs(DIR_OUT)
    else:
        os.makedirs(DIR_OUT)


def formatName(s):
    l = s.split("_")
    ret = ""
    for v in l:
        ret += v[0].upper() + v[1:].lower()
    return ret


def initUtf8():
    import sys
    reload(sys)
    sys.setdefaultencoding('utf8')


def runMain(main, waitWindows=True):
    initUtf8()
    try:
        main()
    except Exception as e:
        print(e)
        import traceback
        traceback.print_exc()
    finally:
        if waitWindows and platform.system() == "Windows":
            print('Press any key to continue...')
            raw_input()


def runShell(cmd, cwd=None, wait=False):
    p = subprocess.Popen(cmd, shell=True, cwd=cwd)
    if wait:
        p.wait()
        if p.returncode:
            raise subprocess.CalledProcessError(
                returncode=p.returncode,
                cmd=cmd)
        return p.returncode
    return 0


def backUpFile(backUp, filename):
    for v in backUp:
        if v["filename"] == filename:
            return
    f = open(filename, "r")
    lines = f.readlines()
    f.close()
    d = collections.OrderedDict()
    d["filename"] = filename
    d["lines"] = lines
    backUp.append(d)


def modifyFile(backUp, filename, func):
    alreadyIn = False
    for v in backUp:
        if v["filename"] == filename:
            alreadyIn = True
            break
    f = open(filename, "r")
    lines = f.readlines()
    f.close()
    f = open(filename, "w")
    for line in lines:
        func(f, line)
    f.close()
    if not alreadyIn:
        d = collections.OrderedDict()
        d["filename"] = filename
        d["lines"] = lines
        backUp.append(d)


def restoreFile(backUp):
    for v in backUp:
        filename = v["filename"]
        lines = v["lines"]
        f = open(filename, "w")
        for line in lines:
            f.write(line)
        f.close()


def getExecPath():
    import sys
    if hasattr(sys, "frozen"):
        return os.path.realpath(sys.executable)
    else:
        return os.path.realpath(sys.argv[0])
