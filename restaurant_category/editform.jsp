<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.RestaurantCategoryDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var 	category_name = $('[name="category_name"]');
	$.extend({
		submitForm : function() {
			if( category_name.val() == '') {
				alert("분류명을 입력하세요.");
				category_name.focus();
				return;
			}
			document.formName.submit();	 
		}
	});
	$.extend({
		confirmDelete : function(global, local, db, page, doc) {
			if(!confirm("정말로 삭제하겠습니까?")){
				return;
			}
			else{
				document.location = "/baas/restaurant_category/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&doc=" +doc;
			}
		}
	});
	
	
});
//-->
</script>
 <%
	 StringUtility strobj = new StringUtility();

	int isAccess = 0;
	String goURL="";
 
  	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
  	 
 	Map map = new HashMap();
	map.put("superuserID", sessionSuperuserID);
	map.put("dbName", "restaurant");
	map.put("accessCode", sessionSuperuserDivisionCode);

	AclDataObject acldataobj = new AclDataObject();
	
	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", map);
	isAccess  = acldataobj.getIs_access();
	String  divisionName = acldataobj.getDivision_name(); 
	
	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
 
  	//데이터  가져온다..
  	String tableName = "tb_" + dbName;
  	Map artclemap = new HashMap();

  	artclemap.put("tableName", tableName);
  	artclemap.put("docNumber", Integer.toString(docNumber));
  		
  		
  	RestaurantCategoryDataObject dataobj = new RestaurantCategoryDataObject();
  	dataobj = (RestaurantCategoryDataObject)sqlMap.queryForObject("restaurantCategoryArticle", artclemap);
  	
 %>
<div class="plate">
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
		<span class="button medium icon"><span class="delete"></span>
		<a href="JavaScript:$.confirmDelete('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=docNumber%>');">삭제</a>
	</span>
	
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/restaurant_category/edit.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 분류명 : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="category_name" value="<%= dataobj.getCategory_name() %>" maxlength="10">
	</td>
</tr>	
<tr><td class="line" colspan=2><hr></td></tr>
<tr><td colspan="2">
	<input type="hidden" name="global_menu" value="<%= globalMenu%>">
	<input type="hidden" name="local_menu" value="<%= localMenu%>">
	<input type="hidden" name="db" value="<%= dbName%>">
	<input type="hidden" name="doc" value="<%= docNumber%>">
	<input type="hidden" name="page" value="<%= pageNumber%>">
	<input type="hidden" name="code" value="<%= accessCode%>">
	
	<span class="btn white large"><input type="button" value="수정하기" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>


 
<br><br>
