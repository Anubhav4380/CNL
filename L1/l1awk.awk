BEGIN{
	tcp_r=0
	tcp_d=0
	
	udp_r=0
	udp_d=0
}

{
	if($1=="r" && $5=="tcp")
		tcp_r++
	
	if($1=="d" && $5=="tcp")
		tcp_d++
	
	if($1=="r" && $5=="cbr")
		udp_r++
	
	if($1=="d" && $5=="cbr")
		udp_d++
}

END{
	print "TCP Received count is "tcp_r
	print "TCP Dropped count is "tcp_d
	
	print "UDP Received count is "udp_r
	print "UDP Dropped count is "udp_d
}
