% family_tree.pl — Family Tree Program for Online Compiler

% ---------- Basic Facts ----------
male(john).
female(mary).
male(david).
female(alice).
male(bob).
female(carol).
female(emma).
male(george).
male(frank).
female(helen).
female(gina).
male(harry).
female(irene).

parent(john, alice).
parent(mary, alice).
parent(john, bob).
parent(mary, bob).

parent(alice, frank).
parent(david, frank).
parent(alice, irene).
parent(david, irene).

parent(bob, emma).
parent(carol, emma).

parent(emma, gina).
parent(george, gina).

parent(frank, harry).
parent(helen, harry).

% ---------- Derived Rules ----------
child(C, P) :- parent(P, C).
grandparent(G, C) :- parent(G, P), parent(P, C).
sibling(X, Y) :- parent(P, X), parent(P, Y), X \= Y.
cousin(X, Y) :- parent(PX, X), parent(PY, Y), sibling(PX, PY), X \= Y.

% Recursive descendants
ancestor(A, D) :- parent(A, D).
ancestor(A, D) :- parent(A, X), ancestor(X, D).
descendant(D, A) :- ancestor(A, D).

% ---------- Automatic Output ----------
:- initialization(main).

main :-
    write('--- Family Tree Relationship Tests ---'), nl,
    write('Children of Alice: '), findall(C, child(C, alice), L1), write(L1), nl,
    write('Siblings of Alice: '), findall(S, sibling(alice, S), L2), write(L2), nl,
    write('Grandparents of Harry: '), findall(G, grandparent(G, harry), L3), write(L3), nl,
    (cousin(irene, gina) -> W1 = 'Yes'; W1 = 'No'),
    write('Are Irene and Gina cousins? '), write(W1), nl,
    write('Descendants of John: '), findall(D, descendant(D, john), L4), write(L4), nl,
    halt.
