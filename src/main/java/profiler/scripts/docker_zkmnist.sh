#!/usr/bin/env bash

export APP_TYPE='distributed'
export APP='input-feed'
export FILE_PATH="/opt/data/zkmnist.json"
export MEMORY=512M
export MULTIPLIER=1

for TOTAL_CORES in `seq 1 6`; do
    export CORES=1
    export NUM_EXECUTORS=$((TOTAL_CORES / CORES))
    export NUM_PARTITIONS=$((TOTAL_CORES * MULTIPLIER))

    /opt/spark/bin/spark-submit --master spark://spark-master:7077 \
      --conf spark.driver.memory=$MEMORY \
      --conf spark.driver.maxResultSize=$MEMORY \
      --conf spark.executor.cores=$CORES \
      --total-executor-cores $TOTAL_CORES \
      --conf spark.executor.memory=$MEMORY \
      --class "profiler.InputProfiler" \
      /opt/spark-apps/dizk-1.0-jar-with-dependencies.jar ${APP_TYPE} ${APP} ${FILE_PATH} ${NUM_EXECUTORS} ${CORES} ${MEMORY} ${NUM_PARTITIONS}
done