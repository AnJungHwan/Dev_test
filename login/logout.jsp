<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR" %>
 
<%

	
	if(session != null){	
	//out.println(session.getAttribute("superuser_id"));
		session.invalidate();
	}
	out.println("<script>alert('�α׾ƿ�  �Ǿ����ϴ�.');document.location='https://www.tyleisure.co.kr/baas/login/loginform.jsp';</script>"); 

	

%>


