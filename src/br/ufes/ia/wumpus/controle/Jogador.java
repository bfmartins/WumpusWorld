package br.ufes.ia.wumpus.controle;

import java.util.ArrayList;
import java.util.List;

import org.newdawn.slick.Image;
import org.newdawn.slick.SlickException;

import br.ufes.ia.wumpus.dominio.Constantes;
import br.ufes.ia.wumpus.dominio.Coordenada;
import br.ufes.ia.wumpus.dominio.Jogada;
import br.ufes.ia.wumpus.dominio.Constantes.AcaoJogador;
import br.ufes.ia.wumpus.dominio.Constantes.DirecaoAcaoJogador;
import br.ufes.ia.wumpus.dominio.Constantes.TipoJogador;
import br.ufes.ia.wumpus.prolog.ConstantesProlog;

public class Jogador {
	
	private int numeroJogador;
	private TipoJogador tipoJogador;
	private Image movimento, norteJogador, sulJogador, oesteJogador, lesteJogador;
	private Coordenada posicaoJogador;
	private Coordenada posicaoInicialJogadorMatriz;
	private List<Coordenada> posicoesVisitadasJogador = new ArrayList<Coordenada>();
	private List<Coordenada> posicoesInferidasJogador = new ArrayList<Coordenada>();
	private AcaoJogador acaoJogador;
	private DirecaoAcaoJogador direcaoAcaoJogador = DirecaoAcaoJogador.LESTE;
	private boolean vivo = true;
	private boolean saiu = false;
	private int energia = 1000;
	private boolean pegouOuro = false;
	private boolean possuiFlecha = true;
	private int proximoJogador = 0;
	private TipoJogador tipoProximoJogador;
	private boolean matouWumpus = false;
	private int contadorRastroJogador = 1;
		
	public Jogador(Jogada jogada) throws SlickException {
		super();
		
		if (jogada != null) {
			
			setNumeroJogador(jogada.getKb());
			
			setTipoJogador(jogada.getTipo());
			switch (getTipoJogador()) {
			case HUMANO:
				norteJogador = new Image(Constantes.IMAGEM_JOGADOR_HUMANO_NORTE);
				sulJogador = new Image(Constantes.IMAGEM_JOGADOR_HUMANO_SUL);
				lesteJogador = new Image(Constantes.IMAGEM_JOGADOR_HUMANO_LESTE);
				oesteJogador = new Image(Constantes.IMAGEM_JOGADOR_HUMANO_OESTE);
				break;
			case AGENTE:
				norteJogador = new Image(Constantes.IMAGEM_JOGADOR_AGENTE_NORTE);
				sulJogador = new Image(Constantes.IMAGEM_JOGADOR_AGENTE_SUL);
				lesteJogador = new Image(Constantes.IMAGEM_JOGADOR_AGENTE_LESTE);
				oesteJogador = new Image(Constantes.IMAGEM_JOGADOR_AGENTE_OESTE);
				break;
			default:
				break;
			}
			
			setMovimento(lesteJogador);
			setAcaoJogador(AcaoJogador.INICIAR);
			
			setPosicaoJogador(jogada.getPos());		
			setPosicaoInicialJogadorMatriz(jogada.getPos());
			setPosicoesVisitadasJogador(jogada.getPos_visitadas());
			setEnergia(jogada.getEnergia());
			setVivo(jogada.getAgente_vivo().equals(ConstantesProlog.PROLOG_SIM));
			setPegouOuro(jogada.getPegou_ouro().equals(ConstantesProlog.PROLOG_SIM));
			setPossuiFlecha(jogada.getPossui_flecha().equals(ConstantesProlog.PROLOG_SIM));
			setMatouWumpus(jogada.getWps_vivo().equals(ConstantesProlog.PROLOG_NAO));
			setProximoJogador(jogada.getProx_kb());
			setTipoProximoJogador(jogada.getProx_tipo());
		}
	}
	
	public void passoJogador(Jogada jogada) throws SlickException {
		
		if (jogada != null) {
			
			// Verificações em relação à jogada
			if ((getNumeroJogador() == jogada.getKb()) && isVivo() && !isSaiu()) {
				
				if (getTipoJogador() == TipoJogador.AGENTE){
					
					if (jogada.getAcao_exe().equals(ConstantesProlog.PROLOG_MOVER)) 
						setAcaoJogador(AcaoJogador.MOVER);
					else if (jogada.getAcao_exe().equals(ConstantesProlog.PROLOG_ATIRAR)) 
						setAcaoJogador(AcaoJogador.ATIRAR_FLECHA);
					else if (jogada.getAcao_exe().equals(ConstantesProlog.PROLOG_SAIR)) {
						setAcaoJogador(AcaoJogador.SAIR);
						setSaiu(true);
					}	
					else if (jogada.getAcao_exe().equals(ConstantesProlog.PROLOG_PEGAR_OURO)) 
						setAcaoJogador(AcaoJogador.PEGAR_OURO);
					
					if (jogada.getOrientacao().equals(ConstantesProlog.PROLOG_LESTE))
						setDirecaoAcaoJogador(DirecaoAcaoJogador.LESTE);
					else if (jogada.getOrientacao().equals(ConstantesProlog.PROLOG_OESTE))
						setDirecaoAcaoJogador(DirecaoAcaoJogador.OESTE);
					else if (jogada.getOrientacao().equals(ConstantesProlog.PROLOG_NORTE))
						setDirecaoAcaoJogador(DirecaoAcaoJogador.SUL);
					else if (jogada.getOrientacao().equals(ConstantesProlog.PROLOG_SUL))
						setDirecaoAcaoJogador(DirecaoAcaoJogador.NORTE);
					else 
						setDirecaoAcaoJogador(getDirecaoAcaoJogador());
				} 
				
				setPosicaoJogador(jogada.getPos());		
				setPosicaoInicialJogadorMatriz(jogada.getPos());
				setPosicoesVisitadasJogador(jogada.getPos_visitadas());
				setEnergia(jogada.getEnergia());
				setVivo(jogada.getAgente_vivo().equals(ConstantesProlog.PROLOG_SIM));
				setPegouOuro(jogada.getPegou_ouro().equals(ConstantesProlog.PROLOG_SIM));
				setPossuiFlecha(jogada.getPossui_flecha().equals(ConstantesProlog.PROLOG_SIM));
				setMatouWumpus(jogada.getWps_vivo().equals(ConstantesProlog.PROLOG_NAO));
				setProximoJogador(jogada.getProx_kb());
				setTipoProximoJogador(jogada.getProx_tipo());
			}
		}
	}
	
	public boolean isSaiu() {
		return saiu;
	}
	
	public void setSaiu(boolean saiu) {
		this.saiu = saiu;
	}
	
	public Image getMovimento() {
		return movimento;
	}
	
	public void setMovimento(Image movimento) {
		this.movimento = movimento;
	}
	
	public Image getNorteJogador() {
		return norteJogador;
	}
	
	public void setNorteJogador(Image norteJogador) {
		this.norteJogador = norteJogador;
	}
	
	public Image getSulJogador() {
		return sulJogador;
	}
	
	public void setSulJogador(Image sulJogador) {
		this.sulJogador = sulJogador;
	}
	
	public Image getOesteJogador() {
		return oesteJogador;
	}
	
	public void setOesteJogador(Image oesteJogador) {
		this.oesteJogador = oesteJogador;
	}
	
	public Image getLesteJogador() {
		return lesteJogador;
	}
	
	public void setLesteJogador(Image lesteJogador) {
		this.lesteJogador = lesteJogador;
	}
	
	public Coordenada getPosicaoJogador() {
		return posicaoJogador;
	}
	
	public void setPosicaoJogador(Coordenada posicaoJogador) {
		this.posicaoJogador = posicaoJogador;
	}
	
	public Coordenada getPosicaoInicialJogadorMatriz() {
		return posicaoInicialJogadorMatriz;
	}
	
	public void setPosicaoInicialJogadorMatriz(
			Coordenada posicaoInicialJogadorMatriz) {
		this.posicaoInicialJogadorMatriz = posicaoInicialJogadorMatriz;
	}
	
	public List<Coordenada> getPosicoesVisitadasJogador() {
		return posicoesVisitadasJogador;
	}
	
	public void setPosicoesVisitadasJogador(
			List<Coordenada> posicoesVisitadasJogador) {
		this.posicoesVisitadasJogador = posicoesVisitadasJogador;
	}
	
	public TipoJogador getTipoJogador() {
		return tipoJogador;
	}
	
	public void setTipoJogador(String tipoJogador) {
		if (tipoJogador == "humano") 
			this.tipoJogador = TipoJogador.HUMANO;
		else 
			this.tipoJogador = TipoJogador.AGENTE;
	}
	
	public void setTipoJogador(TipoJogador tipoJogador) {
		this.tipoJogador = tipoJogador;
	}
	
	public int getNumeroJogador() {
		return numeroJogador;
	}
	
	public void setNumeroJogador(int numeroJogador) {
		this.numeroJogador = numeroJogador;
	}
	
	public AcaoJogador getAcaoJogador() {
		return acaoJogador;
	}
	
	public void setAcaoJogador(AcaoJogador acaoJogador) {
		this.acaoJogador = acaoJogador;
	}
	
	public DirecaoAcaoJogador getDirecaoAcaoJogador() {
		return direcaoAcaoJogador;
	}
	
	public void setDirecaoAcaoJogador(DirecaoAcaoJogador direcaoAcaoJogador) {
		this.direcaoAcaoJogador = direcaoAcaoJogador;
	}
	
	public boolean isVivo() {
		return vivo;
	}
	
	public void setVivo(boolean vivo) {
		this.vivo = vivo;
	}
	
	public int getEnergia() {
		return energia;
	}
	
	public void setEnergia(int energia) {
		this.energia = energia;
	}
	
	public boolean isPegouOuro() {
		return pegouOuro;
	}
	
	public void setPegouOuro(boolean pegouOuro) {
		this.pegouOuro = pegouOuro;
	}
	
	public boolean isPossuiFlecha() {
		return possuiFlecha;
	}
	
	public void setPossuiFlecha(boolean possuiFlecha) {
		this.possuiFlecha = possuiFlecha;
	}
	
	public int getProximoJogador() {
		return proximoJogador;
	}
	
	public void setProximoJogador(int proximoJogador) {
		this.proximoJogador = proximoJogador;
	}
	
	public List<Coordenada> getPosicoesInferidasJogador() {
		return posicoesInferidasJogador;
	}
	
	public void setPosicoesInferidasJogador(List<Coordenada> posicoesInferidasJogador) {
		this.posicoesInferidasJogador = posicoesInferidasJogador;
	}
	
	public boolean isMatouWumpus() {
		return matouWumpus;
	}
	
	public void setMatouWumpus(boolean matouWumpus) {
		this.matouWumpus = matouWumpus;
	}

	public TipoJogador getTipoProximoJogador() {
		return tipoProximoJogador;
	}

	public void setTipoProximoJogador(TipoJogador tipoProximoJogador) {
		this.tipoProximoJogador = tipoProximoJogador;
	}
	
	public void setTipoProximoJogador(String tipoProximoJogador) {
		if (tipoProximoJogador == "humano") 
			this.tipoProximoJogador = TipoJogador.HUMANO;
		else 
			this.tipoProximoJogador = TipoJogador.AGENTE;
	}

	public int getContadorRastroJogador() {
		return contadorRastroJogador;
	}

	public void incrementaContadorRastroJogador() {
		this.contadorRastroJogador++;
	}
	
	public void decrementaContadorRastroJogador() {
		this.contadorRastroJogador--;
	}
	
	public void setContadorRastroJogador(int contadorRastroJogador) {
		this.contadorRastroJogador = contadorRastroJogador;
	}
			
}
