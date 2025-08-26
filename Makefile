.PHONY: test clean lint
.DEFAULT_GOAL := test

FENNEL_VERSION = 1.5.3
TEST_RUNNER_SRC = $(shell find test-runner -type f)

artifacts/redbean.version.txt:
	mkdir -p $(@D)
	curl https://redbean.dev/latest.txt > $@

artifacts/redbean.dev.com: artifacts/redbean.version.txt
	curl -o $@ https://redbean.dev/redbean-$(shell cat $<).com
	chmod +x $@

test-runner/.lua/fennel.lua:
	mkdir -p $(@D)
	curl -o $@ https://fennel-lang.org/downloads/fennel-${FENNEL_VERSION}.lua

redbean-fennel/fennel:
	curl -o $@ https://fennel-lang.org/downloads/fennel-${FENNEL_VERSION}

artifacts/redbean-fennel: artifacts/redbean.dev.com redbean-fennel/fennel test-runner/.lua/fennel.lua
	cp $< redbean.com
	cp test-runner/.lua/fennel.lua redbean-fennel/.lua/fennel.lua
	cd redbean-fennel && zip -r ../redbean.com .
	mv redbean.com $@ 

artifacts/test-runner.com: artifacts/redbean.dev.com test-runner/.lua/fennel.lua test-runner/.fnl/redbean.fnl $(TEST_RUNNER_SRC) USAGE.md artifacts/redbean.version.txt
	cp $< redbean.com
	cd test-runner && zip -r ../redbean.com .
	zip -j redbean.com LICENSE USAGE.md artifacts/redbean.version.txt
	@if [ -f VERSION.txt ]; then zip -j redbean.com VERSION.txt; fi
	mv redbean.com $@ 

test: artifacts/test-runner.com
	@$< $(ARGS)

clean:
	rm -rf artifacts

lint:
	@fennel-ls --lint $$(find . -iname "*.fnl" -type f)

