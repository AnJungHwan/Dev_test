<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@include  file="/baas/include/session.jsp" %>
<% 
	request.setCharacterEncoding("euc-kr");
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}

	String superuser_id = request.getParameter("superuser_id");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	
	sqlMap.delete("superuserDelete", superuser_id);
	
	sqlMap.delete("aclDelete", superuser_id);
	
	out.println("<script>alert('���� �Ǿ����ϴ�.');</script>");
	response.sendRedirect("/baas/index.jsp?global_menu=4&local_menu=1&db=superuser&cmd=viewlist&page=1");
	
%>	

