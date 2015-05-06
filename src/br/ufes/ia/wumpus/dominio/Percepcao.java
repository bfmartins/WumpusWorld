package br.ufes.ia.wumpus.dominio;

import br.ufes.ia.wumpus.prolog.ConstantesProlog;

public class Percepcao {
	
	private String brilho = ConstantesProlog.PROLOG_NAO;
	private Parede paredes;
	private String fedor = ConstantesProlog.PROLOG_NAO;
	private String grito = ConstantesProlog.PROLOG_NAO;
	private String vento = ConstantesProlog.PROLOG_NAO;
	
	private String ouro = ConstantesProlog.PROLOG_NAO;
	private String wumpus = ConstantesProlog.PROLOG_NAO;
	private String buraco = ConstantesProlog.PROLOG_NAO;
	
	public Percepcao() {
		super();
		this.brilho = ConstantesProlog.PROLOG_NAO;
		this.paredes = new Parede();
		this.fedor = ConstantesProlog.PROLOG_NAO;
		this.grito = ConstantesProlog.PROLOG_NAO;
		this.vento = ConstantesProlog.PROLOG_NAO;
	}

	public String getBrilho() {
		return brilho;
	}
	
	public void setBrilho(String brilho) {
		this.brilho = brilho;
	}
	
	public Parede getParedes() {
		return paredes;
	}
	
	public void setParedes(Parede paredes) {
		this.paredes = paredes;
	}
	
	public String getFedor() {
		return fedor;
	}
	
	public void setFedor(String fedor) {
		this.fedor = fedor;
	}
	
	public String getGrito() {
		return grito;
	}
	
	public void setGrito(String grito) {
		this.grito = grito;
	}
	
	public String getVento() {
		return vento;
	}
	
	public void setVento(String vento) {
		this.vento = vento;
	}

	public String getOuro() {
		return ouro;
	}

	public void setOuro(String ouro) {
		this.ouro = ouro;
	}

	public String getWumpus() {
		return wumpus;
	}

	public void setWumpus(String wumpus) {
		this.wumpus = wumpus;
	}

	public String getBuraco() {
		return buraco;
	}

	public void setBuraco(String buraco) {
		this.buraco = buraco;
	}
}
