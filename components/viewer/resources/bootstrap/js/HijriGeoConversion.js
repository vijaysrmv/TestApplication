/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function minDateInCalendar(d, m, y) {

    if ((d / 10 != 0 && m / 10 != 0) && (d < 10 && m < 10)) {
        d = ("0" + d).slice(-2);
        m = ("0" + m).slice(-2);
    } else if (d % 10 != 0 && d < 10) {
        d = ("0" + d).slice(-2);
    } else if (m % 10 != 0 && m <= 10) {
        m = ("0" + m).slice(-2);
    }


    var minDate = y + "-" + m + "-" + d;
    return minDate;
}

function maxDateInCalendar(d, m, y) {

    if ((d / 10 != 0 && m / 10 != 0) && (d < 10 && m < 10)) {
        d = ("0" + d).slice(-2);
        m = ("0" + m).slice(-2);
    } else if (d % 10 != 0 && d < 10) {
        d = ("0" + d).slice(-2);
    } else if (m % 10 != 0 && m <= 10) {
        m = ("0" + m).slice(-2);
    }


    var maxDate = y + "-" + m + "-" + d;
    return maxDate;
}


//HIJRI DAY, MONTH, and YEAR CONVERSION BELOW

function inputDateToDay(_date, delimeter,dateformat) {
    var inputFromUserDate = _date.split(delimeter); //"-"
    var day;
    if(dateformat=="1")
        day=inputFromUserDate[0];
    else if(dateformat=="2")
        day=inputFromUserDate[1];
    else if(dateformat=="3")
        day=inputFromUserDate[2];
    else if(dateformat=="4")
        day=inputFromUserDate[0];

    return parseInt(day);
}

function inputDateToMonth(_date, delimeter,dateformat) {
    var inputFromUserDate = _date.split(delimeter); //"-"
    var month;
    if(dateformat=="1")
        month=inputFromUserDate[1];
    else if(dateformat=="2")
        month=inputFromUserDate[0];
    else if(dateformat=="3")
        month=inputFromUserDate[2];
    else if(dateformat=="4")
        month=inputFromUserDate[2];
    return parseInt(month);
}

function inputDateToYear(_date, delimeter,dateformat) {
    var inputFromUserDate = _date.split(delimeter); //"-"
    var year;
    if(dateformat=="1")
        year=inputFromUserDate[2];
    else if(dateformat=="2")
        year=inputFromUserDate[2];
    else if(dateformat=="3")
        year=inputFromUserDate[0];
    else if(dateformat=="4")
        year=inputFromUserDate[2];
    return parseInt(year);
}



function toConvertedHijriDate(date, dateformat,delimeter) {
    var userDateToHijri;
    var DD;
    var MM;
    var YYYY;


    var hijriFormat = 'en-u-ca-islamic-umalqura-nu-latn'; // use islamic-umalqura calendar (most modern)

    var output = new Intl.DateTimeFormat(hijriFormat).format(date);

    DD = inputDateToDay(output, delimeter,2);

    MM = inputDateToMonth(output, delimeter,2);
    YYYY = inputDateToYear(output, delimeter,2);

    if ((DD / 10 != 0 && MM / 10 != 0) && (DD < 10 && MM < 10)) {
        DD = ("0" + DD).slice(-2);
        MM = ("0" + MM).slice(-2);
    } else if (DD % 10 != 0 && DD < 10) {
        DD = ("0" + DD).slice(-2);
    } else if (MM % 10 != 0 && MM <= 10) {
        MM = ("0" + MM).slice(-2);
    }
    if(dateformat=="1")
        userDateToHijri=DD+delimeter+MM+delimeter+YYYY;
    else if(dateformat=="2")
        userDateToHijri=MM+delimeter+DD+delimeter+YYYY;
    else if(dateformat=="3")
        userDateToHijri=YYYY+delimeter+MM+delimeter+DD;
    else if(dateformat=="4") {
        
        const ar = ['Muh', 'Saf', 'RabI', 'RabII', 'JumI', 'JumII', 'Raj', 'Sha', 'Ram', 'Shw', 'DhuQ', 'DhuH'];
        
        
        userDateToHijri=DD+delimeter+ar[MM-1]+delimeter+YYYY;
        
    }        
   return userDateToHijri;
}

function todayDate(dateformat,delimeter) {
    var date = new Date();

    var DD = date.getDate();
    var MM = date.getMonth() + 1;
    var YYYY = date.getFullYear();

    if ((DD / 10 != 0 && MM / 10 != 0) && (DD < 10 && MM < 10)) {
        DD = ("0" + DD).slice(-2);
        MM = ("0" + MM).slice(-2);
    } else if (DD % 10 != 0 && DD < 10) {
        DD = ("0" + DD).slice(-2);
    } else if (MM % 10 != 0 && MM <= 10) {
        MM = ("0" + MM).slice(-2);
    }
    var outputDate;
     if(dateformat=="1")
        outputDate=DD+delimeter+MM+delimeter+YYYY;
    else if(dateformat=="2")
        outputDate=MM+delimeter+DD+delimeter+YYYY;
    else if(dateformat=="3")
        outputDate=YYYY+delimeter+MM+delimeter+DD;
    else if(dateformat=="4")
        outputDate=DD+delimeter+MM+delimeter+YYYY;
    return outputDate;

}



function toConvertedDateObject(date,dateformat) {

	var day, month, year;
	var date_as_object;
	
    if(dateformat=="1") {
		day  = parseInt(date.substring(0,2));
		month  = parseInt(date.substring(3,5));
		year   = parseInt(date.substring(6,10));
		
		date_as_object = new Date(year, month-1, day);
		return date_as_object;
	}
    else if(dateformat=="2") {
		month  = parseInt(date.substring(0,2));
		day  = parseInt(date.substring(3,5));
		year   = parseInt(date.substring(6,10));
		
		date_as_object = new Date(year, month-1, day);
		return date_as_object;
	}
    else if(dateformat=="3") {
		year   = parseInt(date.substring(0,4));
		month  = parseInt(date.substring(5,7));
		day  = parseInt(date.substring(8,10));
		
		date_as_object = new Date(year, month-1, day);
		return date_as_object;
	}
     else if(dateformat=="4") {

 		day  = parseInt(date.substring(0,2));
                var monthStr = date.substring(3,date.length - 5);
                console.log("MonthStr value:"+monthStr);
                year = parseInt( date.charAt(date.length - 4) + date.charAt(date.length - 3) + date.charAt(date.length - 2) + date.charAt(date.length - 1));
                
                
                const en = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                //const ar = ['Muh', 'Saf', 'RabI', 'RabII', 'JumI', 'JumII', 'Raj', 'Sha', 'Ram', 'Shw', 'DhuQ', 'DhuH'];

//                if(year<2000) {
////                if(isHijri || year<2000) {
//                    month = mmmNumber(monthStr,ar);
//                }
//                else {
                    month = mmmNumber(monthStr,en);
//                }                
                date_as_object = new Date(year, month-1, day); // To Check
                console.log("Date Obj:"+date_as_object);
 		return date_as_object;
 	}


//        else if(dateformat=="4") {
////              let date = new Date(value);
//                const day = date.toLocaleString('default', { day: '2s-digit' });
//                const month = date.toLocaleString('default', { month: 'short' });
//                const year = date.toLocaleString('default', { year: 'numeric' });
//                
//                date_as_object = day + '-' + month + '-' + year;
//                return date_as_object;
//                
// 		day  = parseInt(str1.substring(0,2));
// 		month  = parseInt(str1.substring(-6,3));
// 		year   = parseInt(str1.substring(-1,-5));
//		
// 		date_as_object = new Date(day, month-1, year); // To Check
// 		return date_as_object;
// 	}
    //var userDateToHijri = YYYY + "-" + MM + "-" + DD;
//    return userDateToHijri;
}

function mmmNumber(str1,localeArray) {
    
        //Month Code
        var output_month=0;
        for(var i=0; i<12; i++)
        {
//            if(dateStr.includes( localeArray[i]))
            if(str1===localeArray[i])
            {
                output_month = i+1;
                break;
            }
        } 
        
        if (output_month < 10) {
            output_month = ("0" + output_month).slice(-2);
        } 
console.log("OP Month:"+output_month);
        return output_month;
}
