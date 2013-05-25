/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.entidade;

import java.io.Serializable;
import java.math.BigDecimal;

import java.util.Calendar;
import java.util.Date;


/**
 *
 * @author horacio.vasconcellos
 */
public class Dotacao implements Serializable  {
   private  BigDecimal                dotacaoId;
   private  CentroResponsabilidade    centroResponsabilidade; 
   private  Cargo                     cargo;
   private  Date                      effectiveStartDate;
   private  Date                      effectiveEndDate;
   private  int                       dotacao;
   private  int                       lotacao;
   private  int                       bloqueio;
   private  String                    documento;
   private  Funcionario               criadoPor;
   private  Funcionario               atualizadoPor;

    public Dotacao() {
        Calendar cal = (Calendar.getInstance());
        cal.set(4712, 12, 31); 
        Date dataTermino = cal.getTime();
        this.dotacaoId = new BigDecimal(0);
        this.centroResponsabilidade = new CentroResponsabilidade();
        this.cargo = new Cargo();
        this.effectiveStartDate = new Date(System.currentTimeMillis());
        this.effectiveEndDate = dataTermino;
        this.dotacao = new Integer("0");
        this.bloqueio = new Integer("0");
        this.lotacao  = new Integer("0");
        this.documento = null;
    }

    public Dotacao(BigDecimal dotacaoId, CentroResponsabilidade centroResponsabilidade, Cargo cargo) {
        this.dotacaoId = dotacaoId;
        this.centroResponsabilidade = centroResponsabilidade;
        this.cargo = cargo;
    }

    public Dotacao(BigDecimal dotacaoId, CentroResponsabilidade centroResponsabilidade, Cargo cargo, Date effectiveStartDate, Date effectiveEndDate, int dotacao, int bloqueio,String documento) {
        this.dotacaoId = dotacaoId;
        this.centroResponsabilidade = centroResponsabilidade;
        this.cargo = cargo;
        this.effectiveStartDate = effectiveStartDate;
        this.effectiveEndDate = effectiveEndDate;
        this.dotacao = dotacao;
        this.bloqueio = bloqueio;
        this.documento = documento;
    }

    public Dotacao(BigDecimal dotacaoId, CentroResponsabilidade centroResponsabilidade, Cargo cargo, Date effectiveStartDate, Date effectiveEndDate, int dotacao, int lotacao, int bloqueio, String documento) {
        this.dotacaoId = dotacaoId;
        this.centroResponsabilidade = centroResponsabilidade;
        this.cargo = cargo;
        this.effectiveStartDate = effectiveStartDate;
        this.effectiveEndDate = effectiveEndDate;
        this.dotacao = dotacao;
        this.lotacao = lotacao;
        this.bloqueio = bloqueio;
        this.documento = documento;
    }

    public Dotacao(BigDecimal dotacaoId, CentroResponsabilidade centroResponsabilidade, Cargo cargo, Date effectiveStartDate, Date effectiveEndDate, int dotacao, int lotacao, int bloqueio, String documento, Funcionario criadoPor, Funcionario atualizadoPor) {
        this.dotacaoId = dotacaoId;
        this.centroResponsabilidade = centroResponsabilidade;
        this.cargo = cargo;
        this.effectiveStartDate = effectiveStartDate;
        this.effectiveEndDate = effectiveEndDate;
        this.dotacao = dotacao;
        this.lotacao = lotacao;
        this.bloqueio = bloqueio;
        this.documento = documento;
        this.criadoPor = criadoPor;
        this.atualizadoPor = atualizadoPor;
    }

    public BigDecimal getDotacaoId() {
        return dotacaoId;
    }

    public void setDotacaoId(BigDecimal dotacaoId) {
        this.dotacaoId = dotacaoId;
    }

    public CentroResponsabilidade getCentroResponsabilidade() {
        return centroResponsabilidade;
    }

    public void setCentroResponsabilidade(CentroResponsabilidade centroResponsabilidade) {
        this.centroResponsabilidade = centroResponsabilidade;
    }

    public Cargo getCargo() {
        return cargo;
    }

    public void setCargo(Cargo cargo) {
        this.cargo = cargo;
    }

    public Date getEffectiveStartDate() {
        return effectiveStartDate;
    }

    public void setEffectiveStartDate(Date effectiveStartDate) {
        this.effectiveStartDate = effectiveStartDate;
    }

    public Date getEffectiveEndDate() {
        return effectiveEndDate;
    }

    public void setEffectiveEndDate(Date effectiveEndDate) {
        this.effectiveEndDate = effectiveEndDate;
    }

    public int getDotacao() {
        return dotacao;
    }

    public void setDotacao(int dotacao) {
        this.dotacao = dotacao;
    }

    public int getBloqueio() {
        return bloqueio;
    }

    public void setBloqueio(int bloqueio) {
        this.bloqueio = bloqueio;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public int getLotacao() {
        return lotacao;
    }

    public void setLotacao(int lotacao) {
        this.lotacao = lotacao;
    }

    public Funcionario getCriadoPor() {
        return criadoPor;
    }

    public void setCriadoPor(Funcionario criadoPor) {
        this.criadoPor = criadoPor;
    }

    public Funcionario getAtualizadoPor() {
        return atualizadoPor;
    }

    public void setAtualizadoPor(Funcionario atualizadoPor) {
        this.atualizadoPor = atualizadoPor;
    }

}
