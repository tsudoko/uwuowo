solid(wall).
solid(table).
solid(exit-closed).
item(cat).
item(key).
item(knife).
item(can-_).
floor(stairs-_).

location(Room-wall, X-Y) :-
	\+ (var(X), var(Y)),
	wall(Room, X0-Y0, X1-Y1),
	X >= X0, Y >= Y0, X =< X1, Y =< Y1.
