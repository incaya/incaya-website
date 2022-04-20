export UID = $(shell id -u)

help: # Afficher toutes les recettes du Makefile
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#-------------------
# Commandes usuelles
#-------------------

start: ## Lancement de Hugo en mode dev
	docker run --rm --name incaya-local-website -d \
	  -u ${UID} \
	  -v $(shell pwd):/website \
	  -w /website \
	  -p 1313:1313 \
	  ghcr.io/incaya/incaya-website:latest

stop: ## Arrêt de Hugo en mode dev
	docker stop incaya-local-website

logs: ## Arrêt de Hugo en mode dev
	docker logs -f incaya-local-website

new-blog-post: ## Création d'un nouveau post de blog
	docker run --rm --name incaya-create-content -d \
	  -u ${UID} \
	  -v $(shell pwd):/website \
	  -w /website \
	  ghcr.io/incaya/incaya-website:latest
	(docker exec -it incaya-local-website /website/new-blog-post.sh && docker stop incaya-create-content) || (docker stop incaya-create-content && exit 1)

new-project: ## Création d'un nouveau projet
	docker run --rm --name incaya-create-content -d \
	  -u ${UID} \
	  -v $(shell pwd):/website \
	  -w /website \
	  ghcr.io/incaya/incaya-website:latest
	(docker exec -it incaya-local-website /website/new-project.sh && docker stop incaya-create-content) || (docker stop incaya-create-content && exit 1)

#-------------
# Exploitation
#-------------

build: ## Génération des statiques finaux
	docker run --rm --name incaya-build-website \
	  -u ${UID}	\
	  -v $(shell pwd):/website \
	  -w /website \
	  ghcr.io/incaya/incaya-website:latest \
	  bash -ci hugo

deploy: build ## Deploiement du site
	rsync -avz --delete public/ incaya-general:/var/www/incaya/beta

#-------
# Docker
#-------

docker-image: ## Construction et publication de l'image Docker Hugo utilisée en dev
	docker build -t incaya-website --force-rm .
	docker tag incaya-website ghcr.io/incaya/incaya-website:latest
	docker tag incaya-website ghcr.io/incaya/incaya-website:0.97.3
	docker push ghcr.io/incaya/incaya-website:0.97.3
	docker push ghcr.io/incaya/incaya-website:latest

.PHONY: start build docker-image
