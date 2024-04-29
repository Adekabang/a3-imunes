#!/bin/sh

# . ../common/procedures.sh

# err=0

# eid=`imunes -b services.imn | awk '/Experiment/{print $4; exit}'`
# startCheck "$eid"

#from internal
echo "check thor http (80) from tiger01"
himage tiger01 nc -zvn 200.222.1.12 80 #thor
echo ""

echo "check dedalus ftp (21) from tiger01"
himage tiger01 nc -zvn 200.222.1.11 21 #dedalus
echo ""

echo "check icaro http (80) from tiger01"
himage tiger01 nc -zvn 10.0.2.3 80 #icaro
echo ""

echo "check zeus ssh (22) from tiger01"
himage tiger01 nc -zvn 10.0.2.2 22 #zeus
echo ""


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
