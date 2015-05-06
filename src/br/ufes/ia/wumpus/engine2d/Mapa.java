package br.ufes.ia.wumpus.engine2d;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import br.ufes.ia.wumpus.dominio.Constantes;
import br.ufes.ia.wumpus.prolog.JsonProlog;

public class Mapa {

	// tamanho padrão
	private int tamanhoMapa = 10;
	
	public int getTamanhoMapa() {
		return tamanhoMapa;
	}

	public void setTamanhoMapa(int tamanhoMapa) {
		this.tamanhoMapa = tamanhoMapa;
	}

	/* O mapa é gerado da esquerda para a direita em linha */
	public boolean gerarMapa(int tamanho)
	{
		boolean ret = false;
		setTamanhoMapa(tamanho);
		
		StringBuilder xml = new StringBuilder();
		
		// grama
		xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n");
		xml.append("<map version=\"1.0\" orientation=\"orthogonal\" width=\""+tamanhoMapa+"\" height=\""+tamanhoMapa+"\" tilewidth=\"34\" tileheight=\"34\"> \n");
		xml.append("  <tileset firstgid=\""+ Constantes.ID_TILE_GRAMA +"\" name=\"grama\" tilewidth=\"34\" tileheight=\"34\"> \n");
		xml.append("     <image source=\""+ Constantes.TILE_GRAMA +"\" width=\"34\" height=\"34\"/> \n");
		xml.append("  </tileset> \n");
		
		// pedra
		xml.append("  <tileset firstgid=\"2\" name=\"pedra\" tilewidth=\"34\" tileheight=\"34\"> \n");
		xml.append("     <image source=\""+ Constantes.TILE_PEDRA +"\" width=\"34\" height=\"34\"/> \n");
		xml.append("     <tile id=\"0\"> \n");
		xml.append("        <properties> \n");
		xml.append("           <property name=\"blocked\" value=\"true\"/> \n");
		xml.append("        </properties> \n");
		xml.append("     </tile> \n");
		xml.append("  </tileset> \n");
		
		xml.append(gerarLayersAndTiles());
		xml.append("</map>");
		
		try {
			FileOutputStream file = new FileOutputStream(Constantes.CAMINHO_MAPA_TMX);
			try {
				file.write(xml.toString().getBytes());
				file.close();
				ret = true;
			} catch (IOException e) {
				e.printStackTrace();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return ret;
	}
	
	private String gerarLayersAndTiles() {
		StringBuilder gidCodificada = new StringBuilder();
		StringBuilder xml = new StringBuilder();
		xml.append("   <layer name=\"Layer 0\" width=\""+tamanhoMapa+"\" height=\""+tamanhoMapa+"\"> \n");
		xml.append("      <data encoding=\"base64\" compression=\"gzip\"> \n");
		
		int tileBordasLaterais = tamanhoMapa +1;
		int numeroTiles = tamanhoMapa * tamanhoMapa;
		for (int i = 1; i<= numeroTiles; i++) {
			if (i <= tamanhoMapa || i >= (numeroTiles - tamanhoMapa +1)){
				gidCodificada.append(Constantes.ID_TILE_PEDRA_COD);
			}
			else {
				if (i == tileBordasLaterais || i == tileBordasLaterais -1 ){
					gidCodificada.append(Constantes.ID_TILE_PEDRA_COD);
					if (i == tileBordasLaterais){
						tileBordasLaterais += tamanhoMapa;
					}
				}
				else {
					gidCodificada.append(Constantes.ID_TILE_GRAMA_COD);
				}
			}
		}

		xml.append(JsonProlog.converteBase64(gidCodificada.toString()));
		
		xml.append("      </data> \n");
		xml.append("   </layer> \n");
		
		return xml.toString();
	}
}
