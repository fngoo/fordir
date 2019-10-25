#!/bin/bash

mkdir $output/5_dir
i=1
echo '#!/bin/bash' >> /root/script/3_httprobe/exe.sh

num=1
for line in `cat $var`

do
cd /root/script/5_dir/dirsearch ; python3 dirsearch.py  -u http://$line -e * -w dict_mode_dict.txt -t 100 --timeout=6 --max-retries=1 --plain-text-report=$output/5_dir/$line.txt ; sed -e "/0B/d" $output/5_dir/$line.txt >> sed.txt ; mv sed.txt $output/5_dir/$line.txt
done
# ; sed -e "/0B/d" $output/5_dir/$line.txt >> sed.txt ; for dir in `cat sed.txt`; do a=`echo $dir | grep -oP "http.*" | sed "s/.$//"` ; if  [ "$a" = "$line" ]; then sed "/$dir/d" sed.txt > tem.txt ; mv tem.txt $output/5_dir/$line.txt; fi; done
#mkdir /root/script/3_httprobe/dir_$i
#echo '#!/bin/bash' >> /root/script/3_httprobe/dir_$i/${i}.sh
#echo "cp -r /root/script/5_dir/dirsearch/* /root/script/3_httprobe/dir_$i" >> /root/script/3_httprobe/dir_$i/${i}.sh
#echo "cd /root/script/3_httprobe/dir_$i" >> /root/script/3_httprobe/dir_$i/${i}.sh
#echo 'python3 dirsearch.py  -u http://$line -e * -w dict_mode_dict.txt --timeout=6 --max-retries=1 --plain-text-report=$output/5_dir/$line.txt ; sed -e "/0B/d" $output/5_dir/$line.txt >> sed.txt ; for dir in `cat sed.txt`; do a=`echo $dir | grep -oP "http.*" | sed "s/.$//"` ; if  [ "$a" = "$line" ]; then sed "s,$dir,,g" sed.txt > tem.txt ; mv tem.txt $output/5_dir/$line.txt; fi; done' >> /root/script/3_httprobe/dir_$i/${i}.sh
#echo "sed \"s,line,$line,g\" /root/script/3_httprobe/dir_$i/${i}.sh > /root/script/3_httprobe/dir_$i/${i}1.sh ; mv /root/script/3_httprobe/dir_$i/${i}1.sh /root/script/3_httprobe/dir_$i/${i}.sh" >> /root/script/3_httprobe/dir_$i/${i}.sh
#echo "cd /root/script/3_httprobe" >> /root/script/3_httprobe/dir_$i/${i}.sh
#echo "rm -rf /root/script/3_httprobe/dir_$i" >> /root/script/3_httprobe/dir_$i/${i}.sh
#echo "bash /root/script/3_httprobe/dir_$i/${i}.sh" >> /root/script/3_httprobe/exe.sh
#i=$((i+1))

#done
#cat /root/script/3_httprobe/exe.sh | parallel --jobs 0 --delay 0.6 --retries 1 --timeout 600
cd $output ; cat $output/5_dir/*.txt >> $output/5_dir_all.txt ; rm -rf $output/5_dir
#grep -oP  "http.*" $output/5_dir_all.txt > $output/5_dir_all1.txt ; rm $output/5_dir_all.txt
#Eyewitness
mkdir $output/5_dir
cd /root/script/4_getjs/EyeWitness
grep -oP "http.*" $output/5_dir_all.txt >> $output/5_dir_all1.txt
python3 EyeWitness.py -f $output/5_dir_all1.txt --web --no-prompt -d $output/5_dir
rm $output/5_dir_all1.txt

#rm /root/script/3_httprobe/exe.sh
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
