#!/usr/bin/env bash

# 移动 tfrecords 文件
for i in `seq 1 900`
do
  echo $i
  gsutil -m cp gs://clue_pretrain_corpus/tfrecords/bert_base_128_c5_vocab8k/clue_pretrain128_$i.tfrecord gs://clue_pretrain_corpus/tfrecords/bert_base_128_c5_vocab8k_3g
done