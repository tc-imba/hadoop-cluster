#!/bin/bash

export WORKER_NUMBER=3

master/start.sh
WORKER_ID=1 worker/start.sh
WORKER_ID=2 worker/start.sh
WORKER_ID=3 worker/start.sh
master/start_hadoop.sh
docker exec -it hadoop-master /bin/bash
