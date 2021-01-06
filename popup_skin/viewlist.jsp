<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.PopupSkinDataObject"  %>
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
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCount", countmap)).intValue();
	
%>
<table class="normal">	
<tr>
	<td style="text-align:left;" >
	총  <%=totalCount%>개의  스킨이 있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "writeform", pageNumber);	
	%>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">스킨추가</a></span>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	<th style="width: 10%">번호</th>
	<th style="width: 20%">스킨명</th>
	<th style="width: 45%">스킨</th>
	<th style="width: 15%">크기</th>
	<th style="width: 10%">사용</th>
</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		
		pagemap.put("tableName", tableName);
		
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		List skinList = new ArrayList();
		
		skinList = sqlMap.queryForList("popupSkinPagingList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < skinList.size(); i++){
			PopupSkinDataObject dataobj = (PopupSkinDataObject) skinList.get(i);
			goURL = strobj.generateURL(globalMenu, localMenu, dbName, "editform", pageNumber, dataobj.getSeq_no());
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
		
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td style="text-align:left"> <a  href="<%=goURL%>"><%= dataobj.getTitle() %></a><br></td>
		<td> <img src=/upload/<%=dbName%>/<%= dataobj.getFilename() %> width=25% height=25%><br>
		<td> <%= dataobj.getWidth() %> X <%= dataobj.getHeight() %> <br></td>
		<td> <%= dataobj.getIs_view() %><br></td>
	</tr>
<%	}
	}
	else {
%>
	<tr><td colspan=5> 스킨이 없습니다.</td></tr>
<%
	}
%>
</table>
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
		
		 
		
		if(startPage > 10) {
			int prevPage = startPage - 10;
			goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", prevPage);
		%>
			<a  href="<%=goURL %>">[이전]</a>
		<%
		}
		for(int i = startPage ; i <= endPage ; i++) {
			if (i==currentPage){
				out.println("[<b>"+ i +"</b>]");
			}
			else{
				goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", i);
		%>	
			<a  href="<%=goURL %>"><%=i %></a>
		<%	
			}
		}
		if (endPage < pageCount) {
			int nextPage = startPage + 10;
			goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", nextPage);
		%>	
			<a  href="<%=goURL %>">[다음]</a>
		<%	
		}
	}
	%>
		
</td></tr>
</table><br><br>

