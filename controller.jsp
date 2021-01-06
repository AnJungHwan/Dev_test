<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="/baas/css/common.css" />
<link rel="stylesheet" type="text/css" href="/baas/css/button.css" />
<link rel="stylesheet" type="text/css" href="/baas/css/btn.css" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>동양레저-관리자  화면</title>

</head>
<body>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ page import="database.datadef.MenuDataObject"  %>
<%@ page import="common.utility.StringUtility"  %>

<%
	//session.setAttribute("superuser_id", "superuser");
//	session.setAttribute("superuser_name", "관리자");
//	session.setAttribute("access_level", "SUPER");
	//session.setAttribute("division_name", "동양레저");
//	session.setAttribute("division_code", "TL");


	if(session.getAttribute("superuser_id")==null){
		response.sendRedirect("/baas/login/loginform.jsp");
		return;
	}
%>
<%@include  file="/baas/include/value.jsp" %>
<%@include  file="/baas/include/session.jsp" %>

<div id="header">
	<div id="companyLogo">
		<img src=/baas/images/tyleisure_logo.gif>
	</div>	
	<div id="homeLink">
		<a href=/baas/index.jsp>HOME</a> | 
		<a href=/baas/login/logout.jsp>로그아웃</a><br>
	</div>	
	<div id="globalNavigationBar">
	
	<%
		StringUtility strobj = new StringUtility();	
		String goURL="";
		
		String [][] globalMenuArray = null;
		
		if (sessionSuperuserAccessLevel.equals("SUPER")){
			globalMenuArray =new String[][]{
				{"로그인 정보",""},{"시설물  관리","restaurant"},
				{"클럽 소식","notice"},{"고객 센터","faq"},
				{"운영자 관리","superuser"},{"배너 관리","main_banner"},
				{"팝업 관리","popup"}, {"블로그  관리", "club"}, {"컨텐츠  관리", "gnb"}
			};
		}
		else {
			globalMenuArray =new String[][]{
				{"로그인 정보",""},{"시설물  관리","restaurant"},
				{"클럽 소식","notice"},{"고객 센터","faq"},
			};
		}
		String tmp="";
		for  (int i = 1; i  < globalMenuArray.length ; i++) {
			if  (globalMenu != i){
				tmp = strobj.generateURL(i, 1, globalMenuArray[i][1], "viewlist", 1);
				out.println("<a href=" + tmp +">");
			}
			else{
				goURL = strobj.generateURL(i, 1, globalMenuArray[i][1], "viewlist", 1);
			}
			out.println(globalMenuArray[i][0]);
			
			if  (globalMenu != i) {		
				out.println("</a>");
			}	
			if  (i < (globalMenuArray.length-1)) {
				out.println("|");
			}	
		}
	%>
	</div>
</div> 


<div id="bodies">
	<div id="localNavigationBar"> 
	<center><br>
	<%
		//java.util.Date date = new java.util.Date();
		//SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		//SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");
		//String currentDate = dateFormatter.format(date);
		//String currentTime = timeFormatter.format(date);
	%>
	<table class="smallbox">
	<tr>
		<th><%=globalMenuArray[globalMenu][0] %></th>
	</tr>
		
	</table><br>
	<%
		// 서브  메뉴  트리  구성 - tb_menu에서  불러움
		SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();	
		List menuList = new ArrayList();
	
		
		menuList = sqlMap.queryForList("getLocalMenu", Integer.toString(globalMenu));
		String dbType=null;
		String currentTitle=null;
		for(int i=0; i < menuList.size(); i++){
			MenuDataObject dataobj = (MenuDataObject) menuList.get(i);
			
			goURL = strobj.generateURL(dataobj.getGlobal_menu(), dataobj.getLocal_menu(), dataobj.getDb_name(), "viewlist", 1);
			
			if (localMenu == dataobj.getLocal_menu()){
				out.println(" ▶ " + dataobj.getLocal_title() + "<br><br>");
				dbType = dataobj.getDb_type();
				currentTitle = dataobj.getLocal_title();
			}
			else {
				out.println("<a href="+ goURL +">" + dataobj.getLocal_title() + "</a><br><br>");
			}
		}	
			
	%>
	</center>
	</div>
	<div id="titlebar"><br>
		현재위치 :  <a href=/baas/index.jsp>Home</a>  
		<% 
			if  (currentTitle  != null) { 
		%>
		&lt; <%= currentTitle %>
		<%
			}
		%> &nbsp;&nbsp;<br>
		<hr align=right>
	</div> 

	<div id="section">
		<center>
		<% 
			String  goContentPage = null;
			if (dbType ==null){
				goContentPage  = "/baas/" + commandName  + ".jsp";
			}
			else{
				goContentPage  = "/baas/" + dbType + "/" + commandName  + ".jsp";
			}
		%>
		 <jsp:include page="<%=goContentPage %>" flush="false" /> 
		 <br><br>
		</center>		 
	</div>	
</div>

<div id="footer">
	<address>동양레저(c)</address>
</div>
</body>
</html>