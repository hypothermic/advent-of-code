-module(day5).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

% 't duurt gwn 2 minuten om deze te runnen haha
% wrss kan t veel efficienter

parse_line(Input) ->
	[X, Y] = string:split(Input, " -> "),
	[X1, X2] = string:split(X, ","),
	[Y1, Y2] = string:split(Y, ","),
	{
		{list_to_integer(X1), list_to_integer(X2)},
		{list_to_integer(Y1), list_to_integer(Y2)}
	}.

calc_line([], Out, _Diag) ->
	lists:reverse(Out);

% verticaal
calc_line([{{X1, Y1}, {X2, Y2}} = Line | Rest], Out, Diag) when X1 == X2 ->
	calc_line(Rest,
		[{X, Y} ||
			X <- [X1],
			Y <- lists:seq(erlang:min(Y1, Y2), erlang:max(Y1, Y2))
		] ++ Out, Diag);

% horizontaal
calc_line([{{X1, Y1}, {X2, Y2}} = Line | Rest], Out, Diag) when Y1 == Y2 ->
	calc_line(Rest,
		[{X, Y} ||
			X <- lists:seq(erlang:min(X1, X2), erlang:max(X1, X2)),
			Y <- [Y1]
		] ++ Out, Diag);

% diagonaal
calc_line([{{X1, Y1}, {X2, Y2}} = Line | Rest], Out, Diag) ->
	case Diag of
		false -> calc_line(Rest, Out, Diag);
		true ->
			calc_line(Rest,
				[{X, Y} ||
					X <- lists:seq(erlang:min(X1, X2), erlang:max(X1, X2)),
					Y <- lists:seq(erlang:min(Y1, Y2), erlang:max(Y1, Y2))
				] ++ Out, Diag)
	end.

run(Input, Diagonals) ->
	Lines = lists:map(fun parse_line/1, Input),
	Points = calc_line(Lines, [], Diagonals),

	%io:format("points: ~p\n", [Points]),

	Dupes = lists:foldl(fun(A, Acc) ->
		case length([B || B <- Points, B =:= A]) of
			1 -> Acc;
			_ -> [A | Acc]
		end
	end, [], Points),
	length(lists:usort(Dupes)).

first(Input) ->
	run(Input, false).

second(Input) ->
	run(Input, true).