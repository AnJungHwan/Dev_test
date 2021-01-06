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
%>
<jsp:useBean  id="superuserData" class="database.datadef.SuperuserDataObject" />
<jsp:setProperty  name="superuserData" property="superuser_id" />
<jsp:setProperty  name="superuserData" property="superuser_name" />
<jsp:setProperty  name="superuserData" property="superuser_pwd" />
<jsp:setProperty  name="superuserData" property="email" />
<jsp:setProperty  name="superuserData" property="telephone" />
<jsp:setProperty  name="superuserData" property="position" />
<jsp:setProperty  name="superuserData" property="division" />
<jsp:setProperty  name="superuserData" property="team" />
<jsp:setProperty  name="superuserData" property="access_level" />

<%

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
	
	SuperuserDataObject dataobj = new SuperuserDataObject();
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	
	dataobj = (SuperuserDataObject) sqlMap.queryForObject("superuserCheck", superuserData.getSuperuser_id());
	if ( dataobj != null){ 
		
		out.println("<script>alert('아이디가 존재 합니다.');history.back();</script>"); 
	}
	else {
		// 관리자 DB에서 입력외에 모자란 데이터를 만듬
		// 현재  날짜와  시간, 아이피 어드레스를 구함
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

		java.util.Date date = new java.util.Date();
		String currentDate = dateFormatter.format(date);
		String currentTime = timeFormatter.format(date);

		String ipAddress = request.getRemoteAddr();

		superuserData.setIpaddress(ipAddress);
		superuserData.setCreate_date(currentDate);
		superuserData.setCreate_time(currentTime);
	
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
	
	
		// 관리자  데이터  입력
		sqlMap.insert("superuserInsert", superuserData);
	
		// 접근권한 데이터 입력
	
		Map map = new HashMap();
		if  (superuserData.getAccess_level().equals("SUPER")){
			// 슈퍼 관리자일 경우  사업장별로 11개의 메뉴에 모든 권한을 부여한다.(모든 권한:1)	
			for(int  i=0; i  < divisionArray.length; i++){
				for(int  j=0; j  < dbArray.length; j++){
					map.put("superuser_id",superuserData.getSuperuser_id());
					map.put("division_name", divisionArray[i][0]);
					map.put("division_code", divisionArray[i][1]);
					map.put("db_name", dbArray[j]);
					map.put("is_access", "1");
					sqlMap.insert("aclInsert", map);
					map.clear();
				}
			}
		}			
		else{
			for(int  i=0; i  < divisionArray.length; i++){
				if (division_name.equals(divisionArray[i][0])){ // 권한 부여 받은 사업장과 같을 경우
					for(int  j=0; j  < dbArray.length; j++){
						map.put("superuser_id",superuserData.getSuperuser_id());
						map.put("division_name", divisionArray[i][0]);
						map.put("division_code", divisionArray[i][1]);
						map.put("db_name", dbArray[j]);
						map.put("is_access", isAccessArray[j]);
						sqlMap.insert("aclInsert", map);
						map.clear();
					}
				}
				else{ // 사업장이 다를경우 권한을 없앴다 (권한 없음:0)
					for(int  j=0; j  < dbArray.length; j++){
						map.put("superuser_id",superuserData.getSuperuser_id());
						map.put("division_name", divisionArray[i][0]);
						map.put("division_code", divisionArray[i][1]);
						map.put("db_name", dbArray[j]);
						map.put("is_access", "0");
						sqlMap.insert("aclInsert", map);
						map.clear();
					}
				}
			}
		}
		
		
		response.sendRedirect("/baas/index.jsp?global_menu=4&local_menu=1&db=superuser&cmd=viewlist&page=1");
	}
%>	

