<%@ page language="java" import="java.sql.*, java.io.*, java.util.*" %>
<%@ page contentType="text/html;charset=euc-kr" %>
<html>
<head>
<script language="javascript">
function setCurrentPosition()
{
	var currentTop = self.screenTop -22;
	var currentLeft = self.screenLeft - 3;
	opener.formName.top.value = currentTop;
	opener.formName.left.value = currentLeft;
	self.close();
}
</script>

<title>��ġ  ����</title>
</head>
<body bgcolor=#d4d0c8 topmargin=0 leftmargin=0 marginheight=0 marginwidth=0>
<center>
<br><br><br>

<input type=button value="������ġ��  �����մϴ�." onClick="JavaScript:setCurrentPosition()">


</html>