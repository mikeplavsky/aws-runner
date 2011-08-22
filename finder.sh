#!/bin/bash

path="/home/ubuntu/clones"
repo=$1

echo "Cloning $1"

rm -rf $path 
git clone $1 $path

#python
cd $path/SharePoint\ Information\ Portal/ 
clonedigger .
cp output.html /home/ubuntu/python.duplication.html 

#javascript
cd $path/SharePoint\ Information\ Portal/Application/templates/static/scripts 

#freaks, finally to be moved to vendors
rm -rf ui
rm md5.js
rm json2.js
rm nifty.js
rm swfobject.js

clonedigger -l js .                                                                              
cp output.html /home/ubuntu/js.duplication.html 
