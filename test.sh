#!/bin/sh

echo "Access Testing"
echo "========================================="
echo "FROM TIGER01"

echo "check thor http (80) from tiger01: should OPEN"
himage tiger01 nc -zvn 200.222.1.4 80 #thor
echo ""

echo "check dedalus ftp (21) from tiger01: should OPEN"
himage tiger01 nc -zvn 200.222.1.3 21 #dedalus
echo ""

echo "check icaro http (80) from tiger01: should OPEN"
himage tiger01 nc -zvn 10.0.2.3 80 #icaro
echo ""

echo "check zeus ssh (22) from tiger01: should OPEN"
himage tiger01 nc -zvn 10.0.2.2 22 #zeus
echo ""

echo "========================================="
echo "FROM TIGER02"

echo "check thor http (80) from tiger02: should OPEN"
himage tiger02 nc -zvn 200.222.1.4 80 #thor
echo ""

echo "check dedalus ftp (21) from tiger02: should OPEN"
himage tiger02 nc -zvn 200.222.1.3 21 #dedalus
echo ""

echo "check icaro http (80) from tiger02: should OPEN"
himage tiger02 nc -zvn 10.0.2.3 80 #icaro
echo ""

echo "check zeus ssh (22) from tiger02: should OPEN"
himage tiger02 nc -zvn 10.0.2.2 22 #zeus
echo ""

echo "========================================="
echo "FROM TIGER03"

echo "check thor http (80) from tiger03: should OPEN"
himage tiger03 nc -zvn 200.222.1.4 80 #thor
echo ""

echo "check dedalus ftp (21) from tiger03: should OPEN"
himage tiger03 nc -zvn 200.222.1.3 21 #dedalus
echo ""

echo "check icaro http (80) from tiger03: should CLOSED"
himage tiger03 nc -zvn 10.0.2.3 80 #icaro
echo ""

echo "check zeus ssh (22) from tiger03: should CLOSED"
himage tiger03 nc -zvn 10.0.2.2 22 #zeus
echo ""

echo "check zeus ssh (22) from tiger03 via PUBLIC IP: should OPEN"
himage tiger03 nc -zvn 200.222.1.2 22 #zeus via Port Forwarding
echo ""

echo "========================================="
echo "FROM ATTACKER"

echo "check thor http (80) from attacker: should OPEN"
himage attacker nc -zvn 200.222.1.4 80 #thor
echo ""

echo "check dedalus ftp (21) from attacker: should OPEN"
himage attacker nc -zvn 200.222.1.3 21 #dedalus
echo ""

echo "check icaro http (80) from attacker: should CLOSED"
himage attacker nc -zvn 10.0.2.3 80 #icaro
echo ""

echo "check zeus ssh (22) from attacker: should CLOSED"
himage attacker nc -zvn 10.0.2.2 22 #zeus
echo ""

echo "check zeus ssh (22) from tiger03 via PUBLIC IP: should CLOSED"
himage attacker nc -zvn 200.222.1.2 22 #zeus via Port Forwarding
echo ""
