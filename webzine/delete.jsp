<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@page import="org.jdom.output.Format"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.*" %>


<%@include  file="/baas/include/session.jsp" %>

<% 
	request.setCharacterEncoding("euc-kr");
	
	String dbName = request.getParameter("db");
	String pageNumber = request.getParameter("page");
	String docNumber = request.getParameter("doc");
	String divisionCode = request.getParameter("div");
	String accessCode = request.getParameter("code");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	AclDataObject acldataobj = new AclDataObject();
	
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", dbName);
	aclmap.put("accessCode", accessCode );

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	isAccess  = acldataobj.getIs_access();

	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>");
		return;
	}

	Map fmap = new HashMap();
	fmap.put("tableName","tb_" + dbName);
	fmap.put("docNumber",docNumber);
	String attach_filename   = (String)sqlMap.queryForObject("boardFilename", fmap);
	
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
	
	sqlMap.delete("webzineDelete", map);

	
%>	

