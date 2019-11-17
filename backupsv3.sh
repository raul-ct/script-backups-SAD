#!/bin/bash
#Script de copia completa, diferencial e incremental
#Modificar directorios a respaldar y destino del Backup
echo hola
DIRECTORIOS=$(grep rutabackup params | cut -d$'\t' -f 2)
BACKUPDIR=$(grep backups params | cut -d$'\t' -f 2-)
echo hola2
#Politicas
com_pol=$(grep completa politica | cut -d$'\t' -f 2-)
dif_pol=$(grep diferencial politica | cut -d$'\t' -f 2-)
echo hola, has pasado las politicas
DSEM=`date +%a` ; # Dia semana
DMES=`date +%d` ; # Dia del mes
DYM=`date +%d%b`; # Dia y mes
FACT=`date --iso-8601`
ultimacompleta=$(tac log |grep completa | head -n 1 | cut -d" " -f 2)
ultimacopia=$(tac log | head -n 1 | cut -d" " -f 2)
echo "Hoy es $FACT";


#bucle politicas completa
for dia in $com_pol ;


do
                if [ $((DMES)) = $((dia)) ]
                then
echo $dia
        echo "se ve a realizar una copia total"
        echo "Creando contenedor"
        tar -zvcf "$FACT"_total.tar.gz $DIRECTORIOS
        echo "Moviendo el contenedor a la carpeta deseada"
        mv "$FACT"_total.tar.gz $BACKUPDIR;
        echo "completa "$FACT >> log
        exit
                fi
done

#bucle politicas diferenciales
for diff in $dif_pol ;
do
                if [ $((DMES)) = $((diff)) ]
                then
echo $dia
echo "se ve a realizar una copia diferencial"
        echo "Creando contenedor"
        tar -zvcf "$FACT"_diferencial.tar.gz $DIRECTORIOS -N $ultimacompleta
        echo "Moviendo el contenedor diferencial a la carpeta deseada"
        mv "$FACT"_diferencial.tar.gz $BACKUPDIR;
        echo "diferencial "$FACT >> log
        exit
                fi
done


#politicas incrementales
echo $dia
echo "se ve a realizar una copia incremental"
        echo "Creando contenedor"
        tar -zvcf "$FACT"_incremental.tar.gz $DIRECTORIOS -N $ultimacopia
        echo "Moviendo el contenedor incremental a la carpeta deseada"
        mv "$FACT"_incremental.tar.gz $BACKUPDIR;
         echo "incremental "$FACT >> log
echo $diff_pol
exit
