#!/bin/bash

# * * * * * <script to run>
 # replace * with parameters so they can be filled
 # then script to  run should be provided
 # provide user to run as for system-wide scripts
    # where to save the script incase its system-wide or just adding a user makes it that?
 # fault parameters

cron_generate (){
local minute_hour
read -p "Enter minute_hour: " minute_hour

local day
read -p "Enter day: " day

local dom
read -p "Enter dom: " dom

local month
read -p "Enter month: " month

local dow
read -p "Enter day of the week: " dow

local user
read -p "Enter user: " user

local keyword
read -p "Enter keyword:" keyword

local systemwide
read -p "Is this a system-wide cronjob? (y/n): " systemwide


local logfile 
logfile="/home/perch/Documents/auth.log" 
output="/home/perch/Documents/authtest3.txt"


if [ -z "$minute_hour" ]; then
    minute_hour="*"
fi

if [ -z "$day" ]; then
    day="*"
fi

if [ -z "$dom" ]; then
    dom="*"
fi

if [ -z "$month" ]; then
    month="*"
fi

if [ -z "$dow" ]; then
    dow="*"
fi


local command="grep $keyword $logfile >> $output"

cron_line="$minute_hour $day $dom $month $dow $user"

cron_command="$cron_line $command"

echo "$cron_command"

if [ "$systemwide" == "y" ] && [ -n "$user" ]; then
    local filename
    read -p "Enter filename to save cronjob as: " filename
    echo "$cron_command" >> "etc/cron.d/$filename"
    return 0
fi

if [ -z "$user" ]; then
    (crontab -l 2>/dev/null; echo "$cron_command") | crontab -
    crontab -l
    return 0
fi


if [ -n "$user" ]; then
    (crontab -u "$user" -l 2>/dev/null; echo "$cron_command") |  crontab -u "$user"
    crontab  -u "$user" -l
fi

}

cron_generate


