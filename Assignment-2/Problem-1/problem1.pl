% checkHalfSister(A, B) :- Returns true if A is half-sister of B
checkHalfSister(A, B) :-
    % A should be female
    female(A),
    % A and B should have only one common parent
    % C is the common parent here
    parent(C, A),
    parent(C, B),
    parent(E, A),
    parent(F, B),
    % Check whether other parent is different
    not(E = F),
    not(E = C),
    not(F = C),
    % Check whether they are different individuals
    not(A = B).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% checkUncle(A, B) :- Returns true if A is uncle of B
checkUncle(A, B) :-
    % A should be male
    male(A),
    % Parent of A and grandparent of B should be common
    % D would be grandparent of B and parent of A
    parent(C, B),
    parent(D, C),
    parent(D, A),
    % A should not be parent of B
    not(parent(A, B)).

% -----------------------------------------------------------------------------------------------------------------------------------------------------

% female(A) :- A is female
female(shivkami).
female(avantika).

% male(A) :- A is male
male(kattappa).
male(jolly).
male(bahubali).

% parent(A, B) :- A is parent of B
parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,kattappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).