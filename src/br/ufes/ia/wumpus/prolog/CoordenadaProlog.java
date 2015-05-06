package br.ufes.ia.wumpus.prolog;

import java.util.ArrayList;
import java.util.List;

import br.ufes.ia.wumpus.dominio.Coordenada;

public class CoordenadaProlog {
	
	private int x = 0;
	private int y = 0;
	
	public CoordenadaProlog(int posicaoX, int posicaoY){
		x = posicaoX;
		y = posicaoY;
	}
	
	public CoordenadaProlog(String coordenada){
		CoordenadaProlog coord = toCoordenadaProlog(coordenada);
		if (coord != null) {
			setX(coord.getX());
			setY(coord.getY());
		} 
	}
	
	public CoordenadaProlog(Object objectX, Object objectY) {
		if (objectX != null && objectY != null) {
			x = (int) objectX;
			y = (int) objectY;
		}
	}

	@Override
	public String toString() {
		return "[ " + x + ", " + y + "]";
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
	
	public CoordenadaProlog toCoordenadaProlog(String coordenada) {
		if (coordenada == null || coordenada.length() <= 0 || coordenada.trim().equals("[]"))
			return null;
		else {
			int x, y;
			x = Integer.parseInt(coordenada.substring(coordenada.indexOf('[')+1,coordenada.indexOf(',')-1));
			y = Integer.parseInt(coordenada.substring(coordenada.indexOf(',')+1,coordenada.indexOf(']')-1));
			return new CoordenadaProlog(x,y);
		}
	}
	
	public CoordenadaProlog toCoordenadaProlog(Coordenada cJava){
		if (cJava != null){
			int posicaoX = cJava.getX() - 1;
			int posicaoY = cJava.getY() - 1;
			CoordenadaProlog coordenada = new CoordenadaProlog(posicaoX,posicaoY);
			return coordenada;
		} else
			return null;
	}
	
	public List<CoordenadaProlog> toCoordenadasList(String coordenadas) {
		List<CoordenadaProlog> listaCoordenadas = new ArrayList<CoordenadaProlog>();
		String listaCoordString = coordenadas.substring(coordenadas.indexOf('[')+1,coordenadas.lastIndexOf(',')-1).trim();
		for (int i =1;i<= coordenadas.length();i++){
			CoordenadaProlog coordenada = toCoordenadaProlog(listaCoordString);			
			listaCoordenadas.add(coordenada);
			listaCoordString = listaCoordString.substring(coordenadas.lastIndexOf(']')+1);
		}
		return listaCoordenadas;
	}
	
	public boolean coordenadaPertenceLista(List<CoordenadaProlog> listaCoordenadas) {
		boolean retorno = false;
		for (CoordenadaProlog item : listaCoordenadas) 
			retorno = (item.getX() == getX() && item.getY() == getY()) || retorno ;
		return retorno;
	}

}
