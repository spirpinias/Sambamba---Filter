#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
else
  echo "args:"
  for i in $*; do 
    echo $i 
  done
  echo ""
fi

bamfiles=$(find -L ../data -name "*.bam")
file_count=$(echo $bamfiles | wc -w)

if [ -z "${1}" ]; then
  num_threads=$(get_cpu_count)
else
  if [ "${1}" -gt $(get_cpu_count) ]; then
    echo "Requesting more threads than available. Setting to Max Available."
    num_threads=$(get_cpu_count)
  else
    num_threads="${1}"
  fi
fi

if [ "$2" = "mark" ]; then
  remove=""
else
  remove="-r"
fi

if [ -z "${3}" ]; then
  compress_int=5
else
  compress_int="${3}"
fi

if [ -z "${4}" ]; then
  filter_dups="True"
else
  filter_dups="${4}"
fi

if [ -z "${5}" ]; then
  filter_unaligned="False"
else
  filter_unaligned="${5}"
fi

if [ -z "${6}" ]; then
  filter_multimappers="False"
else
  filter_multimappers="${6}"
fi

if [ -z "${7}" ]; then
  min_read_quality=0
else
  min_read_quality="${7}"
fi

temp_dir="../scratch/tmp"
