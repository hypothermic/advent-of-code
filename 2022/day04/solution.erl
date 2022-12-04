-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

range(L1, U1, L2, U2) when L1 >= L2, U1 =< U2 ->
	true;
range(L1, U1, L2, U2) when L2 >= L1, U2 =< U1 ->
	true;
range(_, _, _, _) ->
	false.

%overlap(L1, U1, L2, U2) when L1 >= U2, L2 =< U1 ->
%	true;
overlap(L1, U1, L2, U2) when L1 =< U2, L1 =< U1, L2 =< U1, L2 =< U2 ->
	true;
overlap(_, _, _, _) ->
	false.

iter([], Sum, _CmpFun) ->
	Sum;

iter([""], Sum, _CmpFun) ->
	Sum;

iter([Ln|T], Sum, CmpFun) ->
	[L1, U1, L2, U2] = lists:map(fun list_to_integer/1, string:tokens(Ln, "-,")),

	Add = case CmpFun(L1, U1, L2, U2) of
		true -> 1;
		false -> 0
	end,

	iter(T, Sum+Add, CmpFun).

first(Input) ->
	iter(Input, 0, fun range/4).

second(Input) ->
	iter(Input, 0, fun overlap/4).
