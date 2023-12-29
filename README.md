# Paxy
In this project we have implemented Paxos using Erlang.
There are 8 processors: 3 proposers and 5 acceptors.
The main goal of the project is to try to test and study how Paxos works in a distributed system.

## Execution
For the execution you can use the following command
```command
paxy:start([0,1,2]).
```
where the vector [0,1,2] defines the instant where each proposer start his execution (in ms).
