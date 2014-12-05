#!/bin/sh

# Set variable
url="https://s3-ap-northeast-1.amazonaws.com/aucfan-tuningathon/dataset/"
prefix="result.day"
extFile=".log.gz"
combineFile=$(mktemp)

### Get each file
for i in `seq -w 1 20`
do
    fileNameZip=$prefix$i$extFile
    linkFile=$url$fileNameZip

    ### Download file
    if [ ! -f $fileNameZip ]
    then
        wget --no-check-certificate $linkFile
    fi

    ### Combine fine
    zcat $fileNameZip >> $combineFile

    ### Get data user unique by day
    totalUser=$(zcat $fileNameZip | cut -f3 | sort -u | wc -l)
    echo "Unique user in day"$i" : "$totalUser
done

### Count total user
totalUser=$(cut -f3 $combineFile | sort -u | wc -l)
echo "Total unique user in all day : "$totalUser

### Get list region
region=$(cut -f2 $combineFile | sort -u)
region=(`echo $region | tr " " "\n"`)

### Get unique number by region
for i in "${region[@]}"
do
   count=$(grep "$i" $combineFile | cut -f3 | sort -u | wc -l)
   echo "Total unique user of region "$i" : "$count
done