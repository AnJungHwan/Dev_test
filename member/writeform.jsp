<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.SuperuserDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

<%
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

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
	var 	form = $('#writeForm'),
		    sid = $('#superuser_id'),
	        sname = $('#superuser_name'),
	        spw = $('#superuser_pwd'),
	        spwc = $('#superuser_pwd_check'),
	        email = $('#email'),
	        tel = $('#telephone'),
	        team = $('#team'),
	        position = $('#position'),
			msgID = $('#msgID'),
			msgPW = $('#msgPW');

	form.submit(function(){
		if(re_id.test(sid.val()) != true) {
			alert("유효한  ID를  입력해  주세요.");
			sid.focus();
			return false;
		}
		else if( sname.val() == '') {
			alert("이름을  입력해  주세요.");
			sname.focus();
			return false;
		}
		else if( spw.val() == '') {
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
	sid.keyup( function() {
		
		if (sid.val().length == 0) { 
			msgID.text('* 4자 이상 16자  이하의 영문 소문자, 숫자만   가능합니다.'); 
		} else if (sid.val().length < 4) { 
			msgID.text('너무 짧습니다.'); 
		} else if (sid.val().length > 16) { 
			msgID.text('너무 길어요.'); 
		} else{
			msgID.text('적당합니다.');
		}
	});
	spw.keyup( function() {
		
		if (spw.val().length == 0) { 
			msgPW.text('* 최소  3자  이상이여야  합니다.'); 
		} else if (spw.val().length < 4) { 
			msgPW.text('너무  짧습니다.');
		} else if (spw.val().length > 8 & spw.val().length < 15) { 
			msgPW.text('적당  합니다.');	
		} else if (spw.val().length > 16) { 
			msgPW.text('너무 길어요.'); 
		} else{
			msgPW.text('보통입니다.');
		}
	});
	$("#access_level").change(function() {
		if  ($(this).val()  == "MANAGER") {
			$("[type='checkbox']").attr('checked', false);
		}
		else{
			$("[type='checkbox']").attr('checked', true);
		}
	});
	$("#division").change(function() {
		var  value = $(this).val();
		$("#division_name").val(value);
	});
	$("#division_name").change(function() {
		var  value = $(this).val();
		$("#division").val(value);
	});
});
</script>
<div class="plate">
	<%
		goURL = strobj.generateForMemberURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
</div>
<div class="square"><br>기본 정보</div>


<form method="post" action="/baas/member/write.jsp" name="writeForm" id="writeForm">
<table class="normal">
<tr>
	<td style="width:150px; color:#BB0000; font-weight:bold; text-align:right">* ID : </td>
	<td style="width:700px; text-align:left" colspan=3 ><input style="width: 150px" type="text" class="thin" name="superuser_id" id="superuser_id">
	<span id="msgID">* 4자 이상 16자  이하의 영문 소문자, 숫자만   가능합니다.</span>
	</td>
</tr>	
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right">* 이름 : </td>
	<td style="text-align:left" colspan=3><input style="width: 150px" type="text" class="thin" name="superuser_name"  id="superuser_name"></td>
</tr>
<tr>
	<td style="width:150px; color:#BB0000; font-weight:bold; text-align:right">* 암호 : </td>
	<td style="width:350px; text-align:left" ><input style="width: 150px" type="password" class="thin" name="superuser_pwd"  id="superuser_pwd">
	<span id="msgPW">* 최소  3자  이상이여야  합니다.</span>
	</td>
	
	<td style="width:80px; color:#BB0000; font-weight:bold; text-align:right" >* 암호확인 : </td>
	<td style="width:270px; text-align:left" ><input style="width: 150px" type="password" class="thin" name="superuser_pwd_check"  id="superuser_pwd_check"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 이메일 : </td>
	<td style="text-align:left" colspan=3><input style="width: 250px" type="text" class="thin" name="email"  id="email"></td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 전화번호 : </td>
	<td style="text-align:left" colspan=3><input style="width: 150px" type="text" class="thin" name="telephone"  id="telephone"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 직책 : </td>
	<td style="text-align:left" colspan=3><input style="width: 100px" type="text" class="thin" name="position"  id="position"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 팀명 : </td>
	<td style="text-align:left" colspan=3><input style="width: 150px" type="text" class="thin" name="team"  id="team"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* 소속 사업장 : </td>
	<td style="text-align:left" colspan=3>
		<select name="division" class="thin" style="width:150px;"  id="division">
		<option value="동양레저" selected>동양레저</option>
		<option value="파인크리크">파인크리크</option>
		<option value="파인밸리">파인밸리</option>
		</select>
	</td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right">* 권한 : </td>
	<td style="text-align:left"  colspan=3>
		<select name="access_level" class="thin" style="width:150px;"   id="access_level">
		<option value="MANAGER" selected>중간 관리자</option>
		<option value="SUPER">슈퍼 관리자</option>
		</select>
		* <font color="red">슈퍼  관리자</font>는  접근권한에는  무관하게  모든  권한을  가집니다.
	
	</td>
</tr>
</table>
<input type="hidden" name="create_date" id="create_date" value="2011-10-10">
<input type="hidden" name="create_time" id="create_time" value="00:00:00">
<input type="hidden" name="ipaddress" id="ipaddress" value="111111">

<div class="square"><br>관리 정보</div>

<table class="normal">
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right" >접근  권한 : </td>
	<td style="width:700px; text-align:left" colspan=3>
		<select name="division_name" class="thin" style="width:150px;"  id="division_name">
		<option value="동양레저" selected>동양레저</option>
		<option value="파인크리크">파인크리크</option>
		<option value="파인밸리">파인밸리</option>
		</select>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >시설물 관리 : </td>
	<td style="text-align:left" >
	<input type="checkbox" name="restaurant" value="1" checked> 대식당
	<input type="checkbox" name="proshop" value="1" checked> 프로샵
	</td>
</tr>	

<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >클럽 소식 : </td>
	<td style="text-align:left" >
	<input type="checkbox"  name="notice" value="1" checked > 공지사항
	<input type="checkbox"  name="event" value="1" checked > 이벤트
	<input type="checkbox"  name="news" value="1" checked> 회원소식지
	<input type="checkbox"  name="gallery" value="1" checked> 포토갤러리
	<input type="checkbox"  name="booking" value="1" checked> 연단체 리스트
	<input type="checkbox"  name="webzine" value="1" checked> THE PINE 웹진 
	</td>
</tr>	

<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right" >고객  센터 : </td>
	<td style="text-align:left" >
	<input type="checkbox"  name="faq" value="1" checked> FAQ
	<input type="checkbox"  name="pds" value="1" checked> 자료실
	</td>
</tr>	

<tr>
	<td colspan="2">
	<hr><br/>
	<span class="btn white large"><input  type="submit" class="btn" value="관리자  생성"></span>
	</td>
</tr>
</table>
</form>
 
<br><br>
