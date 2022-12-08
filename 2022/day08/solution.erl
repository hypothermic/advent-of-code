-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

trace(CX, _, EX, _EY, _Val, _Grid, left) when CX > EX ->
	true;
trace(CX, _, EX, EY, Val, Grid, left) ->
	Row = array:get(EY, Grid),
	Prev = array:get(CX-1, Row),
	if
		Val > Prev -> trace(CX+1, 0, EX, EY, Val, Grid, left);
		true -> false
	end;
trace(CX, _, EX, _EY, _Val, _Grid, right) when CX < EX ->
	true;
trace(CX, _, EX, EY, Val, Grid, right) ->
	Row = array:get(EY, Grid),
	Prev = array:get(CX+1, Row),
	if
		Val > Prev -> trace(CX-1, 0, EX, EY, Val, Grid, right);
		true -> false
	end;
trace(_, CY, _EX, EY, _Val, _Grid, down) when CY > EY ->
	true;
trace(_, CY, EX, EY, Val, Grid, down) ->
	Prev = array:get(EX, array:get(CY-1, Grid)),
	if
		Val > Prev -> trace(0, CY+1, EX, EY, Val, Grid, down);
		true -> false
	end;
trace(_, CY, _EX, EY, _Val, _Grid, up) when CY < EY ->
	true;
trace(_, CY, EX, EY, Val, Grid, up) ->
	Prev = array:get(EX, array:get(CY+1, Grid)),
	if
		Val > Prev -> trace(0, CY-1, EX, EY, Val, Grid, up);
		true -> false
	end.

visible(X, Y, Val, Size, Grid, Count) ->
	%io:format("Scanning ~B;~B ~B~n", [X, Y, Val]),
	FromStart = [trace(1, 1, X, Y, Val, Grid, Dir) || Dir <- [left, down]],
	FromEnd = [trace(Size-2, Size-2, X, Y, Val, Grid, Dir) || Dir <- [right, up]],

	case lists:any(fun (A) -> A end, FromStart ++ FromEnd) of
		true -> Count+1;
		false -> Count
	end.

dist(0, _, _EX, _EY, _Val, _Grid, _Size, Count, left) ->
	Count;
dist(EX, _, EX, EY, Val, Grid, Size, Count, left) ->
	dist(EX-1, 0, EX, EY, Val, Grid, Size, Count, left);
dist(CX, _, EX, EY, Val, Grid, Size, Count, left) ->
	Row = array:get(EY, Grid),
	Cur = array:get(CX, Row),
	if
		Val > Cur -> dist(CX-1, 0, EX, EY, Val, Grid, Size, Count+1, left);
		true -> Count
	end;
dist(CX, _, _EX, _EY, _Val, _Grid, Size, Count, right) when CX =:= Size-1 ->
	Count;
dist(EX, _, EX, EY, Val, Grid, Size, Count, right) ->
	dist(EX+1, 0, EX, EY, Val, Grid, Size, Count, right);
dist(CX, _, EX, EY, Val, Grid, Size, Count, right) ->
	Row = array:get(EY, Grid),
	Cur = array:get(CX, Row),
	if
		Val > Cur -> dist(CX+1, 0, EX, EY, Val, Grid, Size, Count+1, right);
		true -> Count
	end;

dist(_, 0, _EX, _EY, _Val, _Grid, _Size, Count, up) ->
	Count;
dist(_, EY, EX, EY, Val, Grid, Size, Count, up) ->
	dist(0, EY-1, EX, EY, Val, Grid, Size, Count, up);
dist(_, CY, EX, EY, Val, Grid, Size, Count, up) ->
	Cur = array:get(EX, array:get(CY, Grid)),
	if
		Val > Cur -> dist(0, CY-1, EX, EY, Val, Grid, Size, Count+1, up);
		true -> Count
	end;
dist(_, CY, _EX, _EY, _Val, _Grid, Size, Count, down) when CY =:= Size-1 ->
	Count;
dist(_, EY, EX, EY, Val, Grid, Size, Count, down) ->
	dist(0, EY+1, EX, EY, Val, Grid, Size, Count, down);
dist(_, CY, EX, EY, Val, Grid, Size, Count, down) ->
	Cur = array:get(EX, array:get(CY, Grid)),
	if
		Val > Cur -> dist(0, CY+1, EX, EY, Val, Grid, Size, Count+1, down);
		true -> Count
	end.

scenic(X, Y, Val, Size, Grid, Count) ->
	Trace = [dist(X, Y, X, Y, Val, Grid, Size, 1, Dir) || Dir <- [left, right, up, down]],
	Score = lists:foldl(fun (A, AccIn) -> A * AccIn end, 1, Trace),
	%io:format("Scanned ~B;~B ~B, trace=~p, score=~B~n", [X, Y, Val, Trace, Score]),

	if
		Score > Count -> Score;
		true -> Count
	end.

pos(Grid, X, Y, Size, Count, Fun) when X =:= Size-1 ->
	pos(Grid, 1, Y+1, Size, Count, Fun);
pos(_Grid, _X, Y, Size, Count, _Fun) when Y =:= Size-1 ->
	Count;
pos(Grid, X, Y, Size, Count, Fun) ->
	Elem = array:get(X, array:get(Y, Grid)),
	NewCount = Fun(X, Y, Elem, Size, Grid, Count),
	pos(Grid, X+1, Y, Size, NewCount, Fun).

widen(String) ->
	array:from_list(lists:map(fun (A) -> A - 48 end, String)).

solve([Head | _] = Input, Fun, AddSize) ->
	Size = length(Head),
	Grid = array:from_list(lists:map(fun widen/1, Input)),
	pos(Grid, 1, 1, Size, case AddSize of true->4*Size-4; false->0 end, Fun).

first(Input) ->
	solve(Input, fun visible/6, true).

second(Input) ->
	solve(Input, fun scenic/6, false).
