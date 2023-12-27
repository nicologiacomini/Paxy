# Paxy
In this project I implemented Paxos algorithm using Erlang.
The main goal is to test Paxos in a distributed system composed by 3 proposer and 5 acceptors.

## Execution
For the test use the following command (in the Erlang shell):
```console
paxy:start([0,1,2]).
```
where [0,1,2] is the vector of the times where the proposers start to propose. 
