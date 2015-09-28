#!/bin/awk
BEGIN{
	FS=" ";
	campos=3;
}
{
{
	if($1!="" && $2!="" && $3!=""){
		#Validacion Acronimo de paises
		if(match($2,/[A-Z][A-Z]/)){
			if(NF == campos){
				#validacion de cantidad de campos del registro 
				acronimos[$2] = acronimos[$2] $3 "|"
			}
		}	
	}
}
}
END{
	for(key in acronimos){
	print key "|" acronimos[key] > "temp2"
	}
}
