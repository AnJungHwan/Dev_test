<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>


<%@ page import="database.datadef.ClubDataObject"  %>
<%@ page import="database.datadef.ClubCategoryDataObject"  %>
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
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
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
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCount5", countmap)).intValue();
	
%>
<table class="normal">	
<tr>
	<td style="text-align:left;" >
	��  <%=totalCount%>����  �з��� �ֽ��ϴ�. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "writeform", pageNumber);	
	%>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">�з��߰�</a></span>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	<th style="width: 10%">��ȣ</th>
	<th style="width: 20%">�з���</th>
	<th style="width: 20%">�з� �̹���</th>
	<th style="width: 50%">Ÿ��Ʋ �̹���</th>

</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		List categoryList = new ArrayList();
		
		categoryList = sqlMap.queryForList("clubCategoryList");
		int virtualNumber =0;
		for(int i=0; i < categoryList.size(); i++){
			ClubCategoryDataObject dataobj = (ClubCategoryDataObject) categoryList.get(i);
			goURL = strobj.generateURL(globalMenu, localMenu, dbName, "editform", pageNumber, dataobj.getSeq_no());
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
		
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td style="text-align:left"><a  href="<%=goURL %>"><%= dataobj.getCategory_name()  %></a> </td>
		<td style="text-align:left"> <img src=/upload/<%=dbName%>/<%= dataobj.getMenu_filename() %>><br>
		<td style="text-align:left"> <img  src="/upload/<%=dbName%>/<%= dataobj.getTitle_filename() %>"><br></td>
	</tr>
<%	}
	}
	else {
%>
	<tr><td colspan=4> �з��� �����ϴ�.</td></tr>
<%
	}
%>
</table>

