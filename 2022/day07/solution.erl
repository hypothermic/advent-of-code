-module(solution).
-author("hypothermic").

%% API
-export([
	first/1,
	second/1
]).

parse([], _Cd, Files) ->
	Files;
parse([[]], _Cd, Files) ->
	Files;
parse([["$", "cd", Dir] | A], _Cd, Files) ->
	parse(A, Dir, Files);
parse([["$", "ls"] | A], Cd, Files) ->
	parse(A, Cd, Files);
parse([["dir", Dir] | A], Cd, Files) ->
	parse(A, Cd, Files ++ [{dir, Cd, Dir}]);
parse([[Size, File] | A], Cd, Files) ->
	parse(A, Cd, Files ++ [{file, Cd, File, list_to_integer(Size)}]).

splitw(String) ->
	string:tokens(String, " ").

treeify(Cd, [{file, Cd, Name, Size} = File | A], Orig, Tree) ->
	%io:format("File in current dir~n"),
	Files = maps:get(Cd, Tree, []),
	treeify(Cd, A, Orig, Tree#{Cd => Files ++ [{Name, Size}]});
treeify(Cd, [{file, _, _, _} | A], Orig, Tree) ->
	treeify(Cd, A, Orig, Tree);
treeify(Cd, [{dir, Cd, Dir} | A], Orig, Tree) ->
	io:format("Recurse dir ~p~n", [Cd]),
	Recurse = treeify(Dir, Orig, Orig, #{}),
	Files = maps:get(Cd, Tree, []),
	treeify(Cd, A, Orig, Tree#{Cd => Files ++ [Recurse]});
treeify(Cd, [{dir, _, _} | A], Orig, Tree) ->
	%io:format("Dir ~p~n", [Cd]),
	treeify(Cd, A, Orig, Tree);
treeify(_Cd, [], _Orig, Tree) ->
	Tree.

dirs([], Total, Subdirs) ->
	{ok, Total, Subdirs};
dirs([A | T], Total, Subdirs) when is_map(A) ->
	{ok, Size, Newsub} = maps:fold(fun dirfold/3, {ok, 0, Subdirs}, A),
	dirs(T, Total+Size, Newsub);
dirs([{_, Size} | T], Total, Subdirs) ->
	dirs(T, Total+Size, Subdirs).

dirfold(Dir, Children, {ok, _, AccIn}) ->
	{ok, Total, Subdirs} = dirs(Children, 0, AccIn),
	{ok, Total, Subdirs#{Dir => Total}}.

solve(Input) ->
	Files = parse(lists:map(fun splitw/1, Input), "/", []),
	io:format("~p~n", [Files]),
	Tree = treeify("/", Files, Files, #{}),
	io:format("~p~n", [Tree]),

	maps:fold(fun dirfold/3, {ok, 0, #{}}, Tree).

first(Input) ->
	{ok, _, Dirs} = solve(Input),

	F = maps:filter(fun (_K, V) -> V < 100000 end, Dirs),
	maps:fold(fun (_K, V, Acc) -> V + Acc end, 0, F).

second(Input) ->
	{ok, RootSize, Dirs} = solve(Input),

	V = maps:values(Dirs),
	Req = 70000000 - RootSize,

	S = lists:sort(V),
	{value, Ans} = lists:search(fun(A) -> A > Req end, S),
	Ans.
