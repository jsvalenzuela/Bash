#Funciones para eliminar espacios iniciales y finales de una cadena
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

{
	#separo la primer letra de la frase
	letra = substr(trim($0), 0, 1)

	#verifico que el caracter no sea nulo, sea una letra y además verifico si es minuscula
	if(letra != "" &&  match(letra, "[a-zA-Z]")  && letra == tolower(letra) ){
		#si la primer letra esta en minuscula, imprimo error
		printf ("%-6d %-30s %s\n",NR,substr(trim($0), 0, index(trim($0)," ")),"MAYUSCULAS")
	}
}