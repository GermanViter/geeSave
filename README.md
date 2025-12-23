# geeSave - Automatic Backup Script

## Description

geeSave is a small Bash script that automatically backs up a folder to a destination. It focuses on reliability and simplicity and provides:
- Efficient file copying using `rsync`
- Compression of backups into `.tar.gz` archives (not in 1.1)
- Automatic cleanup of old backups (keep only the N most recent)
- Detailed logging of each step

This script is designed for Linux (Ubuntu and other Debian-based distributions) and works well inside a Docker container.

---

## Features

1. Backup a source folder to a destination  
2. Automatic compression of each backup into `.tar.gz` (not in 1.1)
3. Automatic cleanup: keep only the N most recent backups  
4. Logging for each action (copy, compression, deletion)

---

## Prerequisites

- A Linux distribution with Bash (Ubuntu recommended)  
- `rsync` and `tar` installed (tar is not mandatory for 1.1)

Install prerequisites on Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y rsync tar
```

---

## Installation

There are two common ways to install and use geeSave.

### 1) Install from the release .deb (easy)

Download the .deb from the Releases page and install it with dpkg:

```bash
wget https://github.com/GermanViter/geeSave/releases/download/v1.1/geeSave.deb
sudo dpkg -i geeSave.deb
# If dpkg reports missing dependencies, fix them with:
sudo apt-get install -f
```

After installing the package, a system-wide command named `geeSave` will be available (or the package will install the script to a standard location). Run it as shown in the Usage section below.

### 2) Run from source (manual)

```bash
git clone https://github.com/GermanViter/geeSave.git
cd geeSave
```

You can run the script directly from the repository:

```bash
bash save.sh /path/to/source/folder /path/to/destination/folder [optional_backup_name]
```
You can also copy the script by copying it to the PATH 
```bash
sudo cp path/to/script.sh /usr/bin
```
Then you can add a symlink to make an executable
``` bash
sudo ln -s /usr/bin/save.sh /usr/bin/<name of executable>
```
---

## Usage

1. Create the source and destination folders if they don't exist:

```bash
mkdir -p /path/to/source/folder
mkdir -p /path/to/destination/folder
```

2. Run the script

If installed system-wide (from the .deb) or in PATH:

```bash
save /path/to/source/folder /path/to/destination/folder [optional_backup_name]
```

If running the bundled script directly:

```bash
bash save.sh /path/to/source/folder /path/to/destination/folder [optional_backup_name]
```

- If you provide the optional third argument, the archive will be named using that string.
- If you omit the third argument, the script will create a name derived from the source folder path.

Example:

```bash
bash save.sh /home/alice/Project /home/alice/Backups project-backup
# creates /home/alice/Backups/project-backup.tar.gz (and logs actions)
```

---

## Customization

1. Number of backups to keep:
   - Inside the script there is logic that removes older backups. Change the N value used there to keep more or fewer backups.
   - Example shell pattern to remove older archives and keep only the newest N (replace N with a number, DEST with your backup folder):

```bash
N=7
DEST="/path/to/destination"
ls -1t "$DEST"/*.tar.gz | tail -n +$((N+1)) | xargs -r rm -f
```

2. Log path:
   - Modify the `LOGS` variable in the script to change where logs are written.

3. Compression:
   - Compression is enabled by default using `tar -czf`. You can modify this in the script if you prefer another format. (not in 1.1)

4. Backup naming:
   - The script accepts an optional third argument to determine the backup archive name.
   - If no name is provided, the script will derive a name from the source path.
   - If a name is provided, the archive will be saved as `/path/to/destination/<NAME>.tar.gz`.
   - In 1.1, the saved folder wont be archived and will be name `/path/to/destination/<NAME>`.

---

## Troubleshooting

- If `dpkg -i` fails because of missing dependencies, run `sudo apt-get install -f` to install them and finish the installation.
- Make sure `rsync` and `tar` are installed and available in your PATH.
- Check the log file (see `LOGS` variable in the script) for detailed error information.


