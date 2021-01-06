<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.GnbDataObject" %>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var  menu_node  = $("#menu_node");
	var  top_node  = $("#top_node");
	var 	menu_name = $('[name="menu_name"]');
	var 	menu_link = $('[name="menu_link"]');
	
	top_node.change(function() {
		var top = escape(top_node.val());
		$.get("/baas/gnb/parentnode2.jsp", {top: escape(top_node.val()) },function(data){
			
			$("#parentLabel").text("* 중분류를  선택하세요 : ");
			$("#parentDiv").show();		
			$("#parentDiv").html(data);
		});
		
	});
});
//-->
</script>


<%

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	List topList = new ArrayList();	
	
	topList = sqlMap.queryForList("gnbGetTopNodeName");
%>

<select name="top_node" class="thin" style="width:150px;"  id="top_node">
<option value="-">선택해주세요</option>
<%
	for(int i=0; i < topList.size(); i++){
		GnbDataObject dataobj = (GnbDataObject) topList.get(i);
%>
<option value="<%=dataobj.getMenu_name() %>"><%=dataobj.getMenu_name() %></option>
<%		
	}
%>
</select>
