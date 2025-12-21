#!/bin/bash

################################################################
#                                                              #
#           Gee save main script file                          #
#                                                              #
#                                                              #
################################################################

command -v rsync >/dev/null 2>&1 || { echo "rsync not installed"; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "tar not installed"; exit 1; }
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

SOURCE=$1
DEST=$2
BACKUP=$3 

if [[ -z $SOURCE || -z $DEST ]]; then
        echo -e "${RED}Error: missing arguments${RESET}"
        exit 1;
fi

while [[ true ]]; do
   
    DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_DIR="$DEST/backup_$DATE"
    LOGS="/home/sshuser/geeSave/logs/backup.log"

    printF_ail() {
        echo "${RED}Backup failed${RESET}"
        echo "Check logs: $LOGS"
        exit 1
    }

    if [[ ! -d "$SOURCE" ]]; then
        echo -e "${RED}✖ Error: source directory does not exist${RESET}"
        break
    elif [[ -z "$(ls -A "$SOURCE")" ]]; then
        echo -e "${YELLOW}⚠ Source directory is empty${RESET}"
        break
    fi

    mkdir -p "$BACKUP_DIR"

#Copy the changes

    echo -e "${BLUE}Starting backup...${RESET}"
    rsync -av "$SOURCE/" "$BACKUP_DIR" # use rsync intead of cp
    if [ $? -ne 0 ]; then
        echo "[$DATE] "$SOURCE/" : sync failed" >> $LOGS
        printFail
    fi
    
    if [[ ! -z $BACKUP ]]; then
        tar -czf "$DEST/$BACKUP.tar.gz" -C "$DEST" "backup_$DATE" # with name
    else
        tar -czf "$BACKUP_DIR.tar.gz" -C "$DEST" "backup_$DATE" # without name
    fi

    if [ $? -ne 0 ]; then
        echo "[$DATE] "$SOURCE/" : backup failed" >> $LOGS
        print_Fail
    fi

    rm -r "$BACKUP_DIR"

    echo "[$DATE] $BACKUP_DIR : succes" >> $LOGS
    echo "[$DATE] $DEST/backup_$DATE.tar.gz : compressé" >> $LOGS
    
    for OLD in $(ls -t $DEST | grep backup_ | tail -n +6); do
    	rm -r "$DEST/$OLD"
    	echo "[$DATE] Suppression : $OLD" >> $LOGS
    done
    echo -e "${GREEN}Backup finished${RESET}"

    echo "======================================"
    echo -e "${GREEN}✔ Backup completed successfully${RESET}"
    if [[ ! -z "$BACKUP" ]]; then 
        echo "📦 Archive: $DEST/$BACKUP.tar.gz"
    else
    echo "📦 Archive: $BACKUP_NAME.tar.gz"
    fi
    echo "🕒 Time: $DATE"
    echo "======================================"
    break
done
