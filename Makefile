#!make
# include .env
# export $(shell sed 's/=.*//' .env)

# Take First argument only
RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
Environment := $(wordlist 1,1,${RUN_ARGS})

# Default parameters
region ?= us-east-1


ifndef Environment
$(error Environment is not set)
endif

deploy:
	serverless deploy --stage ${Environment} --region ${region}

destroy:
	serverless remove --stage ${Environment} --region ${region}