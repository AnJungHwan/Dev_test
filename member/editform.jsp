<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.SuperuserDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

<%
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}

	StringUtility strobj = new StringUtility();
	String goURL="";
%>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	var re_id = /^[a-z0-9_-]{4,16}$/; // 아이디 검사식
	var re_pw = /^[a-z0-9_-]{4,16}$/; // 비밀번호 검사식
	var re_email = /^([\w\.-]+)@([a-z\d\.-]+)\.([a-z\.]{2,6})$/; // 이메일 검사식
	var re_tel = /^[0-9]{8,11}$/; // 전화번호 검사식
	var 	form = $('#editForm'),
	        spw = $('#superuser_pwd'),
	        spwc = $('#superuser_pwd_check'),
	        email = $('#email'),
	        tel = $('#telephone'),
	        team = $('#team'),
	        position = $('#position'),
			msgPW = $('#msgPW');
	form.submit(function(){
		if( spw.val() == '') {
			alert("암호를 입력해  주세요.");
			spw.focus();
			return false;
		}
		else if( spwc.val() == '') {
			alert("암호 확인을 입력해  주세요.");
			spwc.focus();
			return false;
		}
		else if( spw.val() != spwc.val()) {
			alert("암호가 서로 다릅니다.");
			spw.focus();
			return false;
		}
		else if( email.val() == '') {
			alert("이메일을 입력해  주세요.");
			email.focus();
			return false;
		}
		else if( tel.val() == '') {
			alert("전화번호를 입력해  주세요.");
			tel.focus();
			return false;
		}
		else if( team.val() == '') {
			alert("팀명을 입력해  주세요.");
			tel.focus();
			return false;
		}
		else if( position.val() == '') {
			alert("직책을 입력해  주세요.");
			position.focus();
			return false;
		}
		
	});
	spw.keyup( function() {
		
		if (spw.val().length == 0) { 
			msgPW.text('* 최소  8글자  이상이여야  합니다.'); 
		} else if (spw.val().length < 8) { 
			msgPW.text('너무  짧습니다.');
		} else if (spw.val().length > 8 & spw.val().length < 15) { 
			msgPW.text('적당  합니다.');	
		} else if (spw.val().length > 16) { 
			msgPW.text('너무 길어요.'); 
		} else{
			msgPW.text('보통입니다.');
		}
	});
	$("#division").change(function() {
		var  value = $(this).val();
		$("#division_name").val(value);
	});
	
	
	$.extend({
		confirmDelete : function(id) {
			if(!confirm("정말로 삭제하겠습니까?")){
				return;
			}
			else{
				document.location = "/baas/member/delete.jsp?superuser_id=" + id;
			}
		}	
	});
});
</script>
<%
	//데이터  가져온다..
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	SuperuserDataObject dataobj = new SuperuserDataObject();
	dataobj = (SuperuserDataObject)sqlMap.queryForObject("superuserArticle", Integer.toString(docNumber));

	goURL = strobj.generateForMemberURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
%>

<div class="plate">
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
		<span class="button medium icon"><span class="delete"></span><a href="JavaScript:$.confirmDelete('<%=dataobj.getSuperuser_id()%>')">삭제</a></span>
</div>
<div class="square"><br>기본 정보</div>

<form method="post" action="/baas/member/edit.jsp" name="editForm" id="editForm">
<table class="normal">
<tr>
	<td style="width:150px; color:#BB0000; font-weight:bold; text-align:right">* ID : </td>
	<td style="width:700px; text-align:left" colspan=3 >
	<input type="hidden" name="superuser_id"  id="superuser_id" value="<%=dataobj.getSuperuser_id()%>">
	<%=dataobj.getSuperuser_id() %>
	</td>
</tr>	
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right">* 이름 : </td>
	<td style="text-align:left" colspan=3>
		<%=dataobj.getSuperuser_name() %>
	</td>
</tr>
<tr>
	<td style="width:150px; color:#BB0000; font-weight:bold; text-align:right">* 암호 : </td>
	<td style="width:350px; text-align:left" >
		<input style="width: 150px" type="password" class="thin" name="superuser_pwd"  id="superuser_pwd" value="<%=dataobj.getSuperuser_pwd()%>">
		<span id="msgPW">* 최소  8자  이상이여야  합니다.</span>
	</td>
	
	<td style="width:80px; color:#BB0000; font-weight:bold; text-align:right" >* 확인 : </td>
	<td style="width:270px; text-align:left" >
		<input style="width: 150px" type="password" class="thin" name="superuser_pwd_check"  id="superuser_pwd_check" value="<%=dataobj.getSuperuser_pwd()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 이메일 : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 250px" type="text" class="thin" name="email"  id="email" value="<%=dataobj.getEmail()%>">
	</td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 전화번호 : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 150px" type="text" class="thin" name="telephone"  id="telephone"  value="<%=dataobj.getTelephone()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 직책 : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 100px" type="text" class="thin" name="position"  id="position"  value="<%=dataobj.getPosition()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 팀명 : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 150px" type="text" class="thin" name="team"  id="team"  value="<%=dataobj.getTeam()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 소속 사업장 : </td>
	<td style="text-align:left" colspan=3>
		<select name="division" class="thin" style="width:150px;"  id="division">
		<option value="동양레저" <% if (dataobj.getDivision().equals("동양레저")) out.println("selected"); %>>동양레저</option>
		<option value="파인크리크" <% if (dataobj.getDivision().equals("파인크리크")) out.println("selected"); %>>파인크리크</option>
		<option value="파인밸리" <% if (dataobj.getDivision().equals("파인밸리")) out.println("selected"); %>>파인밸리</option>
		</select>
	</td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right">* 권한 : </td>
	<td style="text-align:left"  colspan=3>
		<% 
			if (dataobj.getAccess_level().equals("MANAGER")){ 
				out.println("중간  관리자");
			}	
			else{ 
				out.println("슈퍼  관리자");
			}	
		%>
		<input style="width: 100px" type="hidden" class="thin" name="access_level"  id="access_level"  value="<%=dataobj.getAccess_level()%>">
	</td>
</tr>
</table>
<%
	if (dataobj.getAccess_level().equals("MANAGER")){
		
		List acllist = new ArrayList();
		acllist = sqlMap.queryForList("aclIsAccessList",dataobj.getSuperuser_id() );
		if (acllist.size() == 0) {

%>
			<div class="square"><br>관리 정보</div>

			<table class="normal">
			<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >접근  권한 : </td>
			<td style="width:700px; text-align:left" colspan=3>
				<select name="division_name" class="thin" style="width:150px;"  id="division_name">
				<option value="동양레저" <% if (dataobj.getDivision().equals("동양레저")) out.println("selected"); %>>동양레저</option>
				<option value="파인크리크" <% if (dataobj.getDivision().equals("파인크리크")) out.println("selected"); %>>파인크리크</option>
				<option value="파인밸리" <% if (dataobj.getDivision().equals("파인밸리")) out.println("selected"); %>>파인밸리</option>
				</select>
			</td>
		</tr>
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >시설물 관리 : </td>
			<td style="text-align:left" >
				<input type="checkbox" name="restaurant" value="1"> 대식당
				<input type="checkbox" name="proshop" value="1"> 프로샵
			</td>
		</tr>	
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >클럽 소식 : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="notice" value="1"> 공지사항
				<input type="checkbox"  name="event" value="1"> 이벤트
				<input type="checkbox"  name="news" value="1"> 회원소식지
				<input type="checkbox"  name="gallery" value="1"> 포토갤러리
				<input type="checkbox"  name="booking" value="1"> 연단체 리스트
				<input type="checkbox"  name="webzine" value="1" checked> THE PINE 웹진 
			</td>
		</tr>	
		<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >고객  센터 : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="faq" value="1"> FAQ
				<input type="checkbox"  name="pds" value="1"> 자료실
			</td>
		</tr>	
		</table>
	
<%
		}
		else {
		
			String accessDB = "";
			String accessDivisionName = null;
			for(int i=0; i < acllist.size(); i++){
				AclDataObject acldataobj = (AclDataObject) acllist.get(i);
				accessDivisionName = acldataobj.getDivision_name();
				accessDB = accessDB + acldataobj.getDb_name() + "/";
			}	
%>		
			<div class="square"><br>관리 정보</div>

			<table class="normal">
			<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >접근  권한 : </td>
			<td style="width:700px; text-align:left" colspan=3>
				<select name="division_name" class="thin" style="width:150px;"  id="division_name">
				<option value="동양레저" <% if (accessDivisionName.equals("동양레저")) out.println("selected"); %>>동양레저</option>
				<option value="파인크리크" <% if (accessDivisionName.equals("파인크리크")) out.println("selected"); %>>파인크리크</option>
				<option value="파인밸리" <% if (accessDivisionName.equals("파인밸리")) out.println("selected"); %>>파인밸리</option>
				</select>
			</td>
		</tr>
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >시설물 관리 : </td>
			<td style="text-align:left" >
				<input type="checkbox" name="restaurant" value="1" <%if (accessDB.matches(".*restaurant.*")) out.println("checked"); %> > 대식당
				<input type="checkbox" name="proshop" value="1" <%if (accessDB.matches(".*proshop.*")) out.println("checked"); %>> 프로샵
			</td>
		</tr>	
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >클럽 소식 : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="notice" value="1" <%if (accessDB.matches(".*notice.*")) out.println("checked"); %>> 공지사항
				<input type="checkbox"  name="event" value="1" <%if (accessDB.matches(".*event.*")) out.println("checked"); %>> 이벤트
				<input type="checkbox"  name="news" value="1" <%if (accessDB.matches(".*news.*")) out.println("checked"); %>> 회원소식지
				<input type="checkbox"  name="gallery" value="1" <%if (accessDB.matches(".*gallery.*")) out.println("checked"); %>> 포토갤러리
				<input type="checkbox"  name="booking" value="1" <%if (accessDB.matches(".*booking.*")) out.println("checked"); %>> 연단체 리스트
				<input type="checkbox"  name="webzine" value="1" <%if (accessDB.matches(".*webzine.*")) out.println("checked"); %>> THE PINE 웹진 
			</td>
		</tr>	
		<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >고객  센터 : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="faq" value="1" <%if (accessDB.matches(".*faq.*")) out.println("checked"); %>> FAQ
				<input type="checkbox"  name="pds" value="1" <%if (accessDB.matches(".*pds.*")) out.println("checked"); %>> 자료실
			</td>
		</tr>	
		</table>
		
<%
	}
}
%>
<table class="normal">
<tr>
	<td colspan="2">
	<hr><br/>
	<span class="btn white large"><input  type="submit" class="btn" value="관리자  수정"></span>
	</td>
</tr>
</table>

</form>
 
<br><br>
