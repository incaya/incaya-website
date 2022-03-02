help: # Afficher toutes les recettes du Makefile
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

start: ## Lancement de Hugo en mode dev
	docker run --rm --name incaya-local-website -d \
	  -v $(shell pwd):/website \
	  -w /website \
	  -p 1313:1313 \
	  ghcr.io/incaya/incaya-website:latest

stop: ## Arrêt de Hugo en mode dev
	docker stop incaya-local-website

build: ## Génération des statiques finaux
	docker run --rm --name incaya-build-website \
	  -v $(shell pwd):/website \
	  -w /website \
	  -p 1313:1313 \
	  ghcr.io/incaya/incaya-website:latest \
	  bash -ci hugo

new-blog-post: ## Création d'un nouveau post de blog (Hudo doit être lancé au préalable avec un make start)
	docker exec -it incaya-local-website /website/new-blog-post.sh

docker-image: ## Construction et publication de l'image Docker Hugo
	docker build -t incaya-website --force-rm .
	docker tag incaya-website ghcr.io/incaya/incaya-website:latest
	docker tag incaya-website ghcr.io/incaya/incaya-website:0.93.1
	docker push ghcr.io/incaya/incaya-website:0.93.1
	docker push ghcr.io/incaya/incaya-website:latest
	

.PHONY: start build docker-image
