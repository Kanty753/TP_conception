# Schéma relationnel — La gargote de Rado
## Étape 1 — La carte

PLAT(**id_plat**, nom, prix)
## Étape 2 — Les catégories *(nouveau : CATEGORIE, modifié : PLAT)*

CATEGORIE(**id_categorie**, nom)

PLAT(**id_plat**, nom, prix, #id_categorie)