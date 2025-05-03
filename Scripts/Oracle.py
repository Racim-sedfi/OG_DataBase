import pandas as pd
from sqlalchemy import create_engine

# Connexion à la base de données Oracle
engine_oracle = create_engine('oracle+cx_oracle://ma223078:20223078@172.16.20.14:1521/?service_name=XEPDB1')

# Fonction pour renommer les colonnes en majuscules et insérer les données dans une table
def insert_data(df, table_name, engine):
   df.columns = df.columns.str.upper()  # Convertir tous les noms de colonnes en majuscules
   df.to_sql(table_name, engine, if_exists='append', index=False)

# Chargement et insertion des données pour chaque fichier CSV
try:
   epreuves_df = pd.read_csv('../Donnees Alimentation/Epreuves.csv')
   
   # Conversion de EpreuveHeure en texte de 8 caractères (format HH:MM:SS)
   if 'EpreuveHeure' in epreuves_df.columns:
       epreuves_df['EpreuveHeure'] = epreuves_df['EpreuveHeure'].astype(str).str.slice(0, 8)
   
   # Conversion de EpreuveDate en texte de 10 caractères (format YYYY-MM-DD)
   if 'EpreuveDate' in epreuves_df.columns:
       epreuves_df['EpreuveDate'] = pd.to_datetime(epreuves_df['EpreuveDate'], errors='coerce').dt.strftime('%Y-%m-%d')
   
   nageurs_df = pd.read_csv('../Donnees Alimentation/Nageurs.csv')
   
   # Conversion de NageurDateNaissance en texte de 10 caractères (format YYYY-MM-DD)
   if 'NageurDateNaissance' in nageurs_df.columns:
       nageurs_df['NageurDateNaissance'] = pd.to_datetime(nageurs_df['NageurDateNaissance'], errors='coerce').dt.strftime('%Y-%m-%d')
   
   composer_df = pd.read_csv('../Donnees Alimentation/ComposerEquipe.csv')
   relais_df = pd.read_csv('../Donnees Alimentation/RelaisEquipe.csv')
   participer_equipe_df = pd.read_csv('../Donnees Alimentation/ParticiperEquipe.csv')
   participer_individuel_df = pd.read_csv('../Donnees Alimentation/ParticiperIndividuel.csv')
   
   # Insertion des données dans les tables Oracle en forçant les noms de colonnes en majuscules
   insert_data(epreuves_df, 'P17_EPREUVES', engine_oracle)
   insert_data(nageurs_df, 'P17_NAGEURS', engine_oracle)
   insert_data(relais_df, 'P17_RELAISEQUIPE', engine_oracle)
   insert_data(composer_df, 'P17_COMPOSEREQUIPE', engine_oracle)
   insert_data(participer_equipe_df, 'P17_PARTICIPEREQUIPE', engine_oracle)
   insert_data(participer_individuel_df, 'P17_PARTICIPERINDIVIDUEL', engine_oracle)
   
   print("Importation réussie pour Oracle !")
except Exception as e:
   print(f"Erreur lors de l'importation dans Oracle : {e}")
