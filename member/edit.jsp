<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.SuperuserDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>

<% 
	request.setCharacterEncoding("euc-kr");
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	String superuser_id = request.getParameter("superuser_id");
	String superuser_pwd = request.getParameter("superuser_pwd");
	String email = request.getParameter("email");
	String telephone = request.getParameter("telephone");
	String position = request.getParameter("position");
	String division = request.getParameter("division");
	String team = request.getParameter("team");
	String access_level = request.getParameter("access_level");
	

	String division_name = request.getParameter("division_name");
	String restaurant = (request.getParameter("restaurant") != null  ? request.getParameter("restaurant") : "0");
	String proshop = (request.getParameter("proshop") != null  ? request.getParameter("proshop") : "0");
	String notice = (request.getParameter("notice") != null  ? request.getParameter("notice") : "0");
	String event = (request.getParameter("event") != null  ? request.getParameter("event") : "0");
	String news = (request.getParameter("news") != null  ? request.getParameter("news") : "0");
	String gallery = (request.getParameter("gallery") != null  ? request.getParameter("gallery") : "0");
	String faq = (request.getParameter("faq") != null  ? request.getParameter("faq") : "0");
	String pds = (request.getParameter("pds") != null  ? request.getParameter("pds") : "0");
	String banner =(request.getParameter("banner") != null  ? request.getParameter("banner") : "0");
	String popup = (request.getParameter("popup") != null  ? request.getParameter("popup") : "0");
	String booking = (request.getParameter("booking") != null  ? request.getParameter("booking") : "0");
	String webzine = (request.getParameter("webzine") != null  ? request.getParameter("webzine") : "0");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	
	Map sumap = new HashMap();
	sumap.put("superuser_id", superuser_id);
	sumap.put("superuser_pwd", superuser_pwd);
	sumap.put("email", email);
	sumap.put("telephone", telephone);
	sumap.put("position", position);
	sumap.put("division", division);
	sumap.put("team", team);
	
	sqlMap.update("superuserUpdate", sumap);

	if  (access_level.equals("MANAGER"))		{
	// Access값을  배열에 집어 넣는다.
	String isAccessArray[] = new String[12] ;
	isAccessArray[0] = restaurant;
	isAccessArray[1] = proshop;
	isAccessArray[2] = notice;
	isAccessArray[3] = event;
	isAccessArray[4] = news;
	isAccessArray[5] = gallery;
	isAccessArray[6] = faq;
	isAccessArray[7] = pds;
	isAccessArray[8] = banner;
	isAccessArray[9] = popup;
	isAccessArray[10] = booking;
	isAccessArray[11] = webzine;
	
	// 배열 세팅
	String [][] divisionArray = new String[][]{{"동양레저","TL"},{"파인크리크","PC"},{"파인밸리","PV"},{"웨스트파인","WP"},{"F&B","NC"}};
	
	String  [] dbArray  = new  String[]{"restaurant","proshop", "notice", "event", "news", "gallery", "faq", "pds", "banner", "popup", "booking","webzine"};

	// 접근권한 데이터 수정
		Map map = new HashMap();
		for(int  i=0; i  < divisionArray.length; i++){
			if (division_name.equals(divisionArray[i][0])){ // 권한 부여 받은 사업장과 같을 경우
				for(int  j=0; j  < dbArray.length; j++){
					map.put("superuser_id",superuser_id);
					map.put("division_name", divisionArray[i][0]);
					map.put("division_code", divisionArray[i][1]);
					map.put("db_name", dbArray[j]);
					map.put("is_access", isAccessArray[j]);
					//out.println("OK:"+superuser_id+"/"+divisionArray[i][0] +"/"+ divisionArray[i][1] +"/"+ dbArray[j] +"/"+ isAccessArray[j] +"<br>");
					sqlMap.update("aclUpdate", map);
					map.clear();
				}
			}
			else{ // 사업장이 다를경우 권한을 없앴다 (권한 없음:0)
				for(int  j=0; j  < dbArray.length; j++){
					map.put("superuser_id",superuser_id);
					map.put("division_name", divisionArray[i][0]);
					map.put("division_code", divisionArray[i][1]);
					map.put("db_name", dbArray[j]);
					map.put("is_access", "0");
					//out.println(superuser_id+"/"+divisionArray[i][0] +"/"+ divisionArray[i][1] +"/"+ dbArray[j] +"/0<br>");
					sqlMap.update("aclUpdate", map);
					map.clear();
				}
			}
		}
	}
	out.println("<script>alert('수정 되었습니다.');</script>");
	response.sendRedirect("/baas/index.jsp?global_menu=4&local_menu=1&db=superuser&cmd=viewlist&page=1");
	
%>	

