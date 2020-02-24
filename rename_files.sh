#!/usr/bin/env bash

i=0
for file in `gsutil ls gs://raw_text/pretrain_data_train`
do
 echo $file
 printf -v l "%07d" $i
 echo $l
 gsutil -m mv $file gs://raw_text/pretrain_data_train_continue/clue_corpus_classic_$l.txt
 i=$[i+1]
done