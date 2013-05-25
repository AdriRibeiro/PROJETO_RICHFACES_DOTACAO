/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package br.com.cobra.utilitarios;

import java.util.Locale;

/**
 *
 * @author horacio
 */
public class UtilitarioParametros {
    public static String getPadraoDaAplicacao(String campo) {
        // Trabalhar com o local da aplicaçao
        Locale local = null;
        java.util.ResourceBundle resourceConfig = java.util.ResourceBundle.getBundle("br/com/cobra/properties/PadraoDaAplicacao");
        return resourceConfig.getString(campo);
    }
    public static String getCamposDaAplicacao(String campo) {
        // Trabalhar com o local da aplicaçao
        Locale local = null;
        java.util.ResourceBundle resourceConfig = java.util.ResourceBundle.getBundle("br/com/cobra/properties/camposDaAplicacao");
        return resourceConfig.getString(campo);
    }
    public static String getConfiguracaoDaAplicacao(String campo) {
        // Trabalhar com o local da aplicaçao
        Locale local = null;
        java.util.ResourceBundle resourceConfig = java.util.ResourceBundle.getBundle("br/com/cobra/properties/configuracoesAplicacao");
        return resourceConfig.getString(campo);
    }

    public static String getMensagemDaAplicacao(String campo) {
        java.util.ResourceBundle resourceConfig = java.util.ResourceBundle.getBundle("br/com/cobra/properties/mensagemDaAplicacao");
        return resourceConfig.getString(campo);
    }
    public static String getErrosDaAplicacao(String campo) {
        java.util.ResourceBundle resourceConfig = java.util.ResourceBundle.getBundle("br/com/cobra/properties/ErrosDaAplicacao");
        return resourceConfig.getString(campo);
    }
}
