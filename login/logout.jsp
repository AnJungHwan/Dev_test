<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR" %>
 
<%

	
	if(session != null){	
	//out.println(session.getAttribute("superuser_id"));
		session.invalidate();
	}
	out.println("<script>alert('로그아웃  되었습니다.');document.location='https://www.tyleisure.co.kr/baas/login/loginform.jsp';</script>"); 

	

%>


