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
	
	var numbers = /^[0-9]{1,4}$/; // 숫자검사
	var title = $('[name="title"]');
	var location = $('[name="location"]');
	$.extend({
		submitForm : function() {

			 if( title.val() == '') {
					alert("플래시  이름을 입력하세요.");
					title.focus();
					return;
			}
			else if(numbers.test(location.val()) != true) {
				alert("순서를  숫자로  입력해  주세요.");
				location.focus();
				return false;
			}
		 	callSwfUpload('"formName"');	 

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
 	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
 %>
<div class="plate">
	<%
		goURL = strobj.generateForBannerURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/sub_flash/write.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 플래시명 : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="title">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 사업장 : </td>
	<td style="text-align:left">
	<select name="division_name" class="thin" style="width:150px;">
		<option value="파인크리크" <% if (divisionCode.equals("PC")) { out.println("selected"); } %>>파인크리크</option>
		<option value="파인밸리" <% if (divisionCode.equals("PV")) { out.println("selected"); } %>>파인밸리</option>
	</select>
	</td>
</tr>	
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* 순서 : </td>
	<td style="text-align:left">
	<input style="width: 20px" type="text" class="thin" name="location" maxlength="2">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* 플래시 : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //파일폼 고유ID
				flash_width='400', //파일폼 너비 (기본값 400, 권장최소 300)
				limit_size='10', // 업로드 제한용량 (기본값 10)
				file_type_name='플래시파일', // 파일선택창 파일형식명 (예: 그림파일, 엑셀파일, 모든파일 등)
				allow_filetype=' *.swf ', // 파일선택창 파일형식 (예: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl *.exe', // 업로드 불가형식 
				upload_exe='/baas/include/upload.jsp', // 업로드 담당프로그램
				browser_id='<%=session.getId()%>'
			);
		</script>
	<br>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 사용 : </td>
	<td style="text-align:left">
	<select name="is_view" class="thin" style="width:150px;"  id="is_view">
	<option value="Y" selected> 사용</option>
	<option value="N"> 미사용 </option>
	</select>
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
	
	<span class="btn white large"><input type="button" value="플래시  등록" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>

</table>
</form>


 
<br><br>
