-module(day13).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

parse_line([[$f | Line] | Next], {Dots, Instrs}) ->
	Dir = case lists:nth(11, Line) of
		$x -> x;
		$y -> y
	end,
	Ln = lists:nth(13, Line) - $0,
	parse_line(Next, {Dots, [{Dir, Ln} | Instrs]});

parse_line([Line | Next], {Dots, Instrs}) ->
	[X, Y] = [binary_to_integer(Tok) || Tok <- re:split(Line, ",")],
	parse_line(Next, {[{X, Y} | Dots], Instrs});

parse_line([_ | Next], Out) ->
	parse_line(Next, Out);

parse_line([], Out) ->
	Out.

new_pos_rel(Ln, Pos) ->
	if
		Ln >= Pos -> Pos;
		true -> 2 * Ln - Pos
	end.

new_pos({Dir, Ln}, {X, Y}) ->
	case Dir of
		x -> {new_pos_rel(Ln, X), Y};
		y -> {X, new_pos_rel(Ln, Y)}
	end.

first(Input) ->
	{Dots, [Instr | _]} = parse_line(Input, {[], []}),

	length(lists:usort(lists:map(fun (Dot) -> new_pos(Instr, Dot) end, Dots))).

print_cell(Input, XY) ->
	case maps:get(XY, Input, $?) of
		$? -> $.;
		_ -> $#
	end.

print_hz(Input, Y) ->
	[io:format("~c", [print_cell(Input, {X, Y})]) || X <- lists:seq(1, 80)],
	io:format("\n").

print(Input) ->
	[print_hz(Input, Y) || Y <- lists:seq(1, 10)].

second(Input) ->
	{Dots, Instrs} = parse_line(Input, {[], []}),

	print(maps:from_list(lists:foldl(fun(Instr, Dotss) -> lists:map(fun (Dot) -> new_pos(Instr, Dot) end, Dotss) end, Dots, Instrs))),

	1. % this module must return an int... stupid exercise to make us print the solution.
