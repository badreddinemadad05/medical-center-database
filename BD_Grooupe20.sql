-- Créer la base de données
USE information_schema;
DROP DATABASE IF EXISTS hospital_database;
create database if not exists hospital_database;
SHOW DATABASES;

USE hospital_database;
DROP USER IF EXISTS 'youssef'@'localhost';
CREATE USER 'youssef'@'localhost' IDENTIFIED BY 'youssef0000';
GRANT ALL PRIVILEGES ON hospital_database.* TO 'youssef'@'localhost';
FLUSH PRIVILEGES;



-- Supprimer les tables dans l'ordre correct
DROP TABLE IF EXISTS EFFECTUE;
DROP TABLE IF EXISTS PARTICIPE;
DROP TABLE IF EXISTS ANALYSE_MEDICAL;
DROP TABLE IF EXISTS CONSULTATION;
DROP TABLE IF EXISTS HOSPITALISATION;
DROP TABLE IF EXISTS VISITE;
DROP TABLE IF EXISTS INFIRMIERE;
DROP TABLE IF EXISTS MEDECIN;
DROP TABLE IF EXISTS PERSONNEL;
DROP TABLE IF EXISTS DEPARTEMENT;
DROP TABLE IF EXISTS CHAMBRE;
DROP TABLE IF EXISTS PATIENT;



-- TABLE DEPARTEMENT
CREATE TABLE DEPARTEMENT (
    NOM_DEP VARCHAR(50) PRIMARY KEY,
    CHEF INT
);
INSERT INTO DEPARTEMENT (NOM_DEP, CHEF) VALUES
('Cardiologie', NULL),
('Pédiatrie', NULL),
('Urgences', NULL),
('Chirurgie', NULL),
('Radiologie', NULL),
('Oncologie', NULL);


-- TABLE PERSONNEL
CREATE TABLE PERSONNEL (
    num_personnel INT  PRIMARY KEY,
    telephone VARCHAR(20),
    date_embauche DATE,
    e_mail VARCHAR(100),
    prenom VARCHAR(50),
    nom VARCHAR(50),
    NOM_DEP VARCHAR(50),
    FOREIGN KEY (NOM_DEP) REFERENCES DEPARTEMENT(NOM_DEP)
);
INSERT INTO PERSONNEL (num_personnel, telephone, date_embauche, e_mail, prenom, nom, NOM_DEP) VALUES
(100, '0611111111', '2022-01-01', 'marie.dupont@hopital.com', 'Marie', 'Dupont', 'Cardiologie'),
(101, '0622222222', '2021-02-15', 'ahmed.benali@hopital.com', 'Ahmed', 'Benali', 'Pédiatrie'),
(102, '0633333333', '2020-03-20', 'lina.karim@hopital.com', 'Lina', 'Karim', 'Urgences'),
(103, '0644444444', '2019-04-10', 'yacine.brahimi@hopital.com', 'Yacine', 'Brahimi', 'Chirurgie'),
(104, '0655555555', '2018-05-05', 'julien.morel@hopital.com', 'Julien', 'Morel', 'Radiologie'),
(105, '0666666666', '2023-06-12', 'fatima.zahra@hopital.com', 'Fatima', 'Zahra', 'Oncologie'),
(106, '0677777777', '2021-07-07', 'hassan.ali@hopital.com', 'Hassan', 'Ali', 'Cardiologie'),
(107, '0688888888', '2020-08-18', 'ines.said@hopital.com', 'Inès', 'Saïd', 'Pédiatrie'),
(108, '0699999999', '2019-09-25', 'mehdi.amrani@hopital.com', 'Mehdi', 'Amrani', 'Urgences'),
(109, '0600000000', '2022-10-10', 'samira.bouaziz@hopital.com', 'Samira', 'Bouaziz', 'Chirurgie');

ALTER TABLE PERSONNEL 
MODIFY COLUMN num_personnel INT AUTO_INCREMENT;




-- TABLE MEDECIN (sous-classe de PERSONNEL)


CREATE TABLE MEDECIN (
    num_personnel INT auto_increment PRIMARY KEY,
    Type VARCHAR(50),
    Disponibilite BOOLEAN,
    FOREIGN KEY (num_personnel) REFERENCES PERSONNEL(num_personnel),
    CHECK (Type IN ('Hospitalisation', 'Consultation'))
);


INSERT INTO MEDECIN (num_personnel, Type, Disponibilite) VALUES
(100, 'consultation', TRUE),
(101, 'consultation', TRUE),
(102, 'hospitalisation', TRUE),
(103, 'hospitalisation', TRUE),
(104, 'consultation', TRUE);


-- TABLE INFIRMIERE (sous-classe de PERSONNEL)
CREATE TABLE INFIRMIERE (
    num_personnel INT PRIMARY KEY,
    Disponibilite BOOLEAN,
    FOREIGN KEY (num_personnel) REFERENCES PERSONNEL(num_personnel)
);
INSERT INTO INFIRMIERE (num_personnel, Disponibilite) VALUES
(105, TRUE),
(106, TRUE),
(107, TRUE),
(108, TRUE),
(109, TRUE);


-- TABLE PATIENT
CREATE TABLE PATIENT (
    id_patient INT AUTO_INCREMENT  PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    sexe VARCHAR(10),
    adresse VARCHAR(100),
    e_mail VARCHAR(100)
);

-- TABLE CHAMBRE
CREATE TABLE CHAMBRE (
    num_chambre INT PRIMARY KEY,
    Surface FLOAT,
    Type VARCHAR(30),
    Nombre_de_lits INT,
    Occupation BOOLEAN,
    CHECK (Type IN ('Bloc Hospitalisation', 'Bloc Consultation'))
);



INSERT INTO CHAMBRE (num_chambre, Surface, Type, Nombre_de_lits, Occupation) VALUES
(1, 20.0, 'Bloc Hospitalisation', 1, TRUE),
(2, 25.5, 'Bloc Hospitalisation', 2, TRUE),
(3, 30.0, 'Bloc Hospitalisation', 3, TRUE),
(4, 15.0, 'Bloc Consultation', 1, TRUE),
(5, 18.5, 'Bloc Consultation', 1, TRUE),
(6, 22.0, 'Bloc Consultation', 2, TRUE);



-- TABLE VISITE

CREATE TABLE VISITE (
    num_visite INT AUTO_INCREMENT PRIMARY KEY,
    duree INT,
    date_visite DATE,
    time_of_visite TIME,
    motif VARCHAR(20),
    id_patient INT,
    num_chambre INT,
    NOM_DEP VARCHAR(50),
    FOREIGN KEY (id_patient) REFERENCES PATIENT(id_patient),
    FOREIGN KEY (num_chambre) REFERENCES CHAMBRE(num_chambre),
    FOREIGN KEY (NOM_DEP) REFERENCES DEPARTEMENT(NOM_DEP),
    CHECK (motif IN ('Hospitalisation', 'Consultation'))
);

-- TABLE HOSPITALISATION (sous-classe de VISITE)
CREATE TABLE HOSPITALISATION (
    id_hospitalisation INT PRIMARY KEY AUTO_INCREMENT,
    num_visite INT,
    type_hospitalisation VARCHAR(50),
    FOREIGN KEY (num_visite) REFERENCES VISITE(num_visite)
);

-- TABLE CONSULTATION (sous-classe de VISITE)
CREATE TABLE CONSULTATION (
    id_consultation INT PRIMARY KEY AUTO_INCREMENT,
    num_visite INT,
    prix DECIMAL(10,2),
    FOREIGN KEY (num_visite) REFERENCES VISITE(num_visite)
);

-- TABLE ANALYSE_MEDICAL

CREATE TABLE ANALYSE_MEDICAL (
    num_analyse INT PRIMARY KEY AUTO_INCREMENT,
    id_consultation INT,
    diagnostic TEXT,
    FOREIGN KEY (id_consultation) REFERENCES CONSULTATION(id_consultation),
    CHECK (diagnostic IN ('début de maladie', 'état instable', 'amélioration en cours', 'guéri'))
);

-- TABLE PARTICIPE (relation INFIRMIERE x HOSPITALISATION)
CREATE TABLE PARTICIPE (
    id_hospitalisation INT,
    num_personnel INT,
    PRIMARY KEY (id_hospitalisation, num_personnel),
    FOREIGN KEY (id_hospitalisation) REFERENCES HOSPITALISATION(id_hospitalisation),
    FOREIGN KEY (num_personnel) REFERENCES INFIRMIERE(num_personnel)
);

-- TABLE EFFECTUE (relation MEDECIN x VISITE)
CREATE TABLE EFFECTUE (
    num_personnel INT,
    num_visite INT,
    PRIMARY KEY (num_personnel, num_visite),
    FOREIGN KEY (num_personnel) REFERENCES MEDECIN(num_personnel),
    FOREIGN KEY (num_visite) REFERENCES VISITE(num_visite)
);


DROP TRIGGER IF EXISTS trg_insert_effectue;

DELIMITER //

CREATE TRIGGER trg_insert_effectue
AFTER INSERT ON VISITE
FOR EACH ROW
BEGIN
  DECLARE medecin_id INT;

  -- Récupérer un médecin disponible dont le type correspond au motif
  SELECT num_personnel
  INTO medecin_id
  FROM MEDECIN
  WHERE Disponibilite = TRUE
    AND LOWER(Type) = LOWER(NEW.motif)
  LIMIT 1;

  -- Si trouvé, insérer dans EFFECTUE
  IF medecin_id IS NOT NULL THEN
		INSERT INTO EFFECTUE (num_personnel, num_visite)
		VALUES (medecin_id, NEW.num_visite);

		UPDATE MEDECIN
		SET Disponibilite = FALSE
		WHERE num_personnel = medecin_id;

  END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_insert_consultation_or_hospitalisation
AFTER INSERT ON VISITE
FOR EACH ROW
BEGIN
  -- Si le motif est consultation
  IF LOWER(NEW.motif) = 'consultation' THEN
    INSERT INTO CONSULTATION (id_consultation, num_visite, prix)
    VALUES (NULL, NEW.num_visite, 50.00);  -- id_consultation auto

  -- Si le motif est hospitalisation
  ELSEIF LOWER(NEW.motif) = 'hospitalisation' THEN
    INSERT INTO HOSPITALISATION (id_hospitalisation, num_visite, type_hospitalisation)
    VALUES (NULL, NEW.num_visite, 'hospitalisation standard');  -- id_hospitalisation auto
  END IF;
END //


DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_insert_analyse_medicale
AFTER INSERT ON CONSULTATION
FOR EACH ROW
BEGIN
    DECLARE choix INT;
    DECLARE diagnostique TEXT;

    -- Générer un nombre aléatoire entre 1 et 4
    SET choix = FLOOR(1 + (RAND() * 4));

    -- Sélectionner un diagnostic en fonction du nombre
    CASE choix
        WHEN 1 THEN SET diagnostique = 'guéri';
        WHEN 2 THEN SET diagnostique = 'début de maladie';
        WHEN 3 THEN SET diagnostique = 'amélioration en cours';
        WHEN 4 THEN SET diagnostique = 'état instable';
    END CASE;

    -- Insertion dans la table ANALYSE_MEDICAL
    INSERT INTO ANALYSE_MEDICAL (
        num_analyse,
        id_consultation,
        diagnostic
    )
    VALUES (
        NULL,
        NEW.id_consultation,
        diagnostique
    );
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_participe_after_hospitalisation
AFTER INSERT ON HOSPITALISATION
FOR EACH ROW
BEGIN
    DECLARE inf_id INT;

    -- Trouver une infirmière disponible
    SELECT num_personnel INTO inf_id
    FROM INFIRMIERE
    WHERE Disponibilite = TRUE
    LIMIT 1;

    -- Si trouvée, l'ajouter dans PARTICIPE et la rendre indisponible
    IF inf_id IS NOT NULL THEN
        INSERT INTO PARTICIPE (id_hospitalisation, num_personnel)
        VALUES (NEW.id_hospitalisation, inf_id);

        UPDATE INFIRMIERE
        SET Disponibilite = FALSE
        WHERE num_personnel = inf_id;
    END IF;
END //

DELIMITER ;

-- les vues :
CREATE VIEW vue_patient_visite AS
SELECT 
    p.id_patient,
    CONCAT(p.prenom, ' ', p.nom) AS nom_complet,
    v.date_visite,
    v.motif,
    v.NOM_DEP
FROM PATIENT p
JOIN VISITE v ON p.id_patient = v.id_patient;

drop view if exists vue_visites_medecins;
CREATE VIEW vue_visites_medecins AS
SELECT 
    c.id_consultation AS id_visite_detail,
    'consultation' AS type_visite,
    v.date_visite,
    v.id_patient,
    p.nom AS nom_patient,
    p.prenom AS prenom_patient,
    m.num_personnel AS id_medecin,
    pers.nom AS nom_medecin,
    a.diagnostic
FROM CONSULTATION c
JOIN VISITE v ON c.num_visite = v.num_visite
JOIN PATIENT p ON v.id_patient = p.id_patient
JOIN EFFECTUE e ON e.num_visite = v.num_visite
JOIN MEDECIN m ON m.num_personnel = e.num_personnel
JOIN PERSONNEL pers ON pers.num_personnel = m.num_personnel
JOIN ANALYSE_MEDICAL a ON a.id_consultation = c.id_consultation

UNION ALL

SELECT 
    h.id_hospitalisation AS id_visite_detail,
    'hospitalisation' AS type_visite,
    v.date_visite,
    v.id_patient,
    p.nom AS nom_patient,
    p.prenom AS nom_patient,
    m.num_personnel AS id_medecin,
    pers.nom AS nom_medecin,
    NULL AS diagnostic  -- pas de diagnostic si ANALYSE_MEDICAL lié à CONSULTATION seulement
FROM HOSPITALISATION h
JOIN VISITE v ON h.num_visite = v.num_visite
JOIN PATIENT p ON v.id_patient = p.id_patient
JOIN EFFECTUE e ON e.num_visite = v.num_visite
JOIN MEDECIN m ON m.num_personnel = e.num_personnel
JOIN PERSONNEL pers ON pers.num_personnel = m.num_personnel;

drop view if exists vue_hospitalisation_infirmiere ;
CREATE VIEW vue_hospitalisation_infirmiere AS
SELECT 
    h.id_hospitalisation,
    v.date_visite,
    v.id_patient,
    p.nom AS prenom_patient,
    i.num_personnel AS id_infirmiere,
    pers.nom AS nom_infirmiere
FROM HOSPITALISATION h
JOIN VISITE v ON h.num_visite = v.num_visite
JOIN PATIENT p ON v.id_patient = p.id_patient
JOIN PARTICIPE pa ON pa.id_hospitalisation = h.id_hospitalisation
JOIN INFIRMIERE i ON i.num_personnel = pa.num_personnel
JOIN PERSONNEL pers ON pers.num_personnel = i.num_personnel;

CREATE VIEW vue_medecins_disponibles AS
SELECT 
    m.num_personnel,
    pers.nom,
    pers.prenom,
    m.Type,
    m.Disponibilite
FROM MEDECIN m
JOIN PERSONNEL pers ON m.num_personnel = pers.num_personnel
WHERE m.Disponibilite = TRUE;



DROP VIEW IF EXISTS vue_occupation_chambres;
CREATE OR REPLACE VIEW vue_occupation_chambres AS
SELECT 
    c.num_chambre,
    c.Type,
    c.Nombre_de_lits,
    c.Occupation,
    v.num_visite
FROM CHAMBRE c
LEFT JOIN VISITE v ON c.num_chambre = v.num_chambre;

select * from vue_occupation_chambres;


SET SQL_SAFE_UPDATES = 0;
-- Puis tu peux vider la table :
DELETE FROM effectue;
delete FROM patient;
delete FROM VISITE ;
-- Ensuite tu peux le réactiver si tu veux :
SET SQL_SAFE_UPDATES = 1;







select pe.nom ,pe.num_personnel from personnel  pe, infirmiere i,participe pa,
hospitalisation h, visite v, patient p
where   pe.num_personnel=i.num_personnel and i.num_personnel=pa.num_personnel 
and pa.id_hospitalisation=h.id_hospitalisation and h.num_visite=v.num_visite
and v.id_patient=p.id_patient and p.prenom='assioui';

INSERT INTO CHAMBRE (num_chambre, Surface, Type, Nombre_de_lits, Occupation)
VALUES (7, 28.5, 'Bloc Hospitalisation', 2, FALSE);
