<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.BookingDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>

<%@include  file="/baas/include/session.jsp" %>
<%
	request.setCharacterEncoding("euc-kr");	
	String division_name  = request.getParameter("division_name");
	String start_year  = request.getParameter("start_year");
	String start_month = request.getParameter("start_month");
	String end_year = request.getParameter("end_year");
	String end_month = request.getParameter("end_month");
	if  (start_month.length() == 1){
		start_month  = "0" + start_month;
	}
	if  (end_month.length() == 1){
		end_month  = "0" + end_month;
	}
	String  start_date  = start_year  + "-" + start_month + "-01";
	String  end_date  = end_year  + "-" + end_month + "-31";
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	AclDataObject aclobj = new AclDataObject();
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", "booking");
	aclmap.put("accessCode", sessionSuperuserDivisionCode);
	aclobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	isAccess  = aclobj.getIs_access();
	if (isAccess==0){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}
	response.setHeader("Content-Disposition", "attachment; filename=booking.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 
	response.setContentType("application/vnd.ms-excel");
	Map  excelmap  = new  HashMap();
	excelmap.put("division_name", division_name);
	excelmap.put("start_date", start_date);
	excelmap.put("end_date", end_date);
	List excelList = new ArrayList();	
	excelList = sqlMap.queryForList("bookingExcelList", excelmap);
	out.println("��ü��" + "\t" + "°��" + "\t" + "����" + "\t"+ "�ð�" + "\t" +"����" + "\t"+"���" + "\t"+"ȸ�强��" + "\t"+"ȸ��ID" + "\t"+	"ȸ��HP" + "\t"+"�ѹ�����" + "\t"+"�ѹ�ID" + "\t"+"�ѹ�HP"+"\t"+"�����ڼ���" + "\t"+"������ID" + "\t"+"������HP" + "\t"+"���ܰ�" + "\t"+"������" + "\t"+	"�����");
	for(int i=0; i < excelList.size(); i++){
		BookingDataObject obj = (BookingDataObject) excelList.get(i);
		out.println(obj.getGroup_name() + "\t" + obj.getChoice_date1() + "\t" + obj.getChoice_date2() + "\t"+obj.getChoice_date3() + "\t" +obj.getOrder_team() + "\t"+obj.getOrder_cnt() + "\t"+obj.getCaptain_name() + "\t"+obj.getCaptain_id() + "\t"+	obj.getCaptain_hp() + "\t"+obj.getManager_name() + "\t"+obj.getManager_id() + "\t"+	obj.getManager_hp() + "\t"+obj.getOrder_name() + "\t"+obj.getOrder_id() + "\t"+obj.getOrder_hp() + "\t"+obj.getCustomer_tran() + "\t"+obj.getWrite_date() + "\t"+	obj.getDivision_name());
	}
%>