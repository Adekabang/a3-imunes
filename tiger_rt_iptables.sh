#! /bin/sh
IPTABLES="iptables"

reset_iptables_v4() {
  $IPTABLES -P OUTPUT  DROP
  $IPTABLES -P INPUT   DROP
  $IPTABLES -P FORWARD DROP

cat /proc/net/ip_tables_names | while read table; do
  $IPTABLES -t $table -L -n | while read c chain rest; do
      if test "X$c" = "XChain" ; then
        $IPTABLES -t $table -F $chain
      fi
  done
  $IPTABLES -t $table -X
done
}

script_body() {
    # Accept established sessions
    $IPTABLES -A INPUT   -m state --state ESTABLISHED,RELATED -j ACCEPT 
    $IPTABLES -A OUTPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT 
    $IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

    echo "Rule 0 (NAT)"
    # Translate source address
    $IPTABLES -t nat -A POSTROUTING -o eth3 -j MASQUERADE
    $IPTABLES -A FORWARD -s 10.0.1.0/29 -o eth0 -j ACCEPT
    $IPTABLES -A FORWARD -s 10.0.2.0/29 -o eth0 -j ACCEPT
    $IPTABLES -A FORWARD -s 10.0.3.0/29 -o eth0 -j ACCEPT
    # Outgoing connections
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.1.0/29  -j SNAT --to-source 200.222.1.2
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.2.0/29  -j SNAT --to-source 200.222.1.2
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.3.0/29  -j SNAT --to-source 200.222.1.2

    echo "Rule 1 (Port Forward)"
    sysctl -w net.ipv4.ip_forward=1
    sysctl -p

    echo "Rule 2 (Allow LAN to Internet and DMZ)"
    $IPTABLES -A INPUT  -s 10.0.1.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A OUTPUT  -s 10.0.1.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD  -s 10.0.1.0/29   -m state --state NEW  -j ACCEPT

    $IPTABLES -A INPUT  -s 10.0.2.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A OUTPUT  -s 10.0.2.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD  -s 10.0.2.0/29   -m state --state NEW  -j ACCEPT

    $IPTABLES -A INPUT  -s 10.0.3.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A OUTPUT  -s 10.0.3.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD  -s 10.0.3.0/29   -m state --state NEW  -j ACCEPT

    echo "Rule 3 (Port Forwarding Zeus SSH accessible from Tiger03 via Public IP)"
    $IPTABLES -A INPUT  ! -s 221.13.1.1 -p tcp --syn --dport 22 -m state --state NEW  -j REJECT
    $IPTABLES -A FORWARD -i eth3 -o eth1 -p tcp --syn --dport 22 ! -s 221.13.1.1 -m conntrack --ctstate NEW -j REJECT
    $IPTABLES -A FORWARD -i eth3 -o eth1 -p tcp --syn --dport 22 -s 221.13.1.1 -m conntrack --ctstate NEW -j ACCEPT
    $IPTABLES -A FORWARD -i eth3 -o eth1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    $IPTABLES -A FORWARD -i eth1 -o eth3 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    $IPTABLES -t nat -A PREROUTING -i eth3 -p tcp --dport 22 -s 221.13.1.1 -j DNAT --to-destination 10.0.2.2
    $IPTABLES -t nat -A POSTROUTING -o eth1 -p tcp --dport 22 -d 10.0.2.2 -j SNAT --to-source 10.0.2.1
}

reset_iptables_v4
script_body
