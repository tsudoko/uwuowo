% requires shell/1 and stty, ugly
:- initialization(shell('stty -g > /tmp/_get_single_char_stty')).

get_single_char(C) :-
	shell('stty raw -echo'),
	(get_code(C); true),
	shell('stty `cat /tmp/_get_single_char_stty`').
