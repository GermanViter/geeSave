# geeSave - Automatic Backup Script

## Description
`FileSaveProject` is a Bash script that automatically backs up a folder to a destination with:  
- Efficient file copying using **rsync**  
- Compression of backups into `.tar.gz` archives  
- Automatic cleanup of old backups  
- Detailed logging for every step

This script is designed for Linux (Ubuntu) and works well inside a **Docker container**.

---

## Features

1. **Backup a source folder to a destination**  
2. **Automatic compression** of each backup into `.tar.gz`  
3. **Automatic cleanup**: keep only the N most recent backups  
4. **Logging** for each action (copy, compression, deletion)  

---

## Prerequisites

- Ubuntu or a Linux distribution with Bash  
- `rsync` installed:
```bash
sudo apt update
sudo apt install -y rsync

## Usage

1. Clone the repository
 - git clone https://github.com/GermanViter/geeSave.git
 - cd geeSave
2. Create source folder and the destination for the save folders
 - mkdir Source/Folder/Example
 - mkdir Destination/Folder/Example
3. Run the script

---

## Customization

1. **Number of backups to keep: change N in the script (tail -n +N+1)**
2. **Log path: modify the LOGS variable in the script**
3. **Compression: enabled by default using tar -czf**
4. **A third arfument can be used to determine the name of the backup.**
   If no name is used, the name of the .tar.gz archive will contain "path/to/folder.tar.gz".**
   Else, the name will be "path/to/folder/$NAME.tar.gz"
