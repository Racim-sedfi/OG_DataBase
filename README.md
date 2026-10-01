# OG_DataBase — Base de données des épreuves de natation (JO Paris 2024)

Conception et implémentation d'une base de données relationnelle sur les épreuves de natation
des Jeux olympiques de Paris 2024 (nageurs, épreuves, relais, résultats et médailles).
Le même modèle est décliné pour **PostgreSQL**, **Oracle** et **MySQL**, avec des scripts
d'import des données, des vues, des fonctions/procédures stockées, des triggers et un jeu
de requêtes SQL commentées.

## Technologies

- SQL : PostgreSQL (PL/pgSQL), Oracle (PL/SQL), MySQL
- Python 3 : pandas, SQLAlchemy (import des fichiers CSV)

## Fonctionnalités principales

- **Modèle relationnel** (tables préfixées `P17_`) : `Epreuves`, `Nageurs`, `RelaisEquipe`,
  `ComposerEquipe`, `ParticiperIndividuel`, `ParticiperEquipe`.
- **Jeu de données** au format CSV : 218 épreuves, 852 nageurs, 112 équipes de relais,
  1 485 participations individuelles et 169 participations en relais.
- **Vues** : médailles par nageur, calendrier des épreuves, équipes gagnantes.
- **Fonctions et procédures** : mise à jour d'un temps, nombre de médailles d'or d'un nageur,
  liste des épreuves gagnées, affichage des médaillés.
- **Triggers** : mise à jour automatique du nombre total de nageurs (`P17_Statistiques`) et
  journalisation des modifications (`P17_HistoriqueModifications`).
- **Requêtes** (une version par SGBD) : expressions rationnelles, comparaison de jointures
  (implicite, explicite, externe, produit cartésien) avec temps d'exécution, opérateurs
  ensemblistes (`UNION`, `INTERSECT`, `EXCEPT`), sous-requêtes, agrégations, `GROUP BY`, `HAVING`.

## Structure du projet

```
├── Creation Tables/          # Création des tables seules (MySQL, Oracle, PostgreSQL)
├── Donnees Alimentation/     # Données sources au format CSV
├── Requêtes/                 # Requêtes SQL commentées, une version par SGBD
├── Scripts/                  # Scripts Python d'import des CSV (un par SGBD)
├── ImportPSQL.sql            # Script complet PostgreSQL : tables, vues, fonctions, données, triggers
├── ImportOracle.sql          # Script complet Oracle
├── ImportMySql.sql           # Script complet MySQL
├── VuesPSQL.sql              # Vues (PostgreSQL)
├── FonctionsEtProceduresPlpgsql.sql / FonctionEtProceduresPlsql.sql
├── TriggersPSQL.sql / TriggersOracle.sql
└── NettoaygePSQL.sql / NettoyageOracle.sql / NettoyageMySql.sql   # Suppression des objets
```

## Utilisation

### Avec les scripts SQL complets (exemple PostgreSQL)

```bash
createdb og_natation
psql -d og_natation -f ImportPSQL.sql            # tables, vues, fonctions, données et triggers
psql -d og_natation -f "Requêtes/PostgreSQL.sql" # requêtes d'analyse
psql -d og_natation -f NettoaygePSQL.sql         # pour tout supprimer
```

Les fichiers `ImportOracle.sql` et `ImportMySql.sql` jouent le même rôle pour Oracle et MySQL.

### Avec les scripts Python

1. Créer les tables avec le script du dossier `Creation Tables/` correspondant au SGBD.
2. Installer les dépendances : `pip install pandas sqlalchemy psycopg2-binary pymysql cx_Oracle`.
3. Renseigner la chaîne de connexion dans `Scripts/Postgre.py`, `Scripts/Oracle.py` ou `Scripts/Mysql.py`.
4. Lancer le script depuis le dossier `Scripts/` (les chemins vers les CSV sont relatifs) :

```bash
cd Scripts
python Postgre.py
```

## Auteur

Racim Sedfi
