-- Étape 5 : Serveurs et tables
-- "Je veux savoir quel serveur a pris la commande et à quelle table.
--  Pour les plats à emporter, il n'y a pas de table."

-- Nouvelle table SERVEUR
CREATE TABLE serveur (
    id_serveur SERIAL       PRIMARY KEY,
    nom        VARCHAR(100) NOT NULL
);

-- Nouvelle table TABLE_SALLE (on ne peut pas appeler la table "table" → mot réservé SQL)
CREATE TABLE table_salle (
    num_table INT PRIMARY KEY
);

-- Données de test
INSERT INTO serveur (nom) VALUES
    ('Njaka Rakoto'),
    ('Lalao Rasoa');

INSERT INTO table_salle (num_table) VALUES
    (1), (2), (3), (4), (5), (6), (7), (8);

-- Ajout des FK dans commande
-- id_serveur : NOT NULL (chaque commande a un serveur)
-- num_table  : NULLABLE (NULL = plat à emporter)
ALTER TABLE commande ADD COLUMN id_serveur INT;
ALTER TABLE commande ADD COLUMN num_table  INT;

-- Mise à jour des commandes existantes
UPDATE commande SET id_serveur = 1, num_table = 3 WHERE id_commande = 1;
UPDATE commande SET id_serveur = 2, num_table = 5 WHERE id_commande = 2;
UPDATE commande SET id_serveur = 1, num_table = NULL WHERE id_commande = 3;  -- à emporter

-- Rendre id_serveur obligatoire maintenant que les données sont remplies
ALTER TABLE commande ALTER COLUMN id_serveur SET NOT NULL;

-- Ajout des contraintes FK
ALTER TABLE commande ADD CONSTRAINT fk_commande_serveur
    FOREIGN KEY (id_serveur) REFERENCES serveur(id_serveur);
ALTER TABLE commande ADD CONSTRAINT fk_commande_table
    FOREIGN KEY (num_table) REFERENCES table_salle(num_table);

-- Vérification : nombre de commandes et chiffre d'affaires par serveur
SELECT s.nom AS serveur,
       COUNT(DISTINCT c.id_commande) AS nb_commandes,
       SUM(p.prix * lc.quantite)     AS chiffre_affaires
FROM serveur s
JOIN commande c        ON s.id_serveur = c.id_serveur
JOIN ligne_commande lc ON c.id_commande = lc.id_commande
JOIN plat p            ON lc.id_plat = p.id_plat
GROUP BY s.nom;

-- Piège :
-- Une table de la salle et une commande sont deux choses différentes :
--   - table_salle utilise un identifiant NATUREL (num_table : le numéro physique 1-8)
--   - commande utilise un identifiant ARTIFICIEL (id_commande : SERIAL auto-incrémenté)
-- Le choix dépend du contexte : les tables ont un numéro fixe et connu,
-- les commandes sont créées dynamiquement sans identifiant naturel.
--
-- Le nom "table" pose problème car c'est un MOT RÉSERVÉ en SQL
-- (CREATE TABLE, ALTER TABLE, DROP TABLE...). On le renomme table_salle.
