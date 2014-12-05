#!/bin/sh

# Set variable
URL="https://s3-ap-northeast-1.amazonaws.com/aucfan-tuningathon/dataset/"
PREFIX="result.day"
EXT_FILE=".log.gz"
FILE_RESULT='result.log'

### Create file result
if [ ! -f $FILE_RESULT ]
then
	touch $FILE_RESULT
else
	> $FILE_RESULT
fi

### Get each file
for i in `seq -w 5 20`
do

	fileNameZip=$PREFIX$i$EXT_FILE
	linkFile=$URL$fileNameZip
			
	### Download file
	if [ ! -f $fileNameZip ]
	then
		wget --no-check-certificate $linkFile
	fi
	
	### Get data user unique by day
	totalUser=$(cut -f3 $fileNameZip | sort -u | wc -l)
	echo "Unique user in day"$i" : "$totalUser >> $FILE_RESULT

done

### Combine fine
combineFile='out.log'
if [ ! -f "$combineFile" ]
then
	zcat $PREFIX*$EXT_FILE > $combineFile
fi

### Count total user
totalUser=$(cut -f3 $combineFile | sort -u | wc -l)
echo "Total unique user in all day : "$totalUser >> $FILE_RESULT


### Get list region
region=$(cut -f2 $combineFile | sort | uniq)
region=(`echo $region | tr " " "\n"`)

### Get unique number by region
for i in "${region[@]}"
do
   count=$(grep "$i" $combineFile | cut -f3 | sort -u | wc -l)
   echo "Total unique user of region "$i" : "$count >> $FILE_RESULT
done