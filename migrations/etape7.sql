-- Étape 7 : Les prix changent
-- "Au 15 octobre, le romazava passe de 7 000 à 7 500 Ar. Mais mes anciennes
--  factures doivent garder l'ancien prix !"

-- On met simplement à jour le prix du romazava dans la table PLAT
UPDATE plat SET prix = 7500 WHERE nom = 'Romazava';

-- Vérification : montant total de chaque commande
SELECT c.id_commande,
       c.date_commande,
       SUM(p.prix * lc.quantite) AS montant_total
FROM commande c
JOIN ligne_commande lc ON c.id_commande = lc.id_commande
JOIN plat p            ON lc.id_plat = p.id_plat
GROUP BY c.id_commande, c.date_commande
ORDER BY c.id_commande;
