#! /usr/bin/env python
#-*- encoding:UTF-8 -*-
'''
Created on Jul 28, 2016
'''
import os, datetime, sys

def handle_backup(basedir, childpath):
	newpath = os.path.join(basedir, childpath)
    	if(not os.path.exists(newpath)):
		print newpath + ' not exists'
        	return
    	if(os.path.isfile(newpath)):
		#print newpath
		modifiedtime = datetime.datetime.fromtimestamp(os.path.getmtime(newpath))
        	rightnow = datetime.datetime.now()
        	duration = (rightnow-modifiedtime).days
		if(duration > 7):#超过一周的删除
			print 'remove '+newpath	
			os.remove(newpath)
    	else:
        	infiles = os.listdir(newpath)
        	for f in infiles:
            		handle_backup(newpath, f)


args = sys.argv
if(len(args) == 1):
	print '''请填写文件夹路径'''
	sys.exit()
BACKUP_FILES_PATH = args[1]

files = os.listdir(BACKUP_FILES_PATH)
for tfile in files:
	handle_backup(BACKUP_FILES_PATH, tfile)
print 'cleaning done'
