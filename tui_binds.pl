move_self(X-Y) :-
	location(Room-self, _),
	move_rel(Room-self,  X-Y),
	true.
turn_pass. % TODO

keybind("7")      :- move_self(-1 - -1), turn_pass.
keybind("9")      :- move_self( 1 - -1), turn_pass.
keybind("1")      :- move_self(-1 -  1), turn_pass.
keybind("3")      :- move_self( 1 -  1), turn_pass.

keybind("\033[A") :- move_self( 0 - -1), turn_pass.
keybind("8")      :- move_self( 0 - -1), turn_pass.
keybind("k")      :- move_self( 0 - -1), turn_pass.

keybind("\033[B") :- move_self( 0 -  1), turn_pass.
keybind("2")      :- move_self( 0 -  1), turn_pass.
keybind("j")      :- move_self( 0 -  1), turn_pass.

keybind("\033[C") :- move_self( 1 -  0), turn_pass.
keybind("6")      :- move_self( 1 -  0), turn_pass.
keybind("l")      :- move_self( 1 -  0), turn_pass.

keybind("\033[D") :- move_self(-1 -  0), turn_pass.
keybind("4")      :- move_self(-1 -  0), turn_pass.
keybind("h")      :- move_self(-1 -  0), turn_pass.

keybind(_).
run_keybind(X) :- keybind(X).
