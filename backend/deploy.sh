#!/bin/bash

echo "🚀 Début du déploiement..."

# Variables
SERVER_USER="debian"
SERVER_IP="51.79.74.100"
SERVER_DIR="/opt/abonneezy"

# Se connecter au serveur
echo "📡 Connexion au serveur..."
ssh ${SERVER_USER}@${SERVER_IP} "
    echo '📂 Vérification du dossier...'
    mkdir -p ${SERVER_DIR}

    echo '🔄 Arrêt des conteneurs existants...'
    cd ${SERVER_DIR}
    docker-compose -f docker-compose.prod.yml down || true

    echo '🧹 Nettoyage des anciens fichiers...'
    rm -rf ${SERVER_DIR}/*
"

# Copier les fichiers
echo "📤 Copie des fichiers vers le serveur..."
scp -r backend/* ${SERVER_USER}@${SERVER_IP}:${SERVER_DIR}/

# Démarrer les conteneurs
echo "🚀 Démarrage des conteneurs..."
ssh ${SERVER_USER}@${SERVER_IP} "
    cd ${SERVER_DIR}
    docker-compose -f docker-compose.prod.yml up --build -d
"

# Run database migrations
echo "🔄 Exécution des migrations de la base de données..."
ssh ${SERVER_USER}@${SERVER_IP} "
    cd ${SERVER_DIR}
    docker-compose -f docker-compose.prod.yml exec api npx prisma migrate deploy
"

# Show logs
echo "📋 Affichage des logs..."
ssh ${SERVER_USER}@${SERVER_IP} "
    cd ${SERVER_DIR}
    docker-compose -f docker-compose.prod.yml logs -f
"

echo "✅ Déploiement terminé !
Pour voir les logs: ssh ${SERVER_USER}@${SERVER_IP} 'cd ${SERVER_DIR} && docker-compose -f docker-compose.prod.yml logs'
Pour vérifier les conteneurs: ssh ${SERVER_USER}@${SERVER_IP} 'docker ps'" 