-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

c([L | LT], [R | RT]) when is_integer(L), is_integer(R) ->
	if
		L < R ->
			true;
		L > R ->
			false;
		true ->
			c(LT, RT)
	end;
c([L | LT], [R | RT]) when is_list(L), is_list(R) ->
	case c(L, R) of
		ok ->
			c(LT, RT);
		A ->
			A
	end;

c([L | LT], [R | _] = RA) when is_integer(L), is_list(R) ->
	c([[L]] ++ LT, RA);
c([L | _] = LA, [R | RT]) when is_list(L), is_integer(R) ->
	c(LA, [[R]] ++ RT);

c([], [_|_]) ->
	true;
c([_|_], []) ->
	false;
c([], []) ->
	ok.

eval(A) ->
	{ok, Scan, _} = erl_scan:string(A ++ "."),
	{ok, Expr} = erl_parse:parse_exprs(Scan),
	{value, List, _} = erl_eval:exprs(Expr, []),
	List.

ln([], _Idx, Res) ->
	Res;
ln([Left, Right, "" | A], Idx, Res) ->
	ln(A, Idx+1, case c(eval(Left), eval(Right)) of
		true -> Res++[Idx];
		_ -> Res
	end).

ln2([], _Idx, Res) ->
	Res;
ln2([Left, Right, "" | A], Idx, Res) ->
	ln2(A, Idx+1, Res ++ [eval(Left), eval(Right)]).

find([L | _], I, Val) when L =:= Val ->
	I;
find([_ | LT], I, Val) ->
	find(LT, I+1, Val).

first(Input) ->
	lists:sum(ln(Input, 1, [])).

second(Input) ->
	D1 = [[2]],
	D2 = [[6]],
	Sorted = lists:sort(fun c/2, ln2(Input, 1, []) ++ [D1] ++ [D2]),
	find(Sorted, 1, D1) * find(Sorted, 1, D2).
