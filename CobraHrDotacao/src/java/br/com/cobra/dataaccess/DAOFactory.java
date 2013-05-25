package br.com.cobra.dataaccess;


import br.com.cobra.utilitarios.UtilitarioParametros;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public final class DAOFactory {
    private static final String PROPERTY_URL               = "BancoDeDadosPadraoConexao";
    private static final String PROPERTY_DRIVER            = "BancoDeDadosPadraoDriver";
    private static final String PROPERTY_USERNAME          = "BancoDeDadosPadraoUsuario";
    private static final String PROPERTY_PASSWORD          = "BancoDeDadosPadraoSenha";
    private static final Map<String, DAOFactory> INSTANCES = new HashMap<String, DAOFactory>();
    private String url;
    private String username;
    private String password;
    private DataSource dataSource;
    private DAOFactory(String name) throws DAOConfigurationException {
        this.url                 = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_URL);
        String driverClassName   = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_DRIVER);
        this.password            = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_PASSWORD);
        this.username            = UtilitarioParametros.getConfiguracaoDaAplicacao(PROPERTY_USERNAME);
        if (driverClassName != null) {
            try {
                Class.forName(driverClassName);
            } catch (ClassNotFoundException e) {
                throw new DAOConfigurationException(UtilitarioParametros.getCamposDaAplicacao("BDCN001"), e);
            }
        } else {
            try {
                dataSource = (DataSource) new InitialContext().lookup(url);
            } catch (NamingException e) {
                throw new DAOConfigurationException(UtilitarioParametros.getCamposDaAplicacao("BDCN002"), e);
            }
        }
    }
    public static DAOFactory getInstance(String name) throws DAOConfigurationException {
        if (name == null) {
            throw new DAOConfigurationException(UtilitarioParametros.getCamposDaAplicacao("BDCN003"));
        }
        DAOFactory instance = INSTANCES.get(name);
        if (instance == null) {
            instance = new DAOFactory(name);
            INSTANCES.put(name, instance);
        }
        return instance;
    }
    Connection getConnection() throws SQLException {
        if (dataSource != null) {
            if (username != null) {
                return dataSource.getConnection(username, password);
            } else {
                return dataSource.getConnection();
            }
        } else {
            return DriverManager.getConnection(url, username, password);
        }
    }
     public CargoDAO getCargoDAO() {
        return new CargoDAO(this);
    }
     public CentroResponsabilidadeDAO getCentroResponsabilidadeDAO() {
        return new CentroResponsabilidadeDAO(this);
    }    
     public DotacaoDAO getDotacaoDAO() {
        return new DotacaoDAO(this);
    }          
     public LoginDAO getLoginDAO() {
        return new LoginDAO(this);
    }               
}

