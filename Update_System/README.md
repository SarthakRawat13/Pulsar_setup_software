# Pulsar Board Setup - System Update Script

This repository contains a simple Bash script to assist with updating the Linux system on a brand new Pulsar board.  
The script is interactive and ensures the user decides whether to update or skip the process.

---

## Features
- Prompts the user to confirm if they want to update the system.
- Runs the necessary update and upgrade commands for Debian/Ubuntu-based systems.
- Handles errors gracefully by showing a message to try a manual update if the automated process fails.
- Designed for **first-time setup** on a new board.

---

## Prerequisites
- Linux-based operating system (Debian/Ubuntu recommended).  
- `sudo` privileges on the board.  

---

## Usage

1. Clone this repository to your Pulsar board:
   ```bash
   git clone <your-repo-url>
   cd <your-repo-folder>
   ```

2. Make the script executable:
   ```bash
   chmod +x update_system.sh
   ```

3. Run the script:
   ```bash
   ./update_system.sh
   ```

4. Follow the prompt:
   - Type `yes` (or `y`) to update the system.  
   - Type `no` (or `n`) to skip the update.  

---

## Manual Update (if needed)
If the script fails for any reason, try updating manually:
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

---

## Notes
- This script is meant for initial setup of a **brand new board**.  
- You may customize the script to install additional tools like `git`, `vim`, or `curl` during setup.  


