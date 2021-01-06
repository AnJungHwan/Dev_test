<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.BoardDataObject"  %>
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
				alert("�˻�� �Է����ּ���");
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
	
	totalCount = ((Integer)sqlMap.queryForObject("getWebzineTotalCount", countmap)).intValue();
	
	
	if (accessCode.equals("AL") && sessionSuperuserAccessLevel.equals("SUPER")){
		accessCode = "TL"; //  ���۰����ڰ� ��������  �׼���  �ڵ带  ���緹����  �����Ѵ�.
	}
%>

<table class="normal">	
<tr>
	<td style="text-align:left;" >
	��  <%=totalCount%>����  �Խù���  �ֽ��ϴ�. 
	</td>
	<td style="text-align:right;" >
	<%
		if(sessionSuperuserAccessLevel.equals("SUPER") || sessionSuperuserDivisionCode.equals(divisionCode) || "AL".equals(divisionCode)){
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "writeform", pageNumber, divisionCode, accessCode);	
	%>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">�۾���</a></span>	
	<%
		}
	%>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	<th style="width: 10%">��ȣ</th>
	<th style="width: 50%">����</th>
	<th style="width: 10%">�ۼ���</th>
	<th style="width: 15%">�ۼ���</th>
	<th style="width: 5%">��ȸ</th>
	<th style="width: 5%">����</th>
	<th style="width: 5%">÷��</th>

</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);
		
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		List dbList = new ArrayList();
		
		dbList = sqlMap.queryForList("webzinePagingList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < dbList.size(); i++){
			BoardDataObject dataobj = (BoardDataObject) dbList.get(i);
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, dataobj.getSeq_no(),  divisionCode, accessCode);
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td style="text-align:left">
        <a  href="<%=goURL %>"><%= dataobj.getTitle() %></a>
        </td>
        <td><%= dataobj.getUser_name() %></td>
        <td><%= dataobj.getWrite_date()%></td>
        <td><%= dataobj.getHitcount()%></td>
        <% if (dataobj.getIs_view().equals("N")) %>
        	<td style="background-color:#808080;color:#ffffff">
        <% else %>
       	<td>
        <%= dataobj.getIs_view()%>
        </td>
         <td>
         <% 
         	if (dataobj.getAttach_filename() != null) {
         		String fileExt = dataobj.getAttach_filename().substring(dataobj.getAttach_filename().lastIndexOf(".")+1);
         %>
         <a  href="/baas/webzine/download.jsp?db=<%=dbName%>&file=<%= dataobj.getAttach_filename() %>">
       	<img src=/baas/images/<%=fileExt%>.gif border="0"></a>
         <%
         	}
         	else{
         		out.println("-");
         	}
         %>
         	
         	</td>
	</tr>
	
<%	}
	}
	else {
%>
	<tr><td colspan=8> �Խõ�  ����  �����ϴ�.</td></tr>
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
			<a  href="<%=goURL %>">[����]</a>
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
			<a  href="<%=goURL %>">[����]</a>
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
<option value="titlecontent">����+����</option>
<option value="title">����</option>
<option  value="content">����</option>
</select>
<span class="btn white"><input  type="button" value="�˻� "  onClick="JavaScript:$.goSearch('<%=globalMenu%>', '<%=localMenu%>', '<%=dbName%>', '<%=pageNumber%>', '<%=divisionCode%>', '<%=accessCode%>');"></span>
</form>
</div>
