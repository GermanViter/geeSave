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
BACKUP_NAME=$3 
USER=$(whoami)

if [[ -z $SOURCE || -z $DEST ]]; then
        echo -e "${RED}Error: missing arguments${RESET}"
        exit 1;
fi

# log file
sudo mkdir -p /var/log/geeSave/
sudo touch /var/log/geeSave/backup.log
sudo chown -R $USER:$USER /var/log/geeSave
sudo chmod 755 /var/log/geeSave
sudo chmod 644 /var/log/geeSave/backup.log



 DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_DIR="$DEST/backup_$DATE"
    LOGS="/var/log/geeSave/backup.log"

    printFail() {
        echo "${RED}Backup failed${RESET}"
        echo "Check logs: $LOGS"
        exit 1
    }

    if [[ ! -w "$LOGS" ]]; then
        echo "Error: cannot write to log file $LOGS"
        exit 1
    fi

while [[ true ]]; do

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
        echo "[$DATE] "$SOURCE/" : sync failed" | sudo tee -a "$LOGS" > /dev/null
        printFail
    fi
    
    echo "[$DATE] $BACKUP_DIR : succes" | sudo tee -a "$LOGS" > /dev/null    
    for OLD in $(ls -t $DEST | grep backup_ | tail -n +2); do
    	rm -r "$DEST/$OLD"
    	echo "[$DATE] Suppression : $OLD" | sudo tee -a "$LOGS" > /dev/null
    done
    echo -e "${GREEN}Backup finished${RESET}"

    echo "======================================"
    echo -e "${GREEN}✔ Backup completed successfully${RESET}"
    echo -e "Folder: $BACKUP_DIR"
    echo -e "Source folder: $SOURCE"
    echo -e "Destination: $DEST"
    echo "🕒 Time: $DATE"
    echo "======================================"
    break
done
