-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

cal([], _Cur, Prev) ->
	Prev;

cal([""|T], Cur, Prev) ->
	if
		Cur > Prev ->
			cal(T, 0, Cur);
		true ->
			cal(T, 0, Prev)
	end;

cal([Ln|T], Cur, Prev) ->
	cal(T, Cur+list_to_integer(Ln), Prev).

first(Input) ->
	cal(Input, 0, 0).

calt([], _Cur, All) ->
	All;

calt([""|T], Cur, All) ->
	calt(T, 0, All ++ [Cur]);

calt([Ln|T], Cur, All) ->
	calt(T, Cur+list_to_integer(Ln), All).

second(Input) ->
	lists:sum(
		lists:sublist(
			lists:reverse(
				lists:sort(
					calt(Input, 0, [])
				)
			), 1, 3
		)
	).
