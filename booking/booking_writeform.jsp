<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

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
	StringUtility strobj = new StringUtility();

	int isAccess = 0;
	String goURL="";

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
		
%>

<table class="normal">	
<form method="post" name="formName" action="/baas/board/write.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* 신청사업장 : </td>
	<td style="width:850px; text-align:left">
	<select name="division_name" class="thin" style="width:150px;">
		<option value="파인크리크" >파인크리크</option>
		<option value="파인밸리" >파인밸리</option>
		<option value="웨스트파인" >웨스트파인</option>
	</select>
	</td>
</tr>	
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* 등록단체명 : </td>
	<td style="width:850px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="group_name">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 희망요일 : </td>
	<td style="text-align:left">
	<select name="choice_date1" size="1">
        <option value="1" selected>1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
	</select>째주
	<select name="choice_date2" size="1">
  		<option value="월" selected>월</option>
  		<option value="화">화</option>
  		<option value="수">수</option>
  		<option value="목">목</option>
  		<option value="금">금</option>
  		<option value="토">토</option>
  		<option value="일">일</option>
		</select>요일
	<select name="choice_date3" size="1">
		<option value="01" selected>01</option>
  		<option value="02">02</option>
  		<option value="03">03</option>
  		<option value="04">04</option>
  		<option value="05">05</option>
  		<option value="06">06</option>
  		<option value="07">07</option>
  		<option value="08">08</option>
  		<option value="09">09</option>
  		<option value="10">10</option>
  		<option value="11">11</option>
  		<option value="12">12</option>
  		<option value="13">13</option>
  		<option value="14">14</option>
  		<option value="15">15</option>
  		<option value="16">16</option>
  		<option value="17">17</option>
  		<option value="18">18</option>
  		<option value="19">19</option>
  		<option value="20">20</option>
  		<option value="21">21</option>
  		<option value="22">22</option>
  		<option value="23">23</option>
  		<option value="24">24</option>
	</select>시
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 신청팀수  : </td>
	<td style="text-align:left">
	<input style="width: 300px" type="text" class="thin" name="order_team">팀
	<input style="width: 300px" type="text" class="thin" name="order_cnt">명
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 회장성명  : </td>
	<td style="text-align:left">
	이름 : <input style="width: 300px" type="text" class="thin" name="captain_name">
	아이디 :<input style="width: 300px" type="text" class="thin" name="captain_id">
	핸드폰 :<input style="width: 300px" type="text" class="thin" name="captain_hp">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 총무성명  : </td>
	<td style="text-align:left">
	이름 : <input style="width: 300px" type="text" class="thin" name="manager_name">
	아이디 :<input style="width: 300px" type="text" class="thin" name="manager_id">
	핸드폰 :<input style="width: 300px" type="text" class="thin" name="manager_hp">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 제출자성명  : </td>
	<td style="text-align:left">
	이름 : <input style="width: 300px" type="text" class="thin" name="order_name">
	아이디 :<input style="width: 300px" type="text" class="thin" name="order_id">
	핸드폰 :<input style="width: 300px" type="text" class="thin" name="order_hp">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* 객단가  : </td>
	<td style="text-align:left">
	<input style="width: 300px" type="text" class="thin" name="customer_tran">원
	</td>
</tr>	
<tr><td colspan="2">
	상기와 같이 연부킹 단체팀 운영규정을 준수할 것을 약속하며, 단체팀 운영규정에 동의합니다.
		<input type="checkbox" name="agree_yn" id="agree_yn" value="Y">
	<span class="btn white large"><input type="button" value="신청하기" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>