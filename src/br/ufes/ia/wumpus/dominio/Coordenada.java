package br.ufes.ia.wumpus.dominio;

import java.util.List;

import br.ufes.ia.wumpus.prolog.CoordenadaProlog;

public class Coordenada {

	private int x = 0;
	private int y = 0;

	private CoordenadaProlog cProlog;
	
	public Coordenada(int posicaoX, int posicaoY){
		x = posicaoX;
		y = posicaoY;
	}
	
	public Coordenada (CoordenadaProlog cProlog){
		Coordenada coord = toCoordenada(cProlog);
		if (coord != null) {
			setX(coord.getX());
			setY(coord.getY());
			setcProlog(cProlog);
		} 
	}
	
	public Coordenada(Object objectX, Object objectY) {
		if (objectX != null && objectY != null) {
			x = (int) objectX;
			y = (int) objectY;
		}
	}
	
	public int getX() {
		return x;
	}

	public void setX(int x) {
		this.x = x;
	}

	public int getY() {
		return y;
	}

	public void setY(int y) {
		this.y = y;
	}	

	public CoordenadaProlog getcProlog() {
		return cProlog;
	}

	public void setcProlog(CoordenadaProlog cProlog) {
		this.cProlog = cProlog;
	}
	
	public Coordenada toCoordenada(CoordenadaProlog cProlog){
		if (cProlog != null){
			// originallmente havia uma conversão que foi retirada
			int posicaoX = cProlog.getX();
			int posicaoY = cProlog.getY();
			Coordenada coordenada = new Coordenada(posicaoX,posicaoY);
			coordenada.setcProlog(cProlog);
			return coordenada;
		} else
			return null;
	}
	
	public boolean coordenadaPertenceLista(List<Coordenada> listaCoordenadas) {
		boolean retorno = false;
		for (Coordenada item : listaCoordenadas) 
			retorno = (item.getX() == getX() && item.getY() == getY()) || retorno ;
		return retorno;
	}

}
