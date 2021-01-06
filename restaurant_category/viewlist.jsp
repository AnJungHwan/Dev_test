<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.RestaurantCategoryDataObject"  %>
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
	총  <%=totalCount%>개의  분류가  있습니다. 
	</td>
	<td style="text-align:right;" >
		<%  goURL = strobj.generateURL(globalMenu, localMenu, dbName, "writeform", pageNumber); %>
		<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">분류추가</a></span>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	<th style="width: 10%">번호</th>
	<th style="width: 90%">분류명</th>
</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);
		
		List categoryList = new ArrayList();
		categoryList = sqlMap.queryForList("restaurantCategoryList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < categoryList.size(); i++){
			RestaurantCategoryDataObject dataobj = (RestaurantCategoryDataObject) categoryList.get(i);
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "editform", pageNumber, dataobj.getSeq_no(), divisionCode, divisionCode);
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
		
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td style="text-align:left"><a  href="<%=goURL %>"><%= dataobj.getCategory_name()  %></a> </td>
	</tr>
<%	}
	}
	else {
%>
	<tr><td colspan=2> 분류가 없습니다.</td></tr>
<%
	}
%>
</table>

<br><br>


