package br.ufes.ia.wumpus.dominio;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import br.ufes.ia.wumpus.prolog.CoordenadaProlog;

public class Sinais {

	private int kb = 0;
	private List<Coordenada> listaPercebe = new ArrayList<Coordenada>();
	
	private String retornoPercepcaoJSON = "";
	private JSONObject percepcaoJSON;
	
	public Sinais(String retornoPersepcaoJSON) {
		super();
		
		// inicializa o objeto json
		setRetornoPercepcaoJSON(retornoPersepcaoJSON);
		setPercepcaoJSON(new JSONObject(retornoPercepcaoJSON));
		
		JSONArray coordenadasProlog = new JSONArray();
		CoordenadaProlog coordenadaProlog;
		
		// inicializa as informações da classe
		setKb(percepcaoJSON.getInt("kb"));
		
		JSONArray listaCoordenadasProlog = new JSONArray();
		listaCoordenadasProlog = percepcaoJSON.getJSONArray("pos");
		if (listaCoordenadasProlog != null){
			List<Coordenada> listaCoordenadas = new ArrayList<Coordenada>();
			for (int i = 0; i < listaCoordenadasProlog.length(); i++) {
				coordenadasProlog = listaCoordenadasProlog.getJSONArray(i);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				listaCoordenadas.add(coordenadaJava);
			}
			setListaPercebe(listaCoordenadas);
		}
	}
	
	public int getKb() {
		return kb;
	}
	
	private void setKb(int kb) {
		this.kb = kb;
	}
	
	public List<Coordenada> getListaPercebe() {
		return listaPercebe;
	}

	private void setListaPercebe(List<Coordenada> listaPercebe) {
		this.listaPercebe = listaPercebe;
	}

	public String getRetornoPercepcaoJSON() {
		return retornoPercepcaoJSON;
	}

	private void setRetornoPercepcaoJSON(String retornoPercepcaoJSON) {
		this.retornoPercepcaoJSON = retornoPercepcaoJSON;
	}

	private void setPercepcaoJSON(JSONObject persepcaoJSON) {
		this.percepcaoJSON = persepcaoJSON;
	}

	public JSONObject getPercepcaoJSON() {
		return percepcaoJSON;
	}	
	
}
