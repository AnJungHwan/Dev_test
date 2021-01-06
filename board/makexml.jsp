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
	
	//필요한 엘리먼트를 생성 물론 루트까지 포함하여 생성
	Element dbname = new Element(dbName);

	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	List xmlList = new ArrayList();
	xmlList = sqlMap.queryForList("boardXmlList", "tb_" + dbName);
	
	//CDATA link =new CDATA();
	String goLink = null;
	String goText = null;
	for(int i=0; i < xmlList.size(); i++){
		BoardDataObject dataobj = (BoardDataObject) xmlList.get(i);
		
		Element tmpList = new Element("list" + Integer.toString(i)); //url link를   가지는 요소
		Element title = new Element("title");
		Element list = new Element("list");
		Element date = new Element("date");
		Element link = new Element("link");
		
		
		
		//각 요소들 배치 작업
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
	
	doc.setRootElement(dbname);	//doc객체에 루트 설정!!! *********
	
	//파일로 남기기
	XMLOutputter xout=new XMLOutputter();
	Format f = xout.getFormat();		//출력 양식 객체
	f.setEncoding("euc-kr");			//XML문서 한글 처리
	f.setIndent("  ");					//들여쓰기 결
	f.setLineSeparator("\r\n");		//줄 바꿈 기능 설정
	f.setTextMode(Format.TextMode.TRIM);	//이미 XML문서에 있는 문자열 리터럴(상수)을 트림 -제거 한다.
	
	xout.setFormat(f);					//빈걸로 나온 xout를 위의 사양들을 설정!

	xout.output(doc, new FileWriter(saveFolder + fileName));
	
	
	out.println("<script>alert('메인에  반영되었습니다.');history.back();</script>"); 
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