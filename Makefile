HUGO = hugo

ifeq ($(OS),Windows_NT)
    HUGO = ./bin/windows/hugo.exe
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        HUGO = ./bin/linux/hugo
    endif
    ifeq ($(UNAME_S),Darwin)
        HUGO = ./bin/mac/hugo
    endif
endif

export HUGO_PATH = ${HUGO}

help: # Afficher toutes les recettes du Makefile
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#-------------------
# Commandes usuelles
#-------------------

start: ## Lancement de Hugo en mode dev
	${HUGO} server

new-blog-post: ## Création d'un nouveau post de blog
	./new-blog-post.sh

#-------------
# Exploitation
#-------------

build: ## Génération des statiques finaux
	${HUGO}

deploy: build ## Deploiement du site
	rsync -avz --delete public/ incaya-general:/var/www/incaya/web

.PHONY: start new-blog-post new-project build deploy
