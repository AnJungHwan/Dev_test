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

<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var oEditor = opener.FCKeditorAPI.GetInstance('content') ;
	var  skin  = opener.formName.popup_skin.value;
	var  width  = opener.formName.width.value;
	var  top  = opener.formName.height.value;
	var previewdiv = document.createElement("DIV");
	document.body.background = skin;
	previewdiv.innerHTML = oEditor.GetXHTML();
 	document.body.appendChild(previewdiv);

 	$("#popup_cookie")
 	.css("position","absolute")
	.css("clear","both")
	.css("margin","0")
	.css("width", width)
	.css("height", "24")
	.css("top", top)
	.css("left", "0")
	.css("background", "#ffffff")
	.css("color", "#000000")
	
	$("#popup_close")
 	.css("position","absolute")
	.css("clear","both")
	.css("margin","6, 0, 0, 0")
	.css("width", "30")
	.css("height", "24")
	.css("top", top)
	.css("left", width-30)
	.css("background", "#ffffff")
	.css("color", "#000000")
	.css("text-align", "center")
	
});
//-->
</script>


<div id="popup_cookie" >
	<input id=checkbox type=checkbox value=checkbox name=checkbox>
	하루동안  이  창을  열지  않음
</div>
<div id="popup_close" style="color:#ffffff" >
	<a href="JavaScript:window.close();">닫기</a>
</div>


</body>
</html>