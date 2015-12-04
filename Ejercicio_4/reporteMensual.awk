BEGIN{
   split("enero_febrero_marzo_abril_mayo_junio_julio_agosto_septiembre_octubre_noviembre_diciembre",mesesArray,"_")
}
{
	split($0,a,"|")
	print "Mes: $mes "
}

