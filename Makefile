GIT_DIR := $(realpath $(shell echo "$${GIT_DIR-./}"))
OUTPUT_DIR := $(realpath $(shell echo "$${OUTPUT_DIR-./build}"))
TOOL_DIR := $(realpath $(shell echo "$${TOOL_DIR-./}"))

.PHONY: all clean compile

all: install compile

serve: install
	GIT_DIR=$(GIT_DIR) bundle exec --gemfile="$(TOOL_DIR)/Gemfile" middleman serve

install:
	$(TOOL_DIR)/script/setup

compile:
	mkdir -p $(OUTPUT_DIR)
	cd $(TOOL_DIR)

	echo "Building from $(TOOL_DIR) to $(OUTPUT_DIR):"
	echo

	GIT_DIR=$(GIT_DIR) bundle exec middleman build \
		--build-dir=$(OUTPUT_DIR) \
		$${VERBOSE}

	cd $(GIT_DIR)

clean:
	rm -rf $(TOOL_DIR)/dist/ $(OUTPUT_DIR)
