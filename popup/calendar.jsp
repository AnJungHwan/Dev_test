<%@ page language="java" import="java.sql.*, java.io.*, java.util.*" %>
<%@ page contentType="text/html;charset=euc-kr" %>

<%! int year;
	int month;
	int date;
	int dayofweek;  //ù��° ���� ����
	int days;  //�״��� ��¥��
	int nowyear; //������ �⵵
	int nowmonth;  //������ ��
	int nowdate;  //������ ��
	String paturl = null;	//ȣ���� �������κ��� url�� �޾ƿ´�.
	String target = "";		//ȣ���� �������� ������ �̸�
	String nowweek;  //������ ����
	String url="";  //��ũ Url
	String stryear = null;	//������ ��
	String strmon = null;	//������ ��
	String strday = null;	//������ ��
	String paradate = null;	//��¥
	String parapo = null;	//ȣ���� �������� ��ġ
%>
<%String name = request.getParameter("name");%>

<%    
/**********          ���� ����Ͻø� ���Ѵ�.                **********/
/**********          ó�� �ҷ��ö� �̰��� ����Ѵ�.          **********/
	Calendar now = Calendar.getInstance();
	year =now.get(Calendar.YEAR);
	month = now.get(Calendar.MONTH)+1;
	date = now.get(Calendar.DATE);
	dayofweek = now.get(Calendar.DAY_OF_WEEK);
	nowyear = year;
	nowmonth = month;
	nowdate = date;
	
/**********          �� �� ���� �޴´�.                    **********/


/**********          �� ���� ���������� ����ϴ�.          **********/
	String reqyear = request.getParameter("year");
	String reqmonth = request.getParameter("month");
	String reqdate = request.getParameter("date");
	String mode = request.getParameter("mode");
	String parapo = request.getParameter("parapo");


/**********          ���� ���� mode������ ó���� �Ѵ�.                      **********/
/**********          ó�� �����ϸ� reqyear, reqmonth�� null �̹Ƿ�          **********/
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
	
/**********          ���� �޾Ƽ� ������ �Ѵ�.          **********/
/**********          ���ϴ� ��,��,���� ����!          **********/
	now.set(Calendar.YEAR,curyear);	
	now.set(Calendar.MONTH,curmonth);
	now.set(Calendar.DATE,1);

	
/**********          ���õ� ������ ��,��,���� ��� �´�.          **********/
	year =now.get(Calendar.YEAR);//�⵵
	month = now.get(Calendar.MONTH)+1;//��
	date = now.get(Calendar.DATE);//��¥
	int blank = now.get(Calendar.DAY_OF_WEEK);//����

/**********          ��,��,��,��¥���� ��� �Ѵ�.          **********/
	if ((nowyear == year) && (nowmonth == month)){  //���� ��,���� ������
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
				nowweek = "��";
				break;
		case	2:
				nowweek = "��";
				break;
		case	3:
				nowweek = "ȭ";
				break;
		case	4:
				nowweek = "��";
				break;
		case	5:
				nowweek = "��";
				break;
		case	6:
				nowweek = "��";
				break;
		default:
				nowweek = "��";
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
<title>��¥����</title>
</head>

<body bgcolor=#d4d0c8 topmargin=0 leftmargin=0 marginheight=0 marginwidth=0>
<center>

	
<form name="form1" method="post">
  <input type="hidden" name="mon" value="4">
  <input type="hidden" name="yyyy" value="102">
  <input type="hidden" name="goType">
</form>


<%

		//���ڸ��� ���� ���� ������ �Ѱ���
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
   		<%= year%> �� <%= month%> ��</font>
   	</th>	
	<th align=center>
   		<a  href="calendar.jsp?name=<%=name%>&mode=nextmonth&year=<%= year%>&month=<%= month%>&date=<%= date%>&a_url=<%= paturl %>&a_target=<%= target %>&parapo=<%= parapo %>">>></a></th>
	</th>
</tr>
<th><font style="color:red"><strong>��</strong></font></th>
<th><strong>��</strong></th>
<th><strong>ȭ</strong></th>
<th><strong>��</strong></th>
<th><strong>��</strong></th>
<th><strong>��</strong></th>
<th><font style="color:blue"><strong>��</strong></font></th>
</tr>
				
<%	
/********** ���ϸ�ŭ ������ ���ؼ�          **********/
	int tr=0;  
	for(int i=1;i<blank;i++){%>
		<td>&nbsp;</td> <%
			tr++;
	}
/********** ��¥�� ��� �Ѵ�.          **********/
	for (int j =1; j< days+1;j++){
		tr++;
		//���ڸ��� ���� ���� ������ �Ѱ���
			stryear = String.valueOf(year);
			strmon = String.valueOf(month);
			if(strmon.length() == 1)
				strmon = "0"+strmon;
			strday = String.valueOf(j);
			if(strday.length() == 1)
				strday = "0"+strday;
			paradate = "'"+stryear+"','"+strmon+"','"+strday+"'";

			// tr=1..7 �Ͽ���..����ϱ����� ��Ÿ����.
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
/********** ��¥�� ����ϰ� �������� �����          **********/
	while(tr > 0 && tr <7){%>
		<td>&nbsp;</td> <%
		tr++;
	}	
%>
				</tr>
			</table>
			<!-- �ش��ϴ� ���� �޷��� ����Ѵ�. -->
		</td>				
	</tr>	
</body>


</html>