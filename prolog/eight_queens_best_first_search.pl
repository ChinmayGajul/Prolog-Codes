% Heuristic to calculate the number of conflicts for a given board configuration
heuristic(Board, HeuristicValue) :-
    conflicts(Board, 1, HeuristicValue). % Start calculating conflicts

% Calculate conflicts for a given board configuration
conflicts([], _, 0). % Base case: no more queens to check
conflicts([Q|Queens], Col, Value) :-
    NextCol is Col + 1,
    conflicts(Queens, NextCol, RestValue),
    count_conflicts(Q, Queens, RestValue, Value).

% Count conflicts for each queen
count_conflicts(_, [], Value, Value). % No more queens to check
count_conflicts(Q, [Q1|Queens], Value, NewValue) :
    Q =\= Q1,
    abs(Q - Q1) =\= Value, % Check if conflict exists
    NextValue is Value + 1,
    count_conflicts(Q, Queens, NextValue, NewValue).
count_conflicts(Q, [_|Queens], Value, NewValue) :-
    count_conflicts(Q, Queens, Value, NewValue).

% Best-First Search for the 8 Queens problem
best_first_search(Start, Solution) :-
    bfs([(Start, [])], Solution).

bfs([(Node, Path) | _], Path) :-
    heuristic(Node, 0), % Goal found when heuristic value is 0 (no conflicts)
    !.

bfs([(Node, CurrentPath) | RemainingNodes], Solution) :-
    generate_next_nodes(Node, CurrentPath, NextNodes),
    append(RemainingNodes, NextNodes, NewNodes),
    sort(NewNodes, SortedNodes), % Sort nodes based on heuristic values
    bfs(SortedNodes, Solution).

% Generate next possible configurations of placing queens
generate_next_nodes(Node, Path, NextNodes) :-
    length(Path, NumQueens),
    NextCol is NumQueens + 1,
    findall((NextNode, [NextNode | Path]), (between(1, 8, Row), permutation([Row | Node], NextNode), \+ member(NextNode, Path)), NextNodes).

% Display the board
display_board([]).
display_board([Col|Queens]) :-
    display_board(Queens),
    write('|'),
    print_line(Col),
    nl.

print_line(Col) :-
    N is Col - 1,
    print_space(N),
    write('Q'),
    N2 is 8 - Col,
    print_space(N2).

print_space(0).
print_space(N) :-
    write(' '),
    N1 is N - 1,
    print_space(N1).
