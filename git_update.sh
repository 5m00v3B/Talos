#!/bin/bash

/usr/bin/git add .
/usr/bin/git commit -m `/usr/bin/date +%Y%m%d`
#/usr/bin/git push -u origin main
/usr/bin/git push --set-upstream origin main

