GIT_DIR := $(realpath $(shell echo "$${GIT_DIR-./}"))
TOOL_DIR := $(realpath $(shell echo "$${TOOL_DIR-./}"))

OUTPUT_DIR := $(shell echo "$${OUTPUT_DIR-./build}")

.PHONY: all clean compile

all: install compile

serve: install
	cd $(TOOL_DIR) && \
		GIT_DIR=$(GIT_DIR) bundle exec middleman serve
	cd $(GIT_DIR)

install:
	$(TOOL_DIR)/script/setup

compile:
	mkdir -p $(OUTPUT_DIR)
	cd $(TOOL_DIR) && \
		GIT_DIR=$(GIT_DIR) bundle exec middleman build \
		--build-dir=$(OUTPUT_DIR) \
		$${VERBOSE} && \
		cd $(GIT_DIR)

clean:
	rm -rf $(TOOL_DIR)/dist/ $(OUTPUT_DIR)
