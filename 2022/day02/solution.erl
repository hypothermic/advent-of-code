-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

shp("A") -> 1;
shp("B") -> 2;
shp("C") -> 3;
shp("X") -> 1;
shp("Y") -> 2;
shp("Z") -> 3.

rps(1, 2) ->
	6+2;
rps(2, 3) ->
	6+3;
rps(3, 1) ->
	6+1;
rps(C, C) ->
	3+C;
rps(_, C) ->
	C.

iter(["" | T], Score) ->
	iter(T, Score);

iter([Ln | T], Score) ->
	[They, Me] = string:split(Ln, " "),
	Th = shp(They),
	Mm = shp(Me),
	iter(T, Score+rps(Th, Mm));

iter([], Score) ->
	Score.

first(Input) ->
	iter(Input, 0).

p2(1, "X") -> 3;
p2(2, "X") -> 1;
p2(3, "X") -> 2;
p2(T, "Y") -> T+3;
p2(1, "Z") -> 6+2;
p2(2, "Z") -> 6+3;
p2(3, "Z") -> 6+1.

iter2(["" | T], Score) ->
	iter2(T, Score);

iter2([Ln | T], Score) ->
	[They, Res] = string:split(Ln, " "),
	Th = shp(They),
	iter2(T, Score+p2(Th, Res));

iter2([], Score) ->
	Score.

second(Input) ->
	iter2(Input, 0).
