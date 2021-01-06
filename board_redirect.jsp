<%@ page language="java" contentType="text/html; charset=EUC-KR"    pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%

	request.setCharacterEncoding("euc-kr");	
	String  uri = request.getParameter("uri");
	
	String folder = null;
	String goURI = null;
	
	String splitChar ="/";
	
	String[] uriArray = uri.split(splitChar); 
	
	if (uriArray[1].equals("PC")){
		folder = "/02_pine/";
	}
	else if (uriArray[1].equals("PV")){
		folder = "/03_pinevalley/";
	}
	else if (uriArray[1].equals("WP")){
		folder = "/04_westpine/";
	}
	
	goURI = folder + uriArray[0] + "_view.jsp?div=" + uriArray[1] +  "&page=1&doc=" + uriArray[2];
	
	response.sendRedirect(goURI);

	
	
%>