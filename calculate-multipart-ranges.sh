#!/bin/bash

if [ "$1" == "" ]
then
        echo "Specify root file name (without wildcard) of of the multi part upload."
        echo "Optionally specify vault name and upload id as the second and third argument, respectivel"
        echo "To see verbose output use -v or --verbose"
        echo "To execute use --exec flag"
        exit 0
fi

VAULT=$2
UPLOAD=$3

if [[ "$*" =~ .*\-\-verbose.* ]] || [[ "$*" =~ .*\ \-v\ ?.* ]]
then
    VERBOSE="y"
fi

if [[ "$*" =~ .*\-\-exec* ]]
then
        if [ "$VAULT" = "" ] || [ "$UPLOAD" = "" ]; then
                echo "Warning: specify vault name and upload id as the second and third argument to execute"
        else
               EXECUTE="y"
       fi 
fi

#FILES=`ls $1*`
RANGE_END=-1
for f in $1*
do
        FILE_SIZE=`wc -c $f | awk '{print $1}' `
        RANGE_START=$((RANGE_END+1))
        RANGE_END=$((RANGE_START+FILE_SIZE-1))
        RANGE=" --range \"bytes $RANGE_START-$RANGE_END/*\" "

        if [ "$VERBOSE" = "y" ]; then 
                echo "$f size: $FILE_SIZE"
                echo "$RANGE"
        fi

        CMD="aws glacier upload-multipart-part --account-id - --vault-name $VAULT --body $f $RANGE --upload-id $UPLOAD"
        echo "$CMD"

        if [ "$EXECUTE" = "y" ]; then
                #echo "Executing with upload-id ${UPLOAD} to vault ${VAULT}"
                eval $CMD

                echo "Done..."
        fi
done

