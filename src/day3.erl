-module(day3).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

filter(Input, Len, Pos, Val) ->
	lists:filter(fun (E) ->
		string:substr(E, (Len - Pos + 1), 1) == Val
	end, Input).

val(Input, Ones, Mode) when length(Ones) >= (length(Input) / 2) ->
	case Mode of
		gamma -> "1";
		eps -> "0"
	end;
val(_Input, _Ones, Mode) ->
	case Mode of
		gamma -> "0";
		eps -> "1"
	end.

iter(Input, Len, Pos, Mode, Out) when Pos > 0 ->
	Ones = filter(Input, Len, Pos, "1"),
	iter(Input, Len, Pos - 1, Mode, Out ++ val(Input, Ones, Mode));

iter(_Input, _Len, _Pos, _Mode, Out) ->
	list_to_integer(Out, 2).

first(Input) ->
	[First | _] = Input,
	Len = string:length(First),

	Gamma = iter(Input, Len, 12, gamma, []),
	Eps = iter(Input, Len, 12, eps, []),

	Gamma * Eps.

xf(Zeros, Ones, Mode) when length(Ones) >= length(Zeros) ->
	case Mode of
		ox -> Ones;
		co -> Zeros
	end;

xf(Zeros, Ones, Mode) ->
	case Mode of
		ox -> Zeros;
		co -> Ones
	end.

iter2(Input, Len, Pos, Mode) when length(Input) > 1 ->
	Ones = filter(Input, Len, Pos, "1"),
	Zeros = filter(Input, Len, Pos, "0"),
	NextDataSet = xf(Zeros, Ones, Mode),
	iter2(NextDataSet, Len, Pos - 1, Mode);

iter2([A], _Len, _Pos, _Mode) ->
	list_to_integer(A, 2).

second(Input) ->
	[First | _] = Input,
	Len = string:length(First),

	Ox = iter2(Input, Len, Len, ox),
	Co = iter2(Input, Len, Len, co),

	Ox * Co.