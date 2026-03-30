#!/bin/bash

echo "Enter target IP Address:"
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
    echo "6. TOGGLE Proxychains (Current: $PROXY_STATUS)"
    echo "7. Note: Manual config is required in /etc/proxychains.conf"
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
            echo "Enter new target IP Address:"
            read host
            ;;

         6)

                if [ -z "$PROXY_CMD" ]; then

                    read -p "Enable Proxychains? (y/n): " confirm

                    if [[ $confirm == "y" ]]; then

                        PROXY_CMD="proxychains4"

                        PROXY_STATUS="ON"

                        echo "Proxychains enabled for all subsequent commands."

                    fi

                else

                    PROXY_CMD=""

                    PROXY_STATUS="OFF"

                    echo "Proxychains disabled. Direct connection restored."

                fi

                ;;

         7)

             echo "--------------------------------------------------"
             echo "IMPORTANT: This script does NOT edit your system files."

             echo "To add/replace IPs, run: sudo vim /etc/proxychains.conf"

             echo "Recommended setup: socks5 127.0.0.1 9050"

             echo "--------------------------------------------------"

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

