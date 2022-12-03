-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

common(S1, S2, Idx) ->
	V = string:slice(S1, Idx, 1),

	case string:find(S2, V) of
		nomatch -> common(S1, S2, Idx+1);
		_ -> V
	end.

val([C]) when C > 96 ->
	C - 96;
val([C]) ->
	C - 64 + 26.

iter([], Sum) ->
	Sum;
iter([""], Sum) ->
	Sum;

iter([Ln|T], Sum) ->
	L = round(length(Ln)/2),
	S1 = string:slice(Ln, 0, L),
	S2 = string:slice(Ln, L),

	C = common(S1, S2, 0),
	V = val(C),

	iter(T, Sum+V).

first(Input) ->
	iter(Input, 0).


common3d(S1, S2, S3, Idx) ->
	V = string:slice(S1, Idx, 1),

	case string:find(S2, V) of
		nomatch -> common3d(S1, S2, S3, Idx+1);
		_ ->
			case string:find(S3, V) of
				nomatch -> common3d(S1, S2, S3, Idx+1);
				_ -> V
			end
	end.

i2([L1, L2, L3 | T], Sum) ->
	C = common3d(L1, L2, L3, 0),
	V = val(C),

	i2(T, Sum+V);

i2(_, Sum) ->
	Sum.

second(Input) ->
	i2(Input, 0).
