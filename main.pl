:- include('basedef.pl').

:- set_prolog_flag(double_quotes, codes).
:- initialization((
	(current_prolog_flag(dialect, swi) ->
		set_prolog_flag(iso, true),
		['compat/stack_usage_swi.pl']
	; true),
	(current_prolog_flag(dialect, xsb) ->
		[
			'compat/random_random.pl',
			'compat/stack_usage_xsb.pl',
			'compat/get_key_unix.pl'
		],
		random:datime_setrand
	; true),
	(current_prolog_flag(dialect, gprolog) ->
		[
			'compat/stack_usage_gprolog.pl',
			'compat/get_key_gprolog.pl'
		],
		randomize
	; true),
	(current_prolog_flag(dialect, trealla) ->
		['compat/get_key_guc.pl'],
		now(Now),
		set_seed(Now)
	; true),
	(\+ current_predicate(get_key_/1) ->
		(current_predicate(get_single_char/1) -> ['compat/get_key_gsc.pl']
		; ['compat/get_key_none.pl'])
	; true),
	(\+ current_predicate(divmod/4) -> ['compat/divmod.pl']; true),
	(\+ current_predicate(stack_usage/1) -> ['compat/stack_usage_none.pl']; true)
)).

stat(self, sanity, 100).

:- initialization([
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
]).

init :-
	put_ent(testroom-lamp, random),
	put_ent(testroom-key, random),
	gen_rooms(StartRoom),
	put_ent(StartRoom-self, random),
	asserta(current_action(act_move)),
	!.
