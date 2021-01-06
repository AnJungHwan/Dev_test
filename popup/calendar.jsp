<%@ page language="java" import="java.sql.*, java.io.*, java.util.*" %>
<%@ page contentType="text/html;charset=euc-kr" %>

<%! int year;
	int month;
	int date;
	int dayofweek;  //첫번째 날의 요일
	int days;  //그달의 날짜수
	int nowyear; //현재의 년도
	int nowmonth;  //현재의 월
	int nowdate;  //현재의 일
	String paturl = null;	//호출한 페이지로부터 url을 받아온다.
	String target = "";		//호출할 페이지의 프레임 이름
	String nowweek;  //현재의 요일
	String url="";  //링크 Url
	String stryear = null;	//문자형 년
	String strmon = null;	//문자형 월
	String strday = null;	//문자형 일
	String paradate = null;	//날짜
	String parapo = null;	//호출할 페이지의 위치
%>
<%String name = request.getParameter("name");%>

<%    
/**********          현재 년월일시를 구한다.                **********/
/**********          처음 불러올때 이값을 사용한다.          **********/
	Calendar now = Calendar.getInstance();
	year =now.get(Calendar.YEAR);
	month = now.get(Calendar.MONTH)+1;
	date = now.get(Calendar.DATE);
	dayofweek = now.get(Calendar.DAY_OF_WEEK);
	nowyear = year;
	nowmonth = month;
	nowdate = date;
	
/**********          년 월 값을 받는다.                    **********/


/**********          년 월을 변경했을때 사용하다.          **********/
	String reqyear = request.getParameter("year");
	String reqmonth = request.getParameter("month");
	String reqdate = request.getParameter("date");
	String mode = request.getParameter("mode");
	String parapo = request.getParameter("parapo");


/**********          받은 값을 mode에따라 처리를 한다.                      **********/
/**********          처음 시작하면 reqyear, reqmonth는 null 이므로          **********/
	int curyear;
	int curmonth;
	int curdate;
	int curdayofweek;

	if ( (reqyear == null || reqyear.equals("") || reqyear.equals("null")) && (reqmonth == null || reqmonth.equals("") || reqmonth.equals("null")) ){
		curyear = year;
		curmonth = month-1;
		curdate = nowdate;
		mode="no";
	}else{
		if(mode.equals("preyear")){
			curyear = Integer.parseInt(reqyear)-1;
			curmonth = Integer.parseInt(reqmonth)-1;
			curdate = Integer.parseInt(reqdate);
		}else if(mode.equals("nextyear")){
			curyear = Integer.parseInt(reqyear)+1;
			curmonth = Integer.parseInt(reqmonth)-1;
			curdate = Integer.parseInt(reqdate);
		}else if(mode.equals("premonth")){
			curyear = Integer.parseInt(reqyear);
			curmonth = Integer.parseInt(reqmonth)-2;
			curdate = Integer.parseInt(reqdate);
		}else if(mode.equals("nextmonth")){
			curyear = Integer.parseInt(reqyear);
			curmonth = Integer.parseInt(reqmonth);
			curdate = Integer.parseInt(reqdate);
		}else{
			curyear = Integer.parseInt(reqyear);
			curmonth = Integer.parseInt(reqmonth)-1;
			curdate = Integer.parseInt(reqdate);
		}
	}
	
/**********          값을 받아서 세팅을 한다.          **********/
/**********          원하는 년,월,일을 설정!          **********/
	now.set(Calendar.YEAR,curyear);	
	now.set(Calendar.MONTH,curmonth);
	now.set(Calendar.DATE,1);

	
/**********          세팅된 내용의 년,월,일을 얻어 온다.          **********/
	year =now.get(Calendar.YEAR);//년도
	month = now.get(Calendar.MONTH)+1;//월
	date = now.get(Calendar.DATE);//날짜
	int blank = now.get(Calendar.DAY_OF_WEEK);//요일

/**********          년,월,일,날짜수를 출력 한다.          **********/
	if ((nowyear == year) && (nowmonth == month)){  //현재 년,월일 같을면
		curdayofweek = now.get(Calendar.DAY_OF_WEEK);
		if(reqdate == null || reqdate.equals("") || reqdate.equals("null")){
			date= nowdate;
		}else{
			date = Integer.parseInt(reqdate);
		}
		curdayofweek = (curdayofweek+((date-1)%7))%7;
	}else{
		curdayofweek = now.get(Calendar.DAY_OF_WEEK);
		if(reqdate == null || reqdate.equals("") || reqdate.equals("null")){
			date= nowdate;
		}else{
			date = Integer.parseInt(reqdate);
		}
		curdayofweek = (curdayofweek+((date-1)%7))%7;
	}
	switch (curdayofweek){
		case	1:
				nowweek = "일";
				break;
		case	2:
				nowweek = "월";
				break;
		case	3:
				nowweek = "화";
				break;
		case	4:
				nowweek = "수";
				break;
		case	5:
				nowweek = "목";
				break;
		case	6:
				nowweek = "금";
				break;
		default:
				nowweek = "토";
				break;
	}
	switch (month){
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			days = 31; break;
		case 4:
		case 6:
		case 9:
		case 11:
			days = 30; break;
		default:
			if((year % 4 ==0) &&(year % 100 !=0 ) ||(year % 400 ==0)){
				days = 29;
			}else{
				days = 28;
			}
	}
//	out.println(days+"<br>");
%>
<html>
<head>
<script language="javascript">
	
	function selectDay(target, year, month, day)
	{
		eval('opener.formName.' + target + '.value = year + "-" + month + "-" + day');
		self.close();
	}
	
</script>
<link rel="stylesheet" type="text/css" href="/baas/css/calendar.css" />
<title>날짜선택</title>
</head>

<body bgcolor=#d4d0c8 topmargin=0 leftmargin=0 marginheight=0 marginwidth=0>
<center>

	
<form name="form1" method="post">
  <input type="hidden" name="mon" value="4">
  <input type="hidden" name="yyyy" value="102">
  <input type="hidden" name="goType">
</form>


<%

		//두자리의 월과 일을 값으로 넘겨줌
			stryear = String.valueOf(nowyear);
			strmon = String.valueOf(nowmonth);
			if(strmon.length() == 1)
				strmon = "0"+strmon;
			strday = String.valueOf(nowdate);
			if(strday.length() == 1)
				strday = "0"+strday;
			paradate = stryear+"."+strmon+"."+strday;
%>

<table  class="calendar">
<tr>
	<th align=center>
   		<a href="calendar.jsp?name=<%=name%>&mode=premonth&year=<%= year%>&month=<%= month%>&date=<%= date%>&a_url=<%= paturl %>&a_target=<%= target %>&parapo=<%= parapo %>"><<</a>
	</th>
	<th align=center colspan=5>
		<font style="font-size:13pt; color=#000000">
   		<%= year%> 년 <%= month%> 월</font>
   	</th>	
	<th align=center>
   		<a  href="calendar.jsp?name=<%=name%>&mode=nextmonth&year=<%= year%>&month=<%= month%>&date=<%= date%>&a_url=<%= paturl %>&a_target=<%= target %>&parapo=<%= parapo %>">>></a></th>
	</th>
</tr>
<th><font style="color:red"><strong>일</strong></font></th>
<th><strong>월</strong></th>
<th><strong>화</strong></th>
<th><strong>수</strong></th>
<th><strong>목</strong></th>
<th><strong>금</strong></th>
<th><font style="color:blue"><strong>토</strong></font></th>
</tr>
				
<%	
/********** 요일만큼 공백을 위해서          **********/
	int tr=0;  
	for(int i=1;i<blank;i++){%>
		<td>&nbsp;</td> <%
			tr++;
	}
/********** 날짜를 출력 한다.          **********/
	for (int j =1; j< days+1;j++){
		tr++;
		//두자리의 월과 일을 값으로 넘겨줌
			stryear = String.valueOf(year);
			strmon = String.valueOf(month);
			if(strmon.length() == 1)
				strmon = "0"+strmon;
			strday = String.valueOf(j);
			if(strday.length() == 1)
				strday = "0"+strday;
			paradate = "'"+stryear+"','"+strmon+"','"+strday+"'";

			// tr=1..7 일요일..토요일까지를 나타낸다.
			if ((nowyear == year) && (nowmonth == month) && (nowdate == j)){ %>  
                <td style="color:#000000; background-color: #efefef">
    			  <a  href=javascript:selectDay(<%="'"+name+"'"%>,<%= paradate%>)> <%= j%></a><br>
			    </td> <%
			}else if( date == j){ %>
                <td>
    			  <a  href=javascript:selectDay(<%="'"+name+"'"%>,<%= paradate%>)> 
				  <font style="font-size:10pt;" color="orange" ><%= j%></font> </a><br>
			    </td> <%
			}else if( tr == 7){ %>
                <td>
    			  <a  href=javascript:selectDay(<%="'"+name+"'"%>,<%= paradate%>)> 
				  <font style="font-size:8pt;" color="blue" ><%= j%></font> </a><br>
			    </td> <%
			}else if( tr == 1){ %>
                <td>
    			  <a  href=javascript:selectDay(<%="'"+name+"'"%>,<%= paradate%>)> 
				  <font style="font-size:8pt;" color="red" ><%= j%></font> </a><br>
			    </td> <%
			}else{ %>
                <td>
    			  <a  href=javascript:selectDay(<%="'"+name+"'"%>,<%= paradate%>)>
				  <font style="font-size:8pt;" color="navy" ><%= j%> </font></a><br>
			    </td> <%
			}
			if( tr == 7){ 
				out.println("</tr>");
				if(j != days){
					out.println("<tr>");
				}
				tr=0;
			}		
	}
/********** 날짜를 출력하고 나머지는 빈공백          **********/
	while(tr > 0 && tr <7){%>
		<td>&nbsp;</td> <%
		tr++;
	}	
%>
				</tr>
			</table>
			<!-- 해당하는 달의 달력을 출력한다. -->
		</td>				
	</tr>	
</body>


</html>