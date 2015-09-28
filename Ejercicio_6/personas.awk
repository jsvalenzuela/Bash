#!/bin/awk
BEGIN{
	FS=","; #Cambio el separador de campos por defecto.
	campos=4;	#Nombre y Apellido ; Documento ; Direccion ; acronimo pais de nacimiento
}
{
	if($1!="" && $2!="" && $3!="" && $4!=""){ #verifico que los campos no esten vacios
		if(match($4,/[A-Z][A-Z]/)){ #verifico que el acronimo solo tenga dos mayusculas
			if(NF == campos){ #validacion de cantidad de campos del registro
				#concateno todos los registros que tengan el mismo acronimo en un array
				#asociativo, separados por un pipe.				 
				personas[$4] = personas[$4] $1 "|" 
			}
		}	
	}
}
END{
	#almaceno los registros agrupados por su acronimo en un archivo temporal
	for(key in personas){
		print key "|" personas[key] > "temp1" 
	}
}
