package br.ufes.ia.wumpus.controle;

import java.util.ArrayList;
import java.util.List;

import br.ufes.ia.wumpus.dominio.Coordenada;
import br.ufes.ia.wumpus.dominio.Mensagem;
import br.ufes.ia.wumpus.prolog.ConstantesProlog;

public class Comunicacao {

	private int numeroJogador;
	private Coordenada posWumpus = new Coordenada (34 ,34);
	private List<Coordenada> posicoesBuracos = new ArrayList<Coordenada>();
	private Coordenada posOuro = new Coordenada (34 ,34);
	private List<Coordenada> posicoesFedores = new ArrayList<Coordenada>();
	private List<Coordenada> posicoesVentos = new ArrayList<Coordenada>();
	private List<Coordenada> posicoesBrilhos = new ArrayList<Coordenada>();
	private Coordenada posImpasse = new Coordenada (34 ,34);
	private Coordenada posPegouOuro = new Coordenada (34 ,34);
	private Coordenada posMatouWumpus = new Coordenada (34 ,34);
	private boolean atirouFlecha = false;
	private boolean agenteSaiu = false;
	private boolean repeteJogada = false;
	
	private boolean inferiuFedor = false;
	private boolean inferiuBrilho = false;
	private boolean inferiuVento = false;
	
	private List<Coordenada> posicoesVisitadas = new ArrayList<Coordenada>();	
	
	private List<Coordenada> posicoesInferidas = new ArrayList<Coordenada>();
	private int totalPosicoesInferidas = 0;
	
	private List<Coordenada> posicoesDescobertas = new ArrayList<Coordenada>();
	private int totalPosicoesDescobertas = 0;

	public Comunicacao(Mensagem mensagem, List<Coordenada> posicoesVisitadas) {
		super();		
		
		this.posicoesVisitadas = posicoesVisitadas;
		
		// alimenta os dados da comunicação
		setNumeroJogador(mensagem.getKb());
		
		// acoes
		setRepeteJogada(mensagem.getAgt_repete().equals(ConstantesProlog.PROLOG_SIM));
		setAgenteSaiu(mensagem.getAgt_saiu().equals(ConstantesProlog.PROLOG_SIM));
		setAtirouFlecha(mensagem.getAgt_atirou_flecha().equals(ConstantesProlog.PROLOG_SIM));
		
		// valores descobertos
		setPosImpasse(mensagem.getPos_impasse());
		setPosPegouOuro(mensagem.getPos_pega_ouro());
		
		// valores inferidos ou descobertos
		setPosicoesBrilhos(mensagem.getBlhs());
		setPosicoesBuracos(mensagem.getBrcs());
		setPosicoesFedores(mensagem.getFdrs());
		setPosicoesVentos(mensagem.getVnts());
		
		// valores inferidos
		setPosMatouWumpus(mensagem.getPos_mata_wps());
		setPosOuro(mensagem.getOur());		
		setPosWumpus(mensagem.getWps());
	}
	
	public int getNumeroJogador() {
		return numeroJogador;
	}
	
	public void setNumeroJogador(int numeroJogador) {
		this.numeroJogador = numeroJogador;
	}
	
	public Coordenada getPosWumpus() {
		return posWumpus;
	}
	
	public void setPosWumpus(Coordenada posWumpus) {
		this.posWumpus = posWumpus;
		posicoesInferidas.add(posWumpus);
		setTotalPosicoesInferidas();
	}
	
	public List<Coordenada> getPosicoesBuracos() {
		return posicoesBuracos;
	}
	
	public void setPosicoesBuracos(List<Coordenada> posicoesBuracos) {
		this.posicoesBuracos = posicoesBuracos;
		for (int i = 0; i < posicoesBuracos.size(); i++) 
			posicoesInferidas.add(posicoesBuracos.get(i));
		setTotalPosicoesInferidas();
}
	public Coordenada getPosOuro() {
		return posOuro;
	}
	
	public void setPosOuro(Coordenada posOuro) {
		if (!posOuro.coordenadaPertenceLista(posicoesVisitadas)) {
			this.posOuro = posOuro;
			posicoesInferidas.add(posOuro);
			setTotalPosicoesInferidas();
		}
	}
	
	public List<Coordenada> getPosicoesFedores() {
		return posicoesFedores;
	}
	
	public void setPosicoesFedores(List<Coordenada> posicoesFedores) {
		this.posicoesFedores = posicoesFedores;
		Coordenada posicao;
		for (int i = 0; i < posicoesFedores.size(); i++) {
			posicao = posicoesFedores.get(i);
			if (!posicao.coordenadaPertenceLista(posicoesVisitadas)) {
				posicoesInferidas.add(posicao);
				setTotalPosicoesInferidas();
				inferiuFedor = true; 
			}
		}
	}
	
	public List<Coordenada> getPosicoesVentos() {
		return posicoesVentos;
	}
	
	public void setPosicoesVentos(List<Coordenada> posicoesVentos) {
		this.posicoesVentos = posicoesVentos;
		Coordenada posicao;
		for (int i = 0; i < posicoesVentos.size(); i++) {
			posicao = posicoesVentos.get(i);
			if (!posicao.coordenadaPertenceLista(posicoesVisitadas)) {
				posicoesInferidas.add(posicao);
				setTotalPosicoesInferidas();
				inferiuVento = true;
			}
		}
	}
	
	public List<Coordenada> getPosicoesBrilhos() {
		return posicoesBrilhos;
	}
	
	public void setPosicoesBrilhos(List<Coordenada> posicoesBrilhos) {
		this.posicoesBrilhos = posicoesBrilhos;
		Coordenada posicao;
		for (int i = 0; i < posicoesBrilhos.size(); i++) {
			posicao = posicoesBrilhos.get(i);
			if (!posicao.coordenadaPertenceLista(posicoesVisitadas)) {
				posicoesInferidas.add(posicao);
				setTotalPosicoesInferidas();
				inferiuBrilho = true;
			}
		}
	}
	
	public Coordenada getPosImpasse() {
		return posImpasse;
	}
	
	public void setPosImpasse(Coordenada posImpasse) {
		this.posImpasse = posImpasse;
	}
	
	public Coordenada getPosPegouOuro() {
		return posPegouOuro;
	}
	
	public void setPosPegouOuro(Coordenada posPegouOuro) {
		this.posPegouOuro = posPegouOuro;
		posicoesDescobertas.add(posPegouOuro);
		setTotalPosicoesDescobertas();
	}
	
	public Coordenada getPosMatouWumpus() {
		return posMatouWumpus;
	}
	
	public void setPosMatouWumpus(Coordenada posMatouWumpus) { 
		this.posMatouWumpus = posMatouWumpus;
		posicoesInferidas.add(posMatouWumpus);
		setTotalPosicoesInferidas();
	}
	
	public boolean isAtirouFlecha() {
		return atirouFlecha;
	}
	
	public void setAtirouFlecha(boolean atirouFlecha) {
		this.atirouFlecha = atirouFlecha;
	}
	
	public boolean isAgenteSaiu() {
		return agenteSaiu;
	}
	
	public void setAgenteSaiu(boolean agenteSaiu) {
		this.agenteSaiu = agenteSaiu;
	}
	
	public List<Coordenada> getPosicoesInferidas() {
		return posicoesInferidas;
	}
	
	public int getTotalPosicoesInferidas() {
		setTotalPosicoesInferidas();
		return totalPosicoesInferidas;
	}
	
	private void setTotalPosicoesInferidas() {
		this.totalPosicoesInferidas = posicoesInferidas.size();
	}
	
	public Coordenada getPosicaoInferida(int posicao) {
		if (posicao < getTotalPosicoesInferidas()) {
			Coordenada cord = posicoesInferidas.get(posicao);
			return cord;
		} else 
			return null;
	}
	
	public List<Coordenada> getPosicoesVisitadas() {
		return posicoesVisitadas;
	}
	
	public List<Coordenada> getPosicoesDescobertas() {
		return posicoesDescobertas;
	}
	
	public int getTotalPosicoesDescobertas() {
		setTotalPosicoesInferidas();
		return totalPosicoesDescobertas;
	}
	
	private void setTotalPosicoesDescobertas() {
		this.totalPosicoesDescobertas = posicoesDescobertas.size();
	}
	
	public Coordenada getPosicaoDescoberta(int posicao) {
		if (posicao < getTotalPosicoesDescobertas()) {
			Coordenada cord = posicoesDescobertas.get(posicao);
			return cord;
		} else 
			return null;
	}
	
	public boolean isRepeteJogada() {
		return repeteJogada;
	}
	
	public void setRepeteJogada(boolean repeteJogada) {
		this.repeteJogada = repeteJogada;
	}

	public boolean inferiuFedor() {
		return inferiuFedor;
	}

	public boolean inferiuBrilho() {
		return inferiuBrilho;
	}

	public boolean inferiuVento() {
		return inferiuVento;
	}
		
}
