#!/usr/bin/env bash
echo $1,$2
PWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
j=0
if [ ! -d $PWD/log ];then
  mkdir $PWD/log
fi
if [ ! -d $PWD/tf_records_all ];then
  mkdir $PWD/tf_records_all
fi

for((i=$1;i<=$2;i++));
do
  random_seed=`expr 12345 + $i `
  echo $random_seed
  python3 create_pretraining_data.py --input_file=$PWD/data/news_zh_$i.txt \
    --output_file=$PWD/tf_records_all/tf_news2016zh_$i.tfrecord --vocab_file=$PWD/bert_base_dir/chinese_L-12_H-768_A-12/vocab_sim_7895.txt \
    --do_lower_case=True --max_seq_length=512 --max_predictions_per_seq=51 --masked_lm_prob=0.10  --random_seed=$random_seed >$PWD/log/tfrecord_$i.log 2>&1 &
  j=$[j+1]
  if [ $j -eq 2 ];then
    wait
    j=0
  fi
done
wait
echo "Finish"
