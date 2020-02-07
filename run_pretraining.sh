BERT_BASE_DIR=./bert_base_dir/chinese_L-12_H-768_A-12
CURRENT_TIME=$(date "+%Y%m%d-%H%M%S")
INPUT_DIR=gs://clue_pretrain_corpus/tfrecords/bert_base_128/clue_pretrain128_*.tfrecord
OUTPUT_DIR=gs://models_zxw/fine_tuning_models/nlp/bert_zh_clue_corpus/len_128/$CURRENT_TIME
IP=10.62.58.202
nohup python3 run_pretraining.py \
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
  --save_checkpoints_steps=1000 > bert_clue.out &

