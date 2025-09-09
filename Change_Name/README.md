# Pulsar Board Device Text Update Script

This script updates the default device text shown on the Pulsar board.  
It modifies the system identification files and login banner messages to reflect **AICRAFT** branding.  

---

## Features
- Updates `/etc/issue` and `/etc/issue.net` to show:
  ```
  AICRAFT Pulsar
  ```
- Updates `/etc/os-release` to set:
  ```
  PRETTY_NAME="AICRAFT"
  ```
- Updates `/etc/update-motd.d/00-header` to set:
  ```
  SDK_DESCRIPTION="Welcome to AICRAFT main (custom based on ubuntu 20.04)"
  ```
- Cleans `/etc/update-motd.d/10-help-text` by removing all `printf` statements.  
- Creates `.bak` backups of all modified files before making changes.  
- Prints `"Update failed, please try manual."` if any command fails.

---

## Usage

1. Clone this repository to your Pulsar board:
   ```bash
   git clone <your-repo-url>
   cd <your-repo-folder>
   ```

2. Make the script executable:
   ```bash
   chmod +x update_device_text.sh
   ```

3. Run the script:
   ```bash
   ./update_device_text.sh
   ```

4. Follow the prompt:
   - Type `yes` (or `y`) to update the device text.  
   - Type `no` (or `n`) to skip.  

---

## Backup and Rollback
- The script automatically creates backups before making changes:
  - `/etc/issue.bak`
  - `/etc/issue.net.bak`
  - `/etc/os-release.bak`
  - `/etc/update-motd.d/00-header.bak`
  - `/etc/update-motd.d/10-help-text.bak`

- To restore any file manually, copy the backup back to its original location:
  ```bash
  sudo cp /etc/issue.bak /etc/issue
  sudo cp /etc/issue.net.bak /etc/issue.net
  sudo cp /etc/os-release.bak /etc/os-release
  sudo cp /etc/update-motd.d/00-header.bak /etc/update-motd.d/00-header
  sudo cp /etc/update-motd.d/10-help-text.bak /etc/update-motd.d/10-help-text
  ```

---

## Notes
- This script is intended for **brand new Pulsar board setup**.  
- Ensure you have `sudo` privileges before running the script.  
- If the script fails, follow the error message and try updating manually.  

---

## License
This project is licensed under the [BSD 3-Clause License](LICENSE).
