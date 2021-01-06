<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.GalleryStorageDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String docNumber  = request.getParameter("doc");
	String  subject = request.getParameter("subject");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	Map map = new HashMap();
	
	map.put("docNumber",docNumber);
	map.put("subject", subject);
	
	//out.println("<script>alert('" + docNumber + "');</script>");
	//out.println("<script>alert('" + subject + "');</script>");  
	
	sqlMap.update("galleryStorageUpdate", map);
	out.println("<script>alert('업데이트  되었습니다.');history.back();</script>"); 
%>	
