import pandas as pd
from sqlalchemy import create_engine

# Connexion à la base de données PostgreSQL
engine_pgsql = create_engine('postgresql+psycopg2://ma223078:20223078@172.16.20.14:5432/ma223078')

# Fonction pour renommer les colonnes en minuscules et insérer les données dans une table
def insert_data(df, table_name, engine):
    df.columns = df.columns.str.lower()  # Convertir tous les noms de colonnes en minuscules
    df.to_sql(table_name, engine, if_exists='append', index=False)

# Chargement et insertion des données pour chaque fichier CSV
try:
    epreuves_df = pd.read_csv('../Donnees Alimentation/Epreuves.csv')
    nageurs_df = pd.read_csv('../Donnees Alimentation/Nageurs.csv')
    composer_df = pd.read_csv('../Donnees Alimentation/ComposerEquipe.csv')
    relais_df = pd.read_csv('../Donnees Alimentation/RelaisEquipe.csv')
    participer_equipe_df = pd.read_csv('../Donnees Alimentation/ParticiperEquipe.csv')
    participer_individuel_df = pd.read_csv('../Donnees Alimentation/ParticiperIndividuel.csv')
    
    # Insertion des données dans les tables PostgreSQL en forçant les noms de colonnes en minuscules
    insert_data(epreuves_df, 'p17_epreuves', engine_pgsql)
    insert_data(nageurs_df, 'p17_nageurs', engine_pgsql)
    insert_data(relais_df, 'p17_relaisequipe', engine_pgsql)
    insert_data(composer_df, 'p17_composerequipe', engine_pgsql)
    insert_data(participer_equipe_df, 'p17_participerequipe', engine_pgsql)
    insert_data(participer_individuel_df, 'p17_participerindividuel', engine_pgsql)
    
    print("Importation réussie pour PostgreSQL !")
except Exception as e:
    print(f"Erreur lors de l'importation dans PostgreSQL : {e}")
