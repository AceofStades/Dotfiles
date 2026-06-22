#!/bin/bash
echo "$(date): $MAC" >> /tmp/zmk_script.log
MAC="$1"
if [ -z "$MAC" ]; then
    echo "{}"
    exit 0
fi

# Handle both MAC address and nativePath format (dev_AB_CD...)
if [[ "$MAC" == *dev_* ]]; then
    DEV=$(echo "$MAC" | grep -o 'dev_[0-9A-F_a-f]*')
else
    DEV="dev_${MAC//:/_}"
fi

# Find all battery characteristics
PATHS=$(busctl tree org.bluez 2>/dev/null | grep "$DEV" | grep -o '/org/bluez.*char[0-9a-f]*$')

CHARS=()
for path in $PATHS; do
    uuid=$(busctl get-property org.bluez "$path" org.bluez.GattCharacteristic1 UUID 2>/dev/null | awk '{print $2}' | tr -d '"')
    if [ "$uuid" = "00002a19-0000-1000-8000-00805f9b34fb" ]; then
        CHARS+=("$path")
    fi
done

if [ ${#CHARS[@]} -ge 2 ]; then
    # Read both
    # Usually the first is left/central and second is right/peripheral
    VAL1=$(busctl call org.bluez "${CHARS[0]}" org.bluez.GattCharacteristic1 ReadValue a{sv} 0 2>/dev/null | awk '{print $3}')
    VAL2=$(busctl call org.bluez "${CHARS[1]}" org.bluez.GattCharacteristic1 ReadValue a{sv} 0 2>/dev/null | awk '{print $3}')
    
    if [ -n "$VAL1" ] && [ -n "$VAL2" ]; then
        echo "{\"left\": $VAL1, \"right\": $VAL2}"
    else
        echo "{}"
    fi
else
    echo "{}"
fi
