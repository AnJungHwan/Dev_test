<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.PopupSkinDataObject"  %>
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
	var 	title = $('[name="title"]');
	$.extend({
		submitForm : function() {
			if( title.val() == '') {
				alert("��Ų���� �Է��ϼ���.");
				title.focus();
				return;
			}
			callSwfUpload('"formName"'); 
		}
	});
	$.extend({
		confirmDelete : function(global, local, db, page, doc) {
			if(!confirm("������ �����ϰڽ��ϱ�?")){
				return;
			}
			else{
				document.location = "/baas/popup_skin/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&doc=" +doc;
			} 
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
  	
  	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
  	 
  	  	
  	//������  �����´�..
  	  		
  	PopupSkinDataObject dataobj = new PopupSkinDataObject();
  	dataobj = (PopupSkinDataObject)sqlMap.queryForObject("popupSkinArticle",  Integer.toString(docNumber));

  	
  	StringUtility strobj = new StringUtility();
  	String goURL="";
 %>
<div class="plate">
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
		<span class="button medium icon"><span class="delete"></span>
		<a href="JavaScript:$.confirmDelete('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=docNumber%>');">����</a>
	</span>
	
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/popup_skin/edit.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* ��Ų�� : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="title" value="<%= dataobj.getTitle() %>">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* ��Ų �̹��� : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //������ ����ID
				flash_width='400', //������ �ʺ� (�⺻�� 400, �����ּ� 300)
				limit_size='10', // ���ε� ���ѿ뷮 (�⺻�� 10)
				file_type_name='�׸�����', // ���ϼ���â �������ĸ� (��: �׸�����, ��������, ������� ��)
				allow_filetype=' *.jpg *.gif', // ���ϼ���â �������� (��: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // ���ε� �Ұ����� 
				upload_exe='/baas/include/upload.jsp', // ���ε� ������α׷�
				browser_id='<%=session.getId()%>'
			);
		</script><br><br>
		<% 
		if(dataobj.getFilename() != null) {
			out.println("���� ��Ų ���� : " + dataobj.getFilename());
			out.println("<font  color=red>** ������ ���� ÷���Ͻø� ���� ��Ų ������ ���� ���ϴ�.</font>");
		%>
			<input type="hidden" name="filename" value="<%=dataobj.getFilename()%>">
		<%
		}
		else  {
		%>
			<input type="hidden" name="filename">
		<%
		}
		%>
	</td>
</tr>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ��� : </td>
	<td style="text-align:left">
	<select name="is_view" class="thin" style="width:150px;"  id="view_type">
	<option value="Y" <% if (dataobj.getIs_view().equals("Y"))  out.println("selected");  %>>���</option>
	<option value="N" <% if (dataobj.getIs_view().equals("N"))  out.println("selected");  %>>�̻��</option>
	</select>
	</td>
</tr>	
<tr><td class="line" colspan=2><hr></td></tr>
<tr><td colspan="2">
	<input type="hidden" name="width" value="<%= dataobj.getWidth()%>">
	<input type="hidden" name="height" value="<%=  dataobj.getHeight()%>">

	<input type="hidden" name="global_menu" value="<%= globalMenu%>">
	<input type="hidden" name="local_menu" value="<%= localMenu%>">
	<input type="hidden" name="db" value="<%= dbName%>">
	<input type="hidden" name="doc" value="<%= docNumber%>">
	<input type="hidden" name="page" value="<%= pageNumber%>">
	
	
	<span class="btn white large"><input type="button" value="�����ϱ�" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>


 
<br><br>
