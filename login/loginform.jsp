<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="/baas/css/common.css" />
<link rel="stylesheet" type="text/css" href="/baas/css/button.css" />
<link rel="stylesheet" type="text/css" href="/baas/css/btn.css" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>동양레저-관리자 화면</title>
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
				alert("아이디를 입력하세요.");
				superuser_id.focus();
				return;
			}else  if(superuser_pwd.val() == '') {
				alert("암호를 입력하세요.");
				superuser_pwd.focus();
				return;
			}else if(pattern1.test(superuser_pwd.val())!= true){
				alert("비밀번호는 영어, 숫자, 특수문자의 조합으로 8~12자리로 변경해주세요.");
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
					<br>관리자  로그인<br>
					<br>Administrator Login  
				</div>
				<div style="text-align:center; height:60px ;background:#ffffff">
					<br>동양레저  통합  웹사이트  관리자  페이지  입니다.<br>
					<br>아이디와  패스워드를  입력하세요<br>
				</div>
				<div style="text-align:center; height:150px; background:#ffffff; border:1px solid #efefef">

					<form method="post" action="/baas/login/login.jsp" name="formName">
					<div><br>
						<span style="text-align:center; height:30px; width:150px"> 아 이 디  </span>
						<span style="text-align:center; height:30px; width:150px"> <input type="text"  onKeyPress="JavaScript: if(event.keyCode == 13) $.submitForm();" id="superuser_id" name="superuser_id" ></span>

					</div>
					<div><br>
						<span style="text-align:center; height:30px; width:150px"> 패스워드  </span>
						<span style="text-align:center; height:30px; width:150px"> <input type="password"  onKeyPress="JavaScript: if(event.keyCode == 13) $.submitForm();" id="superuser_pwd" name="superuser_pwd" ></span>
					</div>	<br>

					<div><br>
					<span class="btn white large"><input type="button" value="로그인" class="btn" onClick="$.submitForm();"></span>
					</div>	
					</form>
				</div>

			</div> 
		</div> 
	</div>
	<div id="footer">
		<address>동양레저(c)</address>
	</div>
</div> 
</body>
</html>