/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.controle;

import br.com.cobra.dataaccess.CargoDAO;
import br.com.cobra.dataaccess.DAOFactory;
import br.com.cobra.entidade.Cargo;
import br.com.cobra.utilitarios.UtilitariosGeracao;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import javax.faces.context.FacesContext;
import javax.faces.model.DataModel;
import javax.faces.model.ListDataModel;
import jxl.write.WriteException;

public class CargoControle implements Serializable {
    private Cargo     cargo;
    private DataModel model;
    private String    filtroDesc;
    public static final CargoDAO cargoDAO;

    static {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        DAOFactory javabase = DAOFactory.getInstance("javabase");
        cargoDAO = javabase.getCargoDAO();
    }

    public Cargo getCargo() {
        return cargo;
    }
    public void setCargo(Cargo cargo) {
        this.cargo = cargo;
    }
    public DataModel getModel() {
        return model;
    }
    public void setModel(DataModel model) {
        this.model = model;        
    }
    
    public String getFiltroDesc() {
        return filtroDesc;
    }

    public void setFiltroDesc(String filtroDesc) {
        this.filtroDesc = filtroDesc;
    }
    public DataModel getTodos() throws Exception {
        model = new ListDataModel(cargoDAO.listaDescricao());
        return model;
    }
    public Cargo getCargoFromEditOrDelete() {
        cargo = (Cargo) model.getRowData();
        return cargo;
    }
/*
 * Edição, Exclusão, Novo e Salvar
 */
    public String editar() {
        cargo = getCargoFromEditOrDelete();
        setCargo(cargo);
        return "editarCargo";
    }
    public String excluir() throws Exception {
        cargo = getCargoFromEditOrDelete();
        cargoDAO.delete(cargo);
        return "sucessoCargo";
    }
    public String novoCargo() {
        this.cargo = new Cargo();
        return "novoCargo";
    }
    public String salvar() throws Exception {
        cargoDAO.salvar(cargo);
        return "sucessoCargo";
    }    

 /*
  * Cancelar, Retornoar
 */
    
    public String cancelarCargo() {
        return "mostrarCargo";
    }

    public String retornarCargo() {
        return "retornarCargo";
    }
     public String excelCargo() throws IOException, SQLException, WriteException {
        String sql_list = "SELECT LOOKUP_CODE AS CODIGO ,MEANING AS DESCRICAO FROM FND_LOOKUP_VALUES_VL where lookup_type = 'COB_HR_CARGOS_PCCS'";
        UtilitariosGeracao.GeracaoemExcel(sql_list, "cargo");
        return "excelCargo";
    }

    public String adobeCargo() {
       String sql_list = "SELECT LOOKUP_CODE AS CODIGO ,MEANING AS DESCRICAO FROM FND_LOOKUP_VALUES_VL where lookup_type = 'COB_HR_CARGOS_PCCS'";
       UtilitariosGeracao.GeracaoemPDF(sql_list, "Cargo");
       return "adobeCargo";
    }
    public String impressaoCargo() {
        return "impressaoCargo";
    }
}