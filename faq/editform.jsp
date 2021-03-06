<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.FaqDataObject"  %>
<%@ page import="database.datadef.FaqCategoryDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

 <%@ page import="com.fredck.FCKeditor.*" %>
 <script language="JavaScript" type="text/JavaScript" src="/baas/js/swf_upload.js"></script>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var 	title = $('[name="title"]');
	$.extend({
		submitForm : function() {
			var oEditor = FCKeditorAPI.GetInstance('content') ;
			var div = document.createElement("DIV");
			 div.innerHTML = oEditor.GetXHTML();

			 if( title.val() == '') {
				alert("제목을 입력하세요.");
				title.focus();
				return;
			}
			 else if(div.innerHTML=='') {
				alert("내용을 입력 하세요");
				oEditor.Focus();
				return false;
			}
			 callSwfUpload('"formName"');	 
		}
	});
});
//-->
</script>
 <%


	int isAccess = 0;
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	AclDataObject acldataobj = new AclDataObject();

	Map map = new HashMap();
	map.put("superuserID", sessionSuperuserID);
	map.put("dbName", dbName);
	map.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", map);
	//isAccess  = acldataobj.getIs_access();
	isAccess = 1;

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
		
		
	FaqDataObject dataobj = new FaqDataObject();
	dataobj = (FaqDataObject)sqlMap.queryForObject("faqArticle", artclemap);

	
	StringUtility strobj = new StringUtility();
	String goURL="";
%>
<div class="plate">
	<%
		goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode, accessCode);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/faq/edit.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* 제목 : </td>
	<td style="width:850px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="title" value="<%=dataobj.getTitle()%>">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 사업장 : </td>
	<td style="text-align:left">
	<select name="division_name" class="thin" style="width:150px;">
	<%
	
	if (sessionSuperuserAccessLevel.equals("SUPER")){
	%>
		<option value="파인크리크" <%if (dataobj.getDivision_name().equals("파인크리크"))  out.println("selected");  %>>파인크리크</option>
		<option value="파인밸리" <%if (dataobj.getDivision_name().equals("파인밸리"))  out.println("selected");  %>>파인밸리</option>
	<%	
	}
	else {
	%>
		<option value="<%=divisionName%>"><%=divisionName %></option>
	<%	
	}
	%>
	</select>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 분류 : </td>
	<td style="text-align:left">
	<select name="category_name" class="thin" style="width:150px;"  id="category_name">
	
	<%
		Map catemap = new HashMap();
		catemap.put("divisionCode", divisionCode);
		List categoryList = new ArrayList();
		categoryList = sqlMap.queryForList("faqCategoryList", catemap);	
			
		for(int i=0; i < categoryList.size(); i++){
			FaqCategoryDataObject catedataobj = (FaqCategoryDataObject) categoryList.get(i);
		%>
			<option value="<%=catedataobj.getCategory_name() %>" <% if (dataobj.getCategory_name().equals(catedataobj.getCategory_name()))  out.println("selected");  %> >
			<%=catedataobj.getCategory_name() %></option>	
	<% 
		}
	%>
	</select>
	</td>
</tr>	
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="text-align:left" colspan=2>
	<%
		FCKeditor oFCKeditor ;
		oFCKeditor = new FCKeditor( request, "content" ) ;
		oFCKeditor.setBasePath( "/baas/FCKeditor/" ) ;
		oFCKeditor.setToolbarSet("tyleisure");
		oFCKeditor.setHeight("300");
		oFCKeditor.setWidth("850");
		oFCKeditor.setValue( dataobj.getContent() );
		out.println( oFCKeditor.create() ) ;
	%>
	</td>
</tr>

<tr><td class="line" colspan=2><hr></td></tr>
<tr><td colspan="2">
	<input type="hidden" name="user_id" value="<%= sessionSuperuserID%>">
	<input type="hidden" name="user_name" value="<%= sessionSuperuserName%>">
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
