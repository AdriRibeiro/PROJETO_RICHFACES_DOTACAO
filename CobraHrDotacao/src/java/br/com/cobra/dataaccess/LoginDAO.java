package br.com.cobra.dataaccess;


import br.com.cobra.entidade.Login;
import br.com.cobra.utilitarios.UtilitarioParametros;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Dictionary;
import java.util.Map;
import oracle.jdbc.OracleTypes;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

public final class LoginDAO {
    private static final String ORACLE_TYPE = "COBRAPUB.TYPLOGON";
    private DAOFactory daoFactory;
    private static Map<BigDecimal, Login> loginMap;
    

    LoginDAO(DAOFactory daoFactory) {
        this.daoFactory = daoFactory;
    }
    public Login procurar(String usuario, String password) throws DAOException, ClassNotFoundException {
        Connection connection = null;
        CallableStatement callable = null;
        Login login = null;
        
        try {
            connection = daoFactory.getConnection();
            callable = connection.prepareCall ("begin ? := cobra_utility.getAcesso(?,?); end;");
            callable.registerOutParameter(1, OracleTypes.JAVA_STRUCT,ORACLE_TYPE);
            callable.setString(2, usuario); 
            callable.setString(3, password); 
            callable.execute(); 
            STRUCT resultado = (STRUCT)callable.getObject(1);
            login = new Login(usuario,password,
                             (BigDecimal)(resultado.getAttributes())[2],
                             (BigDecimal)(resultado.getAttributes())[6]);
        } catch (SQLException e) {
            throw new DAOException(UtilitarioParametros.getCamposDaAplicacao("APP-LG-002"));
        } finally {
            DAOUtil.close(connection);
        }
        return login;
    }
   
}
