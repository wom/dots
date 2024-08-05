# Define variables
SCRIPT_DIR := $(shell pwd)
PLAYBOOK := setup_ans.yaml
INVENTORY := localhost,

# Default target
all: setup_venv  misctools

# Setup virtual environment by calling setup_ansible.sh script
setup_venv:
	@echo "Setting up Ansible virtual environment..."
	@bash $(SCRIPT_DIR)/setup_ansible.sh

# Run the Ansible playbook
all:
	@echo "Running Ansible playbook..."
	@~/venvs/ansible_venv/bin/ansible-playbook setup_ans.yml -i localhost,

misctools:
	@echo "Running Ansible Misctools..."
	@~/venvs/ansible_venv/bin/ansible-playbook ans_templates/misctools.yaml -i localhost,

.PHONY: all setup_venv all misctools