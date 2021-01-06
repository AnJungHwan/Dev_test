<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.datadef.PrevAndNextDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>

<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
$(document).ready(function(){
	$.extend({
		confirmDelete : function(global, local, db, page, div, doc, code) {
			if(!confirm("삭제 하겠습니까?")){
				return;
			}
			else{
				$.get("/baas/board/delete.jsp", {db: db, doc:doc, div:div, code:code },function(data){
					alert("삭제  되었습니다.");
					document.location = "/baas/index.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&cmd=viewlist&page=" + page + "&div=" + div + "&code="+code;
				});
			}
		}
	});
});

function rmSearchBtn()
{
window.open('http://popup.tyleisure.co.kr/rm/creditorSearch.jsp?type=TYR&sdebtCode=D', 'rm_search', 'width=500,height=500');
}

function rmSearchBtn2()
{
window.open('http://popup.tyleisure.co.kr/rm/creditorSearch.jsp?type=TYR&sdebtCode=A', 'rm_search', 'width=500,height=500');
}

function rmSearchBtn05()
{
window.open('http://popup.tyleisure.co.kr/rm/creditorSearch2.jsp?type=TYR&sdebtCode=D', 'rm_search', 'width=500,height=500');
}

//-->
</script>
<%
	int isAccess = 0;
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	AclDataObject acldataobj = new AclDataObject();

	Map map = new HashMap();
	map.put("superuserID", sessionSuperuserID);
	map.put("dbName", dbName);
	map.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", map);
	
	//isAccess  = acldataobj.getIs_access();
	isAccess = 1;


	//데이터  가져온다..
	String tableName = "tb_" + dbName;
	Map artclemap = new HashMap();

	artclemap.put("tableName", tableName);
	artclemap.put("docNumber", Integer.toString(docNumber));
	
	
	BoardDataObject dataobj = new BoardDataObject();
	dataobj = (BoardDataObject)sqlMap.queryForObject("boardArticle", artclemap);
	
	// 조회수  증가  루틴
	sqlMap.update("countPlus", artclemap);
	
	
	String goList = null;
	String goEdit = null;
	String goURL = null;
	
	StringUtility strobj = new StringUtility();
	
	goList = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode, accessCode);
	goEdit = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "editform", pageNumber, docNumber, divisionCode, accessCode);
%>
<br><br>
<div class="plate">
	<span class="button medium icon"><span class="refresh"></span><a href="<%=goList%>">목록</a></span>
	<% if  (isAccess  == 1) { %>
	<span class="button medium icon"><span class="check"></span><a href="<%=goEdit%>">수정</a></span>
	<span class="button medium icon"><span class="delete"></span>
	<a href="JavaScript:$.confirmDelete('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=divisionCode %>','<%=docNumber%>','<%=accessCode%>');">삭제</a>
	</span>
	<% } %>
</div>

<table class="bold"> 	
<tr>
	<th colspan="2"><%=dataobj.getTitle()%></th>
</tr>
<tr>
	<td align="left"><%=dataobj.getUser_id()%>(<%=dataobj.getUser_name()%>)  </td>
	<td align="right"><%=dataobj.getWrite_date()%> | <%=dataobj.getHitcount()%> hit </td>
</tr>
<tr><td colspan="2" class="line"><hr></td></tr>
<tr>
	<td colspan="2" align="right">
	<%
		if(dataobj.getAttach_filename()!=null){
			String fileExt = dataobj.getAttach_filename().substring(dataobj.getAttach_filename().lastIndexOf(".")+1);
	%>
			<a  href="/baas/board/download.jsp?db=<%=dbName%>&file=<%= dataobj.getAttach_filename() %>">
	   		<img src="/baas/images/<%=fileExt%>.gif" border="0"> <%=dataobj.getAttach_filename() %></a>
	<%		
		}
	%>
	</td>
</tr>
<tr>	
	<td style="text-align:left" colspan="2">
<%= dataobj.getContent().replaceAll("\r", "<br>") %>
	</td>
</tr>
</table>
<%
	Map pnnmap = new HashMap();

	pnnmap.put("tableName", tableName);
	pnnmap.put("docNumber", Integer.toString(docNumber));
	
	if (!divisionCode.equals("AL")){
		pnnmap.put("divisionCode", divisionCode);
	}


	PrevAndNextDataObject pnndataobj = new PrevAndNextDataObject();
	pnndataobj = (PrevAndNextDataObject)sqlMap.queryForObject("boardPrevAndNextArticle", pnnmap);
	
	int nextNumber = pnndataobj.getNext_no();
	int prevNumber = pnndataobj.getPrev_no();
	
	String prevTitle = pnndataobj.getPrev_title();
	String nextTitle = pnndataobj.getNext_title();
%>


<table class="normal">	
<tr><td class="line"><hr></td></tr>
<tr>
	<td  style="text-align:left">다음글  : 
	<% 
		if (nextNumber == 0){
			out.println("다음글이  없습니다");
		}
		else {
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, nextNumber, divisionCode,accessCode);
	%>
		<a href="<%=goURL%>"><%= nextTitle%></a>
	<%
		}
	%><br>
	</td>
</tr>
<tr>	
	<td style="text-align:left">이전글  : 
	<% 
		if (prevNumber == 0){
			out.println("이전글이  없습니다");
		}
		else { 
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, prevNumber, divisionCode, accessCode);
	%>
		<a href="<%=goURL%>"><%= prevTitle%> </a></td>
	<%
		}
	%>
</tr>
</table>
