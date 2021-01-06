var __GOMS_CALENDAR_WEEK_NAME                = new Array("일","월","화","수","목","금","토"); //영문으로 바꾸고 잡은 사람은 여기 수정
var __GOMS_CALENDAR_THISMONTH_BG            = "Gainsboro"; //이번달 색상
var __GOMS_CALENDAR_OTHERMONTH_BG            = "white"; //이번달 색상
var __GOMS_CALENDAR_THISMONTH_FONT_COLOR    = "black"; //이번달 색상
var __GOMS_CALENDAR_OTHERMONTH_FONT_COLOR    = "Gainsboro"; //이번달 색상
var __GOMS_CALENDAR_OTHERMONTH_SELECTED_FONT_COLOR= "white"; //선택일 색상
var __GOMS_CALENDAR_OTHERMONTH_SELECTED_BG    = "gray"; //선택일 색상
var __GOMS_CALENDAR_OTHERMONTH_MOUSE_OVER    = "white"; //MouserOver색상
var __GOMS_CALENDAR_DESTFORM;
var __GOMS_CALENDAR_SHOW                    = false;
var nowDate    = new Date();

//인자값(destForm, x축 보정, Y축보정)
function showGomsCalendar()
{

    var destForm,modX, modY;
    
    if(arguments.length > 0){
        destForm    = arguments[0];
    }else{
        destForm    = event.srcElement;
    }
    
    if(arguments.length > 1){
        modX    = arguments[1];
    }else{
        modX    = 0;
    }
    
    if(arguments.length > 2){
        modY    = arguments[2];
    }else{
        modY    = 0;
    }

    var destDate    = getGomsCalendarStringToDate(destForm.value);
//    showDate(destDate);
    getGomsCalendarTags(destDate);
    var x=event.clientX + document.body.scrollLeft  - event.offsetX + modX;
    var y=event.clientY + document.body.scrollTop + destForm.style.height -event.offsetY + modY;

    divGomsCalendar.style.left = x;
    divGomsCalendar.style.top  = y;
    __GOMS_CALENDAR_DESTFORM = destForm;
}

function getGomsCalendarStringToDate(strDate)
{
    var di    = new Array("-", ".", ","); //구분자로 지원할 문자 앞쪽거 우선
    var returnDate  = new Date();//default :today
    var arrDate;
    for(var i = 0 ; i < di.length; i++){
        arrDate = strDate.split(di[i]);
        if(arrDate.length ==3){
            returnDate.setYear(arrDate[0]);
            returnDate.setMonth(arrDate[1] - 1);
            returnDate.setDate(arrDate[2]);
            break;
        }
    }
    return returnDate;//strDate가 올바르지 않은 날자 형태일경우 오늘날짜 리턴
}

//해당일자의 시작일(일요일)을 구한다
function getGomsCalendarFirstDateOfWeek(tDate)
{
    var sunDay = new Date();
    var firstDateOfMonth    = new Date();
    firstDateOfMonth.setYear(tDate.getYear());
    firstDateOfMonth.setMonth(tDate.getMonth());
    firstDateOfMonth.setDate(1);
    sunDay.setTime(gomsDayPlus(firstDateOfMonth, firstDateOfMonth.getDay() * -1));
    return sunDay;
}

//datediff 제공된 일자에 해당 일자를 + - 한 일자를 리턴
function gomsDayPlus(tDate,cnt)
{    
    var rtnDate    = new Date();
    rtnDate.setTime(tDate.getTime() + ( cnt * 24 * 60 * 60 * 1000 ) );
    return rtnDate;
}
//해당월 마지막날의 일자(date type)를 리턴합니다.(100년 후까지 쓸꺼면 로직 보안 해야 합니다... ㅋㅋㅋ)
function getGomsCalendarLastDate(tDate)
{
    var Mon2
    var rtnDate    = new Date();
    var arrLastDay = new Array(31,29,31,30,31,30,31,31,30,31,30,31);
    if(tDate.getYear() % 4 ==0) Mon2 = true;
    else Mon2 =false;
    arrLastDay[1] = (Mon2) ? 29 : 28;
    rtnDate.setYear(tDate.getYear());
    rtnDate.setMonth(tDate.getMonth());
    rtnDate.setDate(arrLastDay[tDate.getMonth()]);
    
    //마지막주 토요일을 구하자
    rtnDate    = gomsDayPlus(rtnDate,6 - rtnDate.getDay())

    return rtnDate;
}

//디버깅용 함수
function showDate(d)
{
    alert(d.getYear() + "-" + ( d.getMonth() +1) + "-" +d.getDate());
}

//레이어 감추기
function hideGomsCalendar()
{
    if( __GOMS_CALENDAR_SHOW    == false){
        divGomsCalendar.style.visibility = "hidden";
    }else{
        setTimeout("hideGomsCalendar()",500);
    }

}
//이동
function goNextMonth()
{
    nowDate.setMonth(nowDate.getMonth() +1);
    getGomsCalendarTags(nowDate);
}

function goPrevMonth()
{
    nowDate.setMonth(nowDate.getMonth() -1);
    getGomsCalendarTags(nowDate);
}

function goNextYear()
{
    nowDate.setYear(nowDate.getYear() + 1);
    getGomsCalendarTags(nowDate);
}

function goPrevYear()
{
    nowDate.setYear(nowDate.getYear() -1);
    getGomsCalendarTags(nowDate);

}

//폼에 데이터 입력
function inputDate(y,m,d)
{
    
    m    = "0" + "" + m;
    m    = m.substring(m.length-2);

    d    = "0" + "" + d;
    d    = d.substring(d.length-2);
    __GOMS_CALENDAR_DESTFORM.value    = y + "-" + m + "-" + d;
    divGomsCalendar.style.visibility = "hidden";
    
}

function getGomsCalendarTags(destDate)
{
    var strTag = "";
    var destYear    = destDate.getFullYear();
    var destMonth    = destDate.getMonth() + 1;
    var destDay        = destDate.getDate();

    nowDate    = destDate;

    var startDate    = getGomsCalendarFirstDateOfWeek(destDate);
    var endDate        = getGomsCalendarLastDate(destDate);
    var pDate        = new Date();
    pDate            = startDate;
    
//    showDate(endDate);


    strTag += "    <table id=\"calendar\" cellspacing=\"0\" cellpadding=\"2\" title=\"Calendar\" border=\"0\" style=\"border-width:1px;border-style:solid;height:177px;width:243px;border-collapse:collapse;font-size:11px\">";
    strTag += "        <tr>";
    strTag += "            <td colspan=\"7\" style=\"background-color:LightSteelBlue;\">";
    strTag += "                <table cellspacing=\"0\" border=\"0\" style=\"color:White;width:100%;border-collapse:collapse;\">";
    strTag += "                    <tr>";
    strTag += "                        <td style=\"width:20%;\">";
    strTag += "                        <span style=\"cursor:hand\" onClick=\"goPrevYear()\" ><<</span>&nbsp;&nbsp;";
    strTag += "                        <span style=\"cursor:hand\" onClick=\"goPrevMonth()\" ><</span>";
    strTag += "                        </td>";
    strTag += "                        <th align=\"center\" style=\"width:40%;\">" + destYear + "년 " + destMonth + "월</th>";
    strTag += "                        <td style=\"width:20%;\" align=\"right\">";
    strTag += "                        <span style=\"cursor:hand\" onClick=goNextMonth() >></span>&nbsp;&nbsp;";
    strTag += "                        <span style=\"cursor:hand\" onClick=goNextYear() >>></span>";
    strTag += "                        </td>";
    strTag += "                    </tr>";
    strTag += "                </table>";
    strTag += "            </td>";
    strTag += "        </tr>";
    strTag += "        <tr>";
    strTag += "            <td align=\"center\" abbr=\"Sunday\" scope=\"col\">" + __GOMS_CALENDAR_WEEK_NAME[0] + "</td>";
    strTag += "            <td align=\"center\" abbr=\"Monday\" scope=\"col\">" + __GOMS_CALENDAR_WEEK_NAME[1] + "</td>";
    strTag += "            <td align=\"center\" abbr=\"Tuesday\" scope=\"col\">" + __GOMS_CALENDAR_WEEK_NAME[2] + "</td>";
    strTag += "            <td align=\"center\" abbr=\"Wednesday\" scope=\"col\">" + __GOMS_CALENDAR_WEEK_NAME[3] + "</td>";
    strTag += "            <td align=\"center\" abbr=\"Thursday\" scope=\"col\">" + __GOMS_CALENDAR_WEEK_NAME[4] + "</td>";
    strTag += "            <td align=\"center\" abbr=\"Friday\" scope=\"col\">" + __GOMS_CALENDAR_WEEK_NAME[5] + "</td>";
    strTag += "            <td align=\"center\" abbr=\"Saturday\" scope=\"col\">" + __GOMS_CALENDAR_WEEK_NAME[6] + "</td>";
    strTag += "        </tr>";

    strTag += "         <tr>";



    var bgColor,fontColor,y,m,d,overColor;
    while(pDate <= endDate)
    {
        y    = pDate.getFullYear();
        m    = pDate.getMonth() + 1;
        d    = pDate.getDate();

        if ( pDate.getYear() == destDate.getYear() &&  pDate.getMonth() == destDate.getMonth() &&  pDate.getDate() == destDate.getDate()){//선택일
            bgColor        = __GOMS_CALENDAR_OTHERMONTH_SELECTED_BG;
            fontColor    = __GOMS_CALENDAR_OTHERMONTH_SELECTED_FONT_COLOR;
            overColor    = bgColor;
        }else if ( pDate.getMonth() == destDate.getMonth() ){//선택월
            bgColor        = __GOMS_CALENDAR_THISMONTH_BG;
            fontColor    = __GOMS_CALENDAR_THISMONTH_FONT_COLOR;
            overColor    = __GOMS_CALENDAR_OTHERMONTH_MOUSE_OVER;
        }else{//기타월
            bgColor = __GOMS_CALENDAR_OTHERMONTH_BG;
            fontColor = __GOMS_CALENDAR_OTHERMONTH_FONT_COLOR;
            overColor = bgColor;
        }



        if(pDate.getDay() ==0){ strTag += "        <tr>";} //일요일이면
        strTag    +="            <td align=\"center\" style=\"color:" + fontColor + ";cursor:hand;background-color:" + bgColor + ";width:14%;\" onClick=\"inputDate(" + y + "," + m + "," + d + ")\" onMouseOver=\"this.style.backgroundColor='" + overColor +"'\" onMouseOut=\"this.style.backgroundColor='" + bgColor +"'\">" + pDate.getDate() + "</td>";
        if(pDate.getDay() ==6 ){ strTag += "        </tr>";} //토요일이면
        pDate    = gomsDayPlus(pDate, 1); //하루 더한다
//        alert(pDate);
        
    }
    strTag    +="            </table>";    
    divGomsCalendar.innerHTML = strTag;
    divGomsCalendar.style.visibility = "visible";

    setTimeout("hideGomsCalendar()",1500);
    __GOMS_CALENDAR_SHOW = true;
}

document.write("<div id=\"divGomsCalendar\" style=\"visibility:hidden; position:absolute; background-Color:white\" onMouseOver=\"__GOMS_CALENDAR_SHOW=true\" onMouseOut=\"__GOMS_CALENDAR_SHOW=false\"></div>");



