#!/bin/bash
# Indica el shell con que se debe ejecutar el script

########################################################################
# PROGRAM-ID.  ejercicio6.sh					       #
# OBJETIVO DEL PROGRAMA: filtre los productos que comienzan con	       # 
# una letra determinada.			                       #
# TIPO DE PROGRAMA: .sh                                                #
# ARCHIVOS DE ENTRADA: salida.txt                                      #
# ARCHIVOS DE SALIDA : N/A			                       #
# ALUMNOS : -Bogado, Sebastian                                         #
#           -Camacho, Manfred					       #
#           -Gonzalez, Gustavo                                         #
#           -Rey, Juan Cruz                                            #
#           -Valenzuela, Santiago 				       #
# COMENTARIOS: N/A						       #
# EjemploEj.:.	./Ejercicio_6.sh ./DocumentoA.txt ./DocumentoB.txt     #
########################################################################
#----------------------------------Funciones-----------------------------------------------
ModoDeUso()
{
	echo "Uso:" $0 "./DocumentoA.txt ./Documentob.txt"               	
	echo "Con -h o -? o -help esta ayuda"
	exit 1
} 

Error()
{
	echo "Error - Error en la cantidad de parametros."
	ModoDeUso
}

obtienePath() 
{
	pathCompletoPersonas=$1
	archivoPersonas=`basename $pathCompletoPersonas`
	directorioPersonas=`dirname $pathCompletoPersonas`

	pathCompletoAcronimos=$2
	archivoAcronimos=`basename $pathCompletoAcronimos`
	directorioAcronimos=`dirname $pathCompletoAcronimos`

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


############################### Programa Principal ########################################

#verificamos si la cantidad de argumentos es distinta de 1

if [ $# -ne 2 ]; then 
	Error #Error cantidad de parametros
fi

if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]; then
	ModoDeUso #Ayuda muestra modo de uso
fi

obtienePath $1 $2

######
if [ ! -d $directorioPersonas -o ! -d $directorioAcronimos ]; then 
	DirectorioInvalido
fi

if [ ! -w $directorioPersonas -o ! -w $directorioAcronimos ]; then
	echo "No posee permisos en el directorio"
	exit
fi

if [ ! -f $archivoPersonas -o ! -f $archivoAcronimos ]; then
	FicheroInvalido #Si no es un archivo regular
fi

if [ ! -r $archivoPersonas -o ! -r $archivoAcronimos ]; then
	echo "No se poseen los permisos necesarios sobre el archivo para continuar con la ejecucion del programa"
	exit 1
fi

if [ ! -s $archivoPersonas -o ! -s $archivoAcronimos ]; then
	echo "El archivo esta vacio"
	exit 1
fi

#$archivoAcronimos
awk -f prueba.awk $archivoPersonas 

awk -f prueba2.awk $archivoAcronimos
sleep 15
personas=`sort salida1`
acronimos=`sort salida2`
join -t'|' -12 <(sort -t'|'  $personas) $acronimos

