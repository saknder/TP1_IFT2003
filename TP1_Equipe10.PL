% definition du labyrinthe 7x7 avec des murs (*)
mur(1,2).  mur(1,3).  mur(1,4).
mur(2,6).  
mur(3,2).  mur(3,3).  mur(3,4).
mur(4,2).
mur(5,2).  mur(5,4). mur(5,5). mur(5,6).
mur(6,4).  mur(6,5). mur(6,6).
mur(7,1).  mur(7,2).

% verifie si une position est un mur
est_mur(X,Y) :- mur(X,Y).

% verifie si une position est accessible (pas un mur et dans les limites)
accessible(X,Y) :
    X > 0, X =< 7,
    Y > 0, Y =< 7,
    \+ est_mur(X,Y).

% Mouvement possible : haut, bas, gauche, droite
deplacement((X,Y), (X2,Y)) :- X2 is X+1, accessible(X2,Y).
deplacement((X,Y), (X2,Y)) :- X2 is X-1, accessible(X2,Y).
deplacement((X,Y), (X,Y2)) :- Y2 is Y+1, accessible(X,Y2).
deplacement((X,Y), (X,Y2)) :- Y2 is Y-1, accessible(X,Y2).





% Définir les cases et les obstacles
case(1, 1).
case(1, 5).
case(1, 6).
case(1, 7).
case(2, 1).
case(2, 2).
case(2, 3).
case(2, 4).
case(2, 5).
case(2, 7).
case(3, 1).
case(3, 5).
case(3, 6).
case(3, 7).
case(4, 1).
case(4, 3).
case(4, 4).
case(4, 5).
case(4, 6).
case(4, 7).
case(5, 1).
case(5, 3).
case(5, 7).
case(6, 1).
case(6, 3).
case(6, 7).
case(7, 1).
case(7, 2).
case(7, 3).
case(7, 4).
case(7, 5).
case(7, 6).
case(7, 7). % Sortie

obstacle(1, 2).
obstacle(1, 3).
obstacle(1, 4).
obstacle(2, 6).
obstacle(3, 2).
obstacle(3, 3).
obstacle(4, 2).
obstacle(5, 2).
obstacle(5, 4).
obstacle(5, 5).
obstacle(6, 2).
obstacle(6, 4).
obstacle(6, 

% Définir les mouvements possibles
mouvement((X, Y), (X1, Y)) :- X1 is X + 1, case(X1, Y).
mouvement((X, Y), (X1, Y)) :- X1 is X - 1, case(X1, Y).
mouvement((X, Y), (X, Y1)) :- Y1 is Y + 1, case(X, Y1).
mouvement((X, Y), (X, Y1)) :- Y1 is Y - 1, case(X, Y1).

% Heuristique de la distance de Manhattan
heuristique((X, Y), (Xf, Yf), H) :- H is abs(X - Xf) + abs(Y - Yf).

% Algorithme A*
a_star(Initial, But, Chemin) :-
    a_star_recherche([[Initial]], But, CheminReversed),
    reverse(CheminReversed, Chemin).

a_star_recherche([[But | CheminRestant] | _], But, [But | CheminRestant]).
a_star_recherche([Chemin | AutresChemins], But, CheminResultat) :-
    Chemin = [Actuel | _],
    findall([Suivant, Actuel | CheminRestant],
            (mouvement(Actuel, Suivant),
             \+ member(Suivant, [Actuel | CheminRestant])),
            NouvellesEtapes),
    heuristiques_etapes(NouvellesEtapes, But, NouvellesEtapesAvecHeuristique),
    append(AutresChemins, NouvellesEtapesAvecHeuristique, TousChemins),
    predsort(compare_chemins, TousChemins, CheminsTries),
    a_star_recherche(CheminsTries, But, CheminResultat).

heuristiques_etapes([], _, []).
heuristiques_etapes([[Etat | CheminRestant] | Autres], But, [[Etat, Heuristique, Etat | CheminRestant] | NouvellesEtapes]) :-
    heuristique(Etat, But, Heuristique),
    heuristiques_etapes(Autres, But, NouvellesEtapes).

compare_chemins(<, [_, H1, _ | _], [_, H2, _ | _]) :- H1 < H2.
compare_chemins(>, [_, H1, _ | _], [_, H2, _ | _]) :- H1 >= H2.

% Exemple de recherche du chemin
?- a_star((1, 1), (7, 7), Chemin).
