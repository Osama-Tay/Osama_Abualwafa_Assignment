#!/bin/bash

# Get system information
EXECUTED_BY=$(whoami)
HOSTNAME=$(hostname)
SERVER_IP=$(hostname -I | awk '{print $1}')

# Public IP with fallback
PUBLIC_IP=$(curl -s --connect-timeout 5 https://ifconfig.me || echo "Not Available")

OS_TYPE_VERSION=$(grep "PRETTY_NAME" /etc/os-release | cut -d'=' -f2 | tr -d '"')
KERNEL_VERSION=$(uname -r)
ARCHITECTURE=$(uname -m)
VIRTUALIZATION=$(systemd-detect-virt)
SERVER_TIME=$(date "+%a %b %d %T %p %Z %Y")
TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3 " (" $4 " " $5}')
UPTIME=$(uptime -p | sed 's/up //')

# Resource Usage
TOTAL_MEMORY=$(free -h | awk '/^Mem:/ {print $2}')
MEMORY_USAGE=$(free -h | awk '/^Mem:/ {print $3 " / " $2}')
SWAP_USAGE=$(free -h | awk '/^Swap:/ {print $3 " / " $2}')
CPU_CORES=$(nproc)

echo "System Information"
echo "------------------"
echo "• Executed By: $EXECUTED_BY"
echo "• Hostname: $HOSTNAME"
echo "• Server IP: $SERVER_IP"
echo "• Public IP: $PUBLIC_IP"
echo "• OS Type and Version: $OS_TYPE_VERSION"
echo "• Kernel Version: $KERNEL_VERSION"
echo "• Architecture: $ARCHITECTURE"
echo "• Virtualization: $VIRTUALIZATION"
echo "• Server Time: $SERVER_TIME"
echo "• Timezone: $TIMEZONE"
echo "• Uptime: $UPTIME"
echo ""
echo "Resource Usage"
echo "--------------"
echo "• Total Memory: $TOTAL_MEMORY"
echo "• Memory Usage: $MEMORY_USAGE"
echo "• Swap Usage: $SWAP_USAGE"
echo "• CPU Cores: $CPU_CORES"
