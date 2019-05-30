#!/bin/bash
echo -e "\nbuild docker hadoop image\n"
docker build -t tcimba/hadoop-cluster:latest .
