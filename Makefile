git := git --git-dir=$${GIT_DIR-.git/}

commits := $(shell mkdir -p tmp/commits && find tmp/commits -name '*.txt')
data_files := $(patsubst tmp/commits/%.txt,data/commits/%.yml,$(commits))

TARGETS := \
	$(data_files) \
	data/history.yml \
	source/index.html.md

.PHONY: all clean build compile

all: $(TARGETS)

compile: $(TARGETS)
	middleman build

build:
	mkdir -p tmp/commits/
	$(git) log --format="tmp/commits/%h.txt" | xargs touch

clean:
	rm -rf tmp source/index.* build data

source/index.html.md:
	$(git) show HEAD:README.md > $@

data/commits/%.yml: tmp/commits/%.txt
	mkdir -p $(dir $@)
	script/template-data $$(basename $< .txt) > $@

data/history.yml:
	mkdir -p $(dir $@)
	script/template-history "$$($(git) log --reverse --root --format='- %h')" > $@
