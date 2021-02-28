BEGIN{
	hdrsize =0;
	recdsize=0;
	starttime=400;
	stoptime=0;
}

{
	event=$1;
	time=$2;
	node_id=$3;
	pkt_size=$8;
	level=$4;
	if(level=="AGT" && event=="s" && pkt_size>=512)
	{
	 if(time<starttime)
	 {
	  starttime=time;
	 }
	}
	if(level=="AGT" && event=="r" && pkt_size>=512)
	{
	 if(time>starttime)
	 {
	  stoptime=time;
	 }
	 hdr_size=pkt_size%512;
	 pkt_size-=hdr_size;
	 recdsize+=pkt_size;
	}
}

END{
	printf("average Throughput = %2f",(recdsize/(stoptime-stattime)*(8/1000)));
}
