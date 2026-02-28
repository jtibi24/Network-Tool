#!/bin/bash

echo "Enter an IP Address:"
read host

# Initialize proxy variable as empty
PROXY_CMD=""

while true; do
    echo -e "\n--- NETWORK TOOLBOX ---"
    echo "Current Target: $host"
    if [ -z "$PROXY_CMD" ]; then
        echo "Proxy Status: OFF (Direct Connection)"
    else
        echo "Proxy Status: ON (Routing through Proxychains)"
    fi
    echo "-----------------------"
    echo "1. Ping host"
    echo "2. Traceroute"
    echo "3. TCPDump"
    echo "4. Nmap Scan"
    echo "5. Change Target IP"
    echo "6. CONFIGURE & ENABLE Proxy"
    echo "7. DISABLE Proxy"
    echo "8. Exit"
    echo -n "Choose an option: "
    read num

    case $num in
        1)
            echo "How many times do you want to ping?"
            read count
            $PROXY_CMD ping -c "$count" "$host"
            ;;
        2)
            echo "Running traceroute to $host"
            $PROXY_CMD traceroute "$host"
            ;;
        3)
            echo "Running tcpdump on $host (Ctrl+C to stop)"
            # Note: tcpdump usually needs sudo, and sudo must come BEFORE proxychains
            sudo $PROXY_CMD tcpdump -i any host "$host"
            ;;
        4)
            echo "Scanning target $host with Nmap..."
            if [ -n "$PROXY_CMD" ]; then
                # Proxychains works best with TCP Connect scans (-sT)
                sudo proxychains nmap -sT -Pn -p- "$host" -oN nmap_results.txt
            else
                sudo nmap -sS -p- "$host" -oN nmap_results.txt
            fi
            echo "Results saved to nmap_results.txt"
            ;;
        5)
            echo "Enter new IP Address:"
            read host
            ;;
        6)
            echo "Enter Proxy IP:"
            read p_ip
            echo "Enter Proxy Port:"
            read p_port
            echo "Enter Proxy Type (socks4/socks5/http):"
            read p_type

            # Automatically update /etc/proxychains.conf
            echo "Updating /etc/proxychains.conf..."
            sudo sed -i '/\[ProxyList\]/q' /etc/proxychains.conf
            echo "$p_type $p_ip $p_port" | sudo tee -a /etc/proxychains.conf > /dev/null

            if [ $? -eq 0 ]; then
                PROXY_CMD="proxychains"
                echo "Configuration updated and Proxychains enabled."
            else
                echo "Failed to update configuration. Check sudo permissions."
            fi
            ;;
        7)
            PROXY_CMD=""
            echo "Proxy disabled. Back to direct connection."
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option selected."
            ;;
    esac

    echo -e "\nPress Enter to return to the menu..."
    read
done



