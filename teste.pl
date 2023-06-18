:-dynamic ondeEstou/1, status_Crime/2, visitou/2.
ondeEstou(x2).


busca_Lista(Elemento, [Elemento|_]).
busca_Lista(Elemento,[_|Cauda]):-
    busca_Lista(Elemento, Cauda).



/* personagens([sr_Marinho, dona_Branca, srta_Rosa, mordomo_James, dona_Violeta, sergio_Soturno, sargento_Bigode, tony_Gourmet]).
 armas([corda, revolver, candelabro, soco_ingles, cano, chave_ingles, faca, pe_de_cabra]).
 a1 = biblioteca
 a3 = sala de estar
 c1 = cozinha
 c3 = salão de jogos
 f1 = conservatorio
 f3 = cozinha
 h2 = escritorio
    ATT 16/06 agora preciso avisar se o jogador acertou ou não cada um do tipo
    palpite dele foi = dona_Violeta
                       corda
    caso ele digite a pessoa errada, ele já deve corrigir, vai ser melhor do que ter que ficar repetindo o palpite toda hora
    ATT 16/06 - mais tarde
    pretendo colocar o status como uma forma de saber se o crime das salas foram resolvidos, isso afeta:
    as descrições, como estou fazendo uma história narrativa, algumas coisas precisam mudar na descrição.
    Além disso, é possível verificar se o jogador resolveu todos os crimes antes de conseguir avançar no jogo.

    Outro tópico, preciso fazer uma lista de dicas, conforme o nome do personagem aparecer, pra tentar deixar mais dinâmico a advinhações
    Falta melhorar a formatação do texto.

    ATT 17/06
    fiz os status, mas ainda não arrumei todos. Agora eles se tornaram visitou, crime_Resolvido. É preciso relacionar eles com a questão da passagem de fase e 
    continuar com as descrições.

    ATT 18/06
    Não consegui fazer a relação para impedir o jogador de entrar no corredor caso nao tenha resolvido todos os crimes. Além disso, atualizar o status do 'visitou' quebrou o programa,
    o jogador estava dando 'saltos', saia de a2 para g2 direto.


*/
/*Listando os personagens e armas de cada sala*/
personagem([a1, sr_Marinho, dona_Branca, mordomo_James]).
personagem([a3, srta_Rosa, dona_Violeta, sergio_Soturno]).
personagem([c1, sargento_Bigode, tony_Gourmet, sr_Marinho]).
personagem([c3, dona_Branca, dona_Violeta, srta_Rosa]).
personagem([f1, tony_Gourmet, sergio_Soturno, mordomo_James]).
personagem([f3, sr_Marinho, srta_Rosa, sr_Marinho]).
personagem([h2, eu, policial_Carter, sr_Yellow]).

arma([a1, soco_ingles, cano, faca]).
arma([a3, corda, revolver, candelabro]).
arma([c1, soco_ingles, chave_inglesa, pe_de_cabra]).
arma([c3, candelabro, revolver, cano]).
arma([f1, tesoura, soco_ingles, faca]).
arma([f3, cano, faca]).
arma([h2, canivete]).

personagens(Posicao) :-
    personagem([Posicao|Resto]),
    write('Personagens: '), write(Resto), nl.


armas(Posicao) :-
    arma([Posicao|Resto]),
    write('Armas: '), write(Resto), nl.

palpite(Onde_estou) :-
    personagem([Onde_estou|Personagens]), nl,
    arma([Onde_estou|Armas]), nl,
    random_member(X, Personagens),
    random_member(Y, Armas),
    verifica_palpite(X, Y).


verifica_arma(X):-
    read(Arma),
    (Arma = X->
        write("Policial: -Tudo certo por aqui detetive. obrigado pelo seu trabalho. Rapazes, podem levar."), nl;
        write("Isso não soa correto..."), nl,
        verifica_arma(X)
    ).

verifica_palpite(X, Y):-
    write("Diante do momento de ansiedade, você responde quem cometeu o crime: "),
    ondeEstou(Onde_estou),
    read(Personagem),
    (Personagem = X ->
        write("Você acertou o culpado, você tem certeza!"),
        write("Todos ficam olham assustados e você fala com qual arma: "),
        read(Arma),
        (Arma = Y -> 
            write(Personagem), write(" ficou muito nervoso(a) e gritou "), 
            fala(Personagem), 
            write("Policial: -Tudo certo por aqui detetive. obrigado pelo seu trabalho. Rapazes, podem levar.");

            write("Você olha novamente para as armas no local do crime, algo lhe diz que "), write(Arma), write(" não é a escolha certa..."),
            armas(Onde_estou), 
            verifica_arma(Y)
        );
        write("Você iria falar "), write(Personagem), write(" mas algo te alertou que aquela não é a reposta..."),
        personagens(Onde_estou),
        verifica_palpite(X, Y)
    ).

modoDetetive:-
    ondeEstou(Onde_estou),
    personagens(Onde_estou),
    armas(Onde_estou), 
    palpite(Onde_estou),
    retract(status_Crime(Onde_estou, nao_Resolvido)),
    assert(status_Crime(Onde_estou, resolvido)),
    nl, !.

modoDetetive:-
    write("Não há nada para ver aqui."), nl.
    
jogo:-
    write('Bem-vindo ao jogo do detetive.'),
    write('Você entrará na visão de um detetive famoso e terá que descobrir 7 crimes que aconteceram numa mansão de uma familia famosa, os Gripp^s.
    Cada crime ocorre em uma sala, as salas podem ter passagem secreta para outras salas ou não.
    Além das salas, há as casas chamadas Lugares, que são apenas células de passagem no tabuleiro.
    Para ver o tabuleiro basta escrever tabuleiro.
    Você pode ser mover para a direita(d), esquerda(e), cima(c), baixo(b) e pela passagem secreta(ps).
    Você pode pedir para descrever a sala em que você está digitando descreva.
    Você deve usar o modoDetetive para saber quais são os personagens e armas que estão presentes na cena do crime e fazer seu palpite.
    Caso você acerte, você pode continuar para outra sala, caso contrario, você precisa continuar na sala e resolver.
    Lembrando que existe 2 "fases" nesse jogo, você passa para segunda fase indo para os corredores (d2 e e2), mas você só pode acessá-los caso vc tenha resolvido os crimes da primeira fase.
    Para ver aonde você começa, digite descreva.
    Bom jogo e Boa sorte detetive...'), nl.

/*fazendo o tabuleiro*/
caminho(x2, d, a2).

/*Caminho da posição A*/
caminho(a1, d, b1).
caminho(a1, ps, c3).
caminho(a2, b, a3).
caminho(a2, d, b2).
caminho(a3, c, a2).
/*Caminho da posição B*/
caminho(b1, e, a1).
caminho(b1, b, b2).
caminho(b2, c, b1).
caminho(b2, b, b3).
caminho(b2, d, c2).
caminho(b2, e, a2).
caminho(b3, c, b2).
caminho(b3, d, c3).
/*Caminho da posição C*/
caminho(c1, b, c2).
caminho(c2, e, b2).

caminho(c2, d, d2).

caminho(c3, e, b3).
caminho(c3, ps, a1).
/*Caminho da posição D e E (corredores)*/
caminho(d2, d, e2).
caminho(e2, d, f2).
/*Caminho da posição F*/
caminho(f1, d, g1).
caminho(f2, d, g2).
caminho(f2, b, f3).
caminho(f3, c, f2).
/*Caminho da posição G*/
caminho(g1, e, f1).
caminho(g1, b, g2).
caminho(g2, d, h2).
caminho(g2, e, f2).


/*Status do crime e se as células já foram visitadas*/
status_Crime(a1, nao_Resolvido).
status_Crime(a3, nao_Resolvido).
status_Crime(c1, nao_Resolvido).
status_Crime(c3, nao_Resolvido).
status_Crime(f1, nao_Resolvido).
status_Crime(f3, nao_Resolvido).
status_Crime(h2, nao_Resolvido).

status_Fase1([nao_Resolvido, nao_Resolvido, nao_Resolvido, nao_Resolvido]).

status_Fase2([nao_Resolvido, nao_Resolvido]).


visitou(x2, nao).
visitou(a1, nao).
visitou(a2, nao).
visitou(a3, nao).
visitou(b1, nao).
visitou(b2, nao). 
/*não precisa, pois ele é um local com muitos caminhos possiveis, mas irei deixar para não ter erro na movimentação*/
visitou(b3, nao).
visitou(c1, nao).
visitou(c2, nao).
visitou(c3, nao).
visitou(d2, nao).
visitou(e2, nao).
visitou(f1, nao).
visitou(f2, nao).
visitou(f3, nao).
visitou(g2, nao).
visitou(g3, nao).
visitou(h2, nao).



/*Regra de movimentação*/
c:- movimentacao(c).
b:- movimentacao(b).
e:- movimentacao(e).
d:- movimentacao(d).
ps:- movimentacao(ps).

/*Movimentação*/
movimentacao(X):-
    ondeEstou(Onde_estou),
    caminho(Onde_estou, X, Vou_aqui),
    retract(ondeEstou(Onde_estou)),
    assert(ondeEstou(Vou_aqui)),
    /*visitou(Onde_estou, Y),
    (Y = nao ->
        retract(visitou(Onde_estou, nao)),
        assert(visitou(Onde_estou, sim));
        write("OK!")
    ),*/
    descreva,
    nl.

movimentacao(_):-
    write('Algo lhe diz que bater em uma parede não é a melhor direção para andar...'), nl, fail.

/*Descrições do ambiente e jogo*/
descreva:- 
    ondeEstou(Onde_estou),
    descricao(Onde_estou).

descricao(x2):-
    write('Chove forte e faz frio nesta noite. Você está com seu casaco usual e encara de longe a mansão dos senhores. Uma noite catastrófica e só você pode resolver o que aconteceu.'),
    nl,
    write('Você chega em frente as grandes portas da entrada da mansão, ao que parece, você só tem um caminho para seguir (d)...').

descricao(a2):-
    visitou(a2, X),
    (X = sim->
        write("Há uma porta sua direita para a sala de estar (b) e o hall a sua frente (d)."), nl;
        write('Você acaba de entrar na mansão. Há uma porta a sua direita (b) que da acesso a sala de estar e mais pra frente, o que parece, tem um hall.'), nl,
        write('No hall você viu alguma figura estranha tentando olhar discretamente para você, sua mente está em alerta.'), nl
    ).
descricao(a1):-
    visitou(a1, X),
    (X = sim ->
        write('A biblioteca continua bagunçada. A porta pequena parece ser um acesso secreto para alguma sala (ps).
        -Não se preocupde detetive, nós cuidados do resto, vá resolver o resto dos crime! - exclama Geronimo.'), nl;
        write('Você entra na Biblioteca e a primeira coisa que vê são todos os livros caídos das prateleiras e uma mancha de sangue na parede, além disso, há uma escada
        que desce para, ao que parece, uma sala mais reservada com um sofá.
        O policial Geronimo relata:
        -Detetive. - Ele cumprimenta - Alguém não estava muito feliz com a biblioteca, descendo as escadas você vai poder enxergar melhor.
        Ao descer você vê uma moça, não aparentava ter mais de 20 anos, estava estirada no sofá que outrora fora branco.
        Algo chama sua atenção, há uma porta pequena, é preciso agachar para conseguir passar.'), nl

    ).
descricao(a3):-
    visitou(a3, X),
    (X = sim ->
        write('Franciso se espanta com o seu retorno e pergunta:
        -Oh, Detetive! Já terminou os outros casos? Não? A gente cuida daqui, não se preocupe.'), nl;
        write('Ao entrar na Sala de Estar você se depara com o Policial Francisco, que diz:
        -Oh, detetive! Chegou bem a tempo, sei que a cena é feia e precisamos da sua ajuda!
        Ao olhar com mais cuidado para o sofá no meio da sala, você percebe que a mesa de centro estava quebrada e havia rastros de sangue até o
        rack da Tv e ali havia um corpo...'), nl
    ).
descricao(b1):-
    visitou(b1, X),
    (X = sim ->
        write('O quadro na parede continua imponente e um sentimento de raiva, brevemente, lhe ocorre. Mas não importa, você tem mais o que fazer.
        Você pode voltar para o hall (b) ou entrar na biblioteca novamente (d).'), nl;
        write('Você percebe um quadro gigante da familia Gripp, parece que o bisavô Victor era bem excentrico.
        A sua esquerda há uma porta dupla entreaberta com um pequeno defeito na fechadura, ela parece ter sido aberta de forma muito minuciosa...
        A sua direita existe uma mesa pequena com um copo de água e uma carta aberta do lado:
        "As coisas estão dificéis, não sabemos até onde ele vai pra tentar desvender todo o mistério da familia Yellow... Tenho medo do que ele pode fazer...
        Ass. R.
        Você pega a carta e guarda no bolso do casaco.
        Agora você decide, voltar ou seguir para a sala? (b-e)"'), nl

    ).
descricao(b2):-
    write('Você chega no hall. Olhando pra frente você percebe que tem um acesso para outro cômodo (d), que você julgou ser a cozinha.
    Seguindo acima (c) há um quadro grande e um acesso, mas você precisa chegar mais perto caso queira ver.
    Abaixo (b) há um acesso e uma janela bem grande que dá para ver o quintal da casa'), nl.

descricao(b3):-
    visitou(b3, X),
    (X = sim ->
        write('Você olha pela janela mais um vez, parece que o tempo está piorando. A movimentação na sala dos jogos continua grande. Você pensa que pode entrar novamente na sala (d)
        ou voltar para o hall (c)'), nl;
        write('Você chega mais perto da janela, não consegue ver o quintal direito por causa da chuva. Há uma pequena mancha de gordura, mas não importa, você apenas limpa a pequena mancha.
        A sua direita há uma entrada para o salão de jogos. Você vê a movimentação dos policiais dentro da sala e então decide... (d)'), nl
    ).

descricao(c1):-
    visitou(c1, X),
    (X = sim ->
        write('Vin lhe pergunta:
        -Já voltou? Não se preocupe, nós cuidados daqui... hm... aquele papel, o que era? parece que te deixou um pouco desconcertado.
        Você não fala nada, apenas olha a cena do crime mais uma vez.'), nl;
        write('Ao entrar na cozinha depressa, concentrado no papel, o policial Vin esbarra em você e derruba seu distintivo.
        -Perdão Detetive, não te vi entrar! - diz ele com os olhos um pouco assustado, talvez pela cena que viu ou talvez por ter se esbarrado em algo sem ver.
        Você se abaixa para pegar o distintivo e pega o papel ao mesmo tempo, quando lê:
        9823-... Não dava para ver o resto, estava borrado, Vin pergunta:
        -O que é isso detetive?
        Você guarda o papel e olha para a cena do crime.
        O corpo do chefe de cozinha estava estirado no chão, mas nenhuma poça de sangue, era dificil saber o que aconteceu, mas você sabe como e quem...'), nl
    ).
descricao(c2):-
    visitou(c2, X),
    (X = sim ->
        write('Você encara o corredor, parece que ele lhe espera ali. (d)'), nl;
        write('Você olha adiante e vê o corredor (d) que é familiar para você e ao mesmo tempo você sente um frio na espinha. Ao desviar o olhar você vê a porta que dá acesso a cozinha (c).
        Ao olhar para a pequena janela que tem na porta você vê um pedaço de um papel, debaixo de um armário de cozinha que fica no chão, provavelmente passou despercebido pelos outros.
        Você então, rapidamente...(c)'), nl
    ).
descricao(c3):-
    visitou(a1, X),
    (X = sim ->
        write('Mais uma vez no salão de jogos, você percebe que atrás da máquina de caça nível tem uma passagem secreta(ps).'), nl;
        write('Ao entrar no salão de jogos algo te chama muita a atenção, havia uma pequena marca de um movel arrastado, ao seguir a pequena pista você vê uma máquina de caça-níquel.
        Ao olhar a cena do crime, a mesa principal estava manchada de sangue e molhada por algo que parecia bebidas alcoolicas e, debaixo da mesa, havia um homem, grisalho, 53 anos.
        Sem vida, o corpo inerte, manchas de sangue apenas na parte de cima da mesa.'), nl
    ).
descricao(d2):-
    write('Você abre a porta do corredor. Ele parece maior do que é, você olha a sua direita e vê o jardim, dessa vez uma árvore bem grande, balançando por conta do temporal lá fora.
    Você só tem uma opção... Seguir em frente, mas algo parece que não quer deixar você seguir, um sentimento estranho... Mas, você precisa ir (d)'), nl.
descricao(e2):-
    write('No final do corredor você tem pequenos lapsos de já ter estado lá, já ter feito esse caminho antes. De fato, você já veio outra vez aqui, num dia claro, para
    conversar com sr... você não se lembra, ou se recusa lembrar? Mas não era isso, era outra coisa, outro dia... Você chega até o final do corredor, você precisa
    avançar (d).'), nl.
descricao(f1):-
    write('Conservatorio'), nl.
descricao(f2):-
    write(''), nl.
descricao(f3):-
    write('cozinha'), nl.
descricao(g1):-
    write(''), nl.
descricao(g2):-
    write(''), nl.
descricao(h2):-
    write('escritorio'), nl.

tabuleiro:-
    write("
          X    A     B     C    D   E    F      G     H
            +-----+-----+-----+       +-----+-----+
            |     |     |     |       |     |     |
      1     |  S  =  L  |  S  |       |  S  =  L  |
            |     |     |     |       |     |     |
            |     |     |     |       |     |     |
        +---+-----+     +=====+-------+-----+     +-----+
      2 | D =  L     L     L  = CO CO =  L     L  =   S |
        +---+=====+     +-----+-------+=====+-----+-----+
            |     |     |     |       |     |
            |     |     |     |       |     |
      3     |  S  |  L  =  S  |       |  S  |
            |     |     |     |       |     |
            +-----+-----+-----+       +-----+
    "), nl,
    write("
        D -> Aonde o detetive começa;
        L-> Lugar, destinado apenas a locomoção;
        S -> Salas onde os crimes aconteceram;
        CO-> Corredor de passagem para próxima fase;
        ATENÇÃO -> algumas salas tem passagem secreta, tente usar ps; 
        ! acessos são células L que tem entrada para uma sala !
        = : porta para salas
        a1 : biblioteca
        a3 : sala de estar
        c1 : cozinha
        c3 : salão de jogos
        f1 : conservatorio
        f3 : cozinha
        h2 : escritorio
    "), ondeEstou(X),
    write("aonde você está: "), write(X), nl.

    


















