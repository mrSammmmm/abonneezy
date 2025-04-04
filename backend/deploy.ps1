# Variables
$SERVER_USER = "debian"
$SERVER_IP = "51.79.74.100"
$SERVER_DIR = "/opt/abonneezy"

Write-Host "🚀 Début du déploiement..." -ForegroundColor Green

# Se connecter au serveur
Write-Host "📡 Connexion au serveur..." -ForegroundColor Blue
ssh "${SERVER_USER}@${SERVER_IP}" "mkdir -p ${SERVER_DIR}"

Write-Host "🔄 Arrêt des conteneurs existants..." -ForegroundColor Yellow
ssh "${SERVER_USER}@${SERVER_IP}" "cd ${SERVER_DIR}; docker-compose down"

Write-Host "🧹 Nettoyage des anciens fichiers..." -ForegroundColor Yellow
ssh "${SERVER_USER}@${SERVER_IP}" "rm -rf ${SERVER_DIR}/*"

# Copier les fichiers
Write-Host "📤 Copie des fichiers vers le serveur..." -ForegroundColor Blue
scp -r backend/* "${SERVER_USER}@${SERVER_IP}:${SERVER_DIR}/"

# Copier le fichier .env
Write-Host "📤 Copie du fichier .env..." -ForegroundColor Blue
Copy-Item "backend/.env.prod" -Destination "backend/.env"
scp "backend/.env" "${SERVER_USER}@${SERVER_IP}:${SERVER_DIR}/"
Remove-Item "backend/.env"

# Démarrer les conteneurs
Write-Host "🚀 Démarrage des conteneurs..." -ForegroundColor Green
ssh "${SERVER_USER}@${SERVER_IP}" "cd ${SERVER_DIR}; docker-compose up --build -d"

Write-Host "✅ Déploiement terminé !" -ForegroundColor Green
Write-Host "Pour voir les logs, exécutez:" -ForegroundColor Gray
Write-Host "ssh ${SERVER_USER}@${SERVER_IP} 'cd ${SERVER_DIR}; docker-compose logs'" -ForegroundColor Gray
Write-Host "Pour vérifier les conteneurs, exécutez:" -ForegroundColor Gray
Write-Host "ssh ${SERVER_USER}@${SERVER_IP} 'docker ps'" -ForegroundColor Gray 