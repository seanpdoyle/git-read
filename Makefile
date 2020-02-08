commits := $(shell mkdir -p tmp/commits && find tmp/commits -name '*.txt')
source_files := $(patsubst tmp/commits/%.txt,source/commits/%/index.html.md.erb,$(commits))
diff_files := $(patsubst tmp/commits/%.txt,source/commits/%/_diff.html,$(commits))

.PHONY: all clean build

all: $(source_files) $(diff_files) source/index.html.md data/commits.yml

clean:
	rm -rf tmp source/commits source/index.* build data

build:
	mkdir -p tmp/commits/
	git log --format="tmp/commits/%h.txt" | xargs touch

source/index.html.md: README.md
	cp README.md source/index.html.md

source/commits/%/_diff.html: tmp/commits/%.txt
	git show --cc --format="" $$(basename $< .txt) --output=$@

data/commits.yml:
	mkdir -p $(dir $@)
	echo "sequence:\n$$(git log --reverse --format="$$(cat templates/commit.yml)")" > data/commits.yml

source/commits/%/index.html.md.erb: tmp/commits/%.txt
	mkdir -p $(dir $@)
	git show --no-patch --output=$@ --format="$$(cat templates/commit.md)" $$(basename $< .txt)
