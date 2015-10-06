#!/bin/bash

insertarFecha(){
file=yyyy.mm.ch
#cuentos las lineas del archivo
cantLineas=`awk 'END{print NR}' yyyy.mm.ch`
#cuentos los separadores de la ultima linea
cantSeparadores=`awk -v cant=$cantLineas -F "|" 'NR==cant{print NF}' yyyy.mm.ch`
#si existiera un reporte previo lo borro
if [ "$cantSeparadores" = 5 ]; then
    sed -i "$ d" yyyy.mm.ch
fi
#limpio archivo reportes anual
limpiarArchivo=`> reporteanual`
cadena="$1|$2"  #concateno la fecha y horas que ingresa usuario 
cantHoras=`echo $cadena | awk -F "|" -f horas.awk` #calculo la cantidad de horas que trabajo redirecionando flujo
registro=$cadena"|"$cantHoras
echo $registro>>$file  #grabo en la ultima linea 
cat $file | awk -F "|" '{print substr($1,1,10)}' | sort -n -t "/"  -k3 -k2 -k1 -o $file $file  #ordeno el archivo
awk -v anioParametro=$4 -v mesParametro=$3 -F "|" -f reporte.awk yyyy.mm.ch   #creo reportes
}

scriptErrorParametro(){
clear
echo "Debe ingresar como minimo 3 parametros. Para mas informacion, utilice el help."
echo "Por ejemplo"
echo "bash ejercicio2.sh -h"
echo "bash ejercicio2.sh -help"
echo "bash ejercicio2.sh -?"
}
ofrecerAyuda(){
clear
echo "Debe pasarse como primer parametro una fecha y hora ingreso. Fecha y hora separados por '|'"
echo "Debe pasarse como segundo parametro una hora de finalizacion."
echo "Debe pasarse como tercer parametro un mes."
echo "Opcional, sirve para generar un reporte del año. De no hacerlo se usara el año actual "
echo "Para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "bash script.sh [-i] [-f] [-r] [-y] "
echo ""
echo ""
echo ""
echo "Ejemplos:"
echo 'bash ejercicio4.sh -i "20/04/2014|12:00:00" -f 20:00:00 -r 8 '
echo "en este caso, se usara el año actual"
echo ""
echo ""
echo ""
echo 'bash ejercicio4.sh -i "20/04/2014|12:00:00" -f 20:00:00 -r 8 -y 2011'
echo "en este caso,se generara un reporte segun el año"
exit 0
}


#validacion de parametros

if ([ $# -ge 2 ] && [ $# -le 5 ]) || [ $# -eq 0 ]
then  
  scriptErrorParametro
fi  

case $# in
1)
    if [ "$1" != "-i" -a $# -eq 1 ]; then
       if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]; then
         ofrecerAyuda
       else  
           scriptErrorParametro
       fi
    fi
;;
3)
    if [ "$3" != "-f" ]; then
      scriptErrorParametro
    fi
    ;;

5) 
    if [ "$5" != "-r" ]; then
      scriptErrorParametro
    fi
  ;;
6)
  #si no tengo el año como parametro
  if [ $# -eq 6 ];then 
       anio=`date +%Y`
  fi 
  ;;
7)
    if [ "$7" != "-y" -o $# -eq 7 ]; then
      scriptErrorParametro
    fi
  ;;
8)
  anio="$8"
  ;;
esac

    
    separadorHora2=${4//[^:]}  #valido la longitud de la hora de salida
    if [ ${#separadorHora2} != 2 ] 
    then
    echo "revisar hora parametro 4"
    scriptErrorParametro
    fi
    delimitador=${2//[^|]} #verifico que exista delimitador
    separadorFecha=${2//[^'/']} #verifico longitud de fecha
    separadorHora1=${2//[^:]} #verifico longitud de hora entrada
    if [ ${#delimitador} != 1 -o ${#separadorFecha} != 2 -o ${#separadorHora1} != 2 ]; then
    echo "revisar hora o fecha parametro 1"
    scriptErrorParametro
    fi

anualPath="./reporteanual"
if [ ! -e $anualPath ]; then
   touch $anualPath 2>/dev/null
   estado=$?
   if [ "$estado" != 0 ]; then
     echo no se pudo crear
     exit
   fi
elif [ ! -w  $anualPath -a ! -r $anualPath ]; then
   echo no tiene permisos sobre anual
   exit
fi

mesesPath="./yyyy.mm.ch"
if [ ! -e $mesesPath ]; then
  touch $mesesPath 2>/dev/null
  estado=$?
   if [ "$estado" != 0 ]; then
     echo no se pudo crear
     exit
   fi
elif [ ! -w  $mesesPath -a ! -r $mesesPath ]; then
   echo no tiene permisos sobre mensual
    exit
fi

fecha=${2:1:9} #extraigo la fecha que ingresa usuario
fechaArchivo=`grep $fecha $mesesPath`
if [ -n "$fechaArchivo" ];then
  echo La fecha ingresada ya existe en el archivo
  exit
else
  insertarFecha $2 $4 $6 $anio
fi
