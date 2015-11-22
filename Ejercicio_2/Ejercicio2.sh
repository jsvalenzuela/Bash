#!/bin/bash/




# *******************************COMIENZA EL BLOQUE DE FUNCIONES
# ACLARACIONES ·$1 ES EL PRIMER PARAMETRO QUE SE PASA, SEA A LA FUNCION O A LA LLAMADA DEL ARCHIVO BASH
# ·LA VARIABLE ESPECIAL $# CONTIENE LA CANTIDAD DE PARAMETROS QUE SE LE PASO AL LLAMAR AL BASH
# -r si se puede leer... comprobar eso.
scriptErrorParametro(){
echo " "
echo "Debe ingresar aunque sea un parametro. Para mas informacion, utilice el help."
echo "Por ejemplo"
echo "bash ejercicio2.sh -h"
echo "bash ejercicio2.sh -help"
echo "bash ejercicio2.sh -?"
}
ofrecerAyuda(){
echo " "
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
	IFS='°'
	cadena=(`echo "$1" | tr [:lower:] [:upper:]`)
	IFS=" "
}
lowerCase(){
	IFS='°'
	cadena=(`echo "$1" | tr [:upper:] [:lower:]`)
	IFS=" "
}

archivoIgnorar(){
	declare -A array
	#voy leyendo las lineas y en caso de haber coincidencia las empiezo a incrementar
	while read linea
	do
		echo "$linea"
		#llamo a esta funcion que las pasa magicamente a mayuscula
		upperCase "$linea"
		#Si el esa posición del array esta vacía, significa que no hay absolutamente una linea hasta ese momento y la pone en cero. Porque sino, produce error
		if [ "${array["$cadena"]}" = "" ]
		then
			array["$cadena"]="0"
		fi
	((array["$cadena"]=${array[$cadena]}+1))
	done < "$1"
	for k in "${!array[@]}"
	do
		echo ${array["$k"]}'.'$k  
	# funciona medio raro... -r implica que se ordena a la inversa, -n que se utiliza los numeros o el peso si se quiere decir -k@ indica cual es el campo por el cual va a ser evaluado
	done | sort -rn -k1
	IFS=" "
}


archivoSinIgnorar(){
declare -A array
while read linea
do
	echo "Son todos cagones"
	if [ "${array[$linea]}" = "" ]
	then
		array["$linea"]="0"
	fi
	((array["$linea"]=${array[$linea]}+1))
done < "$1"

declare -a arrayNumerico
declare -a arrayPalabras
i=0
	for k in "${!array[@]}"
	do
		arrayPalabras["$i"]=$k  
		((arrayNumerico["$i"]=${array["$k"]}))
		((i++))
	done
	ordenar
	for((i=0;i<longitud;i++))
	do
		echo arrayNumerico["$i"] "...." arrayPalabras["$i"]
	done
}


ordenar(){
	declare -i posMax
	longitud=${#arrayNumerico[@]}
	auxiliarNumero=0
	auxiliarPalabra=""
	for((i=0;i<longitud;i++))
	do
		posMax=$i
		for((j=i;j<longitud;j++))
		do
			if (("${arrayNumerico["$j"]}" >= "${arrayNumerico["$posMax"]}"))
			then
				if [ "${arrayPalabras["$j"]}" < "${arrayPalabras["$posMax"]}" ]
				then
					posMax=$j
				fi	
			fi
		done
		auxiliarNumero=${arrayNumerico["$i"]}
		auxiliarPalabra=${arrayPalabras["$i"]}
		arrayNumerico["$i"]=${arrayNumerico["$posMax"]}
		arrayPalabras["$i"]=${arrayPalabras["$posMax"]}
		arrayNumerico["$posMax"]=auxiliarNumero
		arrayPalabras["$posMax"]=auxiliarPalabra
	done
}

verificarPermisosDeLectura(){
	if [ -r $1 ]
	then 
		echo "$1 tiene permisos de lectura"
		return
	fi
	echo "$1 no tiene permisos de lectura, por favor verifique los permisos y cambielos en caso de que sea deseado ser procesado ese archivo"
	exit
}

# *******************************FINALIZA EL BLOQUE DE FUNCIONES
# *******************************COMIENZA EL BLOQUE DEL PROGRAMA
#PREGUNTO SI SE PASO MINIMAMENTE UN PARAMETRO
case $# in
1)
	comprobarAyuda
	verificarPermisosDeLectura "$1"
	archivoSinIgnorar "$1"
	;;
2)
	case "$2" in
	"-i") 	verificarPermisosDeLectura "$1"
			archivoIgnorar "$1"
	;;
	"-ni") 	verificarPermisosDeLectura "$1"
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
