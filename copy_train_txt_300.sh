#!/usr/bin/env bash

# 移动 tfrecords 文件
for i in `seq 1 300`
do
  printf -v j "%03d" $i
  echo $j
  gsutil -m cp gs://clue_pretrain_corpus/raw_txt_corpus/train/clue_pretrain_0000$j.txt ./train_local/
done