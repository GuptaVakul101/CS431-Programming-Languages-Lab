% Computes the optimal path between source and destination based on different optimization parameters (distance, cost and time)
findOptimalTravelRoute(SourcePlace, DestinationPlace) :-

    % NOTE -> If "calculateMinimumTravelWeightSum" returns false, then we can conclude that no such path exists from source to destination
	% Optimization parameter -> Distance
	(calculateMinimumTravelWeightSum(SourcePlace, DestinationPlace, 'Distance') -> true ;
                                        write('No such path exists from source to destination!'), false),
    % Optimization parameter -> Time
	(calculateMinimumTravelWeightSum(SourcePlace, DestinationPlace, 'Time') -> true ;
                                        write('No such path exists from source to destination!'), false),
    % Optimization parameter -> Cost
	(calculateMinimumTravelWeightSum(SourcePlace, DestinationPlace, 'Cost') -> true ;
                                        write('No such path exists from source to destination!'), false).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% Returns true only if there exist an edge between vertex1 and vertex2
% Returns edge weight in terms of distance
getEdgeDetails(Vertex1, Vertex2, EdgeWeight, 'Distance') :-
	bus(_, Vertex1, Vertex2, _, _, EdgeWeight, _).

% Returns edge weight in terms of time
getEdgeDetails(Vertex1, Vertex2, EdgeWeight, 'Time') :-
	bus(_, Vertex1, Vertex2, DepartureTime, ArrivalTime, _, _),
	% Check for next day time differences
	(ArrivalTime > DepartureTime -> EdgeWeight is ArrivalTime - DepartureTime
			  ; EdgeWeight is 24 + ArrivalTime - DepartureTime).

% Returns edge weight in terms of cost
getEdgeDetails(Vertex1, Vertex2, EdgeWeight, 'Cost') :-
	bus(_, Vertex1, Vertex2, _, _, _, EdgeWeight).

% Returns weight in terms of all parameters
getEdgeDetails(Vertex1, Vertex2, BusNumber, Distance, TimeDifference, Cost) :-
	bus(BusNumber, Vertex1, Vertex2, DepartureTime, ArrivalTime, Distance, Cost),
	(ArrivalTime > DepartureTime -> TimeDifference is ArrivalTime - DepartureTime
			  ; TimeDifference is 24 + ArrivalTime - DepartureTime).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% If parent is NULL, waiting time is zero
findWaitingTime('', _, _, WaitingTime) :-
	WaitingTime is 0.

% Finds waiting time at current vertex
findWaitingTime(Parent, CurrentVertex, NextVertex, WaitingTime) :-
    % Waiting time is difference between the departure time and arrival time
	bus(_, Parent, CurrentVertex, _, ArrivalTime, _, _),
	bus(_, CurrentVertex, NextVertex, DepartureTime, _, _, _),
	(DepartureTime > ArrivalTime -> WaitingTime is DepartureTime - ArrivalTime
			  ; WaitingTime is 24 + DepartureTime - ArrivalTime).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE -> if Source equals destination then set all weights to zero
printOptimalPath(SourcePlace, SourcePlace, _, 0, 0, 0) :-
	write('['), write(SourcePlace).

% Prints optimal path and computes minimum distance, time and cost
printOptimalPath(SourcePlace, DestinationPlace, Parent, Distance, Time, Cost) :-
	% Call printOptimalPath recursively for parent of DestinationPlace
	printOptimalPath(SourcePlace, Parent.get(DestinationPlace), Parent, D1, T1, C1),
	getEdgeDetails(Parent.get(DestinationPlace), DestinationPlace, B, D2, T2, C2),
	% Check if parent of parent of DestinationPlace exists. If exists then obtain the waiting time as well
	(get_dict(Parent.get(DestinationPlace), Parent, _) -> 
		findWaitingTime(Parent.get(Parent.get(DestinationPlace)), Parent.get(DestinationPlace), DestinationPlace, WaitingTime);
		WaitingTime is 0),
	Distance is D1 + D2, Time is T1 + T2 + WaitingTime, Cost is C1 + C2,
	write(','), write(B), write('] -> '), write('['), write(DestinationPlace).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE -> If current vertex is same as X, return the remaining list
removeFromList([X|T], X, T).

removeFromList([H|T], X, [H|NT]) :- % Removes a vertex X from given list and returns the remaining list

	H \= X, % Check if H is not equal to X
	removeFromList(T, X, NT). % Call recursively

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE -> If no vertex is left, return the remaining set of vertices
updateParentAndRelaxEdges([], CurSet, _, _, CurSet, ParentList, ParentList, _). 
% Updates the weights of the vertices from adjSet and returns newCurSet
updateParentAndRelaxEdges([NeighbourV-EdgeWeight|T], CurSet, CurVertex, GlobalWeightOfV, NewCurSet, ParentList, FinalParentList, OptimizationParameter) :-
    findWaitingTime(ParentList.get(CurVertex), CurVertex, NeighbourV, WaitingTime),
    (OptimizationParameter == 'Time' ->
		% If Optimization Parameter is time, then compute the waiting time and add it
		( 
            removeFromList(CurSet, NeighbourV-GlobalWeightV1, RestCurSet) -> 
            (GlobalWeightOfV + EdgeWeight + WaitingTime < GlobalWeightV1 -> 
                    NewWeight is GlobalWeightOfV + EdgeWeight + WaitingTime, NewParent = ParentList.put(NeighbourV, CurVertex); 
                    NewWeight is GlobalWeightV1, NewParent = ParentList);
            RestCurSet = CurSet, NewWeight is GlobalWeightOfV + EdgeWeight + WaitingTime, NewParent = ParentList.put(NeighbourV, CurVertex)
        );
		% Else proceed normally
		( 
		removeFromList(CurSet, NeighbourV-GlobalWeightV1, RestCurSet) -> 
            (GlobalWeightOfV + EdgeWeight < GlobalWeightV1 -> 
                    NewWeight is GlobalWeightOfV + EdgeWeight, NewParent = ParentList.put(NeighbourV, CurVertex); 
                    NewWeight is GlobalWeightV1, NewParent = ParentList);
            RestCurSet = CurSet, NewWeight is GlobalWeightOfV + EdgeWeight, NewParent = ParentList.put(NeighbourV, CurVertex)
        )
    ),

    NewCurSet = [NeighbourV-NewWeight|SubNewCurSet],
    % Call this function recursively
	updateParentAndRelaxEdges(T, RestCurSet, CurVertex, GlobalWeightOfV, SubNewCurSet, NewParent, FinalParentList, OptimizationParameter).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE -> If no vertex is left
findUpdatedAdjacentSet([], _, []).
% Given a set of vertices, check if any vertex in it is visited or not and creates new List
findUpdatedAdjacentSet([H|T], VisitedSet, UpdatedAdjSet) :-
    H = V-_,
    % If vertex V is present in visited, do not add it to
    (member(V-_, VisitedSet) -> UpdatedAdjSet = SubNewAdjSet ; UpdatedAdjSet = [H|SubNewAdjSet]),
    % Recursive call
	findUpdatedAdjacentSet(T, VisitedSet, SubNewAdjSet).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% Given a vertex U, returns the set of Adjacent vertices in AdjSet
findAdjacentSet(U, AdjSet, OptimizationParameter) :-
	(setof(V-D, getEdgeDetails(U, V, D, OptimizationParameter), TempAdjSet) *-> TempAdjSet = AdjSet; AdjSet = []).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE -> If no vertex is left
minWeightVertexUtility(Cur, [], Cur, []). 
% Just a helper function to solve minVertex
minWeightVertexUtility(Cur, [H|T], MinV, [H2|RestCurSet]) :-
	H = _-D1, Cur = _-D,
    (D1 < D -> NextM = H, H2 = Cur ; NextM = Cur, H2 = H),
    % Call recursivly
	minWeightVertexUtility(NextM, T, MinV, RestCurSet).

% Returns the vertex with minimum weight from VertexSet
minWeightVertex([H|T], MinV, VertexSet) :-
	minWeightVertexUtility(H, T, MinV, VertexSet).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE -> If no vertex is left, return the final cost and ParentList list
executeDjikstra([], VisitedSet, _, VisitedSet, ParentList, ParentList).

executeDjikstra(CurSet, VisitedSet, OptimizationParameter, MinDist, ParentList, FinalParentList) :-
	% Computes the vertex with minimum Vertex, RestCurSet removes the minVertex from CurSet
	% Here V is the minVertex and D is it's global Cost till now
	minWeightVertex(CurSet, V-D, RestCurSet), 
	findAdjacentSet(V, AdjSet, OptimizationParameter),  % Computes all adjacent vertex to vertex V
	findUpdatedAdjacentSet(AdjSet, VisitedSet, UpdatedAdjSet), % Selects only those vertices which are not visited yet
	updateParentAndRelaxEdges(UpdatedAdjSet, RestCurSet, V, D, NewCurSet, ParentList, NewParent, OptimizationParameter), % Relaxes the adjacent edges and NewCurSet is the new current set with updated cost
	executeDjikstra(NewCurSet, [V-D|VisitedSet], OptimizationParameter, MinDist, NewParent, FinalParentList). % Recursively call Djikstra for remaining vertices

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% It calculates minimum travel weight sum from source to destination based on "Optimization Parameter"
calculateMinimumTravelWeightSum(SourcePlace, DestinationPlace, OptimizationParameter) :-
	dict_create(ParentList, parent, [SourcePlace='']),
	executeDjikstra([SourcePlace-0], [], OptimizationParameter, _, ParentList, NewParent), % Call Djikstra for  Source Vertex and return final parent as NewParent
	get_dict(DestinationPlace, NewParent, _), % Checks if Destination is reachable from Source Vertex or not

	% Prints optimal path along with minimum distance, time and cost
	write('Optimum '), write(OptimizationParameter), write(':\n'),
	write('\tPATH: '), printOptimalPath(SourcePlace, DestinationPlace, NewParent, Distance, Time, Cost), write(']\n'),
	write('\tDistance = '), write(Distance), write(','),
	write(' Time = '), write(Time),  write(','),
	write(' Cost = '), write(Cost), write('\n'), write('\n').

    % write('Optimum '), write(OptimizationParameter), write(':\n'),
	% printOptimalPath(SourcePlace, DestinationPlace, NewParent, Distance, Time, Cost), write('\n'),
	% write('Distance='), write(Distance), write(','),
	% write('Time='), write(Time),  write(','),
	% write('Cost='), write(Cost), write('\n').

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% Defines different buses represented by -> [Number, Origin Place, DestinationPlaceination Place, Departure Time, Arrival Time, Distance, Cost]
% Change input buses here for trying different test cases
bus(121, 'Chandigarh', 'Jaipur', 14.5, 15, 120, 10).
bus(416, 'Chandigarh', 'Delhi', 16, 16.5, 80, 800).
bus(375, 'Jaipur', 'Agra', 16, 16.5, 200, 12).
bus(498, 'Agra', 'Delhi', 16, 16.5, 60, 9).
bus(547, 'Agra', 'Lucknow', 16, 16.5, 30, 8).
bus(748, 'Delhi', 'Panchkula', 16, 16.5, 90, 5).
bus(985, 'Panchkula', 'Mohali', 16, 16.5, 30, 13).