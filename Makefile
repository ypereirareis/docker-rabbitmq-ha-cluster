.PHONY: mysql log stop start remove install
compose=docker-compose
include common.mk

####################################################################################################################
# APP COMMANDS
####################################################################################################################

start:
	@echo "== Start App =="
	@$(compose) up -d rabbitmq1 rabbitmq2 rabbitmq3

build:
	@echo "== Build App =="
	@$(compose) build

install: remove build composer-install start

# --------------------------------------------------------
# Print containers information
# --------------------------------------------------------
state:
	@echo "== Print state of containers =="
	@$(compose) ps

# --------------------------------------------------------
# Remove the whole app (data lost)
# --------------------------------------------------------
remove: stop
	@echo "== Remove containers =="
	@$(compose) rm -f

# --------------------------------------------------------
# Stop the whole app
# --------------------------------------------------------
stop:
	@echo "== Stop containers =="
	@$(compose) stop

# --------------------------------------------------------
# Print containers logs
# --------------------------------------------------------
logs:
	@echo "== Show containers logs =="
	@$(compose) logs -f

# --------------------------------------------------------
# Log into PHP container (bash)
# --------------------------------------------------------
bash:
	@echo "== Connect into PHP container =="
	@$(compose) run --rm php bash

console:
	@echo "== Console command =="
	@$(compose) run --rm php bin/console $(COMMAND_ARGS)

create-rabbit:
	@echo "== Rabbit init =="
	@$(compose) run --rm php vendor/bin/rabbit vhost:mapping:create vhost.yml --host=rabbitmq1 -u guest -p guest

produce-sw:
	@echo "== SWARROT Rabbit Produce messages =="
	@$(compose) run --rm php bin/console rb:test

consume-sw:
	@echo "== SWARROT Rabbit Consume messages =="
	@$(compose) run --rm php bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq1 -vvv

cluster-sw:
	@echo "== SWARROT Rabbit Clustering =="
	@$(compose) exec rabbitmq1 rabbitmqctl set_policy ha-test "^bench" \ '{"ha-mode":"exactly","ha-params":3,"ha-sync-mode":"automatic"}'

produce-os:
	@echo "== OLD Rabbit Produce messages =="
	@$(compose) run --rm php bin/console rb:oldsound

consume-os:
	@echo "== OLD Rabbit Consume messages =="
	@$(compose) run --rm php bin/console rabbitmq:consumer oldsound

# --------------------------------------------------------
# COMPOSER
# --------------------------------------------------------

composer-install:
	@$(compose) run --rm composer bash -c '\
	  composer install --ignore-platform-reqs --no-interaction --prefer-dist $(COMMAND_ARGS)'

composer-update:
	@$(compose) run --rm composer bash -c '\
    composer update --ignore-platform-reqs --no-interaction --prefer-dist $(COMMAND_ARGS)'

composer-require:
	@$(compose) run --rm composer bash -c '\
    composer require --ignore-platform-reqs --no-interaction --prefer-dist $(COMMAND_ARGS)'


# rabbitmqctl set_policy ha-test "^bench" \ '{"ha-mode":"exactly","ha-params":3,"ha-sync-mode":"automatic"}'