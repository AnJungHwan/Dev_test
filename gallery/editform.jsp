<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.GalleryDataObject"  %>
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
	$.extend({
		confirmDelete : function(global, local, db, page, div, id, code) {
			if(!confirm("����!!! \n\n�ش� ������ ���� ��ü�� ���� ���ϴ�.\n\n������ �����ϰڽ��ϱ�?")){
				return;
			}
			else{
				document.location = "/baas/gallery/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&div=" + div + "&id=" +id +"&code="+code;
			}
		}
	});
});
//-->
</script>

 <%
	int isAccess = 0;
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	AclDataObject acldataobj = new AclDataObject();
	
	Map map = new HashMap();
	map.put("superuserID", sessionSuperuserID);
	map.put("dbName", dbName);
	map.put("accessCode", accessCode);

	//999 ����.  Ÿ ������ΰ�� Ȯ�� �ʿ�.
	//acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", map);
	//isAccess  = acldataobj.getIs_access();    //����
	//String  divisionName = acldataobj.getDivision_name();  ������
	
	isAccess = 1;   //����
	String  divisionName = "���緹��";
	
	//out.println("<script>alert(' test ');</script>");
	//out.println("<script>alert('" + divisionName + "');</script>");     //  ���緹��
	
	//alert(divisionName);
	
	if (isAccess==0){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}
	
	//������  �����´�..
	String tableName = "tb_" + dbName;
	Map artclemap = new HashMap();

	artclemap.put("tableName", tableName);
	artclemap.put("docNumber", Integer.toString(docNumber));
		
	
	//out.println("<script>alert('" + tableName + "');</script>"); 
	//out.println("<script>alert('" + docNumber + "');</script>"); 
	
	GalleryDataObject dataobj = new GalleryDataObject();
	dataobj = (GalleryDataObject)sqlMap.queryForObject("galleryArticle", artclemap);

	StringUtility strobj = new StringUtility();
	String goURL=null;
%>
<div class="plate">
	<%
		goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode, accessCode);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
	<% if  (isAccess  == 1) { %>
		<span class="button medium icon"><span class="delete"></span>
		<a href="JavaScript:$.confirmDelete('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=divisionCode %>','<%=dataobj.getGallery_code()%>','<%=accessCode%>');">����</a>
		</span>
	<% } %>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/gallery/edit.jsp">
<tr><td class="line" colspan=2><hr></td></tr>
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ���� : </td>
	<td style="width:850px; text-align:left">
	<input style="width: 300px" type="text" class="thin" name="title" value="<%=dataobj.getTitle()%>">
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ����� : </td>
	<td style="text-align:left">
	<select name="division_name" class="thin" style="width:150px;">
	<%
	
	if (sessionSuperuserAccessLevel.equals("SUPER")){
	%>
		<option value="����ũ��ũ" <%if (dataobj.getDivision_name().equals("����ũ��ũ"))  out.println("selected");  %>>����ũ��ũ</option>
		<option value="����ũ��ũ(����)" <%if (dataobj.getDivision_name().equals("����ũ��ũ(����)"))  out.println("selected");  %>>����ũ��ũ(����)</option>
		<option value="����ũ��ũ(��)" <%if (dataobj.getDivision_name().equals("����ũ��ũ(��)"))  out.println("selected");  %>>����ũ��ũ(��)</option>
		<option value="����ũ��ũ(����)" <%if (dataobj.getDivision_name().equals("����ũ��ũ(����)"))  out.println("selected");  %>>����ũ��ũ(����)</option>
		<option value="����ũ��ũ(����)" <%if (dataobj.getDivision_name().equals("����ũ��ũ(����)"))  out.println("selected");  %>>����ũ��ũ(����)</option>
		<option value="����ũ��ũ(�ܿ�)" <%if (dataobj.getDivision_name().equals("����ũ��ũ(�ܿ�)"))  out.println("selected");  %>>����ũ��ũ(�ܿ�)</option>
		<option value="����ũ��ũ(����ü������)" <%if (dataobj.getDivision_name().equals("����ũ��ũ(����ü������)"))  out.println("selected");  %>>����ũ��ũ(����ü������)</option>
		<option value="����ũ��ũ(��Ÿ���)" <%if (dataobj.getDivision_name().equals("����ũ��ũ(��Ÿ���)"))  out.println("selected");  %>>����ũ��ũ(��Ÿ���)</option>
		<option value="���ι븮" <%if (dataobj.getDivision_name().equals("���ι븮"))  out.println("selected");  %>>���ι븮</option>
		<option value="���ι븮(����)" <%if (dataobj.getDivision_name().equals("���ι븮(����)"))  out.println("selected");  %>>���ι븮(����)</option>
		<option value="���ι븮(��)" <%if (dataobj.getDivision_name().equals("���ι븮(��)"))  out.println("selected");  %>>���ι븮(��)</option>
		<option value="���ι븮(����)" <%if (dataobj.getDivision_name().equals("���ι븮(����)"))  out.println("selected");  %>>���ι븮(����)</option>
		<option value="���ι븮(����)" <%if (dataobj.getDivision_name().equals("���ι븮(����)"))  out.println("selected");  %>>���ι븮(����)</option>
		<option value="���ι븮(�ܿ�)" <%if (dataobj.getDivision_name().equals("���ι븮(�ܿ�)"))  out.println("selected");  %>>���ι븮(�ܿ�)</option>
		<option value="���ι븮(��Ÿ���)" <%if (dataobj.getDivision_name().equals("���ι븮(��Ÿ���)"))  out.println("selected");  %>>���ι븮(��Ÿ���)</option>
		
	<%	
	}
	else {
	%>
		<option value="<%=dataobj.getDivision_name()%>"><%=dataobj.getDivision_name() %></option>
	<%	
	}
	%>
	</select>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right" >* ��ǥ ���� : </td>
	<td style="text-align:left">
	<script language="javascript">
			makeSwfSingleUpload(
				movie_id='smu01', //������ ����ID
				flash_width='400', //������ �ʺ� (�⺻�� 400, �����ּ� 300)
				limit_size='10', // ���ε� ���ѿ뷮 (�⺻�� 10)
				file_type_name='�������', // ���ϼ���â �������ĸ� (��: �׸�����, ��������, ������� ��)
				allow_filetype=' *.* ', // ���ϼ���â �������� (��: *.jpg *.jpeg *.gif *.png)
				deny_filetype='*.cgi *.pl', // ���ε� �Ұ����� 
				upload_exe='/baas/include/upload.jsp', // ���ε� ������α׷�
				browser_id='<%=session.getId()%>'
			);
		</script>
	<br><br>
	<% 
		if(dataobj.getGallery_filename() != null) {
			out.println("���� ���� ���� : " + dataobj.getGallery_filename());
	%>
		<input type="hidden" name="gallery_filename" value="<%=dataobj.getGallery_filename()%>">
	<%
		}
		else  {
	%>
		<input type="hidden" name="gallery_filename">
	<%
		}
	%>
	
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
	
	<span class="btn white large"><input type="button" value="�����ϱ�" class="btn" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>