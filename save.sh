#!/bin/bash

SOURCE="/tmp/sources_text"
DEST="/tmp/sauvegardes"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$DEST/backup_$DATE"

if [[ ! -d "$SOURCE" ]]; then
	echo "Erreur: le dossier source n'existe pas"
	exit 1
fi

mkdir -p "$BACKUP_DIR"

cp -r "$SOURCE/" "$BACKUP_DIR"

echo "sauvegarde terminee avec succes : $BACKUP_DIR"
