/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.entidade;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 *
 * @author horacio.vasconcellos
 */
public class Hierarquia implements Serializable {
   private String     caminho;
   private BigDecimal nivel;
   private String     sigla;
   private String     descricao;
   private BigDecimal  dotacao;
   private BigDecimal  bloqueio;   
   private BigDecimal  lotacao;   

    public Hierarquia() {
    }

    public Hierarquia(String caminho, BigDecimal nivel, String sigla, String descricao, BigDecimal dotacao, BigDecimal bloqueio, BigDecimal lotacao) {
        this.caminho = caminho;
        this.nivel = nivel;
        this.sigla = sigla;
        this.descricao = descricao;
        this.dotacao = dotacao;
        this.bloqueio = bloqueio;
        this.lotacao = lotacao;
    }

    public String getCaminho() {
        return caminho;
    }

    public void setCaminho(String caminho) {
        this.caminho = caminho;
    }

    public BigDecimal getNivel() {
        return nivel;
    }

    public void setNivel(BigDecimal nivel) {
        this.nivel = nivel;
    }

    public String getSigla() {
        return sigla;
    }

    public void setSigla(String sigla) {
        this.sigla = sigla;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public BigDecimal getDotacao() {
        return dotacao;
    }

    public void setDotacao(BigDecimal dotacao) {
        this.dotacao = dotacao;
    }

    public BigDecimal getBloqueio() {
        return bloqueio;
    }

    public void setBloqueio(BigDecimal bloqueio) {
        this.bloqueio = bloqueio;
    }

    public BigDecimal getLotacao() {
        return lotacao;
    }

    public void setLotacao(BigDecimal lotacao) {
        this.lotacao = lotacao;
    }
   
   
}
