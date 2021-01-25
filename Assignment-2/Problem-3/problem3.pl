:-dynamic(optimalCostPath/1). % Dynamic predicate for minimium Distance
:-dynamic(optimalPaths/1). % Dynamic predicate for optimal path variable
:-dynamic(isMarked/1). % Dynamic predicate indicating the set of visited vertices
optimalCostPath(2147483647). % Setting optimal Distance to a very large value

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% Verify whether the given path is correct
verifyPath(ListOfNodes):-
	% Case where there is only 1 vertex in the list
	[H|T] = ListOfNodes, 
	isListEmpty(T),
	% Check whether the path ends correctly
	destinationNode(H). 

verifyPath(ListOfNodes):-
	[X1,X2|_] = ListOfNodes,
	doesEdgeExists(X1,X2,_),
	[_|T] = ListOfNodes,
	verifyPath(T).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% PART-C OF THE PROBLEM -> CALL isPathValid(ListOfNodes)
% Check if the given path is valid
isPathValid(ListOfNodes):-
	[H|_] = ListOfNodes,
	sourceNode(H),
	verifyPath(ListOfNodes),
	!.

isPathValid(_):-
	write("No such path exists!"),
	fail.

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE: If current node is an ending gate, print the path
findAllPathsUtility(CurrentNode,Path):-
	destinationNode(CurrentNode), % For base case, CurrentNode should be the destination gate
	append(Path,[CurrentNode],UpdatedPath), % Append Path and CurrentNode and store it to UpdatedPath variable
	printSinglePath("",UpdatedPath), % Print the path List
	fail.

 % Finds a path from gate CurrentNode
findAllPathsUtility(CurrentNode,Path):-
	% CurrentNode should not be destination node
	\+ destinationNode(CurrentNode), 
	append(Path,[CurrentNode],UpdatedPath),
	doesEdgeExists(CurrentNode, NextNode,_),
	\+ isMarked(NextNode),
	asserta(isMarked(NextNode)),
	% Recusive call with NextNode as starting node
	\+ findAllPathsUtility(NextNode,UpdatedPath),
	retract(isMarked(NextNode)),
	fail.

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% PART-A OF THE PROBLEM -> CALL findAllPaths()
% FIND ALL PATHS 
% first choose a starting node -> mark that as visited -> then computes all paths from that node ->
% then unmark the start node for backtracking
findAllPaths():-
	sourceNode(CurrentNode),
	asserta(isMarked(CurrentNode)),
	\+ findAllPathsUtility(CurrentNode,[]),
	retract(isMarked(CurrentNode)),
	fail.

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% PART-A OF THE PROBLEM -> CALL findOptimalPaths
% first verify that the database is correct (by looking for negative edges weights)
% then perform depth first search to find all paths
% Among them print the optimal paths and the optimal (minimum) distance
findOptimalPaths():-
	\+ checkForNegativeWeights,
	\+ performDFS,
	write("The following paths are optimal (shortest) :-"),
	nl,
	\+ printPaths,
	optimalCostPath(Z),
	printOptimalPathWeightSum(Z).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% Utility function for checking any negative weights in the graph
checkForNegativeWeights:-
	edgeWeights(_,_,X) , X < 0,
	print("Invalid Input -> Negative Edges Found"),
	nl.

% Checks if the list is empty or not
isListEmpty([]).

% returns the weight of the edge X -- Y if it exists
doesEdgeExists(X,Y,Z):- edgeWeights(X,Y,Z).
doesEdgeExists(X,Y,Z):- edgeWeights(Y,X,Z).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% If Distance is less than MinDistance, reset Optimals Paths
updateMinDistance(MinDistance, CurDistance, CurPath) :-

    MinDistance > CurDistance, % Check if Distance is less than Min Distance
    retract(optimalCostPath(MinDistance)), % Unset minDistance 
    asserta(optimalCostPath(CurDistance)), % Set minDistance to Distance 
    retractall(optimalPaths(_)), % Unset all paths in optimal Path
	assertz(optimalPaths(CurPath)). % Add path to optimalPathList

% If Distance is same as MinDistance, add path to list of optimal Paths
updateMinDistance(MinDistance, CurDistance, CurPath) :-

    MinDistance =:= CurDistance, % Check if minDistance is same as distance
	assertz(optimalPaths(CurPath)). % Add Path to optimalPathList

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% BASE CASE: If distance is greater than minDistance, don't proceed 
performDFSUtility(_,CurDistance,_):-
	optimalCostPath(MinDistance),
	CurDistance >= MinDistance,
	fail.

% BASE CASE: If G1 is ending gate, then update minimum distance
performDFSUtility(CurrentNode,CurDistance,Path):-
	destinationNode(CurrentNode),
	append(Path,[CurrentNode],UpdatedPath),	
	optimalCostPath(MinDistance),
	updateMinDistance(MinDistance,CurDistance,UpdatedPath),
	fail.

% Call depth first search from CurrentNode
performDFSUtility(CurrentNode,Sum,Path):-
	\+ destinationNode(CurrentNode),	
	append(Path,[CurrentNode],UpdatedPath),
    % Edge between Current Node and Next Node
	doesEdgeExists(CurrentNode, NextNode,Y),
	% findWeight(CurrentNode,NextNode,Y),
	\+ isMarked(NextNode),
	asserta(isMarked(NextNode)),
    % Update Path Length
	NextSum is Sum+Y,	
	\+ performDFSUtility(NextNode,NextSum,UpdatedPath),
	retract(isMarked(NextNode)),
	fail.

% Start from all the possible sources
performDFS:-
	sourceNode(CurrentNode),	
	asserta(isMarked(CurrentNode)),
	\+ performDFSUtility(CurrentNode,0,[]),
	retract(isMarked(CurrentNode)),
	fail.

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% UTILITY FUNCTIONS FOR PRINTING PATHS AND OPTIMAL DISTANCE
% Prints a single path
printSinglePath(_,[]).

printSinglePath(Prefix,[H|T]):-
	% Only 1 element left
	isListEmpty(T), 
	write(Prefix),
	write(H),
	nl.	

printSinglePath(Prefix,[H|T]):-
	% Some elements are left in list
	\+ isListEmpty(T), 
	format("~w~w -> ",[Prefix,H]),
	printSinglePath("",T).

% Prints all optimal paths
printPaths:-
	optimalPaths(OptimalPath),
	printSinglePath("Path: ",OptimalPath),
	fail.

% Prints the minimum distance if there exists a path from source to destination 
printOptimalPathWeightSum(OptimalDistance):-
	(OptimalDistance =:= 2147483647 -> write('No path exists from given source to destination'), false
                                ; write('Minimum Distance: '), write(OptimalDistance)).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% defining all the origin nodes
sourceNode('G1').
sourceNode('G2').
sourceNode('G3').
sourceNode('G4').

% defining the destination node
destinationNode('G17').

% defines the weights of all edges -> [Source Node, Destination Node, Weight]
edgeWeights('G1','G5',4).
edgeWeights('G2','G5',6).
edgeWeights('G3','G5',8).
edgeWeights('G4','G5',9).
edgeWeights('G1','G6',10).
edgeWeights('G2','G6',9).
edgeWeights('G3','G6',3).
edgeWeights('G4','G6',5).
edgeWeights('G5','G7',3).
edgeWeights('G5','G10',4).
edgeWeights('G5','G11',6).
edgeWeights('G5','G12',7).
edgeWeights('G5','G6',7).
edgeWeights('G5','G8',9).
edgeWeights('G6','G8',2).
edgeWeights('G6','G12',3).
edgeWeights('G6','G11',5).
edgeWeights('G6','G10',9).
edgeWeights('G6','G7',10).
edgeWeights('G7','G10',2).
edgeWeights('G7','G11',5).
edgeWeights('G7','G12',7).
edgeWeights('G7','G8',10).
edgeWeights('G8','G9',3).
edgeWeights('G8','G12',3).
edgeWeights('G8','G11',4).
edgeWeights('G8','G10',8).
edgeWeights('G10','G15',5).
edgeWeights('G10','G11',2).
edgeWeights('G10','G12',5).
edgeWeights('G11','G15',4).
edgeWeights('G11','G13',5).
edgeWeights('G11','G12',4).
edgeWeights('G12','G13',7).
edgeWeights('G12','G14',8).
edgeWeights('G15','G13',3).
edgeWeights('G13','G14',4).
edgeWeights('G14','G17',5).
edgeWeights('G14','G18',4).
edgeWeights('G17','G18',8).