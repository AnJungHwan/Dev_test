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
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}

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
	spw.keyup( function() {
		
		if (spw.val().length == 0) { 
			msgPW.text('* �ּ�  8����  �̻��̿���  �մϴ�.'); 
		} else if (spw.val().length < 8) { 
			msgPW.text('�ʹ�  ª���ϴ�.');
		} else if (spw.val().length > 8 & spw.val().length < 15) { 
			msgPW.text('����  �մϴ�.');	
		} else if (spw.val().length > 16) { 
			msgPW.text('�ʹ� ����.'); 
		} else{
			msgPW.text('�����Դϴ�.');
		}
	});
	$("#division").change(function() {
		var  value = $(this).val();
		$("#division_name").val(value);
	});
	
	
	$.extend({
		confirmDelete : function(id) {
			if(!confirm("������ �����ϰڽ��ϱ�?")){
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
	//������  �����´�..
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	SuperuserDataObject dataobj = new SuperuserDataObject();
	dataobj = (SuperuserDataObject)sqlMap.queryForObject("superuserArticle", Integer.toString(docNumber));

	goURL = strobj.generateForMemberURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
%>

<div class="plate">
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
		<span class="button medium icon"><span class="delete"></span><a href="JavaScript:$.confirmDelete('<%=dataobj.getSuperuser_id()%>')">����</a></span>
</div>
<div class="square"><br>�⺻ ����</div>

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
	<td style="color:#BB0000; font-weight:bold; text-align:right">* �̸� : </td>
	<td style="text-align:left" colspan=3>
		<%=dataobj.getSuperuser_name() %>
	</td>
</tr>
<tr>
	<td style="width:150px; color:#BB0000; font-weight:bold; text-align:right">* ��ȣ : </td>
	<td style="width:350px; text-align:left" >
		<input style="width: 150px" type="password" class="thin" name="superuser_pwd"  id="superuser_pwd" value="<%=dataobj.getSuperuser_pwd()%>">
		<span id="msgPW">* �ּ�  8��  �̻��̿���  �մϴ�.</span>
	</td>
	
	<td style="width:80px; color:#BB0000; font-weight:bold; text-align:right" >* Ȯ�� : </td>
	<td style="width:270px; text-align:left" >
		<input style="width: 150px" type="password" class="thin" name="superuser_pwd_check"  id="superuser_pwd_check" value="<%=dataobj.getSuperuser_pwd()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* �̸��� : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 250px" type="text" class="thin" name="email"  id="email" value="<%=dataobj.getEmail()%>">
	</td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* ��ȭ��ȣ : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 150px" type="text" class="thin" name="telephone"  id="telephone"  value="<%=dataobj.getTelephone()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* ��å : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 100px" type="text" class="thin" name="position"  id="position"  value="<%=dataobj.getPosition()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* ���� : </td>
	<td style="text-align:left" colspan=3>
		<input style="width: 150px" type="text" class="thin" name="team"  id="team"  value="<%=dataobj.getTeam()%>">
	</td>
</tr>
<tr>
	<td style="color:#BB0000; font-weight:bold; text-align:right" >* �Ҽ� ����� : </td>
	<td style="text-align:left" colspan=3>
		<select name="division" class="thin" style="width:150px;"  id="division">
		<option value="���緹��" <% if (dataobj.getDivision().equals("���緹��")) out.println("selected"); %>>���緹��</option>
		<option value="����ũ��ũ" <% if (dataobj.getDivision().equals("����ũ��ũ")) out.println("selected"); %>>����ũ��ũ</option>
		<option value="���ι븮" <% if (dataobj.getDivision().equals("���ι븮")) out.println("selected"); %>>���ι븮</option>
		</select>
	</td>
</tr>
<tr>	
	<td style="color:#BB0000; font-weight:bold; text-align:right">* ���� : </td>
	<td style="text-align:left"  colspan=3>
		<% 
			if (dataobj.getAccess_level().equals("MANAGER")){ 
				out.println("�߰�  ������");
			}	
			else{ 
				out.println("����  ������");
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
			<div class="square"><br>���� ����</div>

			<table class="normal">
			<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >����  ���� : </td>
			<td style="width:700px; text-align:left" colspan=3>
				<select name="division_name" class="thin" style="width:150px;"  id="division_name">
				<option value="���緹��" <% if (dataobj.getDivision().equals("���緹��")) out.println("selected"); %>>���緹��</option>
				<option value="����ũ��ũ" <% if (dataobj.getDivision().equals("����ũ��ũ")) out.println("selected"); %>>����ũ��ũ</option>
				<option value="���ι븮" <% if (dataobj.getDivision().equals("���ι븮")) out.println("selected"); %>>���ι븮</option>
				</select>
			</td>
		</tr>
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >�ü��� ���� : </td>
			<td style="text-align:left" >
				<input type="checkbox" name="restaurant" value="1"> ��Ĵ�
				<input type="checkbox" name="proshop" value="1"> ���μ�
			</td>
		</tr>	
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >Ŭ�� �ҽ� : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="notice" value="1"> ��������
				<input type="checkbox"  name="event" value="1"> �̺�Ʈ
				<input type="checkbox"  name="news" value="1"> ȸ���ҽ���
				<input type="checkbox"  name="gallery" value="1"> ���䰶����
				<input type="checkbox"  name="booking" value="1"> ����ü ����Ʈ
				<input type="checkbox"  name="webzine" value="1" checked> THE PINE ���� 
			</td>
		</tr>	
		<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >��  ���� : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="faq" value="1"> FAQ
				<input type="checkbox"  name="pds" value="1"> �ڷ��
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
			<div class="square"><br>���� ����</div>

			<table class="normal">
			<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >����  ���� : </td>
			<td style="width:700px; text-align:left" colspan=3>
				<select name="division_name" class="thin" style="width:150px;"  id="division_name">
				<option value="���緹��" <% if (accessDivisionName.equals("���緹��")) out.println("selected"); %>>���緹��</option>
				<option value="����ũ��ũ" <% if (accessDivisionName.equals("����ũ��ũ")) out.println("selected"); %>>����ũ��ũ</option>
				<option value="���ι븮" <% if (accessDivisionName.equals("���ι븮")) out.println("selected"); %>>���ι븮</option>
				</select>
			</td>
		</tr>
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >�ü��� ���� : </td>
			<td style="text-align:left" >
				<input type="checkbox" name="restaurant" value="1" <%if (accessDB.matches(".*restaurant.*")) out.println("checked"); %> > ��Ĵ�
				<input type="checkbox" name="proshop" value="1" <%if (accessDB.matches(".*proshop.*")) out.println("checked"); %>> ���μ�
			</td>
		</tr>	
		<tr>
			<td style="color:#000; font-weight:bold; text-align:right" >Ŭ�� �ҽ� : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="notice" value="1" <%if (accessDB.matches(".*notice.*")) out.println("checked"); %>> ��������
				<input type="checkbox"  name="event" value="1" <%if (accessDB.matches(".*event.*")) out.println("checked"); %>> �̺�Ʈ
				<input type="checkbox"  name="news" value="1" <%if (accessDB.matches(".*news.*")) out.println("checked"); %>> ȸ���ҽ���
				<input type="checkbox"  name="gallery" value="1" <%if (accessDB.matches(".*gallery.*")) out.println("checked"); %>> ���䰶����
				<input type="checkbox"  name="booking" value="1" <%if (accessDB.matches(".*booking.*")) out.println("checked"); %>> ����ü ����Ʈ
				<input type="checkbox"  name="webzine" value="1" <%if (accessDB.matches(".*webzine.*")) out.println("checked"); %>> THE PINE ���� 
			</td>
		</tr>	
		<tr>
			<td style="width:150px; color:#000; font-weight:bold; text-align:right" >��  ���� : </td>
			<td style="text-align:left" >
				<input type="checkbox"  name="faq" value="1" <%if (accessDB.matches(".*faq.*")) out.println("checked"); %>> FAQ
				<input type="checkbox"  name="pds" value="1" <%if (accessDB.matches(".*pds.*")) out.println("checked"); %>> �ڷ��
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
	<span class="btn white large"><input  type="submit" class="btn" value="������  ����"></span>
	</td>
</tr>
</table>

</form>
 
<br><br>
