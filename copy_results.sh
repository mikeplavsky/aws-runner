#!/bin/bash

identity=~/.ssh/webserver.pem

scp -v -i $identity ubuntu@$1:~/python.duplication.html /home/ubuntu/$2.python.duplication.html
scp -v -i $identity ubuntu@$1:~/js.duplication.html /home/ubuntu/$2.js.duplication.html
