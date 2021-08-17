#!/bin/bash

git add .
updatesComment=$(date +%Y-%m-%d-%H-%M)
git commit -m "updates for $updatesComment"
git push