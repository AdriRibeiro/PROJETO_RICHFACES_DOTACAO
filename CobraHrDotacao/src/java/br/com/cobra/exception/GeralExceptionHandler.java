package br.com.cobra.exception;

import java.util.Iterator;
import java.util.logging.Logger;
import javax.faces.FacesException;
import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerWrapper;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ExceptionQueuedEvent;
import javax.faces.event.ExceptionQueuedEventContext;
import javax.servlet.http.HttpServletRequest;

public class GeralExceptionHandler extends ExceptionHandlerWrapper {

    private ExceptionHandler parent;
    private static final Logger LOG = Logger.getLogger(GeralExceptionHandler.class.getName());

    public GeralExceptionHandler(final ExceptionHandler parent) {
        this.parent = parent;
    }

    @Override
    public ExceptionHandler getWrapped() {
        return parent;
    }

    @Override
    public void handle() throws FacesException {
        for (Iterator<ExceptionQueuedEvent> i = getUnhandledExceptionQueuedEvents().iterator(); i.hasNext();) {
            ExceptionQueuedEvent event = i.next();
            ExceptionQueuedEventContext eqec = (ExceptionQueuedEventContext) event.getSource();
            Throwable throwable = eqec.getException();

            if (throwable instanceof FacesException) {
                FacesContext fc = FacesContext.getCurrentInstance();
                ExternalContext ec = fc.getExternalContext();
                HttpServletRequest request = (HttpServletRequest) ec.getRequest();
                String originalRequestURI = request.getRequestURI();
                String encodedURL = ec.encodeRedirectURL(originalRequestURI, null);
                ec.getSessionMap().put("br.com.cobra.exception.GeralExceptionHandler.URL", encodedURL);
            }
        }
        parent.handle();
    }
}