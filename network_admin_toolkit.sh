#!/bin/bash

function ssh_login() {
    PS3="Select a server to SSH into: "
    server_options=("Custom target" "HOME_VM" "test" "test linux vm" "Back to Main Menu")

    while true; do
        clear
        echo "===== SSH Server Selection ====="
        select server_choice in "${server_options[@]}"; do
            case $server_choice in
                "Custom target")
                    read -p "Enter the username@hostname to SSH into: " custom_ssh_target
                    ssh $custom_ssh_target
                    break ;;
                "HOME_VM")
                    ssh -p 1337 root@192.168.1.23
                    break ;;
                "test")
                    ssh -p 8263 admin@192.168.1.53
                    break ;;
                "test linux vm")
                    ssh -p 9439 test@192.168.1.54
                    break ;;
                "Back to Main Menu")
                    return ;;
                *)
                    echo "Invalid option";;
            esac
        done
    done
}

function telnet_client() {
  read -p "Enter an IP or domain for Telnet: " target
  read -p "Enter the port: " port
  telnet "$target" "$port"
  return_to_menu
}

function perform_screen() {
    read -p "Enter the device to run screen (default: '/dev/ttyUSB0'): " device
    if [[ -z "$device" ]]; then
        device="/dev/ttyUSB0"
    fi
    screen "$device"
    return_to_menu
}

function close_all_screen_sessions() {
    screen -ls | grep -o -P '\d+\.\S+' | awk '{print $1}' | xargs -I {} screen -X -S {} quit
    return_to_menu
}

function perform_ping() {
    read -p "Enter the IP or domain to ping: " target
    ping -c 4 "$target"
    return_to_menu
}

function perform_traceroute() {
    read -p "Enter the IP or domain for traceroute: " target
    traceroute "$target"
    return_to_menu
}

function perform_mtr() {
    read -p "Enter the IP or domain for MTR: " target
    mtr "$target"
    return_to_menu
}

function perform_curl() {
    read -p "Enter the IP or domain to view headers for: " target
    curl -Iv "$target"
    return_to_menu
}

function perform_nmap() {
    read -p "Enter the target IP or range for Nmap (e.g., '192.168.1.1' or '192.168.1.0/24'): " target
    sudo nmap -T4 -F "$target"
    return_to_menu
}

function perform_whois() {
    read -p "Enter the IP or domain for Whois: " target
    whois "$target"
    return_to_menu
}

function start_iperf_server() {
    read -p "Enter the port for iperf server: " target
    iperf3 -s -p "$target"
    return_to_menu
}

function run_iperf_client() {
    read -p "Enter the server IP or hostname for iperf client: " target_server
    read -p "Enter the server port: " target_port
    read -p "Enter additional iperf options (press Enter for default): " target_options
    iperf3 -c "$target_server" -p "$target_port" $target_options
    return_to_menu
}

function perform_speedtest() {
    speedtest-cli --share
    return_to_menu
}

function start_http_server() {
    read -p "Enter the directory path to share: " target_directory
    if [ -z "$target_directory" ]; then
        echo "Directory path cannot be empty."
        return_to_menu
        return
    fi

    read -p "Enter the port to use (press Enter for default: 8000): " target_port

    if [ -d "$target_directory" ] && [ -n "$target_port" ]; then
        echo "Starting HTTP server to share directory: $target_directory"
        sudo python3 -m http.server --directory "$target_directory" "$target_port"
    elif [ ! -d "$target_directory" ]; then
        echo "Directory not found: $target_directory"
        return_to_menu
    fi
}

function show_logged_users() {
    echo "Logged In Users:"
    who
    return_to_menu
}

function show_process_list() {
    echo "Running Processes:"
    ps aux
    return_to_menu
}

function show_network_connections() {
    echo "Network Connections:"
    netstat -tuln
    return_to_menu
}

function show_disk_usage() {
    echo "Disk Usage:"
    df -h
    return_to_menu
}

function show_system_info() {
    echo "System Information: $(lsb_release -ds)"
    echo "Hostname: $(hostname)"
    echo "Kernel Version: $(uname -r)"
    
    memory_total_kb=$(grep -E '^MemTotal:' /proc/meminfo | awk '{print $2}')
    memory_used_kb=$(grep -E '^MemAvailable:' /proc/meminfo | awk '{print $2}')
    memory_total_mb=$((memory_total_kb / 1024))
    memory_used_mb=$((memory_used_kb / 1024))
    echo "Memory Free: ${memory_used_mb}MB / ${memory_total_mb}MB"
    
    swap_free_kb=$(grep -E '^SwapFree:' /proc/meminfo | awk '{print $2}')
    swap_free_mb=$((swap_free_kb / 1024))
    echo "Swap Free: ${swap_free_mb}MB"
    
    local_ips=$(ip -o -4 addr show | awk '{print $4}' | cut -d/ -f1 | tr '\n' ' ')
    echo "Local IP: $local_ips"
    
    public_ip=$(curl -s 2ip.ua | grep 'ip' | awk -F: '{print $2}' | tr -d '[:blank:]')
    echo "Public IP: $public_ip"
    
    cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | awk -F: '{print $2}')
    echo "CPU: $cpu_info"
    
    disk_total=$(df -h --total | awk '/^total/{print $2}')
    disk_used=$(df -h --total | awk '/^total/{print $3}')
    echo "Disk Usage: $disk_used / $disk_total"
    
    return_to_menu
}

function restart_service() {
    read -p "Enter the name of the service to restart: " service_name
    sudo systemctl restart "$service_name"
    echo "Service '$service_name' restarted."
    return_to_menu
}

function install_dependencies() {
    local package_manager

    if [ -x "$(command -v apt)" ]; then
        package_manager="apt"
    elif [ -x "$(command -v pacman)" ]; then
        package_manager="pacman"
    elif [ -x "$(command -v yum)" ]; then
        package_manager="yum"
    elif [ -x "$(command -v dnf)" ]; then
        package_manager="dnf"
    else
        echo "Unable to determine the distribution or no supported package manager found."
        return_to_menu
        return
    fi

    if [ "$package_manager" = "pacman" ]; then
        sudo "$package_manager" -Sy
    else
        sudo "$package_manager" update -y
    fi

    if [ "$package_manager" = "pacman" ]; then
        sudo "$package_manager" -S --noconfirm curl nmap traceroute net-tools mtr whois inetutils iperf3 python3 speedtest-cli screen
    else
        sudo "$package_manager" install -y curl nmap traceroute net-tools mtr whois telnet iperf3 python3 speedtest-cli screen  
    fi

    echo "Dependencies installed."
    return_to_menu
}

function return_to_menu() {
    read -n 1 -s -r -p "Press any key to return to the menu..."
}

function main_menu() {
    while true; do
        show_menu
    done
}

function show_menu() {
    PS3="Select an option (or press 'q' to exit): "
    options=("SSH Login" "Telnet" "Run 'screen /dev/ttyUSB0'" "Close all 'screen' sessions" "Ping" "Traceroute" "MTR" "View Detailed HTTP Headers" "Nmap (Quick Scan)" "Whois" "Start iperf (Server)" "Run iperf (Client)" "Speedtest" "Start HTTP Server" "Logged In Users" "Running Processes" "Network Connections" "Disk Usage" "System Information" "Restart Service" "Install/Check Dependencies")

    clear
    echo "(っ◔◡◔)っ ♥ Main Admin Menu ♥"
    echo ""
    for ((i=0; i<${#options[@]}; i++)); do
        echo "$((i+1)). ${options[i]}"
    done
    echo

    read -p "Enter your choice (or 'q' to exit): " choice

    if [[ "$choice" == "q" ]]; then
        echo "Exiting the script."
        exit
    elif (( choice >= 1 && choice <= ${#options[@]} )); then
        selected_option="${options[choice-1]}"
        case "$selected_option" in
            "SSH Login")
                echo "SSH Login: Connect to a remote host via SSH."
                ssh_login ;;
            "Telnet")
                echo "Telnet Login: Connect to a remote host via Telnet."
                telnet_client ;;
            "Run 'screen /dev/ttyUSB0'")
                echo "Screen: Run a terminal emulator on a serial device."
                perform_screen ;;
            "Close all 'screen' sessions")
                echo "Close Screens: Terminate all 'screen' sessions."
                close_all_screen_sessions ;;
            "Ping")
                echo "Ping: Send ICMP echo requests to a target."
                perform_ping ;;
            "Traceroute")
                echo "Traceroute: Discover the path packets take between nodes."
                perform_traceroute ;;
            "MTR")
                echo "MTR: Traceroute and network diagnostic tool."
                perform_mtr ;;
            "View Detailed HTTP Headers")
                echo "Viewing Detailed HTTP Headers..."
                perform_curl ;;
            "Nmap (Quick Scan)")
                echo "Nmap: Perform a quick scan on target IP or range."
                perform_nmap ;;
            "Whois")
                echo "Whois: Retrieve domain registration and ownership information."
                perform_whois ;;
            "Start iperf (Server)")
                echo "Starting iperf Server..."
                start_iperf_server ;;
            "Run iperf (Client)")
                echo "Running iperf Client..."
                run_iperf_client ;;
            "Speedtest")
                echo "Speedtest: Measure network bandwidth performance."
                perform_speedtest ;;
            "Start HTTP Server")
                echo "Starting HTTP Server..."
                start_http_server ;;
            "Logged In Users")
                echo "Displaying logged in users..."
                show_logged_users ;;
            "Running Processes")
                echo "Displaying running processes..."
                show_process_list ;;
            "Disk Usage")
                echo "Displaying disk usage..."
                show_disk_usage ;;
            "Network Connections")
                echo "Displaying network connections..."
                show_network_connections ;;
            "Restart Service")
                restart_service ;;
            "System Information")
                echo "Displaying system information..."
                show_system_info ;;
            "Install/Check Dependencies")
                echo "Installing/Checking required dependencies..."
                install_dependencies ;;
            *)
                echo "Invalid option"
                ;;
        esac
    else
        echo "Invalid option"
    fi
}

main_menu
