:- include('basedef.pl').

solid(wall).
solid(table).
solid(exit-closed).
item(cat).
item(key).
item(lamp).
item(knife).
item(can-_).
floor(exit-open).
floor(stairs-_-_).
description(can-ID, Desc) :-
	contents(can-ID, Contents) ->
		(atom_concat(can, ' of ', CanOf), atom_concat(CanOf, Contents, Desc), !)
		; Desc = can.

description(Ent-_-_, Ent) :- !.
description(Ent-_, Ent) :- !.
description(Ent, Ent) :- !.

on_get(_).

location(Room-wall, X-Y) :-
	\+ (var(X), var(Y)),
	wall(Room, X0-Y0, X1-Y1),
	X >= X0, Y >= Y0, X =< X1, Y =< Y1.
