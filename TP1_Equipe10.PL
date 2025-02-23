% Définition du labyrinthe 7x7 avec des murs (*)
mur(1,2).  mur(1,3).  mur(1,4).
mur(2,6).  
mur(3,2).  mur(3,3).  mur(3,4).
mur(4,2).
mur(5,2).  mur(5,4). mur(5,5). mur(5,6).
mur(6,4).  mur(6,5). mur(6,6).
mur(7,1).  mur(7,2).

% Vérifie si une position est un mur
est_mur(X,Y) :- mur(X,Y).

% Vérifie si une position est accessible (pas un mur et dans les limites)
accessible(X,Y) :-
    X > 0, X =< 7,
    Y > 0, Y =< 7,
    \+ est_mur(X,Y).

% Déplacements possibles : haut, bas, gauche, droite
deplacement((X,Y), (X2,Y)) :- X2 is X+1, accessible(X2,Y).
deplacement((X,Y), (X2,Y)) :- X2 is X-1, accessible(X2,Y).
deplacement((X,Y), (X,Y2)) :- Y2 is Y+1, accessible(X,Y2).
deplacement((X,Y), (X,Y2)) :- Y2 is Y-1, accessible(X,Y2).

% Définition du départ et de l'arrivée
depart((1,1)). % Départ en haut à gauche
arrivee((7,7)). % Arrivée en bas à droite

% Distance de Manhattan pour estimer le coût restant jusqu’à l’arrivée
heuristique((X,Y), H) :-
    arrivee((XF,YF)),
    H is abs(X - XF) + abs(Y - YF).

% Algorithme A* : exploration des chemins en tenant compte du coût
a_star([(_, (X,Y), Chemin) | _], Chemin) :- 
    arrivee((X,Y)). % Si on est arrivé, on retourne le chemin

a_star([(G, (X,Y), Chemin) | Reste], Solution) :-
    findall((NC, (XN, YN), [(XN, YN) | Chemin]),
        (deplacement((X,Y), (XN,YN)), % Génère tous les déplacements possibles
         \+ member((XN,YN), Chemin), % Évite de repasser sur les cases déjà visitées
         heuristique((XN,YN), H), % Calcul de l’heuristique
         NC is G + 1 + H), % Mise à jour du coût total G + H
    NouveauxChemins),
    append(Reste, NouveauxChemins, ListeTriee),
    sort(ListeTriee, ListeTrieeTriee), % Trie par coût estimé total
    a_star(ListeTrieeTriee, Solution).

% Fonction principale pour résoudre le labyrinthe
resoudre(Chemin) :-
    depart(D),
    heuristique(D, H),
    a_star([(H, D, [D])], Chemin).
