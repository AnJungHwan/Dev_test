<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

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
	
	
	String  category_code =null;
	String  division_code = null;

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
//	isAccess  = acldataobj.getIs_access();
	isAccess = 1;
	
	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
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
	map.put("division_name", division_name);
	map.put("division_code", division_code);
	map.put("category_name", category_name);
	map.put("category_code", category_code);
	
	
	sqlMap.insert("faqInsert", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBoardURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), division_code, accessCode);
	response.sendRedirect(goURL);
%>
