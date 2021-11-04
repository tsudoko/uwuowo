:- discontiguous attack_damage/1.
:- discontiguous drink/1.
attack_damage(knife, 20).
drink(X, beer_can) :- sub_stat(X, sanity, 20).
post_attack(X, beer_can) :-
	location(X, SX-SY),
	% TODO?
	false.

post_attack(_).
