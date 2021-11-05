random_int(From, To, X) :-
	random(Xf),
	X is floor(Xf * To) + From.

pair_add(X1-Y1, X2-Y2, OX-OY) :-
	OX is X1+X2,
	OY is Y1+Y2.
