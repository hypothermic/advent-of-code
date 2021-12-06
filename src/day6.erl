-module(day6).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

% niet de mooiste oplossing, maar wel in 18 minuten gemaakt :)

day(Current, #{0 := I1, 1 := I2, 2 := I3, 3 := I4, 4 := I5, 5 := I6, 6 := I7, 7 := I8, 8 := I9}) when Current > 0 ->
	day(Current - 1, #{0 => I2, 1 => I3, 2 => I4, 3 => I5, 4 => I6, 5 => I7, 6 => I8 + I1, 7 => I9, 8 => I1});

day(0, Fish) ->
	maps:fold(fun (_K, V, Acc) -> Acc + V end, 0, Fish).

init(Iterations, [Fish | Rest], Map) ->
	init(Iterations, Rest, maps:update_with(Fish, fun (V) -> V + 1 end, 1, Map));

init(Iterations, [], Map) ->
	io:format("a: ~p\n", [Map]),
	day(Iterations, Map).

parse(Input, Iterations) ->
	init(Iterations, lists:map(fun binary_to_integer/1, re:split(Input, ",")),
		#{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0}).

first(Input) ->
	parse(Input, 80).

second(Input) ->
	parse(Input, 256).