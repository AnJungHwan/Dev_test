<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import = "javax.imageio.ImageIO"%>
<%@ page import = "java.awt.image.BufferedImage"%>
<%@ page import = "java.awt.Image"%>
<%@ page import = "javax.swing.ImageIcon"%>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}	

	request.setCharacterEncoding("euc-kr");	
	
	String title  = request.getParameter("title");
	String is_view  = request.getParameter("is_view");
	String  filename = request.getParameter("filename");
	
	String width =  request.getParameter("width");
	String height = request.getParameter("height");
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	
	
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
		if  (!filename.equals("")){ // ���� ÷�� ������ ����
			File  deletemenufile  = new  File(savedir  + filename);
			deletemenufile.delete();
			
			%>
			<%
				String dFile_name = filename;
				String dSavePath = savedir;
				
				//System.out.println("dFile_name :: " + dFile_name);
				//System.out.println("dSavePath :: " + dSavePath);
			%>
			<%@include file="/comm/ftptrans2.jsp" %>
			<%
		}
		
		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][3]);
		for(int i=0;objarr!=null&&i<objarr.length;i++){
			
			File file = new File(savedir + objarr[i][1]);	
			file = policy.rename(file);
			copyFileAbs((File)objarr[i][0],file);//�������� ���������� ������ ������.

			((File)objarr[i][0]).delete();
			
			filename  =  file.getName() ;
			BufferedImage bi = ImageIO.read(file);
			width = Integer.toString(bi.getWidth());
			height = Integer.toString(bi.getHeight());
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
			String tFile_name = filename;
			String tSavePath = savedir;
			
			//System.out.println("tFile_name :: " + tFile_name);
			//System.out.println("tSavePath :: " + tSavePath);
		%>
		<%@include file="/comm/ftptrans.jsp" %>
		<%
	}
	
	
	
	//DB  �Է�
	Map map = new HashMap();
	
	map.put("title",title);
	
	if  (!filename.equals("")){
		map.put("filename", filename);
	}	
	map.put("is_view", is_view);
	map.put("width", width);
	map.put("height",  height);
	map.put("docNumber", docNumber);
	
	sqlMap.update("popupSkinUpdate", map);
	
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