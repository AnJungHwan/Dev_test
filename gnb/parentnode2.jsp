<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.GnbDataObject" %>
<%@ page import="common.utility.StringUtility"  %>
<%
	request.setCharacterEncoding("euc-kr");	
	
	StringUtility strobj = new StringUtility();
	
	String  top_node = strobj.unescape(request.getParameter("top"));
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	List parentList = new ArrayList();	

	parentList = sqlMap.queryForList("gnbGetParentNodeName", top_node);
%>
<input  type="hidden" value="<%=top_node %>">
<select name="parent_node" class="thin" style="width:150px;"  id="parent_node">
<%
	for(int i=0; i < parentList.size(); i++){
		GnbDataObject dataobj = (GnbDataObject) parentList.get(i);
%>
<option value="<%=dataobj.getMenu_name() %>"><%=dataobj.getMenu_name() %></option>
<%		
	}
%>
</select>