#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]
then
        echo "The first argument must be file name and the second argument chunk size (such as 1G that can be used as an input to split. Use optionally --nochunk parameter to just hash."
        exit 0
fi

if [ ! -f "TreeHash.class" ]; then
        javac TreeHash.java
fi

if [ "$?" -ne 0 ]; then echo "Could not compile TreeHash.java.."; exit 1; fi

if [ "$2" != "--nochunk" ]; then
        echo "Chunking..."
        split --bytes=$2 --verbose $1 chunk
else
        echo "Skipping chunking..."
fi

echo "Hashing..."
#java -Xmx2g TreeHash $1 
java TreeHash $1 
