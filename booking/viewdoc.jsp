<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.BookingDataObject"  %>
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
<%
	int isAccess = 0;
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	AclDataObject acldataobj = new AclDataObject();

	Map map = new HashMap();
	map.put("superuserID", sessionSuperuserID);
	map.put("dbName", dbName);
	map.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", map);
	
	isAccess  = acldataobj.getIs_access();

	//������  �����´�..
	String tableName = "tb_" + dbName;
	Map artclemap = new HashMap();

	artclemap.put("tableName", tableName);
	artclemap.put("docNumber", Integer.toString(docNumber));
	
	
	BookingDataObject dataobj = new BookingDataObject();
	dataobj = (BookingDataObject)sqlMap.queryForObject("bookingArticle", artclemap);
	
	
	String goList = null;
	String goURL = null;
	
	StringUtility strobj = new StringUtility();
	
	goList = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", pageNumber, divisionCode, accessCode);

%>
<br><br>
<div class="plate">
	<span class="button medium icon"><span class="refresh"></span><a href="<%=goList%>">���</a></span>
</div>

<table class="list"> 	
<tr>
	<th style="width:140px">��ü��</th>
	<td style="text-align:left" colspan=5><%=dataobj.getGroup_name()%></td>
</tr>
<tr>
	<th style="width:140px" >�����	</th>
	<td style="text-align:left;width:140px">
		<%=dataobj.getChoice_date1()%>°�� <%=dataobj.getChoice_date2()%>���� <%=dataobj.getChoice_date3()%>��</td>
	<th style="width:140px" >����</th>
	<td style="text-align:left;width:140px"><%=dataobj.getOrder_team()%>�� <%=dataobj.getOrder_cnt()%>�� </td>
	<th style="width:140px" >���ܰ�</th>
	<td style="text-align:left;width:140px"><%=dataobj.getCustomer_tran()%>�� </td>
</tr>
<tr>
	<th>ȸ�� ����</th>
	<td style="text-align:left"><%=dataobj.getCaptain_name()%></td>
	<th>ȸ�� ID</th>
	<td style="text-align:left">
	<% if  (dataobj.getCaptain_id() == null)
			out.println("-");
		else
			out.println(dataobj.getCaptain_id());
	%>
	<th>ȸ�� HP</th>
	<td style="text-align:left"><%=dataobj.getCaptain_hp()%> </td>
</tr>
<tr>
	<th>�ѹ� ����</th>
	<td style="text-align:left"><%=dataobj.getManager_name()%></td>
	<th>�ѹ� ID</th>
	<td style="text-align:left">
	<% if  (dataobj.getManager_id() == null)
			out.println("-");
		else
			out.println(dataobj.getManager_id());
	%>
	<th>�ѹ� HP</th>
	<td style="text-align:left"><%=dataobj.getManager_hp()%> </td>
</tr>
<tr>
	<th>��û�� ����</th>
	<td style="text-align:left"><%=dataobj.getOrder_name()%></td>
	<th>��û�� ID</th>
	<td style="text-align:left">
	<% if  (dataobj.getOrder_id() == null)
			out.println("-");
		else
			out.println(dataobj.getOrder_id());
	%>
	<th>��û�� HP</th>
	<td style="text-align:left"><%=dataobj.getOrder_hp()%> </td>
</tr>
<tr>
	<th>��û����</th>
	<td style="text-align:left"><%=dataobj.getWrite_date()%></td>
	<th>�����</th>
	<td style="text-align:left" colspan=3><%=dataobj.getDivision_name()%> </td>
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
	pnndataobj = (PrevAndNextDataObject)sqlMap.queryForObject("bookingPrevAndNextArticle", pnnmap);
	
	int nextNumber = pnndataobj.getNext_no();
	int prevNumber = pnndataobj.getPrev_no();
	
	String prevTitle = pnndataobj.getPrev_title();
	String nextTitle = pnndataobj.getNext_title();
%>


<table class="normal">	
<tr><td class="line"><hr></td></tr>
<tr>
	<td  style="text-align:left">������  : 
	<% 
		if (nextNumber == 0){
			out.println("��������  �����ϴ�");
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
	<td style="text-align:left">������  : 
	<% 
		if (prevNumber == 0){
			out.println("��������  �����ϴ�");
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
