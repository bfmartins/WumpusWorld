package br.ufes.ia.wumpus.dominio;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import br.ufes.ia.wumpus.prolog.CoordenadaProlog;

public class Jogada {
	private int kb = 0;
	private String tipo;
	private Coordenada pos;
	private Percepcao percebe;
	private int energia = 0;
	private List<Acao> lista_de_acoes = new ArrayList<Acao>();
	private List<Coordenada> pos_visitadas = new ArrayList<Coordenada>(); 
	private String acao_exe;
	private String orientacao;
	private String agente_vivo;
	private String pegou_ouro;
	private String possui_flecha;
	private String wps_vivo;
	private int prox_kb;
	private String prox_tipo;

	private String retornoJogadaJSON = "";
	private JSONObject jogadaJSON;		
	
	public Jogada(String retornoKJogadaJSON) {
		super();
		
		// inicializa o objeto json
		setRetornoJogadaJSON(retornoKJogadaJSON);
		setJogadaJSON(new JSONObject(retornoKJogadaJSON));
		
		JSONArray coordenadasProlog = new JSONArray();
		CoordenadaProlog coordenadaProlog;
		
		// inicializa as informações da classe
		setKb(jogadaJSON.getInt("kb"));
		
		setTipo(jogadaJSON.getString("tipo"));
		
		coordenadasProlog = jogadaJSON.getJSONArray("pos");
		if (coordenadasProlog != null){
			coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
			Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
			setPos(coordenadaJava);
		}
		
		JSONArray listaPercebeProlog = new JSONArray();
		listaPercebeProlog = jogadaJSON.getJSONArray("percebe");
		if (listaPercebeProlog != null){
			JSONArray paredesProlog = new JSONArray();
			if (paredesProlog != null){
				Percepcao percebeJava = new Percepcao();
				Parede paredesJava = new Parede();
				percebeJava.setBrilho(listaPercebeProlog.getString(0));
				paredesProlog = listaPercebeProlog.getJSONArray(1);
				paredesJava.setParedeNorte(paredesProlog.getString(0));
				paredesJava.setParedeSul(paredesProlog.getString(1));
				paredesJava.setParedeLeste(paredesProlog.getString(2));
				paredesJava.setParedeOeste(paredesProlog.getString(3));
				percebeJava.setFedor(listaPercebeProlog.getString(2));
				percebeJava.setGrito(listaPercebeProlog.getString(3));
				percebeJava.setVento(listaPercebeProlog.getString(4));
				setPercebe(percebeJava);
			}
		}
	
		setEnergia(jogadaJSON.getInt("energia"));
		
		JSONArray listaAcoesProlog = new JSONArray();
		listaAcoesProlog = jogadaJSON.getJSONArray("lista_de_acoes");
		if (listaAcoesProlog != null){
			List<Acao> listaAcoesJava = new ArrayList<Acao>();
			for (int i = 0; i < listaAcoesProlog.length(); i++) {
				JSONArray acaoProlog = listaAcoesProlog.getJSONArray(i);
				coordenadasProlog = acaoProlog.getJSONArray(0);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				Acao acaoJava = new Acao(coordenadaJava,acaoProlog.getString(1),acaoProlog.getString(2));
				listaAcoesJava.add(acaoJava);
			}		
			setLista_de_acoes(listaAcoesJava);
		}
		
		JSONArray listaCoordenadasProlog = new JSONArray();
		listaCoordenadasProlog = jogadaJSON.getJSONArray("pos_visitadas");
		if (listaCoordenadasProlog != null){
			List<Coordenada> listaCoordenadas = new ArrayList<Coordenada>();
			for (int i = 0; i < listaCoordenadasProlog.length(); i++) {
				coordenadasProlog = listaCoordenadasProlog.getJSONArray(i);
				coordenadaProlog = new CoordenadaProlog(coordenadasProlog.get(0),coordenadasProlog.get(1));
				Coordenada coordenadaJava = new Coordenada(coordenadaProlog);
				listaCoordenadas.add(coordenadaJava);
			}		
			setPos_visitadas(listaCoordenadas);
		}
		
		setAcao_exe(jogadaJSON.getString("acao_exe"));
		setOrientacao(jogadaJSON.getString("orientacao"));
		setAgente_vivo(jogadaJSON.getString("agente_vivo"));
		setPegou_ouro(jogadaJSON.getString("pegou_ouro"));
		setPossui_flecha(jogadaJSON.getString("possui_flecha"));
		setWps_vivo(jogadaJSON.getString("wps_vivo"));
		setProx_kb(jogadaJSON.getInt("prox_kb"));
		setProx_tipo(jogadaJSON.getString("prox_tipo"));

	}
	public int getKb() {
		return kb;
	}
	
	private void setKb(int kb) {
		this.kb = kb;
	}
	
	public String getTipo() {
		return tipo;
	}
	
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	
	public Coordenada getPos() {
		return pos;
	}
	
	public void setPos(Coordenada pos) {
		this.pos = pos;
	}
	
	public Percepcao getPercebe() {
		return percebe;
	}
	
	public void setPercebe(Percepcao percebe) {
		this.percebe = percebe;
	}
	
	public int getEnergia() {
		return energia;
	}
	public void setEnergia(int energia) {
		this.energia = energia;
	}
	
	public List<Acao> getLista_de_acoes() {
		return lista_de_acoes;
	}
	
	public void setLista_de_acoes(List<Acao> lista_de_acoes) {
		this.lista_de_acoes = lista_de_acoes;
	}
	
	public List<Coordenada> getPos_visitadas() {
		return pos_visitadas;
	}
	
	public void setPos_visitadas(List<Coordenada> pos_visitadas) {
		this.pos_visitadas = pos_visitadas;
	}
	
	public String getAcao_exe() {
		return acao_exe;
	}
	
	public void setAcao_exe(String acao_exe) {
		this.acao_exe = acao_exe;
	}
	
	public String getAgente_vivo() {
		return agente_vivo;
	}
	
	public void setAgente_vivo(String agente_vivo) {
		this.agente_vivo = agente_vivo;
	}
	
	public String getPegou_ouro() {
		return pegou_ouro;
	}
	
	public void setPegou_ouro(String pegou_ouro) {
		this.pegou_ouro = pegou_ouro;
	}
	
	public String getPossui_flecha() {
		return possui_flecha;
	}
	
	public void setPossui_flecha(String possui_flecha) {
		this.possui_flecha = possui_flecha;
	}
	
	public String getWps_vivo() {
		return wps_vivo;
	}
	
	public void setWps_vivo(String wps_vivo) {
		this.wps_vivo = wps_vivo;
	}
	
	public String getOrientacao() {
		return orientacao;
	}
	
	public void setOrientacao(String orientacao) {
		this.orientacao = orientacao;
	}
	
	public int getProx_kb() {
		return prox_kb;
	}
	
	public void setProx_kb(int prox_kb) {
		this.prox_kb = prox_kb;
	}
	
	public String getProx_tipo() {
		return prox_tipo;
	}
	
	public void setProx_tipo(String prox_tipo) {
		this.prox_tipo = prox_tipo;
	}
	
	private void setJogadaJSON(JSONObject jogadaJSON) {
		this.jogadaJSON = jogadaJSON;
	}
	
	public String getRetornoJogadaJSON() {
		return retornoJogadaJSON;
	}
	
	private void setRetornoJogadaJSON(String retornoJogadaJSON) {
		this.retornoJogadaJSON = retornoJogadaJSON;
	}

}
