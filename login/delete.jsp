<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@include  file="/baas/include/session.jsp" %>
<%
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	sqlMap.delete("logInfoDelete");
	
	
%>	

