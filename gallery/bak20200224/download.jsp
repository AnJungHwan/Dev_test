<%@ page contentType="application/unknown; charset=euc-kr" %><%@ page import="java.util.*,java.io.*,java.sql.*,java.text.*"%><%
	
	request.setCharacterEncoding("euc-kr");
	
	String fileName = request.getParameter("file");
	String folderName = request.getParameter("db");
	
	String fileName2 = new String(fileName.getBytes("euc-kr"),"8859_1");
	File file = new File("c:/upload/"+ folderName  + "/"+ fileName); // �������Դϴ�.
    byte b[] = new byte[10 * 1024 * 1024];
    response.setHeader("Content-Disposition", "attachment;filename=" + fileName2 + ";");
    if (file.isFile()) {
		BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
        BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
        int read = 0;
        while ((read = fin.read(b)) != -1){
			outs.write(b,0,read);
		}
        outs.close();
        fin.close();
	}
%>

