% A model for the Statues game.
%
% This uses strips.lp

% Fluents
fluent(red).
fluent(at(X)) : x(X).

% kk(X) :- holds(T, at(X)) , time(T).
% #show kk/2.

% Actions
% def
action(move).
% prec

% para que la acción se pueda ejecutar, se debe cumplir que red no es cierto.
action_npre(move, red).

% eff
% cuando se produce move, la posic del player es Dst si at(Src) es true
action_add(move, at(Src+1)) :- at(Src).
% y deja de ser Location
action_del(move, at(Src)) :- at(Src).

% def
action(notMove).
% se agrega esto pq en strips se requiere que se elija una accion en todo tiempo T.
% prec

% para que la acción se pueda ejecutar, se debe cumplir que red es cierto.
action_ppre(notMove, red).

% eff
% cuando se produce notMove, la posic del player es Src si at(Src) es true
action_add(notMove, at(Src)) :- at(Src).
% y deja de ser Src
action_del(notMove, at(Src)) :- at(Src).

% restr
% :- holds(T, red) , holds(T, at(X)) , 

% move / move(Src, Dst)
