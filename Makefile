CMDS=csi-proxy
all: build test

# include release tools for building binary and testing targets
include release-tools/build.make

BUILD_PLATFORMS=windows amd64 amd64 .exe
GOPATH ?= $(shell go env GOPATH)
REPO_ROOT = $(CURDIR)
BUILD_DIR = bin
BUILD_TOOLS_DIR = $(BUILD_DIR)/tools
GO_ENV_VARS = GO111MODULE=on GOOS=windows

# see https://github.com/golangci/golangci-lint/releases
GOLANGCI_LINT_VERSION = v1.21.0
GOLANGCI_LINT = $(BUILD_TOOLS_DIR)/golangci-lint/$(GOLANGCI_LINT_VERSION)/golangci-lint

.PHONY: lint
lint: $(GOLANGCI_LINT)
	$(GO_ENV_VARS) $(GOLANGCI_LINT) run
	git --no-pager diff --exit-code

# see https://github.com/golangci/golangci-lint#binary-release
$(GOLANGCI_LINT):
	curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$$(dirname '$(GOLANGCI_LINT)')" '$(GOLANGCI_LINT_VERSION)'

# this should only be run in a Windows environment
.PHONY: test-go
test: test-go
test-go:
	@ echo; echo "### $@:"
	GO111MODULE=on go test ./pkg/...
