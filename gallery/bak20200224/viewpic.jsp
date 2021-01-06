<%@ page language="java" contentType="text/html; charset=EUC-KR"   pageEncoding="EUC-KR"%>

<%@ page import="database.datadef.GalleryStorageDataObject"  %>
<%@ page import="database.datadef.AclDataObject"  %>
<%@ page import="common.utility.StringUtility"  %>


<%@ page import="database.sqlmap.sqlMapClientManager"  %>
<%@ page import="com.ibatis.sqlmap.client.*"  %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@include  file="/baas/include/session.jsp" %>
<%@include  file="/baas/include/value.jsp" %>

<script type="text/javascript" src="/baas/js/jquery-1.6.2.min.js"></script>
<script type="text/javascript" src="/baas/js/mousewheel.js"></script>
<script type="text/javascript" src="/baas/js/fancybox.js"></script>
<link rel="stylesheet" type="text/css" href="/baas/css/fancybox.css" media="screen" />

<script type="text/javascript">
$(document).ready(function() {
	var word = $('#word');
	var	key = $('#key');
	
	$("a[rel=example_group]").fancybox({
	'transitionIn'		: 'none',
	'transitionOut'		: 'none',
	'titlePosition' 	: 'over',
	'titleFormat'		: function(title, currentArray, currentIndex, currentOpts) {
		return '<span id="fancybox-title-over">Image ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
		}
	});
	
	$.extend({
		goSearch : function(global, local, db, page, div, code) {
			var  searchWord;
			var  searchKey;
			if  (word.val() ==''){
				alert("검색어를 입력해주세요");
				word.focus();
				return;
			}
			else{
				searchWord  = word.val();
				searchKey  = key.val();
				document.location = "/baas/index.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&cmd=searchlist" +"&page=" + page + "&div=" + div + "&code="+code+"&word="+searchWord+"&key="+searchKey;		
			}	 
		}
	});
	$.extend({
		subjectErase : function(global, local, db, page, div, doc, id, code) {
			if(!confirm("정말로 삭제하겠습니까?")){
				return;
			}
			else{
				document.location = "/baas/gallery/erase.jsp?global_menu=" + global + "&local_menu=" + local + "&db=" + db + "&page=" + page + "&div=" + div + "&doc=" +doc +"&code="+code+"&id="+id;
			}
		}
	});
	
	$.extend({
		subjectUpdate : function(doc, subject) {
			var s= document.getElementsByName(subject)[0].value;
			
			var f = document.createElement("form"); // form 엘리멘트 생성
			f.setAttribute("method","post"); // method 속성 설정
			f.setAttribute("action","/baas/gallery/update.jsp"); // action 속성 설정
			document.body.appendChild(f); // 현재 페이지에 form 엘리멘트 추가

			 var i = document.createElement("input"); // input 엘리멘트 생성
			 i.setAttribute("type","hidden"); // type 속성 설정
			 i.setAttribute("name","doc"); // name 속성 설정
			 i.setAttribute("value",doc); // value 속성 설정
			 f.appendChild(i); // form 엘리멘트에 input 엘리멘트 추가

			 var i = document.createElement("input"); // input 엘리멘트 생성
			 i.setAttribute("type","hidden"); // type 속성 설정
			 i.setAttribute("name","subject"); // name 속성 설정
			 i.setAttribute("value",s); // value 속성 설정
			 f.appendChild(i); // form 엘리멘트에 input 엘리멘트 추가
			 
			 f.submit(); // 전송 
		}
	});
});

</script>
<%
	request.setCharacterEncoding("euc-kr");
	
	SqlMapClient sqlMap = sqlMapClientManager.getSqlMapInstance();
	int isAccess = 0;
	int pageSize = 8;
	int currentPage = pageNumber;
	int startRow = currentPage * pageSize - pageSize +1;
	int endRow = currentPage * pageSize;
	int totalCount = 0;
	int number = 0;
	
	AclDataObject acldataobj = new AclDataObject();
	
	if (accessCode.equals("AL") && sessionSuperuserAccessLevel.equals("SUPER")){
		accessCode = "PC"; //  슈퍼관리자가  전체보기에서 글쓰기로   들어왔으면  액세스  코드를  파인크리크로  세팅한다.
	}
	
	Map map = new HashMap();
	map.put("superuserID", sessionSuperuserID);
	map.put("dbName", dbName);
	map.put("accessCode", accessCode);

	acldataobj   = (AclDataObject)sqlMap.queryForObject("aclUserList", map);
	isAccess  = acldataobj.getIs_access();
	
	
	StringUtility strobj = new StringUtility();
	String goURL=null;
	String goPic=null;
	
	String tableName = "tb_" + dbName;
	String  gallery_code  = request.getParameter("id");
			
	Map countmap = new HashMap();
	
	countmap.put("gallery_code", gallery_code);
	
	totalCount = ((Integer)sqlMap.queryForObject("getTotalGalleryCount", countmap)).intValue();
%>

<table class="normal">	
<tr>
	<td style="text-align:left;" >
	총  <%=totalCount%>개의  사진이  있습니다. 
	</td>
	<td style="text-align:right;" >
	<%
		goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewlist", 1, divisionCode, divisionCode);
	%>
	<span class="button medium icon"><span class="add"></span><a href="<%=goURL%>">목록</a></span>	
	
	</td>
</tr>
</table>
 <table class="list">	

<%
	Map pagemap = new HashMap();
		
	pagemap.put("gallery_code", gallery_code);
	pagemap.put("pagingSize", Integer.toString(endRow));
	pagemap.put("startRow", Integer.toString(startRow));
	pagemap.put("endRow", Integer.toString(endRow));
		
	List dbList = new ArrayList();
		
	dbList = sqlMap.queryForList("galleryStoragePagingList", pagemap);
	int virtualNumber =0;
	for(int i=0; i < dbList.size(); i++){
		GalleryStorageDataObject dataobj = (GalleryStorageDataObject) dbList.get(i);
		goURL = strobj.generateForBoardURL(globalMenu, localMenu, dbName, "viewpic", pageNumber, dataobj.getSeq_no(), divisionCode, dataobj.getDivision_code());
		virtualNumber = totalCount - (pageSize * (pageNumber-1) + i);
		
		String fileName = dataobj.getFilename();
%>
	<% if (i ==0) { %>
	
	<tr>
		<td colspan=4 style="color:#000000; font-weight:bold; background-color: #efefef;">
		<%=dataobj.getTitle() %>
		</td> 
	</tr>
	<tr>
	<% } %>
		<td style="width:212px">
		
		<% if ( fileName.indexOf(".mp4") < 0 && fileName.indexOf(".avi")  < 0 && fileName.indexOf(".wmv")  < 0 ) { %>
		<a  rel="example_group" href="/upload/<%=dbName%>_storage/<%= dataobj.getFilename() %>"  title="<%= dataobj.getSubject() %>">
		<img  src="/upload/<%=dbName%>_storage/thumb_<%= dataobj.getFilename() %>" style="border-width:0"></a><br>
		<% } else { %>
		<embed src="/upload/<%=dbName%>_storage/<%= dataobj.getFilename() %>" style="border-width:0" type="application/x-mplayer2" width="200px" height="200px" autostart="false"></embed><br>
		<% } %>
			
			<% if (isAccess==1) { %>
			<input  type="text" value="<%= dataobj.getSubject() %>" class="thin" style="width: 195px" id="subject<%=dataobj.getFilecount()%>"></br>
			<span class="btn white"><input  type="button" value="편집" onClick="$.subjectUpdate('<%=dataobj.getSeq_no()%>', 'subject<%=dataobj.getFilecount()%>')"></span>
			<span class="btn red"><input  type="button" value="삭제" onClick="$.subjectErase('<%=globalMenu %>','<%=localMenu %>','<%= dbName%>','<%=pageNumber %>','<%=divisionCode %>','<%=dataobj.getSeq_no()%>','<%=dataobj.getGallery_code()%>','<%=accessCode%>')"></span>
			<% 
				} 
				else {
					out.println(dataobj.getSubject()); 
				} 
			 %><br>
			조회수 : <%= dataobj.getHitcount() %></br>
		</td>
		<%
			if ( i % 4 == 3) {
				out.println("</tr><tr>");
			}
		}
	%>
</tr>        
</table><br>
<table>
<tr>
	<td>	
	<%
	
	if(totalCount >0) {
		int pageCount = totalCount / pageSize + (totalCount % pageSize == 0 ? 0 : 1);
		
		int startPage = (int)(currentPage/10)*10+1;
		int pageBlock = 10;
		int endPage = startPage + pageBlock-1;
		
		if(endPage > pageCount) endPage = pageCount;
		
		 
		
		if(startPage > 10) {
			int prevPage = startPage - 10;
			goURL = strobj.generateForGalleryURL(globalMenu, localMenu, dbName, "viewpic", prevPage, gallery_code, divisionCode, accessCode);
		%>
			<a  href="<%=goURL %>">[이전]</a>
		<%
		}
		for(int i = startPage ; i <= endPage ; i++) {
			if (i==currentPage){
				out.println("[<b>"+ i +"</b>]");
			}
			else{
				goURL = strobj.generateForGalleryURL(globalMenu, localMenu, dbName, "viewpic", i, gallery_code, divisionCode, accessCode);
		%>	
			<a  href="<%=goURL %>"><%=i %></a>
		<%	
			}
		}
		if (endPage < pageCount) {
			int nextPage = startPage + 10;
			goURL = strobj.generateForGalleryURL(globalMenu, localMenu, dbName, "viewpic", nextPage, gallery_code, divisionCode, accessCode);
		%>	
			<a  href="<%=goURL %>">[다음]</a>
		<%	
		}
	}
	%>
		
</td></tr>
</table><br><br>
		
<!--
<div>
 
<form  name="searchForm"> 
<input  type="text" class="thin" id="word">
<select id="key">
<option value="title">제목</option>
<option  value="content">내용</option>
</select>
<input  type="button" value="검색 "  onClick="JavaScript:$.goSearch('<%=globalMenu%>', '<%=localMenu%>', '<%=dbName%>', '<%=pageNumber%>', '<%=divisionCode%>', '<%=accessCode%>');">
</form>
</div>
 -->