<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.GalleryDataObject"  %>
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
	pageNumber = 1;

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
	String goURL=null;
	String goPic=null;
	String goAdd=null;
	
	String tableName = "tb_" + dbName;
		
	Map countmap = new HashMap();
	
	countmap.put("tableName", tableName);
	
	if (!divisionCode.equals("AL")){
		countmap.put("divisionCode", divisionCode);
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
			<th style="width: 15%"><%=divisionArray[i][0]%></th>	
	<%
			}
				else { 
			goURL = strobj.generateForSearchBoardURL(globalMenu, localMenu, dbName, commandName, 1, divisionArray[i][1], divisionArray[i][1], searchWord, searchField);
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
	총  <%=totalCount%>개의  게시물이  있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
		if(sessionSuperuserAccessLevel.equals("SUPER") || sessionSuperuserDivisionCode.equals(divisionCode)){
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode, accessCode);
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
	<th style="width: 8%">번호</th>
	<th style="width: 15%">사진</th>
	<th style="width: 30%">제목</th>
	<th style="width: 13%">사업장</th>
	<th style="width: 13%">작성자</th>
	<th style="width: 14%">작성일</th>
	<th style="width: 7%">사진수</th>
</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);
		
		if (!divisionCode.equals("AL")){
			pagemap.put("divisionCode", divisionCode);
		}
		pagemap.put("searchWord", searchWord);
		pagemap.put("searchField", searchField);
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		List dbList = new ArrayList();
		
		dbList = sqlMap.queryForList("gallerySearchPagingList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < dbList.size(); i++){
			GalleryDataObject dataobj = (GalleryDataObject) dbList.get(i);
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "editform", pageNumber, dataobj.getSeq_no(), divisionCode, dataobj.getDivision_code());
			goPic = strobj.generateForGalleryURL(globalMenu, localMenu, dbName, "viewpic", pageNumber, dataobj.getGallery_code(), divisionCode, dataobj.getDivision_code());
			goAdd = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "addform", pageNumber, dataobj.getSeq_no(), divisionCode, dataobj.getDivision_code());
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
	<tr>
        <td><%= virtualNumber %></td>
		<td><img  src=/upload/<%=dbName%>_storage/thumb_<%= dataobj.getGallery_filename() %> border="0"></td>
		<td><a  href="<%=goURL%>"><%= dataobj.getTitle() %></a></td>
		<td><%= dataobj.getDivision_name() %></td>
		<td><%= dataobj.getUser_name() %></td>
		<td><%= dataobj.getWrite_date() %></td>
		<td>
		<%= dataobj.getTotalcount() %>장<br>
		<span class="button medium icon"><span class="calendar"></span><a href="<%=goPic%>">보기</a></span>	
		<span class="button medium icon"><span class="check"></span><a href="<%=goAdd%>">추가</a></span>	
		</td>
	</tr>        
	
<%	}
	}
	else {
%>
	<tr><td colspan=8> 게시된  사진이  없습니다.</td></tr>
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
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", prevPage, divisionCode, accessCode);
		%>
			<a  href="<%=goURL %>">[이전]</a>
		<%
		}
		for(int i = startPage ; i <= endPage ; i++) {
			if (i==currentPage){
				out.println("[<b>"+ i +"</b>]");
			}
			else{
				goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", i, divisionCode, accessCode);
		%>	
			<a  href="<%=goURL %>"><%=i %></a>
		<%	
			}
		}
		if (endPage < pageCount) {
			int nextPage = startPage + 10;
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", nextPage, divisionCode, accessCode);
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
<option value="title">제목</option>
</select>
<span class="btn white"><input  type="button" value="검색 "  onClick="JavaScript:$.goSearch('<%=globalMenu%>', '<%=localMenu%>', '<%=dbName%>', '<%=pageNumber%>', '<%=divisionCode%>', '<%=accessCode%>');"></span>
</form>
</div>
