#!/bin/bash

path="/home/ubuntu/clones"

repo=$1
user=$2
parent=$3

echo "Cloning $1"

rm -rf $path 
git clone $1 $path

cd $path/SharePoint\ Information\ Portal/ 
clonedigger .
cp output.html /home/$user/python.duplication.html 

cd $path/SharePoint\ Information\ Portal/Application/templates/static/scripts 
clonedigger -l js .                                                                              
cp output.html /home/$user/javascript.duplication.html 
