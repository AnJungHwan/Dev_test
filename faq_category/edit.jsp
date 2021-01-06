<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String category_name  = request.getParameter("category_name");
	String division_name  = request.getParameter("division_name");
	
	String globalMenu = request.getParameter("global_menu");
	String localMenu = request.getParameter("local_menu");
	String dbName = request.getParameter("db");
	String pageNumber = request.getParameter("page");
	String docNumber = request.getParameter("doc");
	
	String  division_code = null;
	
	if (division_name.equals("공통")){
		division_code="AL";
	}
	else if(division_name.equals("파인크리크")){
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
	 
	AclDataObject acldataobj = new AclDataObject();
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", "faq");
	aclmap.put("accessCode", sessionSuperuserDivisionCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	isAccess  = acldataobj.getIs_access();
	
	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	
	
	//DB  입력
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("category_name",category_name);
	map.put("division_name", division_name);
	map.put("division_code", division_code);
	map.put("docNumber", docNumber);
	
	sqlMap.update("faqCategoryUpdate", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber));
	response.sendRedirect(goURL);

	
%>
