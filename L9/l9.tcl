set val(chan)   Channel/WirelessChannel
set val(prop)   Propagation/TwoRayGround
set val(netif)  Phy/WirelessPhy
set val(mac)    Mac/802_11
set val(ifq)    CMUPriQueue
set val(ll)     LL
set val(ant)    Antenna/OmniAntenna
set val(x)      700
set val(y)      700  
set val(ifqlen) 50
set val(nn)     6
set val(stop)   60.0
set val(rp)     DSR

set ns_ [new Simulator]
set tl9 [open l9.tr w]
$ns_ trace-all $tl9

set nl9 [open l9.nam w]
$ns_ namtrace-all-wireless $nl9 $val(x) $val(y)

set prop [new $val(prop)]

$ns_ use-newtrace
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)


set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(rp) \
           -llType $val(ll) \
           -macType $val(mac) \
           -ifqType $val(ifq) \
           -ifqLen $val(ifqlen) \
           -antType  $val(ant) \
           -propType $val(prop) \
           -phyType $val(netif) \
           -channelType $val(chan) \
           -topoInstance $topo \
           -agentTrace ON \
           -routerTrace ON \
           -macTrace ON
           
for {set i 0} {$i < $val(nn) } {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0
    }
$node_(0) set X_ 150.0
$node_(0) set Y_ 300.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 300.0
$node_(1) set Y_ 500.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 500.0
$node_(2) set Y_ 500.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 300.0
$node_(3) set Y_ 100.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 500.0
$node_(4) set Y_ 100.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 650.0
$node_(5) set Y_ 300.0
$node_(5) set Z_ 0.0

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ initial_node_pos $node_($i) 30
    }

$ns_ at 4.0 "$node_(3) setdest 300.0 500.0 5.0"

$ns_ at 4.0 "$god_ set-dist 0 5 3"

set tcp [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp

set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(5) $sink

$ns_ connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns_ at 3.0 "$ftp start"

for {set i 0} {$i < 6 } {incr i} {
$ns_ at 60.000000 "$node_($i) reset";
}

proc finish {} {
	global ns_
	$ns_ flush-trace
	exec nam l9.nam &
	exit 0
}

$ns_ at 60.000000 "finish"
$ns_ run
