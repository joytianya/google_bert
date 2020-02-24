#!/usr/bin/env bash

i=0
for file in `gsutil ls gs://raw_text/pretrain_data_test`
do
 gsutil mv file gs://raw_text/pretrain_data_test_continue_$i
 i=$[i+1]
done