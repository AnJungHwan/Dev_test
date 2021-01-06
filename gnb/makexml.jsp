<%@ page language="java" contentType="text/html; charset=EUC-KR"     pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="database.datadef.GnbDataObject"  %>
<%@page import="org.jdom.output.Format"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.*" %>
<%
	request.setCharacterEncoding("euc-kr");	
	String  dbName = "gnb";
	
	String  saveFolder = null;
	String  fileName  =  "menu.xml";
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 saveFolder  = "/app/homepage/tyleisure/htdocs/flash/";
	}
	else {
		saveFolder = "c:/upload/flash/";
	}
	
	

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	List xmlList = new ArrayList();
	xmlList = sqlMap.queryForList("gnbList", "tb_" + dbName);
	
	File  f  = new  File(saveFolder  + fileName);
	f.createNewFile();
	
	FileWriter fw  = new  FileWriter(saveFolder  + fileName);
	xmlList = sqlMap.queryForList("gnbList");
	
	fw.write("<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n");
	fw.write("<menu>\n");

	Map countmap = new HashMap();
	
	int smallTotalCount =0;
	int mediumTotalCount =0;
	for(int i=0; i < xmlList.size(); i++){
		GnbDataObject dataobj = (GnbDataObject) xmlList.get(i);
		
		if(dataobj.getMenu_code() == 1){
			if(i >0){
				fw.write("\t</depth1>\n");
			}
			fw.write("\t<depth1>\n");
			fw.write("\t\t<menuName link='" + dataobj.getMenu_link() +"'>" + dataobj.getMenu_name() + "</menuName>\n");
		}
		if(dataobj.getMenu_code() == 2){
			fw.write("\t\t<depth2>\n");
			fw.write("\t\t\t<menuName link='" + dataobj.getMenu_link() +"'>" + dataobj.getMenu_name() + "</menuName>\n");
			
			countmap.put("large_index", Integer.toString(dataobj.getLarge_index()));
			countmap.put("medium_index", Integer.toString(dataobj.getMedium_index()));
			
			mediumTotalCount = ((Integer)sqlMap.queryForObject("getMediumIndexTotalCount", countmap)).intValue();
			
			if (mediumTotalCount ==  1){
				fw.write("\t\t</depth2>\n");
			}		
			countmap.clear();
		}
		if(dataobj.getMenu_code() == 3){
			
			countmap.put("top_code", Integer.toString(dataobj.getTop_code()));
			countmap.put("parent_code", Integer.toString(dataobj.getParent_code()));
			
			smallTotalCount = ((Integer)sqlMap.queryForObject("getSmallIndexTotalCount", countmap)).intValue();
			
			if(dataobj.getSmall_index() == 1){
				fw.write("\t\t\t<depth3>\n");	
			}
			fw.write("\t\t\t\t<menuName link='" + dataobj.getMenu_link() +"'>" + dataobj.getMenu_name() + "</menuName>\n");

			if(dataobj.getSmall_index() == smallTotalCount){
				fw.write("\t\t\t</depth3>\n");	
				if (mediumTotalCount >  1){
					fw.write("\t\t</depth2>\n");
				}	
			}
			countmap.clear();
			
			
		}
		
		
		
	}
	fw.write("\t</depth1>\n");
	fw.write("</menu>\n");
	fw.close(); 
	//out.println("<script>alert('생성  되었습니다.');history.back();</script>"); 
	
	
%>

