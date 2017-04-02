
project=rmq
compose=docker-compose -p $(project)

####################################################################################################################
# APP COMMANDS
####################################################################################################################

install: network remove build composer-install start

build:
	@echo "== Build App =="
	@$(compose) build

start:
	@echo "== Start App =="
	@$(compose) up -d haproxy

network:
	@echo "== Create networks =="
	@docker network create rmq_1_2 || true
	@docker network create rmq_2_3 || true
	@docker network create rmq_3_1 || true

state:
	@echo "== Print state of containers =="
	@$(compose) ps

remove: stop
	@echo "== Remove containers =="
	@$(compose) rm -f

stop:
	@echo "== Stop containers =="
	@$(compose) stop

logs:
	@echo "== Show containers logs =="
	@$(compose) logs -f

bash:
	@echo "== Connect into PHP container =="
	@$(compose) run --rm php bash

console:
	@echo "== Console command =="
	@$(compose) run --rm php bin/console $(cmd)


####################################################################################################################
# RABBITMQ COMMANDS
####################################################################################################################

init-sw:
	@echo "== Rabbit init =="
	@$(compose) run --rm php vendor/bin/rabbit vhost:mapping:create vhost.yml --host=haproxy -u guest -p guest

cluster-sw:
	@echo "== SWARROT Rabbit Clustering =="
	@$(compose) exec rmq1 rabbitmqctl set_policy ha-swarrot "^swarrot" \ '{"ha-mode":"all","ha-sync-mode":"automatic"}'

cluster-os:
	@echo "== SWARROT Rabbit Clustering =="
	@$(compose) exec rmq1 rabbitmqctl set_policy ha-oldsound "^oldsound" \ '{"ha-mode":"all","ha-sync-mode":"automatic"}'

stop-node-1:
	@echo "== Stop rabbitmq node 1 from cluster =="
	@docker stop rmq_rmq1_1

resume-node-1:
	@echo "== Stop rabbitmq node 1 from cluster =="
	@docker start rmq_rmq1_1

stop-node-2:
	@echo "== Stop rabbitmq node 2 from cluster =="
	@docker stop rmq_rmq2_1

resume-node-2:
	@echo "== Stop rabbitmq node 2 from cluster =="
	@docker start rmq_rmq2_1

stop-node-3:
	@echo "== Stop rabbitmq node 3 from cluster =="
	@docker stop rmq_rmq3_1

resume-node-3:
	@echo "== Stop rabbitmq node 3 from cluster =="
	@docker start rmq_rmq3_1

exclude-node-1:
	@echo "== Exclude rabbitmq node 1 from cluster =="
	@docker network disconnect rmq_1_2 rmq_rmq2_1
	@docker network disconnect rmq_3_1 rmq_rmq3_1
	
restore-node-1:
	@echo "== Exclude rabbit node 1 from cluster =="
	@docker network connect rmq_1_2 rmq_rmq2_1
	@docker network connect rmq_3_1 rmq_rmq3_1

# --------------------------------------------------------
# COMPOSER
# --------------------------------------------------------

composer-install:
	@$(compose) run --rm composer bash -c '\
	  composer install --ignore-platform-reqs --no-interaction --prefer-dist $(deps)'

composer-update:
	@$(compose) run --rm composer bash -c '\
    composer update --ignore-platform-reqs --no-interaction --prefer-dist $(deps)'

composer-require:
	@$(compose) run --rm composer bash -c '\
    composer require --ignore-platform-reqs --no-interaction --prefer-dist $(deps)'


