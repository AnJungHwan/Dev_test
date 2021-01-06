<%
	request.setCharacterEncoding("euc-kr");	
	
	int globalMenu  = (request.getParameter("global_menu") != null ? Integer.parseInt(request.getParameter("global_menu")) :0);
	int localMenu  = (request.getParameter("local_menu") != null ? Integer.parseInt(request.getParameter("local_menu")) :0);
	int pageNumber  = (request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) :1);
	int docNumber  = (request.getParameter("doc") != null ? Integer.parseInt(request.getParameter("doc")) :0);				
			
	String dbName  = (request.getParameter("db") != null ? request.getParameter("db") :"");
	String commandName  = (request.getParameter("cmd") != null ? request.getParameter("cmd") :"main");
	String divisionCode  = (request.getParameter("div") != null ? request.getParameter("div") :"AL");
	String accessCode  = (request.getParameter("code") != null ? request.getParameter("code") :"AL");
	String categoryCode  = (request.getParameter("category") != null ? request.getParameter("category") :"AL");
	
%>
