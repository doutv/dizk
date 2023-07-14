#!/usr/bin/env bash

export APP_TYPE='distributed'
export APP='input-feed'
export FILE_PATH="/opt/data/zkmnist.json"
export MEMORY=512M

for TOTAL_CORES in `seq 2 2 10`; do
    export CORES=2
    export NUM_EXECUTORS=$((TOTAL_CORES / CORES))
    export NUM_PARTITIONS=${NUM_EXECUTORS}

    /opt/spark/bin/spark-submit --master spark://spark-master:7077 \
      --conf spark.driver.memory=$MEMORY \
      --conf spark.driver.maxResultSize=$MEMORY \
      --conf spark.executor.cores=$CORES \
      --total-executor-cores $TOTAL_CORES \
      --conf spark.executor.memory=$MEMORY \
      --class "profiler.InputProfiler" \
      /opt/spark-apps/dizk-1.0-jar-with-dependencies.jar ${APP_TYPE} ${APP} ${FILE_PATH} ${NUM_EXECUTORS} ${CORES} ${MEMORY} ${NUM_PARTITIONS}
done