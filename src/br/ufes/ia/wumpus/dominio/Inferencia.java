package br.ufes.ia.wumpus.dominio;

import br.ufes.ia.wumpus.prolog.ConstantesProlog;

public class Inferencia {
	private Coordenada coordenada;
	private Percepcao percepcao;
	private boolean inferiu = false;
		
	public Inferencia(Coordenada coordenada, Percepcao percepcao) {
		super();
		setCoordenada(coordenada);
		setPercepcao(percepcao);
	}

	public Coordenada getCoordenada() {
		return coordenada;
	}
	
	private void setCoordenada(Coordenada coordenada) {
		this.coordenada = coordenada;
	}
	
	public Percepcao getPercepcao() {
		return percepcao;
	}
	
	private void setPercepcao(Percepcao percepcao) {
		this.percepcao = percepcao;
	}

	public boolean isInferiu() {
		return inferiu;
	}

	public void setInferiu(Percepcao percebe) {
		this.inferiu = percebe.getBrilho().equals(ConstantesProlog.PROLOG_SIM) || 
				percebe.getBuraco().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getFedor().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getGrito().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getOuro().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getParedes().getParedeNorte().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getParedes().getParedeSul().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getParedes().getParedeLeste().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getParedes().getParedeOeste().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getVento().equals(ConstantesProlog.PROLOG_SIM) ||
				percebe.getWumpus().equals(ConstantesProlog.PROLOG_SIM);
	}
}
