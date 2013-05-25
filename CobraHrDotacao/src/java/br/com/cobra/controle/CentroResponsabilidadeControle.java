/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.controle;

import br.com.cobra.dataaccess.CentroResponsabilidadeDAO;
import br.com.cobra.dataaccess.DAOFactory;
import br.com.cobra.entidade.CentroResponsabilidade;
import br.com.cobra.entidade.Hierarquia;
import br.com.cobra.utilitarios.UtilitariosGeracao;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import javax.faces.context.FacesContext;
import javax.faces.model.DataModel;
import javax.faces.model.ListDataModel;
import jxl.write.WriteException;

/**
 *
 * @author horacio.vasconcellos
 */

public class CentroResponsabilidadeControle implements Serializable {
    private CentroResponsabilidade centroResponsabilidade;
    private Hierarquia            hierarquia;
    private DataModel model;
    private String filtroSubcr;
    private String filtroDesc;
    public static final CentroResponsabilidadeDAO centroResponsabilidadeDAO;
    static {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        DAOFactory javabase = DAOFactory.getInstance("javabase");
        centroResponsabilidadeDAO = javabase.getCentroResponsabilidadeDAO();
    }
    public CentroResponsabilidade getCentroResponsabilidade() {
        return centroResponsabilidade;
    }
    public void setCentroResponsabilidade(CentroResponsabilidade centroResponsabilidade) {
        this.centroResponsabilidade = centroResponsabilidade;
    }
    public DataModel getModel() {
        return model;
    }
    public void setModel(DataModel model) {
        this.model = model;
    }
    public DataModel getTodos() throws Exception {
        model = new ListDataModel(centroResponsabilidadeDAO.listaDescricao());
        return model;
    }
    public DataModel getTodosHierarquia() throws Exception {
        model = new ListDataModel(centroResponsabilidadeDAO.listaHierarquia());
        return model;
    }    
    public CentroResponsabilidade getCentroResponsabilidadeFromEditOrDelete() {
        centroResponsabilidade = (CentroResponsabilidade) model.getRowData();
        return centroResponsabilidade;
    }

    public String getFiltroSubcr() {
        return filtroSubcr;
    }

    public void setFiltroSubcr(String filtroSubcr) {
        this.filtroSubcr = filtroSubcr;
    }
    
     public String getFiltroDesc() {
        return filtroDesc;
    }

    public void setFiltroDesc(String filtroDesc) {
        this.filtroDesc = filtroDesc;
    }
    
    public String editar() {
        centroResponsabilidade = getCentroResponsabilidadeFromEditOrDelete();
        setCentroResponsabilidade(centroResponsabilidade);
        return "editarCentroResponsabilidade";
    }
 
    public String excluir() throws Exception {
        centroResponsabilidade = getCentroResponsabilidadeFromEditOrDelete();
        return "sucessoCentroResponsabilidade";
    }
   public String novoCentroResponsabilidade() {
        this.centroResponsabilidade = new CentroResponsabilidade();
        return "novoCentroResponsabilidade";
    }
 
    public String salvar() throws Exception {
        return "sucessoCentroResponsabilidade";
    }
    
    public String cancelarCentroResponsabilidade() {
        return "mostrarCentroResponsabilidade";
    }
    public String cancelarHierarquia() {
        return "mostrarHirarquia";
    }
    
    public String retornarCentroResponsabilidade() {
        return "retornarCentroResponsabilidade";
    }
    public String retornarHierarquia() {
        return "retornarHierarquia";
    }
    public String excelHierarquia() throws SQLException, WriteException, IOException {    
        String sql_list = "SELECT * FROM COBRA_HIERARQUIA_DOTACAO_QTD";
        UtilitariosGeracao.GeracaoemExcel(sql_list, "Hierarquia");
        return "excelHierarquia";        
    }
    public String excelCentroResponsabilidade() throws SQLException, WriteException, IOException {
        String sql_list = "SELECT LPAD (' ',LEVEL*5-5) || ch.flex_value  scr,  \n" +
"       ch.attribute3                          Sigla,\n" +
"       ch.description                         Descricao,\n" +
"       ch.attribute2                          Conta\n" +
"  FROM ( SELECT FFV.flex_value,  FFVT.description   , FFV.attribute1, FFV.attribute2, ffv.flex_value_id, ffv.attribute6, ffv.attribute3\n" +
"           -- , SYS_CONNECT_BY_PATH(FFVT.description, '/') \"Caminho\"\n" +
"       FROM APPS.FND_FLEX_VALUES      FFV,\n" +
"            APPS.FND_FLEX_VALUES_TL   FFVT\n" +
"       WHERE 1=1\n" +
"       AND FLEX_VALUE_SET_ID   = 1003450\n" +
"       AND FFV.flex_value_id   = FFVT.flex_value_id\n" +
"       AND FFVT.language       = 'PTB'\n" +
"       AND FFV.ENABLED_FLAG    = 'Y'\n" +
"       AND SYSDATE BETWEEN NVL(START_DATE_ACTIVE,SYSDATE-1) AND NVL(END_DATE_ACTIVE,TO_DATE('31/12/4712','DD/MM/YYYY'))\n" +
"       GROUP BY FFV.flex_value,  FFVT.description   , FFV.attribute1, FFV.attribute2, ffv.flex_value_id, ffv.attribute6,ffv.attribute3\n" +
"     )ch     \n" +
"CONNECT BY NOCYCLE PRIOR ch.flex_value_id = ch.attribute6\n" +
"START WITH  ch.attribute6 is not null and ch.attribute6 = '35620'";
        UtilitariosGeracao.GeracaoemExcel(sql_list, "CentrodeResponsabilidade");
        return "excelCentroResponsabilidade";
    }
    public String adobeHierarquia(){    
        String sql_list = "SELECT * FROM COBRA_HIERARQUIA_DOTACAO_QTD";
        UtilitariosGeracao.GeracaoemPDF(sql_list, "Hierarquia");
       return "adobeHierarquia";
    }    
    public String adobeCentroResponsabilidade() {
        String sql_list = "SELECT LPAD (' ',LEVEL*5-5) || ch.flex_value  scr,  \n" +
"       ch.attribute3                          Sigla,\n" +
"       ch.description                         Descricao,\n" +
"       ch.attribute2                          Conta\n" +
"  FROM ( SELECT FFV.flex_value,  FFVT.description   , FFV.attribute1, FFV.attribute2, ffv.flex_value_id, ffv.attribute6, ffv.attribute3\n" +
"           -- , SYS_CONNECT_BY_PATH(FFVT.description, '/') \"Caminho\"\n" +
"       FROM APPS.FND_FLEX_VALUES      FFV,\n" +
"            APPS.FND_FLEX_VALUES_TL   FFVT\n" +
"       WHERE 1=1\n" +
"       AND FLEX_VALUE_SET_ID   = 1003450\n" +
"       AND FFV.flex_value_id   = FFVT.flex_value_id\n" +
"       AND FFVT.language       = 'PTB'\n" +
"       AND FFV.ENABLED_FLAG    = 'Y'\n" +
"       AND SYSDATE BETWEEN NVL(START_DATE_ACTIVE,SYSDATE-1) AND NVL(END_DATE_ACTIVE,TO_DATE('31/12/4712','DD/MM/YYYY'))\n" +
"       GROUP BY FFV.flex_value,  FFVT.description   , FFV.attribute1, FFV.attribute2, ffv.flex_value_id, ffv.attribute6,ffv.attribute3\n" +
"     )ch     \n" +
"CONNECT BY NOCYCLE PRIOR ch.flex_value_id = ch.attribute6\n" +
"START WITH  ch.attribute6 is not null and ch.attribute6 = '35620'";
       UtilitariosGeracao.GeracaoemPDF(sql_list, "Subcr");
        return "adobeCentroResponsabilidade";
    }
    public String impressaoCentroResponsabilidade() {
        return "impressaoCentroResponsabilidade";
    }
}