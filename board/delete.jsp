<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@page import="org.jdom.output.Format"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.*" %>


<%@include  file="/baas/include/session.jsp" %>

<% 
	request.setCharacterEncoding("euc-kr");
	
	String dbName = request.getParameter("db");
	String pageNumber = request.getParameter("page");
	String docNumber = request.getParameter("doc");
	String divisionCode = request.getParameter("div");
	String accessCode = request.getParameter("code");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();

	AclDataObject acldataobj = new AclDataObject();
	
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", dbName);
	aclmap.put("accessCode", accessCode );

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	//isAccess  = acldataobj.getIs_access();
	isAccess = 1;

	if (isAccess==0){
		out.println("<script>alert('권한이  없습니다.');history.back();</script>");
		return;
	}

	Map fmap = new HashMap();
	fmap.put("tableName","tb_" + dbName);
	fmap.put("docNumber",docNumber);
	String attach_filename   = (String)sqlMap.queryForObject("boardFilename", fmap);
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	
	String  savedir  = uploaddir + dbName +"/";
	
	if (attach_filename != null){
		File  deletefile  = new  File(savedir  + attach_filename);
		out.println(savedir  + attach_filename);
		deletefile.delete();
		
		%>
		<%
			String dFile_name = attach_filename;
			String dSavePath = savedir;
			
			//System.out.println("dFile_name :: " + dFile_name);
			//System.out.println("dSavePath :: " + dSavePath);
		%>
		<%@include file="/comm/ftptrans2.jsp" %>
		<%	
		
	}
	
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("docNumber",docNumber);
	
	sqlMap.delete("boardDelete", map);
	
	String  subXMLFileName = null;
	if (divisionCode.equals("TL")){
		subXMLFileName = "ty_" + dbName +".xml" ;
	}
	else if(divisionCode.equals("PC")){
		subXMLFileName = "pinecreek_" + dbName +".xml" ;
	}
	else if(divisionCode.equals("PV")){
		subXMLFileName = "pinevalley_" + dbName +".xml" ;
	}
	else if(divisionCode.equals("WP")){
		subXMLFileName = "westpine_" + dbName +".xml" ;
	}
	else if(divisionCode.equals("NC")){
		subXMLFileName = "f_b_" + dbName +".xml" ;
	}
	//XML 생성
	StringUtility strobj = new StringUtility();
	if (dbName.equals("notice") || dbName.equals("event")) {
				
		// 메인용  XML
		String  saveFolder = null;
		String  mainXMLFileName  = dbName +".xml";
				
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

		List xmlList = new ArrayList();
		xmlList = sqlMap.queryForList("boardXmlMainList", "tb_" + dbName);
				
		String goLink = null;
		String goTitle = null;		
		for(int i=0; i < xmlList.size(); i++){
			BoardDataObject dataobj = (BoardDataObject) xmlList.get(i);
				
			Element tmpList = new Element("list" + Integer.toString(i)); //url link를   가지는 요소
			Element etitle = new Element("title");
			Element elist = new Element("list");
			Element edate = new Element("date");
			Element elink = new Element("link");
					
					
					
			//각 요소들 배치 작업
			dbname.addContent( tmpList);
			tmpList.addContent(etitle);
			tmpList.addContent(elist);
			tmpList.addContent(edate);
			tmpList.addContent(elink);
			goTitle = strobj.longToShortString(dataobj.getTitle(), 22);		
			goLink = "/08_club/board_redirect.jsp?uri=" + dbName + "/" + dataobj.getDivision_code()  + "/" + dataobj.getSeq_no();
					
			etitle.setText("[" + dataobj.getDivision_name() + "]");
			elist.setText(goTitle);
			edate.setText(dataobj.getWrite_date());
			elink.setContent(new CDATA(goLink));
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

		xout.output(doc, new FileWriter(saveFolder + mainXMLFileName));
				
				
		// 서브용  XML
			
		if( divisionCode.equals("PC") || divisionCode.equals("PV") || divisionCode.equals("WP") || divisionCode.equals("NC") ) {
					
			Document sub_doc = new Document();
					
			//필요한 엘리먼트를 생성 물론 루트까지 포함하여 생성
			Element sub_dbname = new Element(dbName);

			Map xmlmap = new HashMap();
			xmlmap.put("tableName","tb_" + dbName);
			xmlmap.put("division_code", divisionCode);
					
			List sub_xmlList = new ArrayList();
			xmlList = sqlMap.queryForList("boardXmlSubList", xmlmap);
					
			String sub_goLink = null;
			String sub_goTitle = null;		
			for(int i=0; i < xmlList.size(); i++){
				BoardDataObject dataobj = (BoardDataObject) xmlList.get(i);
					
				Element tmpList = new Element("list" + Integer.toString(i)); //url link를   가지는 요소
				Element sub_elist = new Element("list");
				Element sub_edate = new Element("date");
				Element sub_elink = new Element("link");
						
						
						
				//각 요소들 배치 작업
				sub_dbname.addContent( tmpList);
				tmpList.addContent(sub_elist);
				tmpList.addContent(sub_edate);
				tmpList.addContent(sub_elink);
				sub_goTitle = strobj.longToShortString(dataobj.getTitle(), 22);
				sub_goLink = "/08_club/board_redirect.jsp?uri=" + dbName + "/" + dataobj.getDivision_code()  + "/" + dataobj.getSeq_no();
				
				sub_elist.setText(sub_goTitle);
				sub_edate.setText(dataobj.getWrite_date());
				sub_elink.setContent(new CDATA(sub_goLink));
			}
					
			sub_doc.setRootElement(sub_dbname);	//doc객체에 루트 설정!!! *********
					
					//파일로 남기기
			XMLOutputter sub_xout=new XMLOutputter();
			Format sub_f = sub_xout.getFormat();		//출력 양식 객체
			sub_f.setEncoding("euc-kr");			//XML문서 한글 처리
			sub_f.setIndent("  ");					//들여쓰기 결
			sub_f.setLineSeparator("\r\n");		//줄 바꿈 기능 설정
			sub_f.setTextMode(Format.TextMode.TRIM);	//이미 XML문서에 있는 문자열 리터럴(상수)을 트림 -제거 한다.
					
			sub_xout.setFormat(sub_f);					//빈걸로 나온 xout를 위의 사양들을 설정!

			sub_xout.output(sub_doc, new FileWriter(saveFolder + subXMLFileName));
		}
	}	
	
	
	//StringUtility strobj = new StringUtility();
	//String  goURL = strobj.generateForBoardURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), divisionCode, accessCode);
	//response.sendRedirect(goURL);
%>	

