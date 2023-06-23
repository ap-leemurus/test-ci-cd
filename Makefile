### BEGIN CFG CONSTANTS
PYTHON_VER := "3.11.3"
### END CFG CONSTANTS


ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DJANGO_MANAGE_PATH := $(ROOT_DIR)/apostro/manage.py

IS_PYENV_OK := $(shell pyenv prefix $(PYTHON_VER) > /dev/null 2> /dev/null; echo $$?)
TARGET_PYTHON := $(shell pyenv prefix $(PYTHON_VER) 2> /dev/null)/bin/python3
DJANGO_RUN := poetry run python3 $(DJANGO_MANAGE_PATH)


# ========================================================================== #


.PHONY: venv
venv:
ifneq ($(IS_PYENV_OK), 0)
	@echo "Please, use pyenv with python version $(PYTHON_VER) installed"
	exit 1
else
	poetry env use $(TARGET_PYTHON)  # create specific version of virtual environment
	poetry install  # install packages
endif


# ========================================================================== #


.PHONY: hooks
hooks: venv
	poetry run pre-commit install


# ========================================================================== #


.PHONY: run-hooks
run-hooks: hooks
	poetry run pre-commit run --all-files
