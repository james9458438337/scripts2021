ls $1 | while read line; do echo $line && cat $1/$line| wc -l; done
