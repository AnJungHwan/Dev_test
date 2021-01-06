<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.PopupSkinDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

 <%@ page import="com.fredck.FCKeditor.*" %>
<div id="positionLayer" style="display:none">
 <br><br><br>
<input type=button value="������ġ��  �����մϴ�." onClick="JavaScript:$.setCurrentPosition()">
</div>

<div id="sizeLayer" style="display:none">
 <br><br><br>
<input type=button value="�ݱ�" onClick="JavaScript:$.sizeLayerClose()">
</div>

<div id="previewLayer" style="display:none">
</div>

<div id="previewLayerCookie" style="position:absolute; display:none">
<table id="previewLayerTable">
<tr>
	<td>	
		<input id=checkbox type=checkbox value=checkbox name=checkbox>
		�Ϸ絿��  ��  â��  ����  ����
	</td>
	<td align=right valign=center>	
		<a href='JavaScript:$.previewLayerClose()'>�ݱ�</a></span>
	</td>
</tr>
</table>
</div>

<script language="JavaScript" type="text/JavaScript" src="/baas/js/swf_upload.js"></script>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){

	var p_moveX, p_moveY, p_gapX, p_gapY;
	var s_moveX, s_moveY, s_gapX, s_gapY;
	
	var moveX, moveY, gapX, gapY;
	var moveX1, moveY1, gapX1, gapY1;
	
	var isMouseDown = false;

	var numbers = /^[0-9]{1,4}$/; // ���ڰ˻�
	var 	width = $('[name="width"]'),
			height = $('[name="height"]'),
			top = $('[name="top"]'),
			left = $('[name="left"]'),
			title = $('[name="title"]'),
			style = $('[name="style"]');
			is_sub = $('[name="is_sub"]');
	
		
	is_sub.change(function() {
		var  value = $(this).val();
		
		if (value =="Y") {
			$("[type='checkbox']").attr('disabled', false);	
		}
		else if(value =="N") {
			$("[type='checkbox']").attr('checked', false);
			$("[type='checkbox']").attr('disabled', true);
		}
	});
	
	$("#positionLayer").mousedown(function (e) {
		p_gapX = e.pageX - $(this).offset().left;
		p_gapY = e.pageY - $(this).offset().top;
	
		$(document.body).css("cursor", "move");
		isMouseDown = true;
	});
	$("#sizeLayer").mousedown(function (e) {
		s_gapX = e.pageX - $(this).offset().left;
		s_gapY = e.pageY - $(this).offset().top;
	
		$(document.body).css("cursor", "move");
		isMouseDown = true;
	});
	$("#previewLayer").mousedown(function (e) {
		gapX = e.pageX - $(this).offset().left;
		gapY = e.pageY - $(this).offset().top;
	
		gapX1 = e.pageX - $("#previewLayerCookie").offset().left;
		gapY1 = e.pageY -  $("#previewLayerCookie").offset().top;
		
		$(document.body).css("cursor", "move");
		isMouseDown = true;
	});

	$(this).mouseup(function () {
		$(document.body).css("cursor", "default");
		isMouseDown = false;
	});

	$("#positionLayer").mousemove(function (e) {
		if(isMouseDown) {
			p_moveX = e.pageX - p_gapX;
			p_moveY = e.pageY - p_gapY;
			
			$("#positionLayer").css("left", p_moveX + "px");
			$("#positionLayer").css("top", p_moveY + "px");
		}
	});
	$("#sizeLayer").mousemove(function (e) {
		if(isMouseDown) {
			s_moveX = e.pageX - s_gapX;
			s_moveY = e.pageY - s_gapY;
			
			$("#sizeLayer").css("left", s_moveX + "px");
			$("#sizeLayer").css("top", s_moveY + "px");
		}
	});
	$("#previewLayer").mousemove(function (e) {
		if(isMouseDown) {
			moveX = e.pageX - gapX;
			moveY = e.pageY - gapY;
			moveX1 = e.pageX - gapX1;
			moveY1 = e.pageY - gapY1;
			$("#previewLayer").css("left", moveX + "px");
			$("#previewLayer").css("top", moveY + "px");
			$("#previewLayerCookie").css("left", moveX1 + "px");
			$("#previewLayerCookie").css("top", moveY1 + "px");
		}
	});
	
	
		 	
	$.extend({
		previewPopup : function() {
			var oEditor = FCKeditorAPI.GetInstance('content') ;
			if(numbers.test(width.val()) != true) {
				alert("�˾�â  ���̸�  ���ڷ�  �Է���  �ּ���.");
				width.focus();
				return false;
			}
			else if(numbers.test(height.val()) != true) {
				alert("�˾�â  ���̸�  ���ڷ�  �Է���  �ּ���.");
				height.focus();
				return false;
			}
			else if(numbers.test(top.val()) != true) {
				alert("�˾�â  ��ġ(Top)��    ���ڷ�  �Է���  �ּ���.");
				top.focus();
				return false;
			}
			else if(numbers.test(left.val()) != true) {
				alert("�˾�â  ��ġ(Left)��  ���ڷ�  �Է���  �ּ���.");
				left.focus();
				return false;
			}
			
			var popupWidth = width.val();
			var popupHeight = height.val();
			var popupTop = top.val();
			var popupLeft = left.val();
			
			skinValue = $('input[name=skin]:checked').val();

			if(typeof skinValue == 'undefined'){
				popupSkin = "/upload/popup_skin/blank.gif";
			}
			else{
				popupSkin = "/upload/popup_skin/" + skinValue;
			}
			$('#popup_skin').val(popupSkin);
			
			if (style.val() == 'window'){
				popupHeight = Number(height.val())+24;
				var settings = 'height='+popupHeight+',width='+popupWidth+',top='+popupTop+',left='+popupLeft + ',toolbar=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no';
				previewWindow = window.open('/baas/popup/preview.jsp', 'previewWindow', settings);
			}
			else{
				var layerContent = oEditor.GetXHTML();
				 $('table#previewLayerTable').attr('width', popupWidth);
					//layerContent = layerContent + $('#previewLayerCookie').html() ;
					layerContent = layerContent;
					
					$('#previewLayer')
					.css("position","absolute")
					.css("clear","both")
					.css("margin","0")
					.css("z-index", "5000")
					.css("width", popupWidth)
					.css("height", popupHeight)
					.css("top", popupTop)
					.css("left", popupLeft)
					.css("border", "1px solid #ccc")
					.css("border-color", "gray")
					.css("background", "#ffffff")
					.css("background-image", "url("+ popupSkin +")" )
					.css("text-align", "left")
					
					$('#previewLayerCookie')
					.css("position","absolute")
					.css("clear","both")
					.css("margin","0")
					.css("z-index", "5000")
					.css("width", popupWidth)
					.css("height", "24")
					.css("top", Number(popupHeight)+Number(popupTop))
					.css("left", popupLeft)
					.css("border", "1px solid #ccc")
					.css("border-color", "gray")
					.css("background", "#ffffff")
					.css("text-align", "left")
					
					
					$('#previewLayer').html(layerContent);
					$('#previewLayer').show();
					$('#previewLayerCookie').show();
			}
		}
	});

	$.extend({
		positionPopup : function() {
			if(numbers.test(top.val()) != true) {
				alert("�˾�â  ��ġ(Top)��    ���ڷ�  �Է���  �ּ���.");
				top.focus();
				return false;
			}
			else if(numbers.test(left.val()) != true) {
				alert("�˾�â  ��ġ(Left)��  ���ڷ�  �Է���  �ּ���.");
				left.focus();
				return false;
			}
			var popupWidth = width.val() !="" ? width.val() : 320 ;
			var popupHeight = height.val() != "" ? height.val() : 400 ;
			var popupTop = top.val();
			var popupLeft = left.val();

			if (style.val() == 'window'){
				var settings = 'height='+popupHeight+',width='+popupWidth+',top='+popupTop+',left='+popupLeft + ',toolbar=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no';
				positionWindow = window.open('/baas/popup/position.jsp', 'positionWindow', settings);
			}
			else{
				$('#positionLayer')
				.css("position","absolute")
				.css("clear","both")
				.css("margin","0")
				.css("z-index", "5000")
				.css("width", popupWidth)
				.css("height", popupHeight)
				.css("top", popupTop)
				.css("left", popupLeft)
				.css("border", "1px solid #ccc")
				.css("border-color", "gray")
				.css("background", "#d4d0c8")
				.show();	
			}
		}
	});
	
	$.extend({
		sizePopup : function() {
			
			if(numbers.test(width.val()) != true) {
				alert("�˾�â  ���̸�  ���ڷ�  �Է���  �ּ���.");
				width.focus();
				return false;
			}
			else if(numbers.test(height.val()) != true) {
				alert("�˾�â  ���̸�  ���ڷ�  �Է���  �ּ���.");
				height.focus();
				return false;
			}
			var popupWidth = width.val() ;
			var popupHeight = height.val();
			
			var popupTop = top.val() !="" ? top.val() : (screen.height - popupHeight) / 2 ;
			var popupLeft = left.val() != "" ? left.val() : (screen.width - popupWidth) / 2 ;

			if (style.val() == 'window'){
				var settings = 'height='+popupHeight+',width='+popupWidth+',top='+popupTop+',left='+popupLeft + ',toolbar=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no';
				sizeWindow = window.open('/baas/popup/size.jsp', 'sizeWindow', settings);
			}
			else{
				$('#sizeLayer')
				.css("position","absolute")
				.css("clear","both")
				.css("margin","0")
				.css("z-index", "5000")
				.css("width", popupWidth)
				.css("height", popupHeight)
				.css("top", popupTop)
				.css("left", popupLeft)
				.css("border", "1px solid #ccc")
				.css("border-color", "gray")
				.css("background", "#d4d0c8")
				.show();	
			}
		}
	});
	
	$.extend({
		openCalendar : function(name) {
			
			var newtop = event.screenY;
			var newleft = event.screenX;
			if (event.clientX > (document.body.clientWidth - 5 - 200))	{
				newleft=event.screenX - 5 - 200;
			}
			if (event.clientY > (document.body.clientHeight - 5 - 220))	{
				newtop=event.screenY - 30 - 220;
			}	
			var settings="toolbar=no , directories=no, status=no, scrollbars=no, resizable=no,top="+newtop+",left="+newleft+", toolbar=no, height=300, width=200";
			window.open("/baas/popup/calendar.jsp?name="+name, "calendar" , settings);
			}
		});
	
	$.extend({
		submitForm : function() {
			
			var oEditor = FCKeditorAPI.GetInstance('content') ;
			var div = document.createElement("DIV");
			 div.innerHTML = oEditor.GetXHTML();

			 if( title.val() == '') {
					alert("������ �Է��ϼ���.");
					title.focus();
					return;
			}
			 else if(div.innerHTML=='') {
				alert("������ �Է� �ϼ���");
				oEditor.Focus();
				return false;
			}
			 else	if(numbers.test(width.val()) != true) {
				alert("�˾�â  ���̸�  ���ڷ�  �Է���  �ּ���.");
				width.focus();
				return false;
			}
			else if(numbers.test(height.val()) != true) {
				alert("�˾�â  ���̸�  ���ڷ�  �Է���  �ּ���.");
				height.focus();
				return false;
			}
			else if(numbers.test(top.val()) != true) {
				alert("�˾�â  ��ġ(Top)��    ���ڷ�  �Է���  �ּ���.");
				top.focus();
				return false;
			}
			else if(numbers.test(left.val()) != true) {
				alert("�˾�â  ��ġ(Left)��  ���ڷ�  �Է���  �ּ���.");
				left.focus();
				return false;
			}
			
			callSwfUpload('"formName"');	 
		},
		setCurrentPosition : function() {
			var p = $('#positionLayer');
			var position = p.position();
			top.val(position.top);
			left.val(position.left);
			p.hide();
		},
		sizeLayerClose : function() {
			$('#sizeLayer').hide();
		},
		previewLayerClose : function() {
			$('#previewLayer, #previewLayerCookie').hide();
			
		}
	});
	
	
});

//-->
</script>
 <%
	StringUtility strobj = new StringUtility();

	int isAccess = 0;
	String goURL="";

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	if (!sessionSuperuserAccessLevel.equals("SUPER")){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}
	
%>
<div class="plate">
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
	%>
		<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/popup/write.jsp">
<tr><td class="line" colspan=4><hr></td></tr>
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ���� : </td>
	<td style="width:750px; text-align:left" colspan=3>
	<input style="width: 300px" type="text" class="thin" name="title">
	</td>
</tr>	
<tr>
	<%
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date date = new java.util.Date();
		String currentDate = dateFormatter.format(date);
	%>
	<td style="color:#000; font-weight:bold; text-align:right">* �Ⱓ : </td>
	<td style="text-align:left" colspan=3>
	<input style="width: 90px" type="text" class="thin" name="start_date" value="<%=currentDate%>" readonly> 
	<span class="button medium icon"><span class="calendar"></span><input  type="button"  onclick="$.openCalendar('start_date')"></span> ����
	
	<input style="width: 90px" type="text" class="thin" name="end_date" value="<%=currentDate%>" readonly>
	<span class="button medium icon"><span class="calendar"></span><input  type="button"  onclick="$.openCalendar('end_date')"></span> ����
	</td>
</tr>	
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ������ : </td>
	<td style="width:375px; text-align:left">
	<input style="width: 30px" type="text" class="thin" name="width" id ="width" value="320" maxlength="3"> X 
	<input style="width: 30px" type="text" class="thin" name="height"  value="400" maxlength="3">
	<span class="button medium icon"><span class="check"></span><input  type="button"  value="������  �̸�����" onclick="$.sizePopup()"></span>
	</td>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ��ġ : </td>
	<td style="width:375px; text-align:left">
	Top : <input style="width: 30px" type="text" class="thin" name="top" value="0" maxlength="4">  
	Left : <input style="width: 30px" type="text" class="thin" name="left"  value="0" maxlength="4">
	<span class="button medium icon"><span class="check"></span><input  type="button"  value="â����  ����" onclick="$.positionPopup()"></span>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ��Ÿ�� : </td>
	<td style="text-align:left">
	<select name="style" class="thin" style="width:150px;">
		<option value="window" >������  �˾�</option>
		<option value="layer" selected>���̾�  �˾�</option>
	</select>
	</td>
	<td style="color:#000; font-weight:bold; text-align:right"> * ��� : </td>
	<td style="text-align:left">
	<select name="is_view" class="thin" style="width:150px;">
		<option value="Y" selected>���</option>
		<option value="N">�̻��</option>
	</select>
	</td>
</tr>

<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ���� �˾� : </td>
	<td style="text-align:left">
	<select name="is_main" class="thin" style="width:150px;">
		<option value="Y" >�˾��մϴ�.</option>
		<option value="N" >�˾�����  �ʽ��ϴ�.</option>
	</select>
	</td>

	<td style="color:#000; font-weight:bold; text-align:right">* ���� �˾� : </td>
	<td style="text-align:left">
	<select name="is_sub" class="thin" style="width:150px;">
		<option value="Y" >�˾�  �մϴ�.</option>
		<option value="N" >�˾�  ����  �ʽ��ϴ�.</option>
	</select>
	</td>
</tr>	
<tr>

	<td style="color:#000; font-weight:bold; text-align:right">* �����  : </td>
	<td style="text-align:left" colspan=3>
	<input type="checkbox" name="is_pc" value="Y"> ����ũ��ũ
	<input type="checkbox" name="is_pv" value="Y"> ���ι븮
	<input type="checkbox" name="is_wp" value="Y">����Ʈ����
	<input type="checkbox" name="is_yr" value="Y"> ����ȣ����Ʈ
	<input type="checkbox" name="is_wj" value="Y"> ������������
	<input type="checkbox" name="is_nc" value="Y"> F&B
	</td>

</tr>
<tr><td class="line" colspan=4><hr></td></tr>
<tr>
	<td style="text-align:left" colspan=4>
	<%
		FCKeditor oFCKeditor ;
		oFCKeditor = new FCKeditor( request, "content" ) ;
		oFCKeditor.setBasePath( "/baas/FCKeditor/" ) ;
		oFCKeditor.setToolbarSet("tyleisure");
		oFCKeditor.setHeight("500");
		oFCKeditor.setWidth("850");
		out.println( oFCKeditor.create() ) ;
	%>
	</td>
</tr>
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ��Ų : </td>
	<td style="width:750px;text-align:left" colspan=4>
	<table  style="width:750px;text-align:left" >
	<tr>
		<td  style="width:180px;text-align:center" colspan=4 >
		<input type="radio" id="skin" name="skin" value="blank.gif">
		��Ų  ����
		</td>
	</tr>	
	<tr>
	<%
	List skinList = new ArrayList();
	skinList = sqlMap.queryForList("popupSkinEnableList");
	for(int i=0; i < skinList.size(); i++){
		PopupSkinDataObject dataobj = (PopupSkinDataObject) skinList.get(i);
	%>
	<td  style="width:180px;text-align:center" >
	<img src=/upload/<%=dbName%>_skin/<%= dataobj.getFilename() %> width="<%= dataobj.getWidth()/2 %>"  height="<%= dataobj.getHeight()/2 %>"><br>
	<input type="radio" id="skin" name="skin" value="<%= dataobj.getFilename() %>" >
	<%=dataobj.getTitle() %><br>
	������ : <%=dataobj.getWidth() %> X  <%=dataobj.getHeight() %><br>
	
	</td>
	<%
		if ( i % 4 == 3) {
			out.println("</tr><tr>");
		}
	}
	%>	
	</tr>
	</table>
	</td>
</tr>	
<tr><td class="line" colspan=4><hr></td></tr>
<tr><td colspan="4">
	<input type="hidden" id="popup_skin">
	
	<input type="hidden" name="user_id" value="<%= sessionSuperuserID%>">
	<input type="hidden" name="user_name" value="<%= sessionSuperuserName%>">
	
	<input type="hidden" name="global_menu" value="<%= globalMenu%>">
	<input type="hidden" name="local_menu" value="<%= localMenu%>">
	<input type="hidden" name="db" value="<%= dbName%>">
	<input type="hidden" name="doc" value="<%= docNumber%>">
	<input type="hidden" name="page" value="<%= pageNumber%>">

	<span class="btn white large"><input type="button" value="�̸�  ����" onClick="$.previewPopup();"></span>
	<span class="btn white large"><input type="button" value="�˾�  ����" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>



