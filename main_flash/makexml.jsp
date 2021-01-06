<%@ page language="java" contentType="text/html; charset=EUC-KR"     pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="database.datadef.MainFlashDataObject"  %>
<%@page import="org.jdom.output.Format"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.*" %>
<%
	String  saveFolder = null;
	String  fileName  = "swf.xml";
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 saveFolder  = "/app/homepage/tyleisure/htdocs/flash/";
	}
	else {
		saveFolder = "c:/upload/flash/";
	}
	
	Document doc = new Document();
	
	//필요한 엘리먼트를 생성 물론 루트까지 포함하여 생성
	Element mainSwf = new Element("mainSwf");

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	List xmlList = new ArrayList();
	xmlList = sqlMap.queryForList("mainFlashXmlList");
	
	for(int i=0; i < xmlList.size(); i++){
		MainFlashDataObject dataobj = (MainFlashDataObject) xmlList.get(i);
	
		Element swf = new Element("swf"); //url link를   가지는 요소
		Element url = new Element("url");
		Element link = new Element("link");	
		
		//각 요소들 배치 작업
		mainSwf.addContent(swf);
		swf.addContent(url);
		swf.addContent(link);
		
		//Text값을 설정한다.
		url.setText("/upload/main_flash/" + dataobj.getFilename());
		link.setText("http://www.tyleisure.co.kr");
	}
	
	doc.setRootElement(mainSwf);	//doc객체에 루트 설정!!! *********
	
	//파일로 남기기
	XMLOutputter xout=new XMLOutputter();
	Format f = xout.getFormat();		//출력 양식 객체
	f.setEncoding("euc-kr");			//XML문서 한글 처리
	f.setIndent("  ");					//들여쓰기 결
	f.setLineSeparator("\r\n");		//줄 바꿈 기능 설정
	f.setTextMode(Format.TextMode.TRIM);	//이미 XML문서에 있는 문자열 리터럴(상수)을 트림 -제거 한다.
	
	xout.setFormat(f);					//빈걸로 나온 xout를 위의 사양들을 설정!

	xout.output(doc, new FileWriter(saveFolder + fileName));
	
	
	out.println("<script>alert('생성  되었습니다.');history.back();</script>"); 
%>

