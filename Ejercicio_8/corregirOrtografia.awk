{
	i=0
	while(i<NF ){
		if($i == pal){
			printf ("%-6d %-30s %s\n",NR,pal,"ORTOGRAFIA")
			i=NF
		}
		i++
	}
}