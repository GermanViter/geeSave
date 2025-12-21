# FileSaveProject - Automatic Backup Script

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
 - git clone git@github.com:GermanViter/geeSave.git
 - cd geeSave
2. Create source folder and the destination for the save folders
 - mkdir Source/Folder/Example
 - mkdir Destination/Folder/Example
3. Run the script

## Customization

* Number of backups to keep: change N in the script (tail -n +N+1)
* Log path: modify the LOGS variable in the script
* Compression: enabled by default using tar -czf
