<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.GnbDataObject" %>
<%

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	List nodeList = new ArrayList();	
	
	nodeList = sqlMap.queryForList("gnbGetTopNodeName");
%>

<select name="top_node" class="thin" style="width:150px;"  id="top_node">
<%
	for(int i=0; i < nodeList.size(); i++){
		GnbDataObject dataobj = (GnbDataObject) nodeList.get(i);
%>
<option value="<%=dataobj.getMenu_name() %>"><%=dataobj.getMenu_name() %></option>
<%		
	}
%>
</select>
