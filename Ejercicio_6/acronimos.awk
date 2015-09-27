#!/bin/awk
BEGIN{
	FS=" ";
}
{
	acronimos[$2] = acronimos[$2] $3 "|"
}
END{
	for(key in acronimos){
	print key "|" acronimos[key] > "salida2"
}
}
