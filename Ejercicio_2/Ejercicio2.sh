#!/bin/bash/
# *******************************COMIENZA EL BLOQUE DE FUNCIONES
# ACLARACIONES ·$1 ES EL PRIMER PARAMETRO QUE SE PASA, SEA A LA FUNCION O A LA LLAMADA DEL ARCHIVO BASH
# ·LA VARIABLE ESPECIAL $# CONTIENE LA CANTIDAD DE PARAMETROS QUE SE LE PASO AL LLAMAR AL BASH
# ·Se puede poner clear para limpiar la pantalla
# -r si se puede leer... comprobar eso.
scriptErrorParametro(){
clear
echo "Debe ingresar aunque sea un parametro. Para mas informacion, utilice el help."
echo "Por ejemplo"
echo "bash ejercicio2.sh -h"
echo "bash ejercicio2.sh -help"
echo "bash ejercicio2.sh -?"
}
ofrecerAyuda(){
clear
echo "Debe pasarse como parametro el nombre del directorio de entrada y el de salida. Debe escapearse los espacios de la siguiente forma: '\ '"
echo "Para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "bash script.sh [archivo de entrada] [-i o -ni]"
echo ""
echo ""
echo ""
echo "Ejemplos:"
echo "bash ejercicio2.sh archivito.txt -i"
echo "en este caso, se ignora si es mayuscula o minuscula"
echo ""
echo ""
echo ""
echo "bash ejercicio2.sh archivito.txt -ni"
echo "en este caso, no ignora si es mayuscula o minuscula. Por defecto no se ignoran si son mayusculas o minusculas"
exit 0
}
comprobarAyuda(){
if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]
then
ofrecerAyuda
fi
return
}
upperCase(){
cadena=(`echo "$1" | tr [:lower:] [:upper:]`)
}
lowerCase(){
cadena=(`echo "$1" | tr [:upper:] [:lower:]`)
}
ComprobarArchivoRegular(){
if [ -f "$1" ]
then
TrabajarArchivo "$1"
fi
echo "$1 No existe o no es un archivo regular."
exit 0
}
ComprobarPermisos(){
if [ ! -r $1 ]
then
echo "No se poseen los permisos de lectura necesarios"
exit 0
fi
return
}



ComprobarCadena(){
if [ "$(echo $1 | grep -E '^[0-9]*$')" ]
then
return 1
fi
return 0
}

menasjeError(){
echo "$1"
}


pasarAminuscula(){
	echo "hola soy una minuscula"
}
archivoIgnorar(){
	#echo "$1"
	IFS='<<'
	declare -A array
	while read linea
	do
		upperCase "$linea"
		echo "$cadena"
		if [ "${array["$cadena"]}" = "" ]
		then
		array["$cadena"]="0"
		fi
	((array["$cadena"]=${array[$cadena]}+1))
	done < "$1"
	for hola in "${!array[@]}"
	do
	echo "$hola ${array[$hola]}"
	done
	IFS=' '

}


archivoSinIgnorar(){
echo "$1"
declare -A array
while read linea
do
	if [ "${array[$linea]}" = "" ]
	then
	array["$linea"]="0"
	fi
((array["$linea"]=${array[$linea]}+1))
done < "$1"
for hola in "${!array[@]}"
do
echo "$hola ${array[$hola]}"
done
}





# *******************************FINALIZA EL BLOQUE DE FUNCIONES
# *******************************COMIENZA EL BLOQUE DEL PROGRAMA
#PREGUNTO SI SE PASO MINIMAMENTE UN PARAMETRO
case $# in
1)
	comprobarAyuda
	archivoSinIgnorar "$1"
	;;
2)
	case "$2" in
	"-i") archivoIgnorar "$1"
	;;
	"-ni") 
		archivoSinIgnorar "$1"
		;;
*)
	mensajeError "Error en el segundo parametro utilice el help [-h]"
	;;
esac
;;
*)
scriptErrorParametro
;;
esac
