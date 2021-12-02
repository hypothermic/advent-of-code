-module(day2).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

iterate([H | Tail], {Pos, Depth}) ->
	[Cmd, Val] = string:tokens(H, " "),
	Int = list_to_integer(Val),
	case Cmd of
		"forward" -> iterate(Tail, {Pos + Int, Depth});
		"up" -> iterate(Tail, {Pos, Depth - Int});
		"down" -> iterate(Tail, {Pos, Depth + Int})
	end;

iterate([], {Pos, Depth}) ->
	Pos * Depth.

first(Input) ->
	iterate(Input, {0, 0}).

iterate2([H | Tail], {Pos, Depth, Aim}) ->
	[Cmd, Val] = string:tokens(H, " "),
	Int = list_to_integer(Val),
	case Cmd of
		"forward" -> iterate2(Tail, {Pos + Int, Depth + (Int * Aim), Aim});
		"up" -> iterate2(Tail, {Pos, Depth, Aim - Int});
		"down" -> iterate2(Tail, {Pos, Depth, Aim + Int})
	end;

iterate2([], {Pos, Depth, _Aim}) ->
	Pos * Depth.

second(Input) ->
	iterate2(Input, {0, 0, 0}).