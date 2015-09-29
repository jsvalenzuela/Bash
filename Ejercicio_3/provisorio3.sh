#!/bin/bash

esArchivoDeBash(){

VAR1=$(sed -n 1p "$1" 2>>$2)
estado=$? 
hora=`date +%T%t`
fecha=`date +%d-%m-%y`
evento="$hora $fecha"
if [ "$estado" = 0 ]; then
   if [ "$VAR1" = '#!/bin/bash' ];then
     sed -i "$ a #$evento" $1 2>>$2 
     estado=$?
      #sino puedo agregarle ultima linea agrego fecha-hora log
      if [ "$estado" != 0 ];then  
        sed -i "$ s/sed/[$evento]/" $2
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
	mv $1 $nombre 2>>$2 
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

recorrer_directorio(){
 dir=$(dir -1)
 for file in $dir;
  do
# comprobamos que la cadena no este vacía
   if [ -n $file ]; then
    if [ -d "$file" ]; then
     cd $file
     
    # llamada a la función recorrer_directorio
     recorrer_directorio ./ $2
#salgo del directorio
     cd ..
       else
       esArchivoDeBash $file $2
    fi;
   fi;
 done;
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
recorrer_directorio $DIR $2
}



#fin bloque funciones

#compruebo la cantidad de parametros recibidos
if [ $# -lt 2 ]
then
  echo "Error en los parametros. Recuerde que minimamente necesita 2 parametros"
  exit
fi

#cadena va a contener el ultimo elemento que se paso por parametro
cadena="${!#}"
extencion=$(echo "$cadena" | rev | cut -d'.' -f1 | rev)
# COMPREUBO QUE EL ULTIMO PARAMETRO SEA .log
if [ "$extencion" != "log" ]
  then
  echo "El ultimo archivo debe ser un .log para mas informacion utilice el help con el parametro -h"
  exit 
fi
# aca terminan las primeras validaciones


if [ -f $1 ]; then
  esArchivoDeBash $1 $2
elif [ -d $1  ]; then 
   logDirectorio=`pwd`/$2 #envio el log asi ya que para recorrer directorio uso una funcion recursiva
   explorarDirectorio $1 $logDirectorio
else
  hora=`date +%T%t`
  fecha=`date +%d-%m-%y`
  evento="$hora $fecha"
  echo "[$evento]:'$FILE' es un directorio o carpeta inexistente" >> $2
fi
