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

public class Funcionario implements Serializable {
    private BigDecimal      personId;
    private String          nome;

    public Funcionario(BigDecimal personId) {
        this.personId = personId;
    }

    public Funcionario(BigDecimal personId, String nome) {
        this.personId = personId;
        this.nome = nome;
    }

    public BigDecimal getPersonId() {
        return personId;
    }

    public void setPersonId(BigDecimal personId) {
        this.personId = personId;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
    
}
