<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String title  = request.getParameter("title");
	String content  = request.getParameter("content");
	String skin  = request.getParameter("skin");
	String width  = request.getParameter("width");
	String height  = request.getParameter("height");
	String top  = request.getParameter("top");
	String left  = request.getParameter("left");
	String style  = request.getParameter("style");

	String start_date  = request.getParameter("start_date");
	String end_date  = request.getParameter("end_date");

	String is_view  = request.getParameter("is_view");
	String is_main  = request.getParameter("is_main");
	String is_sub  = request.getParameter("is_sub");
	String is_pc  = (request.getParameter("is_pc") != null ? request.getParameter("is_pc") :"N");
	String is_pv  = (request.getParameter("is_pv") != null ? request.getParameter("is_pv") :"N");
	String is_wp  = (request.getParameter("is_wp") != null ? request.getParameter("is_wp") :"N");
	String is_wj  = (request.getParameter("is_wj") != null ? request.getParameter("is_wj") :"N");
	String is_nc  = (request.getParameter("is_nc") != null ? request.getParameter("is_nc") :"N");
	String is_yr  = (request.getParameter("is_yr") != null ? request.getParameter("is_yr") :"N");
	
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");

	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");

	if (skin == null){
		skin = "blank.gif";
	}
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
 
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	
	map.put("title", title);
	map.put("content", content);
	map.put("skin", skin);
	map.put("width", width);
	map.put("height", height);
	map.put("top", top);
	map.put("left", left);
	map.put("style", style);
	
	map.put("start_date", start_date);
	map.put("end_date", end_date);
		
	map.put("is_view", is_view);
	map.put("is_main", is_main);
	map.put("is_sub", is_sub);
	map.put("is_pc", is_pc);
	map.put("is_pv", is_pv);
	map.put("is_wp", is_wp);
	map.put("is_wj", is_wj);
	map.put("is_nc", is_nc);
	map.put("is_yr", is_yr);
	map.put("docNumber", docNumber);
	
	sqlMap.update("popupUpdate", map);
	
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