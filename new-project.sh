#!/bin/bash

read -p 'Quel est le titre projet ? (répondre `a` pour annuler) : ' TITLE

if [ "$TITLE" = "a" ]; then
    echo "Annulation de la création du nouveau projet."
    exit
else
    echo "Création du projet : $TITLE"
    SLUG=$(echo "$TITLE" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | iconv -f utf8 -t ascii//TRANSLIT)
    DATE=$(date -u +'%Y-%m-%d')
    NB_FILES=$(find ./content/atelier -type f | wc -l)
    hugo new --kind atelier-bundle atelier/$SLUG
    sed -i -e "s/#SLUG/$SLUG/g" -e "s/#TITLE/$TITLE/g" -e "s/#WEIGHT/$NB_FILES/g" ./content/atelier/$SLUG/index.md
    chmod 777 -R ./content/atelier/$SLUG
    exit
fi
