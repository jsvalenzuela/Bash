#!/bin/bash
recorrer_directorio()
{
 dir=$(dir -1)
 for file in $dir;
 do
# comprobamos que la cadena no este vacía
  if [ -n $file ]; then
   if [ -d "$file" ]; then
    cd $file
    # llamada a la función recorrer_directorio
    recorrer_directorio ./
#salgo del directorio
    cd ..
      else
      esArchivoDeBash 
   fi;
  fi;
 done;
}

esArchivoDeBash(){
VAR1=`sed -n 1p $1 2>>$2` #tomo la primera linea del 1er archivo
estado=$? 
hora=`date +%T%t`
fecha=`date +%d-%m-%y`
evento="$hora $fecha"
if [ "$estado" = 0 ]; then
   if [ "$VAR1" = '#!/bin/bash' ];then
     sed -i "$ a #$evento" $1 2>>$2 #cuando lo hice en un archivo aparte al codigo de esta funcion, este sed no me tiro error
     estado=$?
      #sino puedo agregarle ultima linea agrego fecha-hora log
      if [ "$estado" != 0 ];then  
        sed -i "$ s/sed/[$evento]/" facha.log 
      fi
        #busco la extension 
	ext=${1##*.}
        #corto la cadena hasta la extension
        archivo=${1%$ext}
        #si el archivo no tiene extension
        if [[ -z $archivo ]]; then
          nombre=${ext^^} #le asigno en mayusculas la extension
	else
          ext=${ext,,} #convierto la extension en minusculas
          archivo=${archivo^^} #convierto en mayusculas el nombre
          nombre=$archivo$ext #concateno el nombre y extension
	fi
	mv $1 $nombre 2>>facha.log 
        estado=$?
        #sino puedo renombrar
          if [ "$estado" != 0 ];then  
             sed -i "$ s/sed/[$evento]/" $2 
	  else
            sed -i "$ a [$evento]:$nombre" $2
          fi
    else
        echo "no es un script de bash"
    fi 
else
   #no se puede leer archivo que recibo
   sed -i "$ s/sed/[$evento]/" $2
fi
}

scriptErrorParametro(){
clear
echo "Debe ingresar aunque sea dos parametro. Para mas informacion, utilice el help."
echo "Por ejemplo"
echo "bash ejercicio4.sh -h"
echo "bash ejercicio4.sh -help"
echo "bash ejercicio4.sh -?"
}

ofrecerAyuda(){
clear
echo "Debe pasarse como parametro el nombre del directorio de entrada y el de salida. Debe escapearse los espacios de la siguiente forma: '\ '"
echo "Para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "bash script.sh [archivo de entrada o directorio] [-i o -ni]"
echo ""
echo ""
echo ""
echo "Ejemplos:"
echo ""
echo ""
echo ""
echo "bash ejercicio2.sh archivito.txt registro.log"

exit 0
}

comprobarAyuda(){
if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]
then
ofrecerAyuda
fi
return
}
explorarDirectorio(){
DIR=$1
cd $DIR
recorrer_directorio $DIR
}
#fin bloque funciones
FILE=$1
if [ -d $FILE ]; then
   esArchivoDeBash
elif [ -f $FILE  ]; then 
   explorarDirectorio
else
   echo "'$FILE' es un directorio o carpeta inexistente"
fi
