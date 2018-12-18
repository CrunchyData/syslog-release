# Makefile for syslog-release
#
include Makefile-pcf.mk

## User Build Targets
# Normal targets assume a final build
# Targets with a *-dev name do not create final builds

.PHONY: all clean dev build status login target showvars

all: status login target build 

clean: bosh-cleanup remove-releases

dev: status login target build-dev 

final: all tarball

fresh: full-clean all

fresh-dev: full-clean dev

full-clean: clean remove-files

rebuild: clean all

rebuild-dev: clean dev

test: all broker-registrar 

test-dev: dev broker-registrar 


## Interstitial Targets
#
# These are used as stepping-stones for the main targets listed above

bosh-cleanup:
	#################################################
	#    Removing all deployments and releases      #
	#               Are you sure?                   #
	#                                               #
	#     Use '^C' to abort the process now         #
	#    Enter 'yes' to proceed with cleanup        #
	#################################################

ifeq ($(BOSH_CLI_VERSION), 1)
	@$(BOSH_CMD) delete release $(DEPLOYMENT_NAME) --force
else
	@$(BOSH_CMD) -e $(BOSH_ENV) delete-release $(DEPLOYMENT_NAME) --force
endif

build: build-blackbox tarball 
ifndef SKIPUPLOAD
ifeq ($(BOSH_CLI_VERSION), 1)
	@$(BOSH_CMD) upload release $(shell \ls -t releases/$(DEPLOYMENT_NAME)/syslog-pglog-*.tgz | head -1)
else
	@$(BOSH_CMD) -e $(BOSH_ENV) upload-release $(RELEASE_TARBALL)
endif
endif

build-blackbox: 
	@$(GIT_CMD) submodule update --init --recursive
	mkdir -p src/blackbox
	GOPATH=$(CURDIR) GOOS=linux GOARCH=amd64 $(GO_CMD) build -o src/blackbox/blackbox-linux64 src/github.com/CrunchyData/blackbox/cmd/blackbox/main.go

build-dev: build-blackbox tarball-dev 
ifndef SKIPUPLOAD
ifeq ($(BOSH_CLI_VERSION), 1)
	@$(BOSH_CMD) upload release $(shell \ls -t dev_releases/$(DEPLOYMENT_NAME)/syslog-pglog-*.tgz | head -1)
else
	@$(BOSH_CMD) -e $(BOSH_ENV) upload-release $(DEV_RELEASE_TARBALL)
endif
endif

help:
		@printf "\
                Bosh Makefile\n\
                Makefile targets (run \"make <target>\"):\n\
                \n\
                All targets have a 'dev' version which does not produce a final target\n\
                unless otherwise noted. Call with \`<target>-dev\`.\n\
                \n\
                all           Compile and test all targets.\n\
                clean         Clean the workspace and remove any previous deployments.\n\
                final         Produces a final build tarball. (Does not have a -dev version).\n\
                fresh         Perform a clean build, removing any previous builds before rebuilding. (same as \`make clean all\`)\n\
                full-clean    Remove all S3 Source packages, clear workspace, and remove previous deployments.\n\
                login         Log in to the Bosh targets using provided credentials.\n\
                status        Displays the status of Bosh.\n\
                tarball       Create a release tarball, suitable for deployment elsewhere.\n\
                test          Run acceptance tests against build.\n\
                tile          Perform a build and generate a *.pivotal CF Tile.\n\
                "


# The @ symbol prevents the command from being echoed,
# preventing leaks of non-default passwords
login:
ifeq ($(BOSH_CLI_VERSION), 1)
	@$(BOSH_CMD) login $(BOSH_USERNAME) $(BOSH_PASSWORD)
else
	@$(BOSH_CMD) -e $(BOSH_ENV) --client=$(BOSH_CLIENT) --client-secret=$(BOSH_CLIENT_SECRET) log-in
endif

remove-releases:
	@$(RM) dev_releases/**/**.tgz
	@$(RM) releases/*.tgz
	@$(RM) config/dev.yml

remove-files:
	@find $(CURDIR)/src -type f \( -iname '*t*gz' -o -iname '*zip' -o -iname '*deb' -o -iname '*bz2' \) -delete

status:
ifeq ($(BOSH_CLI_VERSION), 1)
	@$(BOSH_CMD) status
else
	@$(BOSH_CMD) -e $(BOSH_ENV) env
endif

tarball:
ifeq ($(BOSH_CLI_VERSION), 1)
	yes | $(BOSH_CMD) create release --final --with-tarball --force --name "$(DEPLOYMENT_NAME)" --version "$(RELEASE_VERSION)"
else
	$(BOSH_CMD) -e $(BOSH_ENV) -n create-release --final --force --name=$(DEPLOYMENT_NAME) --version=$(RELEASE_VERSION) --tarball=$(RELEASE_TARBALL)
endif

tarball-dev:
ifeq ($(BOSH_CLI_VERSION), 1)
	$(BOSH_CMD) create release --with-tarball --force --name "$(DEPLOYMENT_NAME)" --timestamp-version
else
	$(BOSH_CMD) -e $(BOSH_ENV) create-release --force --timestamp-version --name=$(DEPLOYMENT_NAME) --tarball=$(DEV_RELEASE_TARBALL)
endif

target:
ifeq ($(BOSH_CLI_VERSION), 1)
	@$(BOSH_CMD) target $(BOSH_TARGET)
endif

