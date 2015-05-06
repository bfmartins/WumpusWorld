package br.ufes.ia.wumpus.dominio;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import br.ufes.ia.wumpus.prolog.CoordenadaProlog;

//import br.ufes.ia.wumpus.prolog.CoordenadaProlog;

public class Mensagem {

	private int kb = 0;
	private Coordenada wps;
	private List<Coordenada> brcs = new ArrayList<Coordenada>();
	private Coordenada our;
	private List<Coordenada> fdrs = new ArrayList<Coordenada>();
	private List<Coordenada> vnts = new ArrayList<Coordenada>();
	private List<Coordenada> blhs = new ArrayList<Coordenada>();
	private Coordenada pos_impasse;
	private Coordenada pos_pega_ouro;
	private Coordenada pos_mata_wps;
	private String agt_atirou_flecha;
	private String agt_saiu;
	private String agt_repete;
	
	private String retornoMensagemJSON = "";
	private JSONObject mensagemJSON;
		
	public Mensagem(String retornoMensagemJSON) {
		super();
		
		// inicializa o objeto json
		setRetornoMensagemJSON(retornoMensagemJSON);
		setMensagemJSON(new JSONObject(retornoMensagemJSON));
		
		JSONArray coordenadasProlog = new JSONArray();
		CoordenadaProlog coordenadaProlog;
		JSONArray listaCoordenadasProlog; 
		
		// inicializa as informações da classe
		setKb(mensagemJSON.getInt("kb"));
		
		coordenadasProlog = mensagemJSON.getJSONArray("wps");
		if (coordenadasProlog != null){
			if (coordenadasProlog.length() > 0) 
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			else
				coordenadaProlog = new CoordenadaProlog("[]");
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setWps(coordenadaJava);
		}
		
		listaCoordenadasProlog = new JSONArray();
		listaCoordenadasProlog = mensagemJSON.getJSONArray("brcs");
		if (listaCoordenadasProlog != null){
			List<Coordenada> listaCoordenadas = new ArrayList<Coordenada>();
			for (int i = 0; i < listaCoordenadasProlog.length(); i++) {
				coordenadasProlog = listaCoordenadasProlog.getJSONArray(i);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				listaCoordenadas.add(coordenadaJava);
			}		
			setBrcs(listaCoordenadas);
		}
		
		coordenadasProlog = mensagemJSON.getJSONArray("our");
		if (coordenadasProlog != null){
			if (coordenadasProlog.length() > 0) 
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			else
				coordenadaProlog = new CoordenadaProlog("[]");
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setOur(coordenadaJava);
		}
		
		listaCoordenadasProlog = new JSONArray();
		listaCoordenadasProlog = mensagemJSON.getJSONArray("fdrs");
		if (listaCoordenadasProlog != null){
			List<Coordenada> listaCoordenadas = new ArrayList<Coordenada>();
			for (int i = 0; i < listaCoordenadasProlog.length(); i++) {
				coordenadasProlog = listaCoordenadasProlog.getJSONArray(i);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				listaCoordenadas.add(coordenadaJava);
			}		
			setFdrs(listaCoordenadas);
		}
		
		listaCoordenadasProlog = new JSONArray();
		listaCoordenadasProlog = mensagemJSON.getJSONArray("vnts");
		if (listaCoordenadasProlog != null){
			List<Coordenada> listaCoordenadas = new ArrayList<Coordenada>();
			for (int i = 0; i < listaCoordenadasProlog.length(); i++) {
				coordenadasProlog = listaCoordenadasProlog.getJSONArray(i);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				listaCoordenadas.add(coordenadaJava);
			}		
			setVnts(listaCoordenadas);
		}
		
		listaCoordenadasProlog = new JSONArray();
		listaCoordenadasProlog = mensagemJSON.getJSONArray("blhs");
		if (listaCoordenadasProlog != null){
			List<Coordenada> listaCoordenadas = new ArrayList<Coordenada>();
			for (int i = 0; i < listaCoordenadasProlog.length(); i++) {
				coordenadasProlog = listaCoordenadasProlog.getJSONArray(i);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				listaCoordenadas.add(coordenadaJava);
			}		
			setBlhs(listaCoordenadas);
		}
		
		coordenadasProlog = mensagemJSON.getJSONArray("pos_impasse");
		if (coordenadasProlog != null){
			if (coordenadasProlog.length() > 0) 
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			else
				coordenadaProlog = new CoordenadaProlog("[]");
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setPos_impasse(coordenadaJava);
		}
		
		coordenadasProlog = mensagemJSON.getJSONArray("pos_pega_ouro");
		if (coordenadasProlog != null){
			if (coordenadasProlog.length() > 0) 
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			else
				coordenadaProlog = new CoordenadaProlog("[]");
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setPos_pega_ouro(coordenadaJava);
		}			
		
		coordenadasProlog = mensagemJSON.getJSONArray("pos_mata_wps");
		if (coordenadasProlog != null){
			if (coordenadasProlog.length() > 0) 
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			else
				coordenadaProlog = new CoordenadaProlog("[]");
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setPos_mata_wps(coordenadaJava);
		}
		
		setAgt_atirou_flecha(mensagemJSON.getString("agt_atirou_flecha"));
		setAgt_saiu(mensagemJSON.getString("agt_saiu"));
		setAgt_repete(mensagemJSON.getString("agt_repete"));

	}
	
	public int getKb() {
		return kb;
	}
	
	private void setKb(int kb) {
		this.kb = kb;
	}
	
	public Coordenada getWps() {
		return wps;
	}
	
	private void setWps(Coordenada wps) {
		this.wps = wps;
	}
	
	public List<Coordenada> getBrcs() {
		return brcs;
	}
	
	private void setBrcs(List<Coordenada> brcs) {
		this.brcs = brcs;
	}
	
	public Coordenada getOur() {
		return our;
	}
	
	private void setOur(Coordenada our) {
		this.our = our;
	}
	
	public List<Coordenada> getFdrs() {
		return fdrs;
	}
	
	private void setFdrs(List<Coordenada> fdrs) {
		this.fdrs = fdrs;
	}
	
	public List<Coordenada> getVnts() {
		return vnts;
	}
	
	private void setVnts(List<Coordenada> vnts) {
		this.vnts = vnts;
	}
	
	public List<Coordenada> getBlhs() {
		return blhs;
	}
	
	private void setBlhs(List<Coordenada> blhs) {
		this.blhs = blhs;
	}
	
	public Coordenada getPos_impasse() {
		return pos_impasse;
	}
	
	private void setPos_impasse(Coordenada pos_impasse) {
		this.pos_impasse = pos_impasse;
	}
	
	public Coordenada getPos_pega_ouro() {
		return pos_pega_ouro;
	}
	
	private void setPos_pega_ouro(Coordenada pos_pega_ouro) {
		this.pos_pega_ouro = pos_pega_ouro;
	}
	
	public Coordenada getPos_mata_wps() {
		return pos_mata_wps;
	}
	
	private void setPos_mata_wps(Coordenada pos_mata_wps) {
		this.pos_mata_wps = pos_mata_wps;
	}
	
	public String getAgt_atirou_flecha() {
		return agt_atirou_flecha;
	}
	
	private void setAgt_atirou_flecha(String agt_atirou_flecha) {
		this.agt_atirou_flecha = agt_atirou_flecha;
	}
	
	public String getAgt_saiu() {
		return agt_saiu;
	}
	
	private void setAgt_saiu(String agt_saiu) {
		this.agt_saiu = agt_saiu;
	}
	
	public String getAgt_repete() {
		return agt_repete;
	}
	
	private void setAgt_repete(String agt_repete) {
		this.agt_repete = agt_repete;
	}
	
	private void setMensagemJSON(JSONObject mensagemJSON) {
		this.mensagemJSON = mensagemJSON;
	}
	
	public String getRetornoMensagemJSON() {
		return retornoMensagemJSON;
	}
	
	private void setRetornoMensagemJSON(String retornoMensagemJSON) {
		this.retornoMensagemJSON = retornoMensagemJSON;
	}
}
