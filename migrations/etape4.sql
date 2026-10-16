-- Étape 4 : Les habitués
-- "Certains clients sont des habitués, je veux les reconnaître.
--  Mais la plupart sont de passage et je ne leur demande rien."

-- Nouvelle table CLIENT
CREATE TABLE client (
    id_client SERIAL       PRIMARY KEY,
    nom       VARCHAR(100) NOT NULL
);

-- Données de test
INSERT INTO client (nom) VALUES
    ('Andry Rajoelina'),
    ('Voahirana Razafy');

-- Ajout FK NULLABLE dans commande (NULL = client de passage)
ALTER TABLE commande ADD COLUMN id_client INT;
ALTER TABLE commande ADD CONSTRAINT fk_commande_client
    FOREIGN KEY (id_client) REFERENCES client(id_client);

-- Associer quelques commandes à des clients habitués
UPDATE commande SET id_client = 1 WHERE id_commande = 1;
UPDATE commande SET id_client = 2 WHERE id_commande = 3;
-- La commande 2 reste à NULL (client de passage)

-- Vérification : liste des commandes avec le nom du client ou "Client de passage"
SELECT c.id_commande,
       c.date_commande,
       COALESCE(cl.nom, 'Client de passage') AS client
FROM commande c
LEFT JOIN client cl ON c.id_client = cl.id_client
ORDER BY c.id_commande;

-- Piège :
-- La clé étrangère id_client doit être NULLABLE (pas NOT NULL), car la plupart
-- des clients sont de passage et n'ont pas de fiche client.
-- Il faut utiliser un LEFT JOIN (et non un INNER JOIN) pour ne perdre aucune
-- commande : un INNER JOIN exclurait les commandes sans client (id_client IS NULL).
