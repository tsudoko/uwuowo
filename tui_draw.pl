:- include('ops.pl').

redraw :-
	put_codes("\x1b\[1J"),
	put_codes("\x1b\[0;0f"),
	location(Room-self, _),
	write_room(Room),
	nl, nl,
	stack_usage(StackBytes),
	current_action(Action),
	atom_concat(act_, DispAction, Action),
	write(StackBytes), (Action \= act_move -> write(' '), write(DispAction); true), nl,
	inventory(self, Inventory),
	write_inventory(Inventory), nl,
	(inventory_cursor(self, Cur), tile(darkness, ET), Cur times_do [put_codes, ET], tile(cursor, T), put_codes(T), nl; nl),
	findall(put_codes(Msg), (status_msg(Msg), put_codes(Msg), retract(status_msg(Msg)), nl), _).

write_inventory([]).
write_inventory([I|Rest]) :-
	tile(I, T), put_codes(T),
	!, write_inventory(Rest).

write_room(Room) :-
	room(Room, RW-RH),
	BRW is RW+1, BRH is RH+1,
	write_room(Room, BRW-BRH).

write_room(Room, RW-RH) :- write_room(Room, RW-RH, 0-0), !.

write_tile(Room, X-Y) :-
	EntX is X-1, EntY is Y-1,
	visible_location(Room-Ent, EntX-EntY),
	tile(Ent, T), put_codes(T).

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
