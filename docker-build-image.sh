#!/bin/bash
echo -e "\nbuild docker hadoop image\n"
sudo docker build -t zzhou612/hadoop-cluster:latest .
