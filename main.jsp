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
			if(!confirm("모든  데이터가  지워집니다.\n\n정말로 삭제하겠습니까?")){
				return;
			}
			else{
				$.get("/baas/login/delete.jsp", function(data){
					alert("삭제  되었습니다.");
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
		accessLevel = "슈퍼관리자";
	}
	else {
		accessLevel = "중간관리자";
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

<br><%=sessionSuperuserID%>(<%=sessionSuperuserName%>)님이 <font color=red><%=accessLevel%></font> 권한으로 접속하셨습니다.<br><br>

접속 서버 : <%=application.getServerInfo() %><br><br>

세션 유지 시간: <%=session.getMaxInactiveInterval()/60 %>분 <br><br>
			
최근  접속 현황  입니다.<br><br>



<table class="normal"  style="width:700px">	
<tr>
	<td style="text-align:left;" >
	총 <%=totalCount %>번의 접속이 있었습니다.
	</td>
	<td style="text-align:right;" >
	<%
		if(sessionSuperuserAccessLevel.equals("SUPER")){
	%>
	<span class="button medium icon"><span class="delete"></span><a href="JavaScript:$.confirmDelete()">접속  정보  삭제</a></span>
	<% } %>
	</td>
</tr>
</table>



<table class="list" style="width:700px">	
<tr>
	<th>접속  아이디</th>
	<th>접속  권한</th>
	<th>로그인  날짜</th>
	<th>로그인  시간</th>
	<th>접속 아이피</th>
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
    		 	out.println("슈퍼관리자");
			}
			else {
				 out.println("중간관리자");
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
			<a  href="index.jsp?cmd=main&page=<%=prevPage%>">[이전]</a>
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
			<a  href="index.jsp?cmd=main&page=<%=nextPage%>">[다음]</a>
		<%	
		}
	}
	%>
		
</td></tr>
</table><br><br>
