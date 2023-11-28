% Place a queen in a column and row if it doesn't conflict with existing queens
% Safe predicate checks if it's safe to place a queen at the given row and column
safe(_, []).
safe(Row, [Col|Queens]) :-
    no_attack(Row, Col, Queens),
    NextRow is Row + 1,
    safe(NextRow, Queens).

% no_attack predicate checks if the queen at Row and Col doesn't attack any other queen
no_attack(_, _, []).
no_attack(Row, Col, [QueenCol|Queens]) :-
    QueenCol =\= Col,
    Diff is abs(Col - QueenCol),
    Diff =\= Row,
    NextRow is Row + 1,
    no_attack(NextRow, Col, Queens).

% Define the solve predicate to solve the 8 Queens problem
solve(Queens) :-
    permutation([1, 2, 3, 4, 5, 6, 7, 8], Queens),
    safe(1, Queens).

% Display the solution
display([]).
display([Col|Queens]) :-
    display(Queens),
    write('|'),
    print_line(Col),
    nl.

% Print the line with the queen at the specified column
print_line(Col) :-
    N is Col - 1,
    print_space(N),
    write('Q'),
    N2 is 8 - Col,
    print_space(N2).

% Helper predicate to print spaces
print_space(0).
print_space(N) :-
    write(' '),
    N1 is N - 1,
    print_space(N1).
