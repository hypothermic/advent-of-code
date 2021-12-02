-module(day1).
-author("hypothermic").

-define(INFINITE, math:pow(10,10)).

%% API
-export([
	first/1,
	second/1
]).

iterate(Current, {Prev, Count}) when Current < Prev ->
	{Current, Count};

iterate(Current, {_Prev, Count}) ->
	{Current, Count + 1}.

first(Input) ->
	{_, Count} = lists:foldl(fun (Current, AccIn) ->
		iterate(Current, AccIn)
	end, {?INFINITE, 0}, lists:map(fun(A) -> list_to_integer(A) end, Input)),

	Count.

slide(Amount, [Current, Next, Then | Rest], Prev, Count) when Amount > 0, (Current + Next + Then) > Prev ->
	slide(Amount-1, [Next, Then] ++ Rest, (Current + Next + Then), Count+1);

slide(Amount, [Current, Next, Then | Rest], _Prev, Count) when Amount > 0 ->
	slide(Amount-1, [Next, Then] ++ Rest, Current, Count);

slide(_, _, _, Count) ->
	Count.

second(Input) ->
	slide(length(lists:map(fun(A) -> list_to_integer(A) end, Input))-2, Input, ?INFINITE, 0).