random_int(From, To, X) :- random(Xf), X is floor(Xf * To) + From.
