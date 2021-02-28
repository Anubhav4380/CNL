BEGIN{
	count=0;
	res=0;
}

{
 if($1=="r" &&  $5=="tcp")
 {
  count+=$6;
 }
}

END{
	res=(8*count)/(1.8*1000000);
	print "Throughput=" res "Mbps";
}


