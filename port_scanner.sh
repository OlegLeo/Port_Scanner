
#!/bin/bash


# User input for 1st argument wich is <Host> and 2nd <PORT>

host=$1
PORT=$2

# Getting the date and hour into a variable

current_date_time=$(date +"%d %B %Y %T")

# In case user wants to finish te scan and presses "CTRL + C". the program quits with the output message

trap 'printf "%s\n ... Program Stopped %s\n"; exit' INT


# Checking if arguments exist

if [ $# -lt 1 ]; then
    echo "Please specify a remote host/subnet ip and a port to scan."
    echo "./port_scanner.sh <host/subnet ip/ip range ex: *.*.*.*> <port> [<port1> <port2> ...] <portRangeStart>-<portRangeFinish>"
    exit 1

elif [ $# -eq 1 ]; then
    # do something if only 1 argument is passed
    #echo "Only 1 argument was passed: $1"

    echo ""
    echo "Starting $0 1.0 at $current_date_time"
    echo ""
    echo "Scanning the most common ports for: '$host' ..."
    echo ""

# Initializing the array
open_hosts=()

if [[ $host == *"*"* ]]; then
    # Argument is a subnet IP address
    IFS='.' read -ra octets <<< "$host"
    base=""
    iterated=""
    
    
    for i in "${octets[@]}"; do
        if [[ $i == *"*"* ]]; then
            # This is the iterated octet
            iterated="$i"
        else
            base="$base$i."
        fi
    done

    # Substitute the iterated octet with all possible values (0-255)
    for i in $(seq 1 2); do
        host="$base$i"
        echo "Looking for open ports on: $host"
        # Looking for most known open ports if there were no ports specified by user 
        echo ""
         for PORT in 21 22 25 53 80 110 143 443 445 3306 9000 49153; do
            if timeout 0.5 bash -c "</dev/tcp/$host/$PORT &>/dev/null" 2>/dev/null ; then
                echo "Port $PORT is open on host $host"
                open_hosts+=("$host port $PORT open")
            fi
        done
        echo ""
    done
    
    # Print the contents of the array with open hosts
if [ ${#open_hosts[@]} -eq 0 ]; then
    echo "No open ports were found"
else
    #echo "Hosts with open ports: ${open_hosts[@]}"
    echo ""
    echo "Open ports were found:"
    echo ""
    for item in "${open_hosts[@]}"; do
    printf "%s\n" "$item"
    echo ""
done

fi

else
    # Argument is a hostname or an IP address

    # Looking for most common open ports if there were no ports specified by user 
    echo ""
     for PORT in 21 22 25 53 80 110 143 443 445 3306 9000 49153; do
        if timeout 0.5 bash -c "</dev/tcp/$host/$PORT &>/dev/null" 2>/dev/null ; then
            echo "Port $PORT is open"
        else
            # Check if an error occurred
            if [ "$?" -ne "124" ] ; then
                echo "Host/Subnet ip can't be reached. Exiting program..."
                exit 1
            fi        
        fi
    done
fi



elif [ $# -eq 2 ]; then
    # do something if 2 arguments are passed

    #echo "2 arguments were passed: $1 and $2"  

    echo ""
    if echo "$2" | grep -q '-'; then
        # Split the range into start and end
        IFS='-' read -r start end <<< "$2"
        # do something with the range
        echo ""
        echo "Starting $0 1.0 at $current_date_time"
        echo ""
        echo "Scanning ports $start to $end on host $1"
        echo ""
        for PORT in $(seq $start $end); do
            if timeout 0.5 bash -c "</dev/tcp/$host/$PORT &>/dev/null" 
            then
                echo "Port $PORT is open"
            else
            # Check if an error occurred
            if [ "$?" -ne "124" ] ; then
                echo ""
                echo "Host/Subnet ip can't be reached. Exiting program..."
                exit 1
                
            fi
                echo "Port $PORT is closed"
            fi
        done
    else

    # scan only a single port
    PORT=$2
        echo ""
        echo "Starting $0 1.0 at $current_date_time"
        echo ""
        echo "Scanning $host on a port $PORT"
        echo ""

        if timeout 1 bash -c "</dev/tcp/$host/$PORT &>/dev/null" 
        then
            echo "Port $PORT is open"
        else
        # Check if an error occurred
            if [ "$?" -ne "124" ] ; then
                echo ""
                echo "Host/Subnet ip can't be reached. Exiting program..."
                exit 1
            fi
            echo "Port $PORT is closed"
        fi
    fi

# scan the list of ports provided by user
elif [ $# -gt 2 ]; then
    echo ""

    #echo "More than 2 arguments provided."
    
    args=("$@") # store all arguments in an array
    args_after_first=("${args[@]:1}")
    echo ""
    echo "Starting $0 1.0 at $current_date_time"
    echo ""
    echo "Scanning $host on ports: ${args_after_first[@]}"
    echo ""
    
    for PORT in "${args_after_first[@]}"; do
        if timeout 0.7 bash -c "</dev/tcp/$host/$PORT &>/dev/null" 
        then
        echo "Port $PORT is open"
        else
        # Check if an error occurred
            if [ "$?" -ne "124" ] ; then
                echo ""
                echo "Host/Subnet can't be reached. Exiting program..."
                exit 1
            fi
        echo "Port $PORT is closed"
        fi
    done

fi







