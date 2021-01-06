<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.PopupDataObject"  %>
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
<!-- ������//-->
<div id="positionLayer" style="display:none">
 <br><br><br>
<input type=button value="������ġ��  �����մϴ�." onClick="JavaScript:$.setCurrentPosition()">
</div>
<!-- ������//-->

<!-- ������//-->
<div id="sizeLayer" style="display:none">
 <br><br><br>
<input type=button value="�ݱ�" onClick="JavaScript:$.sizeLayerClose()">
</div>
<!-- ������//-->


<!-- �̸�����//-->
<div id="previewLayer" style="display:none">


</div>
<!-- �̸�����//-->

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
	
	if  (is_sub.val() == 'N'){
		$("[type='checkbox']").attr('checked', false);
		$("[type='checkbox']").attr('disabled', true);
	}			
			
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
		//	else if(numbers.test(top.val()) != true) {
		//		alert("�˾�â  ��ġ(Top)��    ���ڷ�  �Է���  �ּ���.");
		//		top.focus();
		//		return false;
		//	}
		//	else if(numbers.test(left.val()) != true) {
		//		alert("�˾�â  ��ġ(Left)��  ���ڷ�  �Է���  �ּ���.");
		//		left.focus();
		//		return false;
		//	}
			
			var popupWidth = width.val();
			var popupHeight = height.val();
			// var popupTop = top.val();
			// var popupLeft = left.val();

			
			var popupLeft = $(window).scrollLeft() + ( $(window).width() - popupWidth ) / 2;
			var popupTop = $(window).scrollTop() + ( $(window).height() - popupHeight ) / 2;


			skinValue = $('input[name=skin]:checked').val();
		    titleValue =  $('input[name=title]').val();
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
				var layerTitle = "<table style='width:100%; height:25px; background:#fff; border:0px solid #ccc ' ><tr><td> " + titleValue +"</td></tr></table>"
				var layerContent = oEditor.GetXHTML();
				var layerClose = "<table style='width:100%; height:25px; background:#fff; border:0px solid #ccc ' ><tr><td><input id=checkbox type=checkbox value=checkbox name=checkbox>�����Ϸ� �ݱ�</td><td align=right valign=center>	<a href='JavaScript:$.previewLayerClose()'>�ݱ�</a></td></tr></table>"
				layerContent = layerTitle.concat(layerContent) ;

				layerContent = layerContent.concat(layerClose) ;
				//alert(layerContent);
				//layerContent = layerContent;
					
					$('#previewLayer')
					.css("position","absolute")
					.css("clear","both")
					.css("margin","0")
					.css("z-index", "5000")
					.css("width", Number(popupWidth))
					.css("height", Number(popupHeight)+52)
					.css("top", popupTop)
					.css("left", popupLeft)
					.css("border", "1px solid #ccc")
//					.css("border-color", "gray")
					.css("background", "#ffffff")
					.css("background-image", "url("+ popupSkin +")" )
					.css("text-align", "left")

				//	$('#previewLayerCookie')
				//	.css("position","absolute")
				//	.css("clear","both")
				//	.css("margin","0")
				//	.css("z-index", "5000")
				//	.css("width", popupWidth)
				//	.css("height", "24")
				//	.css("top", Number(popupHeight)+Number(popupTop))
				//	.css("left", popupLeft)
				//	.css("border", "1px solid #ccc")
				//	.css("border-color", "gray")
				//	.css("background", "#ffffff")
				//	.css("text-align", "left")
					
					
					$('#previewLayer').html(layerContent);
					$('#previewLayer').show();

			}
		},
	
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
		},
	
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
		},
	
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
		},
		
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
		},
		confirmDelete : function(global, local, db, page, doc) {
			if(!confirm("������ �����ϰڽ��ϱ�?")){
				return;
			}
			else{
				document.location = "/baas/popup/delete.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&doc=" +doc;
			}
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
	
	//������  �����´�..
	String tableName = "tb_" + dbName;
	Map artclemap = new HashMap();

	artclemap.put("tableName", tableName);
	artclemap.put("docNumber", Integer.toString(docNumber));
		
		
	PopupDataObject dataobj = new PopupDataObject();
	dataobj = (PopupDataObject)sqlMap.queryForObject("popupArticle", artclemap);
	
%>
<div class="plate">
	<%
		goURL = strobj.generateURL(globalMenu, localMenu, dbName, "viewlist", pageNumber);
	%>
	<span class="button medium icon"><span class="refresh"></span><a href="<%=goURL%>">���</a></span>
	<span class="button medium icon"><span class="delete"></span>
	<a href="JavaScript:$.confirmDelete('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=docNumber%>');">����</a>
	</span>
</div>
<table class="normal">	
<form method="post" name="formName" action="/baas/popup/edit.jsp">
<tr><td class="line" colspan=4><hr></td></tr>
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ���� : </td>
	<td style="width:750px; text-align:left" colspan=3>
	<input style="width: 300px" type="text" class="thin" name="title" value="<%=dataobj.getTitle()%>">
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
	<input style="width: 90px" type="text" class="thin" name="start_date" value="<%=dataobj.getStart_date()%>" readonly> 
	<span class="button medium icon"><span class="calendar"></span><input  type="button"  onclick="$.openCalendar('start_date')"></span> ����
	
	<input style="width: 90px" type="text" class="thin" name="end_date" value="<%=dataobj.getEnd_date()%>" readonly>
	<span class="button medium icon"><span class="calendar"></span><input  type="button"  onclick="$.openCalendar('end_date')"></span> ����
	</td>
</tr>	
<tr>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ������ : </td>
	<td style="width:375px; text-align:left">
	<input style="width: 30px" type="text" class="thin" name="width" id ="width" value="<%=dataobj.getWidth()%>" maxlength="3"> X 
	<input style="width: 30px" type="text" class="thin" name="height"  value="<%=dataobj.getHeight()%>" maxlength="3">
	<span class="button medium icon"><span class="check"></span><input  type="button"  value="������  �̸�����" onclick="$.sizePopup()"></span>
	</td>
	<td style="width:100px; color:#000; font-weight:bold; text-align:right">* ��ġ : </td>
	<td style="width:375px; text-align:left"> �߾ӿ� �˾� �մϴ�.

<!--
	Top : <input style="width: 30px" type="text" class="thin" name="top" value="<%=dataobj.getTop()%>" maxlength="4">  
	Left : <input style="width: 30px" type="text" class="thin" name="left"  value="<%=dataobj.getLeft()%>" maxlength="4">
	<span class="button medium icon"><span class="check"></span><input  type="button"  value="â����  ����" onclick="$.positionPopup()"></span>
//-->
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ��Ÿ�� : </td>
	<td style="text-align:left">
	<select name="style" class="thin" style="width:150px;">
		<option value="window" <% if (dataobj.getStyle().equals("window")) out.println("selected"); %>>������  �˾�</option>
		<option value="layer"    <% if (dataobj.getStyle().equals("layer")) out.println("selected"); %>>���̾�  �˾�</option>
	</select>
	</td>
	<td style="color:#000; font-weight:bold; text-align:right"> * ��� : </td>
	<td style="text-align:left">
	<select name="is_view" class="thin" style="width:150px;">
		<option value="Y" <% if (dataobj.getIs_view().equals("Y")) out.println("selected"); %>>���</option>
		<option value="N" <% if (dataobj.getIs_view().equals("N")) out.println("selected"); %>>�̻��</option>
	</select>
	</td>
</tr>

<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* ���� �˾� : </td>
	<td style="text-align:left">
	<select name="is_main" class="thin" style="width:150px;">
		<option value="Y" <% if (dataobj.getIs_main().equals("Y")) out.println("selected"); %>>�˾��մϴ�.</option>
		<option value="N" <% if (dataobj.getIs_main().equals("N")) out.println("selected"); %>>�˾�����  �ʽ��ϴ�.</option>
	</select>
	</td>

	<td style="color:#000; font-weight:bold; text-align:right">* ���� �˾� : </td>
	<td style="text-align:left">
	<select name="is_sub" class="thin" style="width:150px;">
		<option value="Y" <% if (dataobj.getIs_sub().equals("Y")) out.println("selected"); %>>�˾�  �մϴ�.</option>
		<option value="N" <% if (dataobj.getIs_sub().equals("N")) out.println("selected"); %>>�˾�  ����  �ʽ��ϴ�.</option>
	</select>
	</td>
</tr>	
<tr>
	<td style="color:#000; font-weight:bold; text-align:right">* �����  : </td>
	<td style="text-align:left" colspan=3>
	<input type="checkbox" name="is_pc" value="Y" <% if (dataobj.getIs_pc().equals("Y")) out.println("checked"); %>> ����ũ��ũ
	<input type="checkbox" name="is_pv" value="Y" <% if (dataobj.getIs_pv().equals("Y")) out.println("checked"); %>> ���ι븮
	<input type="checkbox" name="is_wp" value="Y" <% if (dataobj.getIs_wp().equals("Y")) out.println("checked"); %>> ����Ʈ����
	<input type="checkbox" name="is_yr" value="Y" <% if (dataobj.getIs_yr().equals("Y")) out.println("checked"); %>> ����ȣ����Ʈ
	<input type="checkbox" name="is_wj" value="Y" <% if (dataobj.getIs_wj().equals("Y")) out.println("checked"); %>> ������������
	<input type="checkbox" name="is_nc" value="Y" <% if (dataobj.getIs_nc().equals("Y")) out.println("checked"); %>> F&B
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
		oFCKeditor.setValue(dataobj.getContent());
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
		<input type="radio" id="skin" name="skin" value="blank.gif" <% if (dataobj.getSkin().equals("blank.gif")) out.println("checked"); %>>
		��Ų  ����
		</td>
	</tr>	
	<tr>
	<%
	List skinList = new ArrayList();
	skinList = sqlMap.queryForList("popupSkinEnableList");
	for(int i=0; i < skinList.size(); i++){
		PopupSkinDataObject skinobj = (PopupSkinDataObject) skinList.get(i);
	%>
	<td  style="width:180px;text-align:center" >
	<img src=/upload/<%=dbName%>_skin/<%= skinobj.getFilename() %> width="<%= skinobj.getWidth()/2 %>"  height="<%= skinobj.getHeight()/2 %>"><br>
	<input type="radio" id="skin" name="skin" value="<%= skinobj.getFilename() %>" <% if (dataobj.getSkin().equals(skinobj.getFilename())) out.println("checked"); %>>
	<%=skinobj.getTitle() %><br>
	������ : <%=skinobj.getWidth() %> X  <%=skinobj.getHeight() %><br>
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
	<span class="btn white large"><input type="button" value="�����ϱ�" onClick="$.submitForm();"></span>
	</td>
</tr>
</table>
</form>





