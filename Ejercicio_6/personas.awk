#!/bin/awk
BEGIN{
	FS=",";
	campos=3;	
}
{
	#Validacion campos vacios
	if($1!="" && $2!="" && $3!=""){
		#Validacion acronimos
		if(match($3,/[A-Z][A-Z]/)){
			if(NF == campos){
				#validacion de cantidad de campos del registro 
				personas[$3] = personas[$3] $1 "|"
			}
		}	
	}
}
END{
	for(key in personas){
	print key "|" personas[key] > "temp1"
}
}
