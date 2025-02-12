# Network Tool

This is a basic network diagnostic tool written in Bash. It provides common network utilities in a single script for easy troubleshooting.

## Features

*   **Ping:** Checks if a host is reachable.
*   **Traceroute:** Shows the network path to a host.
*   **DNS Lookup:** Resolves a hostname to its IP address.
*   **Port Scan:** Scans common ports on a host.
*   **HTTP/HTTPS Request:** Checks if a web server is responding.

## Installation

1. Cloning the Repository

```Bash
git clone https://github.com/kissssu/network_tool.git
cd network_tool
```

2. Make the script executable:

```Bash
chmod +x network_tool.sh
```

## Usage

```bash
./network_tool.sh <hostname_or_ip>
```
- Replace <hostname_or_ip> with the target hostname or IP address (e.g., google.com or 8.8.8.8).

## Examples

```Bash
./network_tool.sh google.com
./network_tool.sh 192.168.1.1
```

### Output
The script will print the results of each test, including:
- Ping status (reachable/unreachable)
- Traceroute output
- DNS lookup results
- Open ports
- HTTP/HTTPS status

```
--- Network Tests for google.com ---

--- Ping ---
google.com is reachable.

--- Traceroute ---
traceroute to google.com (142.250.182.238), 30 hops max, 60 byte packets
 1  _gateway (_____) 1.279 ms  1.252 ms  1.241 ms
 2  ........
 3. ......
 ..

--- DNS Lookup ---
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	google.com
Address: 142.250.182.238
Name:	google.com
Address: 2404:6800:4009:820::200e


--- Port Scan ---
Enter ports to scan (e.g., 80, 21-100, or press Enter for defaults): 
No ports specified. Scanning default ports (21, 22, 80, 443, 3389).
Port 80 is open on google.com
Port 443 is open on google.com

--- HTTP/HTTPS Request ---
HTTP Status Code: 301

```

## Dependencies
- Bash
- ping
- traceroute
- nslookup
- nc (netcat) or nmap (if you choose to use it)
- curl
- host (for hostname resolution check)
These tools are typically available on most Linux and macOS systems.  You may need to install nc (netcat) on some systems if it's not already present.

## Contributing
Contributions are welcome! If you'd like to contribute to this project, please follow these steps:
- Fork the repository on GitHub.
- Create a new branch for your changes.   
- Make your changes and commit them with descriptive commit messages.
- Push your branch to your forked repository.   
- Submit a pull request.
- Please ensure your code follows the existing style and includes appropriate tests.