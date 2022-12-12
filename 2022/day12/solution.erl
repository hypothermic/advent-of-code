-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

val($S) ->
	val($a)-1;
val($E) ->
	val($z)+1;
val(Char) ->
	Char - 96.

parse(Input) ->
	array:from_list([array:fix(array:from_list([val(C) || C <- I])) || I <- Input]).

addv(G, X, Y, X, Y) ->
	ok;
addv(G, Xmax, Y, Xmax, Ymax) ->
	addv(G, 0, Y+1, Xmax, Ymax);
addv(G, X, Y, Xmax, Ymax) ->
	digraph:add_vertex(G, {X, Y}),
	addv(G, X+1, Y, Xmax, Ymax).

find2d(P, E, X, Y, X, Y) ->
	false;
find2d(P, E, Xmax, Y, Xmax, Ymax) ->
	find2d(P, E, 0, Y+1, Xmax, Ymax);
find2d(P, E, X, Y, Xmax, Ymax) ->
	case array:get(X, array:get(Y, P)) of
		E ->
			{X, Y};
		_ ->
			find2d(P, E, X+1, Y, Xmax, Ymax)
	end.

jump(Val, Next) when Next =< Val+1 ->
	true;
jump(_, _) ->
	false.

adde(G, P, X, Y, X, Y) ->
	ok;
adde(G, P, Xmax, Y, Xmax, Ymax) ->
	adde(G, P, 0, Y+1, Xmax, Ymax);
adde(G, P, X, Y, Xmax, Ymax) ->
	%io:format("X ~B, Y ~B", [X, Y]),
	Val = array:get(X, array:get(Y, P)),

	[digraph:add_edge(G, {X, Y}, {X+RX, Y+RY}) ||
		RX <- lists:seq(-1, 1),
		RY <- lists:seq(-1, 1),
		{X+RX, Y+RY} =/= {X, Y},
		{X+RX, Y+RY} =/= {X+1, Y+1},
		{X+RX, Y+RY} =/= {X+1, Y-1},
		{X+RX, Y+RY} =/= {X-1, Y+1},
		{X+RX, Y+RY} =/= {X-1, Y-1},
		X+RX >= 0,
		X+RX < Xmax,
		Y+RY >= 0,
		Y+RY =< Ymax,
		jump(Val, array:get(X+RX, array:get(Y+RY, P)))
	],

	adde(G, P, X+1, Y, Xmax, Ymax).


first(Input) ->
	Parsed = parse(Input),
	Xmax = array:size(array:get(1, Parsed)),
	Ymax = array:size(Parsed)-1,
	%io:format("Xmax=~B, Ymax=~B", [Xmax, Ymax]),

	Graph = digraph:new(),
	addv(Graph, 0, 0, Xmax, Ymax),
	adde(Graph, Parsed, 0, 0, Xmax, Ymax),

	Start = find2d(Parsed, val($S), 0, 0, Xmax, Ymax),
	End = find2d(Parsed, val($E), 0, 0, Xmax, Ymax),

	length(digraph:get_short_path(Graph, Start, End))-1.

second(Input) ->
	Parsed = parse(Input),
	Xmax = array:size(array:get(1, Parsed)),
	Ymax = array:size(Parsed)-1,

	Graph = digraph:new(),
	addv(Graph, 0, 0, Xmax, Ymax),
	adde(Graph, Parsed, 0, 0, Xmax, Ymax),

	Starts = [{X, Y} ||
		X <- lists:seq(0, Xmax-1),
		Y <- lists:seq(0, Ymax-1),
		array:get(X, array:get(Y, Parsed)) =:= val($a)
	],
	End = find2d(Parsed, val($E), 0, 0, Xmax, Ymax),

	Lengths = [length(digraph:get_short_path(Graph, Start, End))-2 ||
		Start <- Starts,
		digraph:get_short_path(Graph, Start, End) =/= false
	],

	lists:min(Lengths).
