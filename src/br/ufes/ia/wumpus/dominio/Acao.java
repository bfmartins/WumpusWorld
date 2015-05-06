package br.ufes.ia.wumpus.dominio;

public class Acao {
	private Coordenada posicao;
	private String acao;
	private String orientação;
	
	public Acao(Coordenada posicao, String acao, String orientação) {
		super();
		this.posicao = posicao;
		this.acao = acao;
		this.orientação = orientação;
	}

	public Coordenada getPosicao() {
		return posicao;
	}
	
	public void setPosicao(Coordenada posicao) {
		this.posicao = posicao;
	}
	
	public String getAcao() {
		return acao;
	}
	
	public void setAcao(String acao) {
		this.acao = acao;
	}
	
	public String getOrientação() {
		return orientação;
	}
	
	public void setOrientação(String orientação) {
		this.orientação = orientação;
	}
		
}
