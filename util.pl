:- include('ops.pl').

maybe :- random_int(0, 2, X), X =:= 0.
random_int(From, To, X) :- % [From, To)
	random(Xf),
	X is floor(Xf * (To - From) + From).

put_codes([]).
put_codes([X|Xs]) :- put_code(X), put_codes(Xs).

times_do(N, TermList) :-
	Goal =.. TermList,
	times_do_(N, Goal).
times_do_(0, _).
times_do_(N, Goal) :-
	NN is N-1,
	call(Goal), times_do_(NN, Goal).

pair_add(X1-Y1, X2-Y2, OX-OY) :-
	OX is X1+X2,
	OY is Y1+Y2.

in_circle(CX-CY, CR, X-Y) :-
	RX is X-CX, RY is Y-CY,
	R is sqrt(RX*RX + RY*RY),
	R < CR.

list_member([X|_], X).
list_member([_|Xs], X) :- list_member(Xs, X).
list_max([X|Xs], Out) :- list_max(Xs, X, Out).
list_max([], Out, Out).
list_max([X|Xs], Max, Out) :- Max < X, !, list_max(Xs, X, Out).
list_max([_|Xs], Max, Out) :- !, list_max(Xs, Max, Out).
list_length(X, Out) :- list_length(X, 0, Out).
list_length([], L, L).
list_length([_|Xs], L, Out) :- NL is L + 1, list_length(Xs, NL, Out).
list_reverse(X, Out) :- list_reverse_concat(X, [], Out).
% FIXME: infinite loop on e.g. list_concat(X, [2], [2, 1])
list_concat(X, Y, Out) :-
	list_reverse(X, RevX),
	list_reverse_concat(RevX, Y, Out).
list_reverse_concat([], Ys, Ys).
list_reverse_concat([X|Xs], Ys, Out) :- list_reverse_concat(Xs, [X|Ys], Out).

list_random_choice(X, Out) :-
	list_length(X, XLen),
	random_int(0, XLen, N),
	list_nth(X, N, Out).
list_nth([X|_], 0, X) :- !.
list_nth([_|Xs], Nth, Out) :- Nnth is Nth-1, list_nth(Xs, Nnth, Out).

list_del_one(Items, X, Out) :- list_del_one(Items, X, [], Out).
list_del_one([X|Rest], X, OtherItems, Out) :- list_reverse_concat(OtherItems, Rest, Out).
list_del_one([Y|Rest], X, OtherItems, Out) :- list_del_one(Rest, X, [Y|OtherItems], Out).

fnv_prime(32, 16777619).
fnv_prime(64, 1099511628211).
fnv_offset(32, 2166136261).
fnv_offset(64, 14695981039346656037).
fnv1a(Bits, Num, Hash) :-
	fnv_prime(Bits, Prime),
	fnv_offset(Bits, Offset),
	fnv1a_(Bits, Prime, Num, Offset, Hash), !.
fnv1a_(_, _, 0, OutHash, OutHash).
fnv1a_(Bits, Prime, Num, AccHash, OutHash) :-
	NAccHash is (xor(AccHash, Num/\0xff) * Prime) /\ ((1<<Bits)-1),
	NNum is Num >> 8,
	!,
	fnv1a_(Bits, Prime, NNum, NAccHash, OutHash).
