#!/bin/bash
mem(){
stats=""
echo "%   process"
echo "============"

# collect the data
for process in `ps aux  | grep -v "COMMAND\|-bash" |awk '{print $11}' | sort -u`
do
  stats="$stats\n`ps aux | grep -F "$process" | grep -v grep | awk 'BEGIN{total=0};{total += $4};END{print total,$11}'`"
done

# sort data numerically (largest first)
echo -e $stats  | grep -v ^$ | sort -rn | head -20
}

cpu(){
stats=""
echo "%   process"
echo "============"

# collect the data
for process in `ps aux  | grep -v "COMMAND\|-bash" |awk '{print $11}' | sort -u`
do
  stats="$stats\n`ps aux | grep -F "$process" | grep -v grep | awk 'BEGIN{total=0};{total += $3};END{print total,$11}'`"
done

# sort data numerically (largest first)
echo -e $stats  | grep -v ^$ | sort -rn | head -20
}

user(){
stats=""
echo "%   user"
echo "============"

# collect the data
for user in `ps aux | grep -v COMMAND | awk '{print $1}' | sort -u`
do
  stats="$stats\n`ps aux | egrep ^$user | awk 'BEGIN{total=0}; \
    {total += $4};END{print total,$1}'`"
done

# sort data numerically (largest first)
echo -e $stats | grep -v ^$ | sort -rn | head
}

case $1 in
    mem)
        mem
    ;;
esac

case $1 in
    cpu)
        cpu
    ;;
esac

case $1 in
    user)
        user
    ;;
esac
