<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.FaqDataObject"  %>
<%@ page import="database.datadef.FaqCategoryDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String title  = request.getParameter("title");
	String content  = request.getParameter("content");
	String  division_name = request.getParameter("division_name");
	String  category_name = request.getParameter("category_name");
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");
	
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	String  accessCode = request.getParameter("code");
	
	String  division_code = null;
	String  category_code = null;
	
	if(division_name.equals("파인크리크")){
		division_code="PC";
	}
	else if(division_name.equals("파인밸리")){
		division_code="PV";
	}
	else if(division_name.equals("웨스트파인")){
		division_code="WP";
	}
	else if(division_name.equals("F&B")){
		division_code="NC";
	}
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	category_code   = (String)sqlMap.queryForObject("faqCategoryGetCode", category_name);
	 
	AclDataObject acldataobj = new AclDataObject();
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", dbName);
	aclmap.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	//isAccess  = acldataobj.getIs_access();
	isAccess = 1;

	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	
	
	Map map = new HashMap();

	map.put("tableName","tb_" + dbName);
	map.put("title",title);
	map.put("content",content);
	map.put("division_name", division_name);
	map.put("division_code", division_code);
	map.put("category_name", category_name);
	map.put("category_code", category_code);
	
	map.put("docNumber", docNumber);
	
	sqlMap.update("faqUpdate", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBoardURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), division_code, accessCode);
	response.sendRedirect(goURL);

%>
