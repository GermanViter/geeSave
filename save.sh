#!/bin/bash

################################################################
#                                                              #
#           Gee save main script file                          #
#                                                              #
#                                                              #
################################################################

# 22 dec : add notification
#### progress
#### resume
#### colors

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

printF_ail() {
    echo "Backup failed"
    echo "Check logs: $LOGS"
    exit 1
}

if [[ ! -d "$SOURCE" ]]; then
	echo "Erreur: le dossier source n'existe pas"
	exit 1
fi

mkdir -p "$BACKUP_DIR"

rsync -av "$SOURCE/" "$BACKUP_DIR"
if [ $? -ne 0 ]; then
    echo "[$DATE] "$SOURCE/" : sync failed"
    printFail
fi

if [[ ! -z $BACKUP ]]; then
    tar -czf "$DEST/$BACKUP.tar.gz" -C "$DEST" "backup_$DATE"
else
    tar -czf "$BACKUP_DIR.tar.gz" -C "$DEST" "backup_$DATE"
fi

if [ $? -ne 0 ]; then
    echo "[$DATE] "$SOURCE/" : backup failed"
    print_Fail
fi

rm -r "$BACKUP_DIR"

echo "[$DATE] $BACKUP_DIR : succes" >> $LOGS
echo "[$DATE] $DEST/backup_$DATE.tar.gz : compressé" >> $LOGS

for OLD in $(ls -t $DEST | grep backup_ | tail -n +6); do
	rm -r "$DEST/$OLD"
	echo "[$DATE] Suppression : $OLD" >> $LOGS
done


echo "======================================"
echo "✅ Backup completed successfully"
if [[ ! -z "$BACKUP" ]]; then 
    echo "📦 Archive: $DEST/$BACKUP.tar.gz"
else
    echo "📦 Archive: $BACKUP_NAME.tar.gz"
fi
echo "🕒 Time: $DATE"
echo "======================================"

