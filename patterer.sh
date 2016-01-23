#!/bin/bash

if [ $# -lt 3 ]; then
	echo Usage: input_yuv pattern output_mp4 [seconds_offset]
	exit 1
fi

INPUT=$1
PATTERN=$2
OUTPUT=$3
OFFSET='0'

if [[ $# -eq 4 ]]; then
	OFFSET=$4
fi

#
# Do sanity checks
#
if [ ! -f $INPUT ]; then
	echo "Input file $INPUT does not exist!"
	exit 1
fi 

if [ ! -f $PATTERN ]; then
	echo "Pattern file $PATTERN does not exist!"
	exit 1
fi

TYPE=$(file $PATTERN | cut -f2 -d' ')
if [ ! "$TYPE" = "ASCII" ]; then
	echo "File $PATTERN should be an ASCII file ! Quitting.."
	exit 1
fi

# Fix pattern file line ending..
[[ $(tail -c1 $PATTERN) && -f $PATTERN ]] && echo ''>>$PATTERN

if [ -f $OUTPUT ]; then
	echo "Output file $OUTPUT already exists! Quitting.."
	exit 1
fi

if [[ ! $INPUT == *.yuv ]]; then
	echo "Input file format has to be YUV. (Input file: $INPUT)"
	exit 1
fi

if [[ ! $OUTPUT == *.mp4 ]]; then
        echo "Output file format has to be mp4. (Output file: $OUTPUT)"
        exit 1
fi

#
# Set variables
#
YUV_SIZE="640x360"
YUV_FR=24
YUV_PIXFMT="yuv420p"

TARGET_S="640x360"

#
# Read pattern file
#
CNT=0
PARTS=()

while read line
do
	if [[ ${#line} -lt 18 ]]; then
		continue
	fi

	START=`echo $line | awk -F' ' '{print $1}'` 
	
	CALC="${START} ${OFFSET} seconds"
	START=$(date '+%H:%M:%S' --date="${CALC}")
	
	LENGTH=`echo $line | awk -F' ' '{print $2}'`
	QP=`echo $line | awk -F' ' '{print $3}'`

	echo "Start: $START, LENGTH: $LENGTH, QP: $QP"

	avconv -ss $START -pix_fmt $YUV_PIXFMT -s $YUV_SIZE -r $YUV_FR -i $INPUT -vcodec libx264 -qp $QP -t $LENGTH -s $TARGET_S $INPUT.$CNT.mp4 &> log_$INPUT.$CNT.mp4.txt

	PARTS+=("$INPUT.$CNT.mp4")

	CNT=$[$CNT+1]

done < $PATTERN

parts_str=$(IFS=' '; echo "${PARTS[*]}")

./concat.sh $parts_str $OUTPUT

for part in "${PARTS[@]}"; do
	rm $part
done

