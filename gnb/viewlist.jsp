<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.GnbDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script type="text/javascript" src="http://dev.jquery.com/view/trunk/plugins/treeview/jquery.treeview.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	
});
//-->
</script>

<%
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}		
	
%>

<br>
<table class="normal">	
<tr>
	<td style="text-align:left;" >
 
	</td>
	<td style="text-align:right;" >
	
	<%
	StringUtility strobj = new StringUtility();
	String goURL="";
	goURL = strobj.generateURL(globalMenu, localMenu, dbName, "readxml", pageNumber);
	%>
	
	</td>
</tr>
</table><br><br>
 <table class="list">	
<tr>
	<td><span class="button large icon"><span class="check"></span><a href="<%=goURL%>">메뉴  XML 수정</a></span></td>
	</tr>
</table><br><br>

