# Medical Center Database

Ce projet est une application de gestion hospitaliere basee sur une base de donnees relationnelle MySQL et une interface Python en ligne de commande. Il a ete realise pour modeliser le fonctionnement d'un centre medical ou d'un hopital, en gerant les patients, les visites, le personnel, les chambres et les departements.

## Objectif du projet

L'objectif principal est de concevoir une base de donnees hospitaliere complete et de montrer comment elle peut etre exploitee a travers une application Python simple. Le systeme permet d'enregistrer des patients, de suivre leurs visites, de distinguer les consultations des hospitalisations et d'affecter automatiquement les ressources medicales disponibles.

## Fonctionnalites

- ajout d'un nouveau patient
- enregistrement d'une visite medicale
- distinction entre consultation et hospitalisation
- affectation automatique d'un medecin disponible
- affectation automatique d'une infirmiere pour une hospitalisation
- creation automatique d'une consultation ou d'une hospitalisation selon le motif
- generation automatique d'une analyse medicale apres une consultation
- affichage de l'historique des visites d'un patient
- affichage du contenu des tables principales
- suivi de l'occupation des chambres

## Technologies et outils utilises

- `MySQL` pour la base de donnees relationnelle
- `SQL` pour la creation des tables, contraintes, vues et triggers
- `Python` pour l'application console
- `mysql.connector` pour la connexion Python-MySQL
- `Docker` pour conteneuriser l'application
- `Docker Compose` pour orchestrer la base de donnees et l'application
- `Luna Modeler` ou un outil similaire pour la modelisation via le fichier `.lun`

## Structure du projet

- `BD_Grooupe20.sql` : script SQL principal de creation et d'initialisation de la base
- `Groupe20.py` : application Python de gestion hospitaliere
- `docker-compose.yml` : configuration des services Docker
- `Dockerfile` : image de l'application Python
- `HOSTPITAL_DATABASE.lun` : fichier de modelisation de la base
- `Rapport du Projet groupe 20.pdf` : rapport du projet

## Base de donnees

La base de donnees `hospital_database` contient plusieurs tables principales :

- `PATIENT`
- `PERSONNEL`
- `MEDECIN`
- `INFIRMIERE`
- `DEPARTEMENT`
- `CHAMBRE`
- `VISITE`
- `CONSULTATION`
- `HOSPITALISATION`
- `EFFECTUE`
- `PARTICIPE`
- `ANALYSE_MEDICAL`

Le projet inclut aussi plusieurs vues pour simplifier la consultation des donnees, ainsi que des triggers pour automatiser certaines operations importantes.

## Automatisations implementees

Les triggers SQL permettent notamment de :

- choisir un medecin disponible apres l'ajout d'une visite
- creer automatiquement une consultation ou une hospitalisation
- generer une analyse medicale apres une consultation
- affecter une infirmiere disponible apres une hospitalisation

## Execution du projet

### Option 1 : avec Docker

1. Se placer dans le dossier du projet.
2. Lancer :

```bash
docker compose up --build
```

### Option 2 : execution locale

1. Installer Python 3 et MySQL.
2. Creer la base de donnees en executant le script SQL.
3. Installer la dependance Python necessaire :

```bash
pip install mysql-connector-python
```

4. Lancer l'application :

```bash
python Groupe20.py
```

## Remarques

- Le fichier `docker-compose.yml` fait reference a `BD_Groupe20.sql` alors que le fichier present dans le projet est nomme `BD_Grooupe20.sql`. Il faut harmoniser ce nom si l'initialisation Docker doit fonctionner correctement.
- Le `Dockerfile` copie un `requirements.txt`, mais ce fichier n'est pas present actuellement dans le depot.

## Auteurs

Projet realise par le groupe 20 dans le cadre d'un projet de base de donnees.
