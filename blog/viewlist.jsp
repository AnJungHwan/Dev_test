<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>


<%@ page import="database.datadef.ClubDataObject"  %>
<%@ page import="database.datadef.ClubCategoryDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="common.utility.StringUtility"  %>


<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>
<script language="JavaScript">
<!--
function addCategory(db) 
{
	var  url  = "/baas/club/insertform.jsp";
	
	var  heightPixel  = 300;
	var  widthPixel  = 300;
	var  leftPosition = (screen.width) ? (screen.width-widthPixel)/2 : 0;
	var  topPosition = (screen.height) ? (screen.height-heightPixel)/2 : 0;
	
	var  settings = "toolbar=0,height=" + heightPixel + ",width=" + widthPixel+ ",top=" + topPosition + ",left=" + leftPosition + ",scrollbars=0 ,resizable=0";
	window.open(url, 'newwin', settings);
	 
}
//-->
</script>
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

	int categoryCount = 0;
	
	StringUtility strobj = new StringUtility();
	String goURL="";
	 
	String tableName = "tb_" + dbName;
		
	Map countmap = new HashMap();
	
	countmap.put("tableName", tableName);
	
	if (!categoryCode.equals("AL")){
		countmap.put("categoryCode", categoryCode);
	}
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCount5", countmap)).intValue();
	countmap.clear();
	
	
%>
<table class="box">
<tr>
	<%	
		
		countmap.put("tableName", "tb_club_category");
		
		categoryCount = ((Integer)sqlMap.queryForObject("getTotalCount", countmap)).intValue();
	
		if (categoryCount == 0) {
			out.println("<script>alert('분류가  없습니다. 분류  관리로  이동합니다.');</script>"); 
			out.println("<script>location.href='/baas/index.jsp?global_menu=7&local_menu=2&db=club_category&cmd=viewlist&page=1'</script>");
		}
		else {
			List categoryList = new ArrayList();	
			categoryList = sqlMap.queryForList("clubCategoryList");
			if  (categoryCode.equals("AL")){
	%>
				<th style="width: <%=850/categoryList.size() %>px">전체</th>
	<%
		}
			else {
				goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, commandName, 1, "AL");
	%>
				<td style="width: <%=850/categoryList.size() %>px"><a href="<%=goURL%>">전체</a></td>
	<%	
			}
			for(int i=0; i < categoryList.size(); i++){
				ClubCategoryDataObject catedataobj = (ClubCategoryDataObject) categoryList.get(i);
			
				if (catedataobj.getCategory_code().equals(categoryCode)){
	%>
					<th style="width: <%=850/categoryList.size() %>px"><%=catedataobj.getCategory_name()%></th>
	<%
				}
				else {
					goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, commandName, 1, catedataobj.getCategory_code());
	%>
					<td style="width: <%=850/categoryList.size() %>px"><a href="<%=goURL%>"><%=catedataobj.getCategory_name()%></a></td>	
	<%
				}
			}
		}
	%>
</tr>
</table><br>

<table class="normal">	
<tr>
	<td style="text-align:left;" >
	총  <%=totalCount%>개의  글이 있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
	if(sessionSuperuserAccessLevel.equals("SUPER") ){
		goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "writeform", pageNumber, categoryCode);	
	%>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">글쓰기</a></span>
	<%
		}
	%>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	<th style="width: 5%">번호</th>
	<th style="width: 10%">분류</th>
	<th style="width: 55%">제목</th>
	<th style="width: 10%">작성자</th>
	<th style="width: 15%">작성일</th>
	<th style="width: 5%">보기</th>
</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);
		
		if (!categoryCode.equals("AL")){
			pagemap.put("categoryCode", categoryCode);
		}
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		
		List shopList = new ArrayList();
		
		shopList = sqlMap.queryForList("clubPagingList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < shopList.size(); i++){
			ClubDataObject dataobj = (ClubDataObject) shopList.get(i);
			goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, dataobj.getSeq_no(),  categoryCode);
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td><%= dataobj.getCategory_name() %></td>
        <td style="text-align:left"><a  href="<%=goURL %>"><%= dataobj.getTitle() %></a> </td>
        <td><%= dataobj.getUser_id() %></td>
        <td><%= dataobj.getWrite_date()%></td>
        <% if (dataobj.getIs_view().equals("N")) %>
        	<td style="background-color:#808080;color:#ffffff">
        <% else %>
        	<td>
        <%= dataobj.getIs_view()%>
        </td>
	</tr>
	
<%	}
	}
	else {
%>
	<tr><td colspan=6> 게시된  글이  없습니다.</td></tr>
<%
	}
%>
</table><br>
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
			goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "viewlist", prevPage, categoryCode);
		%>
			<a  href="<%=goURL %>">[이전]</a>
		<%
		}
		for(int i = startPage ; i <= endPage ; i++) {
			if (i==currentPage){
				out.println("[<b>"+ i +"</b>]");
			}
			else{
				goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "viewlist", i, categoryCode);
		%>	
			<a  href="<%=goURL %>"><%=i %></a>
		<%	
			}
		}
		if (endPage < pageCount) {
			int nextPage = startPage + 10;
			goURL = strobj.generateForBlogURL(globalMenu, localMenu, dbName, "viewlist", nextPage, categoryCode);
		%>	
			<a  href="<%=goURL %>">[다음]</a>
		<%	
		}
	}
	%>
		
</td></tr>
</table>


