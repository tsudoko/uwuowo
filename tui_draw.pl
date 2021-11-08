redraw :-
	write("\x1b[1J"),
	write("\x1b[0;0f"),
	location(Room-self, _),
	write_room(Room),
	nl, nl,
	statistics(localused, StackBytes),
	current_action(Action),
	atom_concat(act_, DispAction, Action),
	write(StackBytes), (Action \= act_move -> write(' '), write(DispAction); true), nl,
	inventory(self, Inventory),
	write_inventory(Inventory), nl.

write_inventory([]).
write_inventory([I|Rest]) :-
	tile(I, T), put_char(T),
	!, write_inventory(Rest).

write_room(Room) :-
	room(Room, RW-RH),
	BRW is RW+1, BRH is RH+1,
	write_room(Room, BRW-BRH).

is_rect_border(RW-RH, X-Y) :- X = 0; Y = 0; X = RW; Y = RH.

write_room(Room, RW-RH) :- write_room(Room, RW-RH, 0-0), !.

toplevel_ent(X) :-
	\+ solid(X),
	\+ item(X),
	\+ floor(X).

in_circle(CX-CY, CR, X-Y) :-
	RX is X-CX, RY is Y-CY,
	R is sqrt(RX*RX + RY*RY),
	R < CR.

is_visible(X-Y) :-
	location(_-self, SX-SY),
	sight_range(self, SR),
	in_circle(SX-SY, SR, X-Y).

get_top_ent(Room, RW-RH, X-Y, Ent) :-
	(is_rect_border(RW-RH, X-Y), Ent = wall);
	EntX is X-1, EntY is Y-1,
	(
		(\+ is_visible(EntX-EntY), Ent = darkness);
		(location(Room-Ent, EntX-EntY), toplevel_ent(Ent));
		(location(Room-Ent, EntX-EntY), item(Ent));
		(location(Room-Ent, EntX-EntY), solid(Ent));
		(location(Room-Ent, EntX-EntY), floor(Ent));
		location(Room-Ent, EntX-EntY)
	);
	Ent = floor.

write_room(_, RW-RH, RW-RH) :-
	tile(wall, T), put_char(T).
write_room(Room, RW-RH, RW-Y) :-
	NY is Y + 1,
	tile(wall, T), put_char(T),
	nl,
	!, write_room(Room, RW-RH, 0-NY).
write_room(Room, RW-RH, X-Y) :-
	get_top_ent(Room, RW-RH, X-Y, Ent),
	tile(Ent, T), put_char(T),
	NX is X + 1,
	!, write_room(Room, RW-RH, NX-Y).
