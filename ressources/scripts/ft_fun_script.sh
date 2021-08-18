#!/bin/bash

LINE=($(ls -1 ft_fun))


for file in "${LINE[@]}"
do
        ret=`cat ft_fun/$file | grep "//file" | sed -e 's/\/\/file//g' | sed 's/[^0-9]*//g' | sed 's/^0*//'`
        if [ -n ret ] ; then
                FINAL[$ret]=$file
        fi
done


echo "" > code.txt
for i in ${FINAL[@]}
do
        cat ft_fun/$i >> code.txt
done


grep return code.txt | cut -d "'" -f2 | tr -d '\n'
