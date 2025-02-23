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

