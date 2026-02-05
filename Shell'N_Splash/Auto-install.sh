#!/usr/bin/env bash
set -Eeuo pipefail

#---Log---------------------------------------------------------------
LOG_TAG="${LOG_TAG:-Splash}"
log() { printf '[%s] %s\n' "$LOG_TAG" "$*" >&2; }
die() { printf '[%s] [ERR] %s\n' "$LOG_TAG" "$*" >&2; exit 1; }

#---Verify,-Update-&-Upgrade------------------------------------------

echo	╔═════════════════════════════════════════════════════════════════════╗
echo	║                    Verification-update-&-upgrade                    ║
echo	╚═════════════════════════════════════════════════════════════════════╝

log "Updating!...."
if ! apt-get update -y; then
    die "Failed to update package list."
fi

log "Upgrading packages!...."
if ! apt-get upgrade -y; then
    die "Failed to upgrade packages."
fi

log "Removing unnecessary packages!...."
if ! apt-get autoremove -y; then
    die "Failed to remove unnecessary packages."
fi

log "Updating curl!...."
if ! apt-get install curl -y; then
    die "Failed to update curl."
fi

log "Update completed!"

#---App-Installer,-if-not-install-------------------------------------

echo	╔═════════════════════════════════════════════════════════════════════╗
echo	║                      Applications-Installation                      ║
echo	╚═════════════════════════════════════════════════════════════════════╝

log "Installing apps"
if ! dpkg -s "emacs" &>/dev/null; then
    apt-get install -y emacs
fi

if ! dpkg -s "git" &>/dev/null; then
    apt-get install -y git
fi

if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing Zsh..."
    sudo apt install -y zsh
fi

if [ -d ~/.oh-my-zsh ] || { [ -n "$ZSH" ] && grep -q "oh-my-zsh" ~/.zshrc 2>/dev/null; }; then
    echo "Oh-My-Zsh is installed!"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Installing Oh-My-Zsh!...."
fi

echo "Installation completed!"

#---Groups,-User-and-Permissions--------------------------------------

echo	╔═════════════════════════════════════════════════════════════════════╗
echo	║                   Creat-Groups-Users-&-Permission                   ║
echo	╚═════════════════════════════════════════════════════════════════════╝

#-----Group-devs-----------------------------
utilisateurs=("Alice" "Teo")
groupe="devs"
repertoire_devs="/var/devs"

for utilisateur in "${utilisateurs[@]}"; do
    if id "$utilisateur" &>/dev/null; then
        echo "User $utilisateur already exists!"
    else
        sudo adduser "$utilisateur"
    fi
    if groups "$utilisateur" | grep -q "\b$groupe\b"; then
        echo "User $utilisateur already belongs to group $groupe."
    else
        sudo usermod -aG "$groupe" "$utilisateur"
    fi
done

if [ ! -d "$repertoire_devs" ]; then
    sudo mkdir -p "$repertoire_devs"
else
    echo "Directory $repertoire_devs already exists."
fi

echo "Configuring permissions for directory $repertoire_devs..."
sudo chmod 770 "$repertoire_devs"
sudo chown :"$groupe" "$repertoire_devs"

#-----Group-admins-----------------------------
utilisateurs=("Lorent" "David")
groupe="admins"
repertoire_admins="/var/admins"

for utilisateur in "${utilisateurs[@]}"; do
    if id "$utilisateur" &>/dev/null; then
        echo "User $utilisateur already exists!"
    else
        sudo adduser "$utilisateur"
    fi
    if groups "$utilisateur" | grep -q "\b$groupe\b"; then
        echo "User $utilisateur already belongs to group $groupe."
    else
        sudo usermod -aG "$groupe" "$utilisateur"
    fi
done

if [ ! -d "$repertoire_admins" ]; then
    sudo mkdir -p "$repertoire_admins"
else
    echo "Directory $repertoire_admins already exists."
fi

echo "Configuring permissions for directory $repertoire_admins..."
sudo chmod 770 "$repertoire_admins"
sudo chown :"$groupe" "$repertoire_admins"

echo "Groups, Users & Permissions created!"

#---Configuration-of-sudoers------------------------------------------

echo	╔═════════════════════════════════════════════════════════════════════╗
echo	║                          Config-of-sudoers                          ║
echo	╚═════════════════════════════════════════════════════════════════════╝

declare -a USERS=("Alice" "Teo")
SERVICE_NAME="gdm.service"

for USERNAME in "${USERS[@]}"; do
    SUDO_FILE="/etc/sudoers.d/${USERNAME}_restart_${SERVICE_NAME}"
    echo "# Permissions for ${USERNAME} to restart ${SERVICE_NAME}" | sudo tee "$SUDO_FILE" > /dev/null
    echo "${USERNAME} ALL=(root) NOPASSWD: /bin/systemctl restart ${SERVICE_NAME}" | sudo tee -a "$SUDO_FILE" > /dev/null
    if sudo visudo -cf "$SUDO_FILE"; then
        echo "Rule added for ${USERNAME}. They can now restart the ${SERVICE_NAME} service."
    else
        echo "Error in rule for ${USERNAME}. Removing file $SUDO_FILE."
        sudo rm -f "$SUDO_FILE"
        exit 1
    fi
done

#---Configuration-of-Applications----------------------------------------

echo	╔═════════════════════════════════════════════════════════════════════╗
echo	║                             Apps-Config                             ║
echo	╚═════════════════════════════════════════════════════════════════════╝

sed -i 's/^ZSH_THEME=.*/ZSH_THEME="intheloop"/' ~/.zshrc
echo "The Oh-My-Zsh theme in the config has been changed to 'intheloop'."
