NB : Les fichiers du  ZIP et du depot github sont organisé un peu différemment.

# Projet Kubernetes avec Minikube, Prometheus, Grafana, Redis et Node.js, OMAR REZKELLAH

## Prérequis

Avant de commencer, assurez-vous d'avoir les outils suivants installés sur votre machine :

- **Docker** : pour la gestion des containers et des images Docker.
- **Minikube** : pour gérer un cluster Kubernetes local.
- **kubectl** : l'outil en ligne de commande pour interagir avec Kubernetes.


## Script d'automatisation

Pour simplifier le processus de déploiement, un script Bash (`deploy.sh`) est fourni. Ce script exécute automatiquement toutes les étapes du projet, y compris :

- Démarrage de Minikube
- Chargement des images Docker
- Application des fichiers de déploiement Kubernetes
- Vérification des services et des pods
- Lancement de Minikube Tunnel
- Affichage des URL des services

### Exécution du script

Pour exécuter le script, procédez comme suit :

1. Clonez ce dépôt et placez-vous dans le répertoire du projet.
2. Donnez les permissions d'exécution au script :
   ```bash
   chmod +x deploy.sh
   ```
3. Exécutez le script avec la commande suivante :
   ```bash
   ./deploy.sh
   ```







## Étapes d'installation et de déploiement

### 1. Démarrage de Minikube

Lancez Minikube avec la commande suivante :

```bash
minikube start --driver=docker --force
```

Cela va démarrer un cluster Kubernetes local sur votre machine.

### 2. Chargement des images Docker dans Minikube

Avant de déployer, vous devez charger les images Docker locales dans Minikube :

```bash
minikube image load node-redis-server
minikube image load redis
minikube image load react
```

### 3. Application des fichiers de déploiement

Une fois que Minikube est prêt et que les images sont chargées, appliquez les fichiers de déploiement pour chaque service (Redis, Node-Redis, React, Prometheus, Grafana) en utilisant la commande suivante :

```bash
kubectl apply -f redis-service.yml -f redis-deployment.yml -f redis-hpa.yml
kubectl apply -f node-redis-service.yml -f node-redis-deployment.yml -f node-redis-hpa.yml
kubectl apply -f react-service.yml -f react-deployment.yml -f react-hpa.yml
kubectl apply -f prometheus-config.yml -f prometheus-deployment.yml -f prometheus-service.yml
kubectl apply -f grafana-deployment.yml -f grafana-service.yml
```

Cela va créer les services, les déploiements et les règles d'auto-scaling pour chacun des composants de l'application.

### 4. Vérification des ressources Kubernetes

Après avoir appliqué les fichiers de déploiement, vérifiez que les services, les pods et les auto-scalers sont créés avec les commandes suivantes :

```bash
kubectl get service
kubectl get pods
kubectl get hpa
```

### 5. Lancement de Minikube Tunnel

Pour exposer vos services localement, activez Minikube Tunnel en arrière-plan :

```bash
minikube tunnel &
```

### 6. Accéder aux services

Vous pouvez maintenant accéder aux services via les URL suivantes :

- **Node-Redis Frontend** : `$(minikube service node-redis-front-service --url)`
- **Prometheus** : `$(minikube service prometheus --url)`
- **Grafana** : `$(minikube service grafana --url)`

### 7. Utilisation des outils de monitoring

Accédez à Prometheus et Grafana via leurs URL respectives. Prometheus scrappera les métriques des services Node-Redis et Redis, et Grafana vous permettra de visualiser ces métriques de manière graphique.



## Structure du projet

Le projet est structuré de la manière suivante :

```
.
├── deploy.sh                          # Script d'automatisation pour déployer l'infrastructure
├── redis-node                         # Contient le code source, les fichiers JavaScript et le Dockerfile pour 					le backend Node.js connecté à Redis.
├── redis-react			       # Contient le code source, les composants React et le Dockerfile pour le 					frontend de l’application.
├── deployement
	├── redis-deployment.yml               # Déploiement de Redis (master et réplicas)
	├── node-redis-deployment.yml          # Déploiement du backend Node-Redis
	├── react-deployment.yml               # Déploiement du frontend React
	├── redis-service.yml                  # Service redis
	├── node-redis-service.yml             # Service back-end
	├── react-service.yml                  # Service front-end
	├── redis-hpa.yml                      # Horizontal Pod Autoscaler pour Redis
	├── node-redis-hpa.yml                 # Horizontal Pod Autoscaler pour Node-Redis
	├── react-hpa.yml                      # Horizontal Pod Autoscaler pour React
	├── prometheus-config.yml              # Fichier de configuration de Prometheus
	├── prometheus-deployment.yml          # Déploiement de Prometheus
	├── prometheus-service.yml             # Service Kubernetes pour Prometheus
	├── grafana-deployment.yml             # Déploiement de Grafana
	├── grafana-service.yml                # Service Kubernetes pour Grafana
	├── restart-all.sh		       # Script bash pour redémarrer tous les déploiements Kubernetes 
	├── redis-pv-pvc.yml                   #Définition des volumes persistants (PV) et des revendications de 						volumes (PVC) pour Redis.
└── README.md                          
```



## Technologies utilisées

- **Minikube** : Pour exécuter un cluster Kubernetes local.
- **Kubernetes** : Orchestration des conteneurs et gestion des ressources.
- **Prometheus** : Surveillance et collecte des métriques des services.
- **Grafana** : Visualisation des données collectées par Prometheus.
- **Docker** : Conteneurisation des applications backend (Node.js) et frontend (React).
- **Redis** : Base de données NoSQL utilisée par le backend Node.js.






