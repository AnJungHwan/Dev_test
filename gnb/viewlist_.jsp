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
	// �������� �ε��� �� 'Loading �̹���'�� �����.
	$('#viewLoading').hide();

	// ajax ���� �� �Ϸ�� 'Loading �̹���'�� ������ ��Ʈ������.
	$('#viewLoading')
	.ajaxStart(function()
	{
		// �ε��̹����� ��ġ �� ũ������	
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
				if(!confirm("��з��� ���� �ϸ� ���� �з��� ���� �˴ϴ�.\n\n ������ �����ϰڽ��ϱ�?")){
					return;
				}
				else  {
					$.get("/baas/gnb/delete.jsp", {doc:doc, menu:menu, large:large, medium:medium},function(data){
						location.reload();
					});
				}
			}
			else  if(menu ==2){
				if(!confirm("�ߺз��� ���� �ϸ� ���� �з��� ���� �˴ϴ�.\n\n ������ �����ϰڽ��ϱ�?")){
					return;
				}
				else  {
					$.get("/baas/gnb/delete.jsp", {doc:doc, menu:menu, large:large, medium:medium},function(data){
						location.reload();
					});
				}
			}
			else  {
				if(!confirm("������ �����ϰڽ��ϱ�?")){
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
				if(!confirm("��з��� ���� �ϸ� ���� �з��� �ϰ� ���� �˴ϴ�.\n\n ������ �����ϰڽ��ϱ�?")){
					return;
				}
				else  {
					$.post("/baas/gnb/edit.jsp", {doc:doc, menu:menu, large:large, medium:medium, name:escape(menu_name), link:escape(menu_link)},function(){
						alert("�����Ͽ����ϴ�.");
						location.reload();
					});
				}
			}
			else  if(menu ==2){
				if(!confirm("�ߺз��� ���� �ϸ� ���� �з��� �ϰ� ���� �˴ϴ�.\n\n ������ �����ϰڽ��ϱ�?")){
					return;
				}
				else  {
					$.post("/baas/gnb/edit.jsp", {doc:doc, menu:menu, large:large, medium:medium, name:escape(menu_name), link:escape(menu_link)},function(){
						alert("�����Ͽ����ϴ�.");
						location.reload();
					});
				}
			}
			else  {
				if(!confirm("�����ϰڽ��ϱ�?")){
					return;
				}
				else{
					$.post("/baas/gnb/edit.jsp", {doc:doc, menu:menu, large:large, medium:medium, name:escape(menu_name), link:escape(menu_link)},function(){
						alert("�����Ͽ����ϴ�.");
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
					alert("�����Ͽ����ϴ�.");	
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
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalCount", countmap)).intValue();
	
%>


<table class="normal">	
<tr>
	<td style="text-align:left;" >
	��  <%=totalCount%>����  �޴��� �ֽ��ϴ�. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "writeform", pageNumber);
	%>
	<span class="button medium icon"><span class="refresh"></span><a href="JavaScript:$.makeXML()">XML �ۼ�</a></span>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">�޴�  �߰�</a></span>
	</td>
</tr>
</table>
 <table class="list">	
<tr>
	
	<th style="width: 10%">�з���</th>
	<th style="width: 12%">�ֻ����з�</th>
	<th style="width: 13%">�����з�</th>
	<th style="width: 25%">�޴���</th>
	<th style="width: 20%">��ũ</th>
	<th style="width: 20%">����/����</th>
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
		 &nbsp; &nbsp; ��
        <%
        } 
        else if(dataobj.getMenu_code()==3){ 
        %>
        &nbsp; &nbsp; &nbsp; &nbsp; ��
        <%  }   %>
        <input type="input" name=name  class="thin" id=menu_name<%=i%> value="<%= dataobj.getMenu_name() %>" style="width: 110px">
        <br></td>
        <td style="text-align:left">
         <input type="input" name=link  class="thin" id=menu_link<%=i%> value="<%= dataobj.getMenu_link() %>" style="width: 110px">
         <br></td>
	  	<td style="text-align:center"> 
	  	<span class="button medium icon"><span class="check"></span>
	  	<a href="JavaScript:$.confirmEdit('<%=dataobj.getSeq_no()%>','<%=dataobj.getMenu_code()%>','<%=dataobj.getLarge_index()%>','<%=dataobj.getMedium_index()%>','<%=i%>')">����</a></span>
	  	
	  	<span class="button medium icon"><span class="delete"></span>
	  	<a href="JavaScript:$.confirmDelete('<%=dataobj.getSeq_no()%>','<%=dataobj.getMenu_code()%>','<%=dataobj.getLarge_index()%>','<%=dataobj.getMedium_index()%>')">����</a></span>
	  	
	  	</td>
	</tr>
<%	}
	}
	else {
%>
	<tr><td colspan=7> �޴���  �����ϴ�.</td></tr>
<%
	}
%>
</table>
<div id="viewLoading">
	<img src="/baas/images/loading.gif">
</div>
