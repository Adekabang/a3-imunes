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
    # ================ IPv4


    # ================ Table 'filter', automatic rules
    # accept established sessions
    $IPTABLES -A INPUT   -m state --state ESTABLISHED,RELATED -j ACCEPT 
    $IPTABLES -A OUTPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT 
    $IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT


    # ================ Table 'nat',  rule set NAT
    # 
    # Rule 0 (NAT)
    # 
    echo "Rule 0 (NAT)"
    # 
    # Translate source address
    $IPTABLES -t nat -A POSTROUTING -o eth3 -j MASQUERADE
    $IPTABLES -A FORWARD -s 10.0.1.0/29 -o eth0 -j ACCEPT
    $IPTABLES -A FORWARD -s 10.0.2.0/29 -o eth0 -j ACCEPT
    $IPTABLES -A FORWARD -s 10.0.3.0/29 -o eth0 -j ACCEPT
    # for outgoing connections
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.1.0/29  -j SNAT --to-source 200.222.1.2
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.2.0/29  -j SNAT --to-source 200.222.1.2
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.3.0/29  -j SNAT --to-source 200.222.1.2
    # 

    echo "Rule 1 (Port Forward)"

    sysctl -w net.ipv4.ip_forward=1
    sysctl -p

    echo "Rule 2 (global)"
    # 
    # This permits access from internal net
    # to the Internet and DMZ
    $IPTABLES -A INPUT  -s 10.0.1.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A OUTPUT  -s 10.0.1.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD  -s 10.0.1.0/29   -m state --state NEW  -j ACCEPT

    $IPTABLES -A INPUT  -s 10.0.2.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A OUTPUT  -s 10.0.2.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD  -s 10.0.2.0/29   -m state --state NEW  -j ACCEPT

    $IPTABLES -A INPUT  -s 10.0.3.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A OUTPUT  -s 10.0.3.0/29   -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD  -s 10.0.3.0/29   -m state --state NEW  -j ACCEPT

    echo "Rule 3 (Port Forwarding TIGER03 to Zeus SSH)"
    $IPTABLES -t nat -A PREROUTING -i eth3 -p tcp --dport 22 -j DNAT --to-destination 10.0.2.2
    $IPTABLES -t nat -A POSTROUTING -o eth1 -p tcp --dport 22 -d 10.0.2.2 -j SNAT --to-source 10.0.2.1



}

reset_iptables_v4
script_body
