<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.ClubCategoryDataObject"  %>
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
	var 	category_name = $('[name="category_name"]');
	$.extend({
		submitForm : function() {
			if( category_name.val() == '') {
				alert("분류명을 입력하세요.");
				category_name.focus();
				return;
			}
			 callSwfUpload('"formName"');	 
		}
	});
	$.extend({
		confirmDelete : function(global, local, db, page, doc) {
			if(!confirm("정말로 삭제하겠습니까?")){
				return;
			}
			else{
				document.location = "/baas/blog_category/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&doc=" +doc;
			}
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
  	
  	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
  	 
  	  	
  	//데이터  가져온다..
  	String tableName = "tb_" + dbName;
  	Map artclemap = new HashMap();

  	artclemap.put("tableName", tableName);
  	artclemap.put("docNumber", Integer.toString(docNumber));
  		
  		
  	ClubCategoryDataObject dataobj = new ClubCategoryDataObject();
  	dataobj = (ClubCategoryDataObject)sqlMap.queryForObject("clubCategoryArticle", artclemap);

  	
  	StringUtility strobj = new StringUtility();
  	String goURL="";
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
<form method="post" name="formName" action="/baas/blog_category/edit.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 분류명 : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="category_name" value="<%= dataobj.getCategory_name() %>">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* 분류 이미지 : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //파일폼 고유ID
				flash_width='400', //파일폼 너비 (기본값 400, 권장최소 300)
				limit_size='10', // 업로드 제한용량 (기본값 10)
				file_type_name='모든파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
				allow_filetype=' *.jpg ', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // 업로드 불가형식 
				upload_exe='/baas/include/upload.jsp', // 업로드 담당프로그램
				browser_id='<%=session.getId()%>'
			);
		</script><br><br>
		<% 
		if(dataobj.getMenu_filename() != null) {
			out.println("현재 첨부 파일 : " + dataobj.getMenu_filename());
			out.println("<font  color=red>** 파일을 새로 첨부하시면 기존 첨부파일은 지워 집니다.</font>");
		%>
			<input type="hidden" name="menu_filename" value="<%=dataobj.getMenu_filename()%>">
		<%
		}
		else  {
		%>
			<input type="hidden" name="menu_filename">
		<%
		}
		%>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* 타이틀 이미지 : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu02', //파일폼 고유ID
				flash_width='400', //파일폼 너비 (기본값 400, 권장최소 300)
				limit_size='10', // 업로드 제한용량 (기본값 10)
				file_type_name='모든파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
				allow_filetype=' *.jpg ', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // 업로드 불가형식 
				upload_exe='/baas/include/upload.jsp', // 업로드 담당프로그램
				browser_id='<%=session.getId()%>'
			);
		</script><br><br>
		<% 
		if(dataobj.getTitle_filename() != null) {
			out.println("현재 첨부 파일 : " + dataobj.getTitle_filename());
			out.println("<font  color=red>** 파일을 새로 첨부하시면 기존 첨부파일은 지워 집니다.</font>");
		%>
			<input type="hidden" name="title_filename" value="<%=dataobj.getTitle_filename()%>">
		<%
		}
		else  {
		%>
			<input type="hidden" name="title_filename">
		<%
		}
		%>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 정렬타입 : </td>
	<td style="text-align:left">
	<select name="view_type" class="thin" style="width:150px;"  id="view_type">
	<option value="type1" <% if (dataobj.getView_type().equals("type1"))  out.println("selected");  %>> Type 1</option>
	<option value="type2" <% if (dataobj.getView_type().equals("type2"))  out.println("selected");  %>> Type 2</option>
	</select>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right"> </td>
	<td style="text-align:left"><br><br>
	* Type 1<br>
	<img src=/baas/images/sample_01.jpg><br><br>
	* Type 2<br>
	<img src=/baas/images/sample_02.jpg><br><br>
	
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
	
	
	<span class="btn white large"><input type="button" value="수정하기" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>


 
<br><br>
