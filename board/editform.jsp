<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.BoardDataObject"  %>
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
	
	var numbers = /^[0-9]{1,4}$/; // 숫자검사
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
		
		
	BoardDataObject dataobj = new BoardDataObject();
	dataobj = (BoardDataObject)sqlMap.queryForObject("boardArticle", artclemap);

	
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
<form method="post" name="formName" action="/baas/board/edit.jsp">
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
		<option value="동양레저" <% if (dataobj.getDivision_name().equals("동양레저")) out.println("selected"); %>>동양레저</option>
		<option value="파인크리크" <%if (dataobj.getDivision_name().equals("파인크리크"))  out.println("selected");  %>>파인크리크</option>
		<option value="파인밸리" <%if (dataobj.getDivision_name().equals("파인밸리"))  out.println("selected");  %>>파인밸리</option>
		<option value="기업회생게시판" <%if (dataobj.getDivision_name().equals("기업회생게시판"))  out.println("selected"); %>>기업회생게시판</option>
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
	<td style="color:#000; font-weight:bold; text-align:right">* 게시  : </td>
	<td style="text-align:left">
	<select name="is_view" class="thin" style="width:150px;"  id="is_view">
	<option value="Y" <% if (dataobj.getIs_view().equals("Y"))  out.println("selected");  %>> 이 글을  게시 합니다.</option>
	<option value="N" <% if (dataobj.getIs_view().equals("N"))  out.println("selected");  %>> 이  글을 숨깁니다. </option>
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
		oFCKeditor.setHeight("500");
		oFCKeditor.setWidth("850");
		oFCKeditor.setValue( dataobj.getContent() );
		out.println( oFCKeditor.create() ) ;
	%>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* 파일 첨부 : </td>
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
		if(dataobj.getAttach_filename() != null) {
			out.println("현재 첨부 파일 : " + dataobj.getAttach_filename());
			out.println("<font  color=red>** 파일을 새로 첨부하시면 기존 첨부파일은 지워 집니다.</font>");
	%>
		<input type="hidden" name="attach_filename" value="<%=dataobj.getAttach_filename()%>">
	<%
		}
		else  {
	%>
		<input type="hidden" name="attach_filename">
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


 
<br><br>
