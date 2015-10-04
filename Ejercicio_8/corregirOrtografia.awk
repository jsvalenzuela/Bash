#Este script recibe de parametro "pal" que es una palabra que no se encuentra en el
#diccionario.
{
	i=0
	#Recorro toda la linea del archivo original
	while(i<NF ){
		#si una palabra del texto original coincide con "pal" entonces imprimo la linea
		#con el tipo de error
		if($i == pal){
			printf ("%-6d %-30s %s\n",NR,pal,"ORTOGRAFIA")
			i=NF
		}
		i++
	}
}