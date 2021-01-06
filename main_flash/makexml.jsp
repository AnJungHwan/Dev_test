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
	
	//�ʿ��� ������Ʈ�� ���� ���� ��Ʈ���� �����Ͽ� ����
	Element mainSwf = new Element("mainSwf");

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	List xmlList = new ArrayList();
	xmlList = sqlMap.queryForList("mainFlashXmlList");
	
	for(int i=0; i < xmlList.size(); i++){
		MainFlashDataObject dataobj = (MainFlashDataObject) xmlList.get(i);
	
		Element swf = new Element("swf"); //url link��   ������ ���
		Element url = new Element("url");
		Element link = new Element("link");	
		
		//�� ��ҵ� ��ġ �۾�
		mainSwf.addContent(swf);
		swf.addContent(url);
		swf.addContent(link);
		
		//Text���� �����Ѵ�.
		url.setText("/upload/main_flash/" + dataobj.getFilename());
		link.setText("http://www.tyleisure.co.kr");
	}
	
	doc.setRootElement(mainSwf);	//doc��ü�� ��Ʈ ����!!! *********
	
	//���Ϸ� �����
	XMLOutputter xout=new XMLOutputter();
	Format f = xout.getFormat();		//��� ��� ��ü
	f.setEncoding("euc-kr");			//XML���� �ѱ� ó��
	f.setIndent("  ");					//�鿩���� ��
	f.setLineSeparator("\r\n");		//�� �ٲ� ��� ����
	f.setTextMode(Format.TextMode.TRIM);	//�̹� XML������ �ִ� ���ڿ� ���ͷ�(���)�� Ʈ�� -���� �Ѵ�.
	
	xout.setFormat(f);					//��ɷ� ���� xout�� ���� ������ ����!

	xout.output(doc, new FileWriter(saveFolder + fileName));
	
	
	out.println("<script>alert('����  �Ǿ����ϴ�.');history.back();</script>"); 
%>

