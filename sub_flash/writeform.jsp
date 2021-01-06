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
	
	var numbers = /^[0-9]{1,4}$/; // ���ڰ˻�
	var title = $('[name="title"]');
	var location = $('[name="location"]');
	$.extend({
		submitForm : function() {

			 if( title.val() == '') {
					alert("�÷���  �̸��� �Է��ϼ���.");
					title.focus();
					return;
			}
			else if(numbers.test(location.val()) != true) {
				alert("������  ���ڷ�  �Է���  �ּ���.");
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
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>");
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
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/sub_flash/write.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* �÷��ø� : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="title">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ����� : </td>
	<td style="text-align:left">
	<select name="division_name" class="thin" style="width:150px;">
		<option value="����ũ��ũ" <% if (divisionCode.equals("PC")) { out.println("selected"); } %>>����ũ��ũ</option>
		<option value="���ι븮" <% if (divisionCode.equals("PV")) { out.println("selected"); } %>>���ι븮</option>
	</select>
	</td>
</tr>	
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* ���� : </td>
	<td style="text-align:left">
	<input style="width: 20px" type="text" class="thin" name="location" maxlength="2">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* �÷��� : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //������ ����ID
				flash_width='400', //������ �ʺ� (�⺻�� 400, �����ּ� 300)
				limit_size='10', // ���ε� ���ѿ뷮 (�⺻�� 10)
				file_type_name='�÷�������', // ���ϼ���â �������ĸ� (��: �׸�����, ��������, ������� ��)
				allow_filetype=' *.swf ', // ���ϼ���â �������� (��: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl *.exe', // ���ε� �Ұ����� 
				upload_exe='/baas/include/upload.jsp', // ���ε� ������α׷�
				browser_id='<%=session.getId()%>'
			);
		</script>
	<br>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ��� : </td>
	<td style="text-align:left">
	<select name="is_view" class="thin" style="width:150px;"  id="is_view">
	<option value="Y" selected> ���</option>
	<option value="N"> �̻�� </option>
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
	
	<span class="btn white large"><input type="button" value="�÷���  ���" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>

</table>
</form>


 
<br><br>
