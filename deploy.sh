#!/bin/bash

# Définir des variables pour les répertoires
REDIS_NODE_DIR="redis-node"
REDIS_REACT_DIR="redis-react"
DEPLOYEMENT_DIR="deployement"

# S'assurer que Minikube est démarré
echo "Vérification du statut de Minikube..."
minikube status || minikube start --driver=docker -force

# Charger les images Docker dans Minikube
echo "Chargement des images Docker dans Minikube..."
minikube image load $REDIS_NODE_DIR/
minikube image load $REDIS_REACT_DIR/

# Construire les images Docker pour Redis et React
echo "Construction des images Docker pour redis-node et redis-react..."

# Construction pour redis-node
echo "Construction de l'image Docker pour redis-node..."
cd $REDIS_NODE_DIR
docker build -t redis-node .
cd ..

# Construction pour redis-react
echo "Construction de l'image Docker pour redis-react..."
cd $REDIS_REACT_DIR
docker build -t redis-react .
cd ..

# Appliquer les fichiers de déploiement Kubernetes
echo "Déploiement des ressources Kubernetes..."
kubectl apply -f $DEPLOYEMENT_DIR/redis-service.yml -f $DEPLOYEMENT_DIR/redis-deployment.yml -f $DEPLOYEMENT_DIR/redis-hpa.yml
kubectl apply -f $DEPLOYEMENT_DIR/node-redis-service.yml -f $DEPLOYEMENT_DIR/node-redis-deployment.yml -f $DEPLOYEMENT_DIR/node-redis-hpa.yml
kubectl apply -f $DEPLOYEMENT_DIR/react-service.yml -f $DEPLOYEMENT_DIR/react-deployment.yml -f $DEPLOYEMENT_DIR/react-hpa.yml
kubectl apply -f $DEPLOYEMENT_DIR/prometheus-config.yml -f $DEPLOYEMENT_DIR/prometheus-deployment.yml -f $DEPLOYEMENT_DIR/prometheus-service.yml
kubectl apply -f $DEPLOYEMENT_DIR/grafana-deployment.yml -f $DEPLOYEMENT_DIR/grafana-service.yml

# Vérifier l'état des pods, services et hpa
echo "Vérification des pods et services déployés..."
kubectl get pods
kubectl get services
kubectl get hpa

# Démarrer le tunnel Minikube pour accéder aux services
echo "Démarrage du tunnel Minikube..."
minikube tunnel &

# Afficher l'URL du service React
echo "Accédez à votre application React via l'URL suivante :"
minikube service node-redis-front-service --url

echo "Automatisation terminée ! Vous pouvez maintenant accéder à vos services via Minikube."
