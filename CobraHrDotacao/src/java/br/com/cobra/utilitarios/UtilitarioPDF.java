/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

import java.io.StringReader;
import java.util.Iterator;
import java.net.URL;

import org.pdfbox.pdmodel.encryption.AccessPermission;
import org.pdfbox.pdmodel.encryption.StandardDecryptionMaterial;
import com.lowagie.text.Document;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfImportedPage;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfWriter;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;

import org.pdfbox.pdmodel.PDDocument;
import org.pdfbox.util.PDFTextStripper;

import com.lowagie.text.BadElementException;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.context.FacesContext;
import javax.sql.DataSource;

/**
 *
 * @author horacio
 */
public class UtilitarioPDF {

    private static final String PROPERTY_TITULO = "Aplicacao.titulo";
    private static final String PROPERTY_NOMEDAEMPRESA = "Aplicacao.NomeDaEmpresa";
    private static final String PROPERTY_LOGODAEMPRESA = "Aplicacao.LogoDaEmpresa";
    private static final String PROPERTY_AUTOR = "Aplicacao.Autor";
    private static final String PROPERTY_DIRETORIOTEMP = "Aplicacao.DiretorioTemporario";
    private static final String PROPERTY_TAM_MAX_STRING = "Aplicacao.TamanhoMaximoString";
    private static final String PROPERTY_URL = "BancoDeDadosPadraoConexao";
    private static final String PROPERTY_DRIVER = "BancoDeDadosPadraoDriver";
    private static final String PROPERTY_USERNAME = "BancoDeDadosPadraoUsuario";
    private static final String PROPERTY_PASSWORD = "BancoDeDadosPadraoSenha";
    private Document documento;
    private PdfPTable datatable;
    private String titulo;
    private String nomeDaEmpresa;
    private String logoDaEmpresa;
    private String autor;
    private DataSource dataSource;
    private Connection connection;
    private Statement statement;
    private ResultSet resultSet;
    private ResultSetMetaData resultMet;
    private Font fonte;

    public String createPDF(String nomeRelatorio, String query) {
        documento = new Document(PageSize.A4.rotate());
        titulo = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_TITULO);
        nomeDaEmpresa = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_NOMEDAEMPRESA);
        
        autor = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_AUTOR);
        String nomedoarquivo = UtilitarioString.captchaString() + ".pdf";
        //String retorno = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_DIRETORIOTEMP) + "#" + nomedoarquivo;
        String retorno = nomedoarquivo;
        logoDaEmpresa = FacesContext.getCurrentInstance().getExternalContext().getRealPath("/imagens/final/img_logo_cobra.png");
        //String filename = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_DIRETORIOTEMP) + "/" + nomedoarquivo;
        String          filename =  FacesContext.getCurrentInstance().getExternalContext().getRealPath("/resources/temporario/" + nomedoarquivo);
        String tempdir = System.getProperty("java.io.tmpdir");
        if ( !(tempdir.endsWith("/") || tempdir.endsWith("\\")) )
            tempdir = tempdir + System.getProperty("file.separator");
        filename                 = tempdir +nomedoarquivo;
        String url = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_URL);
        String driverClassName = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_DRIVER);
        String password = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_PASSWORD);
        String username = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_USERNAME);
        fonte = new Font(Font.COURIER, 10, Font.TIMES_ROMAN);
        fonte.setColor(new Color(0xFF, 0xFF, 0xFF));

        try {
            connection = DriverManager.getConnection(url, username, password);
            statement = connection.createStatement();
            resultSet = statement.executeQuery(query);
            resultMet = resultSet.getMetaData();
            int numcols = resultMet.getColumnCount();
            datatable = new PdfPTable(numcols);
            PdfWriter.getInstance(documento, new FileOutputStream(filename));
            documento.open();
            addMetadados();
            addCabecalho(nomeRelatorio, numcols);
            addRodape(numcols);
            addDados(numcols);
            datatable.setSplitLate(false);
            documento.add(datatable);
            documento.close();
        } catch (SQLException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DocumentException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (FileNotFoundException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        }
        return filename;
    }

    private void addMetadados() {
        documento.addTitle(titulo);
        documento.addKeywords("Metadata");
        documento.addCreator("BBTEcnologia e Serviço");
        documento.addAuthor(autor);
        documento.addHeader("Expires", "0");
    }

    private void addCabecalho(String nomeRelatorio, int numcols) {
        String strtamMaxColuna = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_TAM_MAX_STRING);
        int tamMaxColuna = 50;
        int tamColuna;
        String campo;
        String dataFormato = "dd/MM/yyyy hh:mm:ss";
        SimpleDateFormat sdf = new SimpleDateFormat(dataFormato);
        try {
            float headerwidths[] = new float[numcols];
            datatable.setWidthPercentage(100);
            datatable.getDefaultCell().setPadding(2);
            Image imglogo = Image.getInstance(logoDaEmpresa);
            imglogo.scalePercent(5);
            PdfPTable cabEmpresa = new PdfPTable(3);
            int cabEmpresawidths[] = {10, 63, 17};
            cabEmpresa.setWidths(cabEmpresawidths);
            cabEmpresa.getDefaultCell().setBorderWidth(2);
            cabEmpresa.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
            cabEmpresa.getDefaultCell().setColspan(1);
            cabEmpresa.addCell(imglogo);
            cabEmpresa.addCell(nomeDaEmpresa + "\n" + titulo);
            cabEmpresa.addCell(sdf.format(new Date()));
            PdfPCell celCabEmpresa = new PdfPCell(cabEmpresa);
            celCabEmpresa.setColspan(numcols);
            datatable.addCell(celCabEmpresa);
            PdfPCell cell = new PdfPCell(new Phrase(nomeRelatorio, FontFactory.getFont(FontFactory.HELVETICA, 24, Font.BOLD)));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setBorderWidth(2);
            cell.setColspan(numcols);
            cell.setBackgroundColor(new Color(0xC0, 0xC0, 0xC0));
            cell.setUseDescender(true);
            datatable.addCell(cell);
            datatable.getDefaultCell().setBorderWidth(2);
            datatable.getDefaultCell().setHorizontalAlignment(Element.ALIGN_CENTER);
            for (int i = 1; i <= numcols; i++) {
                campo = resultMet.getColumnLabel(i);
                tamColuna = resultMet.getPrecision(i) + resultMet.getScale(i);
                if (tamColuna < campo.length()) {
                    tamColuna = campo.length();
                } else {
                    if (tamColuna > tamMaxColuna) {
                        tamColuna = tamMaxColuna;
                    }
                }
                headerwidths[i - 1] = new Float(tamColuna);
                datatable.addCell(campo);
            }
            datatable.setWidths(headerwidths);
            datatable.setHeaderRows(4);
        } catch (SQLException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (BadElementException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MalformedURLException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DocumentException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void addDados(int numcols) {
        String dataFormato = "dd/MM/yyyy";
        SimpleDateFormat sdf = new SimpleDateFormat(dataFormato);
        String campo;
        int tipo;
        datatable.getDefaultCell().setBorderWidth(1);
        try {
            while (resultSet.next()) {
                for (int i = 1; i <= numcols; i++) {
                    tipo = resultMet.getColumnType(i);
                    switch (tipo) {
                        case 93:
                            campo = sdf.format(resultSet.getDate(i));
                            break;
                        default:
                            campo = resultSet.getString(i);
                            break;
                    }
                    datatable.getDefaultCell().setHorizontalAlignment(Element.ALIGN_LEFT);
                    datatable.addCell(campo);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UtilitarioPDF.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void addRodape(int numcols) {

        PdfPCell empty = new PdfPCell();
        empty.setColspan(numcols);
        datatable.addCell(empty);
        datatable.setFooterRows(1);
    }
    public static void PDFtoRTF(String arquivoOriginal, String arquivoDestino) throws IOException, Exception {
        FileOutputStream stream2 = new FileOutputStream(arquivoDestino);
        String           retorno = PDFparaTexto(arquivoOriginal, -1, -1);
        StringReader     reader1 = new StringReader(retorno);
        int t;
        while ((t = reader1.read()) > 0) {
            stream2.write(t);
        }
        stream2.close();
    }

    public static void concatPDF(List<FileInputStream> streamOfPDFFiles, FileOutputStream outputStream, boolean paginate) {
        Document document = new Document();
        try {
            List<FileInputStream> pdfs = streamOfPDFFiles;
            List<PdfReader> readers = new ArrayList<PdfReader>();
            int totalPages = 0;
            Iterator<FileInputStream> iteratorPDFs = pdfs.iterator();
            while (iteratorPDFs.hasNext()) {
                FileInputStream pdf = iteratorPDFs.next();
                PdfReader pdfReader = new PdfReader(pdf);
                readers.add(pdfReader);
                totalPages += pdfReader.getNumberOfPages();
            }
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);
            document.open();
            BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            PdfContentByte cb = writer.getDirectContent();
            PdfImportedPage page;
            int currentPageNumber = 0;
            int pageOfCurrentReaderPDF = 0;
            Iterator<PdfReader> iteratorPDFReader = readers.iterator();
            while (iteratorPDFReader.hasNext()) {
                PdfReader pdfReader = iteratorPDFReader.next();
                while (pageOfCurrentReaderPDF < pdfReader.getNumberOfPages()) {
                    document.newPage();
                    pageOfCurrentReaderPDF++;
                    currentPageNumber++;
                    page = writer.getImportedPage(pdfReader, pageOfCurrentReaderPDF);
                    cb.addTemplate(page, 0, 0);
                    if (paginate) {
                        cb.beginText();
                        cb.setFontAndSize(bf, 9);
                        //cb.showTextAligned(PdfContentByte.ALIGN_CENTER, "" + currentPageNumber + " até " + totalPages, 520,5, 0);
                        cb.endText();
                    }
                }
                pageOfCurrentReaderPDF = 0;
            }
            outputStream.flush();
            document.close();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (document.isOpen()) {
                document.close();
            }
            try {
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
        }
    }

    public static void splitPDF(FileInputStream inputStream, FileOutputStream outputStream, int fromPage, int toPage) {
        Document document = new Document();
        try {
            PdfReader inputPDF = new PdfReader(inputStream);
            int totalPages = inputPDF.getNumberOfPages();
            if (fromPage > toPage) {
                fromPage = toPage;
            }
            if (toPage > totalPages) {
                toPage = totalPages;
            }
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);
            document.open();
            PdfContentByte cb = writer.getDirectContent();
            PdfImportedPage page;
            while (fromPage <= toPage) {
                document.newPage();
                page = writer.getImportedPage(inputPDF, fromPage);
                cb.addTemplate(page, 0, 0);
                fromPage++;
            }
            outputStream.flush();
            document.close();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (document.isOpen()) {
                document.close();
            }
            try {
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
        }
    }

    public static String PDFparaTexto(String nomeArquivo, int inicio, int termino) throws Exception {
        String retorno;
        String password = "";
        String pdfFile = nomeArquivo;
        int paginaInicial = inicio;
        int paginaTermino = termino;
        if (inicio < 1) {
            paginaInicial = 1;
        }
        if (paginaTermino < paginaInicial || paginaTermino > Integer.MAX_VALUE) {
            paginaTermino = Integer.MAX_VALUE;
        }
        PDDocument document = null;
        try {
            try {
                URL url = new URL(pdfFile);
                document = PDDocument.load(url);
            } catch (MalformedURLException e) {
                document = PDDocument.load(pdfFile);
            }
            if (document.isEncrypted()) {
                StandardDecryptionMaterial sdm = new StandardDecryptionMaterial(password);
                document.openProtection(sdm);
                AccessPermission ap = document.getCurrentAccessPermission();
                if (!ap.canExtractContent()) {
                    throw new IOException("Criptografia no arquivo");
                }
            }
            PDFTextStripper stripper = null;
            stripper = new PDFTextStripper();
            stripper.setSortByPosition(false);
            stripper.setStartPage(paginaInicial);
            stripper.setEndPage(paginaTermino);
            retorno = stripper.getText(document);
        } finally {
            if (document != null) {
                document.close();
            }
        }
        return retorno;
    }

    public static void main(String[] args) {
        String nomeDoRelatorio = "Relatorio Teste";
        String sqlString = "SELECT * FROM TAB";
        UtilitarioPDF pdfteste = new UtilitarioPDF();
        pdfteste.createPDF(nomeDoRelatorio, sqlString);
    }

}
