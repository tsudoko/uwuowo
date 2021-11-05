solid(wall).
solid(table).
solid(exit-closed).
item(cat).
item(knife).
item(can-_).
floor(stairs).

location(Room-wall, X-Y) :-
	wall(Room, X0-Y0, X1-Y1),
	X >= X0, Y >= Y0, X =< X1, Y =< Y1.
