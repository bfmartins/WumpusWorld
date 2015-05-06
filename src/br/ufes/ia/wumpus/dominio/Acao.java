package br.ufes.ia.wumpus.dominio;

public class Acao {
	private Coordenada posicao;
	private String acao;
	private String orienta��o;
	
	public Acao(Coordenada posicao, String acao, String orienta��o) {
		super();
		this.posicao = posicao;
		this.acao = acao;
		this.orienta��o = orienta��o;
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
	
	public String getOrienta��o() {
		return orienta��o;
	}
	
	public void setOrienta��o(String orienta��o) {
		this.orienta��o = orienta��o;
	}
		
}
