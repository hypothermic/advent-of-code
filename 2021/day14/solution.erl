-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

inc(Val) -> Val + 1.

freqs(Poly) ->
	Z = [[lists:nth(X, Poly), lists:nth(X+1, Poly)] || X <- lists:seq(1, length(Poly) - 1)],

	lists:foldl(fun (E, Acc) -> maps:update_with(E, fun inc/1, 1, Acc) end, #{}, Z).

count(Freqs) ->
	maps:fold(fun(K, V, Acc) ->
		L = string:sub_string(K, 1, 1),
		case is_map_key(L, Acc) of
			true ->
				maps:put(L, maps:get(L, Acc) + V, Acc);
			false ->
				maps:put(L, V, Acc)
		end
	end, #{}, Freqs).

step(0, Freqs, _) ->
	Freqs;

step(Step, Freqs, Repls) ->
	NewFreqs = maps:fold(fun (K, V, Acc) ->
		case is_map_key(K, Repls) of
			true ->
				% lelijke code maar k
				A = maps:get(K, Repls),
				B =
					string:sub_string(K, 1, 1) ++
					string:sub_string(A, 1, 1) ++
					string:sub_string(K, 2, 2),
				N = maps:update_with(string:sub_string(B, 1, 2), fun inc/1, V+1, Acc),
				maps:update_with(string:sub_string(B, 2, 3), fun inc/1, V+1, N);
			false ->
				maps:update_with(K, fun inc/1, 1, Acc)
		end
	end, #{}, Freqs),
	step(Step - 1, NewFreqs, Repls).

solve(Steps, Input) ->
	[Poly | Rest] = Input,

	Repls = lists:foldl(fun (E, Acc) ->
		[P, R] = string:tokens(E, " -> "),
		maps:put(P, R, Acc)
						end, #{}, Rest),

	Freqs = freqs(Poly),
	Count = count(step(Steps, Freqs, Repls)),
	Values = maps:values(Count),

	lists:max(Values) - lists:min(Values).

first(Input) ->
	solve(10, Input).

second(Input) ->
	solve(40, Input).