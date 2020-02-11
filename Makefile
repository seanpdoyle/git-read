.PHONY: all clean compile

all: install compile

serve: install
	bundle exec middleman serve

install:
	script/setup

compile:
	bundle exec middleman build --verbose

clean:
	rm -rf build/ dist/
