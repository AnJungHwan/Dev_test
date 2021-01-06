<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.GalleryDataObject"  %>
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
			 if( title.val() == '') {
				alert("제목을 입력하세요.");
				title.focus();
				return;
			}
			 callSwfUpload('"formName"');	 
		}
	});
	$.extend({
		confirmDelete : function(global, local, db, page, div, id, code) {
			if(!confirm("주의!!! \n\n해당 갤러리 사진 전체가 지워 집니다.\n\n정말로 삭제하겠습니까?")){
				return;
			}
			else{
				document.location = "/baas/gallery/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&div=" + div + "&id=" +id +"&code="+code;
			}
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
		
		
	GalleryDataObject dataobj = new GalleryDataObject();
	dataobj = (GalleryDataObject)sqlMap.queryForObject("galleryArticle", artclemap);

	
	StringUtility strobj = new StringUtility();
	String goURL=null;
%>
<div class="plate">
	<%
		goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode, accessCode);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
	<% if  (isAccess  == 1) { %>
		<span class="button medium icon"><span class="delete"></span>
		<a href="JavaScript:$.confirmDelete('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=divisionCode %>','<%=dataobj.getGallery_code()%>','<%=accessCode%>');">삭제</a>
		</span>
	<% } %>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/gallery/edit.jsp">
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
		<option value="<%=dataobj.getDivision_name()%>"><%=dataobj.getDivision_name() %></option>
	<%	
	}
	%>
	</select>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* 대표 사진 : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //파일폼 고유ID
				flash_width='400', //파일폼 너비 (기본값 400, 권장최소 300)
				limit_size='10', // 업로드 제한용량 (기본값 10)
				file_type_name='모든파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
				allow_filetype=' *.* ', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // 업로드 불가형식 
				upload_exe='/baas/include/upload.jsp', // 업로드 담당프로그램
				browser_id='<%=session.getId()%>'
			);
		</script>
	<br><br>
	<% 
		if(dataobj.getGallery_filename() != null) {
			out.println("현재 사진 파일 : " + dataobj.getGallery_filename());
	%>
		<input type="hidden" name="gallery_filename" value="<%=dataobj.getGallery_filename()%>">
	<%
		}
		else  {
	%>
		<input type="hidden" name="gallery_filename">
	<%
		}
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