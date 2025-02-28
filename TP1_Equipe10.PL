%Déroulement du Jeu
%À chaque tour, le joueur entre une commande pour se déplacer en indiquant une direction (h, b, g, d).
%Le jeu met à jour la position du joueur et affiche l’état du labyrinthe après chaque mouvement.
%Si le déplacement est impossible (mur ou dépasse limites), un message d’erreur s’affiche et le joueur doit entrer une nouvelle commande.
%Le joueur ne peut pas repasser par une case déjà visitée.
%Une fois la case d'arrivée (7,7) atteinte, le jeu est terminé.
%Si le chemin du joueur est optimal, un message de félicitations s'affiche.
%Sinon, la différence entre le chemin du joueur et le chemin optimal est affichée.


% définir un labyrinthe 7x7 avec des murs
mur(1,2).  mur(1,3).  mur(1,4).
mur(2,6).  
mur(3,2).  mur(3,3).  mur(3,4).
mur(4,2).
mur(5,2).  mur(5,4). mur(5,5). mur(5,6).
mur(6,4).  mur(6,5). mur(6,6).
mur(7,1).  mur(7,2).

% vérifier si une position est un mur
est_mur(X,Y) :- mur(X,Y).

% vérifier si une position est accessible
accessible(X,Y) :-
    X > 0, X =< 7,
    Y > 0, Y =< 7,
    \+ est_mur(Y,X).

% définir le départ et l'arrivée
depart((1,1)).
arrivee((7,7)).

% distance qui détermine notre heuristique
heuristique((X,Y), H) :-
    arrivee((XF,YF)),
    H is abs(X - XF) + abs(Y - YF).

% déplacements possibles
deplacement((X,Y), h, (X, Y2)) :- Y2 is Y-1, accessible(X,Y2).
deplacement((X,Y), b, (X, Y2)) :- Y2 is Y+1, accessible(X,Y2).
deplacement((X,Y), g, (X2, Y)) :- X2 is X-1, accessible(X2,Y).
deplacement((X,Y), d, (X2, Y)) :- X2 is X+1, accessible(X2,Y).

% qlgorithme A* : exploration des chemins en tenant compte du coût à chaque état
a_star([(_, (X,Y), Chemin) | _], Chemin) :- 
    arrivee((X,Y)). % une fois arrivé, on retourne le chemin tracé
a_star([(G, (X,Y), Chemin) | Reste], Solution) :-
    findall((NC, (XN, YN), [(XN, YN) | Chemin]),
        (deplacement((X,Y), _,(XN,YN)), % génèrer tous les déplacements possibles
         \+ member((XN,YN), Chemin), % éviter les cases déjà visitées
         heuristique((XN,YN), H), % calculer l’heuristique
         NC is G + 1 + H), % mettre à jour le coût total G + H
    NouveauxChemins),
    append(Reste, NouveauxChemins, ListeTriee),
    sort(ListeTriee, ListeTriee_s), % trier en se basant sur le coût estimé total
    a_star(ListeTriee_s, Solution).

% fonction principale pour résoudre le labyrinthe
resoudre(Chemin) :-
    depart(D),
    heuristique(D, H),
    a_star([(H, D, [D])], Chemin).
afficher_labyrinthe((PX,PY)) :- % affichage du labyrinthe
    nl, write("  1 2 3 4 5 6 7"), nl,
    forall(between(1,7,Y),
        (write(Y), write(" "),
         forall(between(1,7,X),
            ( (PX == X, PY == Y) -> write("P ") ;
              arrivee((X,Y)) -> write("X ") ;
              est_mur(Y,X) -> write("* ") ;
              write(". ") )
         ), nl)
    ), nl.

% jeu
jouer :-
    write(" Bienvenue dans le jeu du labyrinthe !"), nl,
    depart(Depart),
    afficher_labyrinthe(Depart),
    boucle_de_jeu(Depart, [(1,1)]).

% Boucle du jeu (le joueur entre des commandes pour avancer)
boucle_de_jeu(Position, Chemin) :-
    arrivee(Position),
    write(" Félicitations ! Vous avez atteint la sortie !"), nl,
    comparer_chemin(Chemin).

boucle_de_jeu(Position, Chemin) :-
    write("Entrez un déplacement (h: haut, b: bas, g: gauche, d: droite) : "), nl,
    read(Direction),
    (   
        deplacement(Position, Direction, NouvellePosition) -> 
        (   \+ member(NouvellePosition, Chemin) ->
                afficher_labyrinthe(NouvellePosition),
                boucle_de_jeu(NouvellePosition, [NouvellePosition | Chemin])
            ;
            write(" Vous êtes déjà passé par là ! Essayez une autre direction."), nl,
            boucle_de_jeu(Position, Chemin)
        )
        ;
        write(" Déplacement impossible ! Essayez une autre direction."), nl,
        boucle_de_jeu(Position, Chemin)
    ).

% faire la comparaison avec le chemin tracé par le joueur
comparer_chemin(Joueur) :-
    resoudre(Optimal),
    length(Joueur, LJ),
    length(Optimal, LO),
    nl,
    write(" Résultat final : "), nl,
    write("Votre chemin : "), write(Joueur), nl,
    write("Chemin optimal : "), write(Optimal), nl,
    (   
        LJ =:= LO -> write("Bravo ! Vous avez trouvé le chemin optimal !"), nl
        ;
        D is LJ - LO,
        format("Votre chemin a ~w déplacements en plus que le chemin optimal.\n", [D])
    ).
