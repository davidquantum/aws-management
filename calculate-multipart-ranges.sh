#!/bin/bash

if [ "$1" == "" ]
then
        echo "Specify root file name (without wildcard) of of the multi part upload."
        exit 0
fi

#FILES=`ls $1*`
RANGE_END=-1

for f in $1*
do
        FILE_SIZE=`wc -c $f | awk '{print $1}' `
        echo "$f size: $FILE_SIZE"
        RANGE_START=$((RANGE_END+1))
        RANGE_END=$((RANGE_START+FILE_SIZE-1))
        RANGE=" --range \"bytes $RANGE_START-$RANGE_END/*\" "
        echo "$RANGE"

        echo ""
        echo "Example command: aws glacier upload-multipart-part --account-id - --vault-name VAULT --body $f $RANGE --upload-id UPLOADID" 

done

