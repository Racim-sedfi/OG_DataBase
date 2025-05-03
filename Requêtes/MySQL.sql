-- 1) Expression rationnelle

/*   LA DOC ( VOUS EN AUREZ BESOIN ) !!

     ** La requête retournera les nageurs dont les noms respectent ces contraintes stricte. **

    - ^(?=.*[A-Z]{2}) :
    La chaîne doit contenir au moins deux lettres majuscules consécutives.

    - (?!.*[aeiou]{4}) :
    Interdit toute séquence de quatre voyelles minuscules consécutives (aeiou).

    - (?=.{10,}) :
    Spécifie que la chaîne doit avoir au moins 10 caractères.

    - (?!.*(.)\\1{2}) :
    Rejette toute chaîne contenant le même caractère répété trois fois consécutivement.

    - [A-Za-z0-9]{5,10}$ :
    Limite la chaîne à des caractères alphanumériques uniquement et sa longueur à entre 5 et 10 caractères.

*/

SELECT
    NageurNom,
    NageurPrenom,
    NageurPays
FROM
    P17_Nageurs
WHERE
    NageurNom REGEXP '^(?=.*[A-Z]{2})(?!.*[aeiou]{4})(?=.{10,})(?!.*(.)\\1{2})[A-Za-z0-9]{5,10}$';

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- 2)

-- Requête 1 : Récupération des nageurs et de leurs participations individuelles

-- a)

--  Version 1 : Syntaxe implicite

-- en utilisant une condition de jointure dans la clause WHERE.

SELECT DISTINCT N.NageurNom, N.NageurPrenom, N.NageurPays, E.EpreuveDistance, E.EpreuveType, E.EpreuveCategorie, E.EpreuveTour, E.EpreuveDate, E.EpreuveHeure, PI.Couloir, PI.Position, PI.Temps, PI.Medaille
FROM P17_Nageurs N, P17_ParticiperIndividuel PI , P17_Epreuves E
WHERE N.NageurID = PI.NageurID AND PI.EpreuveID = E.EpreuveID ;

-- Temps d'exécution : 0.00829325 ms


-- Version 2 :  Syntaxe explicite
-- en utilisant une syntaxe explicite avec INNER JOIN.

SELECT DISTINCT N.NageurNom, N.NageurPrenom, N.NageurPays, E.EpreuveDistance, E.EpreuveType, E.EpreuveCategorie, E.EpreuveTour, E.EpreuveDate, E.EpreuveHeure, PI.Couloir, PI.Position, PI.Temps, PI.Medaille
FROM P17_Nageurs N
         INNER JOIN P17_ParticiperIndividuel PI ON N.NageurID = PI.NageurID
         INNER JOIN P17_Epreuves E ON PI.EpreuveID = E.EpreuveID;

-- Temps d'exécution : 0.0083395 ms


-- b)  Version 3 :  Jointure externe (gauche)
-- Cette requête inclut tous les nageurs même s'ils n'ont pas de participation individuelle.

SELECT DISTINCT N.NageurNom, N.NageurPrenom, N.NageurPays, E.EpreuveDistance, E.EpreuveType, E.EpreuveCategorie, E.EpreuveTour, E.EpreuveDate, E.EpreuveHeure, PI.Couloir, PI.Position, PI.Temps, PI.Medaille
FROM P17_Nageurs N
         LEFT JOIN P17_ParticiperIndividuel PI ON N.NageurID = PI.NageurID
         LEFT JOIN P17_Epreuves E ON PI.EpreuveID = E.EpreuveID;

-- Temps d'exécution : 0.008598 ms


-- EXPLICATION POURQUOI C'EST DIFFÉRENT AVEC LA JOINTURE INTERNE ?
/*
Avec une jointure externe, les nageurs sans participation (aucune correspondance dans P17_ParticiperIndividuel) apparaîtront dans les résultats avec des valeurs NULL.

Les résultats diffèrent de la jointure interne car la jointure externe inclut les nageurs sans participation.
*/


-- c) Version 4 : Produit cartésien avec restriction
-- Cette requête utilise un produit cartésien avec deux restrictions correspondant aux clés de jointure.

SELECT DISTINCT N.NageurNom, N.NageurPrenom, N.NageurPays,
                E.EpreuveDistance, E.EpreuveType, E.EpreuveCategorie,
                E.EpreuveTour, E.EpreuveDate, E.EpreuveHeure,
                PI.Couloir, PI.Position, PI.Temps, PI.Medaille
FROM P17_Nageurs N, P17_ParticiperIndividuel PI, P17_Epreuves E
WHERE N.NageurID = PI.NageurID
  AND PI.EpreuveID = E.EpreuveID;

-- Temps d'exécution : 0.00829325 ms


-- COMPARAISON DES TEMPS D'EXÉCUTION
/*
 1  -   Jointures internes (Versions 1 et 2) :

	Les temps sont très proches entre la syntaxe implicite et explicite (0.00829325 ms vs 0.0083395 ms).
    La différence minime peut être attribuée à la façon dont MySQL traite les jointures :
    La syntaxe explicite est plus lisible mais légèrement plus coûteuse à analyser pour le moteur SQL.

2 -		Jointure externe (Version 3) :

    Temps légèrement plus élevé (0.008598 ms) en raison de l'inclusion des lignes non appariées (nageurs sans participation ou participation sans épreuve).

3 -		Produit cartésien (Version 4) :

    Temps identique à la syntaxe implicite (0.00829325 ms) car le moteur SQL optimise les conditions dans la clause WHERE en les traitant comme des jointures internes.
    Remarque :  elle devient très inefficace pour des données volumineuses ou des requêtes complexes.
*/





-- Requête 2 : Liste des nageurs ayant participé à plusieurs épreuves


-- a) Version 1 : Syntaxe implicite

SELECT DISTINCT N.NageurNom, N.NageurPrenom
FROM P17_Nageurs N, P17_ParticiperIndividuel PI1, P17_ParticiperIndividuel PI2
WHERE N.NageurID = PI1.NageurID
  AND N.NageurID = PI2.NageurID
  AND PI1.EpreuveID <> PI2.EpreuveID;

-- Temps d'exécution : 0.018834 ms


-- Version 2 : Syntaxe explicite

SELECT DISTINCT N.NageurNom, N.NageurPrenom
FROM P17_Nageurs N
         INNER JOIN P17_ParticiperIndividuel PI1 ON N.NageurID = PI1.NageurID
         INNER JOIN P17_ParticiperIndividuel PI2 ON N.NageurID = PI2.NageurID
WHERE PI1.EpreuveID <> PI2.EpreuveID;

-- Temps d'exécution : 0.01878925 ms



-- Version 3 : Version avec jointure externe
-- Cette requête inclut tous les nageurs, même s'ils n'ont participé qu'à une seule épreuve,
-- et vérifie ceux ayant participé à deux épreuves distinctes.

-- Avec une RIGHT JOIN, tous les nageurs apparaissent, même s’ils n’ont pas participé à plusieurs épreuves (dans ce cas, ces lignes sont exclues via WHERE).


SELECT DISTINCT N.NageurNom, N.NageurPrenom
FROM P17_ParticiperIndividuel PI1
         RIGHT JOIN P17_Nageurs N ON PI1.NageurID = N.NageurID
         RIGHT JOIN P17_ParticiperIndividuel PI2 ON N.NageurID = PI2.NageurID
WHERE PI1.EpreuveID IS NOT NULL
  AND PI1.EpreuveID <> PI2.EpreuveID;

-- Temps d'exécution : 0.01876125 ms




-- Version avec  Produit cartésien + restriction

SELECT DISTINCT N.NageurNom, N.NageurPrenom
FROM P17_Nageurs N, P17_ParticiperIndividuel PI1, P17_ParticiperIndividuel PI2
WHERE N.NageurID = PI1.NageurID
  AND N.NageurID = PI2.NageurID
  AND PI1.EpreuveID <> PI2.EpreuveID;

-- Temps d'exécution : 0.01878875 ms


-- COMPARAISON DES TEMPS D'EXÉCUTION
/*
1-		Jointures internes (Versions 1 et 2) :

   -  Les temps sont très proches (0.018834 ms pour la syntaxe implicite et 0.01878925 ms pour la syntaxe explicite).
   -  Les deux versions produisent les mêmes résultats, mais la syntaxe explicite est préférée pour sa lisibilité et sa maintenance.

2-		Jointure externe (Version 3) :

    - Le temps est légèrement plus bas (0.01876125 ms), mais cette différence est insignifiante dans ce contexte.
    - La RIGHT JOIN commence par inclure tous les nageurs, même ceux n’ayant pas de participation multiple. Cependant, la clause WHERE élimine ces lignes.
    - Cette version est pertinente si on veut être sûr que tous les nageurs sont pris en compte.

3-		Produit cartésien (Version 4) :

    - Temps très proche de la syntaxe explicite (0.01878875 ms). Cela est dû au fait que MySQL optimise souvent les conditions dans la clause WHERE en traitant le produit cartésien comme une jointure interne.
    - Cette méthode n'est pas recommandée pour des tables volumineuses ou complexes, car elle devient très coûteuse.

*/

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- 3) Opérateurs ensemblistes
-- a) UNION:

/*Cette requête combine deux ensembles de résultats :
     - Les nageurs individuels ayant remporté une médaille d'or.
     -  Les équipes de relais ayant remporté une médaille d'or.
     -  Chaque ensemble est homogénéisé avec des colonnes correspondantes (NULL pour les colonnes inutiles).*/

SELECT
    N.NageurNom AS Nom,
    N.NageurPrenom AS Prenom,
    NULL AS Equipe,
    'Individuel' AS TypeParticipation,
    PI.EpreuveID AS Epreuve,
    PI.Medaille
FROM
    P17_Nageurs N
        JOIN
    P17_ParticiperIndividuel PI
    ON N.NageurID = PI.NageurID
WHERE
    PI.Medaille = 'Or'

UNION

SELECT
    NULL AS Nom,
    NULL AS Prenom,
    RE.RelaisEquipePays AS Equipe,
    'Relais' AS TypeParticipation,
    PE.EpreuveID AS Epreuve,
    PE.Medaille
FROM
    P17_RelaisEquipe RE
        JOIN
    P17_ParticiperEquipe PE
    ON RE.RelaisEquipeID = PE.RelaisEquipeID
WHERE
    PE.Medaille = 'Or';

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- b) INTERSECT:

/*  Cette requête trouve l'intersection entre:

    Les nageurs ayant participé à des épreuves individuelles.
    Les nageurs ayant participé à des relais (épreuves d'équipe).

    */
-- version AVEC INTERSECT
SELECT
    N.NageurNom,
    N.NageurPrenom
FROM
    P17_Nageurs N
        JOIN
    P17_ParticiperIndividuel PI
    ON N.NageurID = PI.NageurID
INTERSECT
SELECT
    N.NageurNom,
    N.NageurPrenom
FROM
    P17_Nageurs N
        JOIN
    P17_ComposerEquipe CE
    ON N.NageurID = CE.NageurID;

-- version 2 SANS INTERSECT

SELECT DISTINCT
    N1.NageurNom,
    N1.NageurPrenom
FROM
    P17_Nageurs N1
        JOIN (
        SELECT DISTINCT N.NageurID
        FROM P17_Nageurs N
                 JOIN P17_ParticiperIndividuel PI ON N.NageurID = PI.NageurID
    ) AS Individuel ON N1.NageurID = Individuel.NageurID
        JOIN (
        SELECT DISTINCT N.NageurID
        FROM P17_Nageurs N
                 JOIN P17_ComposerEquipe CE ON N.NageurID = CE.NageurID
    ) AS Equipe ON N1.NageurID = Equipe.NageurID;


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- c) EXCEPT:
/*    Cette requête soustrait:
    Les nageurs masculins (NageurSexe = 'H') qui ne sont pas de nationalité française (NageurPays != 'FRA').   */

SELECT
    NageurNom,
    NageurPrenom,
    NageurPays
FROM
    P17_Nageurs
WHERE
    NageurSexe = 'H'

EXCEPT

SELECT
    NageurNom,
    NageurPrenom,
    NageurPays
FROM
    P17_Nageurs
WHERE
    NageurPays = 'FRA';


-- version 2 avec une sous-requête

SELECT P17_Nageurs.NageurNom, P17_Nageurs.NageurPrenom, P17_Nageurs.NageurPays
FROM P17_Nageurs
WHERE (NageurSexe = 'H') AND NageurPays NOT IN ( SELECT NageurPays FROM P17_Nageurs WHERE NageurPays = 'FRA');



-- version 3 avec LEFT JOIN

SELECT
    n1.NageurNom,
    n1.NageurPrenom,
    n1.NageurPays
FROM
    P17_Nageurs n1
        LEFT JOIN
    P17_Nageurs n2
    ON
        n1.NageurNom = n2.NageurNom
            AND n2.NageurPays = 'FRA'
WHERE
    n1.NageurSexe = 'H'
  AND n2.NageurNom IS NULL;

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- 4) Sous-requêtes:
-- a) Clause WHERE avec  "="  :
--  Le nom, prénom, et pays du nageur ayant réalisé le temps le plus rapide dans l'épreuve spécifiée (EpreuveID = 101) seront affichés.

SELECT
    NageurNom,
    NageurPrenom,
    NageurPays
FROM
    P17_Nageurs
WHERE
    NageurID = (
        SELECT
            NageurID
        FROM
            P17_ParticiperIndividuel
        WHERE
            EpreuveID = 101
          AND Temps = (
            SELECT
                MIN(Temps)
            FROM
                P17_ParticiperIndividuel
            WHERE
                EpreuveID = 101
        )
    );

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- b) Clause WHERE avec IN :
-- Récupère tous les nageurs ayant gagné une médaille d'or en individuel (NageurID IN (...)).

SELECT
    NageurNom,
    NageurPrenom,
    NageurSexe,
    NageurPays
FROM
    P17_Nageurs
WHERE
    NageurID IN (
        SELECT
            NageurID
        FROM
            P17_ParticiperIndividuel
        WHERE
            Medaille = 'Or'
    );

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- c) Sous-requête dans FROM :
-- calcule la moyenne globale des temps moyens (MS) pour toutes les épreuves individuelles dans la table P17_ParticiperIndividuel.

SELECT AVG(T.TempsMoyen) AS TempsMoyenParEpreuve
FROM ( SELECT EpreuveID, AVG(CAST(SUBSTR(Temps, 1, 2) AS FLOAT) * 60 + CAST(SUBSTR(Temps, 4) AS FLOAT)) AS TempsMoyen
       FROM P17_ParticiperIndividuel
       WHERE Temps != '0:00.00'
       GROUP BY EpreuveID
     ) T;

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- d) Sous-requête imbriquée :
-- Calcule le temps médian pour chaque épreuve en comptant les participations en dessous ou égales à un temps donné.
--  Les épreuves ou le temps médian est inférieur à un seuil (ici inférieur à 1min10s)

SELECT DISTINCT
    EpreuveID,
    EpreuveDistance,
    EpreuveType,
    EpreuveTour,
    EpreuveCategorie,
    TempsMed AS TempsMedian
FROM (
         SELECT
             P.EpreuveID,
             E.EpreuveDistance,
             E.EpreuveType,
             E.EpreuveTour,
             E.EpreuveCategorie,
             P.Temps AS TempsMed
         FROM
             P17_ParticiperIndividuel P
                 JOIN
             P17_Epreuves E
             ON P.EpreuveID = E.EpreuveID
         WHERE
             (
                 SELECT
                     COUNT(*)
                 FROM
                     P17_ParticiperIndividuel P2
                 WHERE
                     P2.EpreuveID = P.EpreuveID
                   AND P2.Temps <= P.Temps
             ) = (
                 SELECT
                     FLOOR(COUNT(*) / 2)
                 FROM
                     P17_ParticiperIndividuel P3
                 WHERE
                     P3.EpreuveID = P.EpreuveID
             )
     ) AS Medianes
WHERE
    TempsMed < '1:10.00';

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- e) sous-requête synchronisée

-- Cette requête sélectionne tous les nageurs ayant le meilleur temps dans leurs épreuves respectives en utilisant une sous-requête synchronisée.

-- Pour chaque ligne de la requête principale, la sous-requête compare l’épreuve actuelle (P.EpreuveID) avec toutes les lignes de la table P17_ParticiperIndividuel pour trouver le temps minimum de cette épreuve.


SELECT
    N.NageurID,
    N.NageurNom,
    N.NageurPrenom,
    P.EpreuveID,
    P.Temps
FROM
    P17_ParticiperIndividuel P
        NATURAL JOIN
    P17_Nageurs N
WHERE
    P.Temps = (
        SELECT
            MIN(P2.Temps)
        FROM
            P17_ParticiperIndividuel P2
        WHERE
            P2.EpreuveID = P.EpreuveID
          AND P2.Temps != '0:00.00' -- Exclure les temps disqualifiés
    );

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- f) Sous-requête utilisant l’opérateur ANY :
-- Sélectionne toutes les épreuves où au moins un nageur a terminé en moins de 25 secondes.

SELECT
    E.EpreuveID,
    E.EpreuveDistance,
    E.EpreuveType,
    E.EpreuveTour,
    E.EpreuveCategorie
FROM
    P17_Epreuves E
WHERE
    E.EpreuveID = ANY (
        SELECT
            P.EpreuveID
        FROM
            P17_ParticiperIndividuel P
        WHERE
            P.Temps < '0:25.00'
          AND P.Temps != '0:00.00'
    );

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- g) Sous-requête utilisant l’opérateur ALL :
--  Cette requête retourne les informations du nageur ayant réalisé le temps le plus rapide parmi tous les temps valides (Temps != '0:00.00).


SELECT
    NageurID,
    NageurNom,
    NageurPrenom,
    NageurSexe,
    NageurPays,
    P1.Temps
FROM
    P17_ParticiperIndividuel P1
        NATURAL JOIN
    P17_Nageurs
WHERE
    P1.Temps != '0:00.00' -- Exclure les temps disqualifiés
  AND P1.Temps <= ALL (
    SELECT
        Temps
    FROM
        P17_ParticiperIndividuel
    WHERE
        Temps != '0:00.00' -- Considérer uniquement les temps valides
);

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- 5) Jointure vs Sous-requête :
-- Jointure:

--  afficher les nageurs ayant remporté plusieurs médailles dans leurs participations individuelles.
-- La jointure relie directement la table P17_Nageurs et P17_ParticiperIndividuel via la clé NageurID.

SELECT
    N.NageurID,
    N.NageurNom,
    N.NageurPrenom,
    N.NageurPays,
    COUNT(PI.Medaille) AS NombreMedailles
FROM
    P17_Nageurs N
        JOIN
    P17_ParticiperIndividuel PI
    ON N.NageurID = PI.NageurID
WHERE
    PI.Medaille IS NOT NULL
  AND PI.Medaille != 'Aucune'
GROUP BY
    N.NageurID,
    N.NageurNom,
    N.NageurPrenom,
    N.NageurPays
HAVING
    COUNT(PI.Medaille) > 1
ORDER BY
    NombreMedailles DESC;


-- Temps d'exécution : 0.002235 ms

-- Sous-requête:

SELECT
    N.NageurID,
    N.NageurNom,
    N.NageurPrenom,
    N.NageurPays,
    (
        SELECT
            COUNT(PI.Medaille)
        FROM
            P17_ParticiperIndividuel PI
        WHERE
            PI.NageurID = N.NageurID
          AND PI.Medaille IS NOT NULL
          AND PI.Medaille != 'Aucune'
    ) AS NombreMedailles
FROM
    P17_Nageurs N
WHERE
    (
        SELECT
            COUNT(PI.Medaille)
        FROM
            P17_ParticiperIndividuel PI
        WHERE
            PI.NageurID = N.NageurID
          AND PI.Medaille IS NOT NULL
          AND PI.Medaille != 'Aucune'
    ) > 1
ORDER BY
    NombreMedailles DESC;


-- Temps d'exécution :  0.01638325  ms


-- Comparaison de l'efficacité des deux requêtes :
/*
La version avec jointure est clairement la plus efficace, car :

    -  Elle minimise les lectures répétées.
    -  Elle est optimisée pour les bases de données de grande taille.
    -  Elle est plus facile à lire, maintenir et optimiser.
    -  Le temps d'exécution est très rapide, car la jointure relie directement les deux tables, et le regroupement (GROUP BY) est optimisé pour être exécuté en une seule passe.


La version avec la sous-requête est moins  efficace  car :
    -  Le temps d'exécution est significativement plus lent. La sous-requête est exécutée deux fois pour chaque ligne de la table P17_Nageurs : une fois dans la clause SELECT et une autre dans la clause WHERE.

    - La version avec sous-requête est acceptable pour des bases de données petites ou des besoins très spécifiques, mais elle est à éviter dans les cas où la performance est essentielle.

*/

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- 6) Fonctions d'aggrégation :
-- Temps moyen par nageur
-- Cette requête calcule le temps moyen (en secondes) pour chaque nageur basé sur leurs participations individuelles tout en excluant les temps disqualifiés (0:00.00).

SELECT
    P.NageurID,
    N.NageurNom,
    N.NageurPrenom,
    AVG(CAST(SUBSTR(P.Temps, 1, 2) AS FLOAT) * 60 + CAST(SUBSTR(P.Temps, 4) AS FLOAT)) AS TempsMoyen
FROM
    P17_ParticiperIndividuel P
        NATURAL JOIN P17_Nageurs N
WHERE P.Temps != '0:00.00'
GROUP BY P.NageurID, N.NageurNom, N.NageurPrenom;


-- Calculer le nombre total de médailles attribuées pour chaque catégorie d'épreuve, en excluant les participations où aucune médaille n'a été obtenue.

SELECT EpreuveCategorie, COUNT(Medaille) AS TotalMedailles
FROM P17_Epreuves E
         JOIN P17_ParticiperIndividuel PI ON E.EpreuveID = PI.EpreuveID
WHERE Medaille != 'Aucune'
GROUP BY EpreuveCategorie;

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- 7) Utilisation de GROUP BY

-- Calculer le nombre total de médailles remportées par les nageurs de chaque pays.

SELECT N.NageurPays, COUNT(PI.Medaille) AS TotalMedailles
FROM P17_Nageurs N
         JOIN P17_ParticiperIndividuel PI ON N.NageurID = PI.NageurID
GROUP BY N.NageurPays;


-- Calculer le temps moyen (en secondes) des participants pour chaque épreuve, en excluant les temps invalides (0:00.00).

SELECT EpreuveID,
       AVG(CAST(SUBSTR(Temps, 1, 2) AS FLOAT) * 60 + CAST(SUBSTR(Temps, 4) AS FLOAT)) AS TempsMoyen
FROM P17_ParticiperIndividuel
WHERE Temps != '0:00.00'
GROUP BY EpreuveID;


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- 8) Utilisation de HAVING
--  Identifier les nageurs ayant un temps moyen inférieur à 60 secondes dans leurs participations individuelles.

/*
Les temps au format mm:ss.ss (texte) sont convertis en secondes :

    CAST(SUBSTR(Temps, 1, 2) AS FLOAT) * 60 : Convertit les minutes en secondes.
    CAST(SUBSTR(Temps, 4) AS FLOAT) : Ajoute les secondes.

AVG(...) calcule la moyenne des temps convertis.
*/

SELECT NageurID,
       AVG(CAST(SUBSTR(Temps, 1, 2) AS FLOAT) * 60 + CAST(SUBSTR(Temps, 4) AS FLOAT)) AS TempsMoyen
FROM P17_ParticiperIndividuel
WHERE Temps != '0:00.00'
GROUP BY NageurID
HAVING AVG(CAST(SUBSTR(Temps, 1, 2) AS FLOAT) * 60 + CAST(SUBSTR(Temps, 4) AS FLOAT)) < 60;



-- Nombre d’épreuves par nageur ayant participé à plus de 10 épreuves individuelles

SELECT DISTINCT NageurID, NageurNom, NageurPrenom, NageurSexe, NageurPays, COUNT(EpreuveID) AS TotalEpreuves
FROM P17_ParticiperIndividuel NATURAL JOIN P17_Nageurs
GROUP BY NageurID, NageurNom, NageurPrenom, NageurSexe, NageurPays
HAVING COUNT(EpreuveID) > 10;


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- 9)  Trouver les combinaisons de nageurs masculins (N1) et féminins (N2) appartenant au même pays.

SELECT DISTINCT
    N1.NageurNom AS HommeNom, N1.NageurPrenom AS HommePrenom, N1.NageurPays AS Pays,
    N2.NageurNom AS FemmeNom, N2.NageurPrenom AS FemmePrenom
FROM P17_Nageurs N1
         JOIN P17_Nageurs N2 ON N1.NageurPays = N2.NageurPays
WHERE N1.NageurSexe = 'H' AND N2.NageurSexe = 'F';
