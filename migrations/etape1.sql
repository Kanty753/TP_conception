-- Étape 1 : La carte
-- "Je veux la liste de mes plats avec leur prix."

CREATE TABLE plat (
    id_plat  SERIAL       PRIMARY KEY,
    nom      VARCHAR(100) NOT NULL,
    prix     INT          NOT NULL
);

-- Données de test (7 plats du contexte)
INSERT INTO plat (nom, prix) VALUES
    ('Romazava',              7000),
    ('Ravitoto sy henakisoa', 8000),
    ('Akoho sy voanio',       8500),
    ('Mi sao',                6000),
    ('Soupe chinoise',        5000),
    ('Mofo gasy (les 4)',     1000),
    ('Ranon''ampango',         500);

-- Vérification : plats du plus cher au moins cher
SELECT nom, prix FROM plat ORDER BY prix DESC;

-- Piège :
-- Type du prix : INT (les montants sont en ariary, sans centimes).
--   FLOAT/DOUBLE sont à proscrire (imprécision), DECIMAL est inutile ici (pas de centimes).
-- Identifiant : id_plat (SERIAL) — le nom seul n'est pas fiable comme clé
--   (deux plats pourraient avoir le même nom, ou le nom pourrait changer).
