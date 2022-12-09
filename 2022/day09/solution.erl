-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

move(l, {X, Y}) ->
	{X-1, Y};
move(r, {X, Y}) ->
	{X+1, Y};
move(u, {X, Y}) ->
	{X, Y-1};
move(d, {X, Y}) ->
	{X, Y+1}.

% hz/v
follow({HX, HY}, {TX, HY}) when HX =:= TX+2 ->
	{TX+1, HY};
follow({HX, HY}, {TX, HY}) when HX =:= TX-2 ->
	{TX-1, HY};
follow({HX, HY}, {HX, TY}) when HY =:= TY+2 ->
	{HX, TY+1};
follow({HX, HY}, {HX, TY}) when HY =:= TY-2 ->
	{HX, TY-1};
% diag
follow({HX, HY}, {TX, TY}) when HY =:= TY+2, HX =:= TX+1 ->
	{TX+1, TY+1};
follow({HX, HY}, {TX, TY}) when HY =:= TY+2, HX =:= TX-1 ->
	{TX-1, TY+1};
follow({HX, HY}, {TX, TY}) when HY =:= TY-2, HX =:= TX+1 ->
	{TX+1, TY-1};
follow({HX, HY}, {TX, TY}) when HY =:= TY-2, HX =:= TX-1 ->
	{TX-1, TY-1};
follow({HX, HY}, {TX, TY}) when HY =:= TY+1, HX =:= TX+2 ->
	{TX+1, TY+1};
follow({HX, HY}, {TX, TY}) when HY =:= TY-1, HX =:= TX+2 ->
	{TX+1, TY-1};
follow({HX, HY}, {TX, TY}) when HY =:= TY+1, HX =:= TX-2 ->
	{TX-1, TY+1};
follow({HX, HY}, {TX, TY}) when HY =:= TY-1, HX =:= TX-2 ->
	{TX-1, TY-1};
follow(_H, T) ->
	T.

step([], {HX, HY}, {TX, TY}, Res) ->
	Res;
step([{_, 0} | A], {HX, HY}, {TX, TY} = T, Res) ->
	step(A, {HX, HY}, {TX, TY}, [T] ++ Res);
step([{Dir, Amt} | A], {HX, HY} = H, {TX, TY} = T, Res) ->
	NewH = move(Dir, H),
	NewT = follow(NewH, T),
	%io:format("step ~p (~B;~B), (~B,~B)~n", [Dir] ++ tuple_to_list(NewH) ++ tuple_to_list(NewT)),
	step([{Dir, Amt-1}] ++ A, NewH, NewT, [T] ++ Res).

wsplit(String) ->
	[Dir, Amt] = string:tokens(String, " "),
	{list_to_atom(string:lowercase(Dir)), list_to_integer(Amt)}.

first(Input) ->
	Steps = lists:map(fun wsplit/1, Input),
	%io:format("~p~n", [Steps]),
	length(lists:uniq(step(Steps, {0, 0}, {0, 0}, []))).


%% ---- part 2; rework to general solution


next(H, T) when T < H -> H-1;
next(H, T) -> H+1.

f2a(DX, DY, {HX, HY}, {TX, TY}) ->
	{
		if DX >= 2 -> next(HX, TX); true -> HX end,
		if DY >= 2 -> next(HY, TY); true -> HY end
	}.

follow2({HX, HY} = H, {TX, TY} = T) ->
	DX = abs(HX - TX),
	DY = abs(HY - TY),
	f2a(DX, DY, H, T).

mvtail([A, B | T], Res) ->
	mvtail([B] ++ T, Res ++ [follow2(A, B)]);
mvtail(_, Res) ->
	Res.

step2([], {HX, HY}, TT, Res, Len) ->
	Res;
step2([{_, 0} | A], {HX, HY}, TT, Res, Len) ->
	step2(A, {HX, HY}, TT, [lists:last(TT)] ++ Res, Len);
step2([{Dir, Amt} | A], {HX, HY} = H, [{TX, TY} = T | TT], Res, Len) ->
	NewH = move(Dir, H),
	NewT = follow2(NewH, T),
	NewTT = mvtail([NewT] ++ TT, []),
	%io:format("step ~p (~B;~B), (~B,~B)~n", [Dir] ++ tuple_to_list(NewH) ++ tuple_to_list(NewT)),
	step2([{Dir, Amt-1}] ++ A, NewH, [NewT] ++ NewTT, [lists:last(NewTT)] ++ Res, Len).

second(Input) ->
	Steps = lists:map(fun wsplit/1, Input),
	%io:format("~p~n", [Steps]),
	Len = 9,
	Tail = lists:map(fun (_) -> {0, 0} end, lists:seq(1, Len)),
	length(lists:uniq(step2(Steps, {0, 0}, Tail, [], Len))).
