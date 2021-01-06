<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.BookingDataObject"  %>
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
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCount2", countmap)).intValue();
	
	String [][] divisionArray = new String[][]{
			{"��ü","AL"},
			{"���� ũ��ũ","PC"},
			{"����  �븮","PV"}
			//,{"����Ʈ  ����","WP"}
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
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, commandName, 1, divisionArray[i][1], divisionArray[i][1]);
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
	��  <%=totalCount%>����  ��û����  �ֽ��ϴ�. 
	</td>
	<td style="text-align:right;" >
	<%
		if(sessionSuperuserAccessLevel.equals("SUPER") || sessionSuperuserDivisionCode.equals(divisionCode)){
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "writeform", pageNumber, divisionCode, divisionCode);	
	%>
		<form  name="excleform" method="post" action="/baas/booking/makeexcel.jsp">
		<select name="division_name" class="thin" >
		<%
			List divisionList = new ArrayList();	
			divisionList = sqlMap.queryForList("bookingDivisionList");
			for(int i=0; i < divisionList.size(); i++){
				BookingDataObject divdataobj = (BookingDataObject) divisionList.get(i);
		%>
				<option value="<%=divdataobj.getDivision_name() %>"><%=divdataobj.getDivision_name() %></option>	
		<% 
			}
		 %>
		</select>
		<%
			Calendar cal = Calendar.getInstance();
	    	int  currentYear  = cal.get(Calendar.YEAR);
	    	int  currentMonth  = cal.get(Calendar.MONTH)+1;
		%>
		<select name="start_year" class="thin">
			<% for( int  i=2009; i <= currentYear  ; i++){ %>
			<option value="<%=i %>"><%=i %></option>
		 	<% } %>
		</select>��
		
		<select name="start_month" class="thin">
			<% for( int  i=1; i <= 12  ; i++){ %>
			<option value="<%=i %>"><%=i %></option>
		 	<% } %>
		</select>�� ~
		
		<select name="end_year" class="thin">
			<% for( int  i=2009; i <= currentYear  ; i++){ %>
			<option value="<%=i %>"  <%if  (i==currentYear) { out.println("selected"); } %>><%=i %></option>
		 	<% } %>
		</select>��
		
		<select name="end_month" class="thin">
			<% for( int  i=1; i <= 12  ; i++){ %>
			<option value="<%=i %>"  <%if  (i==currentMonth) { out.println("selected"); } %>><%=i %></option>
		 	<% } %>
		</select>�� ����
		<span class="btn red"><input  type="submit" value="���� ��ȯ"></span>
		</form>	
	<%
		}
	%>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	<th style="width: 5%">��ȣ</th>
	<th style="width: 25%"> ��ü��</th>
	<th style="width: 10%">�����</th>
	<th style="width: 10%">����</th>
	<th style="width: 15%">��ü����</th>
	<th style="width: 10%">�ܰ�</th>
	<th style="width: 15%">��û��</th>
	<th style="width: 10%">�����</th>

</tr>
<%
	if (totalCount >0){
		
		Map pagemap = new HashMap();
		
		pagemap.put("tableName", tableName);
		
		if (!divisionCode.equals("AL")){
			pagemap.put("divisionCode", divisionCode);
		}
		
		pagemap.put("pagingSize", Integer.toString(endRow));
		pagemap.put("startRow", Integer.toString(startRow));
		pagemap.put("endRow", Integer.toString(endRow));
		
		List dbList = new ArrayList();
		
		dbList = sqlMap.queryForList("bookingPagingList", pagemap);
		int virtualNumber =0;
		for(int i=0; i < dbList.size(); i++){
			BookingDataObject dataobj = (BookingDataObject) dbList.get(i);
			goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewdoc", pageNumber, dataobj.getSeq_no(), divisionCode, dataobj.getDivision_code());
			virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
%>
	<tr>
        <td><%= virtualNumber %></td>
        <td style="text-align:left">
        <a  href="<%=goURL %>"><%= dataobj.getGroup_name() %></a>
        </td>
        <td><%= dataobj.getChoice_date1()%>°��<br><%= dataobj.getChoice_date2()%>����<br><%= dataobj.getChoice_date3()%>��</td>
        <td><%= dataobj.getOrder_team() %>��<br>(<%= dataobj.getOrder_cnt() %>��)</td>
        <td>
        	ȸ��:<%= dataobj.getCaptain_name() %><br>
        	�ѹ�:<%= dataobj.getManager_name()%><br>
        	��û:<%= dataobj.getOrder_name()%>
        </td>
       	<td><%= dataobj.getCustomer_tran()%>�� </td>
         <td><%= dataobj.getWrite_date()%>	</td>
         <td><%= dataobj.getDivision_name()%>	</td>
	</tr>
	
<%	}
	}
	else {
%>
	<tr><td colspan=10> �Խõ�  ����  �����ϴ�.</td></tr>
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
</table>

