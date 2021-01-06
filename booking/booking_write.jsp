<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.BookingDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>


<%

	request.setCharacterEncoding("euc-kr");	
	

	String group_name  = request.getParameter("group_name");
	String choice_date1 = request.getParameter("choice_date1");
	String choice_date2 = request.getParameter("choice_date2");
	String choice_date3 = request.getParameter("choice_date3");
	String order_team = request.getParameter("order_team");
	String order_cnt = request.getParameter("order_cnt");
	String captain_name = request.getParameter("captain_name");
	String captain_id = request.getParameter("captain_id");
	String captain_hp = request.getParameter("captain_hp");
	String manager_name = request.getParameter("manager_name");
	String manager_id = request.getParameter("manager_id");
	String manager_hp = request.getParameter("manager_hp");
	String order_name = request.getParameter("order_name");
	String order_id = request.getParameter("order_id");
	String order_hp = request.getParameter("order_hp");
	String customer_tran = request.getParameter("customer_tran");
	String agree_yn = request.getParameter("agree_yn");
	String division_name = request.getParameter("division_name");

	String division_code = null;

	
	
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

	// 현재  날짜와  시간, 아이피 어드레스를 구함
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

	java.util.Date date = new java.util.Date();
	String currentDate = dateFormatter.format(date);
	String currentTime = timeFormatter.format(date);
	
	Map map = new HashMap();
	map.put("tableName","tb_booking");
	map.put("seqTableName", "tb_booking_seq");
	map.put("group_name", group_name);
	map.put("choice_date1", choice_date1);
	map.put("choice_date2", choice_date2);
	map.put("choice_date3", choice_date3);
	map.put("order_team", order_team);
	map.put("order_cnt", order_cnt);
	map.put("captain_name", captain_name);
	map.put("captain_id", captain_id);
	map.put("captain_hp", captain_hp);
	map.put("manager_name", manager_name);
	map.put("manager_id", manager_id);
	map.put("manager_hp", manager_hp);
	map.put("order_name", order_name);
	map.put("order_id", order_id);
	map.put("order_hp", order_hp);
	map.put("customer_tran", customer_tran);
	map.put("agree_yn", agree_yn);
	map.put("write_date", currentDate);
	map.put("write_time", currentTime);
	map.put("division_name", division_name);
	map.put("division_code", division_code);
	
	sqlMap.insert("bookingInsert", map);
	
	
%>
