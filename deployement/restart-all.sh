#!/bin/bash

echo "📦 Redémarrage de tous les déploiements Kubernetes..."

# Récupérer tous les noms de déploiements
DEPLOYMENTS=$(kubectl get deployments -o jsonpath='{.items[*].metadata.name}')

# Boucle de redémarrage
for deploy in $DEPLOYMENTS; do
  echo "🔄 Redémarrage de : $deploy"
  kubectl rollout restart deployment "$deploy"
done

echo "✅ Tous les déploiements ont été redémarrés avec succès."
