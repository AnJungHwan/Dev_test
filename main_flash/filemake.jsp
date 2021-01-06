<%@ page language="java" contentType="text/html; charset=EUC-KR"     pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="database.datadef.MainFlashDataObject"  %>

<%
	String  saveFolder = null;;
	String  fileName  = "swf.xml";
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 saveFolder  = "/app/homepage/tyleisure/htdocs/flash/";
	}
	else {
		saveFolder = "c:/upload/flash/";
	}

	File  f  = new  File(saveFolder  + fileName);
	f.createNewFile();
	
	FileWriter fw  = new  FileWriter(saveFolder  + fileName);
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	List xmlList = new ArrayList();
	xmlList = sqlMap.queryForList("mainFlashXmlList");
	
	fw.write("<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n");
	fw.write("<mainSwf>\n");
	for(int i=0; i < xmlList.size(); i++){
		MainFlashDataObject dataobj = (MainFlashDataObject) xmlList.get(i);
		fw.write("<swf>\n");
		fw.write("\t<url><![CDATA[/upload/main_flash/" + dataobj.getFilename()+ "]]></url>\n");
		fw.write("\t<link><![CDATA[http://www.tyleisure.co.kr]]></link>\n");
		fw.write("</swf>\n");
	}
	fw.write("</mainSwf>\n");
	fw.close(); 
	out.println("<script>alert('생성  되었습니다.');history.back();</script>"); 
%>

