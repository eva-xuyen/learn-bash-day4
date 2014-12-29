#!/bin/sh

# Set variable
url="https://s3-ap-northeast-1.amazonaws.com/aucfan-tuningathon/dataset/"
prefix="result.day"
extFile=".log.gz"
combineFile=$(mktemp)

### Download file
for i in `seq -w 1 20`
do
    fileNameZip=$prefix$i$extFile
    linkFile=$url$fileNameZip
    ### Download file
    if [ ! -f $fileNameZip ]
    then
        wget --no-check-certificate $linkFile
    fi
done

### Get data user unique by day
for i in `seq -w 1 20`
do
    totalUser=$(zcat $prefix$i$extFile | cut -f3 | sort -u | wc -l)
    echo "Unique user in day"$i" : "$totalUser
done

############# Get data for region
### Combine fine
zcat ${prefix}*${extFile} > $combineFile
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