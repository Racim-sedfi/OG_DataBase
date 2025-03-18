-- Triggers
-- 1) Statement.
CREATE TABLE IF NOT EXISTS P17_Statistiques (
    StatID INT PRIMARY KEY DEFAULT 1,
    NbTotalNageurs INT
);

CREATE OR REPLACE FUNCTION P17_Func_UpdateTotalNageurs()
RETURNS TRIGGER AS $$
BEGIN
    -- Met à jour le total des nageurs dans la table P17_Statistiques
    UPDATE P17_Statistiques
    SET NbTotalNageurs = (SELECT COUNT(*) FROM P17_Nageurs)
    WHERE StatID = 1;

    -- Insérer la ligne si elle n'existe pas
    INSERT INTO P17_Statistiques (StatID, NbTotalNageurs)
    VALUES (1, (SELECT COUNT(*) FROM P17_Nageurs))
    ON CONFLICT (StatID) DO NOTHING;

    RETURN NULL;  -- Ce trigger ne modifie pas les lignes
END;
$$ LANGUAGE plpgsql;

-- Création du trigger
CREATE TRIGGER P17_Trigger_UpdateTotalNageurs
AFTER INSERT OR DELETE
ON P17_Nageurs
FOR EACH STATEMENT
EXECUTE FUNCTION P17_Func_UpdateTotalNageurs();

-- Insertion multiple de nageurs
INSERT INTO P17_Nageurs (NageurID, NageurNom, NageurPrenom, NageurSexe, NageurPays, NageurDateNaissance)
VALUES
    (853,'Dupont', 'Jean', 'H', 'FRA', '2000-05-12'),
    (854, 'Martin', 'Sophie', 'F', 'USA', '1998-03-22'),
    (855, 'Nguyen', 'Paul', 'H', 'VIE', '2002-10-15');

-- Suppression d'un nageur
DELETE FROM P17_Nageurs
WHERE NageurNom = 'Dupont' AND nageurprenom = 'Jean';

-- Vérification des statistiques
SELECT * FROM P17_Statistiques;

-- 2) ROW
CREATE TABLE IF NOT EXISTS P17_HistoriqueModifications (
    HistoriqueID SERIAL PRIMARY KEY,
    OperationType VARCHAR(10),     -- Type d'opération (INSERT, UPDATE, DELETE)
    NageurID INT,                  -- L'identifiant du nageur impacté
    EpreuveID INT,                 -- L'épreuve associée
    DateModification TIMESTAMP,    -- Date de la modification
    ValeursAnciennes JSONB,        -- Anciennes valeurs (pour UPDATE/DELETE)
    ValeursNouvelles JSONB         -- Nouvelles valeurs (pour INSERT/UPDATE)
);

CREATE OR REPLACE FUNCTION P17_Func_LogModifications()
RETURNS TRIGGER AS $$
BEGIN
    -- Insérer dans la table P17_HistoriqueModifications
    INSERT INTO P17_HistoriqueModifications (
        OperationType,
        NageurID,
        EpreuveID,
        DateModification,
        ValeursAnciennes,
        ValeursNouvelles
    )
    VALUES (
        TG_OP,  -- Type d'opération (INSERT, UPDATE, DELETE)
        COALESCE(OLD.NageurID, NEW.NageurID),
        COALESCE(OLD.EpreuveID, NEW.EpreuveID),
        CURRENT_TIMESTAMP,
        TO_JSONB(OLD),
        TO_JSONB(NEW)
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Création du trigger
CREATE TRIGGER P17_Trigger_LogModifications
AFTER INSERT OR UPDATE OR DELETE
ON P17_ParticiperIndividuel
FOR EACH ROW
EXECUTE FUNCTION P17_Func_LogModifications();

-- Insertion d'une nouvelle participation
INSERT INTO P17_ParticiperIndividuel (NageurID, EpreuveID, Position, Temps, Couloir, Medaille)
VALUES (1, 101, 1, '00:50.11', 3, 'Or');

-- Mise à jour d'une participation existante
UPDATE P17_ParticiperIndividuel
SET Medaille = 'Argent'
WHERE NageurID = 1 AND EpreuveID = 101;

-- Suppression d'une participation
DELETE FROM P17_ParticiperIndividuel
WHERE NageurID = 1 AND EpreuveID = 101;

-- Vérification des modifications
SELECT * FROM P17_HistoriqueModifications;
