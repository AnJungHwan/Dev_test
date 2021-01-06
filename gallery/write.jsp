<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="database.datadef.GalleryStorageDataObject"  %>
<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>
<%@ page import="common.utility.StringUtility"  %>
<%@ page import="common.utility.CreateThumbnail"  %>
<%@include  file="/baas/include/session.jsp" %>
<%

	request.setCharacterEncoding("euc-kr");	
	
	String title  = request.getParameter("title");
	String  division_name = request.getParameter("division_name");
	String  user_name = request.getParameter("user_name");
	String  user_id = request.getParameter("user_id");
	
	String  globalMenu = request.getParameter("global_menu");
	String  localMenu = request.getParameter("local_menu");
	String  dbName = request.getParameter("db");
	String  docNumber = request.getParameter("doc");
	String  pageNumber = request.getParameter("page");
	String  accessCode = request.getParameter("code");
	
	
	String  filename =null;
	String  division_code = null;

	if(division_name.equals("파인크리크")){
		division_code="PC";
	}
	else if(division_name.equals("파인밸리")){
		division_code="PV";
	}
	else if(division_name.equals("웨스트파인")){
		division_code="WP";
	}
	else if(division_name.equals("파인크리크(전경)")){
		division_code="C0";
	}
	else if(division_name.equals("파인크리크(봄)")){
		division_code="C1";
	}
	else if(division_name.equals("파인크리크(여름)")){
		division_code="C2";
	}
	else if(division_name.equals("파인크리크(가을)")){
		division_code="C3";
	}
	else if(division_name.equals("파인크리크(겨울)")){
		division_code="C4";
	}
	else if(division_name.equals("파인크리크(연단체대항전)")){
		division_code="C5";
	}
	else if(division_name.equals("파인크리크(기타행사)")){
		division_code="C9";
	}
	else if(division_name.equals("파인밸리(전경)")){
		division_code="V0";
	}
	else if(division_name.equals("파인밸리(봄)")){
		division_code="V1";
	}
	else if(division_name.equals("파인밸리(여름)")){
		division_code="V2";
	}
	else if(division_name.equals("파인밸리(가을)")){
		division_code="V3";
	}
	else if(division_name.equals("파인밸리(겨울)")){
		division_code="V4";
	}
	else if(division_name.equals("파인밸리(기타행사)")){
		division_code="V9";
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
		out.println("<script>alert('권한이  없습니다.');history.back();</script>"); 
		return;
	}
	
	// 현재  날짜와  시간, 아이피 어드레스를 구함
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");

	java.util.Date date = new java.util.Date();
	String currentDate = dateFormatter.format(date);
	String currentTime = timeFormatter.format(date);
	
	String  gallery_code  = currentDate.replaceAll("-", "") + currentTime.replaceAll(":","");
	
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
	
	String  savedir  = uploaddir + dbName +"_storage/";
		
	String originalFile  = null;
	String  thumbFile  = null;
	int  filecount  = 0;
	String  gallery_filename=null;
	makeDir(savedir);
	
	Map map = new HashMap();
	
	if(alist != null){
	
		ArrayList filenameList = new ArrayList();
		ArrayList filenameList2 = new ArrayList();

		Object[][] objarr = (Object[][])alist.toArray(new Object[alist.size()][3]);
		
		for(int i=0;objarr!=null&&i<objarr.length;i++){

			File file = new File(savedir + objarr[i][1]);	
																				
			file = policy.rename(file);									//최종저장될 폴더에 이미 같은 이름이 있으면 자동으로 끝에 숫자를 붙임.
			copyFileAbs((File)objarr[i][0],file);						//최종으로 저장폴더에 파일을 복사함.
			((File)objarr[i][0]).delete();								//임시폴더에서 업로드 파일을 삭제함.
			
			filename  =  file.getName() ;
			
			filenameList.add(filename);
			
			if (i==0){
				gallery_filename = filename; 							// 갤러리 대표 이미지를 첫번째 사진으로 한다.
			}
			//out.println(filename);
			
			if ( filename.indexOf(".avi") > 0 || filename.indexOf(".avi") > 0 || filename.indexOf(".wmv") > 0 ){
			}
			else {
				// 썸네일 및 파일 사이즈 조정
				originalFile  = savedir  + filename;
				thumbFile  = savedir  + "thumb_" + filename;
				
				CreateThumbnail thumb  = new  CreateThumbnail();
				//thumb.convert(originalFile,originalFile, 640);  //2019.10.23
				//thumb.convert(originalFile,originalFile, 1024);
				thumb.convert(originalFile,thumbFile, 200);			
				
				filenameList2.add("thumb_" + filename);	
			}
			
			
			filecount  = i+1;
			
			// 데이터베이스 입력
			map.put("tableName","tb_gallery_storage");
			map.put("seqTableName", "tb_gallery_storage_seq");
			
			map.put("user_id", user_id);
			map.put("user_name", user_name);
			map.put("title", title);
			map.put("gallery_code", gallery_code);
			map.put("subject", title);
			map.put("hitcount", "1");
			map.put("write_date", currentDate);
			map.put("write_time", currentTime);
			map.put("filename", filename);
			map.put("division_code", division_code);
			map.put("division_name", division_name);
			map.put("filecount", Integer.toString(filecount));
			sqlMap.insert("galleryStorageInsert", map);
			map.clear();
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
			ArrayList tFile_nameList = filenameList;
			ArrayList tFile_nameList2 = filenameList2;
			String tSavePath = savedir;
			
			//System.out.println("tFile_name :: " + tFile_nameList.get(0));
			//System.out.println("tFile_name2 :: " + tFile_nameList.get(1));
			//System.out.println("tFile_name :: " + tFile_nameList2.get(0));
			//System.out.println("tFile_name2 :: " + tFile_nameList2.get(1));
			//System.out.println("tSavePath :: " + tSavePath);
		%>
		<%@include file="/comm/ftptrans5.jsp" %>
		<%
	}
	map.put("tableName","tb_gallery");
	map.put("seqTableName", "tb_gallery_seq");
	
	map.put("user_id", user_id);
	map.put("user_name", user_name);
	map.put("title", title);
	map.put("gallery_code", gallery_code);
	map.put("totalcount", Integer.toString(filecount));
	map.put("write_date", currentDate);
	map.put("write_time", currentTime);
	map.put("gallery_filename", gallery_filename);
	map.put("division_code", division_code);
	map.put("division_name", division_name);
	
	sqlMap.insert("galleryInsert", map);
	
	
	
	StringUtility strobj = new StringUtility();
	String  goURL = strobj.generateForBoardURL(Integer.parseInt(globalMenu), Integer.parseInt(localMenu), dbName, "viewlist", Integer.parseInt(pageNumber), division_code, accessCode);
	response.sendRedirect(goURL);
%>
<%!
public void makeDir(String savedir) throws Exception{
	java.io.File dir=new java.io.File(savedir);
	if(!dir.exists()){	dir.mkdirs();	}
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