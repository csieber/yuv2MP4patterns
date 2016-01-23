#!/bin/bash

if [ $# -lt 2 ]; then
	echo Usage: concat file1 file2 ... outputfile
	exit 1
fi

# Will store the ts streams to concat
concat=()

# Check that output file does not exist yet
if [ -f ${@: -1} ]; then
	echo "Output file ${@: -1} already exists!"
	echo "Doing nothing .."
	exit 1
fi

# Iterate through the supplied files
end=$(expr $# - 1)
for ((i=1;i<=$end;i++))
do
	file=${!i}

	# Check if file exists
	if [ ! -f $file ]; then
		echo "File '$file' does not exist!"
		exit 1
	fi

	# Check if file is mp4
	if [[ ! $file == *.mp4 ]]; then
		echo "Only mp4 files were tested! $file is not mp4."
		exit 1	
	fi

	# Create a video stream file from the mp4 file.
	# if the ts does not exist yet.

	ts_file="${file}.ts"

	if [ ! -f "${ts_file}" ]; then
		echo "${ts_file} does not exist yet. Creating it."
		avconv -i ${file} -c copy -bsf:v h264_mp4toannexb -f mpegts -strict experimental -y ${ts_file}
	else
		echo "${ts_file} already exists. Skipping."
	fi

	# Check if ts file exists now
	if [ ! -f "${ts_file}" ]; then
		echo "Error creating ${ts_file} !"
		exit 1
	fi

	concat+=(${ts_file})
done

str=$(IFS=\|; echo "${concat[*]}")

# Concat the video now
avconv -i concat:"$str" -c copy -y ${@: -1}

# Remove ts stream files again
for ts in "${concat[@]}"
do
	echo "Cleaning up $ts"
	rm $ts
done

