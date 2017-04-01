.PHONY: mysql log stop start remove install
compose=docker-compose -p rmq


# ================================================================================
# If the first argument is one of the supported commands...
# ================================================================================
SUPPORTED_COMMANDS := console composer-install composer-require composer-update composer-create
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  # use the rest as arguments for the command
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  COMMAND_ARGS := $(subst :,\:,$(COMMAND_ARGS))
  COMMAND_ARGS := $(subst -,\-,$(COMMAND_ARGS))
  COMMAND_ARGS := $(subst =,\=,$(COMMAND_ARGS))
  # ...and turn them into do-nothing targets
  $(eval $(COMMAND_ARGS):;@:)
endif

####################################################################################################################
# APP COMMANDS
####################################################################################################################

start:
	@echo "== Start App =="
	@$(compose) up -d haproxy

build:
	@echo "== Build App =="
	@$(compose) build

networking:
	@echo "== Create networks =="
	@docker network create rabbit_1_2 || true
	@docker network create rabbit_2_3 || true
	@docker network create rabbit_3_1 || true

install: networking remove build composer-install start

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

init-sw:
	@echo "== Rabbit init =="
	@$(compose) run --rm php vendor/bin/rabbit vhost:mapping:create vhost.yml --host=haproxy -u guest -p guest

produce-sw:
	@echo "== SWARROT Rabbit Produce messages =="
	@$(compose) run --rm php bin/console rb:test

consume-sw:
	@echo "== SWARROT Rabbit Consume messages =="
	@$(compose) run --rm php bin/console swarrot:consume:test_consume_quickly swarrot rabbit1 -vvv

cluster-sw:
	@echo "== SWARROT Rabbit Clustering =="
	@$(compose) exec rabbit1 rabbitmqctl set_policy ha-swarrot "^swarrot" \ '{"ha-mode":"all","ha-sync-mode":"automatic"}'

cluster-os:
	@echo "== SWARROT Rabbit Clustering =="
	@$(compose) exec rabbit1 rabbitmqctl set_policy ha-oldsound "^oldsound" \ '{"ha-mode":"all","ha-sync-mode":"automatic"}'

produce-os:
	@echo "== OLD Rabbit Produce messages =="
	@$(compose) run --rm php bin/console rb:oldsound

consume-os:
	@echo "== OLD Rabbit Consume messages =="
	@$(compose) run --rm php bin/console rabbitmq:consumer oldsound

stop-node-1:
	@echo "== Stop rabbitmq node 1 from cluster =="
	@docker stop

resume-node-1:
	@echo "== Stop rabbitmq node 1 from cluster =="
	@docker start

exclude-node-1:
	@echo "== Exclude rabbitmq node 1 from cluster =="
	@docker network disconnect rabbit_1_2
	@docker network disconnect rabbit_3_1
	
restore-node-1:
	@echo "== Exclude rabbit node 1 from cluster =="
	@docker network connect rabbit_1_2
	@docker network connect rabbit_3_1

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
