<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="/baas/css/common.css" />
<link rel="stylesheet" type="text/css" href="/baas/css/button.css" />
<link rel="stylesheet" type="text/css" href="/baas/css/btn.css" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>���緹��-������ ȭ��</title>
</head>
<body>
<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	var 	superuser_id = $('[name="superuser_id"]');
	var 	superuser_pwd = $('[name="superuser_pwd"]');
	var		pattern1 = /([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/;

	$.extend({
		submitForm : function() {
			
			 if(superuser_id.val() == '') {
				alert("���̵� �Է��ϼ���.");
				superuser_id.focus();
				return;
			}else  if(superuser_pwd.val() == '') {
				alert("��ȣ�� �Է��ϼ���.");
				superuser_pwd.focus();
				return;
			}else if(pattern1.test(superuser_pwd.val())!= true){
				alert("��й�ȣ�� ����, ����, Ư�������� �������� 8~12�ڸ��� �������ּ���.");
			}
			
			document.formName.submit();
		}
	});
});
//-->
</script>
<div id="container">

	<div id="header">
		<div id="companyLogo">
			<img src=/baas/images/tyleisure_logo.gif>
		</div>	
	</div> 
	<div id="bodies">
		<div id="content">
			<div class="section">
				<div style="text-align:center; height:60px ;background:#efefef">
					<br>������  �α���<br>
					<br>Administrator Login  
				</div>
				<div style="text-align:center; height:60px ;background:#ffffff">
					<br>���緹��  ����  ������Ʈ  ������  ������  �Դϴ�.<br>
					<br>���̵��  �н����带  �Է��ϼ���<br>
				</div>
				<div style="text-align:center; height:150px; background:#ffffff; border:1px solid #efefef">

					<form method="post" action="/baas/login/login.jsp" name="formName">
					<div><br>
						<span style="text-align:center; height:30px; width:150px"> �� �� ��  </span>
						<span style="text-align:center; height:30px; width:150px"> <input type="text"  onKeyPress="JavaScript: if(event.keyCode == 13) $.submitForm();" id="superuser_id" name="superuser_id" ></span>

					</div>
					<div><br>
						<span style="text-align:center; height:30px; width:150px"> �н�����  </span>
						<span style="text-align:center; height:30px; width:150px"> <input type="password"  onKeyPress="JavaScript: if(event.keyCode == 13) $.submitForm();" id="superuser_pwd" name="superuser_pwd" ></span>
					</div>	<br>

					<div><br>
					<span class="btn white large"><input type="button" value="�α���" class="btn" onClick="$.submitForm();"></span>
					</div>	
					</form>
				</div>

			</div> 
		</div> 
	</div>
	<div id="footer">
		<address>���緹��(c)</address>
	</div>
</div> 
</body>
</html>