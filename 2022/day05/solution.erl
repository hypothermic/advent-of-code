-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

mapfold(_K, V1, V2) when is_list(V2) ->
	lists:append(V2, V1);
mapfold(_K, V1, V2) ->
	[V1, V2].

read_crates(_, 0, Res) ->
	Res;

read_crates(Ln, Num, Res) ->
	Crate = string:slice(Ln, (Num*4)-3, 1),

	case Crate of
		" " ->
			read_crates(Ln, Num-1, Res);
		_ ->
			read_crates(Ln, Num-1, Res#{Num => Crate})
	end.

read_stacks(["" | T], _, Stacks) ->
	{ok, T, -1, Stacks};

read_stacks([Ln | T], _, _Stacks) ->
	{ok, Rem, Num, Stacks} = read_stacks(T, 0, _Stacks),

	case Num of
		-1 ->
			Amt = lists:max(lists:map(fun list_to_integer/1, string:tokens(Ln, " "))),
			%io:format("Amount of crates: ~B~n", [Amt]),
			{ok, Rem, Amt, Stacks};
		_ ->
			Crates = read_crates(Ln, Num, #{}),
			S2 = maps:merge_with(fun mapfold/3, Crates, Stacks),
			{ok, Rem, Num, S2}
	end.

find_top_crates(Stacks) ->
	maps:fold(
		fun (_K, V, AccIn) ->
			AccIn ++ string:slice(string:reverse(V), 0, 1)
		end, "", Stacks).

move_crates([], Stacks, _MoveFunc) ->
	Stacks;
move_crates([""], Stacks, _MoveFunc) ->
	Stacks;

move_crates([Ln|T], Stacks, MoveFunc) ->
	[Amt, Src, Dest] = lists:map(fun list_to_integer/1, string:tokens(Ln, "movefrt ")),
	%io:format("From ~B to ~B, ~B crates~n", [Src, Dest, Amt]),

	SrcPrev = maps:get(Src, Stacks),
	SrcPrevLen = string:length(SrcPrev),
	ToKeep = string:slice(SrcPrev, 0, SrcPrevLen - Amt),
	ToMove = string:slice(SrcPrev, SrcPrevLen - Amt),
	%io:format("Split ~p into ~p and ~p~n", [SrcPrev, ToKeep, ToMove]),

	Result = maps:update_with(Dest,
		fun (V) ->
			V ++ MoveFunc(ToMove)
		end, Stacks#{Src => ToKeep}),

	move_crates(T, Result, MoveFunc).

solve(Input, CrateMoveFunc) ->
	{ok, Rem, _Num, Stacks} = read_stacks(Input, 0, #{}),

	Sorted = move_crates(Rem, Stacks, CrateMoveFunc),
	find_top_crates(Sorted).

move_func_reverse(Crates) ->
	string:reverse(Crates).

move_func_normal(Crates) ->
	Crates.

first(Input) ->
	solve(Input, fun move_func_reverse/1).

second(Input) ->
	solve(Input, fun move_func_normal/1).
