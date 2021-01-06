<%@ page language="java" contentType="text/html; charset=EUC-KR"     pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="database.datadef.SubFlashDataObject"  %>
<%@page import="org.jdom.output.Format"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.*" %>
<%
	
	request.setCharacterEncoding("euc-kr");	

	String division_code  = request.getParameter("div");
	String divisionFolder = null;
	
	if(division_code.equals("PC")){
		divisionFolder = "pinecreek";
	}
	else if(division_code.equals("PV")){
		divisionFolder = "pinevalley";
	}
	else if(division_code.equals("WP")){
		divisionFolder = "westpine";
	}
	else  if (division_code.equals("WJ")){
		divisionFolder = "woonjung";
	}
	else  if (division_code.equals("YR")){
		divisionFolder = "youngrangho";
	}
	else if(division_code.equals("NC")){
		divisionFolder = "f_b";
	}
	
	
	String  saveFolder = null;
	
	
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 saveFolder  = "/app/homepage/tyleisure/htdocs/flash/";
	}
	else {
		saveFolder = "c:/upload/flash/";
	}
	
	String  fileName  = divisionFolder + "_swf.xml";
	
	
	
	Document doc = new Document();
	
	//�ʿ��� ������Ʈ�� ���� ���� ��Ʈ���� �����Ͽ� ����
	Element mainSwf = new Element("submainSwf");

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	List xmlList = new ArrayList();
	
	Map map = new HashMap();
	
	xmlList = sqlMap.queryForList("subFlashXmlList", division_code);
	String goLink = null;
	for(int i=0; i < xmlList.size(); i++){
		SubFlashDataObject dataobj = (SubFlashDataObject) xmlList.get(i);
	
		Element swf = new Element("swf"); //url link��   ������ ���
		Element url = new Element("url");
		
		//�� ��ҵ� ��ġ �۾�
		mainSwf.addContent(swf);
		swf.addContent(url);
		
		//Text���� �����Ѵ�.
		goLink = "/upload/sub_flash/" + divisionFolder + "/" + dataobj.getFilename();
		url.setContent(new CDATA(goLink));
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

