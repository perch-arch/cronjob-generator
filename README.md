🕒 cronjob_generator

A simple interactive Bash script to help you create cron jobs easily without having to memorize crontab syntax. Supports user and system-wide cron jobs, optional input/output files, and validates scheduling fields.


🚀 Features

    Interactive prompts for all cron time fields (minute, hour, day of month, month, day of week)

    Accepts a base command, with optional input (e.g., log file) and output redirection

    Handles both user-level and system-wide cron jobs

    Validates system-wide filenames for safe writing to /etc/cron.d

    Automatically installs the cron job via crontab or sudo tee depending on scope


📦 Example Usage

    ./cronjob_generator.sh

    You’ll be prompted like:

    Enter minute: 0
    Enter hour: 12
    Enter dom: *
    Enter month: *
    Enter hour of the week: 1-5
    Enter base command to run (e.g, grep "failed"): grep "failed"
    Does your command require a log or an input file (y/n): y
    Enter input file path: /var/log/auth.log
    Do you want to redirect output to a file (y/n): y
    Enter output file path: /home/user/cron_output.txt
    Is this a system-wide cronjob? (y/n): n

    This will generate and install a cron job like:

    0 12 * * 1-5 grep "failed" /var/log/auth.log >> /home/user/cron_output.txt


🛠 System-Wide Example

If you select system-wide:

    You’ll be prompted for a username and a valid filename (letters, numbers, dashes, underscores)

    The job will be saved to /etc/cron.d/<filename>

Enter filename to save cronjob as: daily_log_check


📋 Requirements

    Bash

    crontab installed and accessible

    sudo access if writing to /etc/cron.d/


🤖 To-Do / Improvements

    Add dry-run preview before install

    Add optional comments to cron job lines

    Add error handling for invalid time values