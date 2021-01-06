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
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>");
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
	//XML ����
	StringUtility strobj = new StringUtility();
	if (dbName.equals("notice") || dbName.equals("event")) {
				
		// ���ο�  XML
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
				
				//�ʿ��� ������Ʈ�� ���� ���� ��Ʈ���� �����Ͽ� ����
		Element dbname = new Element(dbName);

		List xmlList = new ArrayList();
		xmlList = sqlMap.queryForList("boardXmlMainList", "tb_" + dbName);
				
		String goLink = null;
		String goTitle = null;		
		for(int i=0; i < xmlList.size(); i++){
			BoardDataObject dataobj = (BoardDataObject) xmlList.get(i);
				
			Element tmpList = new Element("list" + Integer.toString(i)); //url link��   ������ ���
			Element etitle = new Element("title");
			Element elist = new Element("list");
			Element edate = new Element("date");
			Element elink = new Element("link");
					
					
					
			//�� ��ҵ� ��ġ �۾�
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
				
		doc.setRootElement(dbname);	//doc��ü�� ��Ʈ ����!!! *********
				
		//���Ϸ� �����
		XMLOutputter xout=new XMLOutputter();
		Format f = xout.getFormat();		//��� ��� ��ü
		f.setEncoding("euc-kr");			//XML���� �ѱ� ó��
		f.setIndent("  ");					//�鿩���� ��
		f.setLineSeparator("\r\n");		//�� �ٲ� ��� ����
		f.setTextMode(Format.TextMode.TRIM);	//�̹� XML������ �ִ� ���ڿ� ���ͷ�(���)�� Ʈ�� -���� �Ѵ�.
				
		xout.setFormat(f);					//��ɷ� ���� xout�� ���� ������ ����!

		xout.output(doc, new FileWriter(saveFolder + mainXMLFileName));
				
				
		// �����  XML
			
		if( divisionCode.equals("PC") || divisionCode.equals("PV") || divisionCode.equals("WP") || divisionCode.equals("NC") ) {
					
			Document sub_doc = new Document();
					
			//�ʿ��� ������Ʈ�� ���� ���� ��Ʈ���� �����Ͽ� ����
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
					
				Element tmpList = new Element("list" + Integer.toString(i)); //url link��   ������ ���
				Element sub_elist = new Element("list");
				Element sub_edate = new Element("date");
				Element sub_elink = new Element("link");
						
						
						
				//�� ��ҵ� ��ġ �۾�
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
					
			sub_doc.setRootElement(sub_dbname);	//doc��ü�� ��Ʈ ����!!! *********
					
					//���Ϸ� �����
			XMLOutputter sub_xout=new XMLOutputter();
			Format sub_f = sub_xout.getFormat();		//��� ��� ��ü
			sub_f.setEncoding("euc-kr");			//XML���� �ѱ� ó��
			sub_f.setIndent("  ");					//�鿩���� ��
			sub_f.setLineSeparator("\r\n");		//�� �ٲ� ��� ����
			sub_f.setTextMode(Format.TextMode.TRIM);	//�̹� XML������ �ִ� ���ڿ� ���ͷ�(���)�� Ʈ�� -���� �Ѵ�.
					
			sub_xout.setFormat(sub_f);					//��ɷ� ���� xout�� ���� ������ ����!

			sub_xout.output(sub_doc, new FileWriter(saveFolder + subXMLFileName));
		}
	}	
	
	
	//StringUtility strobj = new StringUtility();
	//String  goURL = strobj.generateForBoardURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), divisionCode, accessCode);
	//response.sendRedirect(goURL);
%>	
