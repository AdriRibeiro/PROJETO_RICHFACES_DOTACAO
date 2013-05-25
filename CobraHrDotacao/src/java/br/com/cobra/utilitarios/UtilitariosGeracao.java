/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

import java.io.IOException;
import java.sql.SQLException;
import jxl.write.WriteException;

/**
 *
 * @author horacio.vasconcellos
 */
public class UtilitariosGeracao {

    public static void GeracaoemExcel(String sql_list, String classe) throws SQLException, WriteException, IOException {
        String filename = UtilitarioExcel.createWorkbook(sql_list);
        UtilitarioFrameArquivo.download(filename);
    }

    public static void GeracaoemPDF(String sql_list, String classe) {
        try {
            UtilitarioPDF pdfteste = new UtilitarioPDF();
            String filename = pdfteste.createPDF(classe, sql_list);
            UtilitarioFrameArquivo.download(filename);
        } catch (IOException ex) {
        }
    }
}
