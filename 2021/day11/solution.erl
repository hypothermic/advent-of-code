-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

inc(_, Val) -> Val + 1.

flash_inc(Val) -> Val + 1.

flash({X, Y} = Point, Val, {NewFlashes, NewMap}) when Val > 9 ->
	Near = [
		{X - 1, Y - 1}, {X - 0, Y - 1}, {X + 1, Y - 1},
		{X - 1, Y - 0},                 {X + 1, Y - 0},
		{X - 1, Y + 1}, {X - 0, Y + 1}, {X + 1, Y + 1}
	],
	NewNewMap = lists:foldl(fun (Rel, Map) ->
		if
			is_map_key(Rel, Map) ->
				maps:update_with(Rel, fun flash_inc/1, Map);
			true ->
				Map
		end
	end, NewMap, Near),
	{NewFlashes + 1, NewNewMap#{Point => 0}};

flash(_, _, Acc) ->
	Acc.

step(0, _Map, Flashes, _LastFlashes) ->
	Flashes;

step(Step, Map, Flashes, LastFlashes) ->
	case Flashes of
		LastFlashes ->
			step(Step - 1, maps:map(fun inc/2, Map), Flashes, -1);
		_ ->
			{NewFlashes, NewMap} = maps:fold(fun flash/3, {0, Map}, Map),
			step(Step, NewMap, Flashes + NewFlashes, Flashes)
	end.

parse(Input) ->
	maps:from_list([{{X, Y}, lists:nth(X, lists:nth(Y, Input)) - 48} || X <- lists:seq(1, 10), Y <- lists:seq(1, 10)]).

first(Input) ->
	step(100, parse(Input), 0, -1).

all(Step, Map, Flashes, LastFlashes) ->
	case Flashes of
		LastFlashes ->
			all(Step + 1, maps:map(fun inc/2, Map), Flashes, -1);
		_ ->
			{NewFlashes, NewMap} = maps:fold(fun flash/3, {0, Map}, Map),

			case NewFlashes =:= 100 of
				true -> Step;
				false -> all(Step, NewMap, Flashes + NewFlashes, Flashes)
			end
	end.

second(Input) ->
	all(0, parse(Input), 0, -1).
