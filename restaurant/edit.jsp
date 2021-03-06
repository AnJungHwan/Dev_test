<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import = "javax.imageio.ImageIO"%>
<%@ page import = "java.awt.image.BufferedImage"%>
<%@ page import = "java.awt.Image"%>
<%@ page import = "javax.swing.ImageIcon"%>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String title  = request.getParameter("title");
	String content  = request.getParameter("content");
	String  division_name = request.getParameter("division_name");
	String  is_view = request.getParameter("is_view");
	String  is_popup = request.getParameter("is_popup");
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");
	String  attach_filename = request.getParameter("attach_filename");
	String  category_name = request.getParameter("category_name");
	String  price = request.getParameter("price");
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	String  accessCode = request.getParameter("code");
	
	String  division_code = null;
	String  category_code = null;
	
	int width = 0;
	int height = 0;
	
	if(division_name.equals("파인크리크")){
		division_code="PC";
	}
	else if(division_name.equals("파인밸리")){
		division_code="PV";
	}
	else if(division_name.equals("웨스트파인")){
		division_code="WP";
	}
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	
	category_code   = (String)sqlMap.queryForObject("restaurantCategoryGetCode", category_name);
	
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
		if  (!attach_filename.equals("")){ // 기존 첨부 파일이 있음
			File  deletefile  = new  File(savedir  + attach_filename);
			File  thumbfile  = new  File(savedir  + "thumb_" + attach_filename);
			out.println(savedir  + attach_filename);
			deletefile.delete();
			thumbfile.delete();
			
			%>
			<%
				String dFile_name = attach_filename;
				String dSavePath = savedir;
				String dFile_name2 = "thumb_" + attach_filename;
				
				//System.out.println("dFile_name :: " + dFile_name);
				//System.out.println("dSavePath :: " + dSavePath);
			%>
			<%@include file="/comm/ftptrans4.jsp" %>
			<%
			
		}
		
		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][3]);
		for(int i=0;objarr!=null&&i<objarr.length;i++){
			File file = new File(savedir + objarr[i][1]);	
			file = policy.rename(file);
			copyFileAbs((File)objarr[i][0],file);

			((File)objarr[i][0]).delete();
			attach_filename  =  file.getName() ;
			BufferedImage bi = ImageIO.read(file);
			width = bi.getWidth();
			height = bi.getHeight();
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
		String originalFile  = savedir  + attach_filename;
		String  thumbFile  = savedir  + "thumb_" + attach_filename;;
		
		
		CreateThumbnail thumb  = new  CreateThumbnail();
		if (width > 600) {
			thumb.convert(originalFile,originalFile, 600);
		}	
		thumb.convert(originalFile,thumbFile, 200);
		
		%>
		<%
		
		 	String tFile_name = attach_filename;
			String tSavePath = savedir;
			String tFile_name2 = "thumb_" + attach_filename;
			
			//System.out.println("tFile_name :: " + tFile_name);
			//System.out.println("tSavePath :: " + tSavePath);
			//System.out.println("tFile_name :: " + tFile_name2);
		%>
		<%@include file="/comm/ftptrans3.jsp" %> 
		<%
	}
	
	
	
	//DB  입력
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("title",title);
	map.put("content",content);
	map.put("division_name", division_name);

	if  (!attach_filename.equals("")){
		map.put("checkValue", attach_filename);
		//out.println("check");
	}	
	
	map.put("division_code", division_code);
	map.put("is_view", is_view);
	map.put("category_code", category_code);
	map.put("category_name", category_name);
	map.put("price", price);
	map.put("docNumber", docNumber);
	
	sqlMap.update("restaurantUpdate", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForRestaurantURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), division_code, accessCode, category_code);
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