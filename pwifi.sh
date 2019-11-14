# Run this script to get the password for the Wi-Fi network you are currently connected to
echo "running pwifi.sh"

path_to_shill_profile=$(sudo find /home/root -name "shill.profile")
echo "path_to_shill_profile: $path_to_shill_profile"

service_id=$(cat /var/log/net.log | grep "Connected -> Online" | grep -e '[0-9]*' --only-matching | tail -1)
echo "service_id: $service_id"

network_name=$(cat /var/log/net.log | grep "Rep ep updated for $service_id" | tail -1 | grep "SSID=[A-Za-z0-9]*" --only-matching | cut -c 6-)
echo "network_name: $network_name"

line_number=$(sudo cat $path_to_shill_profile | grep -n "Name=$network_name" | grep -e "^[0-9]*" --only-matching)
#echo "line_number: $line_number"
section_end=$((line_number + 20))
#echo "section_end: $section_end"

hashed=$(sudo sed -n "$line_number,${section_end}p" $path_to_shill_profile | grep "Passphrase=rot47:*" | cut -c 18-)
echo "hashed: $hashed"

wifi_password=$(echo "$hashed" | tr '!-~' 'P-~!-O')
echo "Wi-Fi Password: $wifi_password"
