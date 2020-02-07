#IP=10.194.53.194
#ps -ef |grep logdir | grep -v grep | awk '{print $2}' |xargs kill
run_tensorboard() {
  IP=$1
  MODEL_DIR=$2
  TPU_NAME=grpc://${IP}:8470
  capture_tpu_profile --tpu=$TPU_NAME --logdir=${MODEL_DIR}
  tensorboard --logdir=${MODEL_DIR} 
}
CLUE_MODEL_DIR=gs://models_zxw/fine_tuning_models/nlp/bert_zh_clue_corpus/len_128/20200207-015324
WIKI_MODEL_DIR=gs://models_zxw/fine_tuning_models/nlp/bert_zh_wiki_corpus/len_128/20200207-021910
run_tensorboard 10.62.58.202 $CLUE_MODEL_DIR &
run_tensorboard 10.6.121.82 $WIKI_MODEL_DIR &
