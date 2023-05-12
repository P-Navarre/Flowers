# Flowers

Cette application iOS contient :
- un client api généré par openapi-generator.
- un gestionnaire pour le chargement et le cache des images. Son implémentation basée sur le cache de URLSession est basique.
- deux vues, liste et détail. La vue liste est implémentée avec l’architecture clean swift (viewController, interactor, presenter). L'architecture de la vue détail est simplifiée (pas d’interactor). L'affichage s'adapte à la taille de l'éran avec deux colonnes et une split view pour les plus grands écrans iPad pro.
- des tests unitaires pour ImageView, ListViewInteractor et ListViewPresenter.

Les données proviennent de cette base de donnée : https://www.kaggle.com/datasets/l3llff/flowers
Certaines images peuvent sembler déformées ; la déformation vient du jeu de données.
