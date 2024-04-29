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

    echo "Rule 0 (RIP)"
    # RIP between FW and ISP
    $IPTABLES -A OUTPUT -p udp -m udp  -s 1.1.1.1   -d 1.1.1.2   --dport 520  -m state --state NEW  -j ACCEPT
    $IPTABLES -A INPUT -p udp -m udp  -s 1.1.1.2   -d 1.1.1.1   --dport 520  -m state --state NEW  -j ACCEPT

    echo "Rule 1 (HTTP Thor)"
    $IPTABLES -A OUTPUT -p tcp -m tcp  -d 200.222.1.4   --dport 80  -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD -p tcp -m tcp  -d 200.222.1.4   --dport 80  -m state --state NEW  -j ACCEPT

    echo "Rule 2 (FTP Dedalus)"
    $IPTABLES -A OUTPUT -p tcp -m tcp  -d 200.222.1.3   --dport 21  -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD -p tcp -m tcp  -d 200.222.1.3   --dport 21  -m state --state NEW  -j ACCEPT

    echo "Rule 3 (SSH Zeus)"
    $IPTABLES -A OUTPUT -p tcp -m tcp  -d 200.222.1.2   --dport 22  -m state --state NEW  -j ACCEPT
    $IPTABLES -A FORWARD -p tcp -m tcp  -d 200.222.1.2   --dport 22  -m state --state NEW  -j ACCEPT
}

reset_iptables_v4
script_body
