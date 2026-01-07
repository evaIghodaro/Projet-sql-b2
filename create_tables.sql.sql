-- CIARA MOBILITY - Création de la base PostgreSQL

-- RESET
DROP TABLE IF EXISTS paiement CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS maintenance CASCADE;
DROP TABLE IF EXISTS vehicule CASCADE;
DROP TABLE IF EXISTS station CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS vehicule_brut CASCADE;

-- TABLE BRUTE (IMPORT CSV)
CREATE TABLE vehicule_brut (
    type_vehicule VARCHAR(50),
    modele VARCHAR(100),
    autonomie_km INT CHECK (autonomie_km >= 0),
    station_nom VARCHAR(100),
    station_adresse VARCHAR(255)
);

-- ========================
-- CLIENT
-- ========================
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%@%'),
    telephone VARCHAR(20),
    date_inscription DATE DEFAULT CURRENT_DATE
);

-- ========================
-- STATION
-- ========================
CREATE TABLE station (
    id_station SERIAL PRIMARY KEY,
    nom_station VARCHAR(100) UNIQUE NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    capacite INT NOT NULL CHECK (capacite >= 0)
);

-- ========================
-- VEHICULE
-- ========================
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    type_vehicule VARCHAR(30) NOT NULL,
    modele VARCHAR(100) NOT NULL,
    statut VARCHAR(20) NOT NULL
        CHECK (statut IN ('disponible','en_location','en_maintenance','hors_service')),
    autonomie_km INT CHECK (autonomie_km >= 0),
    id_station INT NOT NULL REFERENCES station(id_station)
);

-- ========================
-- LOCATION
-- ========================
CREATE TABLE location (
    id_location SERIAL PRIMARY KEY,
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP CHECK (date_fin > date_debut),
    prix_total NUMERIC(10,2) CHECK (prix_total >= 0),
    id_client INT NOT NULL REFERENCES client(id_client),
    id_vehicule INT NOT NULL REFERENCES vehicule(id_vehicule)
);

-- ========================
-- PAIEMENT
-- ========================
CREATE TABLE paiement (
    id_paiement SERIAL PRIMARY KEY,
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    montant NUMERIC(10,2) CHECK (montant >= 0),
    moyen_paiement VARCHAR(30),
    id_location INT REFERENCES location(id_location)
);

-- ========================
-- MAINTENANCE
-- ========================
CREATE TABLE maintenance (
    id_maintenance SERIAL PRIMARY KEY,
    date_maintenance DATE DEFAULT CURRENT_DATE,
    type_intervention VARCHAR(100),
    commentaire TEXT,
    id_vehicule INT REFERENCES vehicule(id_vehicule)
);

-- ========================
-- VUE
-- ========================
CREATE OR REPLACE VIEW vehicules_disponibles AS
SELECT
    v.id_vehicule,
    v.modele,
    s.nom_station
FROM vehicule v
JOIN station s ON s.id_station = v.id_station
WHERE v.statut = 'disponible';

-- ========================
-- FONCTION
-- ========================
CREATE OR REPLACE FUNCTION calcul_prix(
    date_debut TIMESTAMP,
    date_fin TIMESTAMP,
    tarif_horaire NUMERIC
)
RETURNS NUMERIC AS $$
DECLARE
    duree_heures NUMERIC;
BEGIN
    duree_heures := EXTRACT(EPOCH FROM (date_fin - date_debut)) / 3600;
    RETURN ROUND(duree_heures * tarif_horaire, 2);
END;
$$ LANGUAGE plpgsql;


-- TRIGGER

CREATE OR REPLACE FUNCTION maj_statut_location()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérification de la disponibilité du véhicule
    IF (SELECT statut FROM vehicule WHERE id_vehicule = NEW.id_vehicule) != 'disponible' THEN
        RAISE EXCEPTION 'Véhicule non disponible';
    END IF;

    -- Mise à jour du statut du véhicule
    UPDATE vehicule
    SET statut = 'en_location'
    WHERE id_vehicule = NEW.id_vehicule;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_location
BEFORE INSERT ON location
FOR EACH ROW
EXECUTE FUNCTION maj_statut_location();
