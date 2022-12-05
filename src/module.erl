-module(module).
-author("hypothermic").

-export([
	exec_day/1
]).

-define(COMPILER_OPTS, [
	strong_validation,
	warnings_as_errors,
	report_errors,
	{error_location, column},
	verbose
]).

exec_day({Mode, Year, Day}) ->
	Path = path_to_day_folder(Year, Day),
	ErlPath = list_to_atom(path_to_day_code(Path)),

	ok = case compile:file(ErlPath, ?COMPILER_OPTS) of
		{error, _, _} ->
			error("Compilation errors exist"),
			ok;
		_ ->
			ok
	end,

	% This is a big mess and should probably be separated into functions
	ok = case compile:file(ErlPath, [binary]) of
		{ok, ModuleName, Bin} ->
			case code:load_binary(ModuleName, ok, Bin) of
				{module, Module} ->
					InputPath = case Mode of
						data -> fetch_day_input(Path, Year, Day);
						sample -> path_to_day_sample(Path)
					end,

					{ok, Data} = file:read_file(InputPath),

					Input = lists:filtermap(fun (Binary) ->
						case byte_size(Binary) of
							%0 -> false; % 2022-day1 is formatted with newlines :(
							_ -> {true, binary_to_list(Binary)}
						end
					end, binary:split(Data, [<<"\n">>], [global])),

					First = Module:first(Input),
					Second = Module:second(Input),

					io:format("Day ~B part 1 answer: ~p, part 2 answer: ~p\n", [
						Day, First, Second
					]),

					file:write_file(path_to_day_output(Path),
						ensure_list(First) ++ "\n" ++ ensure_list(Second));
				{error, Reason} ->
					io:format("Error: ~w", [Reason]),
					error
			end;
		_ ->
			ok
	end.

fetch_day_input(Folder, Year, Day) ->
	Result = path_to_day_input(Folder),
	{ok, SessionCookie} = file:read_file(".session"),

	case filelib:is_regular(Result) of
		false ->
			ssl:start(),
			inets:start(),
			httpc:set_options([
				{socket_opts, [
					{verify, verify_peer},
					{cacerts, public_key:cacerts_get()}
				]}]),
			{ok, {{_, 200, _}, _, Body}} =
				httpc:request(get, {challenge_url(Year, Day), [
					{"Cookie", "session=" ++ binary_to_list(SessionCookie)}
				]}, [], []),
			file:write_file(Result, Body),
			inets:stop(),
			ssl:stop(),
			Result;
		_ ->
			Result
	end.

ensure_list(A) when is_integer(A) ->
	integer_to_list(A);

ensure_list(A) ->
	A.

challenge_url(Year, Day) ->
	"https://adventofcode.com/" ++ integer_to_list(Year)
					 ++ "/day/" ++ integer_to_list(Day) ++ "/input".

path_to_day_folder(Year, Day) ->
	integer_to_list(Year) ++ "/day" ++ string:right(integer_to_list(Day), 2, $0).

path_to_day_code(Folder) -> Folder ++ "/solution.erl".

path_to_day_sample(Folder) -> Folder ++ "/sample.txt".

path_to_day_input(Folder) -> Folder ++ "/input.txt".

path_to_day_output(Folder) -> Folder ++ "/output.txt".
