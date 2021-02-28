#create simulator
set ns [new Simulator]

#tracing simulator results
set tl3 [open l3.tr w]
$ns trace-all $tl3

#tracing NAM results
set nl3 [open l3.nam w]
$ns namtrace-all $nl3

#for Distance Vector (should be before creation of nodes)
$ns rtproto DV

#create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#connecting nodes
$ns duplex-link $n0 $n1 1.5Mb 5ms DropTail
$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n5 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail

#orientation
$ns duplex-link-op $n1 $n0 orient left-down
$ns duplex-link-op $n2 $n0 orient left-up
$ns duplex-link-op $n3 $n5 orient right-up
$ns duplex-link-op $n4 $n5 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n2 $n3 orient right

#create tcp agent
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

#create tcp receiver
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n4 $tcp1

#connect tcp agents
$ns connect $tcp0 $tcp1

#create ftp objects
set ftp [new Application/FTP]

#attach ftp with agent tcp0
$ftp attach-agent $tcp0

#for congestion window for ftp
set cl3 [open cl3.tr w]
proc PlotWindow {tcpSource f} {
 global ns
 set counter 0.01
 set currenttime [$ns now]
 set cwnd [$tcpSource set cwnd_]
 puts $f "$currenttime $cwnd"
 $ns at [expr $currenttime+$counter] "PlotWindow $tcpSource $f"
}

#schedule events for ftp
$ns at 0.2 "$ftp start"
$ns at 3.2 "$ftp stop"

#schedule congestion window for ftp
$ns at 0.2 "PlotWindow $tcp0 $cl3"

#Cut down of node line
$ns rtmodel-at 1.0 down $n1 $n4

#join of node line
$ns rtmodel-at 3.0 up $n1 $n4

#procedure finish
proc finish {} {
 global ns tl3 nl3
 $ns flush-trace
 close $tl3
 close $nl3
 exec nam l3.nam &
 exit 0
}

#schedule execution at procedure
$ns at 3.5 "finish"

#to run
$ns run
