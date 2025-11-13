#!/bin/bash

# ===================================
# 🔄 Script de renommage pour obotcall-stack-2
# ===================================

set -e

echo "🔄 Renommage de la nomenclature obotcall-stack-2..."
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Vérifier qu'on est dans le bon dossier
if [ ! -d "apps" ]; then
    echo -e "${RED}❌ Erreur: Le dossier 'apps' n'existe pas!${NC}"
    echo "Assurez-vous d'être dans ~/obotcall/obotcall-stack-2"
    exit 1
fi

echo -e "${YELLOW}📁 Renommage des dossiers...${NC}"

# Renommer apps/inter-app en apps/inter
if [ -d "apps/inter-app" ]; then
    echo "  - apps/inter-app → apps/inter"
    mv apps/inter-app apps/inter
else
    echo -e "${YELLOW}  ⚠️  apps/inter-app n'existe pas (peut-être déjà renommé)${NC}"
fi

# Note: Les autres apps n'existent pas encore, donc pas besoin de les renommer

echo ""
echo -e "${YELLOW}📄 Remplacement des fichiers de configuration...${NC}"

# Sauvegarder l'ancien docker-compose.yml
if [ -f "docker-compose.yml" ]; then
    echo "  - Sauvegarde de docker-compose.yml → docker-compose.yml.old"
    cp docker-compose.yml docker-compose.yml.old
fi

# Note: Les nouveaux fichiers seront copiés manuellement

echo ""
echo -e "${GREEN}✅ Renommage des dossiers terminé!${NC}"
echo ""
echo -e "${YELLOW}📋 Prochaines étapes:${NC}"
echo "  1. Copier les nouveaux fichiers de configuration depuis obotcall-stack-2-renamed/"
echo "  2. Vérifier les changements avec: git status"
echo "  3. Commiter et pusher"
echo ""
echo -e "${YELLOW}Structure actuelle:${NC}"
ls -la apps/
