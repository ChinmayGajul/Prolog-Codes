% Define cities and distances between them
distance(a, b, 10).
distance(a, c, 15).
distance(a, d, 20).
distance(b, c, 35).
distance(b, d, 25).
distance(c, d, 30).

% Find the shortest route for the TSP using Heuristic
tsp_heuristic(Cities, Path, TotalDistance) :-
    start_city(Cities, StartCity),
    heuristic_nn(StartCity, Cities, [StartCity], Path),
    route_distance(Path, TotalDistance).

% Nearest Neighbor Heuristic
heuristic_nn(CurrentCity, Cities, Visited, [CurrentCity | Path]) :-
    find_next_city(CurrentCity, Cities, Visited, NextCity),
    heuristic_nn(NextCity, Cities, [NextCity | Visited], Path).
heuristic_nn(_, _, _, []).

% Find the next city using Heuristic (Nearest Neighbor)
find_next_city(CurrentCity, Cities, Visited, NextCity) :-
    findall(Dist-City, (member(City, Cities), \+member(City, Visited), distance(CurrentCity, City, Dist)), Candidates),
    keysort(Candidates, [Dist-NextCity | _]).

% Utility predicate to find the starting city
start_city([City | _], City).

% Calculate total distance of the route
route_distance([City1, City2 | Rest], TotalDistance) :-
    distance(City1, City2, Dist),
    route_distance([City2 | Rest], PartialDistance),
    TotalDistance is PartialDistance + Dist.
route_distance([_], 0).

% Example usage
?- tsp_heuristic([a, b, c, d, e], _, _).
