% Heuristic predicates

% conflicts predicate calculates the number of conflicts for a queen at a given Row and Col
conflicts(_, [], _, _, 0).
conflicts(Row, [Col|OtherCols], Col, N, C) :-
    NextRow is Row + 1,
    conflicts(Row, OtherCols, Col, N, SubC),
    conflicts(NextRow, OtherCols, Col, N, RestC),
    C is SubC + RestC.
conflicts(Row, [Col|OtherCols], OtherCol, N, C) :-
    NextRow is Row + 1,
    Col #\= OtherCol,
    abs(OtherCol - Col) #\= N,
    conflicts(NextRow, OtherCols, OtherCol, N, C).
conflicts(Row, [Col|OtherCols], OtherCol, N, C) :-
    NextRow is Row + 1,
    (Col #= OtherCol; abs(OtherCol - Col) #= N),
    conflicts(NextRow, OtherCols, OtherCol, N, SubC),
    C is 1 + SubC.

% min_conflicts predicate finds the column with the minimum conflicts for a given row
min_conflicts(_, [], _, _, -1).
min_conflicts(Row, [Col|OtherCols], RowBoard, N, MinCol) :-
    conflicts(1, RowBoard, Col, N, C1),
    min_conflicts(Row, OtherCols, RowBoard, N, NextCol),
    conflicts(1, RowBoard, NextCol, N, C2),
    (C1 < C2 -> MinCol = Col; MinCol = NextCol).

% move_queen predicate moves the queen in the specified row to the column with minimum conflicts
move_queen([], [], _, _).
move_queen([Row|OtherRows], [NewRow|NewBoard], RowNum, N) :-
    min_conflicts(RowNum, Row, Row, N, MinCol),
    move_queen(OtherRows, NewBoard, RowNum, N),
    nth1(MinCol, NewRow, RowNum, NewRow).

% Heuristic function: Evaluate a board based on the total conflicts
heuristic(Board, HeuristicValue) :-
    findall(Conflicts, (nth1(Row, Board, RowValues), conflicts(Row, RowValues, _, _, Conflicts)), ConflictList),
    sum_list(ConflictList, HeuristicValue).

% Main predicate for best-first search to solve the 8 Queens problem
best_first_search(Queens) :-
    initial_board(Board),
    best_first_search([Board-0], Queens).

% Best-first search implementation
best_first_search([Board-_ | _], Board) :-
    heuristic(Board, 0). % If the board's heuristic value is 0, it's a solution.
best_first_search([Board-_ | Rest], Queens) :-
    findall(NewBoard-Heuristic, (move_queen(Board, NewBoard, _, 1), heuristic(NewBoard, Heuristic)), Successors),
    append(Successors, Rest, UpdatedQueue),
    keysort(UpdatedQueue, SortedQueue),
    best_first_search(SortedQueue, Queens).

% Initial empty board
initial_board(Board) :-
    length(Board, 8),
    maplist(length_(8), Board),
    maplist(fd_domain_(1, 8), Board),
    maplist(fd_all_different_, Board).

% Helper predicates
length_(N, L) :- length(L, N).
fd_domain_(Min, Max, L) :- fd_domain(L, Min, Max).
fd_all_different_(L) :- fd_all_different(L).
