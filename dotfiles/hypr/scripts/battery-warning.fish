#!/usr/bin/fish

# This script runs in the background to send a notification for low battery.

while true
    # Get battery capacity and status directly from the system files
    set capacity (cat /sys/class/power_supply/BAT0/capacity)
    set status (cat /sys/class/power_supply/BAT0/status)

    # The path for our lock file to prevent spamming notifications
    set lock_file /tmp/low_battery_notified.lock

    # Check if battery is discharging, below the threshold, and we haven't notified yet
    if test "$status" = "Discharging"; and test "$capacity" -le 20; and not test -f "$lock_file"
        # Send a critical notification
        dunstify -u critical "Low Battery" "Battery level is at $capacity%!"

        # Create the lock file to signify that we have sent the notification
        touch "$lock_file"

    # Check if the system is now charging and the lock file exists
    else if test "$status" != "Discharging"; and test -f "$lock_file"
        # If so, remove the lock file so we can be notified again next time
        rm "$lock_file"
    end

    # Wait for 60 seconds before checking again
    sleep 60
end
