#!/bin/bash

func_start()
{
	path_origen=$1
	path_destino=$2
	intervalo=$3


	if [ ! -e /tmp/datostemporales.txt ]
	then
		rm /tmp/datostemporales.txt
	fi
	#si no existe el archivo significa que no se ejecuto entonces lo ejecuto
	if [ ! -e "/var/run/demonio.pid" ]; then
		#creo canal fifo de comunicacion
		

		touch /tmp/datostemporales.txt

		chmod +rwx /tmp/datostemporales.txt

		#echo "$path_origen" > /tmp/demfifo 
		#echo "$path_destino" > /tmp/demfifo
		#echo "$intervalo" > /tmp/demfifo
		echo $path_origen >> /tmp/datostemporales.txt
		echo $path_destino >> /tmp/datostemporales.txt
		echo $intervalo >> /tmp/datostemporales.txt
		echo "Ejecutando Daemond"
	   	/tmp/demonio.sh &
		pid_hijo=$!

	#Cuando creo el proceso , creo el canal de comunicacion que contiene el pid de ejecucion
	else
		echo "El proceso esta corriendo...Recuperando PID del demonio"
		#como esta ejecutado busco su pid
		pid_hijo=$(`cat /tmp/demonio.pid`)
	fi

	echo "el pid delproceso es " $pid_hijo
	wait $pid_hijo

}

func_stop()
{
	echo "Finalizando proceso..."
	#señal de STOP (19)
	kill -SIGTERM $pid_hijo
}

func_count()
{
	echo "$1" > /tmp/demfifo
	kill -SIGUSR1 $pid_hijo
	sleep 1
	read cantidad < /tmp/demfifo
	echo "la cantidad es: $cantidad"
	rm /tmp/demfifo
}

func_play()
{
	echo "iniciando backup instantaneo"
	kill -SIGUSR2 $pid_hijo
}

func_clear()
{
	echo "limpiando carpeta"
	kill -SIGALRM $pid_hijo
}


#si el demonio esta en ejecucion , cargo su PID
if [ -e /tmp/demonio.pid ]
then
		pid_hijo=`cat /tmp/demonio.pid`
fi

case "$1" in
start)
	func_start $2 $3 $4
;;
stop)
	#Envio señal para que finalice el proceso
	func_stop
;;
count)
	func_count $2
;;
clear)
	func_clear $2
;;
play)
	func_play
;;
#opcion por default
*)
	echo $"Se debe usar de la siguiente manera: $1 {start|stop|count|clear|play}"
esac
