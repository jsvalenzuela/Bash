#!/bin/awk
$1 ~ /[^PC]/ || length($1) != 1{
	print "ERROR (Registro " NR "): El tipo de registro debe ser \"P\" o \"C\""
}
$2 ~ /[^A-Z][^A-Z]/ || length($2) != 2{
	print "ERROR (Registro " NR "): El acronimo es incorrecto"
}
$3 ~ /[^A-Za-zñÑáéíóúÁÉÍÓÚ\- ]/{
	print "ERROR (Registro " NR "): El nombre del pais es invalido"
}