-- Étape 6 : Les paiements
-- "On paie en espèces, MVola, Orange Money ou Airtel Money. Parfois un client
--  paie une partie en espèces et le reste par MVola. Pour le mobile money,
--  je note la référence de la transaction."

-- Table de référence pour les modes de paiement
CREATE TABLE mode_paiement (
    id_mode SERIAL      PRIMARY KEY,
    nom     VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO mode_paiement (nom) VALUES
    ('Espèces'),
    ('MVola'),
    ('Orange Money'),
    ('Airtel Money');

-- Table PAIEMENT : un paiement partiel par mode pour chaque commande
CREATE TABLE paiement (
    id_paiement   SERIAL       PRIMARY KEY,
    id_commande   INT          NOT NULL,
    id_mode       INT          NOT NULL,
    montant       INT          NOT NULL CHECK (montant > 0),
    reference_txn VARCHAR(100),
    FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
    FOREIGN KEY (id_mode)     REFERENCES mode_paiement(id_mode)
);

-- Données de test
-- Commande 1 (montant total = 7000*2 + 500*2 = 15000) : 10000 en espèces + 5000 MVola
INSERT INTO paiement (id_commande, id_mode, montant, reference_txn) VALUES
    (1, 1, 10000, NULL),
    (1, 2,  5000, 'MVOLA-2024-001');

-- Commande 2 (montant total = 6000 + 5000 = 11000) : 6000 par Orange Money (non soldée !)
INSERT INTO paiement (id_commande, id_mode, montant, reference_txn) VALUES
    (2, 3, 6000, 'OM-2024-042');

-- Vérification : commandes non soldées avec montant dû, payé et reste à payer
SELECT c.id_commande,
       SUM(p.prix * lc.quantite)                             AS montant_du,
       COALESCE(pay.total_paye, 0)                           AS montant_paye,
       SUM(p.prix * lc.quantite) - COALESCE(pay.total_paye, 0) AS reste_a_payer
FROM commande c
JOIN ligne_commande lc ON c.id_commande = lc.id_commande
JOIN plat p            ON lc.id_plat = p.id_plat
LEFT JOIN (
    SELECT id_commande, SUM(montant) AS total_paye
    FROM paiement
    GROUP BY id_commande
) pay ON c.id_commande = pay.id_commande
GROUP BY c.id_commande, pay.total_paye
HAVING SUM(p.prix * lc.quantite) - COALESCE(pay.total_paye, 0) > 0
ORDER BY c.id_commande;

-- Piège :
-- Une colonne montant_paye dans commande ne suffit PAS car :
--   - Un client peut payer en PLUSIEURS FOIS et PLUSIEURS MODES (ex: espèces + MVola)
--   - On perdrait le détail : quel mode, quelle référence, quel montant partiel
--   - C'est une relation 1:N (une commande → plusieurs paiements)
--
-- Mode de paiement — CHECK vs table de référence :
--   CHECK (mode IN ('Espèces','MVola',...)) : simple, mais rigide.
--     Si Rado ajoute un nouveau mode, il faut modifier le CHECK (ALTER TABLE).
--   Table de référence MODE_PAIEMENT : plus souple, on ajoute un INSERT.
--     Permet aussi de stocker des infos supplémentaires (ex: frais de commission).
-- → La table de référence est préférable pour l'évolutivité.
