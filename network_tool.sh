#!/bin/bash

# Function to ping a host
ping_host() {
  ping -c 1 "$1" > /dev/null 2>&1  # Redirect output to suppress normal ping output
  if [ $? -eq 0 ]; then
    echo "$1 is reachable."
  else
    echo "$1 is not reachable."
  fi
}

# Function to traceroute to a host
traceroute_host() {
  traceroute "$1"
}

# Function to perform a DNS lookup
nslookup_host() {
  nslookup "$1"
}

# Improved is_valid_hostname_or_ip function
is_valid_hostname_or_ip() {
  if [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then # More robust IPv4 check
    return 0  # Valid IP
  elif host "$1" > /dev/null 2>&1; then # Check if hostname resolves
    return 0  # Valid hostname
  else
    return 1  # Invalid
  fi
}

# Improved port_scan function
port_scan() {
  hostname="$1"
  ports="$2"  # Ports can be a single port, a range (e.g., 1-100), or a comma-separated list

  if [[ -z "$ports" ]]; then
    echo "No ports specified. Scanning default ports (21, 22, 80, 443, 3389)."
    ports="21,22,80,443,3389" # Default ports if none are provided
  fi

  # Handle port ranges and lists
  IFS=','  # Set the field separator to comma
  read -ra port_array <<< "$ports"
  for port_range in "${port_array[@]}"; do
      if [[ "$port_range" =~ ^([0-9]+)-([0-9]+)$ ]]; then # Check for port range
          start_port="${BASH_REMATCH[1]}"
          end_port="${BASH_REMATCH[2]}"
          for port in $(seq "$start_port" "$end_port"); do
              check_port "$hostname" "$port"
          done
      else
          port="$port_range"
          check_port "$hostname" "$port"
      fi
  done
}

# Helper function to check a single port
check_port() {
    hostname="$1"
    port="$2"
    nc -vz -w 1 "$hostname" "$port" 2>/dev/null  # -w 1 for timeout
    if [ $? -eq 0 ]; then
        echo "Port $port is open on $hostname"
    fi
}


http_request() {
  hostname="$1"
  if [[ "$hostname" =~ ^https:// ]]; then
    url="$hostname"
  elif [[ "$hostname" =~ ^http:// ]]; then
    url="$hostname"
  else
    url="http://$hostname"  # Default to http
  fi

  # More robust curl command with timeout and status code extraction
  status_code=$(curl -s -o /dev/null -w "%{http_code}" -m 5 "$url")

  if [[ -n "$status_code" ]]; then  # Check if status_code is not empty
    echo "HTTP Status Code: $status_code"
  else
    echo "HTTP/HTTPS request timed out or failed."
  fi
}

# Main script logic (modified)
if [ -z "$1" ]; then
  echo "Usage: $0 <hostname_or_ip>"
  exit 1
fi

hostname="$1"

if ! is_valid_hostname_or_ip "$hostname"; then
  echo "Invalid hostname or IP address: $hostname" # More informative message
  exit 1
fi


echo "--- Network Tests for $hostname ---"

echo ""
echo "--- Ping ---"
ping_host "$hostname"

echo ""
echo "--- Traceroute ---"
traceroute_host "$hostname"

echo ""
echo "--- DNS Lookup ---"
nslookup_host "$hostname"

echo ""
echo "--- Port Scan ---"
read -p "Enter ports to scan (e.g., 80, 21-100, or press Enter for defaults): " user_ports
port_scan "$hostname" "$user_ports" 

echo ""
echo "--- HTTP/HTTPS Request ---"
http_request "$hostname"

echo ""