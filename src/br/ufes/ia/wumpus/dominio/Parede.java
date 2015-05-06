package br.ufes.ia.wumpus.dominio;

import br.ufes.ia.wumpus.prolog.ConstantesProlog;

public class Parede {
	
	private String paredeNorte = ConstantesProlog.PROLOG_NAO;
	private String paredeSul = ConstantesProlog.PROLOG_NAO;
	private String paredeLeste = ConstantesProlog.PROLOG_NAO;
	private String paredeOeste = ConstantesProlog.PROLOG_NAO;
	
	public Parede() {
		super();
		this.paredeNorte = ConstantesProlog.PROLOG_NAO;
		this.paredeSul = ConstantesProlog.PROLOG_NAO;
		this.paredeLeste = ConstantesProlog.PROLOG_NAO;
		this.paredeOeste = ConstantesProlog.PROLOG_NAO;
	}
	
	public String getParedeNorte() {
		return paredeNorte;
	}
	
	public void setParedeNorte(String paredeNorte) {
		this.paredeNorte = paredeNorte;
	}
	
	public String getParedeSul() {
		return paredeSul;
	}
	
	public void setParedeSul(String paredeSul) {
		this.paredeSul = paredeSul;
	}
	
	public String getParedeLeste() {
		return paredeLeste;
	}
	
	public void setParedeLeste(String paredeLeste) {
		this.paredeLeste = paredeLeste;
	}
	
	public String getParedeOeste() {
		return paredeOeste;
	}
	
	public void setParedeOeste(String paredeOeste) {
		this.paredeOeste = paredeOeste;
	}
		
}
