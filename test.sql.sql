-- Insertion de données de test

INSERT INTO client (nom, prenom, email)
VALUES ('Dupont', 'Alice', 'alice@test.com');

INSERT INTO station (nom_station, adresse, capacite)
VALUES ('Centre Ville', '10 rue principale', 20);

INSERT INTO vehicule (type_vehicule, modele, statut, autonomie_km, id_station)
VALUES ('Voiture', 'Tesla Model 3', 'disponible', 450, 1);

-- Test du trigger de mise à jour du statut
INSERT INTO location (date_debut, date_fin, prix_total, id_client, id_vehicule)
VALUES (NOW(), NOW() + INTERVAL '2 hours', 20, 1, 1);

-- Vérification du statut du véhicule
SELECT id_vehicule, statut FROM vehicule;

