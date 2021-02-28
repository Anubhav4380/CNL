#create simulator
set ns [new Simulator]

#tracing simulator results (.tr)
set tl1 [open l1.tr w]
$ns trace-all $tl1

#tracing NAM results (.nam)
set nl1 [open l1.nam w]
$ns namtrace-all $nl1

#create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#connecting nodes n0-n2, n1-n2, n2-n3
$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns queue-limit $n0 $n2 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5

#create tcp agent
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

#create tcp receiver
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n3 $tcp1

#create udp agent
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

#create udp receiver
set null [new Agent/Null]
$ns attach-agent $n3 $null

#connect tcp agents
$ns connect $tcp0 $tcp1

#connect udp agents
$ns connect $udp $null

#create ftp objects
set ftp [new Application/FTP]

#attach ftp with agent tcp0
$ftp attach-agent $tcp0

#create cbr objects
set cbr [new Application/Traffic/CBR]

#attach cbr with agent udp
$cbr attach-agent $udp

#schedule events for ftp
$ns at 0.2 "$ftp start"
$ns at 2.0 "$ftp stop"

#schedule events for cbr
$ns at 0.2 "$cbr start"
$ns at 2.0 "$cbr stop"

#procedure finish to flush out packets
proc finish {} {
 global ns tl1 nl1
 $ns flush-trace
 close $tl1
 close $nl1
 exec nam l1.nam &
 exit 0
}

#schedule execution at procedure
$ns at 2.5 "finish"

#to run Simulator
$ns run
