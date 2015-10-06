BEGIN{
   resultado=0
   diasCantidadReporteMes=0
   #cadena="ene_feb_mar_abr_may_jun_jul_ago_sep_oct_nov_dic"
   split("ene_feb_mar_abr_may_jun_jul_ago_sep_oct_nov_dic",mesesArray,"_")
   mesAnterior=0
   
}
{
    split($1,fechaCampo,"/")
    split( $4,horas,":" )
    #reporteAnual
    if( fechaCampo[3] == anioParametro)
    {
       #armo un array del reporte anual
       if( fechaCampo[2] > mesAnterior) #condicion de corte para acumular
       {
            mesAnterior = fechaCampo[2] 
            segundosMes[mesAnterior]=0
            diasTrabajadosMes[mesAnterior]=0
       }
       segundosMes[mesAnterior]+=horas[1]*3600+horas[2]*60+horas[3]
       diasTrabajadosMes[mesAnterior]++
    }
    #reportemensual
    if( fechaCampo[2] == mesParametro && fechaCampo[3] == anioParametro )
    {        
         resultado+=horas[1]*3600+horas[2]*60+horas[3]
	 diasCantidadReporteMes++
	 #exit 
    }   
}
END{

  
  #reporte anual
  for(mesLoop=1;mesLoop<=12;mesLoop++)
  {
    if(segundosMes[mesLoop]=="")
        printf("Mes: %s-%d no se encontraron registros del mes\n",mesesArray[mesLoop],mesLoop)>>"reporteanual"
    else
      armarReporte(diasTrabajadosMes[mesLoop],mesesArray[mesLoop],mesLoop,segundosMes[mesLoop],"reporteanual")
        #print segundosMes[mesLoop]
  }
  #reporte mes
  if(resultado == 0)
  {
     printf("Mes: %s-%d|Dias trabajados: -| Horas estimadas: - | Horas reales: -|Diferencia: -",mesesArray[mesParametro],mesParametro)>>"yyyy.mm.ch"    
  }
  else
  {
      
     horasTrabajadas=int(resultado/3600)
     minTrabajados=int((resultado - 3600*horasTrabajadas)) / 60
     segTrabajados=int(resultado %  3600)- int(minTrabajados) * 60 
     horasEstimadas=diasCantidadReporteMes * 8
     diferencia= resultado - horasEstimadas * 3600 
     horaDiferencia=int(diferencia/3600) 
     minDiferencia= int((diferencia - 3600 * horaDiferencia )/60)
     segDiferencia= int((diferencia %  3600)- (minDiferencia * 60))
     printf("Mes: %s-%2d|Dias trabajados: %d|Horas estimadas: %02d:00:00|Horas reales: %02d:%02d:%02d|Diferencia: %02d:%02d:%02d", mesesArray[mesParametro], mesParametro,diasCantidadReporteMes, horasEstimadas, horasTrabajadas,
     minTrabajados,segTrabajados,horaDiferencia, minDiferencia,segDiferencia)>>"yyyy.mm.ch"   
   }  #armarReporte(diasCantidadReporteMes,mesesArray[mesParametro],mesParametro,resultado,"mensual")
}



function armarReporte( diasTrabajados,nombreMes, numeroMes, segundosTotal, archivoPath)
{
  
  horasTrabajadas=int(segundosTotal/3600)
  minTrabajados=int((segundosTotal - 3600*horasTrabajadas)) / 60
  segTrabajados=int(segundosTotal %  3600)- int(minTrabajados) * 60 
  horasEstimadas=diasTrabajados * 8
  diferencia= segundosTotal - horasEstimadas * 3600 
  horaDiferencia=int(diferencia/3600) 
  minDiferencia= int((diferencia - 3600 * horaDiferencia )/60)
  segDiferencia= int((diferencia %  3600)- (minDiferencia * 60))
  printf("Mes: %s-%2d|Dias trabajados: %d|Horas estimadas: %02d:00:00|Horas reales: %02d:%02d:%02d|Diferencia: %02d:%02d:%02d\n", nombreMes, numeroMes,diasTrabajados, horasEstimadas, horasTrabajadas,
   minTrabajados,segTrabajados,horaDiferencia, minDiferencia,segDiferencia)>>archivoPath
  #printf("DiasTrabajados%d :horas %02d:minutos%02d:segundos%02d\n",diasTrabajados,horasTrabajadas,minTrabajados,segTrabajados)
}
