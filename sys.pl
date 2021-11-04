:- include("basedef.pl").

% FIXME: doesn't work with more generalized queries like (someroom, X-Y), needs clpfd and probably something else than \+
empty_tile(Room, X-Y) :-
	size(Room, RX1, RY1),
	\+ location(_, X-Y),
	X >= 0, Y >= 0, X < RX1, Y < RY1,
	true.
	%\+ bagof(Room, wall(Room, WX0, WY0, WX1, WY1),
	%WX0 > 0

teleport(Ent, X-Y) :-
	Room-_ = Ent,
	empty_tile(Room, X-Y),
	retract(location(Ent, _-_)),
	assert(location(Ent, X-Y)).

rel_direction_to(EX-EY, TX-TY, OutX-OutY) :-
	OutX is floor(-sign(EX-TX)),
	OutY is floor(-sign(EY-TY)).

pair_add(X1-Y1, X2-Y2, OX-OY) :-
	OX is X1+X2,
	OY is Y1+Y2.

move_rel(Room-Ent, Direction) :-
	location(Room-Ent, EntXY),
	pair_add(EntXY, Direction, MoveXY),
	teleport(Room-Ent, MoveXY).

move_towards(Room-Ent, Room-Target) :-
	location(Room-Ent, EntXY),
	location(Room-Target, TargetXY),
	rel_direction_to(EntXY, TargetXY, Direction),
	move_rel(Room-Ent, Direction).

move_up(Ent) :-
	location(Ent, X-Y),
	NewX is X+1,
	teleport(Ent, NewX-Y).

move_down(Ent) :-
	location(Ent, X-Y),
	NewX is X-1,
	teleport(Ent, NewX-Y).

move_left(Ent) :-
	location(Ent, X-Y),
	NewY is Y-1,
	teleport(Ent, X-NewY).

move_right(Ent) :-
	location(Ent, X-Y),
	NewY is Y+1,
	teleport(Ent, X-NewY).
