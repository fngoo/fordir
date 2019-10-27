#!/bin/bash

mkdir $output/5_dir
i=1
echo '#!/bin/bash' >> /root/script/3_httprobe/exe.sh

num=1
for line in `cat $var`

do
cd /root/script/5_dir/dirsearch ; python3 dirsearch.py  -u http://$line -e * -w dict_mode_dict.txt --timeout=6 --max-retries=1 --plain-text-report=$output/5_dir/$line.txt
grep -oP  "http.*" $output/5_dir/$line.txt > $output/5_dir/$line1.txt ; mv $output/5_dir/$line1.txt $output/5_dir/$line.txt
vl $output/5_dir/$line.txt | grep -v "\[50" | grep -oP "http.*" > $output/5_dir/$line1.txt ; mv $output/5_dir/$line1.txt $output/5_dir/$line.txt ; sort -u $output/5_dir/$line.txt -o $output/5_dir/$line.txt
done

cd $output/5_dir
a=`ls`
for dir in $a
do
num=`wc -l $dir`
if [ $num -gt 20 ]
then
rm $dir
fi
done
cd $output ; cat $output/5_dir/*.txt >> $output/5_dir_all.txt ; rm -rf $output/5_dir
grep -oP  "http.*" $output/5_dir_all.txt > $output/5_dir_all1.txt ; rm $output/5_dir_all.txt
vl $output/5_dir_all1.txt | grep -v "\[50" | grep -oP "http.*" >> $output/5_dir_all.txt ; rm $output/5_dir_all1.txt
sort -u $output/5_dir_all.txt -o $output/5_dir_all.txt

#Eyewitness
mkdir $output/5_dir
cd /root/script/4_getjs/EyeWitness
python3 EyeWitness.py -f $output/5_dir_all.txt --web --no-prompt -d $output/5_dir



rm /root/script/3_httprobe/dir_* -r
date "+%Y-%m-%d_%H:%M:%S" >> /root/date.txt ; echo 'fordir' >> /root/date.txt

cd $output
rm git_hog.txt
for file in `ls | grep txt`
do
line=`cat $file | wc -l`
if [ $line -eq 0 ]
then
rm -rf $file
fi
done
cd /root/script/5_dir/dirsearch
