<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.LogInfoDataObject"  %>
<%@ page import="database.datadef.SuperuserDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--fff
$(document).ready(function(){
	$.extend({
		confirmDelete : function() {
			if(!confirm("���  �����Ͱ�  �������ϴ�.\n\n������ �����ϰڽ��ϱ�?")){
				return;
			}
			else{
				$.get("/baas/login/delete.jsp", function(data){
					alert("����  �Ǿ����ϴ�.");
					location.reload();
				});
			}
		}
	});
});
//-->
</script>

<%
	String accessLevel = null;
	if (sessionSuperuserAccessLevel.equals("SUPER")){
		accessLevel = "���۰�����";
	}
	else {
		accessLevel = "�߰�������";
	}
	
	int pageSize = 10;
	int currentPage = pageNumber;
	int startRow = currentPage * pageSize - pageSize +1;
	int endRow = currentPage * pageSize;
	int totalCount = 0;
	int number = 0;
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	String tableName = "tb_loginfo";
		
	Map countmap = new HashMap();
	
	countmap.put("tableName", tableName);
	
	if (sessionSuperuserAccessLevel.equals("MANAGER")){
		countmap.put("superuser_id", sessionSuperuserID);
	}
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCount", countmap)).intValue();
	
%>

<br><%=sessionSuperuserID%>(<%=sessionSuperuserName%>)���� <font color=red><%=accessLevel%></font> �������� �����ϼ̽��ϴ�.<br><br>

���� ���� : <%=application.getServerInfo() %><br><br>

���� ���� �ð�: <%=session.getMaxInactiveInterval()/60 %>�� <br><br>
			
�ֱ�  ���� ��Ȳ  �Դϴ�.<br><br>



<table class="normal"  style="width:700px">	
<tr>
	<td style="text-align:left;" >
	�� <%=totalCount %>���� ������ �־����ϴ�.
	</td>
	<td style="text-align:right;" >
	<%
		if(sessionSuperuserAccessLevel.equals("SUPER")){
	%>
	<span class="button medium icon"><span class="delete"></span><a href="JavaScript:$.confirmDelete()">����  ����  ����</a></span>
	<% } %>
	</td>
</tr>
</table>



<table class="list" style="width:700px">	
<tr>
	<th>����  ���̵�</th>
	<th>����  ����</th>
	<th>�α���  ��¥</th>
	<th>�α���  �ð�</th>
	<th>���� ������</th>
</tr>
<%
	
	Map pagemap = new HashMap();

	pagemap.put("tableName", tableName);

	if (sessionSuperuserAccessLevel.equals("MANAGER")){
		pagemap.put("superuser_id", sessionSuperuserID);
	}

	pagemap.put("pagingSize", Integer.toString(endRow));
	pagemap.put("startRow", Integer.toString(startRow));
	pagemap.put("endRow", Integer.toString(endRow));
	
	List list = new ArrayList();
	
	list = sqlMap.queryForList("logInfoPagingList", pagemap);	
	
	
	for(int i=0; i < list.size(); i++){
		LogInfoDataObject dataobj = (LogInfoDataObject) list.get(i);
%>
<tr>
        <td><%= dataobj.getSuperuser_id() %>(<%= dataobj.getSuperuser_name() %>)</td>
        <td>
       <%  if (dataobj.getAccess_level().equals("SUPER")){
    		 	out.println("���۰�����");
			}
			else {
				 out.println("�߰�������");
			}
       %>
        </td>
        <td><%= dataobj.getLogin_date() %></td>
        <td><%= dataobj.getLogin_time() %></td>
        <td><%= dataobj.getIpaddress()%></td>
<tr>
<%
		}
%>
</table><br><br>
<table>
<tr>
	<td>	
	<%
	
	if(totalCount >0) {
		int pageCount = totalCount / pageSize + (totalCount % pageSize == 0 ? 0 : 1);
		
		int startPage = (int)(currentPage/10)*10+1;
		int pageBlock = 10;
		int endPage = startPage + pageBlock-1;
		
		if(endPage > pageCount) endPage = pageCount;
		
		 String  goURL="#";
		
		if(startPage > 10) {
			int prevPage = startPage - 10;
			//goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", prevPage, divisionCode, accessCode);
		%>
			<a  href="index.jsp?cmd=main&page=<%=prevPage%>">[����]</a>
		<%
		}
		for(int i = startPage ; i <= endPage ; i++) {
			if (i==currentPage){
				out.println("[<b>"+ i +"</b>]");
			}
			else{
				//goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", i, divisionCode, accessCode);
		%>	
			<a  href="index.jsp?cmd=main&page=<%=i%>"><%=i %></a>
		<%	
			}
		}
		if (endPage < pageCount) {
			int nextPage = startPage + 10;
			//goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", nextPage, divisionCode, accessCode);
		%>	
			<a  href="index.jsp?cmd=main&page=<%=nextPage%>">[����]</a>
		<%	
		}
	}
	%>
		
</td></tr>
</table><br><br>
