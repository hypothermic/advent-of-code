-module(day8).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

val(Num, Wires) ->
	case length(Num) of
		2 -> 1;
		3 -> 7;
		4 -> 4;
		7 -> 8;

		_ ->
			maps:fold(fun (K, V, Acc) ->
				case length(lists:subtract(Num, K)) of
					0 -> V;
					_ -> Acc
				end
			end, 0, Wires)
	end.

one(Pattern, Length) ->
	lists:nth(1, multiple(Pattern, Length)).

multiple(Pattern, Length) ->
	lists:filter(fun (A) -> length(A) =:= Length end, Pattern).

wires(Pattern) ->
	[N3] = [ A || A <- multiple(Pattern, 5), length(lists:subtract(A, one(Pattern, 2))) =:= 3 ],
	X = [ N || N <- multiple(Pattern, 5), N =/= N3 ],
	[N5] = [ N || N <- X, length(lists:subtract(N, one(Pattern, 4))) =:= 2 ],
	[N2] = X -- [N5],

	[N9] = [ A || A <- multiple(Pattern, 6), length(lists:subtract(A, N3)) =:= 1 ],
	Y = [ A || A <- multiple(Pattern, 6), A =/= N9 ],
	[N0] = [ A || A <- Y, length(lists:subtract(A, one(Pattern, 2))) =:= 4 ],
	[N6] = Y -- [N0],

	#{
		N0 => 0,
		N2 => 2,
		N3 => 3,
		N5 => 5,
		N6 => 6,
		N9 => 9
	}.

second(Input) ->
	lists:foldl(fun(Line, Acc) ->
		Split = re:split(Line, " ", [{return, list}]),
		{Pattern, [_ | Values]} = lists:split(10, Split),

		Wires = wires(Pattern),
%		io:format("combinaties: ~p\n", [Wires]),

%		io:format("values: ~p\n", [Values]),
		[A, B, C, D] = Values,
		Sum = (1000 * val(A, Wires))
			+ (100 * val(B, Wires))
			+ (10 * val(C, Wires))
			+ val(D, Wires),

%		io:format("som: ~p\n", [Sum]),

		Acc + Sum
	end, 0, Input).



first(Input) ->
	% dit is een lange, aha
	% ik wou dit een one liner houden, laat me ff
	length(lists:flatten([[[Num || Num <- re:split(Line, " "), lists:member(size(Num), [2, 3, 4, 7]) ] || Line <- [lists:nth(3,re:split(A, "( \\| )"))]] || A <- Input])).
