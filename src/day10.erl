-module(day10).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

opposite(C) ->
	case C of
		41 -> 40;
		93 -> 91;
		125 -> 123;
		62 -> 60
	end.

score(C) ->
	case C of
		41 -> 3;
		93 -> 57;
		125 -> 1197;
		62 -> 25137
	end.

illegal([], _) ->
	0;

illegal([C | R], M) ->
	case C of
		40 -> illegal(R, [C | M]);
		91 -> illegal(R, [C | M]);
		123 -> illegal(R, [C | M]);
		60 -> illegal(R, [C | M]);
		_ ->
			[L | N] = M,
			case opposite(C) of
				L -> illegal(R, N);
				_ ->
					score(C)
			end
	end.

first(Input) ->
	lists:sum([illegal(Line, []) || Line <- Input]).

middle(L) ->
	Sort = lists:sort(L),
	lists:nth((length(Sort) div 2) + 1, Sort).

score2(C, Acc) ->
	A = case C of
		41 -> 1;
		93 -> 2;
		125 -> 3;
		62 -> 4
	end,
	(Acc * 5) + A.

complete([], A) ->
	lists:foldl(fun score2/2, 0, A);

complete([C | R], M) ->
	case C of
		40 -> complete(R, [41 | M]);
		91 -> complete(R, [93 | M]);
		123 -> complete(R, [125 | M]);
		60 -> complete(R, [62 | M]);
		A -> complete(R, lists:delete(A, M))
	end.

second(Input) ->
	trunc(middle([complete(Line, []) || Line <- Input, illegal(Line, []) =:= 0])).
