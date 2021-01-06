<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.RestaurantCategoryDataObject"  %>
<%@ page import="database.datadef.RestaurantDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="common.utility.StringUtility"  %>


<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var 	word = $('#word');
	var	key = $('#key');
	$("#searchForm").submit(function () {
		return false;		
	});
	$.extend({
		goSearch : function(global, local, db, page, div, code) {
			var  searchWord;
			var  searchKey;
			if  (word.val() ==''){
				alert("검색어를 입력해주세요");
				word.focus();
				return;
			}
			else{
				searchWord  = word.val();
				searchKey  = key.val();
				document.location = "/baas/index.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&cmd=searchlist" +"&page=" + page + "&div=" + div + "&code="+code+"&word="+searchWord+"&key="+searchKey;		
			}	 
		}
	});
});

//-->
</script>
<%
	request.setCharacterEncoding("euc-kr");	
	//pageNumber = 1;

	String searchWord  = request.getParameter("word");
	String searchField  = request.getParameter("key");

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
	if (!divisionCode.equals("AL")){
		countmap.put("divisionCode", divisionCode);
	}
	
	if (!categoryCode.equals("AL")){
		countmap.put("categoryCode", categoryCode);
	}

	countmap.put("searchWord", searchWord);
	countmap.put("searchField", searchField);
	totalCount = ((Integer)sqlMap.queryForObject("getTotalSearchCount2", countmap)).intValue();
	
	String [][] divisionArray = new String[][]{
	{"전체","AL"},
	{"파인 크리크","PC"},
	{"파인  밸리","PV"}
	//,{"웨스트  파인","WP"}
	};
%>
<table class="box">
<tr>
	<%
		for(int i=0; i < divisionArray.length; i++) {
			if (divisionArray[i][1].equals(divisionCode)) {
	%>
				<th style="width: <%= 850/divisionArray.length %>px"><%=divisionArray[i][0]%></th>	
	<%
			}
			else { 
				goURL = strobj.generateForSearchRestaurantURL(globalMenu, localMenu, dbName, "searchlist", 1, divisionArray[i][1], accessCode, searchWord, searchField);
		%>
				<td style="width: <%= 850/divisionArray.length %>px"><a href="<%=goURL%>"><%=divisionArray[i][0]%></a></td>
	<%
		}
			}
	%>
</tr>
</table><br>


<table class="box">
<tr>
	<%	
		List categoryList = new ArrayList();	
		categoryList = sqlMap.queryForList("restaurantCategoryList");
		for(int i=0; i < categoryList.size(); i++){
			RestaurantCategoryDataObject catedataobj = (RestaurantCategoryDataObject) categoryList.get(i);
			
			if (catedataobj.getCategory_code().equals(categoryCode)){
	%>
				<th style="width: <%=850/categoryList.size() %>px"><%=catedataobj.getCategory_name()%></th>
	<%
			}
			else {
				//goURL = strobj.generateForRestaurantURL(globalMenu, localMenu, dbName, commandName, 1, divisionCode,  divisionCode, catedataobj.getCategory_code());
				goURL = strobj.generateForSearchRestaurantURL(globalMenu, localMenu, dbName, "searchlist", 1, divisionCode, divisionCode, catedataobj.getCategory_code(), searchWord, searchField);
				
	%>
				<td style="width: <%=850/categoryList.size() %>px"><a href="<%=goURL%>"><%=catedataobj.getCategory_name()%></a></td>	
	<%
			}
		}
	%>
</tr>
</table><br>



<table class="normal">	
<tr>
	<td style="text-align:left;" >
	총  <%=totalCount%>개의  메뉴가  있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
	if(sessionSuperuserAccessLevel.equals("SUPER") || sessionSuperuserDivisionCode.equals(divisionCode)){
		goURL =  strobj.generateForRestaurantURL(globalMenu, localMenu, dbName, "viewlist", 1, divisionCode, accessCode, categoryCode);	
	%>
	<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">목록</a></span>
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
	<th style="width: 33%">메뉴명</th>
	<th style="width: 10%">사업장</th>
	<th style="width: 10%">작성자</th>
	<th style="width: 12%">작성일</th>
	<th style="width: 10%">가격</th>
	<th style="width: 5%">보기</th>
	<th style="width: 5%">사진</th>
</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);
		
		if (!divisionCode.equals("AL")){
			pagemap.put("divisionCode", divisionCode);
		}
		if (!categoryCode.equals("AL")){
			pagemap.put("categoryCode", categoryCode);
		}
		
		pagemap.put("searchWord", searchWord);
		pagemap.put("searchField", searchField);
		
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		DecimalFormat df = new DecimalFormat("###,###");
		List shopList = new ArrayList();
		
		shopList = sqlMap.queryForList("restaurantSearchPagingList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < shopList.size(); i++){
			RestaurantDataObject dataobj = (RestaurantDataObject) shopList.get(i);
			goURL = strobj.generateForRestaurantURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, dataobj.getSeq_no(), divisionCode, dataobj.getDivision_code(), categoryCode);
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td><%= dataobj.getCategory_name() %></td>
        <td style="text-align:left"><a  href="<%=goURL %>"><%= dataobj.getTitle() %></a> </td>
        <td><%= dataobj.getDivision_name()%></td>
        <td><%= dataobj.getUser_id() %></td>
        <td><%= dataobj.getWrite_date()%></td>
        <td style="text-align:right"><%= df.format(dataobj.getPrice())%>원</td>
        <% if (dataobj.getIs_view().equals("N")) %>
        	<td style="background-color:#808080;color:#ffffff">
        <% else %>
        	<td>
        <%= dataobj.getIs_view()%>
        </td>
        <td style="height:30px">
        <% 
        	if (dataobj.getAttach_filename() == null) { 
        %>
        	-
        <% 
        	}
        	else { 
        %>
        	<img src=/upload/<%=dbName%>/thumb_<%= dataobj.getAttach_filename() %> width="50">
        <% 
        	}
        %>	
        	
        </td>
	</tr>
	
<%	}
	}
	else {
%>
	<tr><td colspan=9> 게시된  메뉴가  없습니다.</td></tr>
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
			goURL = strobj.generateForSearchRestaurantURL(globalMenu, localMenu, dbName, "searchlist", prevPage, divisionCode, accessCode, categoryCode,searchWord, searchField);
		%>
			<a  href="<%=goURL %>">[이전]</a>
		<%
		}
		for(int i = startPage ; i <= endPage ; i++) {
			if (i==currentPage){
				out.println("[<b>"+ i +"</b>]");
			}
			else{
				goURL = strobj.generateForSearchRestaurantURL(globalMenu, localMenu, dbName, "searchlist", i, divisionCode, accessCode, categoryCode,searchWord, searchField);
		%>	
			<a  href="<%=goURL %>"><%=i %></a>
		<%	
			}
		}
		if (endPage < pageCount) {
			int nextPage = startPage + 10;
			goURL = strobj.generateForSearchRestaurantURL(globalMenu, localMenu, dbName, "searchlist", nextPage, divisionCode, accessCode, categoryCode,searchWord, searchField);
		%>	
			<a  href="<%=goURL %>">[다음]</a>
		<%	
		}
	}
	%>
		
</td></tr>
</table><br><br>
<div>
<form  name="searchForm" id="searchForm"> 
<input  type="text" class="thin" id="word" onKeyPress="JavaScript: if(event.keyCode == 13) $.goSearch('<%=globalMenu%>', '<%=localMenu%>', '<%=dbName%>', '<%=pageNumber%>', '<%=divisionCode%>', '<%=accessCode%>');">
<select id="key">
<option value="titlecontent">메뉴명+내용</option>
<option value="title">메뉴명</option>
<option  value="content">내용</option>
</select>
<span class="btn white"><input  type="button" value="검색 "  onClick="JavaScript:$.goSearch('<%=globalMenu%>', '<%=localMenu%>', '<%=dbName%>', '<%=pageNumber%>', '<%=divisionCode%>', '<%=accessCode%>');"></span>
</form>
</div>

