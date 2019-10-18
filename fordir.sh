#!/bin/bash

mkdir $output/5_dir
i=1
echo '#!/bin/bash' >> /root/script/3_httprobe/exe.sh

num=1
for line in `cat $var`

do

mkdir /root/script/3_httprobe/dir_$i
echo '#!/bin/bash' >> /root/script/3_httprobe/dir_$i/${i}.sh
echo "cd /root/script/3_httprobe/dir_$i" >> /root/script/3_httprobe/dir_$i/${i}.sh
echo "cp -r /root/script/5_dir/dirsearch/* /root/script/3_httprobe/dir_$i" >> /root/script/3_httprobe/dir_$i/${i}.sh
echo 'python3 dirsearch.py  -u http://${line} -e * -w dict_mode_dict.txt --timeout=6 --max-retries=1 --plain-text-report=$output/5_dir/$line.txt ; sed -e "/0B/d" $output/5_dir/$line.txt >> sed.txt ; for dir in `cat sed.txt`; do a=`echo $dir | grep -oP "http.*" | sed "s/.$//"` ; if  [ "$a" = "$line" ]; then sed "s,$dir,,g" sed.txt > tem.txt ; mv tem.txt $output/5_dir/$line.txt; fi; done' >> /root/script/3_httprobe/dir_$i/${i}.sh
echo "cd /root/script/3_httprobe" >> /root/script/3_httprobe/dir_$i/${i}.sh
echo "rm -rf /root/script/3_httprobe/dir_$i" >> /root/script/3_httprobe/dir_$i/${i}.sh
echo "bash /root/script/3_httprobe/dir_$i/${i}.sh" >> /root/script/3_httprobe/exe.sh
i=$((i+1))

done
cat /root/script/3_httprobe/exe.sh | parallel --jobs 0 --delay 0.6 --retries 1 --timeout 600
cat $output/5_dir/*.txt > $output/5_dir_all.txt ; rm $output/5_dir -r
grep -oP  "http.*" $output/5_dir_all.txt > $output/5_dir_all1.txt ; rm $output/5_dir_all.txt
#Eyewitness
mkdir $output/5_dir
cd /root/script/4_getjs/EyeWitness
python3 EyeWitness.py -f $output/5_dir_all1.txt --web --no-prompt -d $output/5_dir
mv $output/5_dir_all1.txt $output/5_dir

rm /root/script/3_httprobe/exe.sh
rm /root/script/3_httprobe/dir_* -r
