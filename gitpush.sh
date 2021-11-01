#!/bin/bash
cd project1/script 
git add .
git commit -m "update $(date --iso-8601)"
git push
git status
