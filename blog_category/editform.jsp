<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.ClubCategoryDataObject"  %>
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
	var 	category_name = $('[name="category_name"]');
	$.extend({
		submitForm : function() {
			if( category_name.val() == '') {
				alert("�з����� �Է��ϼ���.");
				category_name.focus();
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
				document.location = "/baas/blog_category/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&doc=" +doc;
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
  	String tableName = "tb_" + dbName;
  	Map artclemap = new HashMap();

  	artclemap.put("tableName", tableName);
  	artclemap.put("docNumber", Integer.toString(docNumber));
  		
  		
  	ClubCategoryDataObject dataobj = new ClubCategoryDataObject();
  	dataobj = (ClubCategoryDataObject)sqlMap.queryForObject("clubCategoryArticle", artclemap);

  	
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
<form method="post" name="formName" action="/baas/blog_category/edit.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:150px; color:#000; font-weight:bold; text-align:right">* �з��� : </td>
	<td style="width:700px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="category_name" value="<%= dataobj.getCategory_name() %>">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* �з� �̹��� : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //������ ����ID
				flash_width='400', //������ �ʺ� (�⺻�� 400, �����ּ� 300)
				limit_size='10', // ���ε� ���ѿ뷮 (�⺻�� 10)
				file_type_name='�������', // ���ϼ���â �������ĸ� (��: �׸�����, ��������, ������� ��)
				allow_filetype=' *.jpg ', // ���ϼ���â �������� (��: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // ���ε� �Ұ����� 
				upload_exe='/baas/include/upload.jsp', // ���ε� ������α׷�
				browser_id='<%=session.getId()%>'
			);
		</script><br><br>
		<% 
		if(dataobj.getMenu_filename() != null) {
			out.println("���� ÷�� ���� : " + dataobj.getMenu_filename());
			out.println("<font  color=red>** ������ ���� ÷���Ͻø� ���� ÷�������� ���� ���ϴ�.</font>");
		%>
			<input type="hidden" name="menu_filename" value="<%=dataobj.getMenu_filename()%>">
		<%
		}
		else  {
		%>
			<input type="hidden" name="menu_filename">
		<%
		}
		%>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* Ÿ��Ʋ �̹��� : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu02', //������ ����ID
				flash_width='400', //������ �ʺ� (�⺻�� 400, �����ּ� 300)
				limit_size='10', // ���ε� ���ѿ뷮 (�⺻�� 10)
				file_type_name='�������', // ���ϼ���â �������ĸ� (��: �׸�����, ��������, ������� ��)
				allow_filetype=' *.jpg ', // ���ϼ���â �������� (��: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // ���ε� �Ұ����� 
				upload_exe='/baas/include/upload.jsp', // ���ε� ������α׷�
				browser_id='<%=session.getId()%>'
			);
		</script><br><br>
		<% 
		if(dataobj.getTitle_filename() != null) {
			out.println("���� ÷�� ���� : " + dataobj.getTitle_filename());
			out.println("<font  color=red>** ������ ���� ÷���Ͻø� ���� ÷�������� ���� ���ϴ�.</font>");
		%>
			<input type="hidden" name="title_filename" value="<%=dataobj.getTitle_filename()%>">
		<%
		}
		else  {
		%>
			<input type="hidden" name="title_filename">
		<%
		}
		%>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ����Ÿ�� : </td>
	<td style="text-align:left">
	<select name="view_type" class="thin" style="width:150px;"  id="view_type">
	<option value="type1" <% if (dataobj.getView_type().equals("type1"))  out.println("selected");  %>> Type 1</option>
	<option value="type2" <% if (dataobj.getView_type().equals("type2"))  out.println("selected");  %>> Type 2</option>
	</select>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right"> </td>
	<td style="text-align:left"><br><br>
	* Type 1<br>
	<img src=/baas/images/sample_01.jpg><br><br>
	* Type 2<br>
	<img src=/baas/images/sample_02.jpg><br><br>
	
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
	
	
	<span class="btn white large"><input type="button" value="�����ϱ�" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>


 
<br><br>
