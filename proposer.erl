-module(proposer).
-export([start/6]).

-define(timeout, 2000).
-define(backoff, 10).

start(Name, Proposal, Acceptors, Sleep, PanelId, Main) ->
  spawn(fun() -> init(Name, Proposal, Acceptors, Sleep, PanelId, Main) end).

init(Name, Proposal, Acceptors, Sleep, PanelId, Main) ->
  timer:sleep(Sleep),
<<<<<<< HEAD
  % Start of the timer
  Begin = erlang:monotonic_time(),
  % Take as Round the first Name of the Proposer
  Round = order:first(Name),
  % Assign to Decision the Value and to LastRound the Round
  {Decision, LastRound} = round(Name, ?backoff, Round, Proposal, Acceptors, PanelId),
  % End of the timer
  End = erlang:monotonic_time(),
  % Calculate the time elapsed 
=======
  Begin = erlang:monotonic_time(),
  Round = order:first(Name),
  {Decision, LastRound} = round(Name, ?backoff, Round, Proposal, Acceptors, PanelId),
  End = erlang:monotonic_time(),
>>>>>>> 2286b6c (final code)
  Elapsed = erlang:convert_time_unit(End-Begin, native, millisecond),
  io:format("[Proposer ~w] DECIDED ~w in round ~w after ~w ms~n", 
             [Name, Decision, LastRound, Elapsed]),
  Main ! done,
  PanelId ! stop.

round(Name, Backoff, Round, Proposal, Acceptors, PanelId) ->
  io:format("[Proposer ~w] Phase 1: round ~w proposal ~w~n", 
             [Name, Round, Proposal]),
  % Update gui
  PanelId ! {updateProp, "Round: " ++ io_lib:format("~p", [Round]), Proposal},
<<<<<<< HEAD
  % We check if the ballot is accepted
  case ballot(Name, Round, Proposal, Acceptors, PanelId) of
    % If the return is ok, I will return the Value and the Round to the init()
    {ok, Value} ->
      {Value, Round};
    
    % If there are not enough answers, abort
    abort ->
      % Sleep for the time defined by Backoff
      timer:sleep(rand:uniform(Backoff)),
      % Select the next Round
      Next = order:inc(Round),
      % Recursion of round passing the double of backoff and the next round (Next) 
=======
  case ballot(Name, Round, Proposal, Acceptors, PanelId) of
    {ok, Value} ->
      {Value, Round};
    abort ->
      timer:sleep(rand:uniform(Backoff)),
      Next = order:inc(Round),
>>>>>>> 2286b6c (final code)
      round(Name, (2*Backoff), Next, Proposal, Acceptors, PanelId)
  end.

ballot(Name, Round, Proposal, Acceptors, PanelId) ->
<<<<<<< HEAD
  % Send a Round to the Acceptors
  prepare(Round, Acceptors),
  % Establish Quorum as the majority of the number of Acceptors
  Quorum = (length(Acceptors) div 2) + 1,
  % Initialize the MaxVoted as null value
  MaxVoted = order:null(),
  % Check the result of collect
  % Quorum is the minimum number of votes in order to accept the Proosal
  % Round define the sequence number that we want to check
  % MaxVoted is the max value voted so far by the Acceptors
  % Proposal is the colour to vote
  case collect(Quorum, Round, MaxVoted, Proposal) of
=======
  prepare(Round, Acceptors),
  Quorum = (length(Acceptors) div 2) + 1,
  MaxVoted = order:null(),
  case collect(Quorum, Round, MaxVoted, Proposal) of   % QUESTIONABLE
>>>>>>> 2286b6c (final code)
    {accepted, Value} ->
      io:format("[Proposer ~w] Phase 2: round ~w proposal ~w (was ~w)~n", 
                 [Name, Round, Value, Proposal]),
      % update gui
      PanelId ! {updateProp, "Round: " ++ io_lib:format("~p", [Round]), Value},
<<<<<<< HEAD
      % Sends the accept to the Acceptor and wait for the vote
      % NEW
      accept(Round, Value, Acceptors),
      % Pass the minimum number of vote (Quorum) that I need in order to accept the Proposal
      case vote(Quorum, Round) of
        ok ->
          % If the Proposal is accepted, I will return to the round()
          % NEW
=======
      accept(Round, Value, Acceptors),
      case vote(Quorum, Round) of
        ok ->
>>>>>>> 2286b6c (final code)
          {ok, Value};
        abort ->
          abort
      end;
    abort ->
      abort
  end.

collect(0, _, _, Proposal) ->
<<<<<<< HEAD
    {accepted, Proposal};
collect(N, Round, MaxVoted, Proposal) ->
    receive 
        {promise, Round, _, na} ->
            collect(N-1, Round, MaxVoted, Proposal);
        {promise, Round, Voted, Value} ->
            case order:gr(Voted, MaxVoted) of
                true ->
                    collect(N-1, Round, Voted, Value);
                false ->
                    collect(N-1, Round, MaxVoted, Proposal)
            end;
        {promise, _, _,  _} ->
            collect(N, Round, MaxVoted, Proposal);
        {sorry, {prepare, Round}} ->
            collect(N, Round, MaxVoted, Proposal);
        {sorry, _} ->
            collect(N, Round, MaxVoted, Proposal)
    after ?timeout ->
            abort
    end.

% If the Quorum is reached return ok
vote(0, _) ->
  ok;
% If the number is received repeat
=======
  {accepted, Proposal};
collect(N, Round, MaxVoted, Proposal) ->
  receive 
    {promise, Round, _, na} ->
      collect(N-1, Round, MaxVoted, Proposal);
    {promise, Round, Voted, Value} ->
      case order:gr(Voted, MaxVoted) of
        true ->
          collect(N-1, Round, Voted, Value);
        false ->
          collect(N-1, Round, MaxVoted, Proposal)
      end;
    {promise, _, _,  _} ->
      collect(N, Round, MaxVoted, Proposal);
    {sorry, {prepare, Round}} ->
      collect(N, Round, MaxVoted, Proposal);
    {sorry, _} ->
      collect(N, Round, MaxVoted, Proposal)
  after ?timeout ->
    abort
  end.

vote(0, _) ->
  ok;
>>>>>>> 2286b6c (final code)
vote(N, Round) ->
  receive
    {vote, Round} ->
      vote(N-1, Round);
    {vote, _} ->
      vote(N, Round);
    {sorry, {accept, Round}} ->
      vote(N, Round);
    {sorry, _} ->
      vote(N, Round)
  after ?timeout ->
    abort
  end.

<<<<<<< HEAD
% Prepare send the prepare message to the Acceptor, that contains self() (PID) and Round
=======
>>>>>>> 2286b6c (final code)
prepare(Round, Acceptors) ->
  Fun = fun(Acceptor) -> 
    send(Acceptor, {prepare, self(), Round}) 
  end,
<<<<<<< HEAD
  % this it means that the message will be forward to every acceptor in the system
=======
>>>>>>> 2286b6c (final code)
  lists:foreach(Fun, Acceptors).

accept(Round, Proposal, Acceptors) ->
  Fun = fun(Acceptor) -> 
    send(Acceptor, {accept, self(), Round, Proposal}) 
  end,
  lists:foreach(Fun, Acceptors).

send(Name, Message) ->
  Name ! Message.
