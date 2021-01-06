<%@ page contentType="text/html; charset=euc-kr" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="common.utility.StringUtility"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ include  file="/baas/include/session.jsp" %>

<%

	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}

	request.setCharacterEncoding("euc-kr");	

	String menu_name  = request.getParameter("menu_name");
	String menu_link  = request.getParameter("menu_link");
	String menu_node  = request.getParameter("menu_node");
	
	String parent_node  = request.getParameter("parent_node");
	String top_node  = request.getParameter("top_node");
	
	
	String link  = request.getParameter("link");
	String is_view  = "Y";
	String target  = request.getParameter("target");
	
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  pageNumber = request.getParameter("page");
	
	String menu_code = null;
	
	int  large_index  = 0;
	int  medium_index = 0;
	int  small_index = 0;
	int  parent_code = 0;
	int  top_code = 0;
	int  total_index =0;
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	
	Map map = new HashMap();
	
	if  (menu_node.equals("대분류")){
		menu_code  = "1";
		large_index = ((Integer)sqlMap.queryForObject("gnbGetMaxIndex", "large_index")).intValue();
		large_index  = (large_index == 0) ? 1 : large_index+1;
		
		parent_node  = "-";
		top_node ="-";
	}
	if  (menu_node.equals("중분류")){
		menu_code  = "2";
		
		// 대분류의  인덱스코드를  구한다.
		large_index = ((Integer)sqlMap.queryForObject("gnbGetLargeIndex", top_node)).intValue();
		top_code = large_index;
		map.put("search_field","medium_index");
		map.put("top_node", top_node);
		
		medium_index = ((Integer)sqlMap.queryForObject("gnbGetMediumMaxIndex", map)).intValue();
		medium_index  = (medium_index == 0) ? 1 : medium_index+1;
		parent_node ="-";
		map.clear();
		
	}
	if  (menu_node.equals("소분류")){
		menu_code  = "3";
		
		// 대분류의  인덱스코드를  구한다.
		large_index = ((Integer)sqlMap.queryForObject("gnbGetLargeIndex", top_node)).intValue();
		top_code = large_index;
		
		map.put("search_field","medium_index");
		map.put("top_node", top_node);
		map.put("parent_node", parent_node);
		medium_index = ((Integer)sqlMap.queryForObject("gnbGetMediumIndex", map)).intValue();
		parent_code  = medium_index;
		map.clear();
		
		map.put("search_field","small_index");
		map.put("top_node", top_node);
		map.put("parent_node", parent_node);
		
		small_index = ((Integer)sqlMap.queryForObject("gnbGetSmallMaxIndex", map)).intValue();
		small_index  = (small_index == 0) ? 1 : small_index+1;
		map.clear();
	}
	
	total_index =((Integer)sqlMap.queryForObject("gnbGetMaxIndex", "total_index")).intValue();
	total_index  = (total_index == 0) ? 1 : total_index+1;
	
	
	// 현재  날짜와  시간, 아이피 어드레스를 구함
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

	java.util.Date date = new java.util.Date();
	String currentDate = dateFormatter.format(date);
	String currentTime = timeFormatter.format(date);

	
	
	map.put("user_id", user_id);
	map.put("user_name", user_name);
	map.put("menu_name", menu_name);
	map.put("menu_link", menu_link);
	map.put("menu_node", menu_node);
	map.put("menu_code", menu_code);
	
	
	map.put("large_index", Integer.toString(large_index));
	map.put("medium_index",  Integer.toString(medium_index));
	map.put("small_index",  Integer.toString(small_index));
	
	map.put("parent_node", parent_node);
	map.put("parent_code", Integer.toString(parent_code));
	map.put("top_node", top_node);
	map.put("top_code", Integer.toString(top_code));
	
	map.put("write_date", currentDate);
	map.put("write_time", currentTime);
	map.put("total_index", Integer.toString(total_index));
	map.put("is_view", is_view);
	sqlMap.insert("gnbInsert", map);
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber));
	response.sendRedirect(goURL);

%>
