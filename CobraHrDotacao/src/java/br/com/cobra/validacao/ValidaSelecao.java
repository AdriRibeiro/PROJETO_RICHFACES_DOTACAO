/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.validacao;

import java.math.BigDecimal;
import javax.faces.component.UIComponent;
import javax.faces.component.UIInput;
import javax.faces.context.FacesContext;
import javax.faces.validator.Validator;
import javax.faces.validator.ValidatorException;

/**
 *
 * @author horacio.vasconcellos
 */
public class ValidaSelecao implements Validator{

    @Override
    public void validate(FacesContext fc, UIComponent uic, Object o) throws ValidatorException {
         BigDecimal bigScr;
         String     stCargo;
         if (null == o) {
            return;
         }
         String validacaoDados = (String) uic.getAttributes().get("validaSelect");
         UIInput dataInput     = (UIInput) fc.getViewRoot().findComponent(validacaoDados);
         if ( uic.getClientId().equalsIgnoreCase("formDotacao:selSubcr")) {
             bigScr   = (BigDecimal) o;
             stCargo  = (String) dataInput.getValue();
         } else {
             stCargo  = (String) o;
             bigScr  =  (BigDecimal) dataInput.getValue();
             
         }
         if (stCargo == null || bigScr == null) {
             return;
         }
         System.out.println("Valor recebido foi " + stCargo + " e " + bigScr);
         
    }
    
}
