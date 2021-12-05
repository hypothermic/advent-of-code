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
			LeftX = erlang:min(X1, X2),
			RightX = erlang:max(X1, X2),
			Vel = if
				Y2 > Y1 -> up;
				true -> down
			end,
			calc_line(Rest, calc_diag({LeftX, Y2}, {RightX, Y1}, Vel, []) ++ Out, Diag)
	end.

calc_diag({X, _Y}, {EndX, _EndY}, _Vel, Out) when X > EndX ->
	Out;

calc_diag({X, Y}, {EndX, EndY}, Vel, Out) when Vel == up ->
	calc_diag({X + 1, Y - 1}, {EndX, EndY}, Vel, [{X, Y} | Out]);

calc_diag({X, Y}, {EndX, EndY}, Vel, Out) ->
	calc_diag({X + 1, Y + 1}, {EndX, EndY}, Vel, [{X, Y} | Out]).

run(Input, Diagonals) ->
	Lines = lists:map(fun parse_line/1, Input),
	Points = calc_line(Lines, [], Diagonals),

	%io:format("points: ~p\n", [Points]),

	% dit kan verbeterd worden. duurt echt veel te lang nu...
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