-module(day9).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

-define(MAP_NOT_FOUND, $9).

% I overslept this day and woke up 1,5 hours later
% so it wasn't a challenge for me anymore.
% heavily inspired by @danilagamma on erlang forums

iter(Map, Rows, Cols) ->
	[maps:get({X, Y}, Map) || X <- lists:seq(1, Rows), Y <- lists:seq(1, Cols), check(Map, X, Y)].

check(Map, X, Y) ->
	lists:all(fun (A) -> A > maps:get({X, Y}, Map) end,
		[maps:get({XDiff, Y}, Map, ?MAP_NOT_FOUND) || XDiff <- [X - 1, X + 1]]
		++ [maps:get({X, YDiff}, Map, ?MAP_NOT_FOUND) || YDiff <- [Y - 1, Y + 1]]).

parse([], Out, _) ->
	Out;
parse([Line | Rest], Out, X) ->
	{_, A} = lists:foldl(fun(Height, {Y, M}) -> {Y + 1, M#{{X, Y} => Height}} end, {1, Out}, Line),
	parse(Rest, A, X + 1).

first(Input) ->
	lists:sum([X - 48 + 1 || X <- iter(parse(Input, #{}, 1), length(Input), length(hd(Input)))]).

three_largest(Map, Rows, Cols, _) ->
	[basin_size({Line, Column}, Map, []) || Line <- lists:seq(1, Rows), Column <- lists:seq(1, Cols)].

basin_size({X, Y}, Map, Basin) ->
	case (maps:get({X, Y}, Map, ?MAP_NOT_FOUND) =/= ?MAP_NOT_FOUND)
	and not lists:member({X, Y}, Basin) of
		true ->
			basin_size_rec({X, Y}, Map, [{X, Y} | Basin]);
		false ->
			Basin
	end.

basin_size_rec({X, Y}, Map, Basin) ->
	basin_size({X, Y + 1}, Map,
		basin_size({X, Y - 1}, Map,
			basin_size({X + 1, Y}, Map,
				basin_size({X - 1, Y}, Map, Basin)))).

second(Input) ->
	Basins = [lists:sort(X) || X <- three_largest(parse(Input, #{}, 1), length(Input), length(hd(Input)), [])],
	[B1, B2, B3 | _] = lists:sort(fun(X, Y) -> length(X) > length(Y) end, lists:usort(Basins)),
	lists:foldl(fun(X, Y) -> X * Y end, 1, [length(X) || X <- [B1, B2, B3]]).