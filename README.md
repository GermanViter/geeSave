# geeSave - Automatic Backup Script

## Description
`FileSaveProject` is a Bash script that automatically backs up a folder to a destination with:
- Efficient file copying using `rsync`
- Compression of backups into `.tar.gz` archives
- Automatic cleanup of old backups (keep only N most recent)
- Detailed logging for every step

This script is designed for Linux (Ubuntu) and works well inside a Docker container.

---

## Features

1. Backup a source folder to a destination  
2. Automatic compression of each backup into `.tar.gz`  
3. Automatic cleanup: keep only the N most recent backups  
4. Logging for each action (copy, compression, deletion)

---

## Prerequisites

- Ubuntu or another Linux distribution with Bash
- `rsync` installed:

```bash
sudo apt update
sudo apt install -y rsync
```

---

## Usage

1. Clone the repository:
```bash
git clone https://github.com/GermanViter/geeSave.git
cd geeSave
```

2. Create the source and destination folders if they don't exist:
```bash
mkdir -p /path/to/source/folder
mkdir -p /path/to/destination/folder
```

3. Run the script:
```bash
bash FileSaveProject.sh /path/to/source/folder /path/to/destination/folder [optional_backup_name]
```
- If you provide the optional third argument, the archive will be named using that string.
- If you omit the third argument, the script will create a name derived from the source folder path.

Example:
```bash
bash FileSaveProject.sh /home/alice/Project /home/alice/Backups project-backup
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
   - Compression is enabled by default using `tar -czf`. You can modify this in the script if you prefer another format.

4. Backup naming:
   - The script accepts an optional third argument to determine the backup archive name.
   - If no name is provided, the script will derive a name from the source path.
   - If a name is provided, the archive will be saved as `/path/to/destination/<NAME>.tar.gz`.

---

## Notes and fixes to original README
- Fixed an unclosed code block in the prerequisites section.
- Corrected typos (e.g., "argument") and wording.
- Clarified how the cleanup step works (example for keeping only N backups).
- Added concrete examples for running the script.

---

If you'd like, I can now:
- Commit this file to a branch named `fix/readme`,
- Push the branch, and
- Open a pull request titled "docs: fix README" with a short description summarizing the changes.

Please confirm if you want me to proceed, or tell me any edits you want first (branch name, PR title, or wording changes).
