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