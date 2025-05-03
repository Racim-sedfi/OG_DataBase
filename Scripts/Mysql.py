import pandas as pd
from sqlalchemy import create_engine

# Connexion à la base de données MySQL
engine_mysql = create_engine('mysql+pymysql://ma223078:20223078@172.16.20.14:3306/ma223078')

# Fonction pour insérer les données dans une table
def insert_data(df, table_name, engine):
    df.to_sql(table_name, engine, if_exists='append', index=False)

# Chargement et insertion des données pour chaque fichier CSV
try:
    epreuves_df = pd.read_csv('../Donnees Alimentation/Epreuves.csv')
    nageurs_df = pd.read_csv('../Donnees Alimentation/Nageurs.csv')
    composer_df = pd.read_csv('../Donnees Alimentation/ComposerEquipe.csv')
    relais_df = pd.read_csv('../Donnees Alimentation/RelaisEquipe.csv')
    participer_equipe_df = pd.read_csv('../Donnees Alimentation/ParticiperEquipe.csv')
    participer_individuel_df = pd.read_csv('../Donnees Alimentation/ParticiperIndividuel.csv')
    
    # Insertion des données dans les tables MySQL
    insert_data(epreuves_df, 'P17_Epreuves', engine_mysql)
    insert_data(nageurs_df, 'P17_Nageurs', engine_mysql)
    insert_data(relais_df, 'P17_RelaisEquipe', engine_mysql)
    insert_data(composer_df, 'P17_ComposerEquipe', engine_mysql)
    insert_data(participer_equipe_df, 'P17_ParticiperEquipe', engine_mysql)
    insert_data(participer_individuel_df, 'P17_ParticiperIndividuel', engine_mysql)
    
    print("Importation réussie pour MySQL !")
except Exception as e:
    print(f"Erreur lors de l'importation dans MySQL : {e}")
