<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.LogInfoDataObject"  %>
<%@ page import="database.datadef.SuperuserDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%
	String superuserID = request.getParameter("superuser_id");	
	String superuserPW = request.getParameter("superuser_pwd");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	
	SuperuserDataObject dataobj = new SuperuserDataObject();
	
	dataobj = (SuperuserDataObject) sqlMap.queryForObject("superuserCheck", superuserID);
	if (dataobj == null){ 
		out.println("<script>alert('���̵� �������� �ʽ��ϴ�.');history.back();</script>"); 
	}
	else {
		// ���̵�  �����ϸ�  �н����带  ��
		String  dbSuperuserPW  = dataobj.getSuperuser_pwd();
		
		if(dbSuperuserPW.equals(superuserPW)){
			String  dbSuperuserAccessLevel  = dataobj.getAccess_level();
			String  dbSuperuserName  = dataobj.getSuperuser_name();
			String  dbSuperuserDivision  = dataobj.getDivision();
			String division_code=null;
			if (dbSuperuserDivision.equals("���緹��")){
				division_code="TL";
			}
			else if(dbSuperuserDivision.equals("����ũ��ũ")){
				division_code="PC";
			}
			else if(dbSuperuserDivision.equals("���ι븮")){
				division_code="PV";
			}
			else if(dbSuperuserDivision.equals("����Ʈ����")){
				division_code="WP";
			}
			else if(dbSuperuserDivision.equals("F&B")){
				division_code="NC";
			}
			// ���� ����
			session.setAttribute("superuser_id", superuserID);
			session.setAttribute("superuser_name", dbSuperuserName);
			session.setAttribute("access_level", dbSuperuserAccessLevel);
			session.setAttribute("division_name", dbSuperuserDivision);
			session.setAttribute("division_code", division_code);
			session.setMaxInactiveInterval(30*60); 
			// ����  ��¥��  �ð�, ������ ��巹���� ����
			SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

			java.util.Date date = new java.util.Date();
			String currentDate = dateFormatter.format(date);
			String currentTime = timeFormatter.format(date);

			String ipAddress = request.getRemoteAddr();
				
			// �α������� ���������� �Է�
			Map logmap = new HashMap();
			logmap.put("superuser_id", superuserID);
			logmap.put("superuser_name", dbSuperuserName);
			logmap.put("login_date", currentDate);
			logmap.put("login_time", currentTime);
			logmap.put("ipaddress", ipAddress);
			logmap.put("access_level", dbSuperuserAccessLevel);
	
			sqlMap.insert("logInfoInsert", logmap);
	
			response.sendRedirect("/baas/index.jsp");	
		}
		else {
			out.println("<script>alert('�н����尡  ����  �ʽ��ϴ�.');history.back();</script>"); 
		}
	}
%>	
	


