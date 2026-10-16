-- Étape 3 : Les commandes
-- "J'enregistre les commandes : la date, quels plats, et combien de chaque."

-- Nouvelle table COMMANDE
CREATE TABLE commande (
    id_commande   SERIAL PRIMARY KEY,
    date_commande DATE   NOT NULL
);

-- Table d'association LIGNE_COMMANDE (relation N:N entre commande et plat)
CREATE TABLE ligne_commande (
    id_commande INT NOT NULL,
    id_plat     INT NOT NULL,
    quantite    INT NOT NULL DEFAULT 1 CHECK (quantite > 0),
    PRIMARY KEY (id_commande, id_plat),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY (id_plat)     REFERENCES plat(id_plat)
);

-- Données de test
INSERT INTO commande (date_commande) VALUES
    ('2024-03-15'),
    ('2024-03-15'),
    ('2024-03-16');

-- Commande 1 : Romazava x2 + Ranon'ampango x2
INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
    (1, 1, 2),
    (1, 7, 2);

-- Commande 2 : Mi sao x1 + Soupe chinoise x1
INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
    (2, 4, 1),
    (2, 5, 1);

-- Commande 3 : Akoho sy voanio x3 + Mofo gasy x3
INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
    (3, 3, 3),
    (3, 6, 3);

-- Vérification : montant total de chaque commande
SELECT c.id_commande,
       c.date_commande,
       SUM(p.prix * lc.quantite) AS montant_total
FROM commande c
JOIN ligne_commande lc ON c.id_commande = lc.id_commande
JOIN plat p            ON lc.id_plat = p.id_plat
GROUP BY c.id_commande, c.date_commande
ORDER BY c.id_commande;

-- Piège :
-- La quantité se place dans la TABLE D'ASSOCIATION (ligne_commande), pas dans plat
-- ni dans commande. C'est un attribut de la relation N:N entre commande et plat :
-- un même plat peut avoir des quantités différentes selon la commande.
