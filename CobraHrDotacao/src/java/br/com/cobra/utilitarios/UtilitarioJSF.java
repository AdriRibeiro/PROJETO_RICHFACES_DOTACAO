/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.Map;
import java.util.Iterator;
import java.util.ResourceBundle;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.component.*;
import javax.faces.context.ExternalContext;
import org.apache.taglibs.standard.lang.jstl.Constants;

/**
 *
 * @author horacio
 */
public class UtilitarioJSF {
        private static ResourceBundle messageBundle = ResourceBundle.getBundle(FacesContext.getCurrentInstance().getApplication().getMessageBundle());
        public static String getRequestParameter(String name) {
        String        parameter = null;
        Map requestParameterMap = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
        if (requestParameterMap != null) {
            parameter = (String) requestParameterMap.get(name);
        }
        return parameter;
    }
    public static String getContextPath() {
        String contextPath = "";
        contextPath = FacesContext.getCurrentInstance().getExternalContext().getRequestContextPath();
        return contextPath;
    }

    public static boolean isAnonymous() {
        boolean anonymous = true;
        String remoteUser = FacesContext.getCurrentInstance().getExternalContext().getRemoteUser();
        if (remoteUser != null && remoteUser.trim().length() > 0) {
            anonymous = false;
        }
        return anonymous;
    }

    public static String getComponentValue(String componentId) {
        String value = null;
        UIViewRoot root = FacesContext.getCurrentInstance().getViewRoot();
        UIComponent component = root.findComponent(componentId);
        if (component != null) {
            Object o = component.getValueBinding("value").getValue(FacesContext.getCurrentInstance());
            value = (String) o;
        }
        return value;
    }

    public static void removeComponent(String componentId) {
        UIViewRoot root = FacesContext.getCurrentInstance().getViewRoot();
        UIComponent component = root.findComponent(componentId);
        if (component != null) {
            UIComponent parent = component.getParent();
            parent.getChildren().remove(component);
        }
    }

    public static String handleException(Exception e) {
        String genericNavState = Constants.ERROR_GETTING_PROPERTY;
        String msg = e.toString();
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg, msg);
        FacesContext.getCurrentInstance().addMessage(Constants.ERROR_GETTING_PROPERTY, message);
        return genericNavState;
    }

    public static String getErrorMsg() {
        String errorMsg = null;
        Iterator msgs = FacesContext.getCurrentInstance().getMessages(Constants.ERROR_GETTING_PROPERTY);
        if (msgs != null) {
            if (msgs.hasNext()) {
                FacesMessage message = (FacesMessage) msgs.next();
                errorMsg = message.getDetail();
            }
        }
        return errorMsg;
    }

    public static boolean isErrorOccurred() {
        boolean errorOccurred = false;
        Iterator msgs = FacesContext.getCurrentInstance().getMessages(Constants.ERROR_GETTING_PROPERTY);
        if (msgs != null && msgs.hasNext()) {
            errorOccurred = true;
        }
        return errorOccurred;
    }

    public static void setMessage(String id, String msg) {
        
        String mensagem = getMessageId(msg);
        //FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg, msg);
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, mensagem, mensagem);
        FacesContext.getCurrentInstance().addMessage(id, message);
    }

    public static String getMessage(String id) {
        String msg = null;
        Iterator msgs = FacesContext.getCurrentInstance().getMessages(id);
        if (msgs != null) {
            if (msgs.hasNext()) {
                FacesMessage message = (FacesMessage) msgs.next();
                System.out.println("As mensagens sao: " + message.getDetail());
                msg = message.getDetail();
            }
        }
        return msg;
    }
    public static String getMessageId(String messageId, Object... params) {
        return MessageFormat.format(messageBundle.getString(messageId), params);
    }
    public static String getMessageId(String messageId) {
        Object o = new Object();
        System.out.println("A mensagem solicitada foi " + messageId);
        return MessageFormat.format(messageBundle.getString(messageId), o);
    }

    public static String getBundleMessage(String bundleName, String messageKey) {
        String bundleMessage = null;
        FacesContext ctx = FacesContext.getCurrentInstance();
        UIViewRoot uiRoot = ctx.getViewRoot();
        Locale locale = uiRoot.getLocale();
        ClassLoader ldr = Thread.currentThread().getContextClassLoader();
        ResourceBundle bundle = ResourceBundle.getBundle(bundleName, locale, ldr);
        System.out.println("Bundle message " + bundleName + " == " + locale + " ---- " + ldr);
        bundleMessage = bundle.getString(messageKey);
        return bundleMessage;
    }

    public static Locale getSelectedLocale() {
        return FacesContext.getCurrentInstance().getExternalContext().getRequestLocale();
    }

    public static Locale getDefaultLocale() {
        return FacesContext.getCurrentInstance().getApplication().getDefaultLocale();
    }

    public static Iterator getSupportedLocales() {
        return FacesContext.getCurrentInstance().getApplication().getSupportedLocales();
    }
    public static Object getLookupManagedBeanName(String bean) {
        Object retorno = null;
        // Era getLookupManagedBeanName(Object bean)
        ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
        Map<String, Object> sessionMap = externalContext.getSessionMap();
        for (String key : sessionMap.keySet()) {
            if (key.equals(bean)) {
            //if (bean.equals(sessionMap.get(key))) {
                retorno = sessionMap.get(key);
                return retorno;
            }
        }
        Map<String, Object> applicationMap = externalContext.getApplicationMap();
        for (String key : applicationMap.keySet()) {
            if (key.equals(bean)) {
            //if (bean.equals(applicationMap.get(key))) {
                retorno = sessionMap.get(key);
                continue;
            }
        }
        return retorno;
    }
    public static boolean setLookupManagedBeanName(String bean, Object value) {
        // Era getLookupManagedBeanName(Object bean)
        ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
        Map<String, Object> sessionMap = externalContext.getSessionMap();
        for (String key : sessionMap.keySet()) {
            if (key.equals(bean)) {
            //if (bean.equals(sessionMap.get(key))) {
                sessionMap.put(bean, value);
                return true;
            }
        }
        Map<String, Object> applicationMap = externalContext.getApplicationMap();
        for (String key : applicationMap.keySet()) {
            if (key.equals(bean)) {
            //if (bean.equals(applicationMap.get(key))) {
                sessionMap.put(bean, value);
                return true;
            }
        }
        return false;
    }

}