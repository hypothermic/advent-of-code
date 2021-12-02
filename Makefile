# I recommend you just type the commands in README.md directly into the console
# Because make can sometimes not display the output correctly :)

TXT_PATH    ?= ./src/
SCRIPT_PATH ?= ../_build/default/bin/
OUT_PATH    ?= ../

.PHONY: all
all: build run

build:
	rebar3 escriptize

run:
	cd $(TXT_PATH) || set -m && clear || $(SCRIPT_PATH)aoc21 &> $(OUT_PATH)out.txt