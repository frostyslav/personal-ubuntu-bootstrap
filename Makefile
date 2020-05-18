.DEFAULT_GOAL = help
.PHONY: help install-prerequisites

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install-prerequisites: update-packages ## install prerequisites
	sudo apt-get install python3-pip -y
	pip3 install --user pipenv

update-packages: ## updates ubuntu packages
	sudo apt-get update
	sudo apt-get upgrade -y

install-ansible: install-prerequisites pipenv-sync ## install ansible

pipenv-sync: ## sync pipenv
	/home/$$USER/.local/bin/pipenv sync

prepare-node: install-ansible ## installs and configures software
	/home/$$USER/.local/bin/pipenv run ansible-galaxy install robertdebock.openssh
	/home/$$USER/.local/bin/pipenv run ansible-galaxy install geerlingguy.docker
	/home/$$USER/.local/bin/pipenv run ansible-playbook -i 'localhost,' ansible/prepare_node.yml -e ansible_connection=local
