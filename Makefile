git := git --git-dir=$${GIT_DIR-.git/}

commits := $(shell mkdir -p tmp/commits && find tmp/commits -name '*.txt')
source_files := $(patsubst tmp/commits/%.txt,source/commits/%/index.html.md,$(commits))
diff_files := $(patsubst tmp/commits/%.txt,source/commits/%/_diff.html,$(commits))

.PHONY: all clean build

all: \
	$(source_files) \
	$(diff_files) \
	source/index.html.md \
	source/javascripts/site.js

build:
	mkdir -p tmp/commits/
	$(git) log --format="tmp/commits/%h.txt" | xargs touch

clean:
	rm -rf tmp source/{commits,javascripts,index.*} build data

node_modules: package.json yarn.lock
	yarn install

source/index.html.md: data/commits.yml
	$(git) show HEAD:README.md > $@

data/commits.yml:
	mkdir -p $(dir $@)
	echo "sequence:\n$$($(git) log --reverse --format="$$(cat templates/commit.yml)")" > data/commits.yml

source/commits/%/_diff.html: tmp/commits/%.txt
	$(git) show --cc --format="" $$(basename $< .txt) --output=$@

source/commits/%/index.html.md: tmp/commits/%.txt
	mkdir -p $(dir $@)
	$(git) show --no-patch --output=$@ --format="$$(cat templates/commit.md)" $$(basename $< .txt)

source/javascripts/site.js: javascripts/site.js node_modules
	mkdir -p $(dir $@)
	node_modules/.bin/webpack --config webpack.config.js $<
