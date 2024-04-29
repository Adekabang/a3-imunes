#!/bin/sh

# . ../common/procedures.sh

# err=0

# eid=`imunes -b services.imn | awk '/Experiment/{print $4; exit}'`
# startCheck "$eid"

#from internal
# himage tiger01 nmap -Pn -p80 200.222.1.12 #thor
# himage tiger01 nmap -Pn -p21 200.222.1.11 #dedalus
# himage tiger01 nmap -Pn -p80 10.0.2.3 #icaro
# himage tiger01 nmap -Pn -p22 10.0.2.2 #zeus

check_port 22 10.0.22

check_port() {
    (echo ^]; echo quit) | timeout --signal=9 5 himage tiger01 telnet $1 $2 > /dev/null 2>&1    
    TELNET_EXIT_CODE=$?
        
    if [[ $TELNET_EXIT_CODE -ne 0 ]]; then
        nc -w $TIMEOUT -z $1 $2 > /dev/null 2>&1
        NC_EXIT_CODE=$?
    fi

    if [[ $TELNET_EXIT_CODE -eq 0 ]] || [[ $NC_EXIT_CODE -eq 0 ]]; then
        echo "success"
    else
        echo "fail"
    fi
}

# err=0
# # ftp
# himage @$eid netstat -an | grep LISTEN | grep -q "21"
# if [ $? -ne 0 ]; then
#     echo "FTP error"
#     err=1
# fi

# # ssh
# himage SSH@$eid netstat -an | grep LISTEN | grep -q "22"
# if [ $? -ne 0 ]; then
#     echo "SSH error"
#     err=1
# fi

# imunes -b -e $eid

# thereWereErrors $err
