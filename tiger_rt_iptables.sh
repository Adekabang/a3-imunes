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
    # for outgoing connections
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.1.0/29  -j SNAT --to-source 200.222.1.2
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.2.0/29  -j SNAT --to-source 200.222.1.2
    $IPTABLES -t nat -A POSTROUTING -o eth3   -s 10.0.3.0/29  -j SNAT --to-source 200.222.1.2
    # 
}

# reset_iptables_v4
script_body