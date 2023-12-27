-module(acceptor).
-export([start/2]).

<<<<<<< HEAD
=======
-define(delay, 10000).

>>>>>>> 2286b6c (final code)
start(Name, PanelId) ->
  spawn(fun() -> init(Name, PanelId) end).
        
init(Name, PanelId) ->
<<<<<<< HEAD
  % Promised is initialized as {0,0} because there isn't a promised
  Promised = order:null(), 
  % Voted is initialized as {0,0} because there isn't a vote
  Voted = order:null(),
  % Value is the color, but it isn't already chose (this means black color)
  Value = na,
  % Execution of the acceptor function
  acceptor(Name, Promised, Voted, Value, PanelId).

acceptor(Name, Promised, Voted, Value, PanelId) ->
  % Until the process receives prepare from proposer, it will await
  receive
  % This is the prepare stage
  % Proposer is the PID of the proposer
  % Round is a tuple {value, Id} where value is the sequene number and Id is the ProposerName
    {prepare, Proposer, Round} ->
      % Compare the round and the promised that it has already
      case order:gr(Round, Promised) of
        true ->
          % If it is true it sends the promise to the proposed
          Proposer ! {promise, Round, Voted, Value},               
          io:format("[Acceptor ~w] Phase 1: promised ~w voted ~w colour ~w~n",
                 [Name, Round, Voted, Value]),
          % Update gui
          % If value is equal to na (that is equal to {0,0,0}) then Colour will be equal to _ {that is equal to Value)
          Colour = case Value of na -> {0,0,0}; _ -> Value end,
          % Send to PanelId the Voted until now, the Promised and the new Colour
          PanelId ! {updateAcc, "Voted: " ++ io_lib:format("~p", [Voted]), 
                     "Promised: " ++ io_lib:format("~p", [Round]), Colour},
          % Repeat the acceptor function with new value of Pro and await for another prepare function
          acceptor(Name, Round, Voted, Value, PanelId);

        false ->
          % if the round received is lower send sorry to the proposer
          Proposer ! {sorry, {prepare, Round}},
          % Repeat the acceptor function and await for another prepare function
          acceptor(Name, Promised, Voted, Value, PanelId)
      end;

  % This is the accept stage 
    {accept, Proposer, Round, Proposal} ->
      % If the Promised is greater or equal to the Proposal
      case order:goe(Round, Promised) of
        true ->
          % Send to the proposer the vote
          Proposer ! {vote, Promised},
          % Chck if the new Proposed received is greater or equal to the Voted
          case order:goe(Round, Voted) of
            true ->
              io:format("[Acceptor ~w] Phase 2: promised ~w voted ~w colour ~w~n",
                 [Name, Promised, Round, Proposal]),
              % Update gui
              % new
              PanelId ! {updateAcc, "Voted: " ++ io_lib:format("~p", [Round]), 
                         "Promised: " ++ io_lib:format("~p", [Promised]), Proposal},
              % Add to the new Promised value and 
              %acceptor(Name, Promised, Voted, Proposal, PanelId);
              acceptor(Name, Promised, Round, Proposal, PanelId);
            false ->
              acceptor(Name, Promised, Voted, Proposal, PanelId)
=======
  Promised = order:null(), 
  Voted = order:null(),
  Value = na,
  acceptor(Name, Promised, Voted, Value, PanelId).

acceptor(Name, Promised, Voted, Value, PanelId) ->
  receive
    {prepare, Proposer, Round} ->
      case order:gr(Round, Promised) of
        true ->
          T = rand:uniform(?delay),
          timer:send_after(T, Proposer, {promise, Round, Voted, Value}),
          % Proposer ! {promise, Round, Voted, Value},               
      io:format("[Acceptor ~w] Phase 1: promised ~w voted ~w colour ~w~n",
                 [Name, Round, Voted, Value]),
          % Update gui
          Colour = case Value of na -> {0,0,0}; _ -> Value end,
          PanelId ! {updateAcc, "Voted: " ++ io_lib:format("~p", [Voted]), 
                     "Promised: " ++ io_lib:format("~p", [Round]), Colour},
          acceptor(Name, Round, Voted, Value, PanelId);
        false ->
          Proposer ! {sorry, {prepare, Round}},
          acceptor(Name, Promised, Voted, Value, PanelId)
      end;
    {accept, Proposer, Round, Proposal} ->
      case order:goe(Round, Promised) of
        true ->
          T = rand:uniform(?delay),
          timer:send_after(T, Proposer, {promise, Round, Voted, Value}),
          % Proposer ! {vote, Round},
          case order:goe(Round, Voted) of
            true ->
      io:format("[Acceptor ~w] Phase 2: promised ~w voted ~w colour ~w value ~w~n",
                 [Name, Promised, Round, Proposal, Value]),
              % Update gui
              PanelId ! {updateAcc, "Voted: " ++ io_lib:format("~p", [Round]), 
                         "Promised: " ++ io_lib:format("~p", [Promised]), Proposal},
              acceptor(Name, Promised, Round, Proposal, PanelId);
            false ->
              acceptor(Name, Promised, Voted, Value, PanelId)   % QUESTIONABLE
>>>>>>> 2286b6c (final code)
          end;                            
        false ->
          Proposer ! {sorry, {accept, Round}},
          acceptor(Name, Promised, Voted, Value, PanelId)
      end;
    stop ->
      PanelId ! stop,
      ok
  end.
