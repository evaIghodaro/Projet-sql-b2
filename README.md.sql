README.md — CIARA Mobility
Description

Projet SQL consistant à créer une base de données pour un service de location de véhicules électriques (voitures, scooters, vélos, trottinettes).

La base permet de gérer :

les stations
les véhicules
les clients
les locations
les paiements
la maintenance

Contenu du projet

Le dépôt contient :
create_tables.sql : création des tables, contraintes, vue et trigger
import_vehicle_csv.sql : import du CSV + normalisation
tests.sql : données de test + vérification du trigger
queries.sql : requêtes d’analyse

README.md : documentation du projet
Points importants
Intégrité assurée via PRIMARY KEY, FOREIGN KEY, UNIQUE et CHECK
Import des données via un fichier CSV
Trigger permettant de passer un véhicule en en_location lors d’une location
Vue vehicules_disponibles facilitant l’accès aux véhicules disponibles
Requêtes d’analyse (ex : revenus, nombre de véhicules, durée moyenne, top véhicules)

Exécution
Ordre d’exécution :
create_tables.sql
import_vehicle_csv.sql
tests.sql (optionnel)
queries.sql

## Import des données – vehicule_brut

La table `vehicule_brut` est une table intermédiaire utilisée pour importer les données depuis un fichier CSV.
Elle permet de stocker les informations brutes avant leur transformation et insertion dans les tables normalisées
(`station` et `vehicule`).

Cette approche respecte les bonnes pratiques en base de données :
- séparation des données brutes et des données métiers
- nettoyage et contrôle avant intégration
- meilleure traçabilité des imports

Une fois les données validées, elles peuvent être insérées dans les tables finales via des requêtes SQL adaptées.
