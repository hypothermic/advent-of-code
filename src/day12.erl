-module(day12).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

parse(Input) ->
	lists:foldl(fun([A, B], AccMap) ->
		AccMap2 = maps:update_with(A, fun(List) -> [B | List] end, [B], AccMap),
		maps:update_with(B, fun(List) -> [A | List] end, [A], AccMap2)
	end, #{}, [re:split(Line, "-") || Line <- Input]).

find(Map, Visited, <<Letter, _/binary>> = Cave, Part2) ->
	if
		Cave == <<"end">> -> 1;
		is_map_key(Cave, Visited) ->
			if
				Part2 and (Cave =/= <<"start">>) ->
					lists:sum([
						find(Map, Visited#{Cave=>true}, NearbyCave, false)
						|| NearbyCave <- maps:get(Cave, Map)
					]);
				true -> 0
			end;
		Letter > 64, Letter < 91 ->
			lists:sum([
				find(Map, Visited, NearbyCave, Part2)
				|| NearbyCave <- maps:get(Cave, Map)
			]);
		true ->
			lists:sum([
				find(Map, Visited#{Cave=>true}, NearbyCave, Part2)
				|| NearbyCave <- maps:get(Cave, Map)
			])
	end.

first(Input) ->
	find(parse(Input), #{}, <<"start">>, false).

second(Input) ->
	find(parse(Input), #{}, <<"start">>, true).
