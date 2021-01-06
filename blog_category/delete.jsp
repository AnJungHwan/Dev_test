<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.ClubCategoryDataObject"  %>
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
	
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	Map fmap = new HashMap();
	fmap.put("tableName","tb_" + dbName);
	fmap.put("docNumber",docNumber);
	
	ClubCategoryDataObject dataobj = new ClubCategoryDataObject();
  	dataobj = (ClubCategoryDataObject)sqlMap.queryForObject("clubCategoryFilename", fmap);
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	
	String  savedir  = uploaddir + dbName +"/";
	
	ArrayList dFilenameList = new ArrayList();
	ArrayList dFilenameList2 = new ArrayList();	
	
	if (dataobj.getMenu_filename() != null){
		File  deletemenufile  = new  File(savedir  + dataobj.getMenu_filename());
		out.println(savedir  + dataobj.getMenu_filename());
		dFilenameList.add(dataobj.getMenu_filename());
		deletemenufile.delete();
	}
	if (dataobj.getTitle_filename() != null){
		File  deletetitlefile  = new  File(savedir  + dataobj.getTitle_filename());
		out.println(savedir  + dataobj.getTitle_filename());
		dFilenameList.add(dataobj.getTitle_filename());
		deletetitlefile.delete();
	}
	
	if (dataobj.getMenu_filename() != null || dataobj.getTitle_filename() != null)
	{
	%>
	<%
		ArrayList tFile_nameList = dFilenameList;
		ArrayList tFile_nameList2 = dFilenameList2;
		String dSavePath = savedir;
		
		//System.out.println("tFile_name :: " + tFile_nameList.get(0));
		//System.out.println("tFile_name2 :: " + tFile_nameList.get(1));
		//System.out.println("tFile_name :: " + tFile_nameList2.get(0));
		//System.out.println("tFile_name2 :: " + tFile_nameList2.get(1));
		//System.out.println("tSavePath :: " + tSavePath);
	%>
	<%@include file="/comm/ftptrans6.jsp" %>
	<%
	}	
	
	
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("docNumber",docNumber);
	
	sqlMap.delete("clubCategoryDelete", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber));
	response.sendRedirect(goURL);

	
%>	

