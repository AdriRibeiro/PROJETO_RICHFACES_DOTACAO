/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

/**
 *
 * @author horacio.vasconcellos
 */
import br.com.cobra.dataaccess.DAOConfigurationException;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.DateFormats;
import jxl.write.DateTime;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableImage;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

/**
 *
 * @author horacio
 */
public class UtilitarioExcel {

    private static final String PROPERTY_URL = "BancoDeDadosPadraoConexao";
    private static final String PROPERTY_DRIVER = "BancoDeDadosPadraoDriver";
    private static final String PROPERTY_USERNAME = "BancoDeDadosPadraoUsuario";
    private static final String PROPERTY_PASSWORD = "BancoDeDadosPadraoSenha";
    private static final String PROPERTY_NOMEDAEMPRESA = "Aplicacao.NomeDaEmpresa";
    private static final String PROPERTY_LOGODAEMPRESA = "Aplicacao.LogoDaEmpresa";
    private static final String PROPERTY_NOMEPLANILHA = "Aplicacao.NomePlanilha";
    private static final String PROPERTY_DIRETORIO_UPLOAD = "Aplicacao.DiretorioUpLoad";
    private static final String PROPERTY_DIRETORIO_DOWNLOAD = "Aplicacao.DiretorioDownload";
    private static final String PROPERTY_DIRETORIO_TEMPORARIO = "Aplicacao.DiretorioTemporario";
    
    public static String createWorkbook(String query) throws SQLException, IOException, WriteException {
        String               url = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_URL);
        String   driverClassName = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_DRIVER);
        String          password = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_PASSWORD);
        String          username = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_USERNAME);
        String     nomeDaEmpresa = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_NOMEDAEMPRESA);
        String      nomePlanilha = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_NOMEPLANILHA);
        String diretorioTemporario = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_DIRETORIO_TEMPORARIO);
        String     nomedoarquivo = UtilitarioString.captchaString() + ".xls";
        String tempdir = System.getProperty("java.io.tmpdir");
        if ( !(tempdir.endsWith("/") || tempdir.endsWith("\\")) )
            tempdir = tempdir + System.getProperty("file.separator");
        String filename                 = tempdir +nomedoarquivo;
        String     logoDaEmpresa = FacesContext.getCurrentInstance().getExternalContext().getRealPath("/imagens/final/img_logo_cobra.png");
        DataSource    dataSource = null;
        Connection    connection = null;
        SimpleDateFormat     sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
        if (driverClassName != null) {
            try {
                Class.forName(driverClassName);
            } catch (ClassNotFoundException e) {
                throw new DAOConfigurationException("Classe do Driver '" + driverClassName + "' não localizada no  classpath.", e);
            }
        } else {
            try {
                dataSource = (DataSource) new InitialContext().lookup(url);
            } catch (NamingException e) {
                throw new DAOConfigurationException("Fonte de Dados'" + url + "' não lozalizada no JNDI.", e);
            }
        }
        connection = DriverManager.getConnection(url, username, password);
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(query);
        ResultSetMetaData resultMet = resultSet.getMetaData();
        int numcols = resultMet.getColumnCount();
        int numcolsmerge = numcols - 1;
        int tipo;
        int numlinha = 2;
        int tamColuna;
        String campo;
        int totalRegistros = 0;
        WorkbookSettings workSet = new WorkbookSettings();
        workSet.setLocale(new Locale("en", "EN"));
        WritableWorkbook workbook = Workbook.createWorkbook(new File(filename), workSet);
        WritableSheet writeSheet = workbook.createSheet(nomePlanilha, 0);
        workbook.setColourRGB(Colour.LIME, 0xff, 0, 0);
        WritableImage wi = new WritableImage(0, 0, 1, 1, new File(logoDaEmpresa));
        writeSheet.addImage(wi);
        WritableCellFormat wrappedText = new WritableCellFormat(WritableWorkbook.ARIAL_10_PT);
        wrappedText.setWrap(false);
        // Monatagem do cabecalho da planilha
        Label label = new Label(0, 0, nomeDaEmpresa, wrappedText);
        //writeSheet.mergeCells(1, 0, (numcolsmerge - 1), 0);
        writeSheet.addCell(label);
        Calendar calenda = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
        calenda.setTime(new Date());
        WritableCellFormat cf1 = new WritableCellFormat(DateFormats.FORMAT1);
        DateTime dt = new DateTime(numcols - 1, 1, calenda.getTime(), cf1, DateTime.GMT);
        writeSheet.addCell(dt);
        WritableCellFormat borderBlack = new WritableCellFormat();
        borderBlack.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
        borderBlack.setBackground(Colour.YELLOW);
        borderBlack.setWrap(true);
        for (int i = 1; i <= numcols; i++) {
            campo = resultMet.getColumnLabel(i);
            label = new Label(i - 1, 1, campo, borderBlack);
            tamColuna = resultMet.getPrecision(i) + resultMet.getScale(i);
            if (tamColuna < campo.length()) {
                tamColuna = campo.length();
            }
            writeSheet.setColumnView(i - 1, tamColuna);
            writeSheet.addCell(label);
        }

        while (resultSet.next()) {
            for (int i = 1; i <= numcols; i++) {
                tipo = resultMet.getColumnType(i);
                switch (tipo) {
                    case 93:
                        try {
                        campo = sdf.format(resultSet.getDate(i));
                        } catch (Exception e) {
                            campo = "";
                        }
                        break;
                    default:
                        campo = resultSet.getString(i);
                        break;
                }
                label = new Label(i - 1, numlinha, campo);
                writeSheet.addCell(label);
            }
            ++numlinha;
            ++totalRegistros;
        }
        campo = "Total de Registros exportados:  " + totalRegistros;
        label = new Label(0, ++numlinha, campo);
        writeSheet.addCell(label);
        workbook.write();
        workbook.close();
       return filename;
    }

    public static void main(String[] args) throws SQLException, IOException, WriteException {
      String filename = UtilitarioExcel.createWorkbook("SELECT FFVB.FLEX_VALUE_ID AS FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO, FFVB.START_DATE_ACTIVE AS DATA_DE_INICIO, FFVB.END_DATE_ACTIVE  AS DATA_DE_TERMINO, NVL(FFVB.ENABLED_FLAG,'Y')  AS HABILITADO  FROM FND_FLEX_VALUES_TL FFVT,FND_FLEX_VALUES    FFVB  WHERE FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450");
      System.out.println("O arquivo gerado foi " + filename);
     // UtilitarioFrameArquivo.downloadPDF(filename);
    }
}
