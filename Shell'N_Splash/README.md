# Auto-Install & System Configuration Script

This Bash script automates system maintenance, software installation, and user management for Debian/Ubuntu-based Linux systems.

## Features

- **System Maintenance:** Automatically updates, upgrades, and removes unnecessary packages (`apt-get`).
- **Tool Installation:** Installs essential tools including `curl`, `emacs`, `git`, and `zsh`.
- **Shell Setup:** Installs **Oh-My-Zsh** and configures the theme to `intheloop`.
- **User & Group Management:**
  - Creates groups (`devs`, `admins`) and users (Alice, Teo, Lorent, David).
  - Sets up shared directories (`/var/devs`, `/var/admins`) with strict permissions (770).
- **Sudo Privileges:** Configures `sudoers` to allow specific users (Alice, Teo) to restart the `gdm.service` without a password.

## Usage

1.  **Make the script executable:**

    ```bash
    chmod +x Auto-install.sh
    ```

2.  **Run with root privileges:**
    ```bash
    sudo ./Auto-install.sh
    ```

> **⚠️ Note:** This script modifies system files, adds users, and changes directory permissions. Please review the code before running it on a production environment.

---

_Project realized for the Fundamentals of Information Technology module - ETNA._
