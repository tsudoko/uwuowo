random_int(From, To, X) :- % [From, To] inclusive
	random(Xf),
	X is round(Xf * To) + From.

pair_add(X1-Y1, X2-Y2, OX-OY) :-
	OX is X1+X2,
	OY is Y1+Y2.

in_circle(CX-CY, CR, X-Y) :-
	RX is X-CX, RY is Y-CY,
	R is sqrt(RX*RX + RY*RY),
	R < CR.

list_reverse(X, Out) :- list_reverse_concat(X, [], Out).
list_concat(X, Y, Out) :-
	list_reverse(X, RevX),
	list_reverse_concat(RevX, Y, Out).
list_reverse_concat([], Ys, Ys).
list_reverse_concat([X|Xs], Ys, Out) :- list_reverse_concat(Xs, [X|Ys], Out).

list_nth([X|_], 0, X).
list_nth([_|Xs], Nth, Out) :- Nnth is Nth-1, list_nth(Xs, Nnth, Out).

list_del_one(X, Items, Out) :- list_del_one(X, Items, [], Out).
list_del_one(X, [X|Rest], OtherItems, Out) :- list_reverse_concat(OtherItems, Rest, Out).
list_del_one(X, [Y|Rest], OtherItems, Out) :- list_del_one(X, Rest, [Y|OtherItems], Out).
