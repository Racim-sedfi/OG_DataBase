-- ===========================
-- Suppression de la base de données en Oracle.
-- ===========================

-- 1) Supprimer tous les TRIGGERS
BEGIN
    FOR trig IN (SELECT TRIGGER_NAME FROM USER_TRIGGERS) LOOP
            EXECUTE IMMEDIATE 'DROP TRIGGER ' || trig.TRIGGER_NAME;
        END LOOP;
END;
/

-- 2) Supprimer toutes les VUES
BEGIN
    FOR vue IN (SELECT VIEW_NAME FROM USER_VIEWS) LOOP
            EXECUTE IMMEDIATE 'DROP VIEW ' || vue.VIEW_NAME;
        END LOOP;
END;
/

-- 3) Supprimer toutes les TABLES
BEGIN
    FOR tab IN (SELECT TABLE_NAME FROM USER_TABLES) LOOP
            EXECUTE IMMEDIATE 'DROP TABLE ' || tab.TABLE_NAME || ' CASCADE CONSTRAINTS';
        END LOOP;
END;
/

-- 4) Supprimer toutes les PROCEDURES et FONCTIONS
BEGIN
    FOR proc IN (SELECT OBJECT_NAME FROM USER_PROCEDURES WHERE OBJECT_TYPE = 'PROCEDURE') LOOP
            EXECUTE IMMEDIATE 'DROP PROCEDURE ' || proc.OBJECT_NAME;
        END LOOP;

    FOR func IN (SELECT OBJECT_NAME FROM USER_PROCEDURES WHERE OBJECT_TYPE = 'FUNCTION') LOOP
            EXECUTE IMMEDIATE 'DROP FUNCTION ' || func.OBJECT_NAME;
        END LOOP;
END;
/

-- 5) Supprimer toutes les SÉQUENCES
BEGIN
    FOR seq IN (SELECT SEQUENCE_NAME FROM USER_SEQUENCES WHERE SEQUENCE_NAME LIKE 'SEQ%') LOOP
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || seq.SEQUENCE_NAME;
        END LOOP;
END;
/

-- 6) Supprimer tous les TYPES DÉFINIS PAR L'UTILISATEUR
BEGIN
    FOR typ IN (SELECT TYPE_NAME FROM USER_TYPES) LOOP
            EXECUTE IMMEDIATE 'DROP TYPE ' || typ.TYPE_NAME;
        END LOOP;
END;
/

-- 7) Message de confirmation
BEGIN
    DBMS_OUTPUT.PUT_LINE('Suppression complète terminée. Toutes les tables, vues, procédures, fonctions, triggers ont été supprimés.');
END;
/
