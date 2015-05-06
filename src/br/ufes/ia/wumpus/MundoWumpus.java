package br.ufes.ia.wumpus;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.TimeUnit;

import org.lwjgl.Sys;
import org.newdawn.slick.Animation;
import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.BasicGame;
import org.newdawn.slick.Color;
import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.Image;
import org.newdawn.slick.Input;
import org.newdawn.slick.SlickException;
import org.newdawn.slick.geom.Rectangle;
import org.newdawn.slick.tiled.TiledMap;

import br.ufes.ia.wumpus.controle.Comunicacao;
import br.ufes.ia.wumpus.controle.Jogador;
import br.ufes.ia.wumpus.dominio.Constantes;
import br.ufes.ia.wumpus.dominio.Coordenada;
import br.ufes.ia.wumpus.dominio.Jogada;
import br.ufes.ia.wumpus.dominio.Constantes.AcaoJogador;
import br.ufes.ia.wumpus.dominio.Constantes.TipoJogador;
import br.ufes.ia.wumpus.dominio.Constantes.TipoObjeto;
import br.ufes.ia.wumpus.engine2d.Mapa;
import br.ufes.ia.wumpus.prolog.InterfaceProlog;

public class MundoWumpus extends BasicGame {
		
		// ****** variáveis do jogo
		
		// container do jogo
		static AppGameContainer app;

		// Tamanho da matriz
		private int tamanhoMatriz = 9;
		
		// Número de jogadores
		private int numeroAgentes = 2;
		private int numeroHumanos = 2;
		private int numeroJogadores = 4;
		
		
		// ****** variáveis de execução do jogo  
		
		// objetos jogadores
		private List<Jogador> jogadores = new ArrayList<Jogador>();

		// interface com o prolog (apenas uma instância para compartilhar a mesma base em diferentes métodos) - singleton
		InterfaceProlog interfaceProlog;
		
		// controle de fluxo
		private boolean pegouOuro = false;
		private boolean wumpusMorto = false;
		
		private int indexProximoJogador = 0;
		private int indexJogadorAtual = 0;
		
		// ******  variáveis da interface visual
		
		// cores
		private int[] r = new int[numeroJogadores];
		private int[] g = new int[numeroJogadores];
		private int[] b = new int[numeroJogadores];
		
		// objetos cenário
		private Animation fedor, brisa, wumpus, wumpusM, brilho;
		private TiledMap mapaCenario;
		private Image ouro, buraco, saida;
		private Image[] rastro = new Image[numeroJogadores]; 
		private boolean[][] blocked;
		HashMap<Coordenada, TipoObjeto> objetosMundo;
		
		// Ao andar o jogador deixa rastro
		boolean desenhaRastroJogador = true;
		String mensagemPainel1 = new String();
		String mensagemPainel2 = new String();

		public MundoWumpus() {
			super("MundoWumpus");
		}

		public static void main(String[] arguments) {	
			try {	
				app = new AppGameContainer(new MundoWumpus());
				app.setDisplayMode(890, 620, false);
				//app.setFullscreen(true);
				app.setShowFPS(false);
				app.start();
			} catch (SlickException e) {
				e.printStackTrace();
			}
		}

		@Override
		public void render(GameContainer container, Graphics graphic)	throws SlickException {
			
			// * Desenha cenário
			mapaCenario.render(0,0);
			
			// * Desenha objetos
			for (Entry<Coordenada, TipoObjeto> entry : objetosMundo.entrySet()) {
				Coordenada coordenada = entry.getKey();
				TipoObjeto objeto = entry.getValue();
				
				switch (objeto) {
				case OURO:
					if (!pegouOuro)
						graphic.drawImage(ouro, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					break;
				case BURACO:
					graphic.drawImage(buraco, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					break;
				case FEDOR:
					if (!wumpusMorto)
						graphic.drawAnimation(fedor, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					break;
				case BRILHO:
					if (!pegouOuro)
						graphic.drawAnimation(brilho, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					break;
				case BRISA:
					graphic.drawAnimation(brisa, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					break;
				case WUMPUS:
					if (!wumpusMorto)
						graphic.drawAnimation(wumpus, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					else
						graphic.drawAnimation(wumpusM, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					break;
				case SAIDA:
					if (pegouOuro)
						graphic.drawImage(saida, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO);
					break;
				default:
					break;
				}
			}
			/*	
			// * Efeito Fog of War
	        Rectangle[][] fogOfWar = new Rectangle[Constantes.TAMANHO_BLOCO][Constantes.TAMANHO_BLOCO];
	        for (int i=0; i<16; i++) {
	            for (int j=0; j<16; j++) {
	                fogOfWar[i][j] = new Rectangle(i*Constantes.TAMANHO_BLOCO,j*Constantes.TAMANHO_BLOCO,Constantes.TAMANHO_BLOCO,Constantes.TAMANHO_BLOCO);
	                Coordenada coordenada = new Coordenada(i,j);
	                
	                Jogada ultimaJogada = interfaceProlog.getUltimaJogada();
	                Comunicacao ultimaComunicacao =interfaceProlog.getUltimaComunicacao();
	                
	                if (ultimaJogada != null && ultimaComunicacao != null)
		                if (coordenada.coordenadaPertenceLista(ultimaJogada.getPos_visitadas()) ||
		                	coordenada.coordenadaPertenceLista(ultimaComunicacao.getPosicoesVisitadas()) || 
		                	coordenada.coordenadaPertenceLista(ultimaComunicacao.getPosicoesDescobertas())) {
		                	
			                // rastro do jogador
							if (desenhaRastroJogador && !coordenada.coordenadaPertenceLista(ultimaComunicacao.getPosicoesDescobertas())) {
								for (int k = 0; k < numeroJogadores; k++) {
									desenhaRastroJogador(coordenada,jogadores.get(k), graphic, rastro[k], r[k], g[k] ,b[k]);
									jogadores.get(k).incrementaContadorRastroJogador();							
								}
							}
						} else if (coordenada.coordenadaPertenceLista(ultimaComunicacao.getPosicoesInferidas())) {
		                	// cinza
							graphic.setColor(Color.lightGray);
		                	graphic.fill(fogOfWar[i][j]);
						} else {
		                	// preto
							graphic.setColor(Color.black);
		                	graphic.fill(fogOfWar[i][j]);
						}
	            }
	        }*/
	                     
			// * Desenha movimento dos jogadores
	        for (int k = 0; k < numeroJogadores; k++)
	        	if (jogadores.get(k) != null) {
	        		desenhaMovimentoJogador(jogadores.get(k));
	        }
	        
	        // desenhar painel com informações
	        desenhaPainel(graphic);
		}

		@Override
		public void init(GameContainer container) throws SlickException {
			// obtem as informações do mundo - no momento os valores estão fixos 
			//(para o caso de fazer uma janela para informar estes dados contendo o número de agentes e humanos e o tamanho da matriz)
			
			// preenche objetos no mundo
			interfaceProlog = new InterfaceProlog(tamanhoMatriz,numeroAgentes,numeroHumanos);
			Constantes.TAMANHO_MAPA = tamanhoMatriz + 2;
			objetosMundo = interfaceProlog.consultarObjetosMundo();
		
			// *** Gera mapa dinamicamente de acordo com o tamanho
			Mapa mapaDinamico = new Mapa();
			if (!mapaDinamico.gerarMapa(Constantes.TAMANHO_MAPA)){
				new Exception("Erro ao gerar mapa. O jogo não pôde ser carregado.");
			}
			
			// *** cores
			r[0] = Color.blue.getRed();
			g[0] = Color.blue.getGreen();
			b[0] = Color.blue.getBlue();
			
			r[1] = Color.red.getRed();
			g[1] = Color.red.getGreen();
			b[1] = Color.red.getBlue();
			
			r[2] = Color.white.getRed();
			g[2] = Color.white.getGreen();
			b[2] = Color.white.getBlue();
			
			r[3] = Color.yellow.getRed();
			g[3] = Color.yellow.getGreen();
			b[3] = Color.yellow.getBlue();
			
			// *** Definição de imagens para animações
			Image[] movimentoFedor = { new Image(Constantes.ANIMACAO_FEDOR),new Image(Constantes.ANIMACAO_FEDOR_ALT) };
			Image[] movimentoBrisa = { new Image(Constantes.ANIMACAO_BRISA),new Image(Constantes.ANIMACAO_BRISA_ALT) };
			Image[] movimentoBrilho = { new Image(Constantes.ANIMACAO_BRILHO),new Image(Constantes.ANIMACAO_BRILHO_ALT) };
			Image[] movimentoWumpus = { new Image(Constantes.ANIMACAO_WUMPUS),new Image(Constantes.ANIMACAO_WUMPUS_ALT) };
			Image[] movimentoWumpusMorto = { new Image(Constantes.ANIMACAO_WUMPUS_MORTO),new Image(Constantes.ANIMACAO_WUMPUS_MORTO_ALT) };
			
			// *** Definição de imagens estáticas
			ouro = new Image(Constantes.IMAGEM_OURO);
			buraco = new Image(Constantes.IMAGEM_BURACO);
			rastro[0] = new Image(Constantes.IMAGEM_RASTRO_1);
			rastro[1] = new Image(Constantes.IMAGEM_RASTRO_2);
			rastro[2] = new Image(Constantes.IMAGEM_RASTRO_3);
			rastro[3] = new Image(Constantes.IMAGEM_RASTRO_4);
			saida = new Image(Constantes.IMAGEM_SAIDA);
			
			// *** Definição de jogadores
			for (int i = 0; i < numeroJogadores; i++) {
				Jogador jogador = interfaceProlog.inicializaJogador();
				if (jogador != null) { 
					jogadores.add(jogador);
					
					// *** Inicializa a ultima jogada e a ultima comunicação
					Jogada jogada = interfaceProlog.getUltimaJogada();
					if (jogada != null) {
						// recebe a comunicação das inferências da jogada
						interfaceProlog.leMensagem(jogada);
					}
				}
			}
			
			// inicializa indices dos jogadores
			indexJogadorAtual = 0;
			indexProximoJogador = 1;
			
			// *** Durações das animações
			int[] duracaoMovimentoBrilho = { 400, 400 };
			int[] duracaoMovimentoBrisa = { 500, 500 };
			int[] duracaoMovimentoWumpus = { 1500, 1500 };
			int[] duracaoMovimentoGenerico = { 600, 600 };

			// *** Inicialização das animações
			fedor = new Animation(movimentoFedor, duracaoMovimentoGenerico, true);
			brisa = new Animation(movimentoBrisa, duracaoMovimentoBrisa, true);
			brilho = new Animation(movimentoBrilho, duracaoMovimentoBrilho, true);
			wumpus = new Animation(movimentoWumpus, duracaoMovimentoWumpus, true);
			wumpusM = new Animation(movimentoWumpusMorto, duracaoMovimentoGenerico, true);
			
			// *** Definição de mapa
			mapaCenario = new TiledMap(Constantes.CAMINHO_MAPA_TMX);

			// *** Colisão baseada na propriedade blocked
			blocked = new boolean[mapaCenario.getWidth()][mapaCenario.getHeight()];

			for (int xAxis = 0; xAxis < mapaCenario.getWidth(); xAxis++) {
				for (int yAxis = 0; yAxis < mapaCenario.getHeight(); yAxis++) {
					int tileID = mapaCenario.getTileId(xAxis, yAxis, 0);
					String value = mapaCenario.getTileProperty(tileID, "blocked","false");
					if ("true".equals(value)) {
						blocked[xAxis][yAxis] = true;
					}
				}
			}
			container.getInput().enableKeyRepeat();
			container.setMinimumLogicUpdateInterval(300);
			container.setAlwaysRender(true);
			container.getGraphics().setBackground(Color.lightGray);			
		}

		@Override
		public void update(GameContainer container, int delta) throws SlickException {
			
			// Lógica do jogo
			
			if (interfaceProlog.isFim()) {
				// verifica se o jogo acabou porque todos morreram
				boolean gameOver = true;
				for (int i = 0; i < numeroJogadores; i++){
					Jogador jogador = jogadores.get(i);
					gameOver = !jogador.isVivo() && gameOver; 
				}
				if (gameOver) {
					Sys.alert("Que pena", "Game Over! O jogo acabou pois não há mais jogadores vivos.");
					container.exit();
				}
				
				// verifica se o jogo acabou porque todos os sobreviventes saíram da caverna com o ouro
				gameOver = true;
				for (int i = 0; i < numeroJogadores; i++){
					Jogador jogador = jogadores.get(i);
					gameOver = (!jogador.isVivo() || jogador.isSaiu()) && gameOver; 
				}
				if (gameOver) {
					Sys.alert("Parabéns", "Você venceu o jogo! A equipe sobrevivente conseguiu pegar o ouro e sair em segurança da caverna.");
					container.exit();
				}
				
			}
				
			for (int i = 0; i < numeroJogadores; i++){
				Jogador jogador = jogadores.get(i);
				int kb = jogador.getNumeroJogador();
				String jogadorKb = String.valueOf(kb);
				
				if (jogador != null) {
						
					// pegou ouro:
					if (jogador.isVivo() && !jogador.isPegouOuro() && estaEmObjetoNoMundo(jogador.getPosicaoJogador(), TipoObjeto.OURO) 
							&& jogador.getAcaoJogador() == AcaoJogador.PEGAR_OURO){
						Sys.alert("Oba!", "O jogador "+ jogadorKb +" pegou o ouro. Parabéns! A equipe agora pode voltar para casa.");
						objetosMundo.put(new Coordenada(1, 1), TipoObjeto.SAIDA);
						setMensagemPainel("O jogador "+ jogadorKb +" pegou  o ouro.", 2);
						pegouOuro = true;
					}
					
					// inferiu ouro
					
					
					// atirou e matou o wumpus:
					if (jogador.isVivo() && !jogador.isMatouWumpus() && jogador.getAcaoJogador() == AcaoJogador.ATIRAR_FLECHA){
						Sys.alert("Oba!", "O jogador "+ jogadorKb +" atirou para o "+ jogador.getDirecaoAcaoJogador() +" e acertou no Wumpus. Parabéns! A equipe agora está mais segura.");
						setMensagemPainel("O jogador "+ jogadorKb +" matou o Wumpus.", 2);
						wumpusMorto = true;
					}
					
					// atirou e errou o wumpus:
					if (jogador.isVivo() && jogador.isMatouWumpus() && jogador.getAcaoJogador() == AcaoJogador.ATIRAR_FLECHA){
						Sys.alert("Que pena!", "O jogador "+ jogadorKb +" atirou para o "+ jogador.getDirecaoAcaoJogador() +" e errou. A equipe continua insegura.");
						setMensagemPainel("O jogador "+ jogadorKb +" atirou e errou o tiro.", 2);
					}
					
					// inferiu o wumpus:
					
		
					// jogador morreu comido pelo wumpus:
					if (!jogador.isVivo() && estaEmObjetoNoMundo(jogador.getPosicaoJogador(), TipoObjeto.WUMPUS)  && !jogador.isMatouWumpus()){
						Sys.alert("Que pena!", "O jogador "+ jogadorKb +" foi devorado pelo Wumpus.");
						setMensagemPainel("O Wumpus matou o Jogador "+ jogadorKb +".", 2);
					}
					
					// esbarrou no wumpus morto
					if (jogador.isVivo() && jogador.getAcaoJogador() == AcaoJogador.ESBARRAO){
						Sys.alert("Que pena!", "O jogador "+ jogadorKb +" esbarrou no Wumpus morto ao se mover para o "+ jogador.getDirecaoAcaoJogador() +".");
						setMensagemPainel("O Jogador "+ jogadorKb +" esbarrou no Wumpus morto. Faça outro movimento.", 2);
					}			
					
					// jogador morreu caindo em um buraco:
					if (!jogador.isVivo() && estaEmObjetoNoMundo(jogador.getPosicaoJogador(), TipoObjeto.BURACO)){
						Sys.alert("Que pena!", "O jogador "+ jogadorKb +" caiu em um buraco e morreu.");
						setMensagemPainel("O Wumpus matou o Jogador "+ jogadorKb +".", 2);
					}
						
					// inferiu buraco
					
					
					// encontrou saída/entrada da caverna
					if (jogador.isVivo() && !jogador.isPegouOuro() && estaEmObjetoNoMundo(jogador.getPosicaoJogador(), TipoObjeto.SAIDA) 
							&& jogador.getAcaoJogador() == AcaoJogador.SAIR){
						Sys.alert("Que pena!", "O jogador "+ jogadorKb +" tentou deixar a caverna antes da missão concluída. Tente saur depois de recuperar o ouro!");
						setMensagemPainel("O jogador "+ jogadorKb +" está na entrada da caverna, mas ainda não pode sair.", 2);
					}
					
					// encontrou saída e saiu
					if (jogador.isVivo() && jogador.isPegouOuro() && jogador.isSaiu() && estaEmObjetoNoMundo(jogador.getPosicaoJogador(), TipoObjeto.SAIDA) 
							&& jogador.getAcaoJogador() == AcaoJogador.SAIR){
						Sys.alert("Oba!", "O jogador "+ jogadorKb +" conseguiu deixar a caverna com segurança. Parabéns!");
						setMensagemPainel("O jogador "+ jogadorKb +" saiu da caverna.", 2);
					}
					
					// bateu na parede
					if (jogador.isVivo() && jogador.getAcaoJogador() == AcaoJogador.PAREDE){
						Sys.alert("Que pena!", "O jogador "+ jogadorKb +" esbarrou na parede "+ jogador.getDirecaoAcaoJogador() +".");
						setMensagemPainel("O Jogador "+ jogadorKb +" esbarrou em uma parede. Faça outro movimento.", 2);
					}
					
					// inferiu sensações
					
					
				}
			}
		}

		@Override
		public void keyPressed(int key, char c) {
			
			// Define tempo para executar ações
			try {
				TimeUnit.MILLISECONDS.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			
			// Pega o proximo jogador para jogador atual
			Jogador jogadorAtual = jogadores.get(indexJogadorAtual);
			if (jogadorAtual != null) {
				if (jogadorAtual.isVivo()) {
					// ações	
					if (jogadorAtual.getTipoJogador() == TipoJogador.HUMANO){	
						if (key == Input.KEY_UP) {
							recuperaPassoProlog(jogadorAtual);
							movimentarJogador(jogadorAtual);
							} 
						else if (key == Input.KEY_DOWN) {
							recuperaPassoProlog(jogadorAtual);
							movimentarJogador(jogadorAtual);
							} 
						else if (key == Input.KEY_RIGHT) {
							recuperaPassoProlog(jogadorAtual);
							movimentarJogador(jogadorAtual);
							}	
						else if (key == Input.KEY_LEFT) {
							recuperaPassoProlog(jogadorAtual);
							movimentarJogador(jogadorAtual);
							} 
						else if (key == Input.KEY_3 && jogadorAtual.isPossuiFlecha()) {
							recuperaPassoProlog(jogadorAtual);
							atirarFlecha(jogadorAtual);
							}	
						else if (key == Input.KEY_4 && jogadorAtual.isPossuiFlecha()) {
							recuperaPassoProlog(jogadorAtual);
							atirarFlecha(jogadorAtual);
							}	
						else if (key == Input.KEY_2 && jogadorAtual.isPossuiFlecha()) {
							recuperaPassoProlog(jogadorAtual);
							atirarFlecha(jogadorAtual);
							}	
						else if (key == Input.KEY_1 && jogadorAtual.isPossuiFlecha()) {
							recuperaPassoProlog(jogadorAtual);
							atirarFlecha(jogadorAtual);
							}	
						else if (key == Input.KEY_5 && !jogadorAtual.isPegouOuro()) {
							recuperaPassoProlog(jogadorAtual);
							pegarOuro(jogadorAtual);
							}	
					} else if (jogadorAtual.getTipoJogador() == TipoJogador.AGENTE && key == Input.KEY_R){	
						realizarAcaoAutomatizada(jogadorAtual);
					}
				}
			}
		}
		
		/*private Coordenada posicaoObjeto(TipoObjeto tipoObjeto){
			for (Map.Entry<Coordenada,TipoObjeto> entry : objetosMundo.entrySet()) {  
				Coordenada coordenadaMundo = entry.getKey();
				TipoObjeto tipoObjetoMundo = entry.getValue();
				if (tipoObjetoMundo == tipoObjeto) {
					return coordenadaMundo;
				}
			}  
			return null;
		}*/
		
		private boolean estaEmObjetoNoMundo(Coordenada coordenadaJogador, TipoObjeto tipoObjeto){
			for (Map.Entry<Coordenada,TipoObjeto> entry : objetosMundo.entrySet()) {  
				Coordenada coordenadaMundo = entry.getKey();
				TipoObjeto tipoObjetoMundo = entry.getValue();
				return (tipoObjetoMundo == tipoObjeto && coordenadaMundo.getX() == coordenadaJogador.getX() / Constantes.TAMANHO_BLOCO
						&& coordenadaMundo.getY() == coordenadaJogador.getY() / Constantes.TAMANHO_BLOCO);
			}
			return false;
		}
		
		private void desenhaRastroJogador(Coordenada coordenada, Jogador jogador, Graphics graphic, Image rastro, int r, int g, int b) {
			if (jogador != null){
	        	if (coordenada.coordenadaPertenceLista(jogador.getPosicoesVisitadasJogador())){
	        		float brilhoPassoJogador = 0.3f;
	        		graphic.drawImage(rastro, coordenada.getX() * Constantes.TAMANHO_BLOCO, coordenada.getY() * Constantes.TAMANHO_BLOCO, new Color(r,g,b,brilhoPassoJogador));
	        	}
			}
		}

		private void desenhaMovimentoJogador(Jogador jogador) {
			if (jogador != null && jogador.isVivo()){
				jogador.getMovimento().draw(jogador.getPosicaoJogador().getX() * Constantes.TAMANHO_BLOCO, jogador.getPosicaoJogador().getY() * Constantes.TAMANHO_BLOCO);
			}
		}

		private void desenhaPainel(Graphics graphic) {
			
			int meioBloco = Constantes.TAMANHO_BLOCO / 2;
			int alinhamentoEsquerda = Constantes.TAMANHO_BLOCO * 16 + 10;
			
			graphic.drawString("Mundo do Wumpus", alinhamentoEsquerda, meioBloco);
			graphic.drawString("Informações:", alinhamentoEsquerda, meioBloco * 2);
			
			for (int i = 0; i < numeroJogadores; i++) {
				Jogador jogador = jogadores.get(i);
				int jogadorKb = jogador.getNumeroJogador();
				int proximoJogadorKb = jogador.getProximoJogador();
				
				if (jogador.isSaiu()) 
					if (jogador.getTipoProximoJogador() == TipoJogador.HUMANO)
						graphic.drawString("O jogador "+ String.valueOf(jogadorKb) +" está ausente", alinhamentoEsquerda, meioBloco * (3+i));
					else
						graphic.drawString("O agente "+ String.valueOf(jogadorKb) +" está ausente", alinhamentoEsquerda, meioBloco * (3+i));
				else if (!jogador.isVivo()) 
					if (jogador.getTipoProximoJogador() == TipoJogador.HUMANO)
						graphic.drawString("O jogador "+ String.valueOf(jogadorKb) +" morreu", alinhamentoEsquerda, meioBloco * (3+i));
					else
						graphic.drawString("O agente "+ String.valueOf(jogadorKb) +" morreu", alinhamentoEsquerda, meioBloco * (3+i));
				else {
					if (jogador.getTipoJogador() == TipoJogador.HUMANO)
						graphic.drawString("Jogador "+ String.valueOf(jogadorKb) +" é HUMANO", alinhamentoEsquerda, meioBloco * (3+i));
					else
						graphic.drawString("jogador "+ String.valueOf(jogadorKb) +" é AGENTE", alinhamentoEsquerda, meioBloco * (3+i));
					
					if (jogador.getTipoProximoJogador() == TipoJogador.HUMANO)
						setMensagemPainel("Jogador "+ String.valueOf(jogadorKb) +", sua vez de jogar.",1);
					else
						setMensagemPainel("Tecle R para o agente "+ String.valueOf(proximoJogadorKb) +", jogar.",1);
				}			
			}
			
			graphic.drawString("Controles:", alinhamentoEsquerda, meioBloco * 8);
			graphic.drawString("AGENTES", alinhamentoEsquerda, meioBloco * 9);
			graphic.drawString("Pressione R", alinhamentoEsquerda, meioBloco * 10);
			
			graphic.drawString("HUMANOS:", alinhamentoEsquerda, meioBloco * 12);
			graphic.drawString("Move:  Oeste,Leste,Norte,Sul", alinhamentoEsquerda, meioBloco * 13);
			graphic.drawString("Atira: 1,    2,    3,    4", alinhamentoEsquerda, meioBloco * 14);
			
			graphic.drawString("LEGENDA:", alinhamentoEsquerda, meioBloco * 16);
			
			graphic.drawImage(ouro, alinhamentoEsquerda, meioBloco * 17);
			graphic.drawString("Ouro", alinhamentoEsquerda + meioBloco * 3, meioBloco * 17);		
			graphic.drawAnimation(brilho,alinhamentoEsquerda, meioBloco * 19);
			graphic.drawString("Brilho", alinhamentoEsquerda + meioBloco * 3, meioBloco * 19);
			
			graphic.drawAnimation(wumpus, alinhamentoEsquerda, meioBloco * 21);
			graphic.drawString("Wumpus", alinhamentoEsquerda + meioBloco * 3, meioBloco * 21);
			graphic.drawAnimation(fedor, alinhamentoEsquerda, meioBloco * 23);
			graphic.drawString("Fedor", alinhamentoEsquerda + meioBloco * 3, meioBloco * 23);
			
			graphic.drawImage(buraco, alinhamentoEsquerda, meioBloco * 25);
			graphic.drawString("buraco", alinhamentoEsquerda + meioBloco * 3, meioBloco * 25);
			graphic.drawAnimation(brisa, alinhamentoEsquerda, meioBloco * 27);
			graphic.drawString("Brisa", alinhamentoEsquerda + meioBloco * 3, meioBloco * 27);
			
			graphic.drawString(mensagemPainel1, meioBloco, meioBloco * 33);
			graphic.drawString(mensagemPainel2, meioBloco, meioBloco * 34);
		}
		
		private void setMensagemPainel(String mensagem, int linha){
			if (linha == 1) 
				mensagemPainel1 = mensagem; 
			else
				mensagemPainel2 = mensagem;
		}
		
/*		private boolean isBlocked(float x, float y) {
			int xBlock = (int) x / Constantes.TAMANHO_BLOCO;
			int yBlock = (int) y / Constantes.TAMANHO_BLOCO;
			return blocked[xBlock][yBlock];
		}*/

		private void realizarAcaoAutomatizada(Jogador jogador){
			if (jogador != null){
				recuperaPassoProlog(jogador);			

				if (jogador.isVivo()){
					if (jogador.getAcaoJogador() != null){
						switch (jogador.getAcaoJogador()){
						case ATIRAR_FLECHA:
							atirarFlecha(jogador);
							break;
						case PEGAR_OURO:
							pegarOuro(jogador);
							break;
						case MOVER:
							movimentarJogador(jogador);
							break;
						case ESBARRAO:
							break;
						default:	
							break;
						}		
					}
				}
			}
		}
		
		private void recuperaPassoProlog(Jogador jogador) {
			
			Jogada jogada = interfaceProlog.realizarPasso(jogador);
			
			if (jogada != null) {
				// recebe a comunicação das inferências da jogada
				interfaceProlog.leMensagem(jogada);
				
				if (jogador.isVivo()) 
					wumpusMorto = jogador.isMatouWumpus();
			}
		}
			
		private void pegarOuro(Jogador jogador) {
			if (jogador.getTipoJogador() != TipoJogador.AGENTE){
				recuperaPassoProlog(jogador);
				setMensagemPainel("Jogador "+jogador.getNumeroJogador()+" pegou o ouro. ", 2);	
				pegouOuro = true;
			}		
		}

		private void atirarFlecha(Jogador jogador){
			if (jogador.getTipoJogador() != TipoJogador.AGENTE)
				recuperaPassoProlog(jogador);
		}
		
		private void movimentarJogador(Jogador jogador){
			
			switch (jogador.getDirecaoAcaoJogador()) {
			case NORTE:
				jogador.setMovimento(jogador.getNorteJogador());
				break;
			case SUL:
				jogador.setMovimento(jogador.getSulJogador());
				break;
			case LESTE:
				jogador.setMovimento(jogador.getLesteJogador());
				break;
			case OESTE:
				jogador.setMovimento(jogador.getOesteJogador());
				break;
			default:
				break;
			}
		}
	}

