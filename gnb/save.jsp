<%@ page contentType="text/html; charset=euc-kr" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="common.utility.StringUtility"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ include  file="/baas/include/session.jsp" %>

<%

	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}

	request.setCharacterEncoding("euc-kr");	

	String content  = request.getParameter("content");

	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  pageNumber = request.getParameter("page");
	
	String  savePath = null;
 	
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		savePath  = "/app/homepage/tyleisure/htdocs/flash/menu.xml";
	}
	else {
		savePath = "c:/upload/flash/menu.xml";
	}
	
	File  f  = new  File(savePath);
	f.createNewFile();
	
	FileWriter fw  = new  FileWriter(savePath);
	
	fw.write(content);
	fw.close(); 	
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber));
	response.sendRedirect(goURL);

%>
