package br.com.cobra.dataaccess;

import br.com.cobra.utilitarios.UtilitarioParametros;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public final class DAOUtil {
    private DAOUtil() {
    }
    public static void setValues(PreparedStatement preparedStatement, Object... values)
        throws SQLException  {
        for (int i = 0; i < values.length; i++) {
            preparedStatement.setObject(i + 1, values[i]);
        }
    }
    public static void close(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println(UtilitarioParametros.getCamposDaAplicacao("BDCN004"));
            }
        }
    }
    public static void close(Statement statement) {
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                System.err.println(UtilitarioParametros.getCamposDaAplicacao("BDCN005"));            
            }
        }
    }
    public static void close(CallableStatement callableStatement) {
        if (callableStatement != null) {
            try {
                callableStatement.close();
            } catch (SQLException e) {
                System.err.println(UtilitarioParametros.getCamposDaAplicacao("BDCN006"));
            }
        }
    }

    public static void close(ResultSet resultSet) {
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
              System.err.println(UtilitarioParametros.getCamposDaAplicacao("BDCN007"));            }
        }
    }
    public static void setParameters(CallableStatement callStatement, Object... values)
        throws SQLException  {
        for (int i = 0; i < values.length; i++) {
            callStatement.setObject(i + 1, values[i]);
        }
    }

    public static String hashMD5(String string) {
        byte[] hash;

        try {
            hash = MessageDigest.getInstance("MD5").digest(string.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(UtilitarioParametros.getCamposDaAplicacao("BDCN999"), e);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(UtilitarioParametros.getCamposDaAplicacao("BDCN999"), e);
        }

        StringBuilder hex = new StringBuilder(hash.length * 2);
        for (byte b : hash) {
            if ((b & 0xff) < 0x10) hex.append("0");
            hex.append(Integer.toHexString(b & 0xff));
        }
        return hex.toString();
    }
}