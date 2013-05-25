/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.entidade;


import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;


/**
 *
 * @author horacio.vasconcellos
 */

public class Login  implements Serializable {
    private String      logon;
    private String      password;
    private BigDecimal  cond;
    private Date        hora;
    private String      tipo;
    private BigDecimal  person_id;
    private String      dn;
    private boolean     logado;

    public Login() {
         this.logon = "";
         this.password = "";
         this.cond = new BigDecimal("6");
         this.logado = false;
    }


    public boolean isLogado() {
        return logado;
    }

    public void setLogado(boolean logado) {
        this.logado = logado;
    }

    public Login(String logon, String password) {
        this.logon = logon;
        this.password = password;
        this.logado = false;
    }

    public Login(String logon, String password, BigDecimal person_id) {
        this.logon = logon;
        this.password = password;
        this.person_id = person_id;
        this.logado = false;
    }

    public Login(String logon, String password, BigDecimal cond, BigDecimal person_id) {
        this.logon = logon;
        this.password = password;
        this.cond = cond;
        this.person_id = person_id;
    }
    
    

    public String getLogon() {
        return logon;
    }

    public void setLogon(String logon) {
        this.logon = logon;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public BigDecimal getCond() {
        return cond;
    }

    public void setCond(BigDecimal cond) {
        this.cond = cond;
    }

    public Date getHora() {
        return hora;
    }

    public void setHora(Date hora) {
        this.hora = hora;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public BigDecimal getPerson_id() {
        return person_id;
    }

    public void setPerson_id(BigDecimal person_id) {
        this.person_id = person_id;
    }

    public String getDn() {
        return dn;
    }

    public void setDn(String dn) {
        this.dn = dn;
    }

}
