-- Suppression de la seéquence si elle exite déjà
DROP SEQUENCE seq_P17_Epreuves
-- Création de la séquence et de la table P17_Epreuves
CREATE SEQUENCE seq_P17_Epreuves START WITH 1 INCREMENT BY 1;

CREATE TABLE P17_Epreuves (
    EpreuveID INT PRIMARY KEY,
    EpreuveDistance VARCHAR2(50),
    EpreuveType VARCHAR2(100),
    EpreuveCategorie CHAR(1),
    EpreuveTour VARCHAR2(50),
    EpreuveDate VARCHAR2(10), -- VARCHAR à la place de DATE pour éviter l'erreur de type lors de l'alimentation de la table sur oracle 
    EpreuveHeure VARCHAR2(8) -- VARCHAR à la place de DATE pour éviter l'erreur de type lors de l'alimentation de la table sur oracle
);

CREATE OR REPLACE TRIGGER trg_P17_Epreuves
BEFORE INSERT ON P17_Epreuves
FOR EACH ROW
BEGIN
    :NEW.EpreuveID := seq_P17_Epreuves.NEXTVAL;
END;
/

-- Suppression de la seéquence si elle exite déjà
DROP SEQUENCE seq_P17_Nageurs
-- Création de la séquence et de la table P17_Nageurs
CREATE SEQUENCE seq_P17_Nageurs START WITH 1 INCREMENT BY 1;

CREATE TABLE P17_Nageurs (
    NageurID INT PRIMARY KEY,
    NageurNom VARCHAR2(50),
    NageurPrenom VARCHAR2(50),
    NageurSexe CHAR(1),
    NageurPays CHAR(3),
    NageurDateNaissance VARCHAR2(10) -- VARCHAR à la place de DATE pour éviter l'erreur de type lors de l'alimentation de la table sur oracle
);

CREATE OR REPLACE TRIGGER trg_P17_Nageurs
BEFORE INSERT ON P17_Nageurs
FOR EACH ROW
BEGIN
    :NEW.NageurID := seq_P17_Nageurs.NEXTVAL;
END;
/

-- Suppression de la seéquence si elle exite déjà

DROP SEQUENCE seq_P17_RelaisEquipe
-- Création de la séquence et de la table P17_RelaisEquipe
CREATE SEQUENCE seq_P17_RelaisEquipe START WITH 1 INCREMENT BY 1;

CREATE TABLE P17_RelaisEquipe (
    RelaisEquipeID INT PRIMARY KEY,
    RelaisEquipePays CHAR(3)
);

CREATE OR REPLACE TRIGGER trg_P17_RelaisEquipe
BEFORE INSERT ON P17_RelaisEquipe
FOR EACH ROW
BEGIN
    :NEW.RelaisEquipeID := seq_P17_RelaisEquipe.NEXTVAL;
END;
/

-- Table P17_ComposerEquipe
CREATE TABLE P17_ComposerEquipe (
    RelaisEquipeID INT,
    NageurID INT,
    PRIMARY KEY (RelaisEquipeID, NageurID),
    FOREIGN KEY (RelaisEquipeID) REFERENCES P17_RelaisEquipe(RelaisEquipeID),
    FOREIGN KEY (NageurID) REFERENCES P17_Nageurs(NageurID)
);

-- Table P17_ParticiperEquipe
CREATE TABLE P17_ParticiperEquipe (
    RelaisEquipeID INT,
    EpreuveID INT,
    Position INT,
    Temps VARCHAR2(10),
    Couloir INT,
    Medaille VARCHAR2(10),
    PRIMARY KEY (RelaisEquipeID, EpreuveID),
    FOREIGN KEY (RelaisEquipeID) REFERENCES P17_RelaisEquipe(RelaisEquipeID),
    FOREIGN KEY (EpreuveID) REFERENCES P17_Epreuves(EpreuveID)
);

-- Table P17_ParticiperIndividuel
CREATE TABLE P17_ParticiperIndividuel (
    NageurID INT,
    EpreuveID INT,
    Position INT,
    Temps VARCHAR2(10),
    Couloir INT,
    Medaille VARCHAR2(10),
    PRIMARY KEY (NageurID, EpreuveID),
    FOREIGN KEY (NageurID) REFERENCES P17_Nageurs(NageurID),
    FOREIGN KEY (EpreuveID) REFERENCES P17_Epreuves(EpreuveID)
);
