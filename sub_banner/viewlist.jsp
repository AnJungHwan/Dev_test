<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.SubBannerDataObject"  %>
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
	String divisionFolder = null; 
	String tableName = "tb_" + dbName;
		
	Map countmap = new HashMap();
	
	countmap.put("tableName", tableName);

	if (!divisionCode.equals("AL")){
		countmap.put("divisionCode", divisionCode);
	}
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCount3", countmap)).intValue();
	
	
	String [][] divisionArray = new String[][]{
		{"전체","AL"},
		{"파인 크리크","PC"},
		{"파인  밸리","PV"}
		//,{"웨스트  파인","WP"},
		//{"F&B","NC"}
	};
%>
<table class="box">
<tr>
	<%
		String printDivisionName = "전체";	
		for(int i=0; i < divisionArray.length; i++) {
			if (divisionArray[i][1].equals(divisionCode)) {
				printDivisionName = divisionArray[i][0];
	%>
			<th style="width: 15%"><%=divisionArray[i][0]%></th>	
	<%
			}
			else { 
			goURL = strobj.generateForBannerURL(globalMenu, localMenu, dbName, commandName, 1, divisionArray[i][1]);
		%>
		<td style="width: 15%"><a href="<%=goURL%>"><%=divisionArray[i][0]%></a></td>
	<%
			}
		}
	%>
</tr>
</table><br>
<table class="normal">	
<tr>
	<td style="text-align:left;" >
	총  <%=totalCount%>개의  배너가 있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateForBannerURL(globalMenu, localMenu, dbName, "writeform", pageNumber, divisionCode);
	%>
	<% if(!divisionCode.equals("AL") ) { %>
	<span class="button medium icon"><span class="refresh"></span><a href="/baas/sub_banner/makexml.jsp?div=<%=divisionCode%>">서브메인(<%=printDivisionName %>)에  반영</a></span>
	<% } %>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">배너  추가</a></span>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	<th style="width: 7%">번호</th>
	<th style="width: 15%">사업장</th>
	<th style="width: 20%">이름</th>
	<th style="width: 20%">배너</th>
	<th style="width: 10%">작성자</th>
	<th style="width: 15%">작성일</th>
	<th style="width: 7%">순서</th>
	<th style="width: 7%">사용</th>
</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);

		if (!divisionCode.equals("AL")){
			pagemap.put("divisionCode", divisionCode);
		}
		
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		List skinList = new ArrayList();
		
		skinList = sqlMap.queryForList("subBannerPagingList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < skinList.size(); i++){
			SubBannerDataObject dataobj = (SubBannerDataObject) skinList.get(i);
			goURL = strobj.generateForBannerURL(globalMenu, localMenu, dbName, "editform", pageNumber, dataobj.getSeq_no(), dataobj.getDivision_code());
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td><%= dataobj.getDivision_name() %></td>
        <td style="text-align:left"> <a  href="<%=goURL%>"><%= dataobj.getTitle() %></a><br></td>
		<td>
		<%	
				if(dataobj.getDivision_code().equals("PC")){
					divisionFolder = "/pinecreek/";
				}
				else if(dataobj.getDivision_code().equals("PV")){
					divisionFolder = "/pinevalley/";
				}
				else if(dataobj.getDivision_code().equals("WP")){
					divisionFolder = "/westpine/";
				}
				else  if (dataobj.getDivision_code().equals("WJ")){
					divisionFolder = "/woonjung/";
				}
				else  if (dataobj.getDivision_code().equals("YR")){
					divisionFolder = "/youngrangho/";
				}
				else if(dataobj.getDivision_code().equals("NC")){
					divisionFolder = "/f_b/";
				}
		 %>
		<img src=/upload/<%=dbName%><%=divisionFolder%><%= dataobj.getFilename() %> border="0"  width=50% height=50%><br>
		<%= dataobj.getWidth() %> X <%= dataobj.getHeight() %> <br></td>
		
		<td> <%= dataobj.getUser_name() %><br></td>
		<td> <%= dataobj.getWrite_date() %><br></td>
		<td> <%= dataobj.getLocation() %><br></td>
		<td> <%= dataobj.getIs_view() %><br></td>
	</tr>
<%	}
	}
	else {
%>
	<tr><td colspan=8> 배너가  없습니다.</td></tr>
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
			goURL = strobj.generateForBannerURL(globalMenu, localMenu, dbName, "viewlist", prevPage, divisionCode);
		%>
			<a  href="<%=goURL %>">[이전]</a>
		<%
		}
		for(int i = startPage ; i <= endPage ; i++) {
			if (i==currentPage){
				out.println("[<b>"+ i +"</b>]");
			}
			else{
				goURL = strobj.generateForBannerURL(globalMenu, localMenu, dbName, "viewlist", i, divisionCode);
		%>	
			<a  href="<%=goURL %>"><%=i %></a>
		<%	
			}
		}
		if (endPage < pageCount) {
			int nextPage = startPage + 10;
			goURL = strobj.generateForBannerURL(globalMenu, localMenu, dbName, "viewlist", nextPage, divisionCode);
		%>	
			<a  href="<%=goURL %>">[다음]</a>
		<%	
		}
	}
	%>
		
</td></tr>
</table><br><br>

