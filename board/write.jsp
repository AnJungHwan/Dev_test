<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.BoardDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@page import="org.jdom.output.Format"%>
<%@page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.*" %>


<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String title  = request.getParameter("title");
	String content  = request.getParameter("content");
	String  division_name = request.getParameter("division_name");
	String  is_view = request.getParameter("is_view");
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");

	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	String  accessCode = request.getParameter("code");
	
	
	String  attach_filename =null;
	String  division_code = null;
	String  subXMLFileName = null;
	
	if (division_name.equals("���緹��")){
		division_code="TL";
		subXMLFileName = "ty_" + dbName +".xml" ;
	}
	else if(division_name.equals("����ũ��ũ")){
		division_code="PC";
		subXMLFileName = "pinecreek_" + dbName +".xml" ;
	}
	else if(division_name.equals("���ι븮")){
		division_code="PV";
		subXMLFileName = "pinevalley_" + dbName +".xml" ;
	}
	else if(division_name.equals("����Ʈ����")){
		division_code="WP";
		subXMLFileName = "westpine_" + dbName +".xml" ;
	}
	//else if(division_name.equals("F&B")){
	else if(division_name.equals("���ȸ���Խ���")){
		division_code="NC";
		subXMLFileName = "f_b_" + dbName +".xml" ;
	}
	
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	 
	AclDataObject acldataobj = new AclDataObject();
	int isAccess = 0;
	Map aclmap = new HashMap();
	aclmap.put("superuserID", sessionSuperuserID);
	aclmap.put("dbName", dbName);
	aclmap.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", aclmap);
	//isAccess  = acldataobj.getIs_access();
	isAccess = 1;
	
	if (isAccess==0){
		out.println("<script>alert('������  �����ϴ�.');history.back();</script>"); 
		return;
	}
	
	DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
	ArrayList alist = (ArrayList)application.getAttribute(session.getId());
	
	String uploaddir = null;
	//if (application.getServerInfo().matches(".*Sun.*")){
	if (application.getServerInfo().matches(".*WebLogic.*")){
		 uploaddir  = "/app/homepage/tyleisure/htdocs/upload/";
	}
	else {
		uploaddir = "c:/upload/";
	}
	
	String  savedir  = uploaddir + dbName +"/";

	makeDir(savedir);
	if(alist != null){
		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][3]);
		for(int i=0;objarr!=null&&i<objarr.length;i++){
			
			File file = new File(savedir + objarr[i][1]);	
			file = policy.rename(file);
			copyFileAbs((File)objarr[i][0],file);

			((File)objarr[i][0]).delete();
			attach_filename  =  file.getName() ;
		}	
		File trashfile  = new  File(uploaddir);
		File[] trashfiles  = trashfile.listFiles();
		if  (trashfiles  != null) {
			for (int  i=0; i< trashfiles.length; i++){
				if  (!trashfiles[i].isDirectory()){
					trashfiles[i].delete();
				}
			}
		}	
		application.removeAttribute(session.getId());
		
		%>
		<%
			String tFile_name = attach_filename;
			String tSavePath = savedir;
			
			//System.out.println("tFile_name :: " + tFile_name);
			//System.out.println("tSavePath :: " + tSavePath);
		%>
		<%@include file="/comm/ftptrans.jsp" %>
		<%
	}

	// ����  ��¥��  �ð�, ������ ��巹���� ����
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

	java.util.Date date = new java.util.Date();
	String currentDate = dateFormatter.format(date);
	String currentTime = timeFormatter.format(date);
	
	Map map = new HashMap();
	map.put("tableName","tb_" + dbName);
	map.put("seqTableName", "tb_"+ dbName +"_seq");
	
	map.put("user_id", user_id);
	map.put("user_name", user_name);
	map.put("title", title);
	map.put("content", content);
	map.put("hitcount", "1");
	map.put("write_date", currentDate);
	map.put("write_time", currentTime);
	map.put("division_name", division_name);
	map.put("attach_filename", attach_filename);
	map.put("division_code", division_code);
	map.put("is_view", is_view);
	
	sqlMap.insert("boardInsert", map);

	StringUtility strobj = new StringUtility();
	//XML ����
	
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
		
		if( division_code.equals("PC") || division_code.equals("PV") || division_code.equals("WP") || division_code.equals("NC") ) {
			
			Document sub_doc = new Document();
			
			//�ʿ��� ������Ʈ�� ���� ���� ��Ʈ���� �����Ͽ� ����
			Element sub_dbname = new Element(dbName);

			Map xmlmap = new HashMap();
			xmlmap.put("tableName","tb_" + dbName);
			xmlmap.put("division_code", division_code);
			
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
	
	
	String  goURL = strobj.generateForBoardURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), division_code, accessCode);
	response.sendRedirect(goURL);
%>
<%!
public void makeDir(String savedir) throws Exception{
	java.io.File dir=new java.io.File(savedir);
	if(!dir.exists()){	dir.mkdirs();	}
}
public static String ko(String s){
	if(s==null)return "";
	try{
		s = new String(s.getBytes("8859_1"),"euc-kr");
	}catch(Exception e){}
	return s;
}
public void copyFileAbs(java.io.File src, java.io.File dst) throws java.io.IOException {    	
	java.io.InputStream in = new java.io.FileInputStream(src);
	java.io.OutputStream out = new java.io.FileOutputStream(dst);
	
	byte[] buf = new byte[1024];
	int len;
	while ((len = in.read(buf)) > 0) {
		out.write(buf, 0, len);
	}
	in.close();
	out.close();
}
%>