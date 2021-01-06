<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@include  file="/baas/include/session.jsp" %>
<% 
	
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}	

	request.setCharacterEncoding("euc-kr");
	
	String globalMenu = request.getParameter("global_menu");
	String localMenu = request.getParameter("local_menu");
	String dbName = request.getParameter("db");
	String pageNumber = request.getParameter("page");
	String docNumber = request.getParameter("doc");
	String categoryCode = request.getParameter("category");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();



	Map fmap = new HashMap();
	fmap.put("tableName","tb_" + dbName);
	fmap.put("docNumber",docNumber);
	String attach_filename   = (String)sqlMap.queryForObject("clubFilename", fmap);
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	
	String  savedir  = uploaddir + dbName +"/";
	
	if (attach_filename != null){
		File  deletefile  = new  File(savedir  + attach_filename);
		out.println(savedir  + attach_filename);
		deletefile.delete();
		
		%>
		<%
			String dFile_name = attach_filename;
			String dSavePath = savedir;
			
			//System.out.println("dFile_name :: " + dFile_name);
			//System.out.println("dSavePath :: " + dSavePath);
		%>
		<%@include file="/comm/ftptrans2.jsp" %>
		<%
	}
	
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("docNumber",docNumber);
	
	sqlMap.delete("clubDelete", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBlogURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), categoryCode);
	response.sendRedirect(goURL);
	
%>	

