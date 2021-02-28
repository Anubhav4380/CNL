set ns [new Simulator -multicast on]

set tf [open 7.tr w]
$ns trace-all $tf

set nf [open 7.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$ns duplex-link $n0 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n7 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 10ms DropTail

set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

set g1 [Node allocaddr]
set g2 [Node allocaddr]

set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1
$udp1 set dst_addr_ $g1
$udp1 set dst_port_ 0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

set udp2 [new Agent/UDP]
$ns attach-agent $n1 $udp2
$udp2 set dst_addr_ $g2
$udp2 set dst_port_ 0
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2

set r1 [new Agent/Null]
$ns attach-agent $n5 $r1
$ns at 1.0 "$n5 join-group $r1 $g1"

set r2 [new Agent/Null]
$ns attach-agent $n6 $r2
$ns at 1.5 "$n6 join-group $r2 $g1"

set r3 [new Agent/Null]
$ns attach-agent $n7 $r3
$ns at 2.0 "$n7 join-group $r3 $g1"

set r4 [new Agent/Null]
$ns attach-agent $n5 $r4
$ns at 4.0 "$n5 join-group $r4 $g2"

set r5 [new Agent/Null]
$ns attach-agent $n6 $r5
$ns at 4.5 "$n6 join-group $r5 $g2"

set r6 [new Agent/Null]
$ns attach-agent $n7 $r6
$ns at 5.0 "$n7 join-group $r6 $g2"

$ns at 2.5 "$n5 leave-group $r1 $g1"
$ns at 3.0 "$n6 leave-group $r2 $g1"
$ns at 3.5 "$n7 leave-group $r3 $g1"

$ns at 5.5 "$n5 leave-group $r4 $g2"
$ns at 6.0 "$n6 leave-group $r5 $g2"
$ns at 6.5 "$n7 leave-group $r6 $g2"

$ns at 0.5 "$cbr1 start"
$ns at 0.5 "$cbr2 start"

$ns at 10.0 "finish"

$n1 label "S1"
$n2 label "S2"
$n5 label "R1"
$n6 label "R2"
$n7 label "R3"

proc finish {} {
	global ns nf tf
	$ns flush-trace
	close $tf
	close $nf
	exec nam 7.nam
	exit 0
}

$ns run
