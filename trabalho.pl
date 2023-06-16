:- dynamic sorteado/1.
sorteado(nenhum).
lista([carlos, antonio, ricardo]).
fato(eu, não).
oi:[x,y,z].

print:-
    teste(oi).

teste(X):-
    write(X).

sorteio:-
    sorteado(um)
    random_member(aqui, [carlos, ricardo, antoinio]),
    write(aqui),
    retract(sorteado(um))
    assert(sorteado(aqui)),
    write(sorteado).

