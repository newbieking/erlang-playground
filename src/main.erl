%%%-------------------------------------------------------------------
%%% @author Test
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 5月 2025 17:05
%%%-------------------------------------------------------------------
-module(main).
-author("Test").

%% API
-compile(nowarn_export_all).
-compile(export_all).



greet(male, Name) ->
  io:format("Hello, Mr. ~s!", [Name]);
greet(female, Name) ->
  io:format("Hello, Mrs. ~s!", [Name]);
greet(_, Name) ->
  io:format("Hello, ~s!", [Name]).

printArr([X | Rest]) ->
  io:write(X),
  printArr(Rest);
printArr([]) ->
  1.

fab(1) ->
  1;
fab(2) ->
  1;
fab(Num) ->
  fab(Num - 1) + fab(Num - 2).


loop(1, Func) ->
  Func(1);
loop(Num, Func) ->
  Func(Num),
  loop(Num - 1, Func).


main() ->
  X = 5,
  io:write(X),
  greet(male, john),
  printArr([1, 2, 3]),
%%  io:write(fab(10)),
  io:format("~n"),
  loop(10, fun(Idx) ->
    io:format("~p ", [fab(Idx)]) end).
%%  io:format("~p", [foo()]).


%% 事件处理器注册与触发
-record(event_handler, {handlers = []}).

register_handler(Handler, State) ->
  State1 = State#event_handler{handlers = [Handler | State#event_handler.handlers]},
%%  io:format("~p~n", [State1#event_handler.handlers]),
  State1.

build_handler(State) ->
  State1 = State,
  State1#event_handler{handlers = lists:reverse(State#event_handler.handlers)}.

trigger_event(Event, State) ->
  [Handler(Event) || Handler <- State#event_handler.handlers],
  State.

foo() ->
  State0 = #event_handler{handlers = []},
  State1 = register_handler(fun(mockEvent) -> io:format("mockEvent handler...~n") end, State0),
  State2 = register_handler(fun(_) -> io:format("uncatchedEvent handler...~n") end, State1),
  State3 = build_handler(State2),
  io:format("~p~n", [State0#event_handler.handlers]),
  io:format("~p~n", [State1#event_handler.handlers]),
  io:format("~p~n", [State2#event_handler.handlers]),
  io:format("~p~n", [State3#event_handler.handlers]),
  trigger_event(mockEvent, State3).
