## User Vars
#
# You can change these to match your system setup

BOSH_CLI_VERSION ?= $(shell \$(BOSH_CMD) --version | cut -f1 -d. | cut -f2 -d" ")
BOSH_ENV ?= vbox
BOSH_PATH ?= /usr/local/bin
DEPLOYMENT_NAME ?= syslog-pglog
BOSH_USERNAME ?= admin
BOSH_PASSWORD ?= admin
BOSH_CREDS_FILE ?= ~/deployments/vbox/creds.yml
BOSH_TARGET ?= 192.168.50.4
CF_ORG ?= org
CF_SPACE ?= space
CF_USERNAME ?= admin
CF_PASSWORD ?= admin
CF_URL ?= https://api.local.pcfdev.io
RELEASE_VERSION ?= 11.3.2.01
TEMPLATE_STUBS ?=
TILE_VERSION ?= $(RELEASE_VERSION)

## System Vars
#
# These should be standard across all environments

SHELL = /bin/bash
BOSH_CMD = $(BOSH_PATH)/bosh
BOSH_CLIENT = admin
BOSH_CLIENT_SECRET = $(shell \$(BOSH_CMD) int $(BOSH_CREDS_FILE) --path /admin_password)
SPRUCE = $(shell which spruce)
MANIFESTS_DIR = $(CURDIR)/manifests
TEMPLATES_DIR = $(CURDIR)/templates
TEMPLATE_STUBS_DIR = $(TEMPLATES_DIR)/stubs
CLOUD_CONFIG = $(MANIFESTS_DIR)/bosh-lite-cloud-config.yml
DEPLOYMENT_MANIFEST = $(MANIFESTS_DIR)/bosh-lite-manifest.yml
DEPLOYMENT_MANIFEST_TEMPLATE = $(TEMPLATES_DIR)/bosh-lite-template.yml
DEV_RELEASE_TARBALL = $(CURDIR)/dev_releases/$(DEPLOYMENT_NAME)/$(DEPLOYMENT_NAME)-latest.tgz
RELEASE_TARBALL = $(CURDIR)/releases/$(DEPLOYMENT_NAME)/$(DEPLOYMENT_NAME)-$(RELEASE_VERSION).tgz

# Optionally include a user variables file
-include uservars.mk

## Common make targets
#
# These targets are useful across all inherited sources

# Outputs all of the variables used in the Makefile
#
# Useful for debugging
showvars:
	@$(info BOSH_CLI_VERSION: $(BOSH_CLI_VERSION))
	@$(info BOSH_CLIENT: $(BOSH_CLIENT))
	@$(info BOSH_CLIENT_SECRET: $(BOSH_CLIENT_SECRET))
	@$(info BOSH_CMD: $(BOSH_CMD))
	@$(info BOSH_PASSWORD: $(BOSH_PASSWORD))
	@$(info BOSH_PATH: $(BOSH_PATH))
	@$(info BOSH_TARGET: $(BOSH_TARGET))
	@$(info BOSH_USERNAME: $(BOSH_USERNAME))
	@$(info CF_BIN: $(CF_BIN))
	@$(info CF_ORG: $(CF_ORG))
	@$(info CF_PASSWORD: $(CF_PASSWORD))
	@$(info CF_SPACE: $(CF_SPACE))
	@$(info CF_USERNAME: $(CF_USERNAME))
	@$(info CLOUD_CONFIG: $(CLOUD_CONFIG))
	@$(info DEPLOYMENT_MANIFEST: $(DEPLOYMENT_MANIFEST))
	@$(info DEPLOYMENT_MANIFEST_TEMPLATE: $(DEPLOYMENT_MANIFEST_TEMPLATE))
	@$(info DEPLOYMENT_NAME: $(DEPLOYMENT_NAME))
	@$(info DEV_RELEASE_TARBALL: $(DEV_RELEASE_TARBALL))
	@$(info INSPEC_TESTS: $(INSPEC_TESTS))
	@$(info MANIFESTS_DIR: $(MANIFESTS_DIR))
	@$(info RELEASE_TARBALL: $(RELEASE_TARBALL))
	@$(info RELEASE_VERSION: $(RELEASE_VERSION))
	@$(info S3_BASE: $(S3_BASE))
	@$(info S3_URL: $(S3_URL))
	@$(info S3_URL_INSPEC: $(S3_URL_INSPEC))
	@$(info SHELL: $(SHELL))
	@$(info SPRUCE: $(SPRUCE))
	@$(info STEMCELL: $(STEMCELL))
	@$(info STEMCELL_NAME: $(STEMCELL_NAME))
	@$(info STEMCELL_URL: $(STEMCELL_URL))
	@$(info TEMPLATES_DIR: $(TEMPLATES_DIR))
	@$(info TEMPLATE_STUBS: $(TEMPLATES_STUBS))
	@$(info TEMPLATE_STUBS_DIR: $(TEMPLATES_STUBS_DIR))
	@$(info TILE_VERSION: $(TILE_VERSION))
	@echo ""
