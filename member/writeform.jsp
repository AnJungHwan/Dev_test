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
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	StringUtility strobj = new StringUtility();
	String goURL="";
%>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	var re_id = /^[a-z0-9_-]{4,16}$/; // ���̵� �˻��
	var re_pw = /^[a-z0-9_-]{4,16}$/; // ��й�ȣ �˻��
	var re_email = /^([\w\.-]+)@([a-z\d\.-]+)\.([a-z\.]{2,6})$/; // �̸��� �˻��
	var re_tel = /^[0-9]{8,11}$/; // ��ȭ��ȣ �˻��
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
			alert("��ȿ��  ID��  �Է���  �ּ���.");
			sid.focus();
			return false;
		}
		else if( sname.val() == '') {
			alert("�̸���  �Է���  �ּ���.");
			sname.focus();
			return false;
		}
		else if( spw.val() == '') {
			alert("��ȣ�� �Է���  �ּ���.");
			spw.focus();
			return false;
		}
		else if( spwc.val() == '') {
			alert("��ȣ Ȯ���� �Է���  �ּ���.");
			spwc.focus();
			return false;
		}
		else if( spw.val() != spwc.val()) {
			alert("��ȣ�� ���� �ٸ��ϴ�.");
			spw.focus();
			return false;
		}
		else if( email.val() == '') {
			alert("�̸����� �Է���  �ּ���.");
			email.focus();
			return false;
		}
		else if( tel.val() == '') {
			alert("��ȭ��ȣ�� �Է���  �ּ���.");
			tel.focus();
			return false;
		}
		else if( team.val() == '') {
			alert("������ �Է���  �ּ���.");
			tel.focus();
			return false;
		}
		else if( position.val() == '') {
			alert("��å�� �Է���  �ּ���.");
			position.focus();
			return false;
		}
	});
	sid.keyup( function() {
		
		if (sid.val().length == 0) { 
			msgID.text('* 4�� �̻� 16��  ������ ���� �ҹ���, ���ڸ�   �����մϴ�.'); 
		} else if (sid.val().length < 4) { 
			msgID.text('�ʹ� ª���ϴ�.'); 
		} else if (sid.val().length > 16) { 
			msgID.text('�ʹ� ����.'); 
		} else{
			msgID.text('�����մϴ�.');
		}
	});
	spw.keyup( function() {
		
		if (spw.val().length == 0) { 
			msgPW.text('* �ּ�  3��  �̻��̿���  �մϴ�.'); 
		} else if (spw.val().length < 4) { 
			msgPW.text('�ʹ�  ª���ϴ�.');
		} else if (spw.val().length > 8 & spw.val().length < 15) { 
			msgPW.text('����  �մϴ�.');	
		} else if (spw.val().length > 16) { 
			msgPW.text('�ʹ� ����.'); 
		} else{
			msgPW.text('�����Դϴ�.');
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
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
</div>
<div class="square"><br>�⺻ ����</div>


<form method="post" action="/baas/member/write.jsp" name="writeForm" id="writeForm">
<table class="normal">
<tr>
	<td style="width:150px; color:#BB0000; font-weight:bold; text-align:right">* ID : </td>
	<td style="width:700px; text-align:left" colspan=3 ><input style="width: 150px" type="text" class="thin" name="superuser_id" id="superuser_id">
	<span id="msgID">* 4�� �̻� 16��  ������ ���� �ҹ���, ���ڸ�   �����մϴ�.</span>
	</td>
</tr>	
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right">* �̸� : </td>
	<td style="text-align:left" colspan=3><input style="width: 150px" type="text" class="thin" name="superuser_name"  id="superuser_name"></td>
</tr>
<tr>
	<td style="width:150px; color:#BB0000; font-weight:bold; text-align:right">* ��ȣ : </td>
	<td style="width:350px; text-align:left" ><input style="width: 150px" type="password" class="thin" name="superuser_pwd"  id="superuser_pwd">
	<span id="msgPW">* �ּ�  3��  �̻��̿���  �մϴ�.</span>
	</td>
	
	<td style="width:80px; color:#BB0000; font-weight:bold; text-align:right" >* ��ȣȮ�� : </td>
	<td style="width:270px; text-align:left" ><input style="width: 150px" type="password" class="thin" name="superuser_pwd_check"  id="superuser_pwd_check"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* �̸��� : </td>
	<td style="text-align:left" colspan=3><input style="width: 250px" type="text" class="thin" name="email"  id="email"></td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* ��ȭ��ȣ : </td>
	<td style="text-align:left" colspan=3><input style="width: 150px" type="text" class="thin" name="telephone"  id="telephone"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* ��å : </td>
	<td style="text-align:left" colspan=3><input style="width: 100px" type="text" class="thin" name="position"  id="position"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* ���� : </td>
	<td style="text-align:left" colspan=3><input style="width: 150px" type="text" class="thin" name="team"  id="team"></td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* �Ҽ� ����� : </td>
	<td style="text-align:left" colspan=3>
		<select name="division" class="thin" style="width:150px;"  id="division">
		<option value="���緹��" selected>���緹��</option>
		<option value="����ũ��ũ">����ũ��ũ</option>
		<option value="���ι븮">���ι븮</option>
		</select>
	</td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right">* ���� : </td>
	<td style="text-align:left"  colspan=3>
		<select name="access_level" class="thin" style="width:150px;"   id="access_level">
		<option value="MANAGER" selected>�߰� ������</option>
		<option value="SUPER">���� ������</option>
		</select>
		* <font color="red">����  ������</font>��  ���ٱ��ѿ���  �����ϰ�  ���  ������  �����ϴ�.
	
	</td>
</tr>
</table>
<input type="hidden" name="create_date" id="create_date" value="2011-10-10">
<input type="hidden" name="create_time" id="create_time" value="00:00:00">
<input type="hidden" name="ipaddress" id="ipaddress" value="111111">

<div class="square"><br>���� ����</div>

<table class="normal">
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right" >����  ���� : </td>
	<td style="width:700px; text-align:left" colspan=3>
		<select name="division_name" class="thin" style="width:150px;"  id="division_name">
		<option value="���緹��" selected>���緹��</option>
		<option value="����ũ��ũ">����ũ��ũ</option>
		<option value="���ι븮">���ι븮</option>
		</select>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >�ü��� ���� : </td>
	<td style="text-align:left" >
	<input type="checkbox" name="restaurant" value="1" checked> ��Ĵ�
	<input type="checkbox" name="proshop" value="1" checked> ���μ�
	</td>
</tr>	

<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >Ŭ�� �ҽ� : </td>
	<td style="text-align:left" >
	<input type="checkbox"  name="notice" value="1" checked > ��������
	<input type="checkbox"  name="event" value="1" checked > �̺�Ʈ
	<input type="checkbox"  name="news" value="1" checked> ȸ���ҽ���
	<input type="checkbox"  name="gallery" value="1" checked> ���䰶����
	<input type="checkbox"  name="booking" value="1" checked> ����ü ����Ʈ
	<input type="checkbox"  name="webzine" value="1" checked> THE PINE ���� 
	</td>
</tr>	

<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right" >��  ���� : </td>
	<td style="text-align:left" >
	<input type="checkbox"  name="faq" value="1" checked> FAQ
	<input type="checkbox"  name="pds" value="1" checked> �ڷ��
	</td>
</tr>	

<tr>
	<td colspan="2">
	<hr><br/>
	<span class="btn white large"><input  type="submit" class="btn" value="������  ����"></span>
	</td>
</tr>
</table>
</form>
 
<br><br>
