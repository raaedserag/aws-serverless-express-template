include .env
export $(shell sed 's/=.*//' .env)

# Take First argument only
RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
Environment := $(wordlist 1,1,${RUN_ARGS})

ifndef Environment
$(error Environment is not set)
endif

deploy:
	cd app; serverless deploy --stage ${Environment}
destroy:
	cd app; serverless remove --stage ${Environment}

layers-deploy:
	cd layers; serverless deploy --stage ${Environment}
layers-destroy:
	cd layers; serverless remove --stage ${Environment}