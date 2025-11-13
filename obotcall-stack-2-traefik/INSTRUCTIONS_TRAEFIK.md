# 🔄 Migration vers Traefik - Instructions

## 📊 Changements effectués

### ❌ Supprimé :
- Service `nginx` dans docker-compose.yml
- Exposition des ports (80, 443) car géré par Traefik
- Réseau interne `obotcall-network` (remplacé par réseau externe)

### ✅ Ajouté :
- **Labels Traefik** pour chaque service frontend
- **Réseau externe** : `docker_oppsys-network` (partagé avec oppsys)
- **Routage automatique** via Traefik
- **SSL automatique** via Let's Encrypt

---

## 🚀 Procédure sur le VPS

### Étape 1 : Créer le réseau Docker externe (si pas déjà fait)

```bash
# Vérifier si le réseau existe
docker network ls | grep oppsys-network

# Si le réseau n'existe pas, le créer
docker network create docker_oppsys-network
```

### Étape 2 : Sauvegarder l'ancien docker-compose.yml

```bash
cd ~/obotcall/obotcall-stack-2
cp docker-compose.yml docker-compose.yml.nginx-backup
```

### Étape 3 : Récupérer le nouveau docker-compose.yml

```bash
# Cloner inter-app temporairement pour récupérer le nouveau fichier
cd ~/obotcall
git clone https://github.com/ecron24/inter-app.git temp-traefik-update
cd temp-traefik-update
git checkout claude/supabase-schemas-four-apps-011CV5UiSGWaHs2B9SVbHeJt

# Copier le nouveau docker-compose.yml
cp obotcall-stack-2-traefik/docker-compose.yml ~/obotcall/obotcall-stack-2/

# Nettoyer
cd ~/obotcall
rm -rf temp-traefik-update
```

### Étape 4 : Vérifier le fichier

```bash
cd ~/obotcall/obotcall-stack-2
cat docker-compose.yml | grep "traefik.enable"
```

Vous devriez voir :
```
- "traefik.enable=true"
- "traefik.enable=true"
...
```

### Étape 5 : Supprimer le dossier nginx (inutile maintenant)

```bash
cd ~/obotcall/obotcall-stack-2
rm -rf nginx/
```

### Étape 6 : Ajouter au Git

```bash
git add .
git status
```

Vous devriez voir :
```
modified:   docker-compose.yml
deleted:    nginx/
```

### Étape 7 : Commiter et pusher

```bash
git commit -m "🔧 Config: Migrate from Nginx to Traefik with labels"
git push origin main
```

---

## 📋 Configuration des Labels Traefik

### Services exposés :

| Service | Domaine | Port | Router Traefik |
|---------|---------|------|----------------|
| **web** | app.obotcall.tech | 3000 | obotcall-web |
| **inter** | inter.app.obotcall.tech | 3001 | obotcall-inter |
| **immo** | immo.app.obotcall.tech | 3002 | obotcall-immo |
| **agent** | agent.app.obotcall.tech | 3003 | obotcall-agent |
| **assist** | assist.app.obotcall.tech | 3004 | obotcall-assist |

### Labels Traefik utilisés :

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.obotcall-{app}.rule=Host(`{domain}`)"
  - "traefik.http.routers.obotcall-{app}.entrypoints=websecure"
  - "traefik.http.routers.obotcall-{app}.tls.certresolver=letsencrypt"
  - "traefik.http.services.obotcall-{app}.loadbalancer.server.port={port}"
  - "traefik.docker.network=docker_oppsys-network"
```

---

## 🌐 Configuration DNS

Assurez-vous que les enregistrements DNS sont configurés :

| Type | Nom | Valeur | TTL |
|------|-----|--------|-----|
| A | app.obotcall.tech | IP_VPS | 3600 |
| A | inter.app.obotcall.tech | IP_VPS | 3600 |
| A | immo.app.obotcall.tech | IP_VPS | 3600 |
| A | agent.app.obotcall.tech | IP_VPS | 3600 |
| A | assist.app.obotcall.tech | IP_VPS | 3600 |

---

## 🔒 SSL Automatique

Traefik va automatiquement :
1. ✅ Détecter les nouveaux services avec labels
2. ✅ Demander les certificats SSL à Let's Encrypt
3. ✅ Renouveler automatiquement les certificats

**Pas besoin de lancer certbot manuellement !**

---

## 🧪 Test de la configuration

### 1. Vérifier que Traefik est actif

```bash
docker ps | grep traefik
```

### 2. Voir les logs Traefik

```bash
docker logs traefik -f
```

Vous devriez voir :
```
Traefik detected new routers: obotcall-web, obotcall-inter...
```

### 3. Démarrer les services obotcall (quand les apps seront prêtes)

```bash
cd ~/obotcall/obotcall-stack-2

# Démarrer seulement web et inter pour l'instant
docker-compose up -d web inter

# Voir les logs
docker-compose logs -f
```

### 4. Vérifier dans les logs Traefik

```bash
docker logs traefik | grep obotcall
```

---

## 🔍 Vérifications

### Vérifier les réseaux

```bash
docker network inspect docker_oppsys-network
```

Vous devriez voir vos conteneurs obotcall connectés.

### Vérifier les routes Traefik

```bash
# Via API Traefik (si activée)
curl http://localhost:8080/api/http/routers | jq | grep obotcall

# Ou voir les logs
docker logs traefik 2>&1 | grep "obotcall"
```

---

## ⚠️ Important

### Profiles Docker Compose

Les services **immo**, **agent**, et **assist** sont dans des profiles :

```bash
# Démarrer seulement web et inter (pas de profile)
docker-compose up -d

# Démarrer avec immo
docker-compose --profile immo up -d

# Démarrer avec tous les services
docker-compose --profile all up -d
```

### Réseau partagé

Tous les services obotcall sont sur le même réseau que :
- Traefik
- Les services oppsys (admin-api, n8n, etc.)
- Peuvent communiquer entre eux

---

## 🆘 Dépannage

### Problème : Service pas accessible

```bash
# 1. Vérifier que le conteneur tourne
docker ps | grep obotcall

# 2. Vérifier les labels Traefik
docker inspect obotcall-web | grep traefik

# 3. Voir les logs Traefik
docker logs traefik -f

# 4. Voir les logs du service
docker logs obotcall-web -f
```

### Problème : Certificat SSL non obtenu

```bash
# Vérifier les logs Traefik pour Let's Encrypt
docker logs traefik 2>&1 | grep -i "acme\|certificate"

# Vérifier que le domaine est accessible en HTTP
curl -I http://app.obotcall.tech
```

---

## ✅ Checklist finale

- [ ] Réseau `docker_oppsys-network` créé
- [ ] Nouveau docker-compose.yml copié
- [ ] Dossier `nginx/` supprimé
- [ ] Changements commités et pushés
- [ ] DNS configurés
- [ ] Traefik actif et fonctionnel
- [ ] Prêt à démarrer les services

---

**Configuration Traefik terminée ! 🎉**

Prochaine étape : Créer les applications (web, immo, agent, assist) !
