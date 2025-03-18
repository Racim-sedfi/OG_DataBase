-- ================================================
-- Suppression de la base de données dans MySQL.
-- ================================================

-- 1) Supprimer toutes les tables
DROP TABLE IF EXISTS P17_ParticiperEquipe;
DROP TABLE IF EXISTS P17_ParticiperIndividuel;
DROP TABLE IF EXISTS P17_Epreuves;
DROP TABLE IF EXISTS P17_ComposerEquipe;
DROP TABLE IF EXISTS P17_RelaisEquipe;
DROP TABLE IF EXISTS P17_Nageurs;

-- 2) Suppression des vues
DROP VIEW IF EXISTS P17_Vue_MedaillesNageur;
DROP VIEW IF EXISTS P17_Vue_CalendrierEpreuves;
DROP VIEW IF EXISTS P17_Vue_EquipesGagnantes;