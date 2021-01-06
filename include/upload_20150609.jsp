<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
/*
작성자 : 박찬연(realcool@empal.com)
설  명 : 플래시로 부터 파일을 임시저장폴더에 저장합니다.
         플래시에서 폼값을 받을때 utf-8로 받아야 합니다.
*/


try{
	String browser_id = request.getParameter("browser_id");
	if(browser_id==null || browser_id.trim().length()==0){
		return;
	}
	String savedir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		savedir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		savedir = "c:/upload/";
	}
	
	makeDir(savedir);
	MultipartRequest multi=new MultipartRequest(request, savedir,1024*1024*100, "utf-8", new DefaultFileRenamePolicy());


	File file = multi.getFile("Filedata");
	if(file==null)return;
	String originFileName = multi.getOriginalFileName("Filedata");
	long filesize = file.length();
	ArrayList alist = (ArrayList)application.getAttribute(browser_id);
	if(alist==null){
		alist = new ArrayList();
	}
	application.setAttribute(browser_id,alist);

	Object[] objarr = new Object[3];
	objarr[0] = file;
	objarr[1] = originFileName;
	objarr[2] = new Long(filesize);

	alist.add(objarr);
}catch(Exception e){
	e.printStackTrace();
}
%>
<%!
public void makeDir(String savedir) throws Exception{
	java.io.File dir=new java.io.File(savedir);
	if(!dir.exists()){	dir.mkdirs();	}
}
%>