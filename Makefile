include .env
export $(shell sed 's/=.*//' .env)

# Take First argument only
RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
Environment := $(wordlist 1,1,${RUN_ARGS})
command = info

ifndef Environment
$(error Environment is not set)
endif

LAYERS_DIR = $(shell ls -d layers/*/)

deploy:
	cd app; serverless deploy --stage ${Environment}
destroy:
	cd app; serverless remove --stage ${Environment}
sls:
	cd app; serverless ${command} --stage ${Environment}

layers-deploy:
	for layer in ${LAYERS_DIR}; do \
		echo $$layer; \
		npm install --prefix $$layer; \
	done
	cd layers; serverless deploy --stage ${Environment}

layers-destroy:
	cd layers; serverless remove --stage ${Environment}