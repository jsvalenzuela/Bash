#!/bin/bash

BackUp()
{
	fecha_actual=$(date + "%d-%m-%y")
	Archivo_a_guardar="$path_destino$fecha_actual.tar.gz"
	tar -zcvf $Archivo_a_guardar $path_destino
}

play()
{
	echo "haciendo backup instantaneo de $path_origen a $path_destino"
	BackUp
}

count()
{
	read path_origen < /tmp/demfifo
	#Lista los archivos y los pasa a la tuberia al comando wc para contarlos
	Cantidad_de_archivos_backup=$(find $path_origen -type f -name "*.sh" | wc -l)
	echo "$Cantidad_de_archivos_backup" > /tmp/demfifo
}

func_clear()
{
	echo "Iniciando la funcion clear."
	echo "Borrando archivos de $path_destino"
	find $path_destino -name '*.sh'  -exec rm -f {} \;
}

iteracion()
{
	sleep $interval &
	wait $!
}

salir()
{
	if [ -e /tmp/demonio.pid ]
	then
		# El fichero PID existe
		if [ `cat /tmp/demonio.pid` -eq $$ ]
		then
			# El PID nos corresponde
			echo "borrando el fichero PID, porque es de esta ejecucion."
			rm -f /tmp/demonio.pid
		fi
	fi

	rm /tmp/demfifo
	exit 0
}

trap salir SIGTERM SIGKILL
trap count SIGUSR1
trap play SIGUSR2 
trap func_clear SIGALRM


echo "Iniciando demonio..."

### VERIFICO SI EL DEMONIO YA ESTA EN EJECUCION:
if [ ! -e /tmp/demonio.pid ]
then
	# no existe el fichero PID
	echo $$ > /tmp/demonio.pid
else
 	# El fichero PID existe
	if [ `cat /tmp/demonio.pid` -ne $$ ]
	then
		echo "Imposible ejecutar, este binario ya se está ejecutando."
		salir
	fi
fi
###

#recibo los parametros
read path_origen < "/tmp/datostemporales.txt"
path_destino=$(head -2 "/tmp/datostemporales.txt" | tail -1)
#intervalo de ejecucion de los backup
intervalo=$(head -3 "/tmp/datostemporales.txt" | tail -1)
#intervalo que uso con los sleeps
interval=1
#borro el archivo que uso como canal
rm "/tmp/datostemporales.txt"

#echo "El path origen es:$path_origen"
#echo "El path destino es: $path_destino"
#variable que marca el intervalo de ejecucion del demonio
#echo "el intevalo es: $interval"


echo "arrancando el demonio con PID=$$"

while true
do
	# hacer lo que sea
	echo "iteracion"
	# esperar
	echo "esperando $interval segundos"
	iteracion
	
	if [ $i -eq $intervalo ]
	then
		i=0
		play
	fi
	i=$((i+1))

done

##fin de demonio
