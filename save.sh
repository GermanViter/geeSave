#!/bin/bash

command -v rsync >/dev/null 2>&1 || { echo "rsync not installed"; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "tar not installed"; exit 1; }

SOURCE=$1
DEST=$2
BACKUP=$3

if [[ -z $SOURCE || -z $DEST ]]; then
	echo "Erreur: le programme a besoins de deux arguments pour fonctionner"
	exit 1;
fi

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$DEST/backup_$DATE"
LOGS="/home/sshuser/geeSave/logs/backup.log"

if [[ ! -d "$SOURCE" ]]; then
	echo "Erreur: le dossier source n'existe pas"
	exit 1
fi

mkdir -p "$BACKUP_DIR"

rsync -av
"$SOURCE/" "$BACKUP_DIR"
if [[ ! -z $BACKUP ]]; then
    tar -czf "$DEST/$BACKUP.tar.gz" -C "$DEST" "backup_$DATE"
else
    tar -czf "$BACKUP_DIR.tar.gz" -C "$DEST" "backup_$DATE"
fi
rm -r "$BACKUP_DIR"

echo "[$DATE] $BACKUP_DIR : succes" >> $LOGS
echo "[$DATE] $DEST/backup_$DATE.tar.gz : compressé" >> $LOGS

for OLD in $(ls -t $DEST | grep backup_ | tail -n +6); do
	rm -r "$DEST/$OLD"
	echo "[$DATE] Suppression : $OLD" >> $LOGS
done




echo "sauvegarde terminee avec succes : $BACKUP_DIR.tar.gz"
