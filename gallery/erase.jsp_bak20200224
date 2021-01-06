<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.GalleryDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	String  accessCode = request.getParameter("code");
	String  idCode = request.getParameter("id");
	String  divisionCode = request.getParameter("div");
	
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	AclDataObject acldataobj = new AclDataObject();
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", dbName);
	aclmap.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	isAccess  = acldataobj.getIs_access();
	
	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	
	String filename   = (String)sqlMap.queryForObject("galleryStorageOneFilename", docNumber);
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	String  savedir  = uploaddir + dbName +"_storage/";
	
	if (filename != null){
		File  deletefile  = new  File(savedir  + filename);
		deletefile.delete();
		
		File  thumbDeletefile  = new  File(savedir  + "thumb_" + filename);
		thumbDeletefile.delete();
		
		
		%>
		<%
			String dFile_name = filename;
			String dSavePath = savedir;
			String dFile_name2 = "thumb_" + filename;
			
			//System.out.println("dFile_name :: " + dFile_name);
			//System.out.println("dSavePath :: " + dSavePath);
		%>
		<%@include file="/comm/ftptrans4.jsp" %>
		<%
	}
	
	//DB  입력
	sqlMap.update("galleryCountMinus", idCode);
	sqlMap.delete("galleryStorageErase", docNumber);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForGalleryURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewpic", Integer.parseInt(pageNumber), idCode, divisionCode, accessCode);
	response.sendRedirect(goURL);

%>
