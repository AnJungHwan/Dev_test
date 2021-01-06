<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>


<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

<script language="JavaScript" type="text/JavaScript" src="/baas/js/swf_upload.js"></script>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var 	content = $('[name="content"]');
	var form = $('#formName');
	$.extend({
		submitForm : function() {
			 if( content.val() == '') {
				alert("내용을 입력하세요.");
				content.focus();
				return;
			}
			form.submit();	 
		}
	});
});
//-->
</script>
 <%
 	
 	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>");
		return;
	}
 
 	StringUtility strobj = new StringUtility();
 	String goURL="";
 %>
<div class="plate">
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/gnb/save.jsp"  id="formName">

<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:700px; text-align:left">
<%
	String  resourcePath = null;
 	
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		resourcePath  = "/app/homepage/tyleisure/htdocs/flash/menu.xml";
	}
	else {
		resourcePath = "c:/upload/flash/menu.xml";
	}
 	
	FileReader  fr  = new  FileReader(resourcePath);
	BufferedReader br = new  BufferedReader(fr);
	String line  = null;
%>	
	<textarea cols=120 rows=50 name="content">
<%
while((line=br.readLine()) !=null ) {
out.println(line);
}
%>
	</textarea>
	</td>
</tr>	
<tr><td class="line" colspan=2><hr></td></tr>
<tr><td colspan="2">
	<input type="hidden" name="db" value="<%= dbName%>">
	<input type="hidden" name="global_menu" value="<%= globalMenu%>">
	<input type="hidden" name="local_menu" value="<%= localMenu%>">
	<input type="hidden" name="page" value="<%= pageNumber%>">
	
	<span class="btn white large"><input type="button" value="저장하기" id="submitBtn" onClick="$.submitForm();"></span>
	</td>
</tr>

</table>
</form>


 
<br><br>
