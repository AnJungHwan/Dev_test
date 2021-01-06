<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.GnbDataObject"  %>
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
<script type="text/javascript" src="http://dev.jquery.com/view/trunk/plugins/treeview/jquery.treeview.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	// 페이지가 로딩될 때 'Loading 이미지'를 숨긴다.
	$('#viewLoading').hide();

	// ajax 실행 및 완료시 'Loading 이미지'의 동작을 컨트롤하자.
	$('#viewLoading')
	.ajaxStart(function()
	{
		// 로딩이미지의 위치 및 크기조절	
		loadingTop = document.body.clientHeight / 2;
		loadingLeft = document.body.clientWidth / 2;
		$('#viewLoading').css('position', 'absolute');
		$('#viewLoading').css('left', loadingLeft);
		$('#viewLoading').css('top', '300');
		$('#viewLoading').css('width', '50');
		$('#viewLoading').css('height', '50');

		$(this).show();
		
		//$(this).fadeIn(500);
	})
	.ajaxStop(function()
	{
		$(this).hide();
		//$(this).fadeOut(500);
	});
	
	
	
	$.extend({
		confirmDelete : function(doc, menu, large, medium) {
			if(menu ==1){
				if(!confirm("대분류를 삭제 하면 하위 분류도 삭제 됩니다.\n\n 정말로 삭제하겠습니까?")){
					return;
				}
				else  {
					$.get("/baas/gnb/delete.jsp", {doc:doc, menu:menu, large:large, medium:medium},function(data){
						location.reload();
					});
				}
			}
			else  if(menu ==2){
				if(!confirm("중분류를 삭제 하면 하위 분류도 삭제 됩니다.\n\n 정말로 삭제하겠습니까?")){
					return;
				}
				else  {
					$.get("/baas/gnb/delete.jsp", {doc:doc, menu:menu, large:large, medium:medium},function(data){
						location.reload();
					});
				}
			}
			else  {
				if(!confirm("정말로 삭제하겠습니까?")){
					return;
				}
				else{
					$.get("/baas/gnb/delete.jsp", {doc:doc, menu:menu, large:large, medium:medium},function(data){
						location.reload();
					});
				}	
			}
			
			
		},
		confirmEdit : function(doc, menu, large, medium, position) {
			var  name  = "menu_name" + position;
			var  link  = "menu_link" + position;
			
			var  menu_name = $('#' + name).val();
			var  menu_link = $('#' + link).val();
			
			if(menu ==1){
				if(!confirm("대분류를 수정 하면 하위 분류도 일괄 수정 됩니다.\n\n 정말로 수정하겠습니까?")){
					return;
				}
				else  {
					$.post("/baas/gnb/edit.jsp", {doc:doc, menu:menu, large:large, medium:medium, name:escape(menu_name), link:escape(menu_link)},function(){
						alert("수정하였습니다.");
						location.reload();
					});
				}
			}
			else  if(menu ==2){
				if(!confirm("중분류를 수정 하면 하위 분류도 일괄 수정 됩니다.\n\n 정말로 수정하겠습니까?")){
					return;
				}
				else  {
					$.post("/baas/gnb/edit.jsp", {doc:doc, menu:menu, large:large, medium:medium, name:escape(menu_name), link:escape(menu_link)},function(){
						alert("수정하였습니다.");
						location.reload();
					});
				}
			}
			else  {
				if(!confirm("수정하겠습니까?")){
					return;
				}
				else{
					$.post("/baas/gnb/edit.jsp", {doc:doc, menu:menu, large:large, medium:medium, name:escape(menu_name), link:escape(menu_link)},function(){
						alert("수정하였습니다.");
						//location.reload();
					});
				}	
			}
		},
		makeXML : function() {
			$.ajax({
				type: "POST",
				url :"/baas/gnb/makexml.jsp",
				data : "",
				success: function() {
					alert("생성하였습니다.");	
				}
			}); 
		}
	});
});
//-->
</script>
<style>
	div#viewLoading {
		text-align: center;
		padding-top: 0px;
		background: #ffffff;
		
	}
</style>
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
	총  <%=totalCount%>개의  메뉴가 있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "writeform", pageNumber);
	%>
	<span class="button medium icon"><span class="refresh"></span><a href="JavaScript:$.makeXML()">XML 작성</a></span>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">메뉴  추가</a></span>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	
	<th style="width: 10%">분류명</th>
	<th style="width: 12%">최상위분류</th>
	<th style="width: 13%">상위분류</th>
	<th style="width: 25%">메뉴명</th>
	<th style="width: 20%">링크</th>
	<th style="width: 20%">수정/삭제</th>
</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);
		
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		List skinList = new ArrayList();
		
		skinList = sqlMap.queryForList("gnbList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < skinList.size(); i++){
		GnbDataObject dataobj = (GnbDataObject) skinList.get(i);
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "editform", pageNumber, dataobj.getSeq_no());
		virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
	<tr>
        <td style="text-align:center"> <%= dataobj.getMenu_node() %><br></td>
		<td style="text-align:center"> <%= dataobj.getTop_node() %><br></td>
        <td style="text-align:center"> <%= dataobj.getParent_node() %><br></td>
        <td style="text-align:left"> 
        <% if(dataobj.getMenu_code()==2){ %>
		 &nbsp; &nbsp; ㄴ
        <%
        } 
        else if(dataobj.getMenu_code()==3){ 
        %>
        &nbsp; &nbsp; &nbsp; &nbsp; ㄴ
        <%  }   %>
        <input type="input" name=name  class="thin" id=menu_name<%=i%> value="<%= dataobj.getMenu_name() %>" style="width: 110px">
        <br></td>
        <td style="text-align:left">
         <input type="input" name=link  class="thin" id=menu_link<%=i%> value="<%= dataobj.getMenu_link() %>" style="width: 110px">
         <br></td>
	  	<td style="text-align:center"> 
	  	<span class="button medium icon"><span class="check"></span>
	  	<a href="JavaScript:$.confirmEdit('<%=dataobj.getSeq_no()%>','<%=dataobj.getMenu_code()%>','<%=dataobj.getLarge_index()%>','<%=dataobj.getMedium_index()%>','<%=i%>')">수정</a></span>
	  	
	  	<span class="button medium icon"><span class="delete"></span>
	  	<a href="JavaScript:$.confirmDelete('<%=dataobj.getSeq_no()%>','<%=dataobj.getMenu_code()%>','<%=dataobj.getLarge_index()%>','<%=dataobj.getMedium_index()%>')">삭제</a></span>
	  	
	  	</td>
	</tr>
<%	}
	}
	else {
%>
	<tr><td colspan=7> 메뉴가  없습니다.</td></tr>
<%
	}
%>
</table>
<div id="viewLoading">
	<img src="/baas/images/loading.gif">
</div>
