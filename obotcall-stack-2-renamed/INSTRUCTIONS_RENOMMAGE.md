# 🔄 Instructions de Renommage - Nouvelle Nomenclature

## 📊 Changements

### Ancienne nomenclature → Nouvelle nomenclature

| Ancien | Nouveau | Domaine |
|--------|---------|---------|
| obotcall-app | **web** | app.obotcall.tech |
| inter-app | **inter** | inter.app.obotcall.tech |
| immo-app | **immo** | immo.app.obotcall.tech |
| agent-app | **agent** | agent.app.obotcall.tech |
| assist-app | **assist** | assist.app.obotcall.tech |

### Structure des dossiers

```
apps/
├── web/         (au lieu de obotcall-app/)
├── inter/       (au lieu de inter-app/)
├── immo/        (au lieu de immo-app/)
├── agent/       (au lieu de agent-app/)
└── assist/      (au lieu de assist-app/)
```

---

## 🚀 Procédure sur le VPS

### Étape 1 : Se positionner dans le bon dossier

```bash
cd ~/obotcall/obotcall-stack-2
```

### Étape 2 : Cloner le repo inter-app pour récupérer les nouveaux fichiers

```bash
cd ~/obotcall
git clone https://github.com/ecron24/inter-app.git temp-inter-app-rename
cd temp-inter-app-rename
git checkout claude/supabase-schemas-four-apps-011CV5UiSGWaHs2B9SVbHeJt
```

### Étape 3 : Copier les nouveaux fichiers

```bash
# Copier les fichiers mis à jour
cp obotcall-stack-2-renamed/docker-compose.yml ~/obotcall/obotcall-stack-2/
cp -r obotcall-stack-2-renamed/nginx ~/obotcall/obotcall-stack-2/
```

### Étape 4 : Renommer le dossier inter-app

```bash
cd ~/obotcall/obotcall-stack-2
mv apps/inter-app apps/inter
```

### Étape 5 : Vérifier la structure

```bash
ls -la apps/
# Vous devriez voir: apps/inter/
```

### Étape 6 : Supprimer les anciens fichiers Nginx

```bash
cd ~/obotcall/obotcall-stack-2
rm -f nginx/conf.d/obotcall-app.conf
rm -f nginx/conf.d/inter-app.conf
rm -f nginx/conf.d/immo-app.conf
rm -f nginx/conf.d/agent-app.conf
rm -f nginx/conf.d/assist-app.conf
```

### Étape 7 : Nettoyer le dossier temporaire

```bash
cd ~/obotcall
rm -rf temp-inter-app-rename
```

### Étape 8 : Retourner dans obotcall-stack-2 et vérifier

```bash
cd ~/obotcall/obotcall-stack-2
git status
```

### Étape 9 : Ajouter les changements au Git

```bash
git add .
git status
```

Vous devriez voir :
- `renamed: apps/inter-app/ → apps/inter/`
- `modified: docker-compose.yml`
- `deleted: nginx/conf.d/obotcall-app.conf`
- `deleted: nginx/conf.d/inter-app.conf`
- etc.
- `new file: nginx/conf.d/web.conf`
- `new file: nginx/conf.d/inter.conf`
- etc.

### Étape 10 : Commiter

```bash
git commit -m "♻️ Refactor: Rename all apps to short names (web, inter, immo, agent, assist)"
```

### Étape 11 : Pusher

```bash
git push origin main
```

---

## 🔍 Vérifications post-renommage

### Vérifier la structure

```bash
cd ~/obotcall/obotcall-stack-2
tree -L 2 apps/
```

Doit afficher :
```
apps/
└── inter/
    ├── README.md
    ├── docker-compose.yml
    ├── docs/
    ├── inter-api/
    ├── src/
    └── ...
```

### Vérifier docker-compose.yml

```bash
grep "container_name:" docker-compose.yml
```

Doit afficher :
```
container_name: obotcall-web
container_name: obotcall-web-api
container_name: obotcall-inter
container_name: obotcall-inter-api
...
```

### Vérifier les configs Nginx

```bash
ls nginx/conf.d/
```

Doit afficher :
```
web.conf
inter.conf
immo.conf
agent.conf
assist.conf
```

---

## 📝 Fichiers mis à jour

- ✅ `docker-compose.yml` - Services renommés
- ✅ `nginx/conf.d/web.conf` - app.obotcall.tech
- ✅ `nginx/conf.d/inter.conf` - inter.app.obotcall.tech
- ✅ `nginx/conf.d/immo.conf` - immo.app.obotcall.tech
- ✅ `nginx/conf.d/agent.conf` - agent.app.obotcall.tech
- ✅ `nginx/conf.d/assist.conf` - assist.app.obotcall.tech
- ✅ `apps/inter-app/` → `apps/inter/` (renommé)

---

## ⚠️ Important : Configuration DNS

Une fois le renommage terminé, vous devrez **mettre à jour vos enregistrements DNS** :

### Anciens domaines (à supprimer ou rediriger)
- ❌ inter-app.app.obotcall.tech
- ❌ immo-app.app.obotcall.tech
- ❌ agent-app.app.obotcall.tech
- ❌ assist-app.app.obotcall.tech

### Nouveaux domaines (à configurer)
- ✅ app.obotcall.tech (pas de changement)
- ✅ inter.app.obotcall.tech
- ✅ immo.app.obotcall.tech
- ✅ agent.app.obotcall.tech
- ✅ assist.app.obotcall.tech

**Configuration DNS :**

| Type | Nom | Valeur | TTL |
|------|-----|--------|-----|
| A | app.obotcall.tech | IP_VPS | 3600 |
| A | inter.app.obotcall.tech | IP_VPS | 3600 |
| A | immo.app.obotcall.tech | IP_VPS | 3600 |
| A | agent.app.obotcall.tech | IP_VPS | 3600 |
| A | assist.app.obotcall.tech | IP_VPS | 3600 |

---

## 🔒 Nouveaux certificats SSL

Après la configuration DNS, obtenir les certificats SSL :

```bash
# Pour le nouveau domaine inter (au lieu de inter-app)
sudo certbot --nginx -d inter.app.obotcall.tech

# Pour les futures apps
sudo certbot --nginx -d immo.app.obotcall.tech
sudo certbot --nginx -d agent.app.obotcall.tech
sudo certbot --nginx -d assist.app.obotcall.tech
```

---

## 🎯 Résultat final

Après le renommage, vous aurez :

```
~/obotcall/obotcall-stack-2/
├── apps/
│   └── inter/                    ✅ Renommé
│
├── nginx/
│   └── conf.d/
│       ├── web.conf              ✅ Nouveau
│       ├── inter.conf            ✅ Nouveau
│       ├── immo.conf             ✅ Nouveau
│       ├── agent.conf            ✅ Nouveau
│       └── assist.conf           ✅ Nouveau
│
├── docker-compose.yml            ✅ Mis à jour
└── ... (autres fichiers)
```

---

## 🆘 En cas de problème

### Rollback si nécessaire

Si quelque chose ne va pas, vous pouvez revenir en arrière :

```bash
# Revenir au commit précédent
git reset --hard HEAD~1

# Restaurer l'ancien docker-compose.yml
cp docker-compose.yml.old docker-compose.yml

# Renommer apps/inter en apps/inter-app
mv apps/inter apps/inter-app
```

---

**Bonne chance avec le renommage ! 🚀**
