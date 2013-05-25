/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

/**
 *
 * @author horacio
 */
public class UtilitarioValidacao {
    public static boolean validaNome(String campo) {
        return campo.matches("[A-Z][a-zA-Z]*");
    }
    public static boolean validaNomeCompleto(String campo) {
        return campo.matches("[a-zA-z]+([ '-][a-zA-Z]+)*");
    }
    public static boolean validaEndereco(String campo) {
        return campo.matches("\\d+\\s+([a-zA-Z]+|[a-zA-Z]+\\s[a-zA-Z]+)");
    }
    public static boolean validaCidade(String campo) {
        return campo.matches("([a-zA-Z]+|[a-zA-Z]+\\s[a-zA-Z]+)");
    }
    public static boolean validaNumeroInteiro(String campo) {
        return campo.matches("^[0-9]+$");
    }
    public static boolean validaNumeroReal(String campo) {
        return campo.matches("^[0-9]+?(.|,[0-9]+)$");
    }
    public static boolean validaCEP(String campo) {
        return campo.matches("\\d{5}-\\d{3}");
    }
    public static boolean validaTelefone(String campo) {
        return campo.matches("\\d{2}-\\d{4}-\\d{4}");
    }
    public static boolean validaEmail(String campo) {
        return campo.matches("([\\w\\-]+\\.)*[\\w\\- ]+@([\\w\\- ]+\\.)+([\\w\\-]{2,3})");
    }
    public static boolean validaCPF(String campo) {
        return campo.matches("\\d{3}.\\d{3}.\\d{3}-\\d{2}");
    }
    public static boolean validaCNPJ(String campo) {
        return campo.matches("^\\d{3}.?\\d{3}.?\\d{3}/?\\d{3}-?\\d{2}$");
    }
    public static void main(String [] args) {
        System.out.println("O nome Horacio esta " + UtilitarioValidacao.validaNome("Horacio"));
        System.out.println("O nome Horacio{espaco} esta " + UtilitarioValidacao.validaNome("Horacio "));
        System.out.println("O nome Horacio Vasoncellos esta " + UtilitarioValidacao.validaNomeCompleto("Horacio Vasoncellos"));
        System.out.println("O nome Horacio Vasoncellos@ esta " + UtilitarioValidacao.validaNomeCompleto("Horacio Vasoncellos@"));
        System.out.println("O CEP 20540150 esta " + UtilitarioValidacao.validaCEP("20540150"));
        System.out.println("O CEP 20540150 esta " + UtilitarioValidacao.validaCEP("20540-150"));
        System.out.println("O Telefone 21-2571-9297 esta " + UtilitarioValidacao.validaTelefone("21-2571-9297"));
        System.out.println("O CPF 77678117787 esta " + UtilitarioValidacao.validaCPF("776.781.17787"));
        System.out.println("O CPF 776.781.177-87 esta " + UtilitarioValidacao.validaCPF("776.781.177-87"));

    }
}