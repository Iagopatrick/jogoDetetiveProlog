:-dynamic ondeEstou/1, status_Crime/2.
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
    dica(X),
    dica(Y),
    verifica_palpite(X, Y).


verifica_arma(X, Personagem):-
    read(Arma),
    (Arma = X->
        fala(Personagem), 
        write("Policial: -Tudo certo por aqui detetive. obrigado pelo seu trabalho. Rapazes, podem levar."), nl;
        write("Isso não soa correto..."), nl,
        verifica_arma(X, Personagem)
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
            
            fala(Personagem), 
            write("Policial: -Tudo certo por aqui detetive. obrigado pelo seu trabalho. Rapazes, podem levar.");

            write("Você olha novamente para as armas no local do crime, algo lhe diz que "), write(Arma), write(" não é a escolha certa..."),nl,
            armas(Onde_estou), 
            verifica_arma(Y, Personagem)
        );
        write("Você iria falar "), write(Personagem), write(" mas algo te alertou que aquela não é a reposta..."), nl,
        personagens(Onde_estou),
        verifica_palpite(X, Y)
    ).

modoDetetive:-
    ondeEstou(Onde_estou),
    status_Crime(Onde_estou, nao_Resolvido),
    personagens(Onde_estou),
    armas(Onde_estou), 
    palpite(Onde_estou),
    retract(status_Crime(Onde_estou, nao_Resolvido)),
    assert(status_Crime(Onde_estou, resolvido)),
    nl, !.

modoDetetive:-
    write("Não há nada para ver aqui."), nl.
    
jogar:-
    write('Bem-vindo ao jogo do detetive.'),
    write('Você entrará na visão de um detetive famoso e terá que descobrir 7 crimes que aconteceram numa mansão de uma familia famosa, os Yellows.
        *Cada crime ocorre em uma sala, as salas podem ter passagem secreta para outras salas ou não.
        *Para ver o tabuleiro basta escrever tabuleiro.
        *Você pode ser mover para a direita(d), esquerda(e), cima(c), baixo(b) e pela passagem secreta(ps).
        *Você pode pedir para descrever a sala em que você está digitando descreva.
        *Você deve usar o modoDetetive para fazer seu palpite.
        *Caso você acerte, você pode continuar para outra sala, caso contrario, você precisa continuar na sala e resolver.
        *Lembrando que existe 2 "fases" nesse jogo, você passa para segunda fase indo para os corredores (d2 e e2), mas você só pode acessá-los caso vc tenha resolvido os crimes da primeira fase.
        *Para ver aonde você começa, digite descreva.
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
caminho(c2, c, c1).

caminho(c2, d, d2):-
    status_Crime(a1, resolvido),
    status_Crime(a3, resolvido),
    status_Crime(c1, resolvido),
    status_Crime(c3, resolvido), !.
caminho(c2, d, d2):-
    write("Melhor você resolver os crimes desses comodos para depois passar pelo corredor..."), nl, fail.

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
caminho(g2, d, h2):-
    status_Crime(f1, resolvido),
    status_Crime(f3, resolvido).    
caminho(g2, e, f2).


/*Status do crime e se as células já foram visitadas*/
status_Crime(a1, nao_Resolvido).
status_Crime(a3, nao_Resolvido).
status_Crime(c1, nao_Resolvido).
status_Crime(c3, nao_Resolvido).

status_Crime(f1, nao_Resolvido).
status_Crime(f3, nao_Resolvido).

status_Crime(h2, nao_Resolvido).













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
    descreva,
    nl, !.

movimentacao(_):-
    write('Algo lhe diz que bater em uma parede não é a melhor direção para andar...'), nl, fail.

/*Descrições do ambiente e jogo*/
descreva:- 
    ondeEstou(Onde_estou),
    descricao(Onde_estou),
    !.

descricao(x2):-
    write('Chove forte e faz frio nesta noite. Você está com seu casaco usual e encara de longe a mansão dos senhores. Uma noite catastrófica e só você pode resolver o que aconteceu.'),
    nl,
    write('Você chega em frente as grandes portas da entrada da mansão, ao que parece, você só tem um caminho para seguir (d)...'), nl.

descricao(a2):-
    write('Você acaba de entrar na mansão. Há uma porta a sua direita (b) que da acesso a sala de estar e mais pra frente, o que parece, tem um hall.'), nl,
    write('No hall você viu alguma figura estranha tentando olhar discretamente para você, sua mente está em alerta.'), nl.

descricao(a1):-
    write('Você entra na Biblioteca e a primeira coisa que vê são todos os livros caídos das prateleiras e uma mancha de sangue na parede, além disso, há uma escada
        que desce para, ao que parece, uma sala mais reservada com um sofá.
        O policial Geronimo relata:
        -Detetive. - Ele cumprimenta - Alguém não estava muito feliz com a biblioteca, descendo as escadas você vai poder enxergar melhor.
        Ao descer você vê uma moça, não aparentava ter mais de 20 anos, estava estirada no sofá que outrora fora branco.
        Algo chama sua atenção, há uma porta pequena, é preciso agachar para conseguir passar.'), nl,
        write("<--Não se esqueça! escreva modoDetetive para desvendar o mistério!-->"), nl.

descricao(a3):-
    write('Ao entrar na Sala de Estar você se depara com o Policial Francisco, que diz:
        -Oh, detetive! Chegou bem a tempo, sei que a cena é feia e precisamos da sua ajuda!
        Ao olhar com mais cuidado para o sofá no meio da sala, você percebe que a mesa de centro estava quebrada e havia rastros de sangue até o
        rack da Tv e ali havia um corpo...'), nl,
        write("<--Não se esqueça! escreva modoDetetive para desvendar o mistério!-->"), nl.

descricao(b1):-
    write('Você percebe um quadro gigante da familia Gripp, parece que o bisavô Victor era bem excentrico.
        A sua esquerda há uma porta dupla entreaberta com um pequeno defeito na fechadura, ela parece ter sido aberta de forma muito minuciosa...
        A sua direita existe uma mesa pequena com um copo de água e uma carta aberta do lado:
        "As coisas estão dificéis, não sabemos até onde ele vai pra tentar desvender todo o mistério da familia Yellow... Tenho medo do que ele pode fazer...
        Ass. R.
        Você pega a carta e guarda no bolso do casaco.
        Agora você decide, voltar ou seguir para a sala? (b-e)"'), nl.
descricao(b2):-
    write('Você chega no hall. Olhando pra frente você percebe que tem um acesso para outro cômodo (d), que você julgou ser a cozinha.
    Seguindo acima (c) há um quadro grande e um acesso, mas você precisa chegar mais perto caso queira ver.
    Abaixo (b) há um acesso e uma janela bem grande que dá para ver o quintal da casa'), nl.

descricao(b3):-
    write('Você chega mais perto da janela, não consegue ver o quintal direito por causa da chuva. Há uma pequena mancha de gordura, mas não importa, você apenas limpa a pequena mancha.
    A sua direita há uma entrada para o salão de jogos. Você vê a movimentação dos policiais dentro da sala e então decide... (d)'), nl.

descricao(c1):-
     write('Ao entrar na cozinha depressa, concentrado no papel, o policial Vin esbarra em você e derruba seu distintivo.
        -Perdão Detetive, não te vi entrar! - diz ele com os olhos um pouco assustado, talvez pela cena que viu ou talvez por ter se esbarrado em algo sem ver.
        Você se abaixa para pegar o distintivo e pega o papel ao mesmo tempo, quando lê:
        9823-... Não dava para ver o resto, estava borrado, Vin pergunta:
        -O que é isso detetive?
        Você guarda o papel e olha para a cena do crime.
        O corpo do chefe de cozinha estava estirado no chão, mas nenhuma poça de sangue, era dificil saber o que aconteceu, mas você sabe como e quem...'), 
        nl.
descricao(c2):-
    write('Você olha adiante e vê o corredor (d) que é familiar para você e ao mesmo tempo você sente um frio na espinha. Ao desviar o olhar você vê a porta que dá acesso a cozinha (c).
        Ao olhar para a pequena janela que tem na porta você vê um pedaço de um papel, debaixo de um armário de cozinha que fica no chão, provavelmente passou despercebido pelos outros.
        Você então, rapidamente...(c)'), nl.

descricao(c3):-
    write('Ao entrar no salão de jogos algo te chama muita a atenção, havia uma pequena marca de um movel arrastado, ao seguir a pequena pista você vê uma máquina de caça-níquel.
        Ao olhar a cena do crime, a mesa principal estava manchada de sangue e molhada por algo que parecia bebidas alcoolicas e, debaixo da mesa, havia um homem, grisalho, 53 anos.
        Sem vida, o corpo inerte, manchas de sangue apenas na parte de cima da mesa.'), nl.

descricao(d2):-
    write('Você abre a porta do corredor. Ele parece maior do que é, você olha a sua direita e vê o jardim, dessa vez uma árvore bem grande, balançando por conta do temporal lá fora.
    Você só tem uma opção... Seguir em frente, mas algo parece que não quer deixar você seguir, um sentimento estranho... Mas, você precisa ir (d)'), nl.
descricao(e2):-
    write('No final do corredor você tem pequenos lapsos de já ter estado lá, já ter feito esse caminho antes. De fato, você já veio outra vez aqui, num dia claro, para
    conversar com sr... você não se lembra, ou se recusa lembrar? Mas não era isso, era outra coisa, outro dia... Você chega até o final do corredor, você precisa
    avançar (d).'), nl.
descricao(f1):-
    write('Você entra na sala de Conservatorio, um lugar dedicado a músicas. E um lapso de memória vem a sua mente, um homem baixo, tocando piano e se assustando com um som de algo se partindo...
    Você vê um homem jogado no tapete, ao centro da sala. Morreu na hora do impacto.'), nl.
descricao(f2):-
    write('Você passa pela pequena abóbada do corredor e encontra uma pequena mesa de centro a sua frente (d). Ao olhar para o lado (b) você vê o que deveria ser o quarto de hóspedes.
    Pedaços da porta estavam espalhados pelo chão. Além disso, você vê dentro do quarto a Oficial Waller assustada.'), nl.
descricao(f3):-
    write('Ao entrar no quarto de hóspedes Waller se dirige a você:
    - Você já esteve aqui antes? - Você sente o suor frio escorrer pela sua testa, mas você não entende porque...
    - Detetive? Pergunto isso por conta da carta que a vítima segura, parece falar sobre um detetive que bate bem com seu perfil e sabemos que você tem seus bicos particulares...
    Você não diz nada, apenas avança pelo pequeno quarto e pega a carta na mão da vítima. Parece ter sido seu último ato, no desespero tentar deixar mais fácil de descobrir o que aconteceu.
    A carta era bem rasa, você não entede o porque da fala da Waller.
    - Bem, acho que você sabe o que ocorreu aqui, seu olhar diz tudo...'), nl.
descricao(g1):-
    write('Ao subir as escadas, você vê um acesso a uma sala grande (d). A cena parece estar feia. Você olha pela janela e consegue ver as pequenas luzes borradas da cidade. Parece te dar um sentimento de
    triteza. Você olha novamente para a escada (b).'), nl.
descricao(g2):-
    write('Ao avançar, você chega mais perto da mesa de centro. Em cima dela tem um pano branco, manchado com, ao que parece, vinho. A frente (d) tem a porta do escritório, ela está fechada e o Policial
    José na frente dele. Ele te cumprimenta com o chapéu. Você vê uma escada que dá acesso a outro andar (c).'), nl.
descricao(h2):-
    write('José deixa você passar. Ao entrar no escritório. Sr. Yellow lhe encara. Você fecha a porta e Yellow fala:
    -Você foi muito sagaz. Um Detetive renomado, veio para resolver o maior crime da cidade... O crime que ele mesmo cometeu... - Sua cabeça dói e você se lembra de tudo... Algumas horas antes,
    você estava lá, você passou por todo aquele caminho, tomado pela fúria e pela sede de fazer justiça. Yellow, o homem que mandou sua filha para longe, aquela que você mais amava... No trajeto
    ela sofreu um acidente, você sabia que tipo de "acidente" ocorreu. Filha bastarda, Yellow a odiava. Você temia isso.
    -Sim - Diz você, abrindo uma garrafa de whisky ali perto e colocando no ocpo - Muito sagaz se fosse real...
    - Você não me achou e deixou um recado - diz ele calmamente.
    - Um recado? Um presente, você odiava todos eles. Não importa mais, você me tirou tudo e eu vou tirar tudo de você. - Você termina o último gole e saca a arma para Yellow.
    Yellow começa a suar frio:
    - Já basta, sei que você não queria fazer o que fez. Acredite em mim, o que aconteceu com ela foi um acidente, eu... Eu juro pela minha vid...
    - Calado. Você não tem o direito de falar dela.
    O tiro é fácil, é muito perto, mas você está tremendo. Yellow joga a mesa pra cima de você, você erra o tiro. Você se levanta rapidamente, a porta se abre e josé grita: 
    - O que está acontecendo?
    Yellow se levanta, mas é tarde demais. Você é certeiro. Yellow cai no chão ao mesmo tempo que José e mais uma vez, você sabe o que aconteceu...'), nl.

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
        f3 : quarto de hóspedes
        h2 : escritorio
    "), 
    ondeEstou(X),
    write("aonde você está: "), write(X), nl, !.

    

/* Falas dos personagens*/


fala(sr_Marinho):-
    write("-ABSURDO! EU JAMAIS FARIA ALGO DESSE TIPO!! VOCÊ VAI ME PAGAR DETETIVE! VOCÊ ME PAGA!!!! - Ele grita e fica vermelho, mas não importa mais."), nl.
fala(dona_Branca):-
    write("- Você está equivocado, isso é... isso é um absurdo!."), nl.
fala(srta_Rosa):-
    write("- Não se preocupe Detetive... Eu irei voltar e, bem... Digamos que sou vingativa, ainda mais com uma injustiça, cuidado. - Ela sorri friamente e estende os braços para ser presa."), nl.
fala(mordomo_James):-
    write("- Mas senhor... eu sirvo essa família há 30 anos, não faria sentido algum eu fazer algo desse tipo, NENHUM!."), nl.
fala(dona_Violeta):-
    write("Violeta lhe olha de cima abaixo e desfere:
        - Cuidado detetive, alguns erros podem ser irreparáveis depois de cometidos e, bem, eu sei que não serei presa..."), nl.
fala(sergio_Soturno):-
    write("Você está errado, eu tirarei seu crachá de detetive assim que for liberado. Além disso, você não vai mais ser empregado e muito menos terá um nome de respeito. - Ele cospe no chão à sua frente."), nl.
fala(sargento_Bigode):-
    write("O sargento fica atônito:
    - Como assim? Você sabe quem eu sou?? Farei da sua vida um INFERNO! Se prepare, imbecil!"), nl.
fala(tony_Gourmet):-
    write("Queria enteder daonde você tirou isso, claramente isso está errado e eu vou provar. Você tem inveja, pode adimitir, ninguém consegue ser igual à mim, mas isso foi longe demais!"), nl.


/*Dicas - assassinos*/
dica(srta_Rosa):-
    write("Você sente um perfume e uma lembrança, espinhos em uma flor..."), nl.
dica(sr_Marinho):-
    write("A lembrança do vento da praia e o mar lhe diz algo, pulsa em sua mente..."), nl.
dica(dona_Branca):-
    write("Algo que deveria simbolizar a paz e a calma, não condiz com o que você enxerga ali..."), nl.
dica(mordomo_James):-
    write("Você não é fã de clichês, mas a culpa é sempre dele..."), nl.
dica(dona_Violeta):-
    write("Um pequeno fio, lilás ou roxo, caído ao lado do corpo..."), nl.
dica(sergio_Soturno):-
    write("A melancolia lhe vem a mente, sim, só ele é a tristeza em pessoa..."), nl.
dica(sargento_Bigode):-
    write("Uma vida no exército pode mudar a vida de alguém, aparentemente foi difícil pra el..."), nl.
dica(tony_Gourmet):-
    write("Alguém que não enxerga a si, longe da realidade, ego inflado..."), nl.

 
/*Dicas - armas armas([corda, revolver, candelabro, soco_ingles, cano, chave_ingles, faca, pe_de_cabra]). */

dica(corda):-
    write("Marcas no pescoço, provavelmente enforcamento."), nl.
dica(revolver):-
    write("Furo no peito, provavelmente de um projétil"), nl.
dica(candelabro):-
    write(""), nl.
dica(soco_ingles):-
    write("Hematomas no rosto e na barriga, parece ter sido uma pancada pesada."), nl.
dica(cano):-
    write("Uma marca que atravessa o rosto, parece ter sido um grande impacto."), nl.
dica(chave_inglesa):-
    write("Um hematoma parecendo uma forma perfeito de uma ferramenta."), nl.
dica(faca):-
    write("Uma perfuração certeira no coração."), nl.
dica(pe_de_cabra):-
    write("Certamente algo pesado e rápido acertou as costas e o peito."), nl.













