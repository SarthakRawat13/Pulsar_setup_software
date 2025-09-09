# Pulsar Board System Update Script

This script is provided to help update the Linux system on a brand new Pulsar board.

## Features
- Prompts the user whether they want to update the system.
- Runs `apt-get update` and `apt-get upgrade -y` if the user agrees.
- Prints a helpful message if the update fails.

## Usage

1. Clone this repository to your Pulsar board using root account:
   ```bash
   git clone <your-repo-url>
   cd <your-repo-folder>
