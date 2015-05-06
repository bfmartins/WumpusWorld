package br.ufes.ia.wumpus.dominio;

public class Constantes {
	
	public static final String CAMINHO_WUMPUS_PROLOG = "data/mw.pl";
	public static final String CAMINHO_MAPA_TMX = "data/cenario.tmx";
	
	// Animações
	public static final String ANIMACAO_BRISA = "data/brisa.png";
	public static final String ANIMACAO_BRISA_ALT = "data/brisa_alt.png";
	
	public static final String ANIMACAO_BRILHO = "data/brilho.png";
	public static final String ANIMACAO_BRILHO_ALT = "data/brilho_alt.png";
	
	public static final String ANIMACAO_FEDOR = "data/fedor.png";
	public static final String ANIMACAO_FEDOR_ALT = "data/fedor_alt.png";
	
	public static final String ANIMACAO_WUMPUS = "data/wumpus.png";
	public static final String ANIMACAO_WUMPUS_ALT = "data/wumpus_alt.png";
	
	public static final String ANIMACAO_WUMPUS_MORTO = "data/wumpusM.png";
	public static final String ANIMACAO_WUMPUS_MORTO_ALT = "data/wumpusM_alt.png";
	
	// Imagens estáticas
	public static final String IMAGEM_JOGADOR_HUMANO_NORTE = "data/jogHBaixo.png";
	public static final String IMAGEM_JOGADOR_HUMANO_SUL = "data/jogHCima.png";
	public static final String IMAGEM_JOGADOR_HUMANO_LESTE = "data/jogHDir.png";
	public static final String IMAGEM_JOGADOR_HUMANO_OESTE = "data/jogHEsq.png";
	
	public static final String IMAGEM_JOGADOR_AGENTE_NORTE = "data/jogRBaixo.png";
	public static final String IMAGEM_JOGADOR_AGENTE_SUL = "data/jogRCima.png";
	public static final String IMAGEM_JOGADOR_AGENTE_LESTE = "data/jogRDir.png";
	public static final String IMAGEM_JOGADOR_AGENTE_OESTE = "data/jogREsq.png";
	
	public static final String IMAGEM_BURACO = "data/caverna.png";
	public static final String IMAGEM_OURO = "data/ouro.png";
	
	public static final String IMAGEM_SAIDA = "data/sair.png";
	
	public static final String IMAGEM_RASTRO_1 = "data/rastro1.png";
	public static final String IMAGEM_RASTRO_2 = "data/rastro2.png";
	public static final String IMAGEM_RASTRO_3 = "data/rastro3.png";
	public static final String IMAGEM_RASTRO_4 = "data/rastro4.png";
	
	// Tiles
	public static final int ID_TILE_GRAMA = 1;
	public static final int ID_TILE_GRAMA_COD = 1000;
	public static final String TILE_GRAMA = "grama.jpg";
	public static final int ID_TILE_PEDRA = 2;
	public static final int ID_TILE_PEDRA_COD = 2000;
	public static final String TILE_PEDRA = "pedra.jpg";
/*	public static final int ID_TILE_ENTRADA = 3;
	public static final int ID_TILE_ENTRADA_COD = 3000;
	public static final String TILE_ENTRADA = "entrada.jpg";
*/	
	// Configurações de renderização e mapa
	public static final int TAMANHO_BLOCO = 34;
	public static int TAMANHO_MAPA = 15;
	
	public static enum TipoObjeto {
		GRAMA , 
		PEDRA,
		OURO,
		BRILHO,
		WUMPUS,
		FEDOR,
		BURACO,
		BRISA,
		JOGADOR,
		ENTRADA,
		SAIDA
	}
	
	public static enum AcaoJogador {
		MOVER,
		ATIRAR_FLECHA,
		PEGAR_OURO,
		INICIAR,
		PAREDE,
		ESBARRAO,
		SAIR
	}
	
	public static enum DirecaoAcaoJogador {
		NORTE,
		SUL,
		LESTE,
		OESTE,
		AQUI
	}
	
	public static enum TipoJogador {
		HUMANO,
		AGENTE
	}	
}
