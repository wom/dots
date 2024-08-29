# Define variables
SCRIPT_DIR := $(shell pwd)
PLAYBOOK := setup_ans.yaml
INVENTORY := localhost,

.PHONY: all setup_venv all misctools setup_ans mcfly
# Default target
all: setup_venv  misctools setup_links mcfly

sudo:
	@sudo echo "Verifying Sudo rights"
# Setup virtual environment by calling setup_ansible.sh script
setup_venv:
	@echo "Setting up Ansible virtual environment..."
	@bash $(SCRIPT_DIR)/setup_ansible.sh

setup_ans:
	@echo "entry"
	@~/venvs/ansible_venv/bin/ansible-playbook setup_ans.yaml -i localhost,

all:
	@echo "All!"

misctools: | sudo
	@echo "Running Ansible Misctools..."
	@~/venvs/ansible_venv/bin/ansible-playbook ans_templates/misctools.yaml -i localhost,

mcfly:
	@echo "Running Ansible mcfly..."
	@~/venvs/ansible_venv/bin/ansible-playbook ans_templates/mcfly.yaml -i localhost,
	@~/venvs/ansible_venv/bin/ansible-playbook ans_templates/taskwarrior.yaml -i localhost,
