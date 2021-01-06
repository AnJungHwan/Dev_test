<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.MainBannerDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@include  file="/baas/include/session.jsp" %>
<%
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}

	request.setCharacterEncoding("euc-kr");
	
	
	String docNumber = request.getParameter("doc");
	String menuCode = request.getParameter("menu");
	String largeIndex = request.getParameter("large");
	String mediumIndex = request.getParameter("medium");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	Map map = new HashMap();
	
	if  (menuCode.equals("1")) {
		sqlMap.delete("gnbTopDelete", largeIndex);
		
	}
	if  (menuCode.equals("2")) {
		map.put("largeIndex",largeIndex);
		map.put("mediumIndex", mediumIndex);
		sqlMap.delete("gnbParentDelete", map);
	}
	sqlMap.delete("gnbDelete", docNumber);
	
	
%>	

