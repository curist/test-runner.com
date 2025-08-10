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

artifacts/test-runner.com: artifacts/redbean.dev.com test-runner/.lua/fennel.lua test-runner/.fnl/redbean.fnl $(TEST_RUNNER_SRC)
	cp $< redbean.com
	cd test-runner && zip -r ../redbean.com .
	mv redbean.com $@ 

test: artifacts/test-runner.com
	@$< $(ARGS)

clean:
	rm -rf artifacts

lint:
	@fennel-ls --lint $$(find . -iname "*.fnl" -type f)

