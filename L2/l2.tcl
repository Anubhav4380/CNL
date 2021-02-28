#create simulator
set ns [new Simulator]

#tracing simulator results
set tl2 [open l2.tr w]
$ns trace-all $tl2

#tracing NAM results
set nl2 [open l2.nam w]
$ns namtrace-all $nl2

#create 6 nodes
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

#connecting nodes
$ns duplex-link $n1 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail

#orientation
$ns duplex-link-op $n3 $n1 orient left-up
$ns duplex-link-op $n3 $n2 orient left-down
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n4 $n6 orient right-down
$ns duplex-link-op $n3 $n4 orient right

#create tcp agent
set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0

#create tcp receiver
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n6 $tcp1

#create tcp agent
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

#create tcp receiver
set tcp3 [new Agent/TCPSink]
$ns attach-agent $n5 $tcp3

#connect tcp agents
$ns connect $tcp0 $tcp1

#connect tcp agents
$ns connect $tcp2 $tcp3

#create ftp objects
set ftp [new Application/FTP]

#attach ftp with agent tcp0
$ftp attach-agent $tcp0

#create telnet objects
set telnet [new Application/Telnet]

#attach telnet with agent tcp2
$telnet attach-agent $tcp2

#for congestion window for ftp
set cl2ftp [open cl2ftp.tr w]
proc PlotWindow {tcpSource f} {
 global ns
 set counter 0.01
 set currenttime [$ns now]
 set cwnd [$tcpSource set cwnd_]
 puts $f "$currenttime $cwnd"
 $ns at [expr $currenttime+$counter] "PlotWindow $tcpSource $f"
}

#for congestion window for telnet
set cl2tel [open cl2tel.tr w]
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
$ns at 2.0 "$ftp stop"

#schedule events for telnet
$ns at 0.2 "$telnet start"
$ns at 2.0 "$telnet stop"

#schedule congestion window for ftp
$ns at 0.2 "PlotWindow $tcp0 $cl2ftp"

#schedule congestion window for telnet
$ns at 0.2 "PlotWindow $tcp2 $cl2tel"

#procedure finish
proc finish {} {
 global ns tl2 nl2
 $ns flush-trace
 close $tl2
 close $nl2
 exec nam l2.nam &
 exit 0
}

#schedule execution at procedure
$ns at 2.5 "finish"

#to run
$ns run
