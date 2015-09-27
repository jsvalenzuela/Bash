#!/bin/awk
BEGIN{
	FS=",";
}
{
	personas[$3] = personas[$3] $1 "|"
}
END{
	for(key in personas){
	print key "|" personas[key] > "salida1"
}
}
