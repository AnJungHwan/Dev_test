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
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
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
	총  <%=totalCount%>명이 있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateForMemberURL(globalMenu, localMenu, dbName, "writeform", pageNumber);
	%>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">관리자생성</a></span>
	</td>
</tr>
</table>

<table class="list">	
<tr>
	<th>번호</th>
	<th>아이디</th>
	<th>이름</th>
	<th>사업장</th>
	<th>팀명</th>
	<th>직책</th>
	<th>접근권한</th>
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
        		out.println("<font  color=red>슈퍼관리자</font>");
        	}
        	else{
        		out.println("중간관리자");
        	}
       	%>
        </td>
        
<tr>
<%
		}
%>
</table>
