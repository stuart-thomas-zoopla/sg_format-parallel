#!/bin/bash

read -p "Enter space-separated list of drives to format (eg. sda sdb sdc): " drive_list

run_sg_format() {
    device=$1
    logfile=$2

    echo "Formatting $device..."
    sg_format --format --size=512 "$device" -v > "$logfile" 2>&1
    echo "Formatting of $device completed."
}

logfiles=""

for drive in $drive_list; do
    logfile="progress_$drive.log"
    run_sg_format "/dev/$drive" "$logfile" &
    logfiles+=" $logfile"
done

wait

echo "Showing live update of log files. Press Ctrl+C to exit."
tail -f $logfiles