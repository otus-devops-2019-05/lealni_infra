#!/bin/bash

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
sleep 5
ps aux | grep puma
