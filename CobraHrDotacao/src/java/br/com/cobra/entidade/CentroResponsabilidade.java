/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.entidade;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author horacio.vasconcellos
 */
public class CentroResponsabilidade  implements Serializable {
     private BigDecimal     flexValueId;
     private String         scr;
     private String         scrSigla;
     private String         descricao;
     private Date           dataInicio;
     private Date           dataTermino;
     private String         habilitado;

    public CentroResponsabilidade() {
        this.flexValueId = new BigDecimal(0);
        this.scr = null;
        this.scrSigla = "";
        this.descricao = "";
        this.dataInicio = new Date(System.currentTimeMillis());
        this.dataTermino = new Date(4712,31, 12);
        this.habilitado = "Y";
    }

    public CentroResponsabilidade(BigDecimal flexValueId, String scr, String scrSigla, String descricao, Date dataInicio, Date dataTermino, String habilitado) {
        this.flexValueId = flexValueId;
        this.scr = scr;
        this.scrSigla = scrSigla;
        this.descricao = descricao;
        this.dataInicio = dataInicio;
        this.dataTermino = dataTermino;
        this.habilitado = habilitado;
    }

    public CentroResponsabilidade(BigDecimal flexValueId, String scr, String descricao) {
        this.flexValueId = flexValueId;
        this.scr = scr;
        this.descricao = descricao;
    }

    public CentroResponsabilidade(BigDecimal flexValueId, String scr, String scrSigla, String descricao) {
        this.flexValueId = flexValueId;
        this.scr = scr;
        this.scrSigla = scrSigla;
        this.descricao = descricao;
    }

    public BigDecimal getFlexValueId() {
        return flexValueId;
    }

    public void setFlexValueId(BigDecimal flexValueId) {
        this.flexValueId = flexValueId;
    }

    public String getScr() {
        return scr;
    }

    public void setScr(String scr) {
        this.scr = scr;
    }

    public String getScrSigla() {
        return scrSigla;
    }

    public void setScrSigla(String scrSigla) {
        this.scrSigla = scrSigla;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Date getDataInicio() {
        return dataInicio;
    }

    public void setDataInicio(Date dataInicio) {
        this.dataInicio = dataInicio;
    }

    public Date getDataTermino() {
        return dataTermino;
    }

    public void setDataTermino(Date dataTermino) {
        this.dataTermino = dataTermino;
    }

    public String getHabilitado() {
        return habilitado;
    }

    public void setHabilitado(String habilitado) {
        this.habilitado = habilitado;
    }
     
}
