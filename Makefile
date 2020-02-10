.PHONY: all clean build compile

all: install compile

serve: install
	bundle exec middleman serve

install: Gemfile Gemfile.lock yarn.lock package.json
	script/setup

compile: build/
	bundle exec middleman build

clean:
	rm -rf build/ dist/
