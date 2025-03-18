-- Procédures et Fonctions
-- 1) Procédure d'édition de données
-- Objectif : Met à jour le temps d'une participation individuelle.
CREATE OR REPLACE PROCEDURE P17_Proc_UpdateTemps(NagID INT, IDEpreuve INT, NouveauTemps VARCHAR(10))
AS $$
BEGIN
    UPDATE P17_ParticiperIndividuel
    SET Temps = NouveauTemps
    WHERE NageurID = NagID AND EpreuveID = IDEpreuve;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erreur lors de la mise à jour du temps pour NageurID = %, EpreuveID = %', NagID, IDEpreuve;
END;
$$ LANGUAGE plpgsql;

CALL P17_Proc_UpdateTemps(1, 16, '0:45.78');

-- 2) Fonction qui retourne une valeur simple
-- Objectif : Retourne le nombre total de médailles d'or gagnées par un nageur donné.
CREATE OR REPLACE FUNCTION P17_Func_MedaillesOr(NagID INT)
RETURNS INT AS
$$
DECLARE
    total_or INT;
BEGIN
    SELECT COUNT(*) INTO total_or
    FROM P17_ParticiperIndividuel
    WHERE NageurID = NagID AND Medaille = 'Or';
    RETURN total_or;
END;
$$ LANGUAGE plpgsql;

SELECT P17_Func_MedaillesOr(232);


-- 3) Fonction qui retourne un ensemble de valeurs
-- Objectif : Retourne la liste des épreuves où un nageur a obtenu une médaille d'or.
CREATE OR REPLACE FUNCTION P17_Func_EpreuvesOr(NagID INT)
RETURNS TABLE(EpreuveID INT, EpreuveDistance VARCHAR ,EpreuveType VARCHAR, EpreuveDate DATE)
AS
$$
BEGIN
    RETURN QUERY
    SELECT E.EpreuveID, E.EpreuveDistance ,E.EpreuveType, E.EpreuveDate
    FROM P17_ParticiperIndividuel PI
    JOIN P17_Epreuves E ON E.EpreuveID = PI.EpreuveID
    WHERE PI.NageurID = NagID AND PI.Medaille = 'Or';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM P17_Func_EpreuvesOr(232);

-- 4) Procédure utilisant un curseur paramétrique
-- Objectif : Affiche les nageurs ayant obtenu une médaille dans les épreuves individuelles.
CREATE OR REPLACE PROCEDURE P17_Proc_AfficheGagnantMedaille()
AS $$
DECLARE
    cur CURSOR FOR
    SELECT DISTINCT N.NageurNom, N.NageurPrenom
    FROM P17_Nageurs N
    JOIN P17_ParticiperIndividuel PI ON N.NageurID = PI.NageurID
    WHERE PI.Medaille = 'Or' OR PI.Medaille = 'Argent' OR PI.Medaille = 'Bronze';
    record RECORD;
BEGIN
    FOR record IN cur LOOP
        RAISE NOTICE 'Nageur: % %', record.NageurNom, record.NageurPrenom;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL P17_Proc_AfficheGagnantMedaille();
