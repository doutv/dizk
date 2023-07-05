#!/usr/bin/env bash
export SIZE=10
export APP=zksnark-large
export MEMORY=1G
export CORES=1

/opt/spark/bin/spark-submit --master spark://spark-master:7077 \
  --conf spark.driver.memory=$MEMORY \
  --conf spark.driver.maxResultSize=$MEMORY \
  --conf spark.executor.cores=$CORES \
  --conf spark.executor.memory=$MEMORY \
  --conf spark.memory.fraction=0.95 \
  --conf spark.memory.storageFraction=0.3 \
  --conf spark.kryoserializer.buffer.max=1g \
  --conf spark.rdd.compress=true \
  --conf spark.rpc.message.maxSize=1024 \
  --conf spark.executor.heartbeatInterval=30s \
  --conf spark.network.timeout=300s\
  --conf spark.local.dir=/opt/spark \
  --conf spark.logConf=true \
  --conf spark.eventLog.dir=/tmp/spark-events \
  --conf spark.eventLog.enabled=true \
  --class "profiler.Profiler" \
  /opt/spark-apps/dizk-1.0.jar $APP $SIZE
