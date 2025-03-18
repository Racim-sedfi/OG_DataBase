-- Procédures et Fonctions
-- 1) Procédure d'édition de données
-- Objectif : Met à jour le temps d'une participation individuelle.
CREATE OR REPLACE PROCEDURE P17_Proc_UpdateTemps(
    NagID IN INT,
    IDEpreuve IN INT,
    NouveauTemps IN VARCHAR2
)
AS
BEGIN
    UPDATE P17_ParticiperIndividuel
    SET Temps = NouveauTemps
    WHERE NageurID = NagID AND EpreuveID = IDEpreuve;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur lors de la mise à jour du temps pour NageurID = ' || NagID || ', EpreuveID = ' || IDEpreuve);
END;
/

-- Appel
BEGIN
    P17_Proc_UpdateTemps(1, 16, '0:45.78');
END;
/

-- 2) Fonction qui retourne une valeur simple
-- Objectif : Retourne le nombre total de médailles d'or gagnées par un nageur donné.
CREATE OR REPLACE FUNCTION P17_Func_MedaillesOr(
    NagID IN INT
) RETURN INT
AS
    total_or INT;
BEGIN
    SELECT COUNT(*) INTO total_or
    FROM P17_ParticiperIndividuel
    WHERE NageurID = NagID AND Medaille = 'Or';

    RETURN total_or;
END;
/

-- Appel
SELECT P17_Func_MedaillesOr(232) FROM DUAL;


-- 3) Fonction qui retourne un ensemble de valeurs
-- Objectif : Retourne la liste des épreuves où un nageur a obtenu une médaille d'or.
CREATE OR REPLACE FUNCTION P17_Func_EpreuvesOr(
    NagID IN INT
) RETURN SYS_REFCURSOR
AS
    result SYS_REFCURSOR;
BEGIN
    OPEN result FOR
    SELECT E.EpreuveID, E.EpreuveDistance, E.EpreuveType, E.EpreuveDate
    FROM P17_ParticiperIndividuel PI
    JOIN P17_Epreuves E ON E.EpreuveID = PI.EpreuveID
    WHERE PI.NageurID = NagID AND PI.Medaille = 'Or';

    RETURN result;
END;
/

-- Appel
DECLARE
    cur SYS_REFCURSOR;
    epreuve_id INT;
    epreuve_distance VARCHAR2(50);
    epreuve_type VARCHAR2(100);
    epreuve_date DATE;
BEGIN
    cur := P17_Func_EpreuvesOr(232);

    LOOP
        FETCH cur INTO epreuve_id, epreuve_distance, epreuve_type, epreuve_date;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('EpreuveID: ' || epreuve_id || ', Distance: ' || epreuve_distance || ', Type: ' || epreuve_type || ', Date: ' || epreuve_date);
    END LOOP;

    CLOSE cur;
END;
/

-- 4) Procédure utilisant un curseur paramétrique
-- Objectif : Affiche les nageurs ayant obtenu une médaille dans les épreuves individuelles.
CREATE OR REPLACE PROCEDURE P17_Proc_AfficheGagnantMedaille
AS
    CURSOR cur IS
    SELECT DISTINCT N.NageurNom, N.NageurPrenom
    FROM P17_Nageurs N
    JOIN P17_ParticiperIndividuel PI ON N.NageurID = PI.NageurID
    WHERE PI.Medaille IN ('Or', 'Argent', 'Bronze');

    record cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO record;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nageur: ' || record.NageurNom || ' ' || record.NageurPrenom);
    END LOOP;
    CLOSE cur;
END;
/

-- Appel
BEGIN
    P17_Proc_AfficheGagnantMedaille;
END;
/
