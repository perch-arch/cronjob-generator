#!/bin/bash

# * * * * * <script to run>
 # replace * with parameters so they can be filled
 # then script to  run should be provided
 # provide user to run as for system-wide scripts
    # where to save the script incase its system-wide or just adding a user makes it that?
 # fault parameters

cronjob_generator (){

#declare schedule variables
local minute
read -p "Enter minute: " minute

local hour
read -p "Enter hour: " hour

local dom
read -p "Enter dom: " dom

local month
read -p "Enter month: " month

local dow
read -p "Enter hour of the week: " dow

# declare action to run
local command
read -p "Enter base command to run (e.g, grep "failed"): " command 
# declare input and output files
local input 
read -p "Does your command require a log or an input file (y/n): " input

if [ $input == "y" ]; then 
    read -p  "Enter input file path: " InputFile
fi

local output
read -p "Do you want to redirect output to a file (y/n): " output

if [ $output == "y" ]; then 
    read -p "Enter output file name/path (e.g., /home/perch/Documents/date): " SaveOutputAs
fi

# declare if systemwide or user cronjob
local systemwide
read -p "Is this a system-wide cronjob? (y/n): " systemwide

if [ $systemwide == "y" ]; then
    read -p "Enter user: " user
fi

if [ -z $minute ]; then
    minute="*"
fi

if [ -z $hour ]; then
    hour="*"
fi

if [ -z $dom ]; then
    dom="*"
fi

if [ -z $month ]; then
    month="*"
fi

if [ -z $dow ]; then
    dow="*"
fi

# command construction

local cron_time="$minute $hour $dom $month $dow"

full_command="$command"

if [ $input == "y" ]; then
    full_command="$command $InputFile"
fi

if [ $output == "y" ]; then
    full_command="$command >> ${SaveOutputAs}_\$(date +\%Y\%m\%d_\%H\%M\%S).log"
fi

if [ $output == "y" ] && [ $input == "y" ]; then
    full_command="$command $InputFile >> ${SaveOutputAs}_\$(date +\%Y\%m\%d_\%H\%M\%S).log"
fi
 
cron_command="$cron_time $user $full_command"


if [ "$systemwide" == "y" ] && [ -n "$user" ]; then
    local filename
    while true; do
        read -p "Enter filename to save cronjob as: " filename

        if [[ "$filename" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            break
        else
            echo "Invalid filename. Only letters, numbers, dashes (-), and underscores (_) are allowed."
        fi

    done
    
    echo "$cron_command" | sudo tee "/etc/cron.d/$filename"

elif [ -n "$user" ]; then
    (crontab -u "$user" -l 2>/dev/null; echo "$cron_command") |  crontab -u "$user"
    crontab  -u "$user" -l

else
    (crontab -l 2>/dev/null; echo "$cron_command") | crontab -

fi

}

cronjob_generator


