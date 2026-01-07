-- Import des données CSV dans la table brute

COPY vehicule_brut(type_vehicule, modele, autonomie_km, station_nom, station_adresse)
FROM '/chemin/vers/vehicules.csv'
DELIMITER ','
CSV HEADER;

-- Insertion des stations à partir des données importées
INSERT INTO station (nom_station, adresse, capacite)
SELECT DISTINCT station_nom, station_adresse, 10
FROM vehicule_brut;

-- Insertion des véhicules à partir de la table brute
INSERT INTO vehicule (type_vehicule, modele, statut, autonomie_km, id_station)
SELECT
    vb.type_vehicule,
    vb.modele,
    'disponible',
    vb.autonomie_km,
    s.id_station
FROM vehicule_brut vb
JOIN station s ON s.nom_station = vb.station_nom;
