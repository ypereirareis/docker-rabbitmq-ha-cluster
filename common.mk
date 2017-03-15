
ifeq "$(shell whoami )" "root"
	CONTAINER_USERNAME = root
	CONTAINER_GROUPNAME = root
	HOMEDIR = /root
	CREATE_USER_COMMAND =
else
	CONTAINER_USERNAME = $(USER)
	CONTAINER_GROUPNAME = $(USER)
	HOMEDIR = /home/$(CONTAINER_USERNAME)
	GROUP_ID = $(shell id -g)
	USER_ID = $(shell id -u)
	CREATE_USER_COMMAND = \
		( addgroup -g $(GROUP_ID) $(CONTAINER_GROUPNAME) && \
		adduser -D -u $(USER_ID) -G $(CONTAINER_GROUPNAME) $(CONTAINER_USERNAME) && \
		mkdir -p $(HOMEDIR) ) > /dev/null 2>&1 &&
endif

AUTHORIZE_HOME_DIR_COMMAND = chown -R $(CONTAINER_USERNAME):$(CONTAINER_GROUPNAME) $(HOMEDIR) &&
EXECUTE_AS = sudo -E -u $(CONTAINER_USERNAME) HOME=$(HOMEDIR)

ADD_SSH_ACCESS_COMMAND = \
  mkdir -p $(HOMEDIR)/.ssh && \
  test -e /var/tmp/id && cp /var/tmp/id $(HOMEDIR)/.ssh/id_rsa ; \
  test -e /var/tmp/known_hosts && cp /var/tmp/known_hosts $(HOMEDIR)/.ssh/known_hosts ; \
  test -e $(HOMEDIR)/.ssh/id_rsa && chmod 600 $(HOMEDIR)/.ssh/id_rsa ;

# ================================================================================
# If the first argument is one of the supported commands...
# ================================================================================
SUPPORTED_COMMANDS := bash-es build console install start stop restart state cc tests assets database database-drop database-test database-test-drop fixtures migrations composer-install composer-require composer-update composer-create mysql units behat gulp npm-install bower-install
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
