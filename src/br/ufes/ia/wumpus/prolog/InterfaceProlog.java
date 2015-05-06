package br.ufes.ia.wumpus.prolog;

import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.List;

import org.newdawn.slick.SlickException;

import jpl.Atom;
import jpl.Query;
import jpl.Term;
import br.ufes.ia.wumpus.controle.Comunicacao;
import br.ufes.ia.wumpus.controle.Jogador;
import br.ufes.ia.wumpus.dominio.Constantes;
import br.ufes.ia.wumpus.dominio.Coordenada;
import br.ufes.ia.wumpus.dominio.Mensagem;
import br.ufes.ia.wumpus.dominio.Jogada;
import br.ufes.ia.wumpus.dominio.Sinais;
import br.ufes.ia.wumpus.dominio. Tabuleiro;
import br.ufes.ia.wumpus.dominio.Constantes.TipoJogador;
import br.ufes.ia.wumpus.dominio.Constantes.TipoObjeto;

public class InterfaceProlog {
	
	private Query query;
	private HttpURLConnection httpConn;
	private String host = "http://localhost:8088/";
	private String server = "server(8088)";
	private Jogada ultimaJogada;
	private Comunicacao ultimaComunicacao;
	private boolean hasSolution = false;
	private boolean fim = false;
	
	public InterfaceProlog(int tamanhoMatriz, int numeroAgentes, int numeroJogadores){
		query = new Query("consult", new Term[] { new Atom(Constantes.CAMINHO_WUMPUS_PROLOG) });
		hasSolution = query.hasSolution();
		
		query = new Query(server);
		hasSolution = query.hasSolution();
		
		// (tamanho da matriz,num agentes,num jogadores)
		query = new Query("main4j("+tamanhoMatriz+","+numeroAgentes+","+numeroJogadores+")");
		hasSolution = query.hasSolution();
	}
	
	public boolean verificaFim() {
		query = new Query("json_fim(Request)");
		hasSolution = query.hasSolution();
		return hasSolution;
	}
	
	public Jogador inicializaJogador(){

		String retornoJson = "";
		query = new Query("json_inic_jog(KB,Request)");
		hasSolution = query.hasSolution();
		retornoJson = JsonProlog.getJson(httpConn, host + "json_inic_jog");		
		// obtem o resultado
		Jogada jogada = new Jogada(retornoJson);
	
		// alimenta o jogador com as informações da jogada inicial (inic do prolog)
		Jogador jogador;
		try {
			jogador = new Jogador(jogada);
			ultimaJogada = jogada;			

			// seta o próximo jogador 
			query = new Query("set_agt_4j("+jogador.getNumeroJogador()+")");
			hasSolution = query.hasSolution();
			
			return jogador;			
		} catch (SlickException e) {
			String a = e.getMessage();
			System.out.print(a);
			return null;
		}
	}

	// M = matriz, [i,j] = posição do wumpus, [[a,b],[c,d],[e,f]] = posições dos buracos, [i,j] = posição do ouro
	public HashMap<Coordenada, TipoObjeto> consultarObjetosMundo(){
		
		HashMap<Coordenada, TipoObjeto> ret = new HashMap<Coordenada, TipoObjeto>();

		// Tabuleiro (ouro, wumpus e buracos)
		query = new Query("json_inic(Request)");
		hasSolution = query.hasSolution();
		String retornoJson = JsonProlog.getJson(httpConn, host + "json_inic");
		Tabuleiro tabuleiro = new Tabuleiro(retornoJson);

		Coordenada posicaoWumpus = tabuleiro.getPos_wps();
		ret.put(posicaoWumpus,TipoObjeto.WUMPUS);

		List<Coordenada> posicoesBuracos = tabuleiro.getLista_buracos();
		for (int i = 0; i < posicoesBuracos.size(); i++) {
			Coordenada posicaoBuraco = posicoesBuracos.get(i);
			ret.put(posicaoBuraco, TipoObjeto.BURACO);
		}
		
		Coordenada posicaoOuro = tabuleiro.getPos_our();
		ret.put(posicaoOuro,TipoObjeto.OURO);
		
		// fedor
		query = new Query("json_fdr(Request)");
		hasSolution = query.hasSolution();
		retornoJson = JsonProlog.getJson(httpConn, host + "json_fdr");
		Sinais percepcaoFedor = new Sinais(retornoJson);

		List<Coordenada> posicoesFedores = percepcaoFedor.getListaPercebe();
		for (int i = 0; i < posicoesFedores.size(); i++) {
			Coordenada posicaoFedor = posicoesFedores.get(i);
			ret.put(posicaoFedor, TipoObjeto.FEDOR);
		}

		// brilho
		query = new Query("json_blh(Request)");
		hasSolution = query.hasSolution();
		retornoJson = JsonProlog.getJson(httpConn, host + "json_blh");
		Sinais percepcaoBrilho = new Sinais(retornoJson);

		List<Coordenada> posicoesBrilhos = percepcaoBrilho.getListaPercebe();
		for (int i = 0; i < posicoesBrilhos.size(); i++) {
			Coordenada posicaoBrilho = posicoesBrilhos.get(i);
			ret.put(posicaoBrilho, TipoObjeto.BRILHO);
		}
		
		// brisa
		query = new Query("json_vnt(Request)");
		hasSolution = query.hasSolution();
		retornoJson = JsonProlog.getJson(httpConn, host + "json_vnt");
		Sinais percepcaoBrisa = new Sinais(retornoJson);

		List<Coordenada> posicoesBrisas = percepcaoBrisa.getListaPercebe();
		for (int i = 0; i < posicoesBrisas.size(); i++) {
			Coordenada posicaoBrisa = posicoesBrisas.get(i);
			ret.put(posicaoBrisa, TipoObjeto.BRILHO);
		}
		
		return ret;
	}
	
	public Jogada realizarPasso(Jogador jogador) {	
		
		String retornoJson = "";
		if (jogador != null){
			if (jogador.getTipoJogador() == TipoJogador.AGENTE){
				query = new Query("passo4j(A,B,C,agente)");
				hasSolution = query.hasSolution();
			} else{
				String acao = new String();
				switch (jogador.getAcaoJogador()) {
					case MOVER:
						acao = "mover";
						break;
					case ATIRAR_FLECHA:
						acao = "atirar";
						break;
					case PEGAR_OURO:
						acao = "pegar_ouro";
						break;
					case SAIR:
						acao = "sair_caverna";
						break;
					default:
						break;
				}
				String direcao = new String();
				switch (jogador.getDirecaoAcaoJogador()) {
					case NORTE:
						direcao = "sul";
						break;
					case SUL:
						direcao = "norte";
						break;
					case LESTE:
						direcao = "leste";
						break;
					case OESTE:
						direcao = "oeste";
						break;
					default:
						direcao = "aqui";
						break;
				}
				query = new Query("passo4j("+acao+","+direcao+","+jogador.getNumeroJogador()+",humano)");
				hasSolution = query.hasSolution();
			}
				
			query = new Query("json_passo(" + jogador.getNumeroJogador() + ",Request)");
			hasSolution = query.hasSolution();
			retornoJson = JsonProlog.getJson(httpConn, host + "json_passo");
			
			// obtem o resultado
			Jogada jogada = new Jogada(retornoJson);
			ultimaJogada = jogada;
			
			// alimenta o jogador com as informações da jogada executada (passo do prolog)
			try {
				jogador.passoJogador(jogada);
			} catch (SlickException e) {
				String a = e.getMessage();
				System.out.print(a);
				return null;
			}
			
			// alimenta o flag de fim de jogo 
			setFim(verificaFim());
			
			return jogada;
		} else 
			return null;
	}

	public void leMensagem(Jogada jogada) {
		
		query = new Query("json_msg(Request)");
		hasSolution = query.hasSolution();
		String retornoJson = JsonProlog.getJson(httpConn, host + "json_msg");
		
		// obtem o resultado
		Mensagem mensagem = new Mensagem(retornoJson);
		
		// alimenta a lista de inferências com as informações das mensagens passadas
		Comunicacao comunicacao = new Comunicacao(mensagem,jogada.getPos_visitadas());
		ultimaComunicacao = comunicacao;
		
		// limpa a base de mensagens prolog
		query = new Query("reset_msg_4j");
		hasSolution = query.hasSolution();
	}

	public Jogada getUltimaJogada() {
		return ultimaJogada;
	}

	public Comunicacao getUltimaComunicacao() {
		return ultimaComunicacao;
	}

	public boolean isFim() {
		return fim;
	}

	public void setFim(boolean fim) {
		this.fim = fim;
	}
}

