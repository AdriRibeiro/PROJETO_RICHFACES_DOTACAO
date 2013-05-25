package br.com.cobra.validacao;


import br.com.cobra.utilitarios.UtilitarioParametros;
import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.component.UIInput;
import javax.faces.context.FacesContext;
import javax.faces.validator.Validator;
import javax.faces.validator.ValidatorException;

/**
 *
 * @author horacio.vasconcellos
 */
public class ValidaQuantidade implements Validator {

    @Override
    public void validate(FacesContext fc, UIComponent uic, Object o) throws ValidatorException {
         if (null == o || 0 == o.toString().length()) {
            return;
         }
         Integer qtdaDotacao;
         Integer qtdaBloqueio;
         
         String validacaoDados = (String) uic.getAttributes().get("validacaoQuantidades");
         UIInput dataInput     = (UIInput) fc.getViewRoot().findComponent(validacaoDados);
         if ( uic.getClientId().equalsIgnoreCase("formDotacao:inpDotacao")) {
             qtdaDotacao = (Integer) o;
             qtdaBloqueio= (Integer) dataInput.getValue();
         } else {
             qtdaBloqueio = (Integer) o;
             qtdaDotacao  = (Integer) dataInput.getValue();
         }
         if (qtdaBloqueio == null || qtdaDotacao == null) {
             return;
         }
         if (qtdaDotacao.compareTo(new Integer(1)) < 0) {
           FacesMessage message = new FacesMessage(UtilitarioParametros.getCamposDaAplicacao("APP-HR-003"));
           message.setSeverity(FacesMessage.SEVERITY_ERROR);
           throw new ValidatorException(message);
         }
         if (qtdaBloqueio.compareTo(new Integer(0)) < 0) {
           FacesMessage message = new FacesMessage(UtilitarioParametros.getCamposDaAplicacao("APP-HR-004"));
           message.setSeverity(FacesMessage.SEVERITY_ERROR);
           throw new ValidatorException(message);
         }         
         if (qtdaDotacao.compareTo(qtdaBloqueio) < 0 ) {
           FacesMessage message = new FacesMessage(UtilitarioParametros.getCamposDaAplicacao("APP-HR-002"));
           message.setSeverity(FacesMessage.SEVERITY_ERROR);
           throw new ValidatorException(message);
         }
    }
    
}
