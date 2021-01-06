<%@ page language="java" contentType="text/html; charset=EUC-KR"     pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="database.datadef.BoardDataObject"  %>
<%@page import="org.jdom.output.Format"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.*" %>
<%
	request.setCharacterEncoding("euc-kr");	
	String  dbName = request.getParameter("db");
	
	String  saveFolder = null;
	String  fileName  = dbName +".xml";
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 saveFolder  = "/app/homepage/tyleisure/htdocs/flash/";
	}
	else {
		saveFolder = "c:/upload/flash/";
	}
	
	
	Document doc = new Document();
	
	//�ʿ��� ������Ʈ�� ���� ���� ��Ʈ���� �����Ͽ� ����
	Element dbname = new Element(dbName);

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	List xmlList = new ArrayList();
	xmlList = sqlMap.queryForList("boardXmlList", "tb_" + dbName);
	
	//CDATA link =new CDATA();
	String goLink = null;
	String goText = null;
	for(int i=0; i < xmlList.size(); i++){
		BoardDataObject dataobj = (BoardDataObject) xmlList.get(i);
		
		Element tmpList = new Element("list" + Integer.toString(i)); //url link��   ������ ���
		Element title = new Element("title");
		Element list = new Element("list");
		Element date = new Element("date");
		Element link = new Element("link");
		
		
		
		//�� ��ҵ� ��ġ �۾�
		dbname.addContent( tmpList);
		tmpList.addContent(title);
		tmpList.addContent(list);
		tmpList.addContent(date);
		tmpList.addContent(link);
		
		goText = getShortString(dataobj.getTitle(), 20);
		goLink = "/08_club/board_redirect.jsp?uri=" + dbName + "/" + dataobj.getDivision_code()  + "/" + dataobj.getSeq_no();
		
		title.setText("[" + dataobj.getDivision_name() + "]");
		list.setText(dataobj.getTitle());
		date.setText(dataobj.getWrite_date());
		link.setContent(new CDATA(goLink));
		//link.setText();
	}
	
	doc.setRootElement(dbname);	//doc��ü�� ��Ʈ ����!!! *********
	
	//���Ϸ� �����
	XMLOutputter xout=new XMLOutputter();
	Format f = xout.getFormat();		//��� ��� ��ü
	f.setEncoding("euc-kr");			//XML���� �ѱ� ó��
	f.setIndent("  ");					//�鿩���� ��
	f.setLineSeparator("\r\n");		//�� �ٲ� ��� ����
	f.setTextMode(Format.TextMode.TRIM);	//�̹� XML������ �ִ� ���ڿ� ���ͷ�(���)�� Ʈ�� -���� �Ѵ�.
	
	xout.setFormat(f);					//��ɷ� ���� xout�� ���� ������ ����!

	xout.output(doc, new FileWriter(saveFolder + fileName));
	
	
	out.println("<script>alert('���ο�  �ݿ��Ǿ����ϴ�.');history.back();</script>"); 
%>

<%!
public String getShortString( String orig, int  length)
 {
    byte[] byteString = orig.getBytes();

    if (byteString.length <= length)
    {
      return orig;
    }
    else
    {
      int minusByteCount = 0;
      for (int i = 0; i < length; i++)
      {
        minusByteCount += (byteString[i] < 0) ? 1 : 0;
      }

      if (minusByteCount % 2 != 0)
      {
        length--;
      }

      return new String(byteString, 0, length) + "...";
    }
  }
%> 