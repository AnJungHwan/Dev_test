<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.SuperuserDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="common.utility.StringUtility"  %>


<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

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
	
	int pageSize = 10;
	int currentPage = pageNumber;
	int startRow = currentPage * pageSize - pageSize +1;
	int endRow = currentPage * pageSize;
	int totalCount = 0;
	int number = 0;
	
	StringUtility strobj = new StringUtility();
	String goURL="";
	
	String tableName = "tb_" + dbName;
	Map countmap = new HashMap();
	
	countmap.put("tableName", tableName);
	countmap.put("searchKey", "superuser_id");
	countmap.put("searchValue", sessionSuperuserID);
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCountSuperuser", countmap)).intValue();
%>

<table class="normal">	
<tr>
	<td style="text-align:left;" >
	��  <%=totalCount%>���� �ֽ��ϴ�. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateForMemberURL(globalMenu, localMenu, dbName, "writeform", pageNumber);
	%>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">�����ڻ���</a></span>
	</td>
</tr>
</table>

<table class="list">	
<tr>
	<th>��ȣ</th>
	<th>���̵�</th>
	<th>�̸�</th>
	<th>�����</th>
	<th>����</th>
	<th>��å</th>
	<th>���ٱ���</th>
</tr>
<%
	int virtualNumber =0;
	List sulist = new ArrayList();

	sulist = sqlMap.queryForList("superuserList");
	for(int i=0; i < sulist.size(); i++){
		SuperuserDataObject dataobj = (SuperuserDataObject) sulist.get(i);
		virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
<tr>
        <td><%= virtualNumber %></td>
        <td>
        <% 
        	goURL = strobj.generateForMemberURL(globalMenu, localMenu, dbName, "editform", pageNumber, dataobj.getSeq_no() );
        %>
        <a href="<%= goURL %>"><%= dataobj.getSuperuser_id()%></a>
        
        
        </td>
        <td><%= dataobj.getSuperuser_name() %></td>
        <td><%= dataobj.getDivision() %></td>
        <td><%= dataobj.getTeam() %></td>
        <td><%= dataobj.getPosition() %></td>
        <td>
        <%
        	if(dataobj.getAccess_level().equals("SUPER")){
        		out.println("<font  color=red>���۰�����</font>");
        	}
        	else{
        		out.println("�߰�������");
        	}
       	%>
        </td>
        
<tr>
<%
		}
%>
</table>
