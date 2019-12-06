#!/bin/bash

mkdir $output/5_dir
i=1
echo '#!/bin/bash' >> /root/script/3_httprobe/exe.sh

num=1
rm -r /root/script/5_dir/dirsearch
cd /root/script/5_dir
git clone https://github.com/maurosoria/dirsearch
echo "home/template/wxserver.asmx" >> /root/script/5_dir/dirsearch/db/dicc.txt
for line in `cat $var`

do
cd /root/script/5_dir/dirsearch
echo "python3 dirsearch.py  -u http://$line -e * -w dict_mode_dict.txt -t 50 --plain-text-report=$output/5_dir/$line.txt" > time.sh ; timeout 1666 bash time.sh ; rm time.sh
grep -oP  "http.*" $output/5_dir/$line.txt | sed "/CHANGELOG.md/d" > $output/5_dir/$line1.txt ; mv $output/5_dir/$line1.txt $output/5_dir/$line.txt
vl -t 15 -s 50 $output/5_dir/$line.txt | grep -v "\[50" | grep -oP "http.*" > $output/5_dir/$line1.txt ; mv $output/5_dir/$line1.txt $output/5_dir/$line.txt ; sort -u $output/5_dir/$line.txt -o $output/5_dir/$line.txt
vl=`ps -a | grep vl | awk '{print $1}'`
for line in $vl
do
kill -9 $line
done
done

cd $output ; cat $output/5_dir/*.txt >> $output/5_dir_all.txt ; rm -rf $output/5_dir
grep -oP  "http.*" $output/5_dir_all.txt > $output/5_dir_all1.txt ; rm $output/5_dir_all.txt
vl -t 15 -s 50 $output/5_dir_all1.txt | grep -v "\[50" | grep -v "\[404" | grep -oP "http.*" >> $output/5_dir_all.txt ; rm $output/5_dir_all1.txt
vl=`ps -a | grep vl | awk '{print $1}'`
for line in $vl
do
kill -9 $line
done
sort -u $output/5_dir_all.txt -o $output/5_dir_all.txt

#Eyewitness
cd /root/script/4_getjs
rm -r EyeWitness
cd /root/script/4_getjs
git clone https://github.com/FortyNorthSecurity/EyeWitness
cd EyeWitness/setup ; bash setup.sh ; bash setup.sh ; pip3 install --upgrade pyasn1-modules
mkdir $output/dir
mkdir /root/z_juice/2_dir
cd /root/script/4_getjs/EyeWitness
python3 EyeWitness.py -f $output/5_dir_all.txt --timeout 16 --web --no-prompt -d $output/dir
cp $output/dir/screens/* /root/z_juice/2_dir

cd $output/dir
grep=`ls | grep report`
if [ "$grep" = "" ]
then
cd $output
rm -r $output/dir
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
if [ "$aws" = "3" ]
then
rm $output/2_AWS.txt
fi

cd /root/script/5_dir/dirsearch
