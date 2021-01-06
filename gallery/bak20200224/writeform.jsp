<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.GalleryStorageDataObject"  %>
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
				alert("������ �Է��ϼ���.");
				title.focus();
				return;
			}
			 callSwfUpload('"formName"');	 
		}
	});
});
//-->
</script>
 <%
 application.removeAttribute(session.getId());
	StringUtility strobj = new StringUtility();

	int isAccess = 0;
	String goURL="";

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	AclDataObject acldataobj = new AclDataObject();
	
	if (accessCode.equals("AL") && sessionSuperuserAccessLevel.equals("SUPER")){
		accessCode = "PC"; //  ���۰����ڰ�  ��ü���⿡�� �۾����   ��������  �׼���  �ڵ带  ����ũ��ũ��  �����Ѵ�.
	}
	
	Map map = new HashMap();
	map.put("superuserID", sessionSuperuserID);
	map.put("dbName", dbName);
	map.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", map);
	isAccess  = acldataobj.getIs_access();
	String  divisionName = acldataobj.getDivision_name(); 
	
	if (isAccess==0){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}
	
%>
<div class="plate">
	<%
		goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode, accessCode);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/gallery/write.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ���� : </td>
	<td style="width:850px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="title">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ����� : </td>
	<td style="text-align:left">
	<select name="division_name" class="thin" style="width:150px;">
	<%
	
	if (sessionSuperuserAccessLevel.equals("SUPER")){
	%>
		<option value="����ũ��ũ" <% if (accessCode.equals("PC")) { out.println("selected"); } %>>����ũ��ũ</option>
		<option value="���ι븮" <% if (accessCode.equals("PV")) { out.println("selected"); } %>>���ι븮</option>
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
	<td style="color:#000; font-weight:bold; text-align:right" >* ����  : </td>
	<td style="text-align:left">
	<script language="javascript">
	makeSwfMultiUpload(
			movie_id='smu03', //������ ����ID 
			flash_width='400', //������ �ʺ� (�⺻�� 400, �����ּ� 300)
			list_rows='10', // ���ϸ�� �� (�⺻��:3)
			limit_size='100', // ���ε� ���ѿ뷮 (�⺻�� 10)
			file_type_name='�������', // ���ϼ���â �������ĸ� (��: �׸�����, ��������, ������� ��)
			allow_filetype='*.jpg *.gif *.wmv', // ���ϼ���â �������� (��: *.jpg *.jpeg *.gif *.png)
			deny_filetype='*.cgi *.pl', // ���ε� �Ұ����� 
			upload_exe='/baas/include/upload.jsp', // ���ε� ������α׷�
			browser_id='<%=session.getId()%>'
			);
		</script>
		<br>
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

	
	<span class="btn white large"><input type="button" value="���� ���" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>
