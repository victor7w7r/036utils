for DEV in $(ls -l /dev/disk/by-id); do
	if readlink $DEV/ | grep -q usb; then
		DEV=$(basename $DEV)
		echo "$DEV is a USB device, info:"
		udevinfo --query=all --name $DEV
		if [ -d /sys/block/${DEV}/${DEV}1 ]
		then
			echo "Has partitions " /sys/block/$DEV/$DEV[0-9]*
		else
			echo "Has no partitions"
		fi
		echo
	fi
done