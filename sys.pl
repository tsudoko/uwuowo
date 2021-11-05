:- include("basedef.pl").

inventory(_, []).
inventory_add(Ent, Item) :-
	once(inventory(Ent, Items)),
	retract(inventory(Ent, Items)),
	assert(inventory(Ent, [Item|Items])).

% FIXME: doesn't work with more generalized queries like (someroom, X-Y), needs clpfd and probably something else than \+
empty_tile(Room, X-Y) :-
	size(Room, RX1-RY1),
	\+ (location(Room-Ent, X-Y), solid(Ent)),
	X >= 0, Y >= 0, X < RX1, Y < RY1.

teleport(Ent, X-Y) :-
	Room-_ = Ent,
	empty_tile(Room, X-Y),
	retract(location(Ent, _-_)),
	assert(location(Ent, X-Y)).

rel_direction_to(EX-EY, TX-TY, OutX-OutY) :-
	OutX is floor(-sign(EX-TX)),
	OutY is floor(-sign(EY-TY)).

get(Room-Ent, Direction) :-
	location(Room-Ent, EntXY),
	pair_add(EntXY, Direction, TargetXY),
	once((location(Room-Target, TargetXY), item(Target))),
	inventory_add(Ent, Target),
	retract(location(Room-Target, TargetXY)).

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
