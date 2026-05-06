# 🔥 Projet Template  🔥 



## &#128203; Généralités :
Projet Django vierge, pour servir de base à un nouveau projet.
- python3.12
- django 5.2 
- poetry
- tailwind css v3
- base de données postgres
- Docker : conteneurs web, tailwind, db
 

##  &#8205;&#127891; Démonstration : [ici](https://www.xxxxxx.fr)

## &#129520; Fonctionnalités :
- ### Fonctionnalités ...

## &#129489;&#8205;&#127891; Les utilisateurs :
- ### ...

## &#128736; Installation : 

- settings : 
  - créer settings/develop.py et settings/production.py : voir les modèles settings/develop.example.py et settings/production.example.py
  - créer .env pour les paramètres de la bd et les variables d'environnement utiles (TOKEN_API...)
- cloner le projet :
```bash
    git clone https://xxxxxxxxx.git
```
- installation en dev:
```bash
    docker compose build			# créé l’image

    # ---
    # si besoin de créer le theme de tailwind 
    # attention : décommenter/recommenter "theme" dans settings.INSTALLED_APPS
    docker compose run --rm tailwind python manage.py tailwind init
    # ---

    docker compose up -d db		# démarrer la db
    docker compose run --rm tailwind python manage.py tailwind install
    docker compose run --rm web python manage.py makemigrations
    docker compose run --rm web python manage.py migrate
    docker compose run --rm web python manage.py createsuperuser
    docker compose up -d			# tout démarrer
```
- installation en prod:
```bash
    docker compose -f docker-compose.yml -f docker-compose.prod.yml up
```


