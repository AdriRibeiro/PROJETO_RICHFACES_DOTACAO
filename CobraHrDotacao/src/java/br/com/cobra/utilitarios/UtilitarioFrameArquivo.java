/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author horacio.vasconcellos
 */
public class UtilitarioFrameArquivo {

    private static final int DEFAULT_BUFFER_SIZE = 10240;

    public static void download(String filename) throws IOException {
        String extensao = null;
        BufferedInputStream input = null;
        BufferedOutputStream output = null;
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        HttpServletResponse response = (HttpServletResponse) externalContext.getResponse();
        File file = new File(filename);
        int locPonto = filename.lastIndexOf('.');
        if (locPonto > 0) {
            extensao = filename.substring(locPonto + 1);
        }
        try {
            String mimetype = "";
            String headertype = "";
            if (extensao.equalsIgnoreCase("xls")) {
                mimetype = "application/vnd.ms-excel";
                headertype = "vnd.ms-excel";
            } else {
                mimetype = "application/pdf";
                headertype = "inbound";
            }
            
            input = new BufferedInputStream(new FileInputStream(file), DEFAULT_BUFFER_SIZE);
            response.reset();
            response.setContentType(mimetype);
            response.setContentLength((int) file.getUsableSpace());
            response.setHeader("Content-disposition", headertype + "; filename=\"" + file.getName() + "\"");
            output = new BufferedOutputStream(response.getOutputStream(), DEFAULT_BUFFER_SIZE);
            byte[] buffer = new byte[DEFAULT_BUFFER_SIZE];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }
            output.flush();
        } finally {
            close(output);
            close(input);
        }
        facesContext.responseComplete();
    }

    private static void close(Closeable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
