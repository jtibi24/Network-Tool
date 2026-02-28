# NetToolbox: Interactive Network Reconnaissance Suite

NetToolbox is a modular Bash utility designed to streamline common networking and security tasks. It provides a centralized interface for reconnaissance, packet analysis, and proxy-managed traffic routing.



## Core Functionality

* **Interactive Menu:** Persistent `while` loop architecture allowing for continuous testing against a defined target without script termination.
* **Proxy Integration:** Integrated `proxychains` support with a global toggle variable (`PROXY_CMD`) to wrap network commands.
* **Automated Configuration:** Uses `sed` to programmatically update `/etc/proxychains.conf` based on user input (IP, Port, and Type).
* **Error Handling:** Employs exit status verification (`$?`) and integer comparison (`-eq`) to ensure command integrity before proceeding.
