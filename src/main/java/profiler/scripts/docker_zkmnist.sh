#!/usr/bin/env bash

export APP_TYPE='distributed'
export APP='input-feed'
export FILE_PATH="/opt/data/zkmnist.json"
export MEMORY=1G
export MULTIPLIER=2
  
for TOTAL_CORES in `seq 1 4`; do
    export CORES=1
    export NUM_EXECUTORS=$((TOTAL_CORES / CORES))
    export NUM_PARTITIONS=$((TOTAL_CORES * MULTIPLIER))

    /opt/spark/bin/spark-submit --master spark://spark-master:7077 \
      --conf spark.driver.memory=$MEMORY \
      --conf spark.driver.maxResultSize=$MEMORY \
      --conf spark.executor.cores=$CORES \
      --total-executor-cores $TOTAL_CORES \
      --conf spark.executor.memory=$MEMORY \
      --conf spark.memory.fraction=0.95 \
      --conf spark.memory.storageFraction=0.3 \
      --conf spark.kryoserializer.buffer.max=1g \
      --conf spark.rdd.compress=true \
      --conf spark.rpc.message.maxSize=1024 \
      --conf spark.executor.heartbeatInterval=30s \
      --conf spark.network.timeout=300s\
      --conf spark.speculation=true \
      --conf spark.speculation.interval=5000ms \
      --conf spark.speculation.multiplier=2 \
      --conf spark.local.dir=/opt/spark \
      --conf spark.logConf=true \
      --conf spark.eventLog.dir=/tmp/spark-events \
      --conf spark.eventLog.enabled=true \
      --class "profiler.InputProfiler" \
      /opt/spark-apps/dizk-1.0-jar-with-dependencies.jar ${APP_TYPE} ${APP} ${FILE_PATH} ${NUM_EXECUTORS} ${CORES} ${MEMORY} ${NUM_PARTITIONS}
done