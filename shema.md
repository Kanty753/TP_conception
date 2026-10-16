# Schéma relationnel — La gargote de Rado
## Étape 1 — La carte

PLAT(**id_plat**, nom, prix)
## Étape 2 — Les catégories *(nouveau : CATEGORIE, modifié : PLAT)*

CATEGORIE(**id_categorie**, nom)

PLAT(**id_plat**, nom, prix, #id_categorie)
## Étape 3 — Les commandes *(nouveau : COMMANDE, LIGNE_COMMANDE)*

CATEGORIE(**id_categorie**, nom)

PLAT(**id_plat**, nom, prix, #id_categorie)

COMMANDE(**id_commande**, date_commande)

LIGNE_COMMANDE(**#id_commande, #id_plat**, quantite)
## Étape 4 — Les habitués *(nouveau : CLIENT, modifié : COMMANDE)*

CATEGORIE(**id_categorie**, nom)

PLAT(**id_plat**, nom, prix, #id_categorie)

CLIENT(**id_client**, nom)

COMMANDE(**id_commande**, date_commande, #id_client?)

LIGNE_COMMANDE(**#id_commande, #id_plat**, quantite)
## Étape 5 — Serveurs et tables *(nouveau : SERVEUR, TABLE_SALLE, modifié : COMMANDE)*

CATEGORIE(**id_categorie**, nom)

PLAT(**id_plat**, nom, prix, #id_categorie)

CLIENT(**id_client**, nom)

SERVEUR(**id_serveur**, nom)

TABLE_SALLE(**num_table**)

COMMANDE(**id_commande**, date_commande, #id_client?, #id_serveur, #num_table?)

LIGNE_COMMANDE(**#id_commande, #id_plat**, quantite)
## Étape 6 — Les paiements *(nouveau : MODE_PAIEMENT, PAIEMENT)*

CATEGORIE(**id_categorie**, nom)

PLAT(**id_plat**, nom, prix, #id_categorie)

CLIENT(**id_client**, nom)

SERVEUR(**id_serveur**, nom)

TABLE_SALLE(**num_table**)

COMMANDE(**id_commande**, date_commande, #id_client?, #id_serveur, #num_table?)

LIGNE_COMMANDE(**#id_commande, #id_plat**, quantite)

MODE_PAIEMENT(**id_mode**, nom)

PAIEMENT(**id_paiement**, #id_commande, #id_mode, montant, reference_txn?)
