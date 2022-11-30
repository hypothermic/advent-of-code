-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

-record(board, {
	hz  :: list(list(integer()))
}).

parse_board_data(Rest, Y, Current, Out) when Y >= 5 ->
	parse_board_data(Rest, 0, #board{hz=[]}, [Current | Out]);

parse_board_data([Line | Rest], Y, #board{hz = OldHz}, Out) ->
	Words = lists:filtermap(fun (Word) ->
		case length(Word) of
			0 -> false;
			_ -> {true, list_to_integer(Word)}
		end
	end, string:tokens(Line, " ")),
	parse_board_data(Rest, Y+1, #board{hz = [Words] ++ OldHz}, Out);

parse_board_data([], _Y, _Current, Out) ->
	Out.

-spec parse_input(Input :: [string()]) -> {Draw :: [integer()], Boards ::[#board{}]}. % anders vergeet ik het aha
parse_input(Input) ->
	[Draw | Data] = Input,

	Nums = lists:map(fun list_to_integer/1, string:tokens(Draw, ",")),

	% TODO parse a2d
	Boards = parse_board_data(Data, 0, #board{hz=[]}, []),

	{Nums, Boards}.

is_solved_x(_Board, _Draw, Iter) when Iter >= 5 ->
	false;

is_solved_x(#board{hz=Hz} = Board, Draw, Iter) ->
	case lists:all(fun (Elem) -> lists:member(Elem, Draw) end, lists:nth(Iter+1, Hz)) of
		false -> is_solved_x(Board, Draw, Iter + 1);
		Res -> Res
	end.

is_solved_y(_Board, _Draw, Iter) when Iter >= 5 ->
	false;

is_solved_y(#board{hz=Hz} = Board, Draw, Iter) ->
	Res = lists:all(fun(Elem) ->
		lists:member(lists:nth(Iter+1, Elem), Draw)
	end, Hz),
	case Res of
		false -> is_solved_x(Board, Draw, Iter + 1);
		Res -> Res
	end.

is_solved(Board, Draw) ->
	is_solved_x(Board, Draw, 0) or is_solved_y(Board, Draw, 0).

% TODO do this with a recursive loop
score(#board{hz = [A, B, C, D, E]}, Draw) ->
	Ar = lists:foldl(fun (X, Y) ->
		case lists:member(X, Draw) of
			false -> Y + X;
			_ -> Y
		end
	end, 0, A),
	Br = lists:foldl(fun (X, Y) ->
		case lists:member(X, Draw) of
			false -> Y + X;
			_ -> Y
		end
	end, Ar, B),
	Cr = lists:foldl(fun (X, Y) ->
		case lists:member(X, Draw) of
			false -> Y + X;
			_ -> Y
		end
	end, Br, C),
	Dr = lists:foldl(fun (X, Y) ->
		case lists:member(X, Draw) of
			false -> Y + X;
			_ -> Y
		end
	end, Cr, D),
	lists:foldl(fun (X, Y) ->
		case lists:member(X, Draw) of
			false -> Y + X;
			_ -> Y
		end
	end, Dr, E).

find_first(Draw, Boards, Iter) ->
	Sub = lists:sublist(Draw, Iter),
	Filtermap = lists:search(fun (Board) ->
		is_solved(Board, Sub)
	end, Boards),
	case Filtermap of
		{value, Value} -> score(Value, Sub) * lists:last(Sub);
		false -> find_first(Draw, Boards, Iter + 1)
	end.

first(Input) ->
	{Draw, Boards} = parse_input(Input),

	find_first(Draw, Boards, 0).

find_last(Draw, Boards, Iter) ->
	Sub = lists:sublist(Draw, Iter),
	Remaining = lists:filter(fun (Board) ->

		not is_solved(Board, Sub)
	end, Boards),
	case length(Remaining) of
		0 ->
			score(lists:nth(1, Boards), Sub) * lists:nth(Iter, Draw);
		_ -> find_last(Draw, Remaining, Iter + 1)
	end.

second(Input) ->
	{Draw, Boards} = parse_input(Input),

	find_last(Draw, Boards, 0).