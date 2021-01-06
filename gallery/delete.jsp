<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="common.utility.StringUtility"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.GalleryStorageDataObject"  %>
<%@include  file="/baas/include/session.jsp" %>
<% 
	
	
	request.setCharacterEncoding("euc-kr");
	
	String globalMenu = request.getParameter("global_menu");
	String localMenu = request.getParameter("local_menu");
	String dbName = request.getParameter("db");
	String pageNumber = request.getParameter("page");
	String idCode = request.getParameter("id");
	String divisionCode = request.getParameter("div");
	String accessCode = request.getParameter("code");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	AclDataObject acldataobj = new AclDataObject();
	
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", dbName);
	aclmap.put("accessCode", accessCode );

	//999 막음.  타 사업장인경우 확인 필요.
	//acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	//isAccess  = acldataobj.getIs_access();
	isAccess = 1;  //권한

	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>");
		return;
	}

	// 갤러리 삭제
	String gallery_filename   = (String)sqlMap.queryForObject("galleryFilename", idCode);
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	
	String  savedir  = uploaddir + dbName +"_storage/";
	
	if (gallery_filename != null){
		File  deletefile  = new  File(savedir  + gallery_filename);
		deletefile.delete();
		
		%>
		<%
			String dFile_name = gallery_filename;
			String dSavePath = savedir;
			String dFile_name2 = "thumb_" + gallery_filename;
			
			//System.out.println("dFile_name :: " + dFile_name);
			//System.out.println("dSavePath :: " + dSavePath);
		%>
		<%@include file="/comm/ftptrans4.jsp" %>
		<%

		
	}
	sqlMap.delete("galleryDelete", idCode);
	
	ArrayList dFilenameList = new ArrayList();
	ArrayList dFilenameList2 = new ArrayList();
	
	// 갤러리 Storage  삭제
	List filenameList = new ArrayList();
	filenameList = sqlMap.queryForList("galleryStorageFilenames", idCode);
	for(int i=0; i < filenameList.size(); i++){
		GalleryStorageDataObject dataobj = (GalleryStorageDataObject) filenameList.get(i);
		File  deleteStorageFile  = new  File(savedir  +dataobj.getFilename());
		File  deleteStorageThumbFile  = new  File(savedir  + "thumb_" + dataobj.getFilename());
		deleteStorageFile.delete();
		deleteStorageThumbFile.delete();
		
		dFilenameList.add(dataobj.getFilename());
		dFilenameList2.add("thumb_" + dataobj.getFilename());
		
		//out.println(deleteStorageFile + "------> deleted<br>");
	}
	
	if(filenameList.size() > 0)
	{
	%>
	<%
		ArrayList tFile_nameList = dFilenameList;
		ArrayList tFile_nameList2 = dFilenameList2;
		String dSavePath = savedir;
		
		System.out.println("tFile_name :: " + tFile_nameList.get(0));
		//System.out.println("tFile_name2 :: " + tFile_nameList.get(1));
		System.out.println("tFile_name :: " + tFile_nameList2.get(0));
		//System.out.println("tFile_name2 :: " + tFile_nameList2.get(1));
		System.out.println("tSavePath :: " + dSavePath);
	%>
	<%@include file="/comm/ftptrans6.jsp" %>
	<%
	}
	
	sqlMap.delete("galleryStorageDelete", idCode);
	
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBoardURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), divisionCode, accessCode);
	response.sendRedirect(goURL);
%>	

