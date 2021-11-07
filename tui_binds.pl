:- include("basedef.pl").

toggle_action(A) :- current_action(A),
	retract(current_action(A)),
	assert(current_action(act_move)).
toggle_action(A) :-
	retract(current_action(_)),
	assert(current_action(A)).

act_self(X-Y) :-
	location(Room-self, _),
	current_action(BaseAction),
	Action =.. [BaseAction, Room-self, X-Y],
	call(Action),
	true.

room_leave_self(Where) :-
	location(Room-self, _),
	room_leave(Room-self, Where).

turn_pass :- turn_pass(_).

keybind("O") :- toggle_action(act_open).
keybind("G") :- toggle_action(act_get).
keybind(">") :- room_leave_self(down), turn_pass.
keybind("<") :- room_leave_self(up)  , turn_pass.

keybind("7")      :- act_self(-1 - -1), turn_pass.
keybind("9")      :- act_self( 1 - -1), turn_pass.
keybind("1")      :- act_self(-1 -  1), turn_pass.
keybind("3")      :- act_self( 1 -  1), turn_pass.

keybind("\033[A") :- act_self( 0 - -1), turn_pass.
keybind("8")      :- act_self( 0 - -1), turn_pass.
keybind("k")      :- act_self( 0 - -1), turn_pass.

keybind("\033[B") :- act_self( 0 -  1), turn_pass.
keybind("2")      :- act_self( 0 -  1), turn_pass.
keybind("j")      :- act_self( 0 -  1), turn_pass.

keybind("5")      :- act_self( 0 -  0), turn_pass.
keybind("\r")     :- act_self( 0 -  0), turn_pass.
keybind(" ")      :-                    turn_pass.

keybind("\033[C") :- act_self( 1 -  0), turn_pass.
keybind("6")      :- act_self( 1 -  0), turn_pass.
keybind("l")      :- act_self( 1 -  0), turn_pass.

keybind("\033[D") :- act_self(-1 -  0), turn_pass.
keybind("4")      :- act_self(-1 -  0), turn_pass.
keybind("h")      :- act_self(-1 -  0), turn_pass.

keybind(_).
run_keybind(X) :- keybind(X).
