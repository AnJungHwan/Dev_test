<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.ClubDataObject" %>

<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	
	$.extend({
		submitForm : function() {
		}
	});
});
//-->
</script>
<%
	request.setCharacterEncoding("euc-kr");	
	
	String  categoryCode = request.getParameter("code");
	categoryCode = "25";

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	Map pagemap = new HashMap();

	
	pagemap.put("tableName", "tb_club");
	
	pagemap.put("categoryCode", categoryCode);

	List contentList = new ArrayList();
	contentList = sqlMap.queryForList("clubListForUser", pagemap);
%>
<table summary="" class="menutype2">
<tr>
<%
	String  title  = null;;
	String  summary  = null;;
	for(int i=0; i < contentList.size(); i++){
		ClubDataObject dataobj = (ClubDataObject) contentList.get(i);
		if  (dataobj.getTitle().length() > 20){
			title  = dataobj.getTitle().substring(0, 18);
		}
		else{
			title  = dataobj.getTitle();
		}
		if  (dataobj.getSummary().length() > 60){
			summary  = dataobj.getSummary().substring(0, 58);
		}
		else{
			summary  = dataobj.getSummary();
		}
%>

<td>
	<dl>
	<dt><a href="#"><img src="/upload/club/<%=dataobj.getAttach_filename() %>" alt="" /></a></dt>
	<dd>	<ol>
		<li><a href="#"><strong><%=title %></strong></a></li>
		<li><span><%=dataobj.getWrite_date() %> | Á¶È¸: <%=dataobj.getHitcount() %></span></li>
		<li><span><%=summary %></span></li>
	</ol></dd>
	</dl>
</td>
<% 	if  (i  % 2 == 1) { %>
</tr><tr>
<% 
	} 
}
%>
</tr>
</table>
									
	



	