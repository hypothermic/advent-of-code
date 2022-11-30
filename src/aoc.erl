-module(aoc).
-author("hypothermic").

-export([
    main/1
]).

parse_args([], Settings) ->
    Settings;

parse_args(["day", DayStr | Tail], {Mode, Year, _}) ->
    parse_args(Tail, {Mode, Year, list_to_integer(DayStr)});

parse_args(["year", YearStr | Tail], {Mode, _, Day}) ->
    parse_args(Tail, {Mode, list_to_integer(YearStr), Day});

parse_args(["mode", ModeStr | Tail], {_, Day, Year}) ->
    Mode = case ModeStr of
        "data" -> data;
        "sample" -> sample;
        _ -> error("Wrong input mode: ~s", [ModeStr])
    end,
    parse_args(Tail, {Mode, Day, Year});

parse_args([_ | Tail], Settings) ->
    parse_args(Tail, Settings).


%% escript Entry point
main(Args) ->
    Settings = parse_args(Args, {data, all, all}),

    ok = run:do_years(Settings),

    erlang:halt(0).
