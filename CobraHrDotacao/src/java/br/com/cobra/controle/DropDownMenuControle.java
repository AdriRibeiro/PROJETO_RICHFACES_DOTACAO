package br.com.cobra.controle;

import java.io.Serializable;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpSession;

public class DropDownMenuControle implements Serializable {
    private String opcao;
    public String getOpcao() {
        return this.opcao;
    }
    public String doSubCr() {
        this.opcao = "mostrarCentroResponsabilidade";
        return opcao;
    }

    public String doDotacao() {
        this.opcao = "mostrarDotacao";
        return opcao;
    }

    public String doCargo() {
        this.opcao = "mostrarCargo";
        return opcao;
    }

    public String doExit() {
        HttpSession sessao = (HttpSession) FacesContext.getCurrentInstance().getExternalContext().getSession(true);
        sessao.invalidate();
        this.opcao = "retornarLogin";
        return opcao;
    }
    public String doDotacaoHierarquica() {
        this.opcao = "mostrarDotacaoHierarquica";
        return opcao;
    }
    
}