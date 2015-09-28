#!/bin/bash
# Indica el shell con que se debe ejecutar el script

########################################################################
# PROGRAM-ID.  ejercicio6.sh					                       #
# OBJETIVO DEL PROGRAMA: filtre los productos que comienzan con	       # 
# una letra determinada.			                                   #
# TIPO DE PROGRAMA: .sh                                                #
# ARCHIVOS DE ENTRADA: salida.txt                                      #
# ARCHIVOS DE SALIDA : N/A			                                   #
# ALUMNOS : -Bogado, Sebastian                                         #
#           -Camacho, Manfred					                       #
#           -Gonzalez, Gustavo                                         #
#           -Rey, Juan Cruz                                            #
#           -Valenzuela, Santiago 				                       #
# COMENTARIOS: N/A						                               #
# EjemploEj.:.	./Ejercicio_6.sh ./DocumentoA.txt ./DocumentoB.txt     #
########################################################################
#----------------------------------Funciones----------------------------------------------
ModoDeUso()
{
	echo "Uso:" $0 "./personas.file ./acronimos.file"               	
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


############################### Programa Principal #######################################

if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]; then
	ModoDeUso #Ayuda muestra modo de uso
fi

#verificamos si la cantidad de argumentos es distinta de 2
if [ $# -ne 2 ]; then 
	Error #Error cantidad de parametros
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

if [ ! -f $pathCompletoPersonas -o ! -f $pathCompletoAcronimos ]; then
	FicheroInvalido #Si no es un archivo regular
fi

if [ ! -r $pathCompletoPersonas -o ! -r $pathCompletoAcronimos ]; then
	echo "No se posee permiso de lectura sobre alguno de los archivos"
	exit 1
fi

if [ ! -s $pathCompletoPersonas -o ! -s $pathCompletoAcronimos ]; then
	echo "El archivo esta vacio"
	exit 1
fi

#ordeno el archivo personas por nombre, luego con personas.awk valido y agrupo a los 
#registros de acuerdo al pais de nacimiento y guardo el resultado en el archivo temp1
sort $pathCompletoPersonas | awk -f personas.awk 

#Elimino el pipe final del archivo temp1 que fue agregado en personas.awk y grabo en temp3
sed 's/|$//' temp1 > temp3

#valido los acronimos
awk -f acronimos.awk $pathCompletoAcronimos 

#Elimino las ciudades (registros que empiezan por C) y para los paises elimino el primer
#campo de los registros (P). Finalmente reemplazo los espacios por el separador "|" y 
#grabo los resultados en el archivo temp2
sed '/^C/d;s/^P //;s/ /|/' $pathCompletoAcronimos > temp2 

#Seteo mi nuevo separador interno de campos para usarlos con read
IFS="|"

#Leo temp2 mientras tenga registros (cada linea contiene dos campos acronimo|nombre)
while read acronimo nombre
do
	#Reemplazo el acronimo por su nombre en temp3
	sed -i "s/$acronimo/$nombre/" temp3
done < temp2

#ordeno temp3 por el pais y grabo la salida en salida.txt 
sort temp3 | awk -f grabar.awk > salida.txt

#Remuevo los archivos temporales
rm temp1
rm temp2
rm temp3

