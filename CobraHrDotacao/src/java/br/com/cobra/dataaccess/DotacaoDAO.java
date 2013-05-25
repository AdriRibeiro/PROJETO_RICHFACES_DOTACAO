package br.com.cobra.dataaccess;


import br.com.cobra.entidade.Cargo;
import br.com.cobra.entidade.Dotacao;
import br.com.cobra.entidade.CentroResponsabilidade;
import br.com.cobra.entidade.Funcionario;
import br.com.cobra.utilitarios.UtilitarioParametros;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;


public final class DotacaoDAO {

    private static final String SQL_FIND_BY_ID = "SELECT COBDOT.DOTACAO_ID,COBDOT.FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO,COBDOT.LOOKUP_CODE,   FLVL.MEANING,COBDOT.EFFECTIVE_START_DATE,COBDOT.EFFECTIVE_END_DATE,COBDOT.DOTACAO, COBRA_UTILITY_EBS.getQtdadeLotacao   (SYSDATE,FFVB.FLEX_VALUE ,UPPER(FLVL.MEANING)) AS LOTACAO,nvl(COBDOT.BLOQUEIO,0) bloqueio,COBDOT.DOCUMENTO,  cobdot.created_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS CRIADOPOR, cobdot.last_updated_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS ATUALIZADOPOR  FROM COBRA_DOTACAO            COBDOT,FND_LOOKUP_VALUES_VL     FLVL,FND_FLEX_VALUES_TL        FFVT,FND_FLEX_VALUES          FFVB WHERE FLVL.lookup_type = 'COB_HR_CARGOS_PCCS' AND FLVL.LOOKUP_CODE = COBDOT.LOOKUP_CODE  AND FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 AND FFVB.FLEX_VALUE_ID = COBDOT.FLEX_VALUE_ID AND SYSDATE BETWEEN COBDOT.EFFECTIVE_START_DATE AND COBDOT.EFFECTIVE_END_DATE AND DOTACAO_ID = ?";
    private static final String SQL_LIST_HISTORY = "SELECT COBDOT.DOTACAO_ID,COBDOT.FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO,COBDOT.LOOKUP_CODE,   FLVL.MEANING,COBDOT.EFFECTIVE_START_DATE,COBDOT.EFFECTIVE_END_DATE,nvl(COBDOT.DOTACAO,0), COBRA_UTILITY_EBS.getQtdadeLotacao   (SYSDATE,FFVB.FLEX_VALUE ,UPPER(FLVL.MEANING)) AS LOTACAO,nvl(COBDOT.BLOQUEIO,0) bloqueio,COBDOT.DOCUMENTO,  cobdot.created_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS CRIADOPOR, cobdot.last_updated_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS ATUALIZADOPOR  FROM COBRA_DOTACAO            COBDOT,FND_LOOKUP_VALUES_VL     FLVL,FND_FLEX_VALUES_TL        FFVT,FND_FLEX_VALUES          FFVB WHERE FLVL.lookup_type = 'COB_HR_CARGOS_PCCS' AND FLVL.LOOKUP_CODE = COBDOT.LOOKUP_CODE  AND FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 AND FFVB.FLEX_VALUE_ID = COBDOT.FLEX_VALUE_ID AND DOTACAO_ID = ?";
    private static final String SQL_LIST_ORDER_BY_ID = "SELECT COBDOT.DOTACAO_ID,COBDOT.FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO,COBDOT.LOOKUP_CODE,   FLVL.MEANING,COBDOT.EFFECTIVE_START_DATE,COBDOT.EFFECTIVE_END_DATE,nvl(COBDOT.DOTACAO,0), COBRA_UTILITY_EBS.getQtdadeLotacao   (SYSDATE,FFVB.FLEX_VALUE ,UPPER(FLVL.MEANING)) AS LOTACAO,nvl(COBDOT.BLOQUEIO,0) bloqueio,COBDOT.DOCUMENTO,  cobdot.created_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS CRIADOPOR, cobdot.last_updated_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS ATUALIZADOPOR  FROM COBRA_DOTACAO            COBDOT,FND_LOOKUP_VALUES_VL     FLVL,FND_FLEX_VALUES_TL        FFVT,FND_FLEX_VALUES          FFVB WHERE FLVL.lookup_type = 'COB_HR_CARGOS_PCCS' AND FLVL.LOOKUP_CODE = COBDOT.LOOKUP_CODE  AND FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 AND FFVB.FLEX_VALUE_ID = COBDOT.FLEX_VALUE_ID AND SYSDATE BETWEEN COBDOT.EFFECTIVE_START_DATE AND COBDOT.EFFECTIVE_END_DATE ORDER BY 1";
    private static final String SQL_LIST_ORDER_BY_NAME = "SELECT COBDOT.DOTACAO_ID,COBDOT.FLEX_VALUE_ID,FFVB.FLEX_VALUE AS SCR,FFVB.ATTRIBUTE3 AS SCR_SIGLA,FFVT.DESCRIPTION AS DESCRICAO,COBDOT.LOOKUP_CODE,   FLVL.MEANING,COBDOT.EFFECTIVE_START_DATE,COBDOT.EFFECTIVE_END_DATE,nvl(COBDOT.DOTACAO,0), COBRA_UTILITY_EBS.getQtdadeLotacao   (SYSDATE,FFVB.FLEX_VALUE ,UPPER(FLVL.MEANING)) AS LOTACAO,nvl(COBDOT.BLOQUEIO,0) bloqueio,COBDOT.DOCUMENTO,  cobdot.created_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS CRIADOPOR, cobdot.last_updated_by,COBRA_UTILITY_EBS.GETPESSOA(SYSDATE,cobdot.created_by) AS ATUALIZADOPOR  FROM COBRA_DOTACAO            COBDOT,FND_LOOKUP_VALUES_VL     FLVL,FND_FLEX_VALUES_TL        FFVT,FND_FLEX_VALUES          FFVB WHERE FLVL.lookup_type = 'COB_HR_CARGOS_PCCS' AND FLVL.LOOKUP_CODE = COBDOT.LOOKUP_CODE  AND FFVB.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID AND FFVT.LANGUAGE = 'PTB'  AND FFVB.VALUE_CATEGORY  = 'COB_GL_CENTRO'  AND FFVB.FLEX_VALUE_SET_ID  = 1003450 AND FFVB.FLEX_VALUE_ID = COBDOT.FLEX_VALUE_ID AND SYSDATE BETWEEN COBDOT.EFFECTIVE_START_DATE AND COBDOT.EFFECTIVE_END_DATE ORDER BY 2";
    private static final String SQL_INSERT = "INSERT INTO COBRA_DOTACAO(DOTACAO_ID,EFFECTIVE_START_DATE, EFFECTIVE_END_DATE,FLEX_VALUE_ID,LOOKUP_CODE,DOTACAO,BLOQUEIO,DOCUMENTO,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY)  VALUES (? ,SYSDATE, TO_DATE('31/12/4712','DD/MM/YYYY'),?,?,?,?,?,SYSDATE,?,SYSDATE,?)";
    private static final String SQL_UPDATE = "UPDATE COBRA_DOTACAO SET FLEX_VALUE_ID = ?,LOOKUP_CODE = ?,DOTACAO = ?,BLOQUEIO = ?,DOCUMENTO  = ?,LAST_UPDATE_DATE = SYSDATE, LAST_UPDATED_BY = ?  WHERE DOTACAO_ID = ? AND EFFECTIVE_END_DATE = ?";
    private static final String SQL_DELETE = "UPDATE COBRA_DOTACAO SET EFFECTIVE_END_DATE = SYSDATE,LAST_UPDATED_BY = ?  WHERE DOTACAO_ID = ? AND EFFECTIVE_END_DATE = ?";
    private DAOFactory daoFactory;


    DotacaoDAO(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }

    public Dotacao procurar(BigDecimal id) throws DAOException {
        return procurar(SQL_FIND_BY_ID, id);
    }

    private Dotacao procurar(String sql, Object... values) throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        Dotacao dotacao = null;
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            DAOUtil.setValues(preparedStatement, values);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                dotacao = mapDotacao(resultSet);
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY001"));
        } finally {
            DAOUtil.close(resultSet);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
        return dotacao;
    }

    public void insert(Dotacao dotacao) throws IllegalArgumentException, DAOException {
        Connection connection = null;
        BigDecimal chave = null;
        PreparedStatement preparedStatement = null;
        ResultSet generatedKeys = null;
        if (dotacao == null) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY002"));
        }
        if (dotacao.getDotacaoId().compareTo(BigDecimal.ZERO) == 0) {
           chave = null; 
        } else {
            chave = dotacao.getDotacaoId();
        }
        Object[] valores = {
            chave,
            dotacao.getCentroResponsabilidade().getFlexValueId(),
            dotacao.getCargo().getCodigo(),
            dotacao.getDotacao(),
            dotacao.getBloqueio(),
            dotacao.getDocumento(),
            dotacao.getCriadoPor().getPersonId(),
            dotacao.getAtualizadoPor().getPersonId()
           };
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_INSERT);
            DAOUtil.setValues(preparedStatement, valores);
            int numRows = preparedStatement.executeUpdate();
            if (numRows == 0) {
                throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY003"));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY003"));
        } finally {
            DAOUtil.close(generatedKeys);
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
    }

    public void update(Dotacao dotacao) throws DAOException {
        this.delete(dotacao);
        this.insert(dotacao);
    }

    public void salvar(Dotacao dotacao) throws DAOException {
        int result = dotacao.getDotacaoId().compareTo(BigDecimal.ZERO);
        if ( result == 0 ) {
            insert(dotacao);
        } else {
            update(dotacao);
            
        }
    }

    public void delete(Dotacao dotacao) throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        Object[] valores = {
            dotacao.getAtualizadoPor().getPersonId(),
            dotacao.getDotacaoId(),
            new java.sql.Date(dotacao.getEffectiveEndDate().getTime())
        };
         System.out.println("==Excluindo em " + dotacao.getAtualizadoPor().getPersonId() + " com " + dotacao.getDotacaoId() + " as " + new java.sql.Date(dotacao.getEffectiveEndDate().getTime()));
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_DELETE);
            DAOUtil.setValues(preparedStatement, valores);
            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows == 0) {
                throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY004"));
            }
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("BDQY004"));
        } finally {
            DAOUtil.close(preparedStatement);
            DAOUtil.close(connection);
        }
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

    public List<Dotacao> listaCodigo() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<Dotacao> elementos = new ArrayList<Dotacao>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_ID);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapDotacao(resultSet));
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

    public List<Dotacao> listaHistorico(BigDecimal dotacaoId) throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<Dotacao> elementos = new ArrayList<Dotacao>();
        Object[] valores = { dotacaoId };
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_HISTORY);
            DAOUtil.setValues(preparedStatement, valores);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapDotacao(resultSet));
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
    
    public List<Dotacao> listaDescricao() throws DAOException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        List<Dotacao> elementos = new ArrayList<Dotacao>();
        try {
            connection = daoFactory.getConnection();
            preparedStatement = connection.prepareStatement(SQL_LIST_ORDER_BY_NAME);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                elementos.add(mapDotacao(resultSet));
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

    private static Dotacao mapDotacao(ResultSet resultSet) throws SQLException {
        Cargo cargo ;//= cargoDAO.procurar(resultSet.getString(3));
        CentroResponsabilidade centro; // = cargoDAO.procurar(resultSet.getString(3));

        return new Dotacao(resultSet.getBigDecimal(1),
                           new CentroResponsabilidade(resultSet.getBigDecimal(2),resultSet.getString(3),resultSet.getString(4),resultSet.getString(5)),
                           new Cargo(resultSet.getString(6),resultSet.getString(7)),
                           resultSet.getDate(8),
                           resultSet.getDate(9),
                           resultSet.getInt(10),
                           resultSet.getInt(11),
                           resultSet.getInt(12),
                           resultSet.getString(13),
                           new Funcionario(resultSet.getBigDecimal(14),resultSet.getString(15)),
                           new Funcionario(resultSet.getBigDecimal(16),resultSet.getString(17))
                );
        
    }

    static public void main(String []args) throws DAOException {
        DAOFactory javabase = DAOFactory.getInstance("javabase");
        BigDecimal dotacaoId = new BigDecimal(42);
        int numBlq = 2;
        int numDot = 20;
        DotacaoDAO dotacaoDAO = javabase.getDotacaoDAO();
        Dotacao dotacao = dotacaoDAO.procurar(dotacaoId);
        SimpleDateFormat formatador = new SimpleDateFormat ("dd/MM/yyyy HH:mm:ss");   
        System.out.println("==> " + formatador.format(dotacao.getEffectiveEndDate()));  
        SimpleDateFormat simpleDateFormat =    new SimpleDateFormat("dd-MM-yyyy HH:mm:ss", Locale.US);
        System.out.println("==> " + simpleDateFormat.format(dotacao.getEffectiveStartDate()));
    }
}
