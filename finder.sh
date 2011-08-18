#!/bin/bash

path="/home/ubuntu/clones"
repo=$1

echo "Cloning $1"

rm -rf $path 
git clone $1 $path

cd $path/SharePoint\ Information\ Portal/ 
clonedigger .
cp output.html /home/ubuntu/python.duplication.html 

cd $path/SharePoint\ Information\ Portal/Application/templates/static/scripts 
clonedigger -l js .                                                                              
cp output.html /home/ubuntu/js.duplication.html 
