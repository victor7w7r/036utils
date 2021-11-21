#!/bin/bash

START=$(date +%s)

chars="/-\|"

while [[ $(($(date +%s) - $START)) -lt 1 ]]; do
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.08
    echo -en "${chars:$i:1}" "\r"
  done
done
