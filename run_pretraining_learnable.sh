#!/usr/bin/env bash
BERT_BASE_DIR=./bert_base_dir/chinese_L-12_H-768_A-12
CURRENT_TIME=$(date "+%Y%m%d-%H%M%S")
INPUT_DIR=gs://clue_pretrain_corpus/tfrecords/bert_base_128/clue_pretrain128_*.tfrecord
OUTPUT_DIR=gs://clue_pretrain_corpus/experiments/bert_base_learnable_c5/$CURRENT_TIME
IP=10.240.1.26
nohup python3 run_pretraining_learnable.py \
  --use_tpu=True  --tpu_name=grpc://${IP}:8470 --tpu_zone=us-central1-a \
  --input_file=$INPUT_DIR \
  --output_dir=$OUTPUT_DIR \
  --do_train=True \
  --do_eval=True \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --train_batch_size=1024 \
  --max_seq_length=128 \
  --max_predictions_per_seq=20 \
  --num_train_steps=125000 \
  --num_warmup_steps=12500 \
  --learning_rate=1e-4  \
  --save_checkpoints_steps=1000 > bert_clue_learnable.out &

