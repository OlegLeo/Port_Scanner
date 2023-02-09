This script is a basic port scanner that scans a host or subnet IP address for open ports. The user inputs the host and port as arguments, and the script checks for open ports and outputs the results.

To run the script, the user needs to provide a host/ip or a range of subnet ip's. User also can provide a port or range of ports as arguments to be scanned.

If only one argument is passed, the script will scan the most common ports (21, 22, 25, 53, 80, 110, 143, 443, 445, 3306, 9000, 49153) for the specified host.

The usage is as follows:

         chmod +x port_scanner.sh

        ./port_scanner.sh < host/ ip / ip range ex.: 192.168.1.* > <port> [<port1> <port2> ...] <portRangeStart>-<portRangeFinish>


The script supports the following use cases:

If two arguments are passed, the script will scan a single specified port or a range of ports. The port range must be specified in the format <portRangeStart>-<portRangeFinish>.

The script outputs the result of the scan, indicating which ports are open and which are closed. If no open ports are found, the script outputs "No open ports were found".

If the user terminates the script by pressing "CTRL + C", the program quits with the message "Program Stopped". Additionally, the script will exit if the specified host/subnet IP can't be reached.

