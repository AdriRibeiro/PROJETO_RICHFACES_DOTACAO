/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function logout() {
    javascript:window.close();
    OpenWindow = window.open("", "newwin", "height=150,width=150,toolbar=no,scrollbars=" + scroll + ",menubar=no");
    OpenWindow.document.write("<html><head><title>Volte Sempre</title></head>")
    OpenWindow.document.write("<body bgcolor='#ffffff' text='#000000'><center><font face='arial' size= '2'><br> </br>");
    OpenWindow.document.write("<p>A Auditoria Interna agradece a(s) sua(s) atualizações.")
    OpenWindow.document.write("<a href='javascript:window.close()'>Fechar</a></p>")
    OpenWindow.document.write("</font></center></body></html>")
}
