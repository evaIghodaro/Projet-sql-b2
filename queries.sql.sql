-- Liste des véhicules disponibles
SELECT * FROM vehicules_disponibles;

-- Nombre total de véhicules
SELECT COUNT(*) FROM vehicule;

-- Nombre de véhicules par station
SELECT s.nom_station, COUNT(v.id_vehicule)
FROM station s
LEFT JOIN vehicule v ON v.id_station = s.id_station
GROUP BY s.nom_station;

-- Liste des locations avec les clients
SELECT l.id_location, c.nom, c.prenom, l.date_debut, l.date_fin
FROM location l
JOIN client c ON c.id_client = l.id_client;

-- Durée moyenne des locations
SELECT AVG(date_fin - date_debut) FROM location;

-- Véhicules en maintenance
SELECT * FROM vehicule WHERE statut = 'en_maintenance';

-- Paiements supérieurs à la moyenne
SELECT * FROM paiement
WHERE montant > (SELECT AVG(montant) FROM paiement);

-- Clients sans location
SELECT * FROM client
WHERE id_client NOT IN (SELECT id_client FROM location);

-- Revenu total
SELECT SUM(montant) FROM paiement;

-- Historique des locations par véhicule
SELECT v.modele, COUNT(l.id_location)
FROM vehicule v
LEFT JOIN location l ON l.id_vehicule = v.id_vehicule
GROUP BY v.modele;
