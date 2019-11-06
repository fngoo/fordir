#!/bin/bash

mkdir $output/5_dir
i=1
echo '#!/bin/bash' >> /root/script/3_httprobe/exe.sh

num=1
for line in `cat $var`

do
cd /root/script/5_dir/dirsearch
echo "python3 dirsearch.py  -u http://$line -e * -w dict_mode_dict.txt --timeout=2 --plain-text-report=$output/5_dir/$line.txt" > time.sh ; timeout 360 bash time.sh ; rm time.sh
grep -oP  "http.*" $output/5_dir/$line.txt > $output/5_dir/$line1.txt ; mv $output/5_dir/$line1.txt $output/5_dir/$line.txt
vl -s 50 $output/5_dir/$line.txt | grep -v "\[50" | grep -oP "http.*" > $output/5_dir/$line1.txt ; mv $output/5_dir/$line1.txt $output/5_dir/$line.txt ; sort -u $output/5_dir/$line.txt -o $output/5_dir/$line.txt
done

cd $output/5_dir
a=`ls`
for dir in $a
do
num=`cat $dir | wc -l`
if [ $num -gt 20 ]
then
vl -s 50 $dir | grep -v "\[50" | grep -oP "http.*" > vl.txt ; mv vl.txt $dir
fi
done
cd $output ; cat $output/5_dir/*.txt >> $output/5_dir_all.txt ; rm -rf $output/5_dir
grep -oP  "http.*" $output/5_dir_all.txt > $output/5_dir_all1.txt ; rm $output/5_dir_all.txt
vl -s 50 $output/5_dir_all1.txt | grep -v "\[50" | grep -oP "http.*" >> $output/5_dir_all.txt ; rm $output/5_dir_all1.txt
sort -u $output/5_dir_all.txt -o $output/5_dir_all.txt

#Eyewitness
cd /root/script/4_getjs
rm -r EyeWitness
cd /root/script/4_getjs
git clone https://github.com/FortyNorthSecurity/EyeWitness
cd EyeWitness/setup ; bash setup.sh ; bash setup.sh ; pip3 install --upgrade pyasn1-modules
mkdir $output/5_dir
cd /root/script/4_getjs/EyeWitness
python3 EyeWitness.py -f $output/5_dir_all.txt --web --no-prompt -d $output/5_dir

cd $output/5_dir
grep=`ls | grep report`
if [ "$grep" = "" ]
then
cd $output
rm -r $output/5_dir
fi



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

aws=`cat $output/2_AWS.txt | wc -l`
if [ $aws < 6 ]
then
rm 2_AWS.txt
fi

cd /root/script/5_dir/dirsearch
> /root/screenlog.0
