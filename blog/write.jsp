<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}	
	
	request.setCharacterEncoding("euc-kr");	
	
	String title  = request.getParameter("title");
	String content  = request.getParameter("content");
	String  is_view = request.getParameter("is_view");
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");
	
	String  category_name = request.getParameter("category_name");
	String  summary = request.getParameter("summary");
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");

	
	String  attach_filename =null;
	String  category_code = null;
	
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	category_code   = (String)sqlMap.queryForObject("clubCategoryGetCode", category_name);
	
	out.println(category_code);
	
	DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
	ArrayList alist = (ArrayList)application.getAttribute(session.getId());
	
	if(alist == null){
		out.println("<script>alert('대표  이미지  파일이  없습니다.');history.back();</script>");
		return;
	}
	
	
	
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
		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][3]);
		for(int i=0;objarr!=null&&i<objarr.length;i++){
			File file = new File(savedir + objarr[i][1]);	
			file = policy.rename(file);                            //최종저장될 폴더에 이미 같은 이름이 있으면 자동으로 끝에 숫자를 붙임.
			copyFileAbs((File)objarr[i][0],file);                //최종으로 저장폴더에 파일을 복사함.

			((File)objarr[i][0]).delete();                        //임시폴더에서 업로드 파일을 삭제함.
			attach_filename  =  file.getName() ;
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
		
		CreateThumbnail thumb  = new  CreateThumbnail();
		thumb.convert(originalFile,originalFile, 150);
		
		%>
		<%
			String tFile_name = attach_filename;
			String tSavePath = savedir;
			
			//System.out.println("tFile_name :: " + tFile_name);
			//System.out.println("tSavePath :: " + tSavePath);
		%>
		<%@include file="/comm/ftptrans.jsp" %>
		<%
		
	}

	// 현재  날짜와  시간, 아이피 어드레스를 구함
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

	java.util.Date date = new java.util.Date();
	String currentDate = dateFormatter.format(date);
	String currentTime = timeFormatter.format(date);
	
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("seqTableName", "tb_"+ dbName +"_seq");
	
	map.put("user_id", user_id);
	map.put("user_name", user_name);
	map.put("title", title);
	map.put("content", content);
	map.put("hitcount", "1");
	map.put("write_date", currentDate);
	map.put("write_time", currentTime);
	map.put("attach_filename", attach_filename);
	map.put("is_view", is_view);
	map.put("category_name", category_name);
	map.put("category_code", category_code);
	map.put("summary", summary);
	
	
	sqlMap.insert("clubInsert", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBlogURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), category_code);
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