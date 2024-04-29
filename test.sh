#!/bin/sh

# . ../common/procedures.sh

# err=0

# eid=`imunes -b services.imn | awk '/Experiment/{print $4; exit}'`
# startCheck "$eid"

#from internal
himage tiger01 nc -zv 200.222.1.12 80 #thor
himage tiger01 nc -zv 200.222.1.11 21 #dedalus
himage tiger01 nc -zv 10.0.2.3 80 #icaro
himage tiger01 nc -zv 10.0.2.2 22 #zeus


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
