#create simulator
set ns [new Simulator]

#tracing simulator results
set tl4 [open l4.tr w]
$ns trace-all $tl4

#tracing NAM results
set nl4 [open l4.nam w]
$ns namtrace-all $nl4

#create 6 nodes
set n0 [$ns node]
set n1 [$ns node]

#connecting nodes
$ns duplex-link $n0 $n1 10Mb 22ms DropTail

#orientation
$ns duplex-link-op $n0 $n1 orient right

#create tcp agent
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

#create tcp receiver
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp1

#connect tcp agents
$ns connect $tcp0 $tcp1

#create ftp objects
set ftp [new Application/FTP]

#attach ftp with agent tcp0
$ftp attach-agent $tcp0

#to set packet size
$tcp0 set packetsize_ 1500

#schedule events for ftp
$ns at 0.2 "$ftp start"
$ns at 4.0 "$ftp stop"

#procedure finish
proc finish {} {
 global ns tl4 nl4
 $ns flush-trace
 close $tl4
 close $nl4
 exec nam l4.nam &
 exit 0
}

#schedule execution at procedure
$ns at 4.5 "finish"

#to run
$ns run
