package br.ufes.ia.wumpus.dominio;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import br.ufes.ia.wumpus.prolog.CoordenadaProlog;

public class Tabuleiro {
	
	private int kb = 0;
	private Coordenada pos_wps;
	private List<Coordenada> lista_buracos = new ArrayList<Coordenada>();
	private Coordenada pos_our;
	
	private String retornoTabuleiroJSON = "";
	private JSONObject tabuleiroJSON;
		
	public Tabuleiro(String retornoTabuleiroJSON) {
		super();
		
		// inicializa o objeto json
		setRetornoTabuleiroJSON(retornoTabuleiroJSON);
		setTabuleiroJSON(new JSONObject(retornoTabuleiroJSON));
		
		JSONArray coordenadasProlog = new JSONArray();
		CoordenadaProlog coordenadaProlog;
		
		// inicializa as informações da classe
		setKb(tabuleiroJSON.getInt("kb"));
		
		coordenadasProlog = tabuleiroJSON.getJSONArray("pos_wps");
		if (coordenadasProlog != null){
			coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setPos_wps(coordenadaJava);
		}
		
		JSONArray listaCoordenadasProlog = new JSONArray();
		listaCoordenadasProlog = tabuleiroJSON.getJSONArray("lista_buracos");
		if (listaCoordenadasProlog != null){
			List<Coordenada> listaCoordenadas = new ArrayList<Coordenada>();
			for (int i = 0; i < listaCoordenadasProlog.length(); i++) {
				coordenadasProlog = listaCoordenadasProlog.getJSONArray(i);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				listaCoordenadas.add(coordenadaJava);
			}		
			setLista_buracos(listaCoordenadas);
		}
		
		coordenadasProlog = tabuleiroJSON.getJSONArray("pos_our");
		if (coordenadasProlog != null){
			coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setPos_our(coordenadaJava);
		}
	}
	
	public int getKb() {
		return kb;
	}
	
	private void setKb(int kb) {
		this.kb = kb;
	}
	
	public Coordenada getPos_wps() {
		return pos_wps;
	}
	
	private void setPos_wps(Coordenada pos_wps) {
		this.pos_wps = pos_wps;
	}
	
	public List<Coordenada> getLista_buracos() {
		return lista_buracos;
	}
	
	public void setLista_buracos(List<Coordenada> lista_buracos) {
		this.lista_buracos = lista_buracos;
	}
	
	public Coordenada getPos_our() {
		return pos_our;
	}
	
	private void setPos_our(Coordenada pos_our) {
		this.pos_our = pos_our;
	}
	
	private void setTabuleiroJSON(JSONObject tabuleiroJSON) {
		this.tabuleiroJSON = tabuleiroJSON;
	}
	
	public String getRetornoTabuleiroJSON() {
		return retornoTabuleiroJSON;
	}
	
	private void setRetornoTabuleiroJSON(String retornoTabuleiroJSON) {
		this.retornoTabuleiroJSON = retornoTabuleiroJSON;
	}

}
