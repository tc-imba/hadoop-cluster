#!/bin/bash
mkdir input
echo "Hello Docker" >input/file2.txt
echo "Hello Hadoop" >input/file1.txt

hadoop fs -mkdir -p input
hdfs dfs -put ./input/* input

hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-3.2.0-sources.jar org.apache.hadoop.examples.WordCount input output

echo -e "\ninput file1.txt:"
hdfs dfs -cat input/file1.txt

echo -e "\ninput file2.txt:"
hdfs dfs -cat input/file2.txt

echo -e "\nwordcount output:"
hdfs dfs -cat output/part-r-00000
