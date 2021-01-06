<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.PopupSkinDataObject"  %>
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
	var 	title = $('[name="title"]');
	$.extend({
		submitForm : function() {
			if( title.val() == '') {
				alert("스킨명을 입력하세요.");
				title.focus();
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
				document.location = "/baas/popup_skin/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&doc=" +doc;
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
  	  		
  	PopupSkinDataObject dataobj = new PopupSkinDataObject();
  	dataobj = (PopupSkinDataObject)sqlMap.queryForObject("popupSkinArticle",  Integer.toString(docNumber));

  	
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
<form method="post" name="formName" action="/baas/popup_skin/edit.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 스킨명 : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="title" value="<%= dataobj.getTitle() %>">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* 스킨 이미지 : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //파일폼 고유ID
				flash_width='400', //파일폼 너비 (기본값 400, 권장최소 300)
				limit_size='10', // 업로드 제한용량 (기본값 10)
				file_type_name='그림파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
				allow_filetype=' *.jpg *.gif', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // 업로드 불가형식 
				upload_exe='/baas/include/upload.jsp', // 업로드 담당프로그램
				browser_id='<%=session.getId()%>'
			);
		</script><br><br>
		<% 
		if(dataobj.getFilename() != null) {
			out.println("현재 스킨 파일 : " + dataobj.getFilename());
			out.println("<font  color=red>** 파일을 새로 첨부하시면 기존 스킨 파일은 지워 집니다.</font>");
		%>
			<input type="hidden" name="filename" value="<%=dataobj.getFilename()%>">
		<%
		}
		else  {
		%>
			<input type="hidden" name="filename">
		<%
		}
		%>
	</td>
</tr>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 사용 : </td>
	<td style="text-align:left">
	<select name="is_view" class="thin" style="width:150px;"  id="view_type">
	<option value="Y" <% if (dataobj.getIs_view().equals("Y"))  out.println("selected");  %>>사용</option>
	<option value="N" <% if (dataobj.getIs_view().equals("N"))  out.println("selected");  %>>미사용</option>
	</select>
	</td>
</tr>	
<tr><td class="line" colspan=2><hr></td></tr>
<tr><td colspan="2">
	<input type="hidden" name="width" value="<%= dataobj.getWidth()%>">
	<input type="hidden" name="height" value="<%=  dataobj.getHeight()%>">

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
