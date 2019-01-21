#!/bin/bash
#Script de copia completa, diferencial e incremental
#Modificar directorios a respaldar y destino del Backup
DIRECTORIOS=/home/usu/*
DSEM=`date +%a` ; # Dia semana
DMES=`date +%d` ; # Dia del mes
DYM=`date +%d%b`; # Dia y mes
FACT=`date --iso-8601`
BACKUPDIR=/home/backups/
echo "Hoy es $FACT";
if [ $((DMES)) = $((1)) ] || [ $((DMES)) = $((11)) ] || [ $((DMES)) = $((21))  ]

then
        echo "se ve a realizar una copia total";
        echo "Creando contenedor";
        tar -zvcf total_"$FACT".tar.gz $DIRECTORIOS;
        echo "Moviendo el contenedor a la carpeta deseada";
        mv total_"$FACT".tar.gz $BACKUPDIR;
else
        if [ $((DMES)) -eq $((6)) ] || [ $((DMES)) -eq $((16)) ] || [ $((DMES)) -eq $((26)) ]
then

DIFF=`date --iso-8601 --date='-5 day'`
        echo "se ve a realizar una copia diferencial"
        echo "Creando tar.gz"
        tar -zvcf diferencial_"$FACT".tar.gz $DIRECTORIOS -N $DIFF
        echo "Moviendo el contenedor a la carpeta deseada"
        mv diferencial_"$FACT".tar.gz $BACKUPDIR
        echo "Diferencial completada"
       
else 
                echo "se ve a realizar una copia incremental"
                tar -zvcf incremental_"$FACT".tar.gz $DIRECTORIOS -N `date --iso-8601 --date='-1 day'`
                echo "Moviendo el contenedor a la carpeta deseada"
                mv incremental_"$FACT".tar.gz $BACKUPDIR
                echo "Incremental completada"
fi
fi
