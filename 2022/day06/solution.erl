-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

generic([_A | T] = Cur, Size, Cnt) ->
	Elem = string:slice(Cur, 0, Size),
	Elems = length(Elem),

	case length(lists:uniq(Elem)) of
		Elems ->
			Cnt+Size;
		_ ->
			generic(T, Size, Cnt+1)
	end.

first([Input, _]) ->
	generic(Input, 4, 0).

second([Input, _]) ->
	generic(Input, 14, 0).
