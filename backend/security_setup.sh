#!/bin/bash

echo "🔒 Configuration de la sécurité du serveur..."

# Mise à jour du système
echo "📦 Mise à jour du système..."
sudo apt update
sudo apt upgrade -y

# Installation et configuration du pare-feu
echo "🛡️ Installation et configuration du pare-feu..."
sudo apt install -y ufw

# Configuration des règles du pare-feu
echo "⚙️ Configuration des règles du pare-feu..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Autoriser SSH (port 22)
sudo ufw allow ssh

# Autoriser HTTP (port 80)
sudo ufw allow http

# Autoriser HTTPS (port 443)
sudo ufw allow https

# Autoriser le port de l'API (3000)
sudo ufw allow 3000

# Activer le pare-feu
echo "y" | sudo ufw enable

# Configuration de sécurité SSH
echo "🔑 Configuration de la sécurité SSH..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo tee -a /etc/ssh/sshd_config << EOF

# Sécurité supplémentaire
PermitRootLogin no
PasswordAuthentication yes
MaxAuthTries 3
EOF

# Redémarrer SSH
sudo systemctl restart ssh

# Installation de fail2ban
echo "🚫 Installation de fail2ban..."
sudo apt install -y fail2ban

# Configuration de fail2ban
sudo tee /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
EOF

# Redémarrer fail2ban
sudo systemctl restart fail2ban

echo "✅ Configuration de sécurité terminée !"
echo "🔍 Vérification des services..."
echo "UFW Status:"
sudo ufw status
echo "Fail2ban Status:"
sudo systemctl status fail2ban 