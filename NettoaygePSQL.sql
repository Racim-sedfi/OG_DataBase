-- ===================================================
-- Suppression de la base de données sur Postgres
-- ===================================================

-- 1) Suppression des tables
DROP TABLE IF EXISTS P17_Statistiques CASCADE;
DROP TABLE IF EXISTS P17_HistoriqueModifications CASCADE;
DROP TABLE IF EXISTS P17_ParticiperEquipe CASCADE;
DROP TABLE IF EXISTS P17_ParticiperIndividuel CASCADE;
DROP TABLE IF EXISTS P17_Epreuves CASCADE;
DROP TABLE IF EXISTS P17_ComposerEquipe CASCADE;
DROP TABLE IF EXISTS P17_RelaisEquipe CASCADE;
DROP TABLE IF EXISTS P17_Nageurs CASCADE;

-- 2) Suppression des vues
DROP VIEW IF EXISTS P17_Vue_MedaillesNageur CASCADE;
DROP VIEW IF EXISTS P17_Vue_CalendrierEpreuves CASCADE;
DROP VIEW IF EXISTS P17_Vue_EquipesGagnantes CASCADE;

-- 3) Suppression des fonctions et procédures
DROP FUNCTION IF EXISTS P17_Proc_UpdateTemps CASCADE;
DROP FUNCTION IF EXISTS P17_Func_MedaillesOr CASCADE;
DROP FUNCTION IF EXISTS P17_Func_EpreuvesOr CASCADE;
DROP PROCEDURE IF EXISTS P17_Proc_AfficheGagnantMedaille CASCADE;
DROP FUNCTION IF EXISTS P17_Func_UpdateTotalNageurs CASCADE;
DROP FUNCTION IF EXISTS P17_Func_LogModifications CASCADE;

-- 4) Suppression des triggers
DROP TRIGGER IF EXISTS P17_Trigger_UpdateTotalNageurs ON P17_Nageurs CASCADE;
DROP TRIGGER IF EXISTS P17_Trigger_LogModifications ON P17_ParticiperIndividuel CASCADE;

-- 5) Message de confirmation
DO $$
BEGIN
    RAISE NOTICE 'Base de données effacée avec succès ! Toutes les tables, séquences, vues, procédures, fonctions et triggers ont été supprimés.';
END $$;
