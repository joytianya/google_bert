#!/usr/bin/env bash
CURRENT_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
export PYTHONPATH=$CURRENT_DIR/../../:$PYTHONPATH
CURRENT_TIME=$(date "+%Y%m%d-%H%M%S")
CLUE_DATA_DIR=gs://data_zxw/nlp/CLUE
CLUE_PREV_TRAINED_MODEL_DIR=gs://models_zxw/prev_trained_models/nlp/clue-model
CLUE_OUTPUT_DIR=gs://models_zxw/fine_tuning_models/nlp/clue-model

run_task() {
  TASK_NAME=$1
  MODEL_NAME=$2
  DATA_DIR=$CLUE_DATA_DIR/${TASK_NAME}_public
  PREV_TRAINED_MODEL_DIR=$CLUE_PREV_TRAINED_MODEL_DIR/$MODEL_NAME
  MAX_SEQ_LENGTH=$3
  TRAIN_BATCH_SIZE=$4
  LEARNING_RATE=$5
  NUM_TRAIN_EPOCHS=$6
  SAVE_CHECKPOINTS_STEPS=$7
  TPU_IP=$8
  OUTPUT_DIR=$CLUE_OUTPUT_DIR/$MODEL_NAME/$TASK_NAME/$CURRENT_TIME
  COMMON_ARGS="
        --task_name=$TASK_NAME \
        --data_dir=$DATA_DIR \
        --vocab_file=$PREV_TRAINED_MODEL_DIR/vocab.txt \
        --bert_config_file=$PREV_TRAINED_MODEL_DIR/bert_config.json \
        --init_checkpoint=$PREV_TRAINED_MODEL_DIR/bert_model.ckpt \
        --max_seq_length=$MAX_SEQ_LENGTH \
        --train_batch_size=$TRAIN_BATCH_SIZE \
        --learning_rate=$LEARNING_RATE \
        --num_train_epochs=$NUM_TRAIN_EPOCHS \
        --save_checkpoints_steps=$SAVE_CHECKPOINTS_STEPS \
        --output_dir=$OUTPUT_DIR \
        --keep_checkpoint_max=0 \
        --num_tpu_cores=8 --use_tpu=True --tpu_name=grpc://$TPU_IP:8470
  "
  echo "Start running..."
  python3 $CURRENT_DIR/../run_classifier.py \
        $COMMON_ARGS \
        --do_train=true \
        --do_eval=false \
        --do_predict=false 

  echo "Start predict..."
  python3 $CURRENT_DIR/../run_classifier.py \
        $COMMON_ARGS \
        --do_train=false \
        --do_eval=true \
        --do_predict=true 
}
##command##task_name##model_name##max_seq_length##train_batch_size##learning_rate##num_train_epochs##save_checkpoints_steps##tpu_ip
run_task afqmc bert_clue_normal_c5 128 16 2e-5 3 300 10.100.247.82
run_task tnews bert_clue_normal_c5 128 16 2e-5 3 300 10.100.247.82
run_task iflytek bert_clue_normal_c5 128 32 2e-5 3 300 10.100.247.82
run_task cmnli bert_clue_normal_c5 128 64 3e-5 2 300 10.100.247.82

#run_task csl bert_clue_normal_c5 128 16 1e-5 5 100 10.62.58.202
#run_task wsc bert_clue_normal_c5 128 16 1e-5 10 10 10.100.247.82
