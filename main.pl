:- include('basedef.pl').

:- initialization((current_prolog_flag(dialect, swi), set_prolog_flag(iso, true); true)).
:- initialization((current_prolog_flag(dialect, swi), ['compat/stack_usage_swi.pl']; true)).
:- set_prolog_flag(double_quotes, codes).

stat(self, sanity, 100).
current_action(act_move).

:- [
	'util.pl',
	'cat.pl',
	'testroom.pl',
	'maze_btree.pl',
	'roomgen.pl',
	'entities.pl',
	'sys.pl',
	'tui_draw.pl',
	'tui_tiles.pl',
	'tui_binds.pl',
	'tui.pl'
].

:- (
	gen_rooms(StartRoom),
	put_ent(StartRoom-self, random)
).
:- put_ent(testroom-lamp, random).
:- put_ent(testroom-key, random).
