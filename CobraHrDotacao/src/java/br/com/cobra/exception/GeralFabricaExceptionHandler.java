package br.com.cobra.exception;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class GeralFabricaExceptionHandler extends ExceptionHandlerFactory {

    private ExceptionHandlerFactory parent;

    public GeralFabricaExceptionHandler(final ExceptionHandlerFactory parent) {
        this.parent = parent;
    }

    @Override
    public ExceptionHandler getExceptionHandler() {
        ExceptionHandler result = parent.getExceptionHandler();
        result = new GeralExceptionHandler(result);
        return result;
    }
}
