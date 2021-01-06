<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@include  file="/baas/include/value.jsp" %>


<jsp:forward page="/baas/controller.jsp">     
	
	<jsp:param name="global_menu" value="<%=globalMenu %>" />
	<jsp:param name="local_menu" value="<%=localMenu%>" />
	
	<jsp:param name="page" value="<%=pageNumber%>" />
	<jsp:param name="doc" value="<%=docNumber%>" />
	
	<jsp:param name="db" value="<%=dbName%>" />
	<jsp:param name="cmd" value="<%=commandName%>" />
	
	<jsp:param name="div" value="<%=divisionCode%>" />
	<jsp:param name="code" value="<%=accessCode%>" />
	<jsp:param name="category" value="<%=categoryCode%>" />
	
</jsp:forward> 

