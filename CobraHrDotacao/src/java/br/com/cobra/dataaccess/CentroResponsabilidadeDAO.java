package br.com.cobra.dataaccess;


import br.com.cobra.entidade.CentroResponsabilidade;
import br.com.cobra.entidade.Hierarquia;
import br.com.cobra.utilitarios.UtilitarioParametros;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public final class CentroResponsabilidadeDAO {

    private static final String SQL_FIND_BY_ID = "SELECT FFVB.FLEX_VALUE_ID AS FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO, FFVB.START_DATE_ACTIVE AS DATA_DE_INICIO, FFVB.END_DATE_ACTIVE  AS DATA_DE_TERMINO, NVL(FFVB.ENABLED_FLAG,'Y')  AS HABILITADO  FROM FND_FLEX_VALUES_TL FFVT,FND_FLEX_VALUES    FFVB  WHERE FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 AND FFVB.FLEX_VALUE_ID = ?";
    private static final String SQL_FIND_BY_DESCRIPTION = "SELECT FFVB.FLEX_VALUE_ID AS FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO, FFVB.START_DATE_ACTIVE AS DATA_DE_INICIO, FFVB.END_DATE_ACTIVE  AS DATA_DE_TERMINO, NVL(FFVB.ENABLED_FLAG,'Y')  AS HABILITADO  FROM FND_FLEX_VALUES_TL FFVT,FND_FLEX_VALUES    FFVB  WHERE FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450";
    private static final String SQL_LIST_ORDER_BY_ID = "SELECT FFVB.FLEX_VALUE_ID AS FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO, FFVB.START_DATE_ACTIVE AS DATA_DE_INICIO, FFVB.END_DATE_ACTIVE  AS DATA_DE_TERMINO, NVL(FFVB.ENABLED_FLAG,'Y')  AS HABILITADO  FROM FND_FLEX_VALUES_TL FFVT,FND_FLEX_VALUES    FFVB  WHERE FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 ORDER BY 2 DESC";
    private static final String SQL_LIST_ORDER_BY_NAME = "SELECT FFVB.FLEX_VALUE_ID AS FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO, FFVB.START_DATE_ACTIVE AS DATA_DE_INICIO, FFVB.END_DATE_ACTIVE  AS DATA_DE_TERMINO, NVL(FFVB.ENABLED_FLAG,'Y')  AS HABILITADO  FROM FND_FLEX_VALUES_TL FFVT,FND_FLEX_VALUES    FFVB  WHERE FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 ORDER BY 2 DESC";
    private static final String SQL_LIST_ORDER_BY_ASSET = "SELECT CAMINHO, NIVEL, SIGLA, DESCRICAO, SUM_DOTACAO, SUM_BLOQUEIO, SUM_LOTACAO FROM COBRA_HIERARQUIA_DOTACAO_QTD";
    private static final String SQL_INSERT = "";
    private static final String SQL_UPDATE = "";
    private static final String SQL_DELETE = "";
    private static final String SQL_EXIST_DESCRICAO = "";
    private DAOFactory daoFactory;
    private static Map<BigDecimal, CentroResponsabilidade> organizacaoMap;

    CentroResponsabilidadeDAO(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }

    public CentroResponsabilidade procurar(BigDecimal id) throws DAOException {
        return procurar(SQL_FIND_BY_ID, id);
    }

    public CentroResponsabilidade procurar(String descricao) throws DAOException {
        return procurar(SQL_FIND_BY_DESCRIPTION, descricao);
    }

    private CentroResponsabilidade procurar(String sql, Object... values) throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        CentroResponsabilidade organizacao = null;
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            DAOUtil.setValues(preparedStatement, values);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                organizacao = mapOrganizacao(resultSet);
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return organizacao;
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
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return exist;
    }

    public List<CentroResponsabilidade> listaCodigo() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<CentroResponsabilidade> elementos = new ArrayList<CentroResponsabilidade>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapOrganizacao(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return elementos;
    }

    public List<CentroResponsabilidade> listaDescricao() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<CentroResponsabilidade> elementos = new ArrayList<CentroResponsabilidade>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_NAME);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapOrganizacao(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return elementos;
    }

    public List<Hierarquia> listaHierarquia() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<Hierarquia> elementos = new ArrayList<Hierarquia>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_ASSET);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapHierarquia(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return elementos;
    }
    public ArrayList<CentroResponsabilidade> listaArrayList() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        ArrayList<CentroResponsabilidade> elementos = new ArrayList<CentroResponsabilidade>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_ASSET);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapOrganizacao(resultSet));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return elementos;
    }

    private static CentroResponsabilidade mapOrganizacao(ResultSet resultSet) throws SQLException {
        return new CentroResponsabilidade(
                resultSet.getBigDecimal(1),
                resultSet.getString(2),
                resultSet.getString(3),
                resultSet.getString(4),
                resultSet.getDate(5),
                resultSet.getDate(6),
                resultSet.getString(7)
                );
    }
    private static Hierarquia mapHierarquia(ResultSet resultSet) throws SQLException {
        return new Hierarquia(
                resultSet.getString(1),
                resultSet.getBigDecimal(2),
                resultSet.getString(3),
                resultSet.getString(4),
                resultSet.getBigDecimal(5),
                resultSet.getBigDecimal(6),
                resultSet.getBigDecimal(7)
                );
    }

    
    static public void main(String []args) throws DAOException {
        DAOFactory javabase = DAOFactory.getInstance("javabase");
        CentroResponsabilidadeDAO organizacaoDAO = javabase.getCentroResponsabilidadeDAO();
        List<CentroResponsabilidade> list = new ArrayList<CentroResponsabilidade>();
        CentroResponsabilidade app = new CentroResponsabilidade();
        list = organizacaoDAO.listaDescricao();
        for (CentroResponsabilidade reg:list) {
            System.out.println("==> " + reg.getScr() + ") " + reg.getDescricao());
        }
    }
}
