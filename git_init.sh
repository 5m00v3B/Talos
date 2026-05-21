#!/bin/bash

echo "kubectl" > .gitignore
git init
git add .
git commit -m `/usr/bin/date +%Y%m%d`
git branch -M main
git remote add origin https://github.com/5m00v3B/Talos.git
git push -u origin main
