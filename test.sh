#!/bin/bash

USBS=$(ls /dev/disk/by-id | grep usb)

for DEV in $USBS; do
	PREARRAY[$COUNT]=$(readlink "/dev/disk/by-id/$DEV") 
	COUNT=$(( COUNT + 1 ))
done
COUNT=0
QUANTITY=0
BLOCKCOUNT=0
PARTITIONCOUNT=0
declare -A subarray

#subarray[${},${}]

for ARRAY in "${PREARRAY[@]}"; do
	if [ "$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*sd[[:alpha:]]$/d')" == "" ]; then
		BLOCK[$BLOCKCOUNT]=$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\///') 
		BLOCKSTAT="${BLOCK[$BLOCKCOUNT]}"
		PARTITIONSQUERY=$(ls /dev/ | grep -i "^""$BLOCKSTAT""[[:digit:]]$" )

		subarray[${BLOCKCOUNT},${0}]="${BLOCK[$BLOCKCOUNT]}"

		PARTITIONCOUNT=0

		for PARTITION in "${PARTITIONSQUERY[@]}"; do
			subarray[${BLOCKCOUNT},${PARTITIONCOUNT}]=$PARTITION
			PARTITIONCOUNT=$(( PARTITIONCOUNT + 1 ))
		done

		BLOCKCOUNT=$(( BLOCKCOUNT + 1 ))

	fi
done

echo "${subarray[@]}"

for ((i=0; i<BLOCKCOUNT; i++))
do
    for ((j=0; j<PARTITIONCOUNT; j++))
    do
        echo -ne "${subarray[${1},${j}]}\t"
    done
    echo
done

exit 0

for ARRAY in "${PREARRAY[@]}"; do
	if [ "$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*sd[[:alpha:]]$/d')" == "" ]; then
		BLOCK[$BLOCKCOUNT]=$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\///') 
		#PARTITIONSQUERY=$(ls /dev | grep -i "^""$BLOCK[$BLOCKCOUNT]""[[:digit:]]$" )
		BLOCKCOUNT=$(( BLOCKCOUNT + 1 ))
	fi
done

	ARRAYUSB[$COUNT]=$(echo "$ARRAY" | sed 's/^\.\.\/\.\.\///' | sed '/.*sd[[:alpha:]]$/d') 
		#echo "${ARRAYUSB[$COUNT]}"
		COUNT=$(( COUNT + 1 ))
		QUANTITY=$(( QUANTITY + 1 ))
		BLOCKCOUNT=0
	