#!/usr/bin/env bash

i=0
for file in `gsutil ls gs://raw_text/pretrain_data_test`
do
 echo file
 printf -v l "%07d" $i
 echo $l
 gsutil mv file gs://raw_text/pretrain_data_test_continue/clue_corpus_classic_$l.txt
 i=$[i+1]
done