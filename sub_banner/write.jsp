<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import = "javax.imageio.ImageIO"%>
<%@ page import = "java.awt.image.BufferedImage"%>
<%@ page import = "java.awt.Image"%>
<%@ page import = "javax.swing.ImageIcon"%>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}

	request.setCharacterEncoding("euc-kr");	

	String title  = request.getParameter("title");
	String link  = request.getParameter("link");
	String is_view  = request.getParameter("is_view");
	String  division_name = request.getParameter("division_name");
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");
	int width  = 0;
	int height  = 0;
	String location  = request.getParameter("location");
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  pageNumber = request.getParameter("page");
	
	String filename = null;
	
	String  division_code = null;
	String divisionFolder = null;
	
	if(division_name.equals("����ũ��ũ")){
		division_code="PC";
		divisionFolder = "/pinecreek/";
	}
	else if(division_name.equals("���ι븮")){
		division_code="PV";
		divisionFolder = "/pinevalley/";
	}
	else if(division_name.equals("����Ʈ����")){
		division_code="WP";
		divisionFolder = "/westpine/";
	}
	else  if (division_name.equals("������������")){
		division_code="WJ";
		divisionFolder = "/woonjung/";
	}
	else  if (division_name.equals("����ȣ")){
		division_code="YR";
		divisionFolder = "/youngrangho/";
	}
	else if(division_name.equals("F&B")){
		division_code="NC";
		divisionFolder = "/f_b/";
	}
	
	
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
	ArrayList alist = (ArrayList)application.getAttribute(session.getId());
	
	if(alist == null){
		out.println("<script>alert('���  ������  �����ϴ�.');history.back();</script>");
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
	
	String  savedir  = uploaddir + dbName + divisionFolder  ;
	
	makeDir(savedir);

	if(alist != null){
		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][3]);
		
		for(int i=0;objarr!=null&&i<objarr.length;i++){
			File file = new File(savedir + objarr[i][1]);	
			file = policy.rename(file);
			copyFileAbs((File)objarr[i][0],file);

			((File)objarr[i][0]).delete();         
			filename  =  file.getName() ;
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
	
	// ����  ��¥��  �ð�, ������ ��巹���� ����
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

	java.util.Date date = new java.util.Date();
	String currentDate = dateFormatter.format(date);
	String currentTime = timeFormatter.format(date);

	
	Map map = new HashMap();
	map.put("user_id", user_id);
	map.put("user_name", user_name);
	map.put("title", title);
	map.put("filename", filename);
	map.put("width", Integer.toString(width));
	map.put("height",  Integer.toString(height));
	
	map.put("link", link);
	map.put("is_view", is_view);
	map.put("division_name", division_name);
	map.put("division_code", division_code);
	map.put("write_date", currentDate);
	map.put("write_time", currentTime);
	map.put("target", "_blank");
	map.put("location", location);
	sqlMap.insert("subBannerInsert", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBannerURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), division_code);
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