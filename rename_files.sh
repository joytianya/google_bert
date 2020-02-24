#!/usr/bin/env bash

i=0
for file in `gsutil ls gs://raw_text/pretrain_data_train`
do
 echo "file is" $file
 printf -v l "%07d" $i
 #echo $l
 remainder=$(( $i % 100 ))
 echo "remainder is " $remainder
 if [ "$remainder" -eq 0 ]; then
   gsutil -m cp $file gs://raw_text/pretrain_data_test_continue
 else
   gsutil -m cp $file gs://raw_text/pretrain_data_train_continue/clue_corpus_classic_$l.txt
 fi
 i=$[i+1]
done