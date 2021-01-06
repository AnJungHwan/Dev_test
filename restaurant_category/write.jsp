<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String  category_name = request.getParameter("category_name");
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	String  accessCode = request.getParameter("code");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	AclDataObject acldataobj = new AclDataObject();
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", "restaurant");
	aclmap.put("accessCode", sessionSuperuserDivisionCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	isAccess  = acldataobj.getIs_access();
	
	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	Map map = new HashMap();
	
	map.put("category_name", category_name);
	
	sqlMap.insert("restaurantCategoryInsert", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber));
	response.sendRedirect(goURL);
%>
