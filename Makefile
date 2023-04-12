#------------------------------------------------#
#	  				         #
#	    Makefile de déploiement 		 #
#						 #
#------------------------------------------------#
# Description Ceci est un script Make qui permettra de simplifier les commandes de déploiement des applications
ENV := $(PWD)/.env 
include $(ENV)
export


.SILENT:
.PHONY: deploy git build rebuild connect log status stop start restart down
.DEFAULT_GOAL=aide
# Déclaration de variable
dc = docker-compose
app = web


# Connecxion à la base de données
sgbd = psql 
user = ${POSTGRES_USER} 
password = ${POSTGRES_PASSWORD}
db = ${POSTGRES_DB}

aide: ## Voir la liste des commandes
	@printf "\nUSAGE : make [commande] \n"
	@printf "\nCommande : \n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\n"


# *********** Déploiement *********** #
deploy: ## Déployer l'app web
	@$(dc) exec $(app) sh -c "git stash && git pull origin preprod && git log -1"
git: ## Voir la dernière version du code de l'application
	@$(dc) exec $(app) sh -c "git log -3"
build: ## Reconstruire le container web
	@$(dc) up --build -d $(app)
rebuild: ## Reconstruire le container web en ignorant le cache
	@$(dc) build --no-cache && $(dc) up -d
# *********** Débug *********** #
connect-web: ## Se connecter au container web en ssh
	@$(dc) exec $(app) bash
log: ## Voir les logs en continue du container web
	@$(dc) logs -f $(app)
# *********** Statut ************#
status: ## Voir le statut des containers
	@$(dc) ps
stop: ## Arrêter tous les containers
	@$(dc) stop
start: ## Démarrer tous les containers
	@$(dc) start
restart: ## Rédémarrer tous les containers
	@$(dc) restart
# *********** Supprimé les containers ainsi que le volume, network ************ #
down: ## Supprimer les containers ainsi que le network
	@$(dc) down -v --remove-orphans
