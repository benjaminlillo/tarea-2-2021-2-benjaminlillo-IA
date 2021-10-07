%  S             G   | % k=10
%  0|1|2|3|4|5|6|7   | exec(0, move), exec(1, move), exec(4, move), exec(6, move), exec(8, move), ...
% -----------------

x(0..7).

start(at(0)).
goal(at(7)).

holds(2, red).
holds(3, red).
holds(5, red).
holds(7, red).
