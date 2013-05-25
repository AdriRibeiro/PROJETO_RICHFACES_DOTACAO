/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.cobra.utilitarios;

/**
 *
 * @author horacio
 */
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Random;

public final class UtilitarioString {

    public static final int PAD_LEFT = -1;
    public static final int PAD_BOTH = 0;
    public static final int PAD_RIGHT = 1;
    public static final String __LINE_SEPARATOR = (String) System.getProperty("line.separator", "\n");
    public static String __ISO_8859_1;
    private static char[] lowercases = {
        '\000', '\001', '\002', '\003', '\004', '\005', '\006', '\007',
        '\010', '\011', '\012', '\013', '\014', '\015', '\016', '\017',
        '\020', '\021', '\022', '\023', '\024', '\025', '\026', '\027',
        '\030', '\031', '\032', '\033', '\034', '\035', '\036', '\037',
        '\040', '\041', '\042', '\043', '\044', '\045', '\046', '\047',
        '\050', '\051', '\052', '\053', '\054', '\055', '\056', '\057',
        '\060', '\061', '\062', '\063', '\064', '\065', '\066', '\067',
        '\070', '\071', '\072', '\073', '\074', '\075', '\076', '\077',
        '\100', '\141', '\142', '\143', '\144', '\145', '\146', '\147',
        '\150', '\151', '\152', '\153', '\154', '\155', '\156', '\157',
        '\160', '\161', '\162', '\163', '\164', '\165', '\166', '\167',
        '\170', '\171', '\172', '\133', '\134', '\135', '\136', '\137',
        '\140', '\141', '\142', '\143', '\144', '\145', '\146', '\147',
        '\150', '\151', '\152', '\153', '\154', '\155', '\156', '\157',
        '\160', '\161', '\162', '\163', '\164', '\165', '\166', '\167',
        '\170', '\171', '\172', '\173', '\174', '\175', '\176', '\177'};


    static {
        String iso = System.getProperty("ISO_8859_1");
        if (iso != null) {
            __ISO_8859_1 = iso;
        } else {
            try {
                new String(new byte[]{(byte) 20}, "ISO-8859-1");
                __ISO_8859_1 = "ISO-8859-1";
            } catch (java.io.UnsupportedEncodingException e) {
                __ISO_8859_1 = "ISO8859_1";
            }
        }
    }
    public static String ltrim(String source) {
        return source.replaceAll("^\\s+", "");
    }

    public static String rtrim(String source) {
        return source.replaceAll("\\s+$", "");
    }

    public static String itrim(String source) {
        return source.replaceAll("\\b\\s{2,}\\b", " ");
    }
    public static String trim(String source) {
        return itrim(ltrim(rtrim(source)));
    }
    public static String lrtrim(String source){
        return ltrim(rtrim(source));
    }


    private UtilitarioString() {
    }
    public static int ocorrencia(String texto, String delimitador) {
        int numero = 0;
        for (int i=0; i < texto.length() ; i++) {
            if (texto.substring(i, (i+1)).equals(delimitador) ) {
                ++numero;
            }
        }
        return numero;
    }
    public static String textoEntre (String original, String priOcorrencia, String segOcorrencia) {
        String novoTexto = null;
        int    posInicio = original.indexOf(priOcorrencia, 0);
        int    posTermino= 0;
        if (posInicio > 0 ) {
            novoTexto = original.substring(posInicio + priOcorrencia.length(), original.length());
            posTermino= novoTexto.indexOf(segOcorrencia, 0);
            if (posTermino > 0) {
                novoTexto = novoTexto.substring(0, posTermino);
                novoTexto = lrtrim(novoTexto);
            }
            else novoTexto= null;
        }

        return novoTexto;
    }
    public static String piece(String texto, String delimitador, int posicao) {
        String  novoTexto = texto + delimitador;
        boolean eterno    = true;
        int posInicial    = 0;
        int posTermino    = 0;
        int posConta      = 0;
        String retorno;
        for (int i=0; eterno ; i++ ) {
            posTermino = novoTexto.indexOf(delimitador, posInicial);
            posConta++;
            if (posTermino < 0) {
                eterno = false;
                break;
            } else {
                if (posConta == posicao) {
                    eterno = false;
                    break;
                }
                else posInicial = posTermino + 1;
            }
        }
        if (posTermino < 0) retorno = null;
        else retorno = novoTexto.substring(posInicial, posTermino);
        return retorno;
  }

    public static String pad(String string, String pad, int length, int direction)
            throws IllegalArgumentException {
        StringBuilder builder = new StringBuilder(string);

        switch (direction) {
            case PAD_LEFT:
                while (builder.length() < length) {
                    builder.insert(0, pad);
                }
                break;

            case PAD_RIGHT:
                while (builder.length() < length) {
                    builder.append(pad);
                }
                break;

            case PAD_BOTH:
                int right = (length - builder.length()) / 2 + builder.length();
                while (builder.length() < right) {
                    builder.append(pad);
                }
                while (builder.length() < length) {
                    builder.insert(0, pad);
                }
                break;

            default:
                throw new IllegalArgumentException("Invalid direction, must be one of" + " StringUtil.PAD_LEFT, StringUtil.PAD_BOTH or StringUtil.PAD_RIGHT.");
        }

        return builder.toString();
    }

    public static String trim(String string, String trim) {
        if (trim.length() == 0) {
            return string;
        }

        int start = 0;
        int end = string.length();
        int length = trim.length();

        while (start + length <= end && string.substring(start, start + length).equals(trim)) {
            start += length;
        }
        while (start + length <= end && string.substring(end - length, end).equals(trim)) {
            end -= length;
        }

        return string.substring(start, end);
    }

    public static String join(Collection<?> collection, String join) {
        StringBuilder builder = new StringBuilder();

        for (Iterator<?> iter = collection.iterator(); iter.hasNext();) {
            builder.append(iter.next());

            if (iter.hasNext()) {
                builder.append(join);
            }
        }

        return builder.toString();
    }

    public static String join(Object[] objects, String join) {
        StringBuilder builder = new StringBuilder();

        for (int i = 0; i < objects.length;) {
            builder.append(objects[i]);

            if (++i < objects.length) {
                builder.append(join);
            }
        }

        return builder.toString();
    }

    public static String decapitalize(String string) {
        if (string.length() == 0) {
            return string;
        }
        return string.substring(0, 1).toLowerCase() + string.substring(1);
    }

    public static boolean isNumber(String string) {
        return string.matches("^\\d+$");
    }

    public static boolean isNumeric(String string) {
        return string.matches("^[-+]?\\d+(\\.\\d+)?$");
    }

    public static boolean isValuta(String string) {
        return string.matches("^\\d+\\.\\d{2}$");
    }

    public static boolean hasNumbers(String string) {
        return string.matches("^.*\\d.*$");
    }

    public static boolean isEmailAddress(String string) {
        return string.matches("^[\\w-~#&]+(\\.[\\w-~#&]+)*@([\\w-]+\\.)+[a-z]{2,5}$");
    }

    public static String removeXss(String string) {
        return string.replaceAll("(?i)<script.*?>.*?</script.*?>", "") // Remove all <script> tags.
                .replaceAll("(?i)<.*?javascript:.*?>.*?</.*?>", "") // Remove tags with javascript: call.
                .replaceAll("(?i)<.*?\\s+on.*?>.*?</.*?>", ""); // Remove tags with on* attributes.
    }

    public static String asciiToLowerCase(String s) {
        char[] c = null;
        int i = s.length();

        // look for first conversion
        while (i-- > 0) {
            char c1 = s.charAt(i);
            if (c1 <= 127) {
                char c2 = lowercases[c1];
                if (c1 != c2) {
                    c = s.toCharArray();
                    c[i] = c2;
                    break;
                }
            }
        }

        while (i-- > 0) {
            if (c[i] <= 127) {
                c[i] = lowercases[c[i]];
            }
        }

        return c == null ? s : new String(c);
    }
    public static boolean startsWithIgnoreCase(String s, String w) {
        if (w == null) {
            return true;
        }

        if (s == null || s.length() < w.length()) {
            return false;
        }

        for (int i = 0; i < w.length(); i++) {
            char c1 = s.charAt(i);
            char c2 = w.charAt(i);
            if (c1 != c2) {
                if (c1 <= 127) {
                    c1 = lowercases[c1];
                }
                if (c2 <= 127) {
                    c2 = lowercases[c2];
                }
                if (c1 != c2) {
                    return false;
                }
            }
        }
        return true;
    }

    public static int indexFrom(String s, String chars) {
        for (int i = 0; i < s.length(); i++) {
            if (chars.indexOf(s.charAt(i)) >= 0) {
                return i;
            }
        }
        return -1;
    }

    public static String replace(String s, String sub, String with) {
        int c = 0;
        int i = s.indexOf(sub, c);
        if (i == -1) {
            return s;
        }
        StringBuffer buf = new StringBuffer(s.length() + with.length());
        synchronized (buf) {
            do {
                buf.append(s.substring(c, i));
                buf.append(with);
                c = i + sub.length();
            } while ((i = s.indexOf(sub, c)) != -1);

            if (c < s.length()) {
                buf.append(s.substring(c, s.length()));
            }

            return buf.toString();
        }
    }

    public static String unquote(String s) {
        if ((s.startsWith("\"") && s.endsWith("\"")) ||
                (s.startsWith("'") && s.endsWith("'"))) {
            s = s.substring(1, s.length() - 1);
        }
        return s;
    }

    public static void append(StringBuffer buf, String s, int offset, int length) {
        synchronized (buf) {
            int end = offset + length;
            for (int i = offset; i < end; i++) {
                if (i >= s.length()) {
                    break;
                }
                buf.append(s.charAt(i));
            }
        }
    }

    public static void append(StringBuffer buf, byte b, int base) {
        int bi = 0xff & b;
        int c = '0' + (bi / base) % base;
        if (c > '9') {
            c = 'a' + (c - '0' - 10);
        }
        buf.append((char) c);
        c = '0' + bi % base;
        if (c > '9') {
            c = 'a' + (c - '0' - 10);
        }
        buf.append((char) c);
    }

    public static String captchaString() {
        String strBase  = new  String("QAa0bcLdUK2eHfJgTP8XhiFj61DOklNm9nBoI5pGqYVrs3CtSuMZvwWx4yE7zR");
     	StringBuffer sb = new StringBuffer();
        Random r        = new Random();
        int te          = 0;
     	for(int i=1;i<=6;i++){
        	te=r.nextInt(62);
            sb.append(strBase.charAt(te));
        }
 	    return sb.toString();
     }
    public static String reverseString(String valor) {
        String string = valor;
        return new StringBuffer(string).reverse().toString();
    }

    public static ArrayList<String> splitStringRepetido(String valor) {
        ArrayList valores = new ArrayList();
        String temp = (Normalizer.normalize(valor, java.text.Normalizer.Form.NFD)).replaceAll("[^\\p{ASCII}]","");
        String [] splitTexto = temp.split(" ");
        for (String elemento: splitTexto) {
            elemento = ((elemento.replaceAll(";", " ")).replaceAll(",", " ")).replaceAll("  ", " ");
            if (elemento != null) {
               if (! valores.contains(valor)) valores.add(valor);
            }
        }
        return valores;
    }

    public static void main(String [] args) {
        String texto = "Cópia:  Diretoria de Planejamento e Controle - DICON 1. OBJETO DE AUDITORIA Os Controles Internos Administrativos da Entidade.2. OBJETIVO DA AUDITORIA  Emitir parecer sobre o Sistema de Controles Internos, de modo a assegurar que o mesmo esteja funcionando em linha com os pressupostos básicos de integridade do desempenho funcional, confiabilidade da informação gerencial e conformidade com leis, regulamentos, políticas e procedimentos aplicáveis à Empresa. 3. ORIGEM DA DEMANDA Demanda legal exarada no Inciso III, Art. 7º da IN CGU nº 01, de 03 de janeiro de 2007, com o detalhamento previsto no item 4 do Anexo VIII da Portaria CGU nº 3, de 05 de janeiro de 2006.";
        //System.out.println(" O valor 'e " + UtilitarioString.ocorrencia("Horacio;Junior",";"));
        System.out.println(" O valor e:" +UtilitarioString.textoEntre(texto,"1. OBJETO DE AUDITORIA","2. OBJETIVO DA AUDITORIA"));
    }
}