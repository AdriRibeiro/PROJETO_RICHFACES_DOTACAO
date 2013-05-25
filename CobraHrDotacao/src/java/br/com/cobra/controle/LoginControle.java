/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.controle;

import br.com.cobra.dataaccess.DAOException;
import br.com.cobra.dataaccess.DAOFactory;
import br.com.cobra.dataaccess.LoginDAO;
import br.com.cobra.entidade.Login;
import br.com.cobra.utilitarios.UtilitarioParametros;
import java.io.IOException;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpSession;

/**
 *
 * @author horacio.vasconcellos
 */
public class LoginControle implements Serializable {

    private Login login;
    public static final LoginDAO loginDAO;

    static {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        String databaseName = facesContext.getExternalContext().getInitParameter("database.name");
        loginDAO = DAOFactory.getInstance(databaseName).getLoginDAO();
    }

    public LoginControle() {
        this.login = new Login();
        
    }

    
    public LoginControle(Login login) {
        this.login = login;
    }

    public Login getLogin() {
        return login;
    }

    public void setLogin(Login login) {
        this.login = login;
    }

    public String validacao() {
        FacesMessage mensagem = null;
        String retorno = "";
       try {
           login = loginDAO.procurar(login.getLogon(), login.getPassword());
           
        } catch (DAOException ex) {
            //Logger.getLogger(LoginControle.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            // Logger.getLogger(LoginControle.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (login.getCond().compareTo(BigDecimal.ZERO) == 0) {
            this.login.setLogado(true);
            retorno = "sucessoLogin";
        } else {
            this.login.setLogado(false);
            this.login.setLogon("");
            mensagem = new FacesMessage(UtilitarioParametros.getCamposDaAplicacao("APP-LG-001"));
            mensagem.setSeverity(FacesMessage.SEVERITY_ERROR);
            FacesContext.getCurrentInstance().addMessage(null,mensagem);
        }
        return retorno;
    }

    public String loginUsuario() {
        this.login = new Login();
        return "efetuarLogin";
    }
  public String logout() {
      HttpSession sessao = (HttpSession) FacesContext.getCurrentInstance().getExternalContext().getSession(true);
      sessao.invalidate();
      return "/formulario/formLogin.xhtml";
    }    
    public String navegacao() throws IOException {
        String redirectURL = (String) FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("br.com.cobra.exception.GeralExceptionHandler.URL");
        FacesContext.getCurrentInstance().getExternalContext().redirect(redirectURL);
        return null;
    }
  
}
