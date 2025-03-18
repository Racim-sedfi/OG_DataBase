-- Vues
-- Vue des médailles par nageur
CREATE VIEW P17_Vue_MedaillesNageur AS
SELECT
    N.NageurNom,
    N.NageurPrenom,
    N.NageurPays,
    COUNT(CASE WHEN PI.Medaille = 'Or' THEN 1 END) AS Nb_Or,
    COUNT(CASE WHEN PI.Medaille = 'Argent' THEN 1 END) AS Nb_Argent,
    COUNT(CASE WHEN PI.Medaille = 'Bronze' THEN 1 END) AS Nb_Bronze
FROM
    P17_Nageurs N
    JOIN P17_ParticiperIndividuel PI ON N.NageurID = PI.NageurID
GROUP BY
    N.NageurNom, N.NageurPrenom, N.NageurPays;

SELECT * FROM P17_Vue_MedaillesNageur;

-- Vue des résultats des épreuves par date
CREATE VIEW P17_Vue_ClassementEpreuves AS
SELECT
    E.EpreuveDate,
    E.EpreuveDistance,
    E.EpreuveType,
    E.EpreuveTour,
    PI.Position,
    N.NageurNom,
    N.NageurPrenom,
    PI.Temps
FROM
    P17_Epreuves E
    JOIN P17_ParticiperIndividuel PI ON E.EpreuveID = PI.EpreuveID
    JOIN P17_Nageurs N ON N.NageurID = PI.NageurID
ORDER BY
    E.EpreuveDate, E.EpreuveDistance, PI.Position;

SELECT * FROM P17_Vue_ClassementEpreuves;

-- Vue des équipes gagnantes
CREATE VIEW P17_Vue_EquipesGagnantes AS
SELECT
    E.EpreuveDate,
    E.EpreuveDistance,
    E.EpreuveType,
    E.EpreuveTour,
    PE.Medaille,
    RE.RelaisEquipePays
FROM
    P17_Epreuves E
    JOIN P17_ParticiperEquipe PE ON E.EpreuveID = PE.EpreuveID
    JOIN P17_RelaisEquipe RE ON RE.RelaisEquipeID = PE.RelaisEquipeID
WHERE
    PE.Medaille IN ('Or', 'Argent', 'Bronze');

SELECT * FROM P17_Vue_EquipesGagnantes;


