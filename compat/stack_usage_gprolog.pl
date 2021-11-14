stack_usage(X) :- statistics(local_stack, Stack), [X|_] = Stack.
