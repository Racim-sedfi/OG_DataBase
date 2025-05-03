CREATE TABLE P17_Epreuves (
    EpreuveID SERIAL PRIMARY KEY,
    EpreuveDistance VARCHAR(50),
    EpreuveType VARCHAR(100),
    EpreuveCategorie VARCHAR(1),
    EpreuveTour VARCHAR(50),
    EpreuveDate DATE,
    EpreuveHeure TIME
);

CREATE TABLE P17_Nageurs (
    NageurID SERIAL PRIMARY KEY,
    NageurNom VARCHAR(50),
    NageurPrenom VARCHAR(50),
    NageurSexe CHAR(1),
    NageurPays CHAR(3),
    NageurDateNaissance DATE
);

CREATE TABLE P17_RelaisEquipe (
    RelaisEquipeID SERIAL PRIMARY KEY,
    RelaisEquipePays CHAR(3)
);

CREATE TABLE P17_ComposerEquipe (
    RelaisEquipeID INT,
    NageurID INT,
    PRIMARY KEY (RelaisEquipeID, NageurID),
    FOREIGN KEY (RelaisEquipeID) REFERENCES P17_RelaisEquipe(RelaisEquipeID),
    FOREIGN KEY (NageurID) REFERENCES P17_Nageurs(NageurID)
);


CREATE TABLE P17_ParticiperEquipe (
    RelaisEquipeID INT,
    EpreuveID INT,
    Position INT,
    Temps VARCHAR(10),
    Couloir INT,
    Medaille VARCHAR(10),
    PRIMARY KEY (RelaisEquipeID, EpreuveID),
    FOREIGN KEY (RelaisEquipeID) REFERENCES P17_RelaisEquipe(RelaisEquipeID),
    FOREIGN KEY (EpreuveID) REFERENCES P17_Epreuves(EpreuveID)
);

CREATE TABLE P17_ParticiperIndividuel (
    NageurID INT,
    EpreuveID INT,
    Position INT,
    Temps VARCHAR(10),
    Couloir INT,
    Medaille VARCHAR(10),
    PRIMARY KEY (NageurID, EpreuveID),
    FOREIGN KEY (NageurID) REFERENCES P17_Nageurs(NageurID),
    FOREIGN KEY (EpreuveID) REFERENCES P17_Epreuves(EpreuveID)
);
