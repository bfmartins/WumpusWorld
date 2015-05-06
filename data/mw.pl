% Trabalho final para IA - PINF6012
%
% Professor Orivaldo
%
% Esta é uma representação de uma situação do mundo Wumpus
%
% Versão 8 (28/02/2014) para o trabalho de IA por:
%
% Beatriz Franco Martins Souza - 2013230509 (Núcleo em Prolog)
% Carpegieri Torezani - 2012230463 (Testes e documentação)
% Estevao B. Saleme - 2013230510 (Interface em Java)
%
% versão 9 (30/06/2014) para artigo de IA por:
%
% Beatriz Franco Martins Souza - 2013230509 (Núcleo em Prolog,
% Testes, documentação e Interface em Java)
%
% Features:
%
% Ajustes no envio da inicialização para uso da interface
% Adição das funcionalidades de inicialização via core na interface
% Adição das funcionalidades de exibição das inferências na interface
% Adição das funcionalidades de leitura das mensagens na interface
%
%------------------------------------------------------------

%------------------------------------------------------------
%
% INICIALIZAÇÕES
%
%------------------------------------------------------------
%------------------------------------------------------------
% Declaração de predicados dinâmicos
%------------------------------------------------------------

:- dynamic ([not/2,
	     agt/2,
	     fch/3,
	     wps/2,
	     fdr/2,
	     brc/2,
	     brcs/2,
	     vnt/2,
	     our/2,
	     our/3,
	     blh/2,
	     bum/3,
	     grt/2,
	     prd/2,
	     fim/1,
	     fdrs/2,
	     vnts/2,
	     blhs/2,
	     agt_obj/2,
	     agt_pcb/3,
	     vivo/3,
	     lista_ppa/2,
	     lista_acoes/2,
	     mat/1,
	     matriz/2,
	     pts_agt/2,
	     pos_adj/2,
	     pos_val/1,
	     sai_agt/1,
	     trj/5,
	     trj_id/2,
	     tot_kbs/1,
	     tot_kbas/1,
	     tot_kbhs/1,
	     agt_ativo/1,
	     agt_est/2,
	     tot_trj/2,
	     lista_est/2,
	     arv/2,
	     agt_ips/2,
	     agt_wps/2,
	     melhor_trj/5,
	     tot_off/1,
	     id_msg/1 ,
	     msg/6,
	     saiu/3,
	     kb_origem/1,
	     inicio/1,
	     rpt/3,
	     tiro/3
	    ]).

%------------------------------------------------------------
%
% DECLARAÇÕES DE FUNÇÕES AUXILIARES
%
%------------------------------------------------------------
%------------------------------------------------------------
% Função para gerar posições randômicas do tabuleiro
%------------------------------------------------------------

random_mat(P,LPMAT) :-
	mat(M) , % Tamanho máximo da matriz
	randset(2,M,P) ,
	not(pertence(P,LPMAT)), !.
random_mat(P,LPMAT) :- random_mat(P,LPMAT) , !.

%------------------------------------------------------------
% Pesquisa em uma lista se um elemento pertence a esta lista
%------------------------------------------------------------

pertence(E,[E|_]) :- !.
pertence(E,[_|R]) :- pertence(E,R).

%------------------------------------------------------------
% Insere elementos em uma lista
%------------------------------------------------------------

insere(P,L,[P|L]) :- !.

%------------------------------------------------------------
% Remove um elemento de uma lista preenchidas
% ------------------------------------------------------------

remove(E,[E|R],R) :- !.
remove(E,[C|R1],[C|R2]) :- remove(E,R1,R2) .

%------------------------------------------------------------
% Concatena duas listas
%------------------------------------------------------------

concatena(L,[],L) :- !.
concatena(L1,[C|L2],[C|L3]) :- concatena(L1,L2,L3).

%------------------------------------------------------------
% Retorna o último elemento de uma lista
%------------------------------------------------------------

ultimo([E],E) :- !.
ultimo([_|EN],E) :- ultimo(EN,E).

%------------------------------------------------------------
% Retorna o último elemento de uma lista
%------------------------------------------------------------

total_elementos([],0) :- !.
total_elementos([_|EN],T) :-
	total_elementos(EN,TN) ,
	T is TN + 1.

%------------------------------------------------------------
%
% INICIALIZAÇÕES DO JOGO
%
%------------------------------------------------------------
%------------------------------------------------------------
% Sistema de coordenadas baseado em coordenadas cartezianas x,y
% posicionadas a partir do canto superior esquerdo da tela
% (diferentemente da versão original do jogo - linha , coluna)
% por causa da orientação do engine 2d da interface. Esta modificação
% foi feita para a nova versão da interface de modo a compatibilizar
% as corrdenadas
% ------------------------------------------------------------

n([I,J],[X,Y]) :- X is I , Y is J - 1 .
s([I,J],[X,Y]) :- X is I , Y is J + 1 .
l([I,J],[X,Y]) :- X is I + 1 , Y is J .
o([I,J],[X,Y]) :- X is I - 1 , Y is J .

ne([I,J],[X,Y]) :- X is I + 1 , Y is J - 1 .
se([I,J],[X,Y]) :- X is I + 1 , Y is J + 1 .
so([I,J],[X,Y]) :- X is I - 1 , Y is J + 1.
no([I,J],[X,Y]) :- X is I - 1 , Y is J - 1.

e_norte([I,J],[X,Y],norte) :- X == I , Y < J .
e_sul([I,J],[X,Y],sul) :- X == I , Y > J .
e_leste([I,J],[X,Y],leste) :- X > I , Y == J .
e_oeste([I,J],[X,Y],oeste) :- X < I , Y == J .


%------------------------------------------------------------
% Inicialização do tabuleiro
%------------------------------------------------------------

inic_mat(M) :-
	kb_mat(KB) ,
	assert(mat(M)) ,
	ini([I,J]) ,
	assert(matriz(KB,[[I,J]])) ,
	assert(fim([I,J])) ,
	assert(pts_agt(KB,1000)) ,
	assert(tot_off(KB)) ,
	assert(fdrs(KB,[])) ,
	assert(vnts(KB,[])) ,
	assert(blhs(KB,[])).

%------------------------------------------------------------
% Inicialização do objetos do tabuleiro randomicamente
%------------------------------------------------------------

inic_wps :-
	kb_mat(KB) ,
	matriz(KB,LPMAT) ,
	random_mat([I,J],LPMAT) ,
	insere([I,J],LPMAT,NLPMAT) ,
	retractall(matriz(KB,_)) ,
	assert(matriz(KB,NLPMAT)) ,
	assert(wps(KB,[I,J])) ,
	assert(vivo(KB,wps(KB,[I,J]),sim)).

inic_brc :-
	kb_mat(KB) ,
	matriz(KB,LPMAT) ,
	random_mat([I1,J1],LPMAT) ,
	insere([I1,J1],LPMAT,LPMAT1) ,
	retractall(matriz(KB,_)) ,
	assert(matriz(KB,LPMAT1)) ,
	assert(brc(KB,[I1,J1])) ,
	random_mat([I2,J2],LPMAT1) ,
	insere([I2,J2],LPMAT1,LPMAT2) ,
	retractall(matriz(KB,_)) ,
	assert(matriz(KB,LPMAT2)) ,
	assert(brc(KB,[I2,J2])) ,
	random_mat([I3,J3],LPMAT2) ,
	insere([I3,J3],LPMAT2,LPMAT3) ,
	retractall(matriz(KB,_)) ,
	assert(matriz(KB,LPMAT3)) ,
	assert(brc(KB,[I3,J3])),
	assert(brcs(KB,[[I1,J1],[I2,J2],[I3,J3]])).

inic_our :-
	kb_mat(KB) ,
	matriz(KB,LPMAT) ,
	random_mat([I,J],LPMAT) ,
	insere([I,J],LPMAT,NLPMAT) ,
	retractall(matriz(KB,LPMAT)) ,
	assert(matriz(KB,NLPMAT)) ,
	assert(our(KB,[I,J])) .

%------------------------------------------------------------
% Inicialização dos agentes
%------------------------------------------------------------

inic_kbas(KB) :- assert(tot_kbas(KB)) .

inic_kbhs(KBH) :- assert(tot_kbhs(KBH)) .

inic_kbs :- tot_kbas(KBA) ,
	tot_kbhs(KBH) ,
	KB is KBH + KBA ,
	assert(tot_kbs(KB)) .

inic_agt(KB) :-
	tot_kbs(TKB) ,
	% Inicializa enquanto não alcançar o total de jogadores
	TKB < KB , !.
inic_agt(KB) :-
	ini([I,J]) ,
	assert(agt(KB,[I,J])) ,
	assert(vivo(KB,agt(KB,_),sim)) ,
	assert(vivo(KB,wps(KB,_),sim)) ,
	assert(fch(KB,agt(KB,_),sim)) ,
	assert(lista_ppa(KB,[[I,J]])) ,
	assert((lista_acoes(KB,[]))) ,
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[I,J],iniciou,aqui,LA) ,
	assert(pts_agt(KB,1000)) ,
	assert(agt_ativo(1)) ,
	assert(our(KB,agt(KB,_),nao)) ,
	assert(fdrs(KB,[])) ,
	assert(vnts(KB,[])) ,
	assert(blhs(KB,[])) ,
	assert(inicio(KB)) ,
	inic_obj(KB) ,
	NKB is KB + 1 ,
	inic_agt(NKB) , !.

inic_obj(KB) :-
	assert(agt_obj(KB,ouro)) ,
	assert(agt_obj(KB,wumpus)).

%------------------------------------------------------------
% Inicialização do id de mensagens
%------------------------------------------------------------

inic_msg :- assert(id_msg(0)).

%------------------------------------------------------------
% Inicialização para o inicio do jogo
%------------------------------------------------------------

inic_jogo(M,KB,KBH) :-
	inic_mat(M) ,
	inic_wps ,
	inic_brc ,
	inic_our ,
	inic_kbas(KB) ,
	inic_kbhs(KBH) ,
	inic_kbs ,
	inic_agt(1) ,
	inic_msg.

%------------------------------------------------------------
% Função para imprimir na tela as informações iniciais
%------------------------------------------------------------

descricao :-
	format("~nMundo do Wumpus.") , nl ,
	format("~n-------------------------------------------------------------------") ,nl ,
	format("Este e o jogo Mundo do Wumpus, versao 9.0, criado por
Beatriz Franco Martins Souza para o Mestrado, na UFES na disciplina
de Inteligencia Artificial. Este jogo foi baseado no exemplo exposto
no capitulo 7 do livro 'Russell, S.; Norvig, P.; Artificial
Intelligence - A Modern Approach; Prentice Hall; 2010, ed3.' ") ,nl ,
	format("-------------------------------------------------------------------") , nl , !.

%------------------------------------------------------------
% Função para imprimir na tela as informações na matriz
% quando esta for gerada randômicamente
%------------------------------------------------------------

descreve_mat :-
	format("~n~nCenario randomico adotado.~n") ,nl ,
	mat(M) ,
	format("Caverna de tamanho: ~p por ~p",[M,M]) , nl ,
	wps(0,W) ,
	format("O Wumpus esta na posicao: ~p",[W]) , nl ,
	our(0,O) ,
	format("O Ouro esta na posicao: ~p",[O]) , nl ,
	brcs(0,[B1,B2,B3]) ,
	format("Os buracos estao nas posicoes: ~p, ~p e ~p~n~n",[B1,B2,B3]) , nl , !.

%------------------------------------------------------------
% Função para imprimir na tela as informações da pontuação
% obtidas por cada agente/jogador
%------------------------------------------------------------

descreve_pts(KB) :-
	tot_kbs(TKB) ,
	KB > TKB , !.
descreve_pts(KB) :-
	pts_agt(KB,T) ,
	format("A pontuacao do agente ~p foi de: ~p",[KB,T]) , nl ,
	NKB is KB + 1 ,
	descreve_pts(NKB) , !.

%------------------------------------------------------------
% Função para imprimir na tela os trajetos percorridos pelos
% agentes no decorrer do jogo
%------------------------------------------------------------

descreve_acoes(KB) :-
	tot_kbs(TKB) ,
	KB > TKB , !.
descreve_acoes(KB) :-
	lista_acoes(KB,LA) ,
	format("~nO trajeto percorrido pelo agente ~p foi: ~n~p",[KB,LA]) , nl ,
	NKB is KB + 1 ,
	descreve_acoes(NKB) , !.

%------------------------------------------------------------
% Função para imprimir na tela as situações dos agentes
% durante o jogo
%------------------------------------------------------------

situacao_agt(KB) :-
	vivo(KB,agt(KB,[_,_]),S1) ,
	format("~nO agente ~p esta vivo: ~p",[KB,S1]) , nl ,
	pts_agt(KB,T) ,
	format("A pontuacao do agente ~p e: ~p",[KB,T]) , nl ,
	our(KB,agt(KB,[_,_]),S2) ,
	format("O agente ~p pegou o ouro: ~p",[KB,S2]) , nl ,
	fch(KB,agt(KB,[_,_]),S3) ,
	format("O agente ~p possui uma flecha: ~p",[KB,S3]) , nl ,
	vivo(KB,wps(KB,[_,_]),S4) ,
	format("O Wumpus esta na vivo: ~p",[S4]) , nl , !.

%------------------------------------------------------------
% Função para imprimir na tela as situações dos agentes
% durante o jogo
%------------------------------------------------------------

situacao_hum(KB) :-
	vivo(KB,agt(KB,[_,_]),S1) ,
	format("~nO jogador ~p esta vivo: ~p",[KB,S1]) , nl ,
	pts_agt(KB,T) ,
	format("A pontuacao do jogador ~p e: ~p",[KB,T]) , nl ,
	our(KB,agt(KB,[_,_]),S2) ,
	format("O jogador ~p pegou o ouro: ~p",[KB,S2]) , nl ,
	fch(KB,agt(KB,[_,_]),S3) ,
	format("O jogador ~p possui uma flecha: ~p",[KB,S3]) , nl ,
	vivo(KB,wps(KB,[_,_]),S4) ,
	format("O Wumpus esta na vivo: ~p",[S4]) , nl , !.

%------------------------------------------------------------
%
% NAVEGAÇÃO
%
%------------------------------------------------------------
%------------------------------------------------------------
%
% Funções "main"
%------------------------------------------------------------
%------------------------------------------------------------
% Função "main" com execução passo a passo e tabuleiro
% randômico
%------------------------------------------------------------

main(M,KB,KBH) :-
	descricao ,
	inic_jogo(M,KB,KBH) ,
	descreve_mat , !.

%------------------------------------------------------------
% Função "main" com execução automática e tabuleiro
% randômico (sem jogador humano)
%------------------------------------------------------------

mainauto(M,KB,0) :-
	descricao ,
	inic_jogo(M,KB,0) ,
	descreve_mat ,
	exec , !.

%------------------------------------------------------------
% Função "main" para java com controle de execução pelo java
%------------------------------------------------------------

main4j(M,KB,KBH) :-
	descricao ,
	inic_jogo(M,KB,KBH) ,
	descreve_mat , !.

%------------------------------------------------------------
%
% Funções para controle de execução
%------------------------------------------------------------
%------------------------------------------------------------
% Função para identificar o jogador/agente inicial
%------------------------------------------------------------

kb_ini(_,0) :- fim_jogo , !.
kb_ini(KB,KB) :- vivo(KB,agt(KB,_),sim) , !.
kb_ini(KB,NKB) :-
	vivo(KB,agt(KB,_),nao) ,
	PKB is KB + 1 ,
	kb_ini(PKB,NKB) , ! .

%------------------------------------------------------------
% Função para reiniciar o jogador/agente ativo
%------------------------------------------------------------

reset_agt :-
	retractall(agt_ativo(_)) ,

	% ativa o primeiro que estiver vivo
	kb_mat(KBM) ,
	KBI is KBM + 1 ,
	kb_ini(KBI,KB) ,

	assert(agt_ativo(KB)) .

%------------------------------------------------------------
% Função para identificar o tipo da KB
%------------------------------------------------------------

tipo_kb(KB,agente):-
	tot_kbas(TKBA),
	KB =< TKBA .
tipo_kb(KB,humano):-
	tot_kbas(TKBA),
	KB > TKBA ,
	tot_kbs(TKB),
	KB =< TKB.
tipo_kb(KB,jogo):- kb_mat(KB).
tipo_kb(KB,mensagem):- kb_msg(KB).

%------------------------------------------------------------
% Função para modificar o jogador/agente ativo
%------------------------------------------------------------

set_agt(KB) :-
	tot_kbs(TKB) ,
	KB == TKB ,
	reset_agt , !.
set_agt(KB) :-
	NKB is KB + 1 ,
	vivo(NKB,agt(NKB,_),nao) ,
	retractall(agt_ativo(_)) ,
	assert(agt_ativo(NKB)) ,
	set_agt(NKB) , !.
set_agt(KB) :-
	NKB is KB + 1 ,
	vivo(NKB,agt(NKB,_),sim) ,
	retractall(agt_ativo(_)) ,
	assert(agt_ativo(NKB)) .

%------------------------------------------------------------
% Função para contagem de agentes mortos ou em impasse
%------------------------------------------------------------

soma_off :-
	tot_off(TOFF) ,
	NTOFF is TOFF + 1 ,
	retractall(tot_off(_)) ,
	assert(tot_off(NTOFF)) .

%------------------------------------------------------------
% Função para verificar se ocorreu o fim do jogo por
% eliminação de todos os jogadores ou se todos sairam da caverna
%------------------------------------------------------------

fim_jogo :-
	tot_off(TOFF) ,
	tot_kbs(TKBS) ,
	TOFF == TKBS ,

	% Finaliza o jogo
	retractall(fim(_)) ,
	assert(fim([0,0])).

%------------------------------------------------------------
% Função para leitura de uma ação em tela
%------------------------------------------------------------

le_acao(KB,_,_,_) :-
	format("~n~nDigite a ação a ser tomada pelo jogador ~p.",[KB]) , nl ,
	format("~nAções possíveis:~n") , nl ,
	format("1- Mover para o norte;") , nl ,
	format("2- Mover para o sul;") , nl ,
	format("3- Mover para o leste;") , nl ,
	format("4- Mover para o oeste;") , nl ,
	fail.
le_acao(KB,_,_,_) :-
	fch(KB,agt(KB,_),sim) ,
	format("5- Atirar para o norte;") , nl ,
	format("6- Atirar para o sul;") , nl ,
	format("7- Atirar para o leste;") , nl ,
	format("8- Atirar para o oeste;") , nl ,
	fail .
le_acao(KB,_,_,_) :-
	agt(KB,P) ,
	kb_mat(KBM) ,
	our(KBM,P) ,
	format("9- Pegar o ouro;") , nl ,
	fail .
le_acao(KB,_,_,_) :-
	ini([I,J]) ,
	agt(KB,[I,J]) ,
	agt_obj(KB,sair) ,
	format("0- Sair da caverna;") , nl ,
	fail .
le_acao(KB,AE,OE,[X,Y]) :-
	repeat ,
	format("~nAção escolhida -> ") ,

	% leitura da opção
	get_char(C) , nl ,

	% verifica se a ação tomada é válida
	acoes_hum(AV) ,
	pertence(C,AV) ,

	% traduz a opção do jogador para uma ação do jogo
	trdz_acao(C,AC,OC) ,

	% Avalia a ação do jogador e determina a posição de movimento
	agt(KB,[I,J]) ,
	aval_acao(KB,[I,J],AC,OC,[X,Y],AE,OE) , !.

%------------------------------------------------------------
% Função traduz a opção do jogador para uma ação do jogo
%------------------------------------------------------------

trdz_acao('1',mover,norte) :- !.
trdz_acao('2',mover,sul) :- !.
trdz_acao('3',mover,leste) :- !.
trdz_acao('4',mover,oeste) :- !.
trdz_acao('5',atirar,norte) :- !.
trdz_acao('6',atirar,sul) :- !.
trdz_acao('7',atirar,leste) :- !.
trdz_acao('8',atirar,oeste) :- !.
trdz_acao('9',pegar_ouro,aqui) :- !.
trdz_acao('0',sair,aqui) :- !.

%------------------------------------------------------------
% Avaliação da ação tomada por parte do jogador para pegar o ouro
%------------------------------------------------------------

aval_acao(_,[I,J],pegar_ouro,aqui,[I,J],pegar_ouro,aqui) :- !.

%------------------------------------------------------------
% Avaliação da ação tomada por parte do jogador para atirar
%------------------------------------------------------------

aval_acao(KB,[I,J],atirar,O,[I,J],atirar,O) :-
	fch(KB,agt(KB,_),nao) ,

	% Atualiza a pontuação
	redz_pnt(KB,1) ,

	% Mensagem
	format("O jogador ~p não pode atirar porque não tem mais flechas! Escolha outro movimento.~n",[KB]) , nl ,
	! , fail .
aval_acao(KB,[I,J],atirar,O,[I,J],atirar,O) :-
	fch(KB,agt(KB,_),sim) , !.

%------------------------------------------------------------
% Avaliação da ação tomada por parte do jogador para mover-se
%------------------------------------------------------------

aval_acao(KB,[I,J],mover,O,[X,Y],parede,O) :-
	% verifica se a posição da orientação é parede
	bum(KB,[I,J],O) ,

	% Obtem a posição a partir da orientação
	ori_mov(KB,[I,J],[X,Y],O) ,

	% Atualiza a ação tomada
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[X,Y],parede,O,LA) ,

	% Atualiza a pontuação
	pnt_pos([X,Y],PNT) ,
	redz_pnt(KB,PNT) ,

	% Mensagem
	format("O jogador ~p bateu na parede! Escolha outro movimento.~n",[KB]) , nl ,
	! , fail .
aval_acao(KB,[I,J],mover,O,[X,Y],esbarrao,O) :-
	% Obtem a posição a partir da orientação
	ori_mov(KB,[I,J],[X,Y],O) ,

	% verifica se O Wumpus está morto
	vivo(KB,wps(KB,[X,Y]),nao) ,

	% Atualiza a ação tomada
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[X,Y],esbarrao,O,LA) ,

	% Atualiza a pontuação
	pnt_pos([X,Y],PNT) ,
	redz_pnt(KB,PNT) ,

	% Mensagem
	format("O jogador ~p esbarrou no Wumpus morto! Escolha outro movimento.~n",[KB]) , nl ,
	! , fail .
aval_acao(KB,[I,J],mover,O,[X,Y],mover,O) :-

	% Obtem a posição a partir da orientação
	ori_mov(KB,[I,J],[X,Y],O) , !.

%------------------------------------------------------------
% Avaliação da ação tomada por parte do jogador para sair
%------------------------------------------------------------

% Redundancia proposital por causa da interface java (com o menu)
aval_acao(KB,[I,J],sair,aqui,[I,J],sair,aqui) :-
	not(ini([I,J])) ,

	% Atualiza a pontuação
	redz_pnt(KB,1) ,

	% Mensagem
	format("Você não pode sair agora! Escolha outro movimento.~n") , nl ,
	! , fail .
aval_acao(_,[I,J],sair,_,[I,J],sair,_) :-
	ini([I,J]) , !.

%------------------------------------------------------------
% Função de percepção para o agente
%------------------------------------------------------------

percebe_agt(KB,[I,J]) :-
	vivo(KB,agt(KB,_),sim) ,

	% Mostra na tela a situação atual do jogo
	situacao_agt(KB)  ,

	% Percepção
	format("O agente ~p pode perceber [Brilho,[Paredes(norte,sul,leste,oeste)],Fedor,Grito,Vento] conforme a seguir:",[KB]) , nl ,
	agt_pcb(KB,[I,J],[BLH,BUM,FDR,GRT,VNT]) ,
	format("O agente ~p percebe: ~p",[KB,[BLH,BUM,FDR,GRT,VNT]]) , nl ,
	envia_msg(KB,broadcast,ppa,[I,J]) , !.
percebe_agt(_,_).

%------------------------------------------------------------
% Função de percepção para o jogador humano
%------------------------------------------------------------

percebe_hum(KB,[I,J]) :-
	vivo(KB,agt(KB,_),sim) ,

	% Mostra na tela a situação atual do jogo
	situacao_hum(KB)  ,

	% Percepção
	format("O jogador ~p pode perceber [Brilho,[Paredes(norte,sul,leste,oeste)],Fedor,Grito,Vento] conforme a seguir:",[KB]) , nl ,
	agt_pcb(KB,[I,J],[BLH,BUM,FDR,GRT,VNT]) ,
	format("O jogador ~p percebe: ~p",[KB,[BLH,BUM,FDR,GRT,VNT]]) , nl ,
	envia_msg(KB,broadcast,ppa,[I,J]) , !.
percebe_hum(_,_).

%------------------------------------------------------------
% Função de percepção para o agente via java
%------------------------------------------------------------

percebe_agt_4j(KB,[I,J],[BLH,BUM,FDR,GRT,VNT]) :-
	vivo(KB,agt(KB,_),sim) ,
%	format("~nInicializando o agente ~p.",[KB]) , nl ,
%	format("~nA posicao inicial do agente ~p e: ~p",[KB,[I,J]]) , nl ,

	% Mostra na tela a situação atual do jogo
%	situacao_agt(KB)  ,

	% Percepção
%	format("O agente ~p pode perceber [Brilho,[Paredes(norte,sul,leste,oeste)],Fedor,Grito,Vento] conforme a seguir:",[KB]) , nl ,
	agt_pcb(KB,[I,J],[BLH,BUM,FDR,GRT,VNT]) ,
%	format("O agente ~p percebe: ~p",[KB,[BLH,BUM,FDR,GRT,VNT]]) , nl ,
	envia_msg(KB,broadcast,ppa,[I,J]) ,
	!.
percebe_agt_4j(_,_,_).

%------------------------------------------------------------
% Função de percepção para o jogador humano via java
%------------------------------------------------------------

percebe_hum_4j(KB,[I,J],[BLH,BUM,FDR,GRT,VNT]) :-
	vivo(KB,agt(KB,_),sim) ,
%	format("~nInicializando o jogador ~p.",[KB]) , nl ,
%	format("~nA posicao inicial do jogador ~p e: ~p",[KB,[I,J]]) , nl ,

	% Mostra na tela a situação atual do jogo
%	situacao_hum(KB)  ,

	% Percepção
%	format("O jogador ~p pode perceber [Brilho,[Paredes(norte,sul,leste,oeste)],Fedor,Grito,Vento] conforme a seguir:",[KB]) , nl ,
	agt_pcb(KB,[I,J],[BLH,BUM,FDR,GRT,VNT]) ,
%	format("O jogador ~p percebe: ~p",[KB,[BLH,BUM,FDR,GRT,VNT]]) , nl ,
	envia_msg(KB,broadcast,ppa,[I,J]) ,
	!.
percebe_hum_4j(_,_,_).

%------------------------------------------------------------
% Função de percepção inicial para o agente
%------------------------------------------------------------

percebe_ini_agt(KB,[I,J]) :-
	% mostra na tela as percepções iniciais
	ini([I,J]) ,
	agt(KB,[I,J]) ,
	not(agt_obj(kb,sair)) ,
	inicio(KB) ,
	retractall(inicio(KB)) ,
	percebe_agt(KB,[I,J]) , !.
percebe_ini_agt(_,_).

%------------------------------------------------------------
% Função de percepção inicial para o jogador humano
%------------------------------------------------------------

percebe_ini_hum(KB,[I,J]) :-
	% mostra na tela as percepções iniciais
	ini([I,J]) ,
	agt(KB,[I,J]) ,
	not(agt_obj(kb,sair)) ,
	inicio(KB) ,
	retractall(inicio(KB)) ,
	percebe_hum(KB,[I,J]) , !.
percebe_ini_hum(_,_).

%------------------------------------------------------------
% Função de percepção inicial para o jogador via java
%------------------------------------------------------------

percebe_ini_4j(KB,agente,[I,J],PCB) :-
	agt_ativo(KB) ,
	inicio(KB) ,
	ini([I,J]) ,
	agt(KB,[I,J]) ,
	tipo_kb(KB,agente) ,
	not(agt_obj(kb,sair)) ,
	percebe_agt_4j(KB,[I,J],PCB) ,
%	format("~nO agente ~p foi inicializado com sucesso!~n",[KB]) , nl ,
	!.
percebe_ini_4j(KB,humano,[I,J],PCB) :-
	agt_ativo(KB) ,
	inicio(KB) ,
	ini([I,J]) ,
	agt(KB,[I,J]) ,
	tipo_kb(KB,humano) ,
	not(agt_obj(kb,sair)) ,
	percebe_hum_4j(KB,[I,J],PCB) ,
%	format("~nO jogador ~p foi inicializado com sucesso!~n",[KB]) , nl ,
	!.
percebe_ini_4j(_,_,_,_).

%------------------------------------------------------------
% Informa o proximo jogador a ser inicializado ou -1 se for o final
%------------------------------------------------------------

set_agt_4j(KB) :-
	% Ativa o próximo agente
	set_agt(KB) ,
	retractall(inicio(KB)) , ! .
set_agt_4j(-1).

%------------------------------------------------------------
% Função de execução automática
%------------------------------------------------------------

exec :- fim_jogo ,
	not(our(_,agt(_,_),sim)) ,
	format("~nTrajetos percorridos.~n~n") ,
	descreve_acoes(1) ,
	format("~n~nPontuações.~n") ,
	descreve_pts(1) ,
	format("~n~nFim do jogo, não houveram vencedores!~n~n") , !.

exec :- fim_jogo ,
	our(_,agt(_,_),sim) ,
	format("~nPontuações.~n") ,
	descreve_pts(1) ,
	format("~n~nVitória, parabéns!~n~n") , !.

exec :- agt_ativo(KB) ,
	format("~nO agente ativo é o agente: ~p",[KB]) ,
	agt(KB,[I,J]) ,
	format("~nA posição atual do jogador ~p é: ~p",[KB,[I,J]]) ,

	% Leitura das mensagens recebidas pela KB compartilhada
	le_msg(KB) ,

	% Percepção inicial
	percebe_ini_agt(KB,[I,J]) ,

	% Calcula o risco de morte antes da próxima ação (executa inferências)
	risco(KB,[I,J],[NI,NJ],A,R) ,

	format("~nA próxima ação do agente ~p será: ~p ",[KB,A]) ,
	format("~nA próxima posição do agente ~p será: ~p ",[KB,[NI,NJ]]) ,
	format("~nO risco de morte nesta ação é de: ~p por cento~n~n",[R]) ,

	% Descrece a situação após a ação
	format("-> O agente ~p executou a ação: ~p~n",[KB,A]) ,

	% Toma a ação de acordo com o atual estratégia e objetivo
	acao(KB,[NI,NJ],A,_) ,

	% Percepção
	percebe_agt(KB,[NI,NJ]) ,

	% Ativa o próximo agente
	set_agt(KB) ,

	% Recursão
	exec , !.

%------------------------------------------------------------
% Função de passo de execução
%------------------------------------------------------------

passo :-
	fim_jogo ,
	not(our(_,agt(_,_),sim)) ,
	format("~n~nTrajetos percorridos.~n~n") ,
	descreve_acoes(1) ,
	format("~n~nPontuações.~n") ,
	descreve_pts(1) ,
	format("~nFim do jogo, não houveram vencedores!~n~n") , !.

passo :-
	fim_jogo ,
	our(_,agt(_,_),sim) ,
	format("~nPontuações.~n") ,
	descreve_pts(1) ,
	format("~nVitória, parabéns!~n~n") , !.

passo :-
	agt_ativo(KB) ,

	% Se for um jodador humano
	tipo_kb(KB,humano) ,

	% Leitura das mensagens recebidas pela KB compartilhada
	le_msg(KB) ,

	format("~nO jogador ativo é: jogador ~p",[KB]) ,
	agt(KB,[I,J]) ,
	format("~nA posição atual do jogador ~p é: ~p",[KB,[I,J]]) ,

	% Percepção inicial
	percebe_ini_hum(KB,[I,J]) ,

	% Aguarda o envio de uma ação
	le_acao(KB,A,O,[NI,NJ]) ,

	% Calcula o risco e faz inferências
	risco(KB,[I,J],[NI,NJ],A,R) ,

	format("~nA próxima ação do jogador ~p será: ~p ",[KB,A]) ,
	format("~nA próxima posição do jogador ~p será: ~p ",[KB,[NI,NJ]]) ,
	format("~nO risco de morte nesta ação é de: ~p por cento~n~n",[R]) ,

	% Descrece a situação após a ação
	format("-> O jogador ~p executou a ação: ~p~n",[KB,A]) ,

	% Toma a ação de acordo com a escolha feita
	acao(KB,[NI,NJ],A,O) ,

	% Percepção
	percebe_hum(KB,[NI,NJ]) ,

	% Ativa o próximo agente
	set_agt(KB) ,

	format("~n~nFim da ação de um passo.~n~n") , !.

passo :-
	agt_ativo(KB) ,

	% Se for um agente
	tipo_kb(KB,agente) ,

	% Leitura das mensagens recebidas pela KB compartilhada
	le_msg(KB) ,

	format("~nO agente ativo é: agente ~p",[KB]) ,
	agt(KB,[I,J]) ,
	format("~nA posição atual do agente ~p é: ~p",[KB,[I,J]]) ,

	% Percepção inicial
	percebe_ini_agt(KB,[I,J]) ,

	% Calcula a ação em função do risco de morte (executa inferências)
	risco(KB,[I,J],[NI,NJ],A,R) ,

	format("~nA próxima ação do agente ~p será: ~p ",[KB,A]) ,
	format("~nA próxima posição do agente ~p será: ~p ",[KB,[NI,NJ]]) ,
	format("~nO risco de morte nesta ação é de: ~p por cento~n~n",[R]) ,

	% Descrece a situação após a ação
	format("-> O agente ~p executou a ação: ~p~n",[KB,A]) ,

	% Toma a ação de acordo com o atual estratégia e objetivo
	acao(KB,[NI,NJ],A,_) ,

	% Percepção
	percebe_agt(KB,[NI,NJ]) ,

	% Ativa o próximo agente
	set_agt(KB) ,

	format("~n~nFim da ação de um passo.~n~n") , !.

%------------------------------------------------------------
% Função de passo de execução para o java
%------------------------------------------------------------

passo4j(_,_,_,_) :-
	fim_jogo ,
	not(our(_,agt(_,_),sim)) ,
	format("~n~nTrajetos percorridos.~n") , nl ,
	descreve_acoes(1) ,
	format("~n~nPontuacoes.") , nl ,
	descreve_pts(1) ,
	format("~nFim do jogo, nao houveram vencedores!~n") , nl , !.

passo4j(_,_,_,_) :-
	fim_jogo ,
	our(_,agt(_,_),sim),
	format("~nPontuações.") , nl ,
	descreve_pts(1) ,
	format("~nVitoria, parabens!~n") , nl , !.

passo4j(A,O,KB,humano) :-
	agt_ativo(KB) ,

	% Se for um jodador humano
	tipo_kb(KB,humano) ,

	% Leitura das mensagens recebidas pela KB compartilhada
	le_msg(KB) ,

	format("~nO jogador ativo e: jogador ~p",[KB]) ,
	agt(KB,[I,J]) ,
	format("~nA posicao atual do jogador ~p e: ~p",[KB,[I,J]]) ,

	% --------------------------------------------------------------
	% A percepção inicial foi deslocada para a inicialização dos agentes
	% executada pelo java via JSON
	% --------------------------------------------------------------
	% Percepção inicial
	% percebe_ini_hum(KB,[I,J]) ,

	% --------------------------------------------------------------
	% A avaliação deve retornava false caso a ação não fosse permitida
	% mas retirei essa função porque dava erro na interface e substitui
	% pelo envio da operação rpt, resta saber se isso afeta as inferências...
	%	aval_acao(KB,[I,J],A,O,[NI,NJ],_,O) ,
	% --------------------------------------------------------------

	% Calcula o risco e faz inferências
	risco(KB,[I,J],[NI,NJ],A,R) ,

	format("~nA proxima acao do jogador ~p sera: ~p ",[KB,A]) ,
	format("~nA proxima posicao do jogador ~p sera: ~p ",[KB,[NI,NJ]]) ,
	format("~nO risco de morte nesta acao e de: ~p por cento~n~n",[R]) ,

	% Descrece a situação após a ação
	format("-> O jogador ~p executou a acao: ~p~n",[KB,A]) ,

	% Toma a ação de acordo com a escolha feita
	acao(KB,[NI,NJ],A,O) ,

	% Percepção
	percebe_hum(KB,[NI,NJ]) ,

	% Ativa o próximo agente
	set_agt(KB) ,

	format("~n~nFim da acao de um passo.~n~n") , !.

passo4j(A,_,KB,agente) :-
	agt_ativo(KB) ,

	% Se for um agente
	tipo_kb(KB,agente) ,

	% Leitura das mensagens recebidas pela KB compartilhada
	le_msg(KB) ,

	format("~nO agente ativo e: agente ~p",[KB]) ,
	agt(KB,[I,J]) ,
	format("~nA posicao atual do agente ~p e: ~p",[KB,[I,J]]) ,

	% --------------------------------------------------------------
	% A percepção inicial foi deslocada para a inicialização dos agentes
	% executada pelo java via JSON
	% --------------------------------------------------------------
	% Percepção inicial
	% percebe_ini_agt(KB,[I,J]) ,

	% Calcula a ação em função do risco de morte (executa inferências)
	risco(KB,[I,J],[NI,NJ],A,R) ,

	format("~nA proxima acao do agente ~p sera: ~p ",[KB,A]) ,
	format("~nA proxima posicao do agente ~p sera: ~p ",[KB,[NI,NJ]]) ,
	format("~nO risco de morte nesta acao e de: ~p por cento~n~n",[R]) ,

	% Descrece a situação após a ação
	format("-> O agente ~p executou a acao: ~p~n",[KB,A]) ,

	% Toma a ação de acordo com o atual estratégia e objetivo
	acao(KB,[NI,NJ],A,_) ,

	% Percepção
	percebe_agt(KB,[NI,NJ]) ,

	% Ativa o próximo agente
	set_agt(KB) ,

	format("~n~nFim da acao de um passo.~n~n") , !.

%------------------------------------------------------------
%
% BASES DE CONHECIMENTO DO JOGO (KBS)
%    ATENÇÃO ESTES PREDICADOS NÃO PODEM SER MOVIDOS PARA
%    ACIMA DE ONDE ESTÃO POSICIONADOS
%
%------------------------------------------------------------
%------------------------------------------------------------
% Base de Conhecimento do JOGO SEM VALOR DEFINIDO PARA KB
%
%------------------------------------------------------------
% FATOS
%------------------------------------------------------------

ini([1,1]).
acoes_hum(['1','2','3','4','5','6','7','8','9','0']).

%------------------------------------------------------------
% REGRAS
%------------------------------------------------------------

pos_i_j([I,J]) :- number(I) , number(J) , !.

pos_result([P,O,N]) :-
	pos_i_j(P) ,
	atom(O) ,
	number(N) ,
	pertence(O,[wumpus,ouro,buraco,impasse]) , !.

pos_val([I,J])  :- mat(L), I > 0 , I < L + 1 , J > 0 , J < L + 1 .

pos_adj([I,J],[X,Y]) :- n([I,J],[X,Y]) , pos_val([X,Y]).
pos_adj([I,J],[X,Y]) :- s([I,J],[X,Y]) , pos_val([X,Y]).
pos_adj([I,J],[X,Y]) :- l([I,J],[X,Y]) , pos_val([X,Y]).
pos_adj([I,J],[X,Y]) :- o([I,J],[X,Y]) , pos_val([X,Y]).

pos_dgnl([I,J],[X,Y]) :- ne([I,J],[X,Y]) , pos_val([X,Y]).
pos_dgnl([I,J],[X,Y]) :- se([I,J],[X,Y]) , pos_val([X,Y]).
pos_dgnl([I,J],[X,Y]) :- so([I,J],[X,Y]) , pos_val([X,Y]).
pos_dgnl([I,J],[X,Y]) :- no([I,J],[X,Y]) , pos_val([X,Y]).

prd([I,J],[X,Y],norte) :- n([I,J],[X,Y]) , not(pos_val([X,Y])).
prd([I,J],[X,Y],sul) :- s([I,J],[X,Y]) , not(pos_val([X,Y])).
prd([I,J],[X,Y],leste) :- l([I,J],[X,Y]) , not(pos_val([X,Y])).
prd([I,J],[X,Y],oeste) :- o([I,J],[X,Y]) , not(pos_val([X,Y])).

%------------------------------------------------------------
% Base de Conhecimento de COMUNICAÇÃO POR MENSAGENS ONDE
% KB = -1
%
%------------------------------------------------------------
% FATOS
%------------------------------------------------------------

kb_msg(-1).

%------------------------------------------------------------
% Base de Conhecimento do TABULEIRO ONDE KB = 0
%
%------------------------------------------------------------
% FATOS DA KB = 0
%------------------------------------------------------------

kb_mat(0).

%------------------------------------------------------------
% REGRAS DA KB = 0
%------------------------------------------------------------

fdr(KB,[I,J]) :-
	kb_mat(KB) ,
	wps(KB,[X,Y]) ,
	pos_adj([X,Y],[I,J]).

vnt(KB,[I,J]) :-
	kb_mat(KB) ,
	brc(KB,[X,Y]) ,
	pos_adj([X,Y],[I,J]).

blh(KB,[I,J]) :-
	kb_mat(KB) ,
	our(KB,[X,Y]) ,
	pos_adj([X,Y],[I,J]).

%------------------------------------------------------------
% Base de Conhecimento DOS JOGADORES (AGENTES) ONDE OS
% VALORES PARA KB SÃO NÚMEROS INTEIROS POSITIVOS
%
%------------------------------------------------------------
% FATOS PARA AS KBS > 0
%------------------------------------------------------------

%------------------------------------------------------------
% REGRAS PARA AS KBS > 0
%------------------------------------------------------------

% Ver comentário importante abaixo
ppa(KB,[I,J],sim) :-
	lista_ppa(KB,LA) ,
	pertence([I,J],LA) , ! .
ppa(KB,[I,J],nao) :-
	lista_ppa(KB,LA) ,
	not(pertence([I,J],LA)) , ! .

/*
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
 OBSERVAÇÃO IMPORTANTE A RESPEITO DO PREDICADO ppa ACIMA:
------------------------------------------------------------

 Nota-se que foi necessário repetir a segunda chamada do
 predicado alterando-se a função pertence para uma condição
 de negação, porque o seguine erro de execução estava ocorrendo:

1- na inicialização do jogo executo um predicado para iniciar
as listas de posições visitadas:

assert(lista_ppa(KB,[[I,J]])), onde I = 1 e J = 1.

2- esta lista é usada para saber se uma dada posição já foi
visitada por meio de um predicado (versão original dele)
conforme abaixo:

ppa(KB,[I,J],sim) :-
	lista_ppa(KB,LA) ,
	pertence([I,J],LA) , ! .
ppa(_,_,nao) :- !.

3- quando abre o prolog e antes de fazer qualquer coisa você
pode executar o predicado acima e o resultado é:

1 ?- ppa(1,[1,1],sim).
false.

2 ?- ppa(1,[1,1],nao).
true.

4- mas depois que a função main é chamada ocorre um falso positivo,
e o resultado deveria se inverter ppa/sim deveria responder true e
ppa/nao deveria responder false, mas não é o que ocorre veja:

1 ?- main(5,2,2).

...

Cenário randômico adotado.

O Wumpus está na posição: [2,3]
O Ouro está na posição: [1,3]
Os buracos estão nas posições: [[2,4]], [[1,4]] e [[1,5]]

true.

2 ?- ppa(1,[1,1],nao).
true.

3 ?- ppa(1,[1,1],sim).
true.

5- descobri que isso ocorre exatamente depois de:

assert(lista_ppa(KB,[[I,J]]))

6- resumindo esse negócio está misterioso...
porque uma função do próprio prolog (que está em 1)
está gerando esse efeito colateral?
eu não sei bem, parece que é bug...
Esta é a grande questão, e que está me causando tanto problema.

------------------------------------------------------------
------------------------------------------------------------

Não sei se tem alguma coisa a ver mas retirei o envio de mensagem
ppa do insere lista e coloquei juntamente com os controles de movimento
já que foram adicionadas mensagem de repetição de jogada
vamos ver o efeito disso depois

------------------------------------------------------------
*/

ins_lista_ppa(_,P,LPV) :-
	% verifica se já pertence à lista
	pertence(P,LPV) , !.
ins_lista_ppa(KB,P,LPV) :-
	insere(P,LPV,LPVR) ,
	retractall(lista_ppa(KB,_)) ,
	assert(lista_ppa(KB,LPVR)) , !.

rem_lista_ppa(KB,P,LPV) :-
	remove(P,LPV,LPVR) ,
	retractall(lista_ppa(KB,_)) ,
	assert(lista_ppa(KB,LPVR)) , !.

pos_lvr(KB,[I,J]) :- ppa(KB,[I,J],sim) , ! .
pos_lvr(KB,[I,J]) :- not(brc(KB,[I,J])) , not(wps(KB,[I,J])).

bum(KB,[I,J],O) :-
	kb_mat(KBM) ,
	KB > KBM ,
	prd([I,J],_,O).

%------------------------------------------------------------
%
% CÁLCULO SITUACIONAL
%
%------------------------------------------------------------

%------------------------------------------------------------
%
% Percepões
%------------------------------------------------------------
%------------------------------------------------------------
% Percepções do agente de acordo com a situação
%------------------------------------------------------------

agt_pcb(KB,[I,J],[BLH,[BUMN,BUMS,BUML,BUMO],FDR,GRT,VNT]) :-
	pcb_blh(KB,[I,J],BLH) ,
	pcb_bum(KB,[I,J],BUMN,norte) ,
	pcb_bum(KB,[I,J],BUMS,sul) ,
	pcb_bum(KB,[I,J],BUML,leste) ,
	pcb_bum(KB,[I,J],BUMO,oeste) ,
	pcb_fdr(KB,[I,J],FDR) ,
	pcb_grt(KB,[I,J],GRT) ,
	pcb_vnt(KB,[I,J],VNT) , !.

pcb_blh(KB,[I,J],sim) :-
	kb_mat(KBM) ,
	blh(KBM,[I,J]) ,
	assert(blh(KB,[I,J])) ,
	envia_msg(KB,broadcast,blh,[I,J]) , !.
pcb_blh(_,_,nao).

pcb_bum(KB,[I,J],sim,O) :-
	bum(KB,[I,J],O) ,
	assert(bum(KB,[I,J],O)) , !.
pcb_bum(_,_,nao,_).

pcb_fdr(KB,[I,J],sim) :-
	kb_mat(KBM) ,
	fdr(KBM,[I,J]) ,
	assert(fdr(KB,[I,J])) ,
	envia_msg(KB,broadcast,fdr,[I,J]) , !.
pcb_fdr(_,_,nao).

pcb_grt(KB,_,sim) :-
	kb_mat(KBM) ,
	wps(KBM,[X,Y]) ,
	grt(KB,wps(KB,[X,Y])) ,

	% Atualiza situação do Wumpus na sua KB
	retractall(vivo(KB,wps(KB,_),sim)) ,
	assert(vivo(KB,wps(KB,[X,Y]),nao)) ,

	% Envia mensagem da grito
	envia_msg(KB,broadcast,grt,[X,Y]) ,

	% Não griga nunca mais
	retractall(grt(_,_)) , !.
pcb_grt(_,_,nao).

pcb_vnt(KB,[I,J],sim) :-
	kb_mat(KBM) ,
	vnt(KBM,[I,J]) ,
	assert(vnt(KB,[I,J])) ,
	envia_msg(KB,broadcast,vnt,[I,J]) , !.
pcb_vnt(_,_,nao).

%------------------------------------------------------------
%
% Cálculos
%------------------------------------------------------------
%------------------------------------------------------------
% Cálculo do número de paredes
%------------------------------------------------------------

prd_n(KB,[I,J],1) :- bum(KB,[I,J],norte) , !.
prd_n(_,_,0).

prd_s(KB,[I,J],1) :- bum(KB,[I,J],sul) , !.
prd_s(_,_,0).

prd_l(KB,[I,J],1) :- bum(KB,[I,J],leste) , !.
prd_l(_,_,0).

prd_o(KB,[I,J],1) :- bum(KB,[I,J],oeste) , !.
prd_o(_,_,0).

conta_prds(KB,[I,J],TP) :-
	prd_n(KB,[I,J],Pn) ,
	prd_s(KB,[I,J],Ps) ,
	prd_l(KB,[I,J],Pl) ,
	prd_o(KB,[I,J],Po) ,
	TP is (Pn + Ps + Pl + Po) .

%------------------------------------------------------------
% Cálculo do número de fedores
%------------------------------------------------------------

fdr_n(KB,[I,J],1) :- n([I,J],[X,Y]) , fdr(KB,[X,Y]) , !.
fdr_n(_,_,0).

fdr_s(KB,[I,J],1) :- s([I,J],[X,Y]) , fdr(KB,[X,Y]) , !.
fdr_s(_,_,0).

fdr_l(KB,[I,J],1) :- l([I,J],[X,Y]) , fdr(KB,[X,Y]) , !.
fdr_l(_,_,0).

fdr_o(KB,[I,J],1) :- o([I,J],[X,Y]) , fdr(KB,[X,Y]) , !.
fdr_o(_,_,0).

conta_fdrs(KB,[I,J],TF) :-
	fdr_n(KB,[I,J],Fn) ,
	fdr_s(KB,[I,J],Fs) ,
	fdr_l(KB,[I,J],Fl) ,
	fdr_o(KB,[I,J],Fo) ,
	TF is (Fn + Fs + Fl + Fo) .

%------------------------------------------------------------
% Cálculo do número de ventos
%------------------------------------------------------------

vnt_n(KB,[I,J],1) :- n([I,J],[X,Y]) , vnt(KB,[X,Y]) , !.
vnt_n(_,_,0).

vnt_s(KB,[I,J],1) :- s([I,J],[X,Y]) , vnt(KB,[X,Y]) , !.
vnt_s(_,_,0).

vnt_l(KB,[I,J],1) :- l([I,J],[X,Y]) , vnt(KB,[X,Y]) , !.
vnt_l(_,_,0).

vnt_o(KB,[I,J],1) :- o([I,J],[X,Y]) , vnt(KB,[X,Y]) , !.
vnt_o(_,_,0).

conta_vnts(KB,[I,J],TV) :-
	vnt_n(KB,[I,J],Tn) ,
	vnt_s(KB,[I,J],Ts) ,
	vnt_l(KB,[I,J],Tl) ,
	vnt_o(KB,[I,J],To) ,
	TV is (Tn + Ts + Tl + To) .

%------------------------------------------------------------
% Cálculo do número de brilhos
%------------------------------------------------------------

blh_n(KB,[I,J],1) :- n([I,J],[X,Y]) , blh(KB,[X,Y]) , !.
blh_n(_,_,0).

blh_s(KB,[I,J],1) :- s([I,J],[X,Y]) , blh(KB,[X,Y]) , !.
blh_s(_,_,0).

blh_l(KB,[I,J],1) :- l([I,J],[X,Y]) , blh(KB,[X,Y]) , !.
blh_l(_,_,0).

blh_o(KB,[I,J],1) :- o([I,J],[X,Y]) , blh(KB,[X,Y]) , !.
blh_o(_,_,0).

conta_blhs(KB,[I,J],TB) :-
	blh_n(KB,[I,J],Tn) ,
	blh_s(KB,[I,J],Ts) ,
	blh_l(KB,[I,J],Tl) ,
	blh_o(KB,[I,J],To) ,
	TB is (Tn + Ts + Tl + To) .

%------------------------------------------------------------
% Cálculo do número de posições visitadas
%------------------------------------------------------------

ppa_n(KB,[I,J],1) :- n([I,J],[X,Y]) , ppa(KB,[X,Y],sim) , !.
ppa_n(_,_,0).

ppa_s(KB,[I,J],1) :- s([I,J],[X,Y]) , ppa(KB,[X,Y],sim) , !.
ppa_s(_,_,0).

ppa_l(KB,[I,J],1) :- l([I,J],[X,Y]) , ppa(KB,[X,Y],sim) , !.
ppa_l(_,_,0).

ppa_o(KB,[I,J],1) :- o([I,J],[X,Y]) , ppa(KB,[X,Y],sim) , !.
ppa_o(_,_,0).

conta_ppas(KB,[I,J],TA) :-
	ppa_n(KB,[I,J],Tn) ,
	ppa_s(KB,[I,J],Ts) ,
	ppa_l(KB,[I,J],Tl) ,
	ppa_o(KB,[I,J],To) ,
	TA is (Tn + Ts + Tl + To) .

%------------------------------------------------------------
% Faz algumas totalizações
%------------------------------------------------------------

soma_fdr_prd(KB,[I,J],TPF) :-
	conta_fdrs(KB,[I,J],TF) ,
	conta_prds(KB,[I,J],TP) ,
	TPF is (TF + TP) .

soma_vnt_prd(KB,[I,J],TPV) :-
	conta_vnts(KB,[I,J],TV) ,
	conta_prds(KB,[I,J],TP) ,
	TPV is (TV + TP) .

soma_blh_prd(KB,[I,J],TPB) :-
	conta_blhs(KB,[I,J],TB) ,
	conta_prds(KB,[I,J],TP) ,
	TPB is (TB + TP) .

soma_ppa_prd(KB,[I,J],TPA) :-
	conta_ppas(KB,[I,J],TA) ,
	conta_prds(KB,[I,J],TP) ,
	TPA is (TA + TP) .

soma_wps(KB,[I,J],1) :-
	fdr(KB,[I,J]) ,
	wps(KB,W) ,
	pos_adj([I,J],W) , !.
soma_wps(_,_,0).

soma_brc(KB,[I,J],T) :-
	vnt(KB,[I,J]) ,
	findall(brc(KB,B),pos_adj([I,J],B),LBRC) ,
	total_elementos(LBRC,T).

soma_wps_brc(KB,[I,J],T) :-
	soma_wps(KB,[I,J],T1) ,
	soma_brc(KB,[I,J],T2) ,
	T is T1 + T2 .

%------------------------------------------------------------
%
% Inferências
% (cálculo de risco de morte em função da KB para a ação)
%------------------------------------------------------------
%------------------------------------------------------------
% Risco para inferência dos objetivos primários
%------------------------------------------------------------
%------------------------------------------------------------
% Como só há um ouro, se dois brilhos estão a minha volta então na
% diagonal entre eles está o ouro, o fail ocorre pois ainda não
% foi feita avaliação de outros perigos
%------------------------------------------------------------

risco(KB,[I,J],_,mover,0) :- % Só funciona assim para 1 ouro
	agt_obj(KB,ouro) ,
	not(blh(KB,[I,J])),
	conta_blhs(KB,[I,J],2) ,

	% Descobre a diagonal
	pos_dgnl([I,J],[ID,JD]) ,
	conta_blhs(KB,[ID,JD],2) ,

	% Infere a posição do ouro (só para um único ouro)
	retractall(our(KB,_)) ,
	assert(our(KB,[ID,JD])),
	envia_msg(KB,broadcast,our,[ID,JD]) ,

	% Infere brilhos
	infere_blhs(KB,[ID,JD]) ,

	fail .

%------------------------------------------------------------
% Como só há um Wumpus, se dois fedores estão a minha volta então na
% diagonal entre eles está o Wumpus o fail ocorre pois não há
% avaliação de outros perigos
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :- % Só funciona assim para 1 Wumpus
	agt_obj(KB,wumpus) ,
	not(fdr(KB,[I,J])),
	conta_fdrs(KB,[I,J],2) ,

	% Descobre a diagonal
	pos_dgnl([I,J],[ID,JD]) ,
	conta_fdrs(KB,[ID,JD],2) ,

	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,

	% Infere a posição do Wumpus (só para um único Wumpus)
	retractall(wps(KB,_)) ,
	assert(wps(KB,[ID,JD])) ,
	envia_msg(KB,broadcast,wps,[ID,JD]) ,

	% Infere fedores
	infere_fdrs(KB,[ID,JD]) ,

	fail.

%------------------------------------------------------------
% Caso esteja em uma quina do tabuleiro com vento, exceto na posição
% inicial então um buraco está na posição não visitada, pois
% se já tivesse visitada já teria morrido
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],impasse,100) :-
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	vnt(KB,[I,J]) ,

	% Não funciona para a posição inicial
	not(ini([I,J])) ,
	conta_prds(KB,[I,J],2) ,

	% Infere o local de um buraco
	assert(brc(KB,[X,Y])) ,
	envia_msg(KB,broadcast,brc,[X,Y]) ,

	% Infere ventos
	infere_vnts(KB,[X,Y]) ,

	fail .

%------------------------------------------------------------
% Caso esteja em uma posição que tem vento e tem fedor e se
% esta posição tem parede, não há posições livres a não ser
% aquela de onde o agente veio. Se alem disso o Wumpus já foi
% inferido e está em uma das adjuntas, pode-se inferir um
% buraco e vice versa.
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],impasse,100) :-
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	fdr(KB,[I,J]) ,
	vnt(KB,[I,J]) ,
	conta_prds(KB,[I,J],1) ,
	wps(KB,[XW,YW]) ,
	pos_adj([I,J],[XW,YW]) ,
	(XW =\= X ; YW =\= Y) ,

	% Infere o local de um buraco
	assert(brc(KB,[X,Y])) ,
	envia_msg(KB,broadcast,brc,[X,Y]) ,

	% Infere ventos
	infere_vnts(KB,[X,Y]) ,

	fail .

risco(KB,[I,J],[X,Y],impasse,100) :-
	agt_obj(KB,wumpus) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	fdr(KB,[I,J]) ,
	vnt(KB,[I,J]) ,
	conta_prds(KB,[I,J],1) ,
	brc(KB,[XW,YW]) ,
	pos_adj([I,J],[XW,YW]) ,
	(XW =\= X ; YW =\= Y) ,

	% Infere o local do Wumpus
	assert(wps(KB,[X,Y])) ,
	envia_msg(KB,broadcast,wps,[X,Y]) ,

	% Infere fedores
	infere_fdrs(KB,[X,Y]) ,

	fail .

risco(KB,[I,J],[X,Y],impasse,100) :-
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	fdr(KB,[I,J]) ,
	vnt(KB,[I,J]) ,
	conta_prds(KB,[I,J],1) ,

	fail .

%------------------------------------------------------------
% Caso ele esteja em um fedor e as outras posições adjuntas
% ja tenham sido visitadas infere a posição do Wumpus
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],impasse,100) :-
	agt_obj(KB,wumpus) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	fdr(KB,[I,J]) ,
	soma_ppa_prd(KB,[I,J],3) ,

	% Infere a posição do Wumpus
	retractall(wps(KB,_)) ,
	assert(wps(KB,[X,Y])),
	envia_msg(KB,broadcast,wps,[X,Y]) ,

	% Infere fedores
	infere_fdrs(KB,[X,Y]) ,

	fail .

%------------------------------------------------------------
% Caso ele esteja em um vento e as outras posições adjuntas
% ja tenham sido visitadas infere a posição de um buraco
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],impasse,100) :-
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	vnt(KB,[I,J]) ,
	soma_ppa_prd(KB,[I,J],3) ,

	% Infere a posição do buraco
	assert(brc(KB,[X,Y])),
	envia_msg(KB,broadcast,brc,[X,Y]) ,

	% Infere ventos
	infere_vnts(KB,[X,Y]) ,

	fail .

%------------------------------------------------------------
% Risco para ação de impasse após inferencias
%------------------------------------------------------------
%------------------------------------------------------------
% Se na posição inicial tem fedor e vento é um impasse
% - TOTALMENTE SEM SAIDA, mesmo se atirar
% ------------------------------------------------------------

risco(KB,[I,J],_,impasse,100) :-
	ini([I,J]) ,
	vnt(KB,[I,J]) ,
	fdr(KB,[I,J]) ,
	fail .

%------------------------------------------------------------
% Risco zero para operações de não movimento
%------------------------------------------------------------
%------------------------------------------------------------
% Caso esteja de volta na posição inicial e tenha cumprido os objetivos
% pode sair
%------------------------------------------------------------

risco(KB,[I,J],[I,J],sair,0) :-
	agt_obj(KB,sair) ,
	ini([I,J]) , !.

%------------------------------------------------------------
% Caso esteja em uma posição onde está o ouro pode pegá-lo
%------------------------------------------------------------

risco(KB,[I,J],[I,J],pegar_ouro,0) :-
	agt_obj(KB,ouro) ,
	kb_mat(KBM) ,

	% Pegar o ouro caso caia na posição mesmo sem ter inferido
	our(KBM,[I,J]) ,

	% Pegar se ninguem pegou ainda
	our(_,agt(_,_),nao) ,

	% Se caiu numa casa onde o ouro está sem ter inferido
	retractall(our(KB,_)) ,
	assert(our(KB,[I,J])) ,
	envia_msg(KB,broadcast,our,[I,J]) , !.

%------------------------------------------------------------
% Caso haja 3 ou 4 paredes + fedores em volta da posição para qual
% estaria indo, então o Wumpus está lá
%------------------------------------------------------------

risco(KB,[I,J],[I,J],atirar,0) :-
	agt_obj(KB,wumpus) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),sim) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,

	% 3 fedores, só funciona assim para 1 Wumpus
	soma_fdr_prd(KB,[X,Y],T) ,
	(T == 3 ; T == 4) ,

	% Infere o local do Wumpus
	retractall(wps(KB,_)) ,
	assert(wps(KB,[X,Y])) ,
	envia_msg(KB,broadcast,wps,[X,Y]) ,

	% Infere fedores
	infere_fdrs(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso esteja em uma quina do tabuleiro com fedor, então o Wumpus
% deve estar na posição não visitada desde que a posição de origem não
% seja a primeira, neste caso o tiro será dado a esmo apenas para
% validar a provável posição do Wumpus
%------------------------------------------------------------

risco(KB,[I,J],[I,J],atirar,0) :-
	agt_obj(KB,wumpus) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),sim) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	fdr(KB,[I,J]) ,
	conta_prds(KB,[I,J],2) ,

	% é a posição inicial
	ini([I,J]) ,

	% infere para atirar a esmo
	assert(wps(KB,[X,Y])) , !.

risco(KB,[I,J],[I,J],atirar,0) :-
	agt_obj(KB,wumpus) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),sim) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	fdr(KB,[I,J]) ,
	conta_prds(KB,[I,J],2) ,

	% não é a posição inicial
	not(ini([I,J])) ,

	% Infere o local do Wumpus
	retractall(wps(KB,_)) ,
	assert(wps(KB,[X,Y])) ,
	envia_msg(KB,broadcast,wps,[X,Y]) ,

	% Infere fedores
	infere_fdrs(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso ele já conheça a posição do Wumpus naquela a qual ele está indo
%------------------------------------------------------------

risco(KB,[I,J],[I,J],atirar,0) :-
	agt_obj(KB,wumpus) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),sim) ,
	mirar_wps(KB,[I,J]) , !.

%------------------------------------------------------------
% Risco para posições não visitadas do menor para o maior
%------------------------------------------------------------
%------------------------------------------------------------
% Se já conhece a posição do Wumpus e está na posição inicial
% move para a posição oposta independentemente de ser ou não
% uma posição visitada
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	ini([I,J]) ,
	pos_adj([I,J],[X,Y]) ,
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso esteja em uma quina do tabuleiro com brilho, exceto na posição
% inicial então o ouro está na posição não visitada, pois se já tivesse
% visitada já teria pego o ouro
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	blh(KB,[I,J]) ,

	% Não funciona para a posição inicial
	not(ini([I,J])) ,
	conta_prds(KB,[I,J],2) ,

	% Infere o local do ouro
	retractall(our(KB,_)) ,
	assert(our(KB,[X,Y])) ,
	envia_msg(KB,broadcast,our,[X,Y]) ,

	% Infere brilhos
	infere_blhs(KB,[X,Y]) ,
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso ele esteja em um brilho e as outras posições adjuntas
% ja tenham sido visitadas infere a posição do ouro
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	blh(KB,[I,J]) ,
	soma_ppa_prd(KB,[I,J],3) ,

	% Infere a posição do ouro
	retractall(our(KB,_)) ,
	assert(our(KB,[X,Y])),
	envia_msg(KB,broadcast,our,[X,Y]) ,

	% Infere os brilhos
	infere_blhs(KB,[X,Y]) ,
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso haja 4 paredes + brilhos em volta da posição para qual estou
% indo o ouro está lá
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,

	% 3 brilhos, só funciona assim para 1 ouro
	soma_blh_prd(KB,[X,Y],T) ,
	(T == 3 ; T == 4) ,

	% Infere o local do ouro
	retractall(our(KB,_)) ,
	assert(our(KB,[X,Y])),
	envia_msg(KB,broadcast,our,[X,Y]) ,

	% Infere brilhos
	infere_blhs(KB,[X,J]) ,

	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso ele esteja em um brilho e as outras posições adjuntas
% não tenham sido visitadas move-se para uma delas
% desde que não haja fedores e nem ventos no local onde está
% porque neste caso deve prevalecer a regra de fedores e ventos
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	blh(KB,[I,J]) ,
	not(fdr(KB,[I,J])) ,
	not(vnt(KB,[I,J])) ,
	soma_ppa_prd(KB,[I,J],T) ,
	(T == 1 ; T == 2) ,
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso esteja em uma posição sem fedor e sem vento então procura uma
% adjunta não visitada para mover-se com risco zero, neste caso
% considera a soma de fedores em volta de si como 1 ou zero para
% restringir o caso das diagonais, já que o calculo com diagonais
% foi feito mais acima. Também só funciona para 1 Wumpus
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	not(fdr(KB,[I,J])) ,
	not(vnt(KB,[I,J])) ,
	conta_fdrs(KB,[I,J],T) ,
	(T == 0 ; T == 1) ,
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso esteja em uma posição sem fedor e sem vento então procura uma
% adjunta não visitada para mover-se com risco zero (essa duplica a de
% cima) mas funciona para qualquer caso
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	not(fdr(KB,[I,J])) ,
	not(vnt(KB,[I,J])) ,
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso esteja em uma posição com fedor ou vento tem um
% terço de chances de morrer em posições não visitadas
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,33) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	pos_lvr(KB,[X,Y]) ,
	(fdr(KB,[I,J]) ; vnt(KB,[I,J])) ,
	conta_prds(KB,[I,J],0) ,
	conta_ppas(KB,[I,J],1) , !.

%------------------------------------------------------------
% Caso esteja em uma posição com fedor ou vento tem um
% metade das chances de morrer em posições não visitadas
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,50) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	pos_lvr(KB,[X,Y]) ,
	(fdr(KB,[I,J]) ; vnt(KB,[I,J])) ,
	conta_prds(KB,[I,J],0) ,
	conta_ppas(KB,[I,J],2) , !.

risco(KB,[I,J],[X,Y],mover,50) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	pos_lvr(KB,[X,Y]) ,
	(fdr(KB,[I,J]) ; vnt(KB,[I,J])) ,
	conta_prds(KB,[I,J],1) ,
	conta_ppas(KB,[I,J],1) , !.

%------------------------------------------------------------
% Caso esteja em uma quina com fedor ou com vento então a
% posição adjunta não visitada pode ou não ter Wumpus ou buraco,
% considerando-se o caso especial onde a quina é a posição inicial
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,50) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	pos_lvr(KB,[X,Y]) ,

	% cláusulas separadas (ou exclusivo)
	vnt(KB,[I,J]) ,
	(conta_prds(KB,[I,J],1) ;
	(conta_prds(KB,[I,J],2) ,

	% Duas paredes só ocorrem na posição [1,1]
	ini([I,J]))) , !.

risco(KB,[I,J],[X,Y],mover,50) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	pos_lvr(KB,[X,Y]) ,

	% cláusulas separadas (ou exclusivo)
	fdr(KB,[I,J]) ,
	(conta_prds(KB,[I,J],1) ;
	(conta_prds(KB,[I,J],2) ,

	% Duas paredes só ocorrem na posição [1,1]
	ini([I,J]))) , !.

%------------------------------------------------------------
% Caso esteja em uma posição que tem vento e tem fedor, entao
% e a posiçao que estou indo está livre a chance de morte é de
% 66 por cento.
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,66) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	fdr(KB,[I,J]) ,
	vnt(KB,[I,J]) ,
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Caso haja 4 ventos em volta da posição para o qual estou indo, há
% grande possibilidade de haver buraco, mas como há mais de um buraco no
% jogo há também possibilidade de não haver buraco lá, então apliquei um
% risco suposto de 90 por cento, mas esta regra pode ser melhorada,
% consultando-se as posições de buracos já conhecidos e posições já
% visitadas
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,90) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	soma_vnt_prd(KB,[X,Y],4) ,
	% para inferir buraco deve calcular a possibilidade em função do número
	% de buracos do tabuleiro na inicialização
	pos_lvr(KB,[X,Y]) , !.

%------------------------------------------------------------
% Risco para ação de impasse
%------------------------------------------------------------
%------------------------------------------------------------
% Todas as posições ao seu redor já foram visitadas
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	soma_ppa_prd(KB,[I,J],4) ,
	pos_adj([I,J],[X,Y]) , !.

%------------------------------------------------------------
% Se uma adjutnta é Wumpus e todas as posições
% ao seu redor já foram visitadas - PROCURAR UMA VISITADA
% ------------------------------------------------------------

risco(KB,[I,J],[X,Y],impasse,100) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	soma_ppa_prd(KB,[I,J],3) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	wps(KB,[X,Y]) ,
	fail.

%------------------------------------------------------------
% Se uma adjutnta é buraco e todas as posições
% ao seu redor já foram visitadas - PROCURAR UMA VISITADA
% ------------------------------------------------------------

risco(KB,[I,J],[X,Y],impasse,100) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	soma_ppa_prd(KB,[I,J],3) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],nao) ,
	brc(KB,[X,Y]) ,
	fail .

%------------------------------------------------------------
% Se a soma de visitadas, paredes, buracos e wumpus a sua volta
% for 4 - PROCURAR UMA VISITADA
% ------------------------------------------------------------

risco(KB,[I,J],[X,Y],impasse,100) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	soma_ppa_prd(KB,[I,J],T1) ,
	soma_wps_brc(KB,[I,J],T2) ,
	T is T1 + T2 ,
	T == 4 ,
	pos_adj([I,J],[X,Y]) ,
	fail .

%------------------------------------------------------------
% Risco para posições visitadas
%------------------------------------------------------------
%------------------------------------------------------------
% Caso esteja indo para uma posição já visitada anteriormente
% não há perigo
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	(agt_obj(KB,wumpus) ;
	agt_obj(KB,ouro)) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],sim) , !.

%------------------------------------------------------------
% Caso o objetivo seja sair, procura por posições visitadas
% onde o x ou o y sejam sempre menores do que a posição onde
% está
%------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,0) :-
	agt_obj(KB,sair) ,
	pos_adj([I,J],[X,Y]) ,
	ppa(KB,[X,Y],sim) ,
	(X < I ; Y < J) , !.

%------------------------------------------------------------
% Risco para ação sem movimento a esmo
%------------------------------------------------------------
%------------------------------------------------------------
% Caso deseje atirar a esmo
%------------------------------------------------------------

risco(KB,[I,J],[I,J],atirar,0) :-
	agt_obj(KB,wumpus) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),sim) , !.

%------------------------------------------------------------
% Risco para suicídio
%------------------------------------------------------------
% ------------------------------------------------------------
% Caso ele já conheça a posição do Wumpus ou de um buraco
% naquela a qual ele está indo
% ------------------------------------------------------------

risco(KB,[I,J],[X,Y],mover,100) :-
	pos_adj([I,J],[X,Y]) ,
	% Situação onde já inferiu o perigo
	not(pos_lvr(KB,[X,Y])) , !.

%------------------------------------------------------------
%
% AÇÕES
%
%------------------------------------------------------------
%------------------------------------------------------------
%
% Executa as ações do agente de acordo com a decisão tomada
%------------------------------------------------------------
%------------------------------------------------------------
% Pegando o ouro
%------------------------------------------------------------

acao(KB,[I,J],pegar_ouro,aqui) :-
	% Executa a ação
	agt_our(KB,[I,J]) , !.

%------------------------------------------------------------
% Atirando no Wumpus
%------------------------------------------------------------

acao(KB,_,atirar,_) :-
	(not(agt_obj(KB,wumpus)) ;
	fch(KB,agt(KB,_),nao)) , !.

acao(KB,[I,J],atirar,norte) :-
	% Executa a ação
	wps(KB,[X,Y]) ,
	X < I , Y == J ,
	atr_agt(KB,[I,J],norte) , !.

acao(KB,[I,J],atirar,sul) :-
	% Executa a ação
	wps(KB,[X,Y]) ,
	X > I , Y == J ,
	atr_agt(KB,[I,J],sul) , !.

acao(KB,[I,J],atirar,leste) :-
	% Executa a ação
	wps(KB,[X,Y]) ,
	X == I , Y > J ,
	atr_agt(KB,[I,J],leste) , !.

acao(KB,[I,J],atirar,oeste) :-
	% Executa a ação
	wps(KB,[X,Y]) ,
	X == I , Y < J ,
	atr_agt(KB,[I,J],oeste) , !.

acao(KB,[I,J],atirar,O) :-
	% Executa a ação
	atr_agt(KB,[I,J],O) , !.

%------------------------------------------------------------
% Movendo-se
%------------------------------------------------------------

acao(KB,[NI,NJ],mover,O) :-
	% Determina a orientação do movimento
	ori_agt(KB,[NI,NJ],[I,J],O) ,

	% Movimenta
	mov_agt(KB,[I,J],[NI,NJ],O) , !.

%------------------------------------------------------------
% Saindo da caverna
%------------------------------------------------------------

acao(KB,[I,J],sair_caverna,aqui) :-
	% Busca a saída
	agt_obj(KB,sair) ,
	sai_agt(KB,[I,J]) , !.

%------------------------------------------------------------
% Atualiza ação tomada na lista de ações por KB
%------------------------------------------------------------

atu_lacoes(KB,[I,J],A,O,LA) :-
	insere(O,[],OLA) ,
	insere(A,OLA,ACAOLA) ,
	insere([I,J],ACAOLA,POSLA) ,
	insere(POSLA,LA,NLA) ,
	retractall(lista_acoes(KB,_)) ,
	assert(lista_acoes(KB,NLA)) , !.

%------------------------------------------------------------
% Determina a orientação do movimento
%------------------------------------------------------------

ori_agt(KB,[X,Y],[I,J],norte) :-
	agt(KB,[I,J]) ,
	e_norte([I,J],[X,Y],norte) , !.

ori_agt(KB,[X,Y],[I,J],sul) :-
	agt(KB,[I,J]) ,
	e_sul([I,J],[X,Y],sul), !.

ori_agt(KB,[X,Y],[I,J],leste) :-
	agt(KB,[I,J]) ,
	e_leste([I,J],[X,Y],leste) , !.

ori_agt(KB,[X,Y],[I,J],oeste) :-
	agt(KB,[I,J]) ,
	e_oeste([I,J],[X,Y],oeste) , !.

%------------------------------------------------------------
% Determina a o movimento pela orientação
%------------------------------------------------------------

ori_mov(KB,[I,J],[X,Y],norte) :-
	agt(KB,[I,J]) ,
	n([I,J],[X,Y]) , !.

ori_mov(KB,[I,J],[X,Y],sul) :-
	agt(KB,[I,J]) ,
	s([I,J],[X,Y]) , !.

ori_mov(KB,[I,J],[X,Y],leste) :-
	agt(KB,[I,J]) ,
	l([I,J],[X,Y]) , !.

ori_mov(KB,[I,J],[X,Y],oeste) :-
	agt(KB,[I,J]) ,
	o([I,J],[X,Y]) , !.

%------------------------------------------------------------
% Mirando no Wumpus
%------------------------------------------------------------

mirar_wps(KB,[I,J]) :-
	mirar_wps_i(KB,[1,J]) ;
	mirar_wps_j(KB,[I,1]) .

mirar_wps_i(_,[I,_]) :-
	mat(M) ,
	I > M ,
	! , fail .
mirar_wps_i(KB,[I,J]) :-
	NI is I + 1 ,
	(wps(KB,[I,J]) ;
	 mirar_wps_i(KB,[NI,J])).

mirar_wps_j(_,[_,J]) :-
	mat(M) ,
	J > M ,
	! , fail .
mirar_wps_j(KB,[I,J]) :-
	NJ is J + 1 ,
	(wps(KB,[I,J]) ;
	 mirar_wps_j(KB,[I,NJ])).

%------------------------------------------------------------
% Dispara um tiro
%------------------------------------------------------------

tiro_wps(KB,[I,J],O) :-
	% Se acertou o Wumpus
	kb_mat(KBM) ,
	wps(KBM,[X,Y]) ,
	(e_norte([I,J],[X,Y],O) ;
	 e_sul([I,J],[X,Y],O) ;
	 e_leste([I,J],[X,Y],O) ;
	 e_oeste([I,J],[X,Y],O)) ,

	% Atualiza que matou o monstro
	assert(agt_wps(KB,agt(KB,[I,J]))) ,

	% Atualiza situação do Wumpus
	retractall(vivo(KBM,wps(KBM,_),sim)) ,
	assert(vivo(KBM,wps(KBM,[X,Y]),nao)) ,

	% Grava o grito
	assert(grt(KB,wps(KB,[X,Y]))) ,

	% Infere o novo local do Wumpus
	retractall(wps(KB,_)) ,
	assert(wps(KB,[X,Y])) ,

	% Infere a posição dos fedores
	infere_fdrs(KB,[X,Y]) ,

	format("~nParabens, o agente ~p acertou o Wumpus!",[KB]) , nl , !.

tiro_wps(KB,[I,J],_) :-
	% Se errou o tiro
	format("~nOps, errou e o Wumpus continua vivo!~n") , nl ,

	% Verifica se pode inferir a posição do Wumpus após o tiro
	wps(KB,[X,Y]) ,
	pos_adj([I,J],[NX,NY]) ,
	(NX =\= X , NY =\= Y) ,
	ppa(KB,[X,Y],nao) ,
	ppa(KB,[NX,NY],nao) ,
	fdr(KB,[I,J]) ,
	conta_prds(KB,[I,J],2) ,

	% Infere o novo local do Wumpus
	retractall(wps(KB,_)) ,
	assert(wps(KB,[NX,NY])) .

tiro_wps(KB,_,_) :-
	% Apagar a inferência incorreta
	wps(KB,[X,Y]) ,
	retract(wps(KB,[X,Y])) .

tiro_wps(_,_,_) :- !. % atirou a esmo sem inferir


%------------------------------------------------------------
% Infere a posição de todos os fedores
%------------------------------------------------------------

infere_fdrs(KB,[I,J]) :-
	pos_adj([I,J],[X,Y]) ,
	assert(fdr(KB,[X,Y])) ,
	fail.
infere_fdrs(KB,_) :-
	retractall(fdrs(KB,_)) ,
	assert(fdrs(KB,[])) ,
	lista_fdrs(KB) ,
	fdrs(KB,LFDRS) ,
	envia_msg(KB,broadcast,fdrs,LFDRS) , !.

%------------------------------------------------------------
% Infere a posição de todos os ventos
%------------------------------------------------------------

infere_vnts(KB,[I,J]) :-
	pos_adj([I,J],[X,Y]) ,
	assert(vnt(KB,[X,Y])) ,
	fail.
infere_vnts(KB,_) :-
	retractall(vnts(KB,_)) ,
	assert(vnts(KB,[])) ,
	lista_vnts(KB) ,
	vnts(KB,LVNTS) ,
	envia_msg(KB,broadcast,vnts,LVNTS) , !.

%------------------------------------------------------------
% Infere a posição de todos os brilhos
%------------------------------------------------------------

infere_blhs(KB,[I,J]) :-
	pos_adj([I,J],[X,Y]) ,
	assert(blh(KB,[X,Y])) ,
	fail.
infere_blhs(KB,_) :-
	retractall(blhs(KB,_)) ,
	assert(blhs(KB,[])) ,
	lista_blhs(KB) ,
	blhs(KB,LBLHS) ,
	envia_msg(KB,broadcast,blhs,LBLHS) , !.

%------------------------------------------------------------
% Verificando a condição do Agente após o movimento
%------------------------------------------------------------

vivo_agt(KB,[X,Y],_,_) :-
	% Verifica se a energia acabou
	pts_agt(KB,T) ,
	T =< 0 ,

	% Se o jogador morreu então mostra mensagem
	format("~nAcabou sua energia, voce morreu e esta fora do jogo!~n") , nl ,

	% Atualiza a ação tomada
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[X,Y],morreu,aqui,LA) ,

	% Atualiza contador para fim de jogo
	soma_off , !.
vivo_agt(KB,[X,Y],_,_) :-
	% Verifica se o agente esbarrou no Wumpus
	kb_mat(KBM) ,
	wps(KBM,[X,Y]) ,

	% verifica se O Wumpus está morto
	vivo(KB,wps(KB,[X,Y]),nao) ,

	% Atualiza a ação tomada
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[X,Y],esbarrao,aqui,LA) ,

	% Atualiza a pontuação
	redz_pnt(KB,5) ,

	% Mensagem
	format("O jogador ~p esbarrou no Wumpus morto! Escolha outro movimento.~n",[KB]) , nl , !.
vivo_agt(KB,[X,Y],_,_) :-
	% Verifica se o agente morreu pelo monstro
	kb_mat(KBM) ,
	wps(KBM,[X,Y]) ,

	% verifica se O Wumpus está vivo
	vivo(KB,wps(KB,[X,Y]),sim) ,

	% Atualiza a situação do agente para morto
	retract(vivo(KB,agt(KB,_),sim)) ,
	assert(vivo(KB,agt(KB,[X,Y]),nao)) ,

	% Atualiza pontuação do agente
	redz_pnt(KB,1000) ,

	% Se o jogador morreu então mostra mensagem
	format("~nO Wumpus te pegou, voce morreu e esta fora do jogo!~n") , nl ,

	% Atualiza a ação tomada
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[X,Y],morreu,aqui,LA) ,

	% Atualiza contador para fim de jogo
	soma_off , !.
vivo_agt(KB,[X,Y],_,_) :-
	% Verifica se o agente morreu caindo no buraco
	kb_mat(KBM) ,
	brc(KBM,[X,Y]) ,

	% Atualiza a situação do agente para morto
	retract(vivo(KB,agt(KB,_),sim)) ,
	assert(vivo(KB,agt(KB,[X,Y]),nao)) ,

	% Atualiza pontuação do agente
	redz_pnt(KB,1000) ,

	% Se o jogador morreu então mostra mensagem
	format("~nCaiu em um buraco, voce morreu e esta fora do jogo!~n") , nl ,

	% Atualiza a ação tomada
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[X,Y],morreu,aqui,LA) ,

	% Atualiza contador para fim de jogo
	soma_off , !.
vivo_agt(_,[X,Y],A,O) :-
	% O agente ainda está vivo
	kb_mat(KBM) ,
	pos_lvr(KBM,[X,Y]) ,

	% Atualiza a ação tomada
	lista_acoes(KB,LA) ,
	atu_lacoes(KB,[X,Y],A,O,LA) .
vivo_agt(_,[X,Y],mover,_) :-
	% Atualiza lista de posições visitadas somente se continuou vivo após o movimento
	lista_ppa(KB,LPPA) ,
	ins_lista_ppa(KB,[X,Y],LPPA) , !.

%------------------------------------------------------------
% Movimenta para a posição da orientação fornecida
%------------------------------------------------------------

mov_agt(KB,[I,J],_,O) :-
	% Verifica se o agente bateu na parede
	bum(KB,[I,J],O) ,

	% Atualiza pontuação do agente
	pnt_pos([I,J],1) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[I,J],parede,O) ,

	% Repete a vez
	envia_msg(KB,interface,rpt,[I,J]) , !.

mov_agt(KB,[I,J],[X,Y],_) :-
	% Atualiza pontuação do agente
	pnt_pos([I,J],PNT) ,
	redz_pnt(KB,PNT) ,

	% Verifica se bateu no Wumpus morto para evitar movimento
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,[I,J]),nao) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[X,Y],esbarrao,aqui) ,

	% Repete a vez
	envia_msg(KB,interface,rpt,[I,J]) , !.

mov_agt(KB,[I,J],[X,Y],O) :-
	% Movimento
	pos_adj([I,J],[X,Y]) ,

	% Atualiza posição do agente
	retract(agt(KB,[I,J])) ,
	assert(agt(KB,[X,Y])) ,

	% Atualiza pontuação do agente
	pnt_pos([I,J],PNT) ,
	redz_pnt(KB,PNT) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[X,Y],mover,O) ,

	% Envia o ppa
	envia_msg(KB,broadcast,ppa,[X,Y]) , !.

%------------------------------------------------------------
% Pegar o ouro
%------------------------------------------------------------

agt_our(KB,[I,J]) :-
	% Se já pegou o ouro
	our(KB,agt(KB,_),sim) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[I,J],sem_ouro,aqui) ,

	% Repete a vez
	envia_msg(KB,interface,rpt,[I,J]) , !.

agt_our(KB,[I,J]) :-
	% Se não pegou o ouro ainda
	our(_,agt(_,_),nao) ,

	% Posição do ouro
	our(KB,[I,J]) ,

	% Atualiza pontuação do agente
	redz_pnt(KB,1) ,

	% Atualiza objetivo
	retractall(agt_obj(KB,_)) ,
	assert(agt_obj(KB,sair)) ,

	% Atualiza situação do ouro
	retract(our(KB,agt(KB,_),nao)) ,
	assert(our(KB,agt(KB,[I,J]),sim)) ,

	retract(our(KB,[I,J])) ,
	retractall(blh(KB,_)) ,
	format("~nParabens, voce ~p pegou o ouro!",[KB]) , nl ,

	% Verifica se o agente morreu
	vivo_agt(KB,[I,J],pegar_ouro,aqui) ,

	% Atualiza que pegou o ouro e envia mensagem
	envia_msg(KB,broadcast,pour,[I,J]) , !.

%------------------------------------------------------------
% Atirar a flecha
%------------------------------------------------------------

atr_agt(KB,[I,J],_) :- fch(KB,agt(KB,_),nao) ,

	% Atualiza pontuação do agente
	redz_pnt(KB,1) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[I,J],sem_flecha,aqui) ,

	% Repete a vez
	envia_msg(KB,interface,rpt,[I,J]) , !.

%------------------------------------------------------------
% Atirar para a orientação enviada
%------------------------------------------------------------

atr_agt(KB,[I,J],O) :- fch(KB,agt(KB,_),sim) ,

	% Atualiza a carga de flechas
	retract(fch(KB,agt(KB,_),sim)) ,
	assert(fch(KB,agt(KB,[I,J]),nao)) ,
	envia_msg(KB,broadcast,fch,[I,J]) ,

	% Atualiza objetivo
	retractall(agt_obj(KB,_)) ,
	assert(agt_obj(KB,ouro)) ,

	% Atualiza pontuação do agente
	redz_pnt(KB,10) ,

	% Efetua o disparo e verifica se acertou o Wumpus
	tiro_wps(KB,[I,J],O) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[I,J],atirar,O) , !.

%------------------------------------------------------------
% O agente escala a saída
%------------------------------------------------------------

sai_agt(KB,[I,J]) :-
	ini([I,J]) ,
	our(_,agt(_,[_,_]),sim) ,

	% Atualiza pontuação do agente
	soma_pnt(KB,1000) ,

	% Totaliza para o fim do jogo
	soma_off ,

	% Sai da caverna
	retract(agt(KB,[I,J])) ,
	assert(agt(KB,[0,0])) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[I,J],sair,aqui) ,

	envia_msg(KB,broadcast,sai,[I,J]) , !.

sai_agt(KB,[I,J]) :-
	% Atualiza pontuação do agente
	redz_pnt(KB,1) ,

	% Verifica se o agente morreu
	vivo_agt(KB,[I,J],nao_sai,aqui) ,

	% Repete a vez
	envia_msg(KB,interface,rpt,[I,J]) , !.

%------------------------------------------------------------
%
% PONTUAÇÕES
%
%------------------------------------------------------------
%------------------------------------------------------------
% Soma pontos
%------------------------------------------------------------

soma_pnt(KB,P)  :-
	pts_agt(KB,T) ,
	Novo_T is T + P ,
	retract(pts_agt(KB,_)) ,
	assert(pts_agt(KB,Novo_T)).

%------------------------------------------------------------
% Reduz pontos
%------------------------------------------------------------

redz_pnt(KB,P) :-
	pts_agt(KB,T) ,
	Novo_T is T - P ,
	retract(pts_agt(KB,_)) ,
	assert(pts_agt(KB,Novo_T)).

%------------------------------------------------------------
% Determina pontuação
%------------------------------------------------------------

pnt_pos([I,J],1) :- (pos_val([I,J])) , !.
pnt_pos([I,J],0) :- ini([I,J]) , !.
pnt_pos(P,N) :-
	kb_mat(KBM) ,
	fdr(KBM,P) ,
	vnt(KBM,P) ,
	N is 10 , !.
pnt_pos(P,N) :-
	kb_mat(KBM) ,
	fdr(KBM,P) ,
	N is 5 , !.
pnt_pos(P,N) :-
	kb_mat(KBM) ,
	vnt(KBM,P) ,
	N is 5 , !.
pnt_pos(P,N) :-
	kb_mat(KBM) ,
	blh(KBM,P) ,
	N is 0 , !.
pnt_pos(P,N) :-
	kb_mat(KBM) ,
	pos_lvr(KBM,P) ,
	N is 2 , !.
pnt_pos(P,N) :-
	kb_mat(KBM) ,
	not(pos_lvr(KBM,P)) ,
	N is 1000 , !.
pnt_pos(_,0) :- !.

%------------------------------------------------------------
%
% MENSAGENS
%
%------------------------------------------------------------
%------------------------------------------------------------
%
% Mensagens para comunicação entre agentes durante o
% decorrer do jogo.
%------------------------------------------------------------
% Novo valor para o ID de mensagens
%------------------------------------------------------------

novo_id(NID) :-
	id_msg(ID) ,
	NID is ID + 1 ,
	retractall(id_msg(_)) ,
	assert(id_msg(NID)) .

%------------------------------------------------------------
% Efetiva o broadcast da mensagem para A KB -1
%------------------------------------------------------------

msg_4j(KBO,_,TMSG,LMSG) :-
	% guarda a mensagem para a kb de mensagens (kb = 1-)
	novo_id(ID) ,
	retractall(kb_origem(_)) ,
	assert(kb_origem(KBO)) ,
	assert(msg(KBMSG,ID,KBMSG,KBO,TMSG,LMSG)) , !.

%------------------------------------------------------------
% Efetiva o broadcast da mensagem para todas as KBs
%------------------------------------------------------------

msg_broadcast(KBO,KBD,TMSG,LMSG) :-
	tot_kbs(TKB) ,
	KBD > TKB ,

	% kb = -1
	kb_msg(KBMSG) ,

	% guarda a mensagem para a kb de mensagens (kb = 1-)
	novo_id(ID) ,
	retractall(kb_origem(_)) ,
	assert(kb_origem(KBO)) ,
	assert(msg(KBMSG,ID,KBMSG,KBO,TMSG,LMSG)) , !.
msg_broadcast(KBO,KBD,TMSG,LMSG) :-
	(KBO == KBD ; vivo(KBD,agt(KBD,_),nao)),
	NKBD is KBD + 1 ,
	msg_broadcast(KBO,NKBD,TMSG,LMSG) , !.
msg_broadcast(KBO,KBD,TMSG,LMSG) :-
	% kb = -1
	kb_msg(KBMSG) ,

	% guarda a mensagem
	novo_id(ID) ,
	retractall(kb_origem(_)) ,
	assert(kb_origem(KBO)) ,
	assert(msg(KBMSG,ID,KBD,KBO,TMSG,LMSG)) ,
	NKBD is KBD + 1 ,
	msg_broadcast(KBO,NKBD,TMSG,LMSG).

%------------------------------------------------------------
% Envio de uma mensagem para todas as KBs (broadcast)
%------------------------------------------------------------

envia_msg(KB,broadcast,TMSG,LMSG) :-
	msg_broadcast(KB,1,TMSG,LMSG) , !.

%------------------------------------------------------------
% Envio de uma mensagem para a KB -1 reenviar a ação
%------------------------------------------------------------

envia_msg(KB,interface,TMSG,LMSG) :-
	msg_4j(KB,1,TMSG,LMSG) , !.

%------------------------------------------------------------
% Leitura de todas as mensagens enviadas para uma dada KB
%------------------------------------------------------------

le_msg(KBD) :-
	% kb = -1
	kb_msg(KBMSG) ,
	msg(KBMSG,ID,KBD,KBO,TMSG,LMSG) ,

	% Atualiza a mensagems na kb de destino
	grava_msg(KBD,KBO,TMSG,LMSG) ,
	retract(msg(KBMSG,ID,KBD,KBO,TMSG,LMSG)) ,
	fail .
le_msg(_).

%------------------------------------------------------------
% Grava a mensagem na sua respectiva KB
%------------------------------------------------------------

grava_msg(KBD,_,wps,LMSG) :- assert(wps(KBD,LMSG)).
grava_msg(KBD,_,brc,LMSG) :- assert(brc(KBD,LMSG)).
grava_msg(KBD,_,our,LMSG) :- assert(our(KBD,LMSG)).
grava_msg(KBD,_,fdr,LMSG) :- assert(fdr(KBD,LMSG)).
grava_msg(KBD,_,vnt,LMSG) :- assert(vnt(KBD,LMSG)).
grava_msg(KBD,_,blh,LMSG) :- assert(blh(KBD,LMSG)).
grava_msg(KBD,_,fdrs,LMSG) :-
	assert_fdrs(KBD,LMSG) ,
	lista_fdrs(KBD) .
grava_msg(KBD,_,vnts,LMSG) :-
	assert_vnts(KBD,LMSG) ,
	lista_vnts(KBD) .
grava_msg(KBD,_,blhs,LMSG) :-
	assert_blhs(KBD,LMSG) ,
	lista_blhs(KBD) .
grava_msg(KBD,_,ppa,LMSG) :-
	lista_ppa(KBD,LPPA) ,
	insere(LMSG,LPPA,NLPPA) ,
	retractall(lista_ppa(KBD,_)) ,
	assert(lista_ppa(KBD,NLPPA)).
grava_msg(KBD,KBO,ips,LMSG) :- assert(agt_ips(KBD,agt(KBO,LMSG))).
grava_msg(KBD,KBO,fch,_) :-
	assert(fch(KBD,agt(KBO,_),nao)) ,
	retractall(tiro(KBD,_,_)) ,
	assert(tiro(KBD,agt(KBO,_),sim)) .
grava_msg(KBD,KBO,sai,LMSG) :- assert(saiu(KBD,agt(KBO,LMSG),nao)) .
grava_msg(KBD,KBO,pour,LMSG) :-
	assert(our(KBD,agt(KBO,LMSG),sim)) ,
	retractall(agt_obj(KBD,_)) ,
	assert(agt_obj(KBD,sair)) ,
	retract(our(KBD,LMSG)) ,
	retractall(blh(KBD,_)) .
grava_msg(KBD,KBO,grt,LMSG) :-
	assert(wps(KBD,LMSG)) ,
	assert(agt_wps(KBD,agt(KBO,LMSG))) ,
	retractall(vivo(KBD,wps(KBD,_),sim)) ,
	assert(vivo(KBD,wps(KBD,LMSG),nao)) ,
	retractall(agt_obj(KBD,wumpus)) .
grava_msg(KBD,KBO,rpt,LMSG) :-
	retractall(rpt(KBD,_,_)) ,
	assert(rpt(KBD,agt(KBO,LMSG),sim)) , !.

%------------------------------------------------------------
% Grava todos os fedores na KB
%------------------------------------------------------------

assert_fdrs(KB,[[I,J]]) :- assert(fdr(KB,[I,J])) , !.
assert_fdrs(KB,[P|RP]) :-
	assert(fdr(KB,P)) ,
	assert_fdrs(KB,RP) .

%------------------------------------------------------------
% Grava todos os ventos na KB
%------------------------------------------------------------

assert_vnts(KB,[[I,J]]) :- assert(vnt(KB,[I,J])) , !.
assert_vnts(KB,[P|RP]) :-
	assert(vnt(KB,P)) ,
	assert_vnts(KB,RP) .

%------------------------------------------------------------
% Grava todos os brilhos na KB
%------------------------------------------------------------

assert_blhs(KB,[[I,J]]) :- assert(blh(KB,[I,J])) , !.
assert_blhs(KB,[P|RP]) :-
	assert(blh(KB,P)) ,
	assert_blhs(KB,RP) .

%------------------------------------------------------------
%
% Mensagens para comunicação com a interface Java usando o
% protocolo montado abaixo.
%------------------------------------------------------------
% Declaração de biblioteca JSON
%------------------------------------------------------------

:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

%------------------------------------------------------------
% Declaração de biblioteca para comunicação
%------------------------------------------------------------

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

%------------------------------------------------------------
% Instanciando um servidor http
%------------------------------------------------------------

server(Port) :- http_server(http_dispatch, [port(Port)]).

%------------------------------------------------------------
% Função de tradução para JSON - FATOS PARA AS KBS
%------------------------------------------------------------

:- json_object mat(mat:integer).

json_mat(_Request) :-
	format('Content-type: text/plain~n~n') ,
	mat(M) ,
	prolog_to_json(mat(M),JSON_Object) ,
	json_write(current_output, JSON_Object), nl ,
	http_handler('/json_mat', json_mat, []).

:- json_object wps(kb:integer,
		   pwps:list).

json_wps(_Request) :-
	format('Content-type: text/plain~n~n') ,
	kb_mat(KBM) ,
	wps(KBM,P) ,
	prolog_to_json(wps(KBM,P),JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	http_handler('/json_wps', json_wps, []).

:- json_object brcs(kb:integer,
		    pos:list).

% Usada apenas no envio de mensagens
lista_brcs(KB) :-
	brc(KB,B) ,
	brcs(KB,L) ,
	not(pertence(B,L)) ,
	insere(B,L,NL) ,
	retractall(brcs(KB,_)) ,
	assert(brcs(KB,NL)) ,
	fail.
lista_brcs(_).

json_brcs(_Request) :-
	format('Content-type: text/plain~n~n') ,
	kb_mat(KBM) ,
	brcs(KBM,L) ,
	prolog_to_json(brcs(KBM,L),JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	http_handler('/jsonbrcs', json_brcs, []).

:- json_object our(kb:integer,
		   pos:list).

json_our(_Request) :-
	format('Content-type: text/plain~n~n') ,
	kb_mat(KBM) ,
	our(KBM,P) ,
	prolog_to_json(our(KBM,P),JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	http_handler('/json_our', json_our, []).

:- json_object fdrs(kb:integer,
		   pos:list).

lista_fdrs(KB) :-
	fdr(KB,F) ,
	fdrs(KB,L) ,
	not(pertence(F,L)) ,
	insere(F,L,NL) ,
	retractall(fdrs(KB,_)) ,
	assert(fdrs(KB,NL)) ,
	fail.
lista_fdrs(_).

json_fdr(_Request) :-
	format('Content-type: text/plain~n~n') ,
	kb_mat(KBM) ,
	lista_fdrs(KBM) ,
	fdrs(KBM,L) ,
	prolog_to_json(fdrs(KBM,L),JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	retractall(fdrs(KBM,_)) ,
	assert(fdrs(KBM,[])) ,
	http_handler('/json_fdr', json_fdr, []).

:- json_object vnts(kb:integer,
		   pos:list).

lista_vnts(KB) :-
	vnt(KB,V) ,
	vnts(KB,L) ,
	not(pertence(V,L)) ,
	insere(V,L,NL) ,
	retractall(vnts(KB,_)) ,
	assert(vnts(KB,NL)) ,
	fail.
lista_vnts(_).

json_vnt(_Request) :-
	format('Content-type: text/plain~n~n') ,
	kb_mat(KBM) ,
	lista_vnts(KBM) ,
	vnts(KBM,L) ,
	prolog_to_json(vnts(KBM,L),JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	retractall(vnts(KBM,_)) ,
	assert(vnts(KBM,[])) ,
	http_handler('/json_vnt', json_vnt, []).

:- json_object blhs(kb:integer,
		   pos:list).

lista_blhs(KB) :-
	blh(KB,B) ,
	blhs(KB,L) ,
	not(pertence(B,L)) ,
	insere(B,L,NL) ,
	retractall(blhs(KB,_)) ,
	assert(blhs(KB,NL)) ,
	fail.
lista_blhs(_).

json_blh(_Request) :-
	format('Content-type: text/plain~n~n') ,
	kb_mat(KBM) ,
	lista_blhs(KBM) ,
	blhs(KBM,L) ,
	prolog_to_json(blhs(KBM,L),JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	retractall(blhs(KBM,_)) ,
	assert(blhs(KBM,[])) ,
	http_handler('/json_blh', json_blh, []).

%------------------------------------------------------------
% Função de tradução para JSON - Tabuleiro
%------------------------------------------------------------
% PROTOCOLO DE COMUNICAÇÃO:
%
% Ação:         Após o término da inicialização
% Entrada:      KBs iniciadas
% Saída:        O posicionamento dos objetos da KB 0
% Formato JSON: tabuleiro = { mat:int,
%                             wps:[I,J] ,
%                             brcs:[[I,J],[I,J],[I,J]] ,
%                             our:[I,J] }
%------------------------------------------------------------

:- json_object json_tab(kb:integer,
		   pos_wps:list,
		   lista_buracos:list,
		   pos_our:list).

json_tab(KBM,PWPS,L,POUR) :-
	kb_mat(KBM) ,
	wps(KBM,PWPS) ,
	brcs(KBM,L) ,
	our(KBM,POUR) .

json_inic(_Request) :-
	format('Content-type: text/plain~n~n') ,
	json_tab(KBM,PWPS,L,POUR) ,
	prolog_to_json(json_tab(KBM,PWPS,L,POUR),JSON_Object) ,
	json_write(current_output,JSON_Object) , nl ,
	http_handler('/json_inic', json_inic, []).

%------------------------------------------------------------
% Função de tradução para JSON - Inicializar jogadores agentes
% ou humanos
%------------------------------------------------------------
% PROTOCOLO DE COMUNICAÇÃO:
%
% Ação:         Após o envio do tabuleiro
% Entrada:      KBs iniciadas
% Saída:        O ID, a posição, a percepção, e a pontuação
%		e o tipo dos jogadores, e demais dados
% Formato JSON: jogador = {  }
% ------------------------------------------------------------

:- json_object json_jog(kb:integer,
			tipo:atom,
			pos:list,
			percebe:list,
			energia:integer,
			lista_de_acoes:list,
			pos_visitadas:list,
			acao_exe:atom,
			orientacao:atom,
			agente_vivo:atom,
			pegou_ouro:atom,
			possui_flecha:atom,
			wps_vivo:atom,
		        prox_kb:integer,
		        prox_tipo:atom).

json_jog(KB,TP,POS,PCB,PNT,LACOES,LPPA,AE,O,SAGT,SOUR,SFCH,SWPS,PKB,PTP) :-
	percebe_ini_4j(KB,TP,POS,PCB) ,
	tipo_kb(KB,TP) ,
	pts_agt(KB,PNT) ,
	lista_ppa(KB,LPPA) ,
	lista_acoes(KB,LACOES) ,
	lista_acoes(KB,[[_,AE,O]|_]) ,
	vivo(KB,agt(KB,_),SAGT) ,
	our(KB,agt(KB,_),SOUR) ,
	fch(KB,agt(KB,_),SFCH) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),SWPS) ,
	agt_ativo(PKB) ,
	tipo_kb(PKB,PTP).

json_inic_jog(KB,_Request) :-
	format('Content-type: text/plain~n~n') ,
	json_jog(KB,TP,POS,PCB,PNT,LACOES,LPPA,AE,O,SAGT,SOUR,SFCH,SWPS,PKB,PTP) ,
	prolog_to_json(json_jog(KB,TP,POS,PCB,PNT,LACOES,LPPA,AE,O,SAGT,SOUR,SFCH,SWPS,PKB,PTP),JSON_Object) ,
	json_write(current_output,JSON_Object) , nl ,
	http_handler('/json_inic_jog', json_inic_jog(KB), []) , !.

%------------------------------------------------------------
% Função de tradução para JSON - Retorno de passo
%------------------------------------------------------------
% PROTOCOLO DE COMUNICAÇÃO:
%
% Ação:         Após o término de um passo dado por um agente
% Entrada:      Ação da KB executada
% Saída:        O ID do agente,
%               a nova posição do agente,
%               a percepção do agente,
%               a nova pontuação do agente,
%               o trajeto já percorrido,
%               a ação que foi executada,
%               o resultado da ação executada:
%               (se o agente está vivo,
%               se agente pegou o ouro,
%               o numero de flechas do agente,
%               se o agente matou o wumpus,
%               se o wumpus está vivo,
%               se o agente inferiu alguma coisa)
% Formato JSON:
%------------------------------------------------------------

:- json_object json_res(kb:integer,
			tipo:atom,
			pos:list,
			percebe:list,
			energia:integer,
			lista_de_acoes:list,
			pos_visitadas:list,
			acao_exe:atom,
			orientacao:atom,
			agente_vivo:atom,
			pegou_ouro:atom,
			possui_flecha:atom,
			wps_vivo:atom,
		        prox_kb:integer,
		        prox_tipo:atom).

json_res(KB,TP,POS,PCB,PNT,LACOES,LPPA,AE,O,sim,SOUR,SFCH,SWPS,PKB,PTP) :-
	agt(KB,POS) ,
	tipo_kb(KB,TP) ,
	vivo(KB,agt(KB,_),sim) ,
	agt_pcb(KB,POS,PCB) ,
	pts_agt(KB,PNT) ,
	lista_acoes(KB,LACOES) ,
	lista_acoes(KB,[[_,AE,O]|_]) ,
	lista_ppa(KB,LPPA) ,
	our(KB,agt(KB,_),SOUR) ,
	fch(KB,agt(KB,_),SFCH) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),SWPS) ,
	agt_ativo(PKB) ,
	tipo_kb(PKB,PTP) , !.

% quando morre não tem percepção
json_res(KB,TP,POS,[],PNT,LACOES,LPPA,AE,O,nao,SOUR,SFCH,SWPS,PKB,PTP) :-
	agt(KB,POS) ,
	tipo_kb(KB,TP) ,
	vivo(KB,agt(KB,_),nao) ,
	pts_agt(KB,PNT) ,
	lista_acoes(KB,LACOES) ,
	lista_acoes(KB,[[_,AE,O]|_]) ,
	lista_ppa(KB,LPPA) ,
	our(KB,agt(KB,_),SOUR) ,
	fch(KB,agt(KB,_),SFCH) ,
	kb_mat(KBM) ,
	vivo(KBM,wps(KBM,_),SWPS) ,
	agt_ativo(PKB) ,
	tipo_kb(PKB,PTP) , !.

json_passo(KB,_Request) :-
	format('Content-type: text/plain~n~n') ,
	json_res(KB,TP,POS,PCB,PNT,LACOES,LPPA,AE,O,SAGT,SOUR,SFCH,SWPS,PKB,PTP) ,
        prolog_to_json(json_res(KB,TP,POS,PCB,PNT,LACOES,LPPA,AE,O,SAGT,SOUR,SFCH,SWPS,PKB,PTP),JSON_Object) ,
	json_write(current_output,JSON_Object) , nl ,
	http_handler('/json_passo', json_passo(KB), []) .

%------------------------------------------------------------
% Função de tradução de JSON - Se houve final do jogo
%------------------------------------------------------------
% PROTOCOLO DE COMUNICAÇÃO:
%
% Ação:         Apartir de uma solicitação da interface
%               para testar o final do jogo
% Entrada:      _
% Saída:        true ou false
%
% Formato JSON:
%------------------------------------------------------------

:- json_object fim(fim_jogo:boolean).

json_fim(_Request) :-
	format('Content-type: text/plain~n~n') ,
	fim_jogo ,
	prolog_to_json(fim_jogo,JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	http_handler('/json_fim', json_fim, []).

%------------------------------------------------------------
% Função de tradução de JSON - Inferências do jogo
%------------------------------------------------------------
% PROTOCOLO DE COMUNICAÇÃO:
%
% Ação:         Apartir de uma solicitação da interface
%               lê as mensagens da KB -1 e envia via JSON
% Entrada:      _
% Saída:        true ou false
%
% Formato JSON:
%------------------------------------------------------------

:- json_object re_msg(kb:integer,
		      wps:list,
		      brcs:list,
		      our:list,
		      fdrs:list,
		      vnts:list,
		      blhs:list,
		      pos_impasse:list,
		      pos_pega_ouro:list,
		      pos_mata_wps:list,
		      agt_atirou_flecha:atom,
		      agt_saiu:atom,
		      agt_repete:atom).

re_msg(KBO,PWPS,LBRC,POUR,LFDR,LVNT,LBLH,PAIPS,PAOUR,PAWPS,RAFCH,RASAI,RARPT) :-
	kb_msg(KB) ,
	le_msg(KB) ,
	kb_origem(KBO) ,
	re_msg1(KB,PWPS) ,
	re_msg2(KB,LBRC) ,
	re_msg3(KB,POUR) ,
	re_msg4(KB,LFDR) ,
	re_msg5(KB,LVNT) ,
	re_msg6(KB,LBLH) ,
	re_msg7(KB,KBD,PAIPS) ,
	re_msg8(KB,KBD,PAOUR) ,
	re_msg9(KB,KBD,PAWPS) ,
	re_msg10(KB,KBD,RAFCH) ,
	re_msg11(KB,KBD,RASAI) ,
	re_msg12(KB,KBD,RARPT) .

re_msg1(KB,P) :-
	wps(KB,P) , !.
re_msg1(_,[]).

re_msg2(KB,L) :-
	retractall(brcs(KB,_)) ,
	assert(brcs(KB,[])) ,
	lista_brcs(KB) ,
	brcs(KB,L) , !.
re_msg2(_,[]).

re_msg3(KB,P) :-
	our(KB,P) , !.
re_msg3(_,[]).

re_msg4(KB,L) :-
	retractall(fdrs(KB,_)) ,
	assert(fdrs(KB,[])) ,
	lista_fdrs(KB) ,
	fdrs(KB,L) , !.
re_msg4(_,[]).

re_msg5(KB,L) :-
	retractall(vnts(KB,_)) ,
	assert(vnts(KB,[])) ,
	lista_vnts(KB) ,
	vnts(KB,L) , !.
re_msg5(_,[]).

re_msg6(KB,L) :-
	retractall(blhs(KB,_)) ,
	assert(blhs(KB,[])) ,
	lista_blhs(KB) ,
	blhs(KB,L) , !.
re_msg6(_,[]).

re_msg7(KB,KBD,P) :-
	agt_ips(KB,agt(KBD,P)) , !.
re_msg7(_,_,[]) :- !.

re_msg8(KB,KBD,P) :-
	our(KB,agt(KBD,P),sim) , !.
re_msg8(_,_,[]).

re_msg9(KB,KBD,P) :-
	agt_wps(KB,agt(KBD,P)) , !.
re_msg9(_,_,[]).

re_msg10(KB,KBD,R) :-
	tiro(KB,agt(KBD,_),R) , !.
re_msg10(_,_,nao).

re_msg11(KB,KBD,R) :-
	saiu(KB,agt(KBD,_),R) , !.
re_msg11(_,_,nao).

re_msg12(KB,KBD,R) :-
	rpt(KB,agt(KBD,_),R) , !.
re_msg12(_,_,nao).

json_msg(_Request) :-
	format('Content-type: text/plain~n~n') ,
	% Leitura das mensagens recebidas pela KB compartilhada
	re_msg(KB,PWPS,LBRC,POUR,LFDR,LVNT,LBLH,PAIPS,PAOUR,PAWPS,RAFCH,RASAI,RARPT) ,
	prolog_to_json(re_msg(KB,PWPS,LBRC,POUR,LFDR,LVNT,LBLH,PAIPS,PAOUR,PAWPS,RAFCH,RASAI,RARPT),JSON_Object) ,
	json_write(current_output, JSON_Object) , nl ,
	http_handler('/json_msg', json_msg, []) .

%------------------------------------------------------------
%
% RESET DO JOGO
%
%------------------------------------------------------------
%------------------------------------------------------------
% Reset da kb de mensagens para java
%------------------------------------------------------------

reset_msg_4j :-
	kb_msg(KBMSG) ,
	reset_kb(KBMSG) .

%------------------------------------------------------------
% Reset da kb de mensagens
%------------------------------------------------------------

reset_kb(KB) :-
	retractall(wps(KB,_)) ,
	retractall(brcs(KB,_)) ,
	retractall(our(KB,_)) ,
	retractall(fdrs(KB,_)) ,
	retractall(vnts(KB,_)) ,
	retractall(blhs(KB,_)) ,
	retractall(agt_ips(KB,agt(_,_))) ,
	retractall(our(KB,agt(_,_),_)) ,
	retractall(agt_wps(KB,agt(_,_))) ,
	retractall(fch(KB,agt(_,_),_)) ,
	retractall(saiu(KB,agt(_,_),nao)) ,
	retractall(lista_ppa(KB,_)) ,
	retractall(tiro(KB,agt(_,_),_)) ,
	retractall(rpt(KB,agt(_,_),_)) ,
	assert(lista_ppa(KB,[])) , !.

%------------------------------------------------------------
% Reset geral
%------------------------------------------------------------

reset_geral :-
	% matriz
	retractall(mat(_)) ,
	retractall(matriz(_,_)) ,
	retractall(fim(_)) ,
	retractall(tot_off(_)) ,

	% Pontuação
	retractall(pts_agt(_,_)) ,

	% Wumpus
	retractall(wps(_,_))  ,
	retractall(vivo(_,wps(_,_),_)) ,

	% Buracos
	retractall(brc(_,_))  ,
	retractall(brcs(_,_)) ,

	% Ouro
	retractall(our(_,_))  ,
	retractall(our(_,agt(_,_),_)),

	% Trajetos
	retractall(lista_ppa(_,_)) ,
	retractall(trj_id(_,_)) ,
	retractall(trj(_,_,_,_,_)) ,
	retractall(melhor_trj(_,_,_,_,_)) ,
	retractall(tot_trj(_,_)) ,

	% KBs
	retractall(tot_kbs(_)) ,
	retractall(tot_kbhs(_)) ,

	% Agentes
	retractall(agt(_,_))  ,
	retractall(fch(_,agt(_,_),_)) ,
	retractall(vivo(_,agt(_,_),_)) ,
	retractall(saiu(_,agt(_,_),_)) ,
	retractall(pts_agt(_,_)) ,
	retractall(lista_acoes(_,_)) ,
	retractall(fdr(_,_)) ,
	retractall(vnt(_,_)) ,
	retractall(blh(_,_)) ,
	retractall(agt_ativo(_)) ,
	retractall(agt_ips(_,_)) ,
	retractall(agt_wps(_,_)) ,

	% Objetivos
	retractall(agt_obj(_,_)) ,

	% Estrategias
	retractall(lista_est(_,_)) ,

	% Mensagens
	retractall(id_msg(_)) ,
	retractall(msg(_,_,_,_,_,_)) , !.

%------------------------------------------------------------
%
% FINALIZAÇÃO DO JOGO
%
%------------------------------------------------------------














