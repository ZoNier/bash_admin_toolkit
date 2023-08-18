## Network Admin Toolkit

The Network Admin Toolkit is a comprehensive collection of network administration tools and utilities designed to simplify the management and troubleshooting of various network-related tasks. This script offers a user-friendly, menu-driven interface for executing essential network tasks within a Linux environment.

### Features

- **SSH Login**: Seamlessly connect to remote servers using SSH.
- **Telnet**: Establish connections to remote hosts using the Telnet protocol.
- **Serial Terminal**: Launch terminal emulators on serial devices for remote access.
- **Close all 'screen' Sessions**: Effortlessly terminate all active 'screen' sessions.
- **Ping**: Assess network connectivity by sending ICMP echo requests.
- **Traceroute**: Uncover the route packets take between network nodes.
- **MTR**: Conduct comprehensive traceroute and network diagnostics.
- **View Detailed HTTP Headers**: Retrieve intricate HTTP headers from servers.
- **Nmap (Quick Scan)**: Perform swift network scans using Nmap.
- **Whois**: Retrieve domain registration and ownership information.
- **iperf**: Measure network performance as both a server and client.
- **Speedtest**: Evaluate network bandwidth performance.
- **Start HTTP Server**: Share files through an HTTP server.
- **Logged In Users**: Display active user sessions.
- **Check Local Ports**: View open network ports on the local machine.
- **Running Processes**: List currently active processes.
- **Network Connections**: Display active network connections.
- **Disk Usage**: Examine disk usage statistics.
- **System Information**: Obtain system details including OS, memory, and CPU.
- **Restart Service**: Restart specified services using systemctl.
- **Install/Check Dependencies**: Manage script dependencies effortlessly.

### Usage

1. Clone this repository to your local machine.
2. Navigate to the repository directory using your terminal.
3. Execute the script with the command: `./network_admin_toolkit.sh`

Follow the on-screen instructions to select and perform a variety of network administration tasks.

For easy access to the script, you can create a symbolic link to it in a directory that's included in your system's PATH. Here's how you can do it:

1. Open your terminal.
2. Navigate to the repository directory where the script is located.
3. Run the following command to create a symbolic link:
`sudo ln -s $(pwd)/network_admin_toolkit.sh /usr/local/bin/tools`
`sudo chmod +x $(pwd)/network_admin_toolkit.sh`

Now you can run the script from anywhere by simply typing `tools` in your terminal.

### Requirements

- A Linux environment
- Bash shell
- Python 3 (for starting HTTP server)
- Internet connectivity (for some tools)

### Disclaimer

The Network Admin Toolkit is provided as-is and should be used responsibly. Prior to using it in a production environment, ensure you understand the commands it executes.

### License

This script is released under the [MIT License](LICENSE).

---

**Note**: Ensure that you have the necessary permissions to carry out administrative tasks on your network and systems. Use this script responsibly and at your own risk.
