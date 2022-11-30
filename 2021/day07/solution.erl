-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

calc(Input, DistanceFunc) ->
	lists:min([
		lists:sum([
			DistanceFunc(Crab, Point) || Crab <- Input
		])
		|| Point <- lists:seq(lists:min(Input), lists:max(Input))
	]).

parse(Input) ->
	lists:map(fun binary_to_integer/1, re:split(Input, ",")).

first(Input) ->
	trunc(calc(parse(Input), fun (P1, P2) -> abs(P2 - P1) end)).

second(Input) ->
	trunc(calc(
		parse(Input),
		fun (P1, P2) ->
			A = abs(P2 - P1),
			A * (A + 1) / 2
		end
	)).