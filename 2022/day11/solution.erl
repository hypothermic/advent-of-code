-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

-record(monkey, {
	items :: list(),
	opsign :: string(),
	operand :: string(),
	test :: integer(),
	true :: integer(),
	false :: integer(),
	inspect :: integer()
}).

parse([], Monkeys) ->
	Monkeys;
parse([[] | A], Monkeys) ->
	parse(A, Monkeys);
parse([[$M, $o, $n, $k, $e, $y, _, Num, $:], L1, L2, L3, L4, L5 | A], Monkeys) ->
	Items = lists:map(fun list_to_integer/1, string:tokens(string:slice(L1, 18), ", ")),
	Opsign = string:slice(L2, 23, 1),
	Operand = string:slice(L2, 25),
	Test = list_to_integer(string:slice(L3, 21)),
	True = list_to_integer(string:slice(L4, 29)),
	False = list_to_integer(string:slice(L5, 30)),

	Monkey = #monkey{
		items = Items,
		opsign = Opsign,
		operand = Operand,
		test = Test,
		true = True,
		false = False,
		inspect = 0
	},

	parse(A, Monkeys#{Num-48 => Monkey}).

op(Val, "*", "old") ->
	Val*Val;
op(Val, "*", A) ->
	Val*list_to_integer(A);
op(Val, "+", "old") ->
	Val+Val;
op(Val, "+", A) ->
	Val+list_to_integer(A).

iter_item([], _Monkey, Monkeys, _WorryFun) ->
	Monkeys;
iter_item([Item | A], Monkey, Monkeys, WorryFun) ->
	NewVal = WorryFun(op(Item, Monkey#monkey.opsign, Monkey#monkey.operand)),

	Recipient = case NewVal rem Monkey#monkey.test of
		0 ->
			Monkey#monkey.true;
		_ ->
			Monkey#monkey.false
	end,

	%io:format("Inspect item: ~B~nDecrease to: ~B~nThrow to ~B~n", [Item, NewVal, Recipient]),

	Recip = maps:get(Recipient, Monkeys),
	RecipItems = Recip#monkey.items,
	NewRecip = Recip#monkey{items = RecipItems ++ [NewVal]},
	NewMonkeys = Monkeys#{Recipient => NewRecip},

	iter_item(A, Monkey, NewMonkeys, WorryFun).

iter_monkey(Max, Max, Monkeys, _WorryFun) ->
	Monkeys;
iter_monkey(Num, Max, Monkeys, WorryFun) ->
	Monkey = maps:get(Num, Monkeys),

	Items = Monkey#monkey.items,
	Inspect = Monkey#monkey.inspect,
	NewMonkey = Monkey#monkey{items = [], inspect = Inspect+length(Items)},
	NewMonkeys = Monkeys#{Num => NewMonkey},

	iter_monkey(Num+1, Max, iter_item(Items, NewMonkey, NewMonkeys, WorryFun), WorryFun).

iter_round(0, Monkeys, _WorryFun) ->
	Monkeys;
iter_round(Rounds, Monkeys, WorryFun) ->
	%io:format("Rounds left: ~p~n", [Rounds]),
	iter_round(Rounds-1, iter_monkey(0, lists:max(maps:keys(Monkeys))+1, Monkeys, WorryFun), WorryFun).

solve(Input, Rounds, WorryFun) ->
	Monkeys = parse(Input, #{}),

	State = iter_round(Rounds, Monkeys, WorryFun),

	Inspects = maps:fold(fun (_, Monkey, AccIn) ->
		[Monkey#monkey.inspect] ++ AccIn
	end, [], State),

	lists:foldl(fun (A, Acc) -> A*Acc end, 1, lists:sublist(lists:reverse(lists:sort(Inspects)), 1, 2)).

first(Input) ->
	solve(Input, 20, fun (A) -> floor(A / 3) end).

second(Input) ->
	% takes a while to complete, lol
	solve(Input, 10000, fun (A) -> A end).
