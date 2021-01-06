<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.ClubDataObject"  %>
<%@ page import="database.datadef.PrevAndNextDataObject"  %>

<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	$.extend({
		confirmDelete : function(global, local, db, page, doc, category) {
			if(!confirm("������ �����ϰڽ��ϱ�?")){
				return;
			}
			else{
				document.location = "/baas/blog/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&doc=" +doc +"&category="+category;
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
	
	
	ClubDataObject dataobj = new ClubDataObject();
	dataobj = (ClubDataObject)sqlMap.queryForObject("clubArticle", artclemap);
	
	// ��ȸ��  ����  ��ƾ
	sqlMap.update("countPlus", artclemap);
	
	
	String goList = null;
	String goEdit = null;
	String goURL = null;
	
	StringUtility strobj = new StringUtility();
	
	goList = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, categoryCode);
	goEdit = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "editform", pageNumber, docNumber, categoryCode);
	
	//out.println(docNumber);
%>
<br><br>
<div class="plate">
	<span class="button medium icon"><span class="refresh"></span><a href="<%=goList%>">���</a></span>
	
	<span class="button medium icon"><span class="check"></span><a href="<%=goEdit%>">����</a></span>
	<span class="button medium icon"><span class="delete"></span>
	<a href="JavaScript:$.confirmDelete('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=docNumber%>','<%= categoryCode%>');">����</a>
	</span>
	
</div>

<table class="bold"> 	
<tr>
	<th colspan="2"><%=dataobj.getTitle()%></th>
</tr>
<tr>
	<td align="left">
	<%=dataobj.getUser_id()%>(<%=dataobj.getUser_name()%>)<br>
	�з� : <%=dataobj.getCategory_name()%>
	 </td>
	<td align="right">
	<%=dataobj.getWrite_date()%> | <%=dataobj.getHitcount()%> hit<br> 
	
	</td>
</tr>
<tr><td colspan="2" class="line"><hr></td></tr>
<tr>	
	<td style="text-align:center" colspan="2">
<%= dataobj.getContent().replaceAll("\r", "<br>") %>
	</td>
</tr>
</table>
<%
	Map pnnmap = new HashMap();

	pnnmap.put("tableName", tableName);
	pnnmap.put("docNumber", Integer.toString(docNumber));
	
	if (!categoryCode.equals("AL")){
		pnnmap.put("categoryCode", categoryCode);
	}

	PrevAndNextDataObject pnndataobj = new PrevAndNextDataObject();
	pnndataobj = (PrevAndNextDataObject)sqlMap.queryForObject("clubPrevAndNextArticle", pnnmap);
	
	int nextNumber = pnndataobj.getNext_no();
	int prevNumber = pnndataobj.getPrev_no();
	
	String prevTitle = pnndataobj.getPrev_title();
	String nextTitle = pnndataobj.getNext_title();
%>


<table class="normal">	
<tr><td class="line"><hr></td></tr>
<tr>
	<td  style="text-align:left">������  : 
	<% 
		if (nextNumber == 0){
			out.println("��������  �����ϴ�");
		}
		else {
			goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, nextNumber, categoryCode);
	%>
		<a href="<%=goURL%>"><%= nextTitle%></a>
	<%
		}
	%><br>
	</td>
</tr>
<tr>	
	<td style="text-align:left">������  : 
	<% 
		if (prevNumber == 0){
			out.println("��������  �����ϴ�");
		}
		else { 
			goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, prevNumber, categoryCode);
	%>
		<a href="<%=goURL%>"><%= prevTitle%> </a></td>
	<%
		}
	%>
</tr>
</table>
