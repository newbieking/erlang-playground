%%%-------------------------------------------------------------------
%%% @author Test
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 5月 2025 10:55
%%%-------------------------------------------------------------------
-module(func).
-author("Test").

%% API
-compile(nowarn_export_all).
-compile(export_all).

%% 获取列表长度
len([]) ->
  0;
len([_ | Rest]) ->
  len(Rest) + 1.

test_len() ->
  io:format("~p~n", [len([1, 2, 3, 4])]),
  io:format("~p~n", [len([])]).

%% 获取列表长度 尾递归
len_tail(List) ->
  len_tail(List, 0).
len_tail([], Acc) ->
  Acc;
len_tail([_ | Rest], Acc) ->
  len_tail(Rest, Acc + 1).

test_len_tail() ->
  io:format("~p~n", [len_tail([1, 2, 3, 4])]),
  io:format("~p~n", [len_tail([])]).

%% 列表求和
sum(List) ->
  sum(List, 0).
sum([X | Tail], Acc) ->
  sum(Tail, Acc + X);
sum([], Acc) ->
  Acc.

test_sum() ->
  io:format("~p~n", [sum([1, 2, 3, 4])]),
  io:format("~p~n", [sum([])]).

%% 函数映射
map(Func, List) ->
  map(Func, List, []).
map(Func, [X | Tail], Acc) ->
  map(Func, Tail, [Func(X) | Acc]);
map(_, [], Acc) ->
  lists:reverse(Acc).

test_map() ->
  FunIt = fun(It) -> It * 2 end,
  io:format("~p~n", [map(FunIt, [1, 2, 3, 4])]),
  io:format("~p~n", [map(FunIt, [])]).

%% 过滤函数
filter(Pred, List) -> filter(Pred, List, []).
filter(Pred, [X | Tail], Acc) ->
  case Pred(X) of
    true -> filter(Pred, Tail, [X | Acc]);
    false -> filter(Pred, Tail, Acc)
  end;
filter(_, [], Acc) ->
  lists:reverse(Acc).

test_filter() ->
  FunIt = fun(It) -> It rem 2 /= 0 end,
  io:format("~p~n", [filter(FunIt, [1, 2, 3, 4])]),
  io:format("~p~n", [filter(FunIt, [])]).

%% 不可变栈
stack_new() -> [].
stack_push(Element, Stack) -> [Element | Stack].
stack_pop([Val | Tail]) -> {Val, Tail};
stack_pop([]) -> {nil, []}.
stack_peek([Head | _]) -> Head;
stack_peek([]) -> nil.

test_stack() ->
  Stack = stack_new(),
  Stack1 = stack_push(1, Stack),
  Stack2 = stack_push(2, Stack1),
  Stack3 = stack_push(3, Stack2),
  io:format("~p~n", [stack_peek(Stack3)]),
  {Val, Stack4} = stack_pop(Stack3),
  io:format("element popped up: ~p~n", [Val]),
  io:format("~p~n", [stack_peek(Stack4)]).

%%二叉树遍历
%%{node, Value, Left, Right} | empty
%%先序遍历
preorder({node, Value, Left, Right}) ->
  [Value] ++ preorder(Left) ++ preorder(Right);
preorder(empty) ->
  [].
%% 中序遍历
inorder({node, Value, Left, Right}) ->
  inorder(Left) ++ [Value] ++ inorder(Right);
inorder(empty) ->
  [].

%%后序遍历
postorder({node, Value, Left, Right}) ->
  postorder(Left) ++ postorder(Right) ++ [Value];
postorder(empty) ->
  [].

%%      1
%%   2    3
%% 4  5  6
%% 前序遍历 1 2 4 5 3 6
%% 中序遍历 4 2 5 1 6 3
%% 后序遍历 4 5 2 6 3 1
test_preorder() ->
  Tree = {node, 1,
    {node, 2, {node, 4, empty, empty}, {node, 5, empty, empty}},
    {node, 3, {node, 6, empty, empty}, empty}
  },
  io:format("~p~n", [preorder(Tree)]),
  io:format("~p~n", [inorder(Tree)]),
  io:format("~p~n", [postorder(Tree)]).


%%斐波那契数列
fib(N) -> fib(N, 0, 1).
fib(1, _, B) -> B;
fib(N, A, B) -> fib(N - 1, B, A + B).


test_fib() ->
  io:format("~p~n", [fib(1)]),
  io:format("~p~n", [fib(2)]),
  io:format("~p~n", [fib(3)]),
  io:format("~p~n", [fib(4)]),
  io:format("~p~n", [fib(5)]),
  io:format("~p~n", [fib(6)]).


%%阶乘
fact(N) -> fact(N, 1).
fact(0, Acc) ->
  Acc * 1;
fact(N, Acc) ->
  fact(N - 1, Acc * N).


test_fact() ->
  io:format("~p~n", [fact(0)]),
  io:format("~p~n", [fact(1)]),
  io:format("~p~n", [fact(2)]),
  io:format("~p~n", [fact(10)]).


%% 生成集合的所有子集 (幂集)
%% [1,2,3,4]
%% [[], [1], [2], [3], [4], [1,2], [1,3], [1,4], [2,3], [2,4], [3,4], ]
%% 1 [[], [2], [3], [4], [2,3], [2,4], [3,4], [2,3,4]]
powerset([Head | Tail]) ->
  SubPowerSet = powerset(Tail),
  SubPowerSet ++ [[Head | S] || S <- SubPowerSet];
powerset([]) ->
  [[]].

test_powerset() ->
  io:format("~p~n", [powerset([1, 2, 3, 4])]),
  io:format("~p~n", [powerset([])]).

%%管道操作
pipe(Value, [Op]) ->
  Op(Value);
pipe(Value, [Op | Ops]) ->
  pipe(Op(Value), Ops).


test_pipe()
  ->
  io:format("~p~n", [pipe([1, 2, 3, 4], [fun powerset/1, fun len_tail/1, fun(It) -> It * 2 end])]).

%%foldl
foldl(_, Acc, []) -> Acc;
foldl(Func, Acc, [Head | Tail]) ->
  foldl(Func, Func(Acc, Head), Tail).

test_foldl() ->
  io:format("~p~n", [foldl(fun(Acc, It) -> Acc rem It + It end, 1, [1, 2, 3, 4])]).


%%foldr
foldr(_, Acc, []) -> Acc;
foldr(Func, Acc, [Head | Tail]) ->
  Func(Head, foldr(Func, Acc, Tail)).

test_foldr() ->
  io:format("~p~n", [foldr(fun(Acc, It) -> Acc rem It + It end, 1, [1, 2, 3, 4])]).


%% monad
%%-type the_maybe(A) :: {just, A} | nothing.
bind(nothing, _) -> nothing;
bind({just, A}, Func) ->
  Func(A).

safe_div(_, 0) -> nothing;
safe_div(A, B) -> {just, A / B}.

test_maybe() ->
  Result = bind(safe_div(10, 2), fun(X) -> safe_div(X, 5) end),
  io:format("~p~n", [Result]).


%%并行map

pmap(Func, List)->
  Parent = self(),
  Pids = [spawn(fun()-> Parent ! {self(), Func(X)} end) || X <- List],
  [ receive
      {_, Result} -> Result
    after 500 ->
      timeout
    end || _ <- Pids].


test_pmap()->
  io:format("task start~n"),
  io:format("~p~n", [pmap(fun(It)-> timer:sleep(1000), It * It end, [1,2,3,4])]).













