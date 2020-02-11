GIT_DIR := $(shell echo "$${GIT_DIR-./}")
OUTPUT_DIR := $(shell echo "$${OUTPUT_DIR-./build}")

.PHONY: all clean compile

all: install compile

serve: install
	GIT_DIR=$(GIT_DIR) bundle exec middleman serve

install:
	script/setup

compile:
	mkdir -p $(OUTPUT_DIR)
	GIT_DIR=$(GIT_DIR) bundle exec middleman build --verbose --build-dir=$(OUTPUT_DIR)

clean:
	rm -rf dist/ $(OUTPUT_DIR)
