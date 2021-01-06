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
	var  menu_node  = $("#menu_node");
	var  top_node  = $("#top_node");
	var  parent_node  = $("#parent_node");
	var 	menu_name = $('[name="menu_name"]');
	var 	menu_link = $('[name="menu_link"]');
	
	menu_node.change(function() {

		if(menu_node.val() == '대분류'){
			
			$("#topLabel").text("");
			$("#topDiv").hide();			
			$("#parentLabel").text("");
			$("#parentDiv").hide();			
		}	
		else if(menu_node.val() == '중분류'){
			$("#parentLabel").text("");
			$("#parentDiv").hide();
			$.get("/baas/gnb/topnode.jsp", function(data){
				$("#topLabel").text("* 대분류를  선택하세요 : ");
				$("#topDiv").show();		
				$("#topDiv").html(data);
			});
		}
		else if(menu_node.val() == '소분류'){
			
			$.get("/baas/gnb/parentnode1.jsp", function(data){
				$("#topLabel").text("* 대분류를  선택하세요 : ");
				$("#topDiv").show();		
				$("#topDiv").html(data);
			});
		}
	});
	
	
	$("#submitBtn").click(function() {
		 if( menu_name.val() == '') {
				alert("메뉴명을 입력하세요.");
				menu_name.focus();
				return;
			}
			else if(menu_link.val() == '') {
				alert("메뉴가 링크될곳을 입력해 주세요");
				menu_link.focus();
				return false;
			}
			else if(menu_node.val() == '-') {
				alert("메뉴의  분류를 선택해 주세요");
				menu_node.focus();
				return false;
			}
			else if(parent_node.val() == '-') {
				alert("대분류를 선택해 주세요");
				menu_node.focus();
				return false;
			}
		 	document.formName.submit(); 
	
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
 	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
 %>
<div class="plate">
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/gnb/write.jsp">

<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 메뉴명 : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="menu_name">
	</td>
</tr>	
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 메뉴링크 : </td>
	<td style="text-align:left">
	<input style="width: 300px" type="text" class="thin" name="menu_link">
	</td>
</tr>	

<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 메뉴  분류명 : </td>
	<td style="text-align:left">
	<select name="menu_node" class="thin" style="width:150px;"  id="menu_node">
	<option value="-">선택해주세요</option>
	<option value="대분류"> 대분류</option>
	<option value="중분류"> 중분류 </option>
	<option value="소분류"> 소분류 </option>
	</select>
	</td>
</tr>

<tr>
	<td style="width:150px; color:red; font-weight:bold; text-align:right" ><label id="topLabel"></label></td>
	<td style="text-align:left">
	<div id="topDiv">
	</div>
	</td>	
</tr>
<tr>
	<td style="width:150px; color:red; font-weight:bold; text-align:right" ><label id="parentLabel"></label></td>
	<td style="text-align:left">
	<div id="parentDiv">
	</div>
	</td>	
</tr>


<tr><td class="line" colspan=2><hr></td></tr>
<tr><td colspan="2">
	<input type="hidden" name="user_id" value="<%= sessionSuperuserID%>">
	<input type="hidden" name="user_name" value="<%= sessionSuperuserName%>">
	
	<input type="hidden" name="db" value="<%= dbName%>">
	<input type="hidden" name="global_menu" value="<%= globalMenu%>">
	<input type="hidden" name="local_menu" value="<%= localMenu%>">
	<input type="hidden" name="page" value="<%= pageNumber%>">
	
	<span class="btn white large"><input type="button" value="메뉴  등록" id="submitBtn"></span>
	</td>
</tr>

</table>
</form>


 
<br><br>
