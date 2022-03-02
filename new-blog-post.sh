#!/bin/bash

read -p 'Quel est le titre du post de blog ? (répondre `a` pour annuler) : ' TITLE

if [ $TITLE = a ]; then
    echo "Annulation de la création du nouveau post de blog."
    exit
else
    echo "Création du post de blog : $TITLE"
    SLUG=$(echo "$TITLE" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | iconv -f utf8 -t ascii//TRANSLIT)
    DATE=$(date -u +'%Y-%m-%d')
    BLOG_PATH=$(echo "$DATE"_"$SLUG")
    hugo new --kind blog-bundle blog/$BLOG_PATH
    sed -i -e "s/#SLUG/$SLUG/g" -e "s/#TITLE/$TITLE/g" ./content/blog/$BLOG_PATH/index.md
    chmod 777 -R ./content/blog/$BLOG_PATH
    exit
fi
