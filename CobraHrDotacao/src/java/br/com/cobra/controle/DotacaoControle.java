package br.com.cobra.controle;

import br.com.cobra.dataaccess.CargoDAO;
import br.com.cobra.dataaccess.CentroResponsabilidadeDAO;
import br.com.cobra.dataaccess.DAOException;
import br.com.cobra.dataaccess.DotacaoDAO;
import br.com.cobra.dataaccess.DAOFactory;
import br.com.cobra.entidade.Cargo;
import br.com.cobra.entidade.CentroResponsabilidade;
import br.com.cobra.entidade.Dotacao;
import br.com.cobra.entidade.Funcionario;
import br.com.cobra.utilitarios.UtilitariosGeracao;
import java.io.IOException;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.faces.component.UIInput;
import javax.faces.component.html.HtmlInputText;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.DataModel;
import javax.faces.model.ListDataModel;
import javax.faces.model.SelectItem;
import jxl.write.WriteException;



/**
 *
 * @author horacio.vasconcellos
 */
public class DotacaoControle implements Serializable {

    private Dotacao dotacao;
    private DataModel model;
    private DataModel modelHistorico;
    private Dotacao dotacaoHistorico;
    private int linhaCorrente;
    public static final DotacaoDAO dotacaoDAO;
    public static final CentroResponsabilidadeDAO subcrDAO;
    public static final CargoDAO cargoDAO;
    private String descricaoFiltro;
    private String scrFiltro;
    private String siglaFiltro;
    private HtmlInputText inputDotacao,inputBloqueio;
    private UIInput       selCargo, selSubCr;
    private static List<SelectItem> subcrSelectItems;
    private static List<SelectItem> cargoSelectItems;

    static {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        DAOFactory javabase = DAOFactory.getInstance("javabase");
        dotacaoDAO = javabase.getDotacaoDAO();
        subcrDAO = javabase.getCentroResponsabilidadeDAO();
        cargoDAO = javabase.getCargoDAO();
        preencheCargoSelectItems();
        preencheSubcrSelectItems();
    }

    public String getSiglaFiltro() {
        return siglaFiltro;
    }

    public void setSiglaFiltro(String siglaFiltro) {
        this.siglaFiltro = siglaFiltro;
    }

    public DotacaoControle() {
        this.dotacaoHistorico = new Dotacao();
        this.dotacao = null;
    }

    public UIInput getSelCargo() {
        return selCargo;
    }

    public void setSelCargo(UIInput selCargo) {
        this.selCargo = selCargo;
    }

    public UIInput getSelSubCr() {
        return selSubCr;
    }

    public void setSelSubCr(UIInput selSubCr) {
        this.selSubCr = selSubCr;
    }

    public HtmlInputText getInputDotacao() {
        return inputDotacao;
    }

    public void setInputDotacao(HtmlInputText inputDotacao) {
        this.inputDotacao = inputDotacao;
    }

    public HtmlInputText getInputBloqueio() {
        return inputBloqueio;
    }

    public void setInputBloqueio(HtmlInputText inputBloqueio) {
        this.inputBloqueio = inputBloqueio;
    }

    public Dotacao getDotacao() {
        return dotacao;
    }

    public void setDotacao(Dotacao dotacao) {
        this.dotacao = dotacao;
    }

    public int getLinhaCorrente() {
        return linhaCorrente;
    }

    public void setLinhaCorrente(int linhaCorrente) {
        this.linhaCorrente = linhaCorrente;
    }

    public Dotacao getDotacaoHistorico() {
        return dotacaoHistorico;
    }

    public void setDotacaoHistorico(Dotacao dotacaoHistorico) {
        this.dotacaoHistorico = dotacaoHistorico;
    }

    public String getDescricaoFiltro() {
        return descricaoFiltro;
    }

    public void setDescricaoFiltro(String descricaoFiltro) {
        this.descricaoFiltro = descricaoFiltro;
    }

    public String getScrFiltro() {
        return scrFiltro;
    }

    public void setScrFiltro(String scrFiltro) {
        this.scrFiltro = scrFiltro;
    }

    
    public DataModel getModelHistorico() {
        return modelHistorico;
    }

    public void setModelHistorico(DataModel modelHistorico) {
        this.modelHistorico = modelHistorico;
    }

    public DataModel getModel() {
        return model;
    }

    public void setModel(DataModel model) {
        this.model = model;
    }

    public DataModel getTodos() throws Exception {
        model = new ListDataModel(dotacaoDAO.listaDescricao());
        return model;
    }

    public DataModel getHistoricoTodos() throws Exception {
        if (dotacaoHistorico.getDotacaoId().compareTo(BigDecimal.ZERO) > 0) {
            modelHistorico = new ListDataModel(dotacaoDAO.listaHistorico(dotacaoHistorico.getDotacaoId()));
        }
        return modelHistorico;
    }

    public List<SelectItem> getSubcrSelectItems() {
        return subcrSelectItems;
    }

    public void setSubcrSelectItems(List<SelectItem> subcrSelectItems) {
        this.subcrSelectItems = subcrSelectItems;
    }

    public List<SelectItem> getCargoSelectItems() {
        return cargoSelectItems;
    }

    public void setCargoSelectItems(List<SelectItem> cargoSelectItems) {
        this.cargoSelectItems = cargoSelectItems;
    }

    public Dotacao getDotacaoFromEditOrDelete() {
        dotacao = (Dotacao) model.getRowData();
        return dotacao;
    }

    public String editar() {
        dotacao = getDotacaoFromEditOrDelete();
        ExternalContext exctxt = FacesContext.getCurrentInstance().getExternalContext();
        Object objeto = FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("loginBean");
        this.dotacao.setAtualizadoPor(
                new Funcionario(((LoginControle) objeto).getLogin().getPerson_id(), ((LoginControle) objeto).getLogin().getLogon()));
        setDotacao(dotacao);
        return "editarDotacao";
    }

    public String excluir() throws Exception {
        ExternalContext exctxt = FacesContext.getCurrentInstance().getExternalContext();
        Object objeto = FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("loginBean");
        dotacao = getDotacaoFromEditOrDelete();
        this.dotacao.setAtualizadoPor(
                new Funcionario(((LoginControle) objeto).getLogin().getPerson_id(), ((LoginControle) objeto).getLogin().getLogon()));
        dotacaoDAO.delete(dotacao);
        return "sucessoDotacao";
    }

    public String novaDotacao() {
        this.dotacao = new Dotacao();
        ExternalContext exctxt = FacesContext.getCurrentInstance().getExternalContext();
        Object objeto = FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("loginBean");
        this.dotacao.setAtualizadoPor(
                new Funcionario(((LoginControle) objeto).getLogin().getPerson_id(), ((LoginControle) objeto).getLogin().getLogon()));
        this.dotacao.setCriadoPor(
                new Funcionario(((LoginControle) objeto).getLogin().getPerson_id(), ((LoginControle) objeto).getLogin().getLogon()));
        return "novaDotacao";
    }

    public String salvar() throws Exception {
        dotacaoDAO.salvar(dotacao);
        return "sucessoDotacao";
    }

    public String cancelarDotacao() {
        return "cancelarDotacao";
    }

    public String retornarDotacao() {
        return "retornarDotacao";
    }

    public String excelDotacao() throws SQLException, WriteException, IOException {
        String sql_list = "SELECT COBDOT.DOTACAO_ID,COBDOT.FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO,COBDOT.LOOKUP_CODE,   FLVL.MEANING,COBDOT.EFFECTIVE_START_DATE,COBDOT.EFFECTIVE_END_DATE,COBDOT.DOTACAO,COBDOT.BLOQUEIO,COBDOT.DOCUMENTO FROM COBRA_DOTACAO            COBDOT,FND_LOOKUP_VALUES_VL     FLVL,FND_FLEX_VALUES_TL        FFVT,FND_FLEX_VALUES          FFVB WHERE FLVL.lookup_type = 'COB_HR_CARGOS_PCCS' AND FLVL.LOOKUP_CODE = COBDOT.LOOKUP_CODE  AND FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 AND FFVB.FLEX_VALUE_ID = COBDOT.FLEX_VALUE_ID AND SYSDATE BETWEEN COBDOT.EFFECTIVE_START_DATE AND COBDOT.EFFECTIVE_END_DATE ORDER BY 2";
        UtilitariosGeracao.GeracaoemExcel(sql_list, "Dotacao");
        return "excelDotacao";
    }

    public String adobeDotacao() {
        String sql_list = "SELECT COBDOT.DOTACAO_ID,COBDOT.FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO,COBDOT.LOOKUP_CODE,   FLVL.MEANING,COBDOT.EFFECTIVE_START_DATE,COBDOT.EFFECTIVE_END_DATE,COBDOT.DOTACAO,COBDOT.BLOQUEIO,COBDOT.DOCUMENTO FROM COBRA_DOTACAO            COBDOT,FND_LOOKUP_VALUES_VL     FLVL,FND_FLEX_VALUES_TL        FFVT,FND_FLEX_VALUES          FFVB WHERE FLVL.lookup_type = 'COB_HR_CARGOS_PCCS' AND FLVL.LOOKUP_CODE = COBDOT.LOOKUP_CODE  AND FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 AND FFVB.FLEX_VALUE_ID = COBDOT.FLEX_VALUE_ID AND SYSDATE BETWEEN COBDOT.EFFECTIVE_START_DATE AND COBDOT.EFFECTIVE_END_DATE ORDER BY 2";
        UtilitariosGeracao.GeracaoemPDF(sql_list, "Dotacao");
        return "adobeDotacao";
    }

    public String impressaoDotacao() {
        return "impressaoDotacao";
    }

    public String historicoDotacao() {
        return "historicoDotacao";
    }
    /*
     *  Processo de Validação de Mudança de Cargo
     */

    private static void preencheSubcrSelectItems() {
        subcrSelectItems = new ArrayList<SelectItem>();
        try {
            for (CentroResponsabilidade centro : subcrDAO.listaCodigo()) {
                subcrSelectItems.add(new SelectItem(centro.getFlexValueId(), centro.getScr() + "-" + centro.getDescricao()));
            }
        } catch (DAOException ex) {
        }
    }

    private static void preencheCargoSelectItems() {
        cargoSelectItems = new ArrayList<SelectItem>();
        try {
            for (Cargo cargo : cargoDAO.listaDescricao()) {
                cargoSelectItems.add(new SelectItem(cargo.getCodigo(), cargo.getDescricao()));
            }
        } catch (DAOException ex) {
        }
    }
    private void log(Object object) {
        String methodName = Thread.currentThread().getStackTrace()[2].getMethodName();
        System.out.println("DotacaoControle " + methodName + ": " + object);
    }

    public void cargoChanged(ValueChangeEvent event) {
        String selCargo = (String)event.getNewValue();
        ExternalContext exctxt = FacesContext.getCurrentInstance().getExternalContext();
        Object memoFaces = FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("dotacaoBean");
        BigDecimal memo = ((DotacaoControle)memoFaces).dotacao.getCentroResponsabilidade().getFlexValueId();
        Dotacao dota;
        for (Object objeto:model) {
          dota = (Dotacao)objeto;
          if (dota.getCargo().getCodigo().compareTo(selCargo) == 0) {
          }
        }
    }    
} 