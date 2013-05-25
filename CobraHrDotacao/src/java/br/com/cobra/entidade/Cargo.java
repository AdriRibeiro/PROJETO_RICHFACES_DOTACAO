/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.entidade;

import java.io.Serializable;


/**
 *
 * @author horacio.vasconcellos
 */

public class Cargo implements Serializable {
    private String   codigo;
    private String   descricao;

    public Cargo() {
         this.codigo = null;
        this.descricao = null;
    }

    public Cargo(String codigo, String descricao) {
        this.codigo = codigo;
        this.descricao = descricao;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    
}