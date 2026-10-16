-- Étape 2 : Les catégories
-- "Je range mes plats par catégorie : plats malagasy, plats chinois, soupes, desserts, boissons."

-- Nouvelle table CATEGORIE
CREATE TABLE categorie (
    id_categorie SERIAL       PRIMARY KEY,
    nom          VARCHAR(100) NOT NULL UNIQUE
);

-- Données de test
INSERT INTO categorie (nom) VALUES
    ('Plat malagasy'),
    ('Plat chinois'),
    ('Soupe'),
    ('Dessert et goûter'),
    ('Boisson');

-- Ajout de la colonne (nullable d'abord, car la table contient déjà des données)
ALTER TABLE plat ADD COLUMN id_categorie INT;

-- Mise à jour des plats existants
UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE nom = 'Plat malagasy')
    WHERE nom IN ('Romazava', 'Ravitoto sy henakisoa', 'Akoho sy voanio');
UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE nom = 'Plat chinois')
    WHERE nom = 'Mi sao';
UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE nom = 'Soupe')
    WHERE nom = 'Soupe chinoise';
UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE nom = 'Dessert et goûter')
    WHERE nom = 'Mofo gasy (les 4)';
UPDATE plat SET id_categorie = (SELECT id_categorie FROM categorie WHERE nom = 'Boisson')
    WHERE nom = 'Ranon''ampango';

-- Maintenant rendre NOT NULL et ajouter la FK
ALTER TABLE plat ALTER COLUMN id_categorie SET NOT NULL;
ALTER TABLE plat ADD CONSTRAINT fk_plat_categorie
    FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie);

-- Vérification : nombre de plats par catégorie, y compris les catégories sans plat
SELECT c.nom AS categorie, COUNT(p.id_plat) AS nb_plats
FROM categorie c
LEFT JOIN plat p ON c.id_categorie = p.id_categorie
GROUP BY c.nom
ORDER BY nb_plats DESC;

-- Piège :
-- On ne peut pas simplement ajouter une colonne VARCHAR(50) dans la table des plats car :
-- 1. La même catégorie serait dupliquée dans chaque ligne (redondance → anomalies de mise à jour).
--    Exemple concret : si on renomme "Plat malagasy" en "Plat malgache", il faut modifier toutes
--    les lignes concernées. Si on en oublie une, on a deux orthographes différentes.
-- 2. On ne peut pas lister les catégories sans plat (ex: une catégorie "Entrée" vide).
-- La solution est une table CATEGORIE séparée avec une clé étrangère.
