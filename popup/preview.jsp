<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>미리보기</title>
<style>
A:link  {text-decoration:none; color: #000000}
A:visited {text-decoration:none; color : #000000}
A:hover {text-decoration : underline ; color : #000000}

body {
	margin: 0px 0px 0px 0px;
	padding: 0px 0px 0px 0px;
	background-color: #fff;
	font-family: verdana,arial,curier,돋움;
	font-style: normal;
	font-size: 12px;
	line-height: 100%;
	color: #808080;
}
</style>
</head>
<body>
<div id="previewLayer" style="display:none">


</div>

<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var oEditor = opener.FCKeditorAPI.GetInstance('content') ;
	var  skinValue  = opener.formName.popup_skin.value;
//alert(skinValue);
	var layerContent = oEditor.GetXHTML();

	$('#previewLayer')
	.css("background-image", "url("+ skinValue +")" )

	$('#previewLayer').html(layerContent);
	$('#previewLayer').show();


	
});
//-->
</script>
<table style='width:100%; height:25px; background:#fff; border:0px solid #ccc ' >
<tr><td><input id=checkbox type=checkbox value=checkbox name=checkbox>오늘하루 닫기</td>
<td align=right valign=center><a href="JavaScript:window.close();">닫기</a></td></tr></table>

</body>
</html>