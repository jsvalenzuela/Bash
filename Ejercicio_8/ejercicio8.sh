#!/bin/bash
# Indica el shell con que se debe ejecutar el script
clear
########################################################################
# PROGRAM-ID.  ejercicio8.sh					                       #
# OBJETIVO DEL PROGRAMA: Mini-verificador ortográfico, que permite     #
# verificar el léxico utilizado en la redacción de un texto.           #
# TIPO DE PROGRAMA: .sh                                                #
# ARCHIVOS DE ENTRADA: texto.txt, diccionario.dic, [archivoSalida.txt] #
# ARCHIVOS DE SALIDA : errores.err			                           #
# ALUMNOS : -Bogado, Sebastian                                         #
#           -Camacho, Manfred					                       #
#           -Gonzalez, Gustavo                                         #
#           -Rey, Juan Cruz                                            #
#           -Valenzuela, Santiago 				                       #
# COMENTARIOS: N/A						                               #
# EjemploEj.:.	./ejercicio8.sh ./miTexto.file ./diccionario.file      #
########################################################################
#----------------------------------Funciones----------------------------------------------
ModoDeUso()
{
	echo "       Uso:" $0 "./texto.file ./diccionario.file [./salida.txt]"               
	echo "       Con -h o -? o -help esta ayuda"
	exit 1
} 

Error()
{
	echo "Error - Error en la cantidad de parametros."
	ModoDeUso
}

obtienePath() 
{
	pathCompletoTexto=$1
	texto=`basename $pathCompletoTexto`
	directorioTexto=`dirname $pathCompletoTexto`

	pathCompletoDiccionario=$2
	diccionario=`basename $pathCompletoDiccionario`
	directorioDiccionario=`dirname $pathCompletoDiccionario`

	pathCompletoSalida=$3
	salida=`basename $pathCompletoSalida`
	directorioSalida=`dirname $pathCompletoSalida`

}

DirectorioInvalido() 
{
	echo "Directorio a procesar inexistente"
	ModoDeUso
}

FicheroInvalido() 
{
	echo "Fichero a procesar inexistente"
	ModoDeUso
}


############################### Programa Principal #######################################

if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]; then
	ModoDeUso #Ayuda muestra modo de uso
fi

#verificamos si la cantidad de argumentos es distinta de 2 o 3
if [ $# -ne 2 -a $# -ne 3 ]; then 
	Error #Error cantidad de parametros
fi

#Si no se especifico el tercer parametro seteamos uno por defecto
if [ $# -eq 2 ]; then
		set $1 $2 "error.err" #set modifica los valores de los parametros
fi

obtienePath $1 $2 $3

######
if [ ! -d $directorioTexto -o ! -d $directorioDiccionario -o ! -d $directorioSalida ]; then 
	DirectorioInvalido
fi

if [ ! -w $directorioTexto -o ! -w $directorioDiccionario -o ! -w $directorioSalida ]; then 
	echo "No posee permisos en el directorio" 
	exit
fi

if [ ! -f $pathCompletoTexto -o ! -f $pathCompletoDiccionario ]; then
	FicheroInvalido #Si no es un archivo regular
fi

if [ ! -r $pathCompletoTexto -o ! -r $pathCompletoDiccionario ]; then
	echo "No se posee permiso de lectura sobre alguno de los archivos"
	exit 1
fi

if [ ! -s $pathCompletoTexto -o ! -s $pathCompletoDiccionario ]; then
	echo "El archivo esta vacio"
	exit 1
fi


#############################    PROGRAMA PRINCIPAL  #####################################
#Elimino los caracteres especiales
cat $pathCompletoTexto | sed -f eliminarCaracteres.sed > temp1

#Convierto los espacios en saltos de linea del texto, lo ordeno, elimino palabras
#repetidas ignorando case sensitive y guardo el resultado en temp1
tr ' ' '\n' <  temp1 | sort | uniq -i > temp3

#Ordeno el diccionario y lo almaceno en temp2
sort $pathCompletoDiccionario > temp2

#Comparo ambos archivos y me quedo solo con las palabras que no estan en el diccionario
#luego con awk elimino los numeros para tener solo palabras y almaceno en temp
comm -23 temp3 temp2 | awk '$0 ~ /[a-zA-Z]/ {print $0}' > temp

#Escribo la cabecera del archivo de salida
echo "LINEA  PALABRA                        ERROR" > $3

#Leo cada palabra de mi archivo temp (donde estan las palabras no encontradas en el 
#diccionario) y las busco en el texto original para obtener el nuemero de linea donde este
#el error y guardo en el archivo de salida
while read palabra
do
	awk -v pal=$palabra -f corregirOrtografia.awk $pathCompletoTexto >> $3
done < temp

#PRIMERA LETRA DE CASA FRASE EN MAYUSCULA
#Se toma como registro a las frases que terminen con punto o un salto de linea, y guarda 
#en la salida
awk -F "." -f corregirMayusculas.awk $pathCompletoTexto >> $3
awk -F "\n" -f corregirMayusculas.awk $pathCompletoTexto >> $3

#CORRECCION DE SIGNOS DE PUNTUACIon
awk -f corregirPuntuacion.awk  $pathCompletoTexto >> $3

#ordeno el archivo de salida de acuerdo a el numero de linea y elimino los duplicados 
#generados al corregir mayusculas dos veces
cat $3 > temp1
sort -n temp1 | uniq > $3

#verifico si hubo o no errores
if [[ $(wc -l < $3) = 1 ]]; then
	echo "SIN ERRORES" > $3
fi

rm temp
rm temp1
rm temp2
rm temp3