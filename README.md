My solutions for Advent of Code
=====

I rarely write programs in high level languages anymore because I study/work in the embedded field...
My goal is to stay up to date with Erlang and wipe the rust off my brain by solving the yearly AoC challenges :-)

Build & run
-----

If you want to run this project, make sure you have [rebar3](http://www.rebar3.org/) installed.
It's the de-facto toolchain for Erlang nowadays, so you really shouldn't be using anything else.
Use the Makefile with the build/run/clean targets, or manually do these things:

    $ rebar3 escriptize
    $ set -m && clear && _build/default/bin/aoc

Using command-line arguments, a specific year or day can be specified to run.
The data set (real data or sample data) can be chosen using the `mode` argument:

    $ make run [year X] [day X] [mode data/sample]
    $ make run year 2021 day 3 mode sample

Completion times 2019
-----

| Day | Time required | Finished at (CET) | Global rank | Solution                             |
| --- | ------------- | ----------------- | ----------- |--------------------------------------|
| 1   | 10:31         | 06:10 AM          | 2608        | [day1.erl](2021/day01/solution.erl)  |
| 2   | 06:08         | 06:06 AM          | 4147        | [day2.erl](2021/day02/solution.erl)  |
| 3   | 33:31         | 06:33 AM          | 3001        | [day3.erl](2021/day03/solution.erl)  |
| 4   | 24:54         | 06:24 AM          | 1038        | [day4.erl](2021/day04/solution.erl)  |
| 5   | 26:30         | 06:26 AM          | 1652        | [day5.erl](2021/day05/solution.erl)  |
| 6   | 19:02         | 06:19 AM          | 1841        | [day6.erl](2021/day06/solution.erl)  |
| 7   | 16:30         | 06:16 AM          | 4087        | [day7.erl](2021/day07/solution.erl)  |
| 8   | 33:01         | 06:33 AM          | 542         | [day8.erl](2021/day08/solution.erl)  |
| 9   | too late      | too late          | too bad     | [day9.erl](2021/day09/solution.erl)  |
| 10  | 18:54         | 06:18 AM          | 1573        | [day10.erl](2021/day10/solution.erl) |
