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
	write_inventory(Inventory), nl,
	(inventory_cursor(self, Cur), put_char_n("　", Cur), tile(cursor, T), put_char(T), nl; nl),
	(status_msg(Msg), write(Msg), retract(status_msg(Msg)), nl; nl).

put_char_n(_, 0).
put_char_n(X, N) :- put_char(X), NN is N-1, put_char_n(X, NN).

write_inventory([]).
write_inventory([I|Rest]) :-
	tile(I, T), put_char(T),
	!, write_inventory(Rest).

write_room(Room) :-
	room(Room, RW-RH),
	BRW is RW+1, BRH is RH+1,
	write_room(Room, BRW-BRH).

write_room(Room, RW-RH) :- write_room(Room, RW-RH, 0-0), !.

write_tile(Room, X-Y) :-
	EntX is X-1, EntY is Y-1,
	visible_location(Room-Ent, EntX-EntY),
	tile(Ent, T), put_char(T).

write_room(Room, RW-RH, RW-RH) :-
	write_tile(Room, RW-RH).
write_room(Room, RW-RH, RW-Y) :-
	NY is Y + 1,
	write_tile(Room, RW-Y),
	nl,
	!, write_room(Room, RW-RH, 0-NY).
write_room(Room, RW-RH, X-Y) :-
	write_tile(Room, X-Y),
	NX is X + 1,
	!, write_room(Room, RW-RH, NX-Y).
