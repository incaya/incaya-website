# Site INCAYA

Le site web d'INCAYA s'appuie sur le générateur de site statique [Hugo](https://gohugo.io/documentation/).

## Pré-requis

Vous devez avoir l'exécutable d'Hugo (en version extended) sur votre poste de travail.
Il est téléchargeable sur le Github de projet : https://github.com/gohugoio/hugo/releases

Une fois cet exécutable téléchargé, vous devrez le déplacer dans le répertoire `/bin/VOTRE-OS` en le renommant simplement `hugo`.

> Si Hugo est déja installé sur votre poste, vous pouvez faire un lien symbolique de l'exécutable dans `/bin/VOTRE-OS`

## Créer un post de blog

```bash
make new-blog-post
```

## Démarrer le serveur de développement

```bash
make start
```

## Déploiement

Pour pouvoir lancer le déploiement, vous devrez au préalable configurer l'accés ssh au serveur `incaya-general` d'INCAYA sous le nom... `incaya-general`.

```bash
make deploy
```
