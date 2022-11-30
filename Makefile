SOURCES			?= src/*.erl 20**/day**/solution.erl
SCRIPT_PATH	 	?= ./_build/default/bin
SCRIPT_BIN		?= $(SCRIPT_PATH)/aoc
OUT_PATH    	?= ../

# When "run" target is specified, pass along all args
# https://stackoverflow.com/a/14061796
ifeq (run, $(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: all
all: build run

build: $(SCRIPT_BIN)
$(SCRIPT_BIN): $(SOURCES)
	rebar3 escriptize

clean:
	rm $(SCRIPT_BIN)

run: build
	set -m && $(SCRIPT_BIN) $(RUN_ARGS)