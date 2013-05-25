package br.com.cobra.dataaccess;


import br.com.cobra.entidade.Cargo;
import br.com.cobra.utilitarios.UtilitarioParametros;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class CargoDAO {
    private static Map<String, Cargo> cargoMap;
    private static final String SQL_FIND_BY_ID = "SELECT LOOKUP_CODE AS CODIGO ,MEANING AS DESCRICAO FROM FND_LOOKUP_VALUES_VL where lookup_type = 'COB_HR_CARGOS_PCCS' AND LOOKUP_CODE = ?";
    private static final String SQL_FIND_BY_DESCRIPTION = "SELECT LOOKUP_CODE AS CODIGO ,MEANING AS DESCRICAO FROM FND_LOOKUP_VALUES_VL where lookup_type = 'COB_HR_CARGOS_PCCS'  AND LOOKUP_CODE = ?";
    private static final String SQL_LIST_ORDER_BY_ID = "SELECT LOOKUP_CODE AS CODIGO ,MEANING AS DESCRICAO FROM FND_LOOKUP_VALUES_VL where lookup_type = 'COB_HR_CARGOS_PCCS' ORDER BY 1";
    private static final String SQL_LIST_ORDER_BY_NAME = "SELECT LOOKUP_CODE AS CODIGO ,MEANING AS DESCRICAO FROM FND_LOOKUP_VALUES_VL where lookup_type = 'COB_HR_CARGOS_PCCS' ORDER BY 2";
    private static final String SQL_LIST_ORDER_BY_ASSET = "";
    private static final String SQL_INSERT = "";
    private static final String SQL_UPDATE = "";
    private static final String SQL_DELETE = "";
    private static final String SQL_EXIST_DESCRICAO = "";
    private DAOFactory daoFactory;
    

    CargoDAO(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }

    public Cargo procurar(BigDecimal id) throws DAOException {
        return procurar(SQL_FIND_BY_ID, id);
    }

    public Cargo procurar(String descricao) throws DAOException {
        return procurar(SQL_FIND_BY_DESCRIPTION, descricao);
    }

    private Cargo procurar(String sql, Object... values) throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        Cargo cargo = null;
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            DAOUtil.setValues(preparedStatement, values);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                cargo = mapCargo(resultSet);
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY001"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return cargo;
    }

    public void insert(Cargo cargo) throws IllegalArgumentException, DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;
        if (cargo == null) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        }
        Object[] valores = {
            cargo.getDescricao()
           };
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_INSERT);
            DAOUtil.setValues(preparedStatement, valores);
            int numRows = preparedStatement.executeUpdate();
            if (numRows == 0) {
                throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
        } finally {
            DAOUtil.close(generatedKeys);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
    }

    public void update(Cargo cargo) throws DAOException {
        if (cargo.getCodigo() == null) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        }
        Object[] valores = {
            cargo.getDescricao()
        };

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_UPDATE);
            DAOUtil.setValues(preparedStatement, valores);
            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows == 0) {
                throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY006"));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
        } finally {
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
    }

    public void salvar(Cargo cargo) throws DAOException {
    }

    public void delete(Cargo cargo) throws DAOException {

        Date dataAtual = new Date();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        Object[] valores = {
            cargo.getCodigo()
        };
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_DELETE);
            DAOUtil.setValues(preparedStatement, valores);
            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows == 0) {
                throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY004"));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
        } finally {
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
    }

    public boolean existDescricao(String descricao) throws DAOException {
        return exist(SQL_EXIST_DESCRICAO, descricao);
    }

    private boolean exist(String sql, Object... values) throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        boolean exist = false;

        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            DAOUtil.setValues(preparedStatement, values);
            resultSet = preparedStatement.executeQuery();
            exist = resultSet.next();
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return exist;
    }

    public List<Cargo> listaCodigo() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<Cargo> elementos = new ArrayList<Cargo>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapCargo(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return elementos;
    }

    public List<Cargo> listaDescricao() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<Cargo> elementos = new ArrayList<Cargo>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_NAME);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapCargo(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return elementos;
    }

    public List<Cargo> listaAtivos() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<Cargo> elementos = new ArrayList<Cargo>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_ASSET);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapCargo(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY005"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return elementos;
    }
     private static Cargo mapCargo(ResultSet resultSet) throws SQLException {
        return new Cargo(
                resultSet.getString(1),
                resultSet.getString(2)
                );
    }

    private static void mapListCargo(ResultSet resultSet) throws SQLException, DAOException {
        DAOFactory       javabase  = DAOFactory.getInstance("javabase");
        CargoDAO       cargoDAO  = javabase.getCargoDAO();
        cargoMap  = new LinkedHashMap<String, Cargo>();
        Iterator inte = cargoDAO.listaAtivos().iterator();
        for (Iterator<Cargo> it= cargoDAO.listaAtivos().iterator(); it.hasNext(); ) {
            Cargo cargo = it.next();
            cargoMap.put(cargo.getCodigo(),cargo);
        }
    }

    static public void main(String []args) throws DAOException {
        DAOFactory javabase = DAOFactory.getInstance("javabase");
        CargoDAO cargoDAO = javabase.getCargoDAO();
        List<Cargo> list = new ArrayList<Cargo>();
        Cargo app = new Cargo();
        list = cargoDAO.listaDescricao();
        for (Cargo reg:list) {
            System.out.println("==> " + reg.getCodigo() + " = " +  reg.getDescricao());
        }
    }
}
