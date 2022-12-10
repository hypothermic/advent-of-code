-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

res(Elapsed, X, Res) ->
	case lists:member(Elapsed, [20, 60, 100, 140, 180, 220]) of
		true ->
			Res ++ [Elapsed * X];
		_ ->
			Res
	end.

pic(Elapsed, X, Pic) when Elapsed rem 40 =:= 0 ->
	Pic ++ [case abs(X-(Elapsed rem 40))=<1 of true->$#; _->$. end] ++ [$\n];
pic(Elapsed, X, Pic) ->
	Pic ++ [case abs(X-(Elapsed rem 40))=<1 of true->$#; _->$. end].

cycle([], _Wait, _Elapsed, _X, Res, Pic) ->
	{Res, Pic};
cycle([[]], _Wait, _Elapsed, _X, Res, Pic) ->
	{Res, Pic};
cycle([["noop"] | A], Wait, Elapsed, X, Res, Pic) ->
	cycle(A, Wait, Elapsed+1, X, res(Elapsed, X, Res), pic(Elapsed, X, Pic));
cycle([["addx", _Val] | _] = A, 0, Elapsed, X, Res, Pic) ->
	cycle(A, 1, Elapsed+1, X, res(Elapsed, X, Res), pic(Elapsed, X, Pic));
cycle([["addx", Val] | A], 1, Elapsed, X, Res, Pic) ->
	cycle(A, 0, Elapsed+1, X+list_to_integer(Val), res(Elapsed, X, Res), pic(Elapsed, X, Pic)).

first(Input) ->
	Instrs = lists:map(fun (A) -> string:tokens(A, " ") end, Input),

	{Res, _} = cycle(Instrs, 0, 1, 1, [], []),

	lists:sum(Res).

second(Input) ->
	Instrs = lists:map(fun (A) -> string:tokens(A, " ") end, Input),

	{_, Pic} = cycle(Instrs, 0, 1, 1, [], []),

	Pic.
