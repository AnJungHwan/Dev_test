<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.SubFlashDataObject"  %>
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
	String divisionCode = request.getParameter("div");
	String divisionFolder = null;
	
	if(divisionCode.equals("PC")){
		divisionFolder = "/pinecreek/";
	}
	else if(divisionCode.equals("PV")){
		divisionFolder = "/pinevalley/";
	}
	else if(divisionCode.equals("WP")){
		divisionFolder = "/westpine/";
	}
	else  if (divisionCode.equals("WJ")){
		divisionFolder = "/woonjung/";
	}
	else  if (divisionCode.equals("YR")){
		divisionFolder = "/youngrangho/";
	}
	else if(divisionCode.equals("NC")){
		divisionFolder = "/f_b/";
	}
	
	
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	SubFlashDataObject dataobj = new SubFlashDataObject();
  	dataobj = (SubFlashDataObject)sqlMap.queryForObject("subFlashFilename", docNumber);
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	
	String  savedir  = uploaddir + dbName + divisionFolder  ;
	
	
	if (dataobj.getFilename() != null){
		File  deletefile  = new  File(savedir  + dataobj.getFilename());
		out.println(savedir  + dataobj.getFilename());
		deletefile.delete();
		
		%>
		<%
			String dFile_name = dataobj.getFilename();
			String dSavePath = savedir;
			
			//System.out.println("dFile_name :: " + dFile_name);
			//System.out.println("dSavePath :: " + dSavePath);
		%>
		<%@include file="/comm/ftptrans2.jsp" %>
		<%
		
	}
	
	
	sqlMap.delete("subFlashDelete", docNumber);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBannerURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), divisionCode);
	response.sendRedirect(goURL);
%>	

