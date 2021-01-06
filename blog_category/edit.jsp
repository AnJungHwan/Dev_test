<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}	

	request.setCharacterEncoding("euc-kr");	
	
	String category_name  = request.getParameter("category_name");
	String view_type  = request.getParameter("view_type");
	String  menu_filename = request.getParameter("menu_filename");
	String  title_filename = request.getParameter("title_filename");
	
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	
	String[]  attach_filename = new String[2];
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	
		
	DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
	ArrayList alist = (ArrayList)application.getAttribute(session.getId());
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	
	String  savedir  = uploaddir + dbName +"/";
	
	
	makeDir(savedir);
	
	if(alist != null){
		
		String dFile_name = "";
		String dSavePath = "";
	
		if  (!menu_filename.equals("")){ // 기존 첨부 파일이 있음
			File  deletemenufile  = new  File(savedir  + menu_filename);
			deletemenufile.delete();
			
			%>
			<%
				dFile_name = menu_filename;
				dSavePath = savedir;
				
				//System.out.println("dFile_name :: " + dFile_name);
				//System.out.println("dSavePath :: " + dSavePath);
			%>
			<%@include file="/comm/ftptrans2.jsp" %>
			<%
			
		}
		if  (!title_filename.equals("")){ // 기존 첨부 파일이 있음
			File  deletetitlefile  = new  File(savedir  + title_filename);
			deletetitlefile.delete();
			
			%>
			<%
				dFile_name = title_filename;
				dSavePath = savedir;
				
				//System.out.println("dFile_name :: " + dFile_name);
				//System.out.println("dSavePath :: " + dSavePath);
			%>
			<%@include file="/comm/ftptrans2.jsp" %>
			<%
			
		}
		
		ArrayList filenameList = new ArrayList();
		ArrayList filenameList2 = new ArrayList();
		
		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][3]);
		for(int i=0;objarr!=null&&i<objarr.length;i++){
			//out.println(objarr[i][0]);//업로드 파일객체(임시 폴더에 올라온 파일명- 폴더포함)
			//out.println(objarr[i][1]);//원래파일명()
			//out.println(objarr[i][2]);//저장된파일명(파일사이즈)
			File file = new File(savedir + objarr[i][1]);	
			file = policy.rename(file);//최종저장될 폴더에 이미 같은 이름이 있으면 자동으로 끝에 숫자를 붙임.
			copyFileAbs((File)objarr[i][0],file);//최종으로 저장폴더에 파일을 복사함.

			((File)objarr[i][0]).delete();//임시폴더에서 업로드 파일을 삭제함.
			
			attach_filename[i]  =  file.getName() ;
			out.println(attach_filename[i]);
			
			filenameList.add(file.getName());
		}	
		File trashfile  = new  File(uploaddir);
		File[] trashfiles  = trashfile.listFiles();
		if  (trashfiles  != null) {
			for (int  i=0; i< trashfiles.length; i++){
				if  (!trashfiles[i].isDirectory()){
					trashfiles[i].delete();
				}
			}
		}	
		application.removeAttribute(session.getId());
		
		
		%>
		<%
			ArrayList tFile_nameList = filenameList;
			ArrayList tFile_nameList2 = filenameList2;
			String tSavePath = savedir;
			
			//System.out.println("tFile_name :: " + tFile_nameList.get(0));
			//System.out.println("tFile_name2 :: " + tFile_nameList.get(1));
			//System.out.println("tFile_name :: " + tFile_nameList2.get(0));
			//System.out.println("tFile_name2 :: " + tFile_nameList2.get(1));
			//System.out.println("tSavePath :: " + tSavePath);
		%>
		<%@include file="/comm/ftptrans5.jsp" %>
		<%
		
	}
	
	
	
	//DB  입력
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("category_name",category_name);
	
	if  (!menu_filename.equals("")){
		map.put("menu_filename", attach_filename[0]);
	}	

	if  (!title_filename.equals("")){
		map.put("title_filename", attach_filename[1]);
	}	
	map.put("view_type", view_type);
	map.put("docNumber", docNumber);
	
	sqlMap.update("clubCategoryUpdate", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber));
	response.sendRedirect(goURL);

	
%>
<%!
public void makeDir(String savedir) throws Exception{
	java.io.File dir=new java.io.File(savedir);
	if(!dir.exists()){	dir.mkdirs();	}
}
public static String ko(String s){
	if(s==null)return "";
	try{
		s = new String(s.getBytes("8859_1"),"euc-kr");
	}catch(Exception e){}
	return s;
}
public void copyFileAbs(java.io.File src, java.io.File dst) throws java.io.IOException {    	
	java.io.InputStream in = new java.io.FileInputStream(src);
	java.io.OutputStream out = new java.io.FileOutputStream(dst);
	
	byte[] buf = new byte[1024];
	int len;
	while ((len = in.read(buf)) > 0) {
		out.write(buf, 0, len);
	}
	in.close();
	out.close();
}
%>