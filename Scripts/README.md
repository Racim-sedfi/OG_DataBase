Scripts d'Importation de Données

** Description

Ces scripts Python permettent d'importer des données de fichiers CSV dans des bases de données MySQL, PostgreSQL, et Oracle. Ils utilisent pandas pour la lecture des fichiers et SQLAlchemy pour se connecter aux bases de données et insérer les données.


** Prérequis
Installer les bibliothèques nécessaires : pandas, SQLAlchemy, pymysql (pour MySQL), psycopg2 (pour PostgreSQL), et cx_Oracle (pour Oracle).


** Configurer les informations de connexion dans chaque script.

    Configurer les informations de connexion dans chaque script (username, password, host, port, etc.).
    Exécuter le script correspondant à la base de données souhaitée :
        import_mysql.py pour MySQL
        import_postgres.py pour PostgreSQL
        import_oracle.py pour Oracle

** Avantages

    Facilité d'utilisation : Permet une importation rapide des données sans manipulation manuelle.
    Modularité : Adapté pour chaque base de données.
    Automatisation : Pratique pour des chargements de données récurrents.
