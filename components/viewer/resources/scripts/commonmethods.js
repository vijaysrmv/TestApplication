var INT_MIN = "-9223372036854775808";
var INT_MAX = "9223372036854775807";
var LONG_MIN = "-9223372036854775808" ;
var LONG_MAX = "9223372036854775807" ;

function myTrim(x) 
{	
    return x.replace(/^\s+|\s+$/gm,'');
}

function removeAll(data,searchfortxt)
{ 
	var startIndex=0;
	while(data.indexOf(searchfortxt)!=-1)
	{
		data=data.substring(startIndex,data.indexOf(searchfortxt))+data.substring(data.indexOf(searchfortxt)+searchfortxt.length,data.length);
	}	
	
	return data;
}

function replaceAll(data,searchfortxt, replacetxt)
{ 
	var startIndex=0;
	while(data.indexOf(searchfortxt)!=-1)
	{
		data=data.substring(startIndex,data.indexOf(searchfortxt)) + replacetxt + data.substring(data.indexOf(searchfortxt)+searchfortxt.length,data.length);
	}	
	
	return data;
}

function removeallspaces(data)
{   
	return data.replace(/\s/g, ""); 
    	 
}

function removedoublespaces(data)
{   
	return data.replace(/\s{2,}/g, ' ');	

}

function containing(data, searchfortxt)
{ 
	if(data.indexOf(searchfortxt)!=-1)
		return true;
	else 
		{
		return false;}
}

function index_of_substring(data, searchfortxt)
{
    if(data.indexOf(searchfortxt)!=-1)
    	{
    	
    	 return data.indexOf(searchfortxt);
    	}
    
}
function mandatory_document(data, DOCUMENT_VALUE)
{
	if(data != DOCUMENT_VALUE|| data == ""|| data == null)
		{
			alert("please attach the document");
			return false;
		}
	else
		{return true;
		
		}
}
function atleast_one_document(data)
{
	if(data == null|| data == "")
		{
			alert("please attach atleast one  document");
			return false;
		}
	else
		return true;
}

function replaceUrlChars(sUrl)
{	
	return sUrl.split("+").join("ENCODEDPLUS");
}

function extractvalue(data)
{ 
return data.replace(/,/g, "");
	
}

function calculatedays(datefield, datefield1)
{
	var dd1=datefield.substring(0,2);
	var mm1=datefield.substring(3,5);
	var yy1=datefield.substring(6,10);
	var depDate1=yy1+'/'+mm1+'/'+dd1;
	var Cur1Date=datefield1;
	var dd2=Cur1Date.substring(0,2);
	var mm2=Cur1Date.substring(3,5);
	var yy2=Cur1Date.substring(6,10);
	var CurDate1=yy2+'/'+mm2+'/'+dd2;
	var CurDate2=new Date(CurDate1);
	var depDate2=new Date(depDate1);
	var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	
	return days;
}

function validateTypeOfValue(thisRef,controlid){
    var ctrlId=thisRef.id;
    var tempMsg;
    var correctValue;
    var patternRef = document.getElementById(ctrlId+"_patternMsg");
    if(controlid!=undefined)
        ctrlId=controlid;
    if(thisRef.value!==""){
    var value;
    if(thisRef.getAttribute("maskingPattern")!=null && thisRef.getAttribute("maskingPattern")!=undefined && thisRef.getAttribute("maskingPattern")!='' && thisRef.getAttribute("maskingPattern")!='nomasking' && thisRef.getAttribute("maskingPattern")!='email'){
        if(thisRef.getAttribute("maskingPattern").toString()==='currency_rupees' || thisRef.getAttribute("maskingPattern").toString()==='currency_dollar' || thisRef.getAttribute("maskingPattern").toString()==='currency_naira' || thisRef.getAttribute("maskingPattern").toString()==='currency_yen' || thisRef.getAttribute("maskingPattern").toString()==='currency_euro' || thisRef.getAttribute("maskingPattern").toString()==='currency_french' || thisRef.getAttribute("maskingPattern").toString()==='currency_bahamas' || thisRef.getAttribute("maskingPattern").toString()==='currency_greek' || thisRef.getAttribute("maskingPattern").toString()==='percentage'|| thisRef.getAttribute("maskingPattern").toString()==='dgroup2'|| thisRef.getAttribute("maskingPattern").toString()==='dgroup3'|| thisRef.getAttribute("maskingPattern").toString()==='NZP')
            value = jQuery(thisRef).autoNumeric('get');
        else
            value = jQuery(thisRef).cleanVal();
    }
    else if(thisRef.getAttribute("custommasking") != null && thisRef.getAttribute("custommasking") != undefined && thisRef.getAttribute("custommasking") != '' && thisRef.getAttribute("custommasking") == 'true') {
    	if(thisRef.getAttribute("datatype") != "date") {
            value = jQuery(thisRef).autoNumeric('get');
        } else {
            value = thisRef.value;
        }
    }
    else{
        value=thisRef.value;
    }
    correctValue =ENTER_CORRECT_VALUE_FOR+thisRef.getAttribute("typeofvalue");
    tempMsg=getIformCustomMsg(ctrlId,"CORRECTVAL_MSG");
    if(tempMsg!=""){
        correctValue=tempMsg;
    }
    if(thisRef.getAttribute("typeofvalue")==='Float'){
        if(value.length>1&&value.charAt(0)=="-")//Bug 81361
            value=value.substring(1);//Bug 81361
        if(isNaN(parseFloat(value)) || !isFinite(parseFloat(value)) || (value.indexOf('.')>0 && (value.length-value.indexOf('.')-1)>(parseInt(thisRef.getAttribute("Precision"))))  ||(value.indexOf('.')>0&&(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision")))<(value.indexOf('.')))||(value.indexOf('.')<0&&value.length>(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision"))))){//Bug 81361
            if(!(isNaN(parseFloat(value)) || !isFinite(parseFloat(value))) && ((value.indexOf('.')>0&&(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision")))<(value.indexOf('.')))||(value.indexOf('.')<0&&value.length>(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision")))))){//Bug 81361
                correctValue=CORRECT_VALUE;
                tempMsg=getIformCustomMsg(ctrlId,"FLOATCORRECTVAL_MSG");
                if(tempMsg!=""){
                    correctValue=tempMsg;
                }
            } 
            else if(!(isNaN(parseFloat(value)) || !isFinite(parseFloat(value))) && (value.length-value.indexOf('.')-1)>(parseInt(thisRef.getAttribute("Precision")))){
                correctValue=PRECISION_VALUE+thisRef.getAttribute("Precision");
                tempMsg=getIformCustomMsg(ctrlId,"PRECISION_MSG");
                if(tempMsg!=""){
                    correctValue=tempMsg;
                }
            }
            if(patternRef!=null && patternRef!=undefined){
                jQuery(patternRef).text(correctValue);
                toggleErrorTooltip(thisRef,null,patternRef,false,1);
            }
            return false;  
        }
    } else if(thisRef.getAttribute("typeofvalue")==='Integer'){
        if(isNaN(parseInt(value)) || (value.indexOf(".") >= 0 ) || !isFinite(value) || parseInt(INT_MIN)>parseInt(value) || parseInt(INT_MAX)<parseInt(value)){
            if(!(isNaN(parseInt(value)) || !isFinite(value)) && (parseInt(INT_MIN)>parseInt(value) || parseInt(INT_MAX)<parseInt(value))){
                correctValue=ENTER_VALUE_BETWEEN+INTEGER_RANGE;
                tempMsg=getIformCustomMsg(ctrlId,"BETWEENVAL_MSG");
                if(tempMsg!=""){
                    correctValue=tempMsg;
                }
            }
            
            if(patternRef!=null && patternRef!=undefined){
                    jQuery(patternRef).text(correctValue);
                    toggleErrorTooltip(thisRef,null,patternRef,false,1);
                }
               return false;  
        }
    }
    else if(thisRef.getAttribute("typeofvalue")==='Long'){
    if(isNaN(parseInt(value)) || (value.indexOf(".") >= 0 ) || !isFinite(value) || BigInt(LONG_MIN)>BigInt(value) || BigInt(LONG_MAX)<BigInt(value)){
            if(!(isNaN(parseInt(value)) || !isFinite(value)) && (BigInt(LONG_MIN)>BigInt(value) || BigInt(LONG_MAX)<BigInt(value))){
                correctValue=ENTER_VALUE_BETWEEN+FLOAT_RANGE;
                tempMsg=getIformCustomMsg(ctrlId,"BETWEENVAL_MSG");
                if(tempMsg!=""){
                    correctValue=tempMsg;
                }
            }
             if(patternRef!=null && patternRef!=undefined){
                    jQuery(patternRef).text(correctValue);
                    toggleErrorTooltip(thisRef,null,patternRef,false,1);
                }
                return false;  
        }
    }
    else if(thisRef.getAttribute("typeofvalue")==='Boolean'){
        if(!(value.toLowerCase()==="true" || value.toLowerCase()==="false" || value=="0" || value=="1")){
             if(patternRef!=null && patternRef!=undefined){
                    jQuery(patternRef).text(correctValue);
                    toggleErrorTooltip(thisRef,null,patternRef,false,1);
                }
               return false;  
        }
    }
    else if(thisRef.getAttribute("typeofvalue")==='Date'){
        if (!isDate(value,'yyyy-MM-dd HH:mm:ss')) {
             if(patternRef!=null && patternRef!=undefined){
                    jQuery(patternRef).text(correctValue);
                    toggleErrorTooltip(thisRef,null,patternRef,false,1);
                }
                return false;  
         } 
     }
     else if(thisRef.getAttribute("typeofvalue")==='ShortDate'){
        if (!isDate(value,'yyyy-MM-dd')) {
             if(patternRef!=null && patternRef!=undefined){
                    jQuery(patternRef).text(correctValue);
                    toggleErrorTooltip(thisRef,null,patternRef,false,1);
                }
               return false;  
         } 
     } 
    }
     jQuery(patternRef).css("display","none");
     toggleErrorTooltip(thisRef,null,patternRef,false,0);
    return true;
}

//Bug 75125
function validateTableCellValue(thisRef,tableId,colIndex){
    var errorflag=false;
    var msgkey=tableId+"_column"+colIndex;
    var correctValue;
    if(thisRef.value!==""){
    var value;
    
    if(thisRef.getAttribute("maskingPattern")!=null && thisRef.getAttribute("maskingPattern")!=undefined && thisRef.getAttribute("maskingPattern")!='' && thisRef.getAttribute("maskingPattern")!='nomasking'&& thisRef.getAttribute("maskingPattern")!='email'){
        if(thisRef.getAttribute("maskingPattern").toString()==='currency_rupees' || thisRef.getAttribute("maskingPattern").toString()==='currency_dollar' ||thisRef.getAttribute("maskingPattern").toString()==='currency_naira' || thisRef.getAttribute("maskingPattern").toString()==='currency_yen' || thisRef.getAttribute("maskingPattern").toString()==='currency_euro' || thisRef.getAttribute("maskingPattern").toString()==='currency_french' || thisRef.getAttribute("maskingPattern").toString()==='currency_bahamas' || thisRef.getAttribute("maskingPattern").toString()==='currency_greek' || thisRef.getAttribute("maskingPattern").toString()==='percentage'|| thisRef.getAttribute("maskingPattern").toString()==='dgroup2'|| thisRef.getAttribute("maskingPattern").toString()==='dgroup3'|| thisRef.getAttribute("maskingPattern").toString()==='NZP')
            value = jQuery(thisRef).autoNumeric('get');
        else
        {
            if(!thisRef.getAttribute("controltype") == "date")
                value = jQuery(thisRef).cleanVal();
        }
            
    }else if(thisRef.getAttribute("custommasking") != null && thisRef.getAttribute("custommasking") != 'undefined'){
        if(thisRef.getAttribute("custommasking")=="true"){
            value = jQuery(thisRef).autoNumeric('get');
        }
    }
    else{
        value=thisRef.value;
    }
 
    correctValue =ENTER_CORRECT_VALUE_FOR+thisRef.getAttribute("typeofvalue");
    var tempMsg=getIformCustomMsg(msgkey,"CORRECTVAL_MSG");
    if(tempMsg!=""){
        correctValue=tempMsg;
    }
    if(thisRef.getAttribute("typeofvalue")==='Float'){
        try{
        if(value.length>1&&value.charAt(0)=="-")//Bug 81361
            value=value.substring(1);//Bug 81361    
        value=value.replace(/\,/g,''); 
        if(isNaN(parseFloat(value)) || !isFinite(value) || (value.indexOf('.')>0 && (value.length-value.indexOf('.')-1)>(parseInt(thisRef.getAttribute("Precision"))))  ||(value.indexOf('.')>0&&(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision")))<(value.indexOf('.')))||(value.indexOf('.')<0&&value.length>(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision"))))){//Bug 81361
            if(!(isNaN(parseFloat(value)) || !isFinite(value)) && ((value.indexOf('.')>0&&(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision")))<(value.indexOf('.')))||(value.indexOf('.')<0&&value.length>(parseInt(thisRef.getAttribute("FloatLength")) - parseInt(thisRef.getAttribute("Precision")))))){//Bug 81361
                correctValue=CORRECT_VALUE;
                tempMsg=getIformCustomMsg(msgkey,"FLOATCORRECTVAL_MSG");
                if(tempMsg!=""){
                    correctValue=tempMsg;
                }
            } 
            else if(!(isNaN(parseFloat(value)) || !isFinite(value)) && (value.length-value.indexOf('.')-1)>(parseInt(thisRef.getAttribute("Precision"))))
                correctValue=PRECISION_VALUE+thisRef.getAttribute("Precision");
                tempMsg=getIformCustomMsg(msgkey,"PRECISION_MSG");
                if(tempMsg!=""){
                    correctValue=tempMsg;
                }
                errorflag=true;           
        }
    }
    catch(ex){}
    } else if(thisRef.getAttribute("typeofvalue")==='Integer'){
        value=value.replace(/\,/g,''); 
        if(isNaN(parseInt(value)) || !isFinite(value) || parseInt(INT_MIN)>parseInt(value) || parseInt(INT_MAX)<parseInt(value)){
            if(!(isNaN(parseInt(value)) || !isFinite(value)) && (parseInt(INT_MIN)>parseInt(value) || parseInt(INT_MAX)<parseInt(value)))
                correctValue=ENTER_VALUE_BETWEEN+INTEGER_RANGE;
            tempMsg=getIformCustomMsg(msgkey,"BETWEENVAL_MSG");
            if(tempMsg!=""){
                correctValue=tempMsg;
            }
            errorflag=true;
        }
    }
    else if(thisRef.getAttribute("typeofvalue")==='Long'){
      value=value.replace(/\,/g,''); 
    if(isNaN(parseInt(value)) || !isFinite(value) || BigInt(LONG_MIN)>BigInt(value) || BigInt(LONG_MAX)<BigInt(value)){
            if(!(isNaN(parseInt(value)) || !isFinite(value)) && (BigInt(LONG_MIN)>BigInt(value) || BigInt(LONG_MAX)<BigInt(value)))
                correctValue=ENTER_VALUE_BETWEEN+FLOAT_RANGE;
            tempMsg=getIformCustomMsg(msgkey,"BETWEENVAL_MSG");
            if(tempMsg!=""){
                correctValue=tempMsg;
            }
            errorflag=true;             
        }
    }
    else if(thisRef.getAttribute("typeofvalue")==='Boolean'){
        if(!(value.toLowerCase()==="true" || value.toLowerCase()==="false" || value=="0" || value=="1")){
            errorflag=true;
        }
    }else if(thisRef.getAttribute("typeofvalue")==='Date'&&!thisRef.getAttribute("controltype")=="date"){
        if (!isDate(value,'yyyy-MM-dd HH:mm:ss')) {
            errorflag=true; 
        }
     }
     if(thisRef.getAttribute("customPattern")!=null){
         var strPattern=thisRef.getAttribute("customPattern");
         if(! new RegExp(strPattern).test(value)){
            correctValue=MSG_ONLY +MSG_CUSTOM_PATTERN+ strPattern + MSG_ARE_ALLOWED; 
            tempMsg=getIformCustomMsg(msgkey,"CUSTOMPATTERN_MSG");
            if(tempMsg!=""){
                correctValue=tempMsg;
            }
            errorflag=true; 
         }            
     }
    }    
    if(errorflag)
    {
      toggleTableErrorTooltip(thisRef,correctValue,1);
      return false;
    }else
    {
        toggleTableErrorTooltip(thisRef,correctValue,0);
        return true;
    }
 }

function validateDateValue(thisRef)
{
    try{
    var dateformat;
    if($(thisRef).hasClass('tableinput'))
    {
        if($(thisRef).hasClass('tabledate'))
             dateformat = thisRef.getAttribute("dateformat")+"_"+thisRef.getAttribute("dateseparator")+"_"+"1";
        if($(thisRef).hasClass('tabledatetime'))
            dateformat = thisRef.getAttribute("dateformat")+"_"+thisRef.getAttribute("dateseparator")+"_"+"2";
    }
    else
        dateformat=thisRef.getAttribute("dateformat");
    var daysInMonth = [0,31,28,31,30,31,30,31,31,30,31,30,31];
    var currentTime;
    var dateFormatString=dateformat.split("_");
    var dateFormat=dateFormatString[0];
    var dateSeperator=dateFormatString[1];
    if (dateSeperator == 1)
        dateSeperator = "/";
    else if (dateSeperator == 2)
        dateSeperator = "-";
    else if (dateSeperator == 3)
        dateSeperator = ".";
    if (new Date().getHours().toString().length > 1)
        currentTime = new Date().getHours() + ":";
    else
        currentTime = ("0" + (new Date().getHours().toString())) + ":";
    if (new Date().getMinutes().toString().length > 1)
        currentTime = currentTime + new Date().getMinutes() + ":";
    else
        currentTime = currentTime + ("0" + (new Date().getMinutes()).toString()) + ":";
    if (new Date().getSeconds().toString().length > 1)
        currentTime = currentTime + new Date().getSeconds();
    else
        currentTime = currentTime + ("0" + (new Date().getSeconds()).toString());
  
    var Dateparts =thisRef.value.split(dateSeperator);
    if(mobileMode!=null&&mobileMode!='')
    	Dateparts =thisRef.value.split("-");
    var timeSplit = thisRef.value.split(" ");
    var dateYear = timeSplit[0].split("/");
    if(dateFormatString[2] == 2)
    {
        var timeSplitNew = timeSplit[1].split(":");
        if (parseInt(timeSplitNew[0]) > 23 || parseInt(timeSplitNew[1]) > 59 || parseInt(timeSplitNew[2]) > 59)
            timeSplit[1] = currentTime;
    }
    var month = (new Date().getMonth() + 1); 
    var currentdate;
    var currentDay = new Date().getDate();
    var outputDate=timeSplit[0];
    if (currentDay.toString().length == 1)
        currentDay = "0" + currentDay;
    if (dateFormat == 1) {
        if (month.toString().length > 1)
            currentdate = currentDay + dateSeperator + month + dateSeperator + new Date().getFullYear();
        else
            currentdate = currentDay + dateSeperator + ("0" + month.toString()) + dateSeperator + new Date().getFullYear();
  
        if (parseInt(Dateparts[0]) > 31 || parseInt(Dateparts[1]) > 12)
            outputDate = currentdate;
        if(Dateparts[0] > daysInMonth[parseInt(Dateparts[1])])
            outputDate = currentdate;
        if (parseInt(Dateparts[1]) == 2 && parseInt(Dateparts[0]) < 30 && dateYear[2] % 4 == 0)
            outputDate = timeSplit[0];
    } else if (dateFormat == 2) {
        if ((month.toString()).length > 1)
            currentdate = month + dateSeperator + currentDay + dateSeperator + new Date().getFullYear();
        else
            currentdate = ("0" + month.toString()) + dateSeperator + currentDay + dateSeperator + new Date().getFullYear();
        if (Dateparts[0] > 12 || Dateparts[1] > 31)
            outputDate = currentdate;
        if (parseInt(Dateparts[0]) == 2 && parseInt(Dateparts[1]) > 29 && dateYear[2] % 4 == 0)
            outputDate = currentdate;
        if(parseInt(Dateparts[0])==2 && parseInt(Dateparts[1])>28 && dateYear[2] % 4 != 0)
            outputDate = currentdate;
    } else if (dateFormat == 3) {
        if ((month.toString()).length > 1)
            currentdate = new Date().getFullYear() + dateSeperator + month + dateSeperator + currentDay;
        else
            currentdate = new Date().getFullYear() + dateSeperator + ("0" + month.toString()) + dateSeperator + currentDay;
        if (Dateparts[1] > 12 || Dateparts[2] > 31)
            outputDate = currentdate;
        if (parseInt(Dateparts[1]) == 2 && parseInt(Dateparts[2]) > 29 && dateYear[2] % 4 == 0)
            outputDate = currentdate;
        if(parseInt(Dateparts[1])==2 && parseInt(Dateparts[2])>28 && dateYear[2] % 4 != 0)
            outputDate = currentdate;
    } else if (dateFormat == 4) {
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        currentdate = currentDay + dateSeperator + months[new Date().getMonth()] + dateSeperator + new Date().getFullYear();
        if (Dateparts[0] > 31)
            outputDate = currentdate;
    }
    if(mobileMode!=null&&mobileMode!='')
    	outputDate=Dateparts[0]+"-"+Dateparts[1]+"-"+Dateparts[2];
    if(dateFormatString[2] == 2)
        thisRef.value=outputDate+" "+timeSplit[1];
    else
        thisRef.value=outputDate;
    }
    catch(ex){}
}

function validateValue(thisRef, dataType)
{
    try{
    if(dataType==="email")
    {
	return validateEmail(thisRef);
    }   
    if(thisRef.getAttribute("disabled") !=null || dataType=="password")
        return true;
    var value = getControlValue(thisRef);
    var ctrlId=thisRef.id;
    var validationMsg = ENTER_VALUE_BETWEEN;
    var correctValue = ENTER_CORRECT_VALUE;
    
    var controlRef = document.getElementById(ctrlId);
    var patternRef = document.getElementById(ctrlId+"_patternMsg");
    var patternStringRef = document.getElementById(ctrlId+"_patternString");
    var msgRef = document.getElementById(ctrlId+"_msg");
    var tempMsg;
    var minDate;
    var maxDate;
    var invalidFlag; 
   if((dataType == 'Integer' || dataType == 'Long') &&  value!="" &&  (value != parseInt(value) ) ){
            tempMsg=getIformCustomMsg(ctrlId,"CORRECTVAL_MSG");
            if(tempMsg!=""){
                correctValue=tempMsg;
            }
            if(patternRef!=null && patternRef!=undefined){
            jQuery(patternRef).text(correctValue);
            toggleErrorTooltip(controlRef,msgRef,patternRef,false,1);
            }
            return false;
   }else if((dataType == 'Float') &&  value!="" &&  (value != parseFloat(value) ) ){
            tempMsg=getIformCustomMsg(ctrlId,"CORRECTVAL_MSG");
            if(tempMsg!=""){
                correctValue=tempMsg;
            }
            if(patternRef!=null && patternRef!=undefined){
             jQuery(patternRef).text(correctValue);
            toggleErrorTooltip(controlRef,msgRef,patternRef,false,1);
            }
            return false;
   }else if(dataType == 'Integer' && (parseInt(value) < parseInt(INT_MIN) || parseInt(value) >parseInt(INT_MAX))){
        validationMsg  += INTEGER_RANGE; 
        tempMsg=getIformCustomMsg(ctrlId,"BETWEENVAL_MSG");
        if(tempMsg!=""){
            correctValue=tempMsg;
        }
        if(patternRef!=null && patternRef!=undefined){
            jQuery(patternRef).text(validationMsg);
            toggleErrorTooltip(controlRef,msgRef,patternRef,false,1);
        }
            return false;
    }else if((dataType == 'Float' || dataType == 'Long') && (BigInt(value) < BigInt(LONG_MIN) ||  BigInt(value) > BigInt(LONG_MAX))){
        validationMsg  += FLOAT_RANGE;
        tempMsg=getIformCustomMsg(ctrlId,"BETWEENVAL_MSG");
        if(tempMsg!=""){
            correctValue=tempMsg;
        }
        if(patternRef!=null && patternRef!=undefined){
            jQuery(patternRef).text(validationMsg);            
	toggleErrorTooltip(controlRef,msgRef,patternRef,false,1);
        }
        return false;
    }else{
        if(dataType == "radio"){
            var radioMsgRef = document.getElementById(ctrlId.substr(0,ctrlId.lastIndexOf("_"))+"_msg");
            var radioRef = document.getElementById(ctrlId);
            var radioPatternRef = document.getElementById(ctrlId+"_patternMsg");
            if(radioMsgRef!=null && radioMsgRef!=undefined){
                jQuery(radioMsgRef).css("display","none");
            }
            if(radioPatternRef!=null && radioPatternRef!=undefined){
                jQuery(radioPatternRef).css("display","none");
            }
            toggleErrorTooltip(radioRef,radioMsgRef,radioPatternRef,false,0);
            if(radioRef!=null && radioRef!=undefined){
                jQuery(radioRef).removeClass("mandatory");
            }          
           
        }else if(dataType == "date" && mobileMode!='android' && mobileMode!='ios'){
            
            var dateFormatString=thisRef.getAttribute("dateformat").split("_");
            var dateFormat=dateFormatString[0];
            var dateSeperator=dateFormatString[1];
            var currentTime = getCurrentTime();
                        
            if($(thisRef).attr('format')!=undefined && $(thisRef).attr('format')!=""){
            if($(thisRef).attr('mindate')!=""&&$(thisRef).attr('mindate')!==undefined){
                minDate = moment($(thisRef).attr('mindate'), $(thisRef).attr('format').toUpperCase()).format("DD/MM/YYYY");
                if($(thisRef).attr('format').toUpperCase()=="MM/DD/YYYY"|| $(thisRef).attr('format').toUpperCase()=="MM.DD.YYYY" || $(thisRef).attr('format').toUpperCase()=="MM-DD-YYYY"){
                    minDate=$(thisRef).attr('minDate');
                }
            }
            if($(thisRef).attr('maxdate')!=""&&$(thisRef).attr('maxdate')!==undefined){
                    maxDate = moment($(thisRef).attr('maxdate'), $(thisRef).attr('format').toUpperCase()).format("DD/MM/YYYY");
                    if($(thisRef).attr('format').toUpperCase()=="YYYY/MM/DD" || $(thisRef).attr('format').toUpperCase()=="YYYY.MM.DD" || $(thisRef).attr('format').toUpperCase()=="YYYY-MM-DD"){
                        maxDate=$(thisRef).attr('maxdate');
                    }
            }
            }
            if(thisRef.getAttribute("mindate")!="" || thisRef.getAttribute("maxdate")!=""){
                var selectedDate = getSelectedDate(thisRef);
                if($(thisRef).hasClass('myjquerydatetimepicker')){
                    var time=value.split(" ")[1];
                    if(selectedDate==maxDate)
                    {
                        if (selectedDate == getCurrentDateTime(1,1,false)) {
                            if (time > currentTime)
                                thisRef.value = getCurrentDateTime(dateFormat,dateSeperator,true);
                        }
                    }
//                    else if(selectedDate==minDate)
//                    {
//                            if (selectedDate == getCurrentDateTime(1,1,false)) {
//                                if (time < currentTime)
//                                    thisRef.value = getCurrentDateTime(dateFormat,dateSeperator,true);
//                            }
//                    }
                    else if (maxDate!=undefined && moment(selectedDate,"DD/MM/YYYY") > moment(maxDate,"DD/MM/YYYY"))  {
                        thisRef.value=maxDate + " " +getCurrentTime();
                    }
                    else if(minDate!=undefined && moment(selectedDate,"DD/MM/YYYY") < moment(minDate,"DD/MM/YYYY")){
                        thisRef.value=minDate + " " +getCurrentTime();
                    }
                }
                else if($(thisRef).hasClass('myjquerydatepicker'))
                {
                   if (maxDate!=undefined && moment(selectedDate,"DD/MM/YYYY") > moment(maxDate,"DD/MM/YYYY"))  {
                        thisRef.value=maxDate;
                    }
                    else if(minDate!=undefined && moment(selectedDate,"DD/MM/YYYY") < moment(minDate,"DD/MM/YYYY")){
                        thisRef.value=minDate;
                    } 
                }
            }
        }
        else{
          if(msgRef!=null && msgRef!=undefined)  
            msgRef.style.display="none";
          if(patternRef!=null && patternRef!=undefined)
            patternRef.style.display="none";
          controlRef.classList.remove("mandatory");
          toggleErrorTooltip(controlRef,msgRef,patternRef,false,0);
        }         
    }   
    if(value == "")
        return true;
    if(patternStringRef!=null && patternStringRef!=undefined && (dataType.toLowerCase() == 'text' || dataType == 'textarea'))
    {
       var strPattern=patternStringRef.innerHTML;
       var validationType=document.getElementById(thisRef.id+"_validationString").innerHTML;
            var msg="";
            var ValidationMessage;
            if(patternStringRef.getAttribute("customPattern")){
                msg=patternStringRef.getAttribute("customPattern");
                ValidationMessage=MSG_ONLY +MSG_CUSTOM_PATTERN+ msg + MSG_ARE_ALLOWED;
            }else{
                if(validationType.indexOf("A")>-1)
                {
                    msg +=MSG_ALPHABETS;
                }

                if(validationType.indexOf("N")>-1) 
                {
                    if(msg!="")
                        msg+=","
                    msg +=MSG_NUMBERS;
                }

                if(validationType.indexOf("S")>-1)
                {
                    if(msg!="")
                        msg+=","
                    msg +=MSG_SPACES;
                }

                if(validationType.indexOf("_")>-1)
                {
                    var spclChars = validationType.substr(validationType.indexOf("_")+1);
                    if(msg!="")
                        msg+=", "
                    msg += spclChars ;
                }

                if(msg == "")
                    ValidationMessage = NO_CHAR_ALLOWED;
                else    
                    ValidationMessage=MSG_ONLY + msg + MSG_ARE_ALLOWED;
            }
            
        if(! new RegExp(strPattern).test(value) || strPattern == "")
        {
           if(jQuery(jQuery(controlRef)[0]).parent().parent().parent().hasClass("floating-label-form-group"))
                jQuery(jQuery(controlRef)[0]).parent().parent().parent().addClass("mandatory");
           else
                jQuery(jQuery(controlRef)[0]).addClass("mandatory");
           if(msgRef!=null && msgRef!=undefined)
                msgRef.style.display="none";
           tempMsg=getIformCustomMsg(ctrlId,"CUSTOMPATTERN_MSG");
           if(tempMsg!=""){
                ValidationMessage=tempMsg;
           }
           patternRef.innerHTML = ValidationMessage;
           toggleErrorTooltip(controlRef,msgRef,patternRef,false,1);
           return false;
        }
        else if(patternStringRef!=null & patternStringRef!=undefined && (patternStringRef.getAttribute("allowSpaces")==='false' || patternStringRef.getAttribute("allowNumbers")==='false' || patternStringRef.getAttribute("SpecialCharacters")!=="") && patternStringRef.getAttribute("allowAlphabets")==="true"){
            invalidFlag = false;
            if(patternStringRef.getAttribute("allowSpaces")==='false'){
                if(/\s/g.test(value)){
                    invalidFlag = true;
                }
                }
            if(patternStringRef.getAttribute("allowNumbers")==='false'){
                if(!/^([^0-9]*)$/.test(value)){
                    invalidFlag = true;
                }
            }
              if(patternStringRef.getAttribute("SpecialCharacters")!==''){
                var specialCharsNotAllowed=patternStringRef.getAttribute("SpecialCharacters");
                for(var i=0;i<specialCharsNotAllowed.length;i++){
                if(value.indexOf(specialCharsNotAllowed[i])>=0){
                    invalidFlag = true;
                    break;
                    }
                    }
                }
                
        }
        if(invalidFlag == true){
            tempMsg=getIformCustomMsg(ctrlId,"CUSTOMPATTERN_MSG");
            if(tempMsg!=""){
                ValidationMessage=tempMsg;
            }
            if(patternRef!=null & patternRef!=undefined){
                patternRef.innerHTML = ValidationMessage;
                toggleErrorTooltip(controlRef,msgRef,patternRef,false,1);
            }
            return false;
        }
    }
        else
        {
            if(jQuery(jQuery(controlRef)[0]).parent().parent().parent().hasClass("floating-label-form-group"))
                jQuery(jQuery(controlRef)[0]).parent().parent().parent().removeClass("mandatory");
            else
                 jQuery(jQuery(controlRef)[0]).removeClass("mandatory")
            if(jQuery(jQuery(controlRef)[0]).attr("multiple")!="undefined") //Bug 82172
                jQuery(jQuery(controlRef)[0]).siblings().find('.dropdown-toggle').removeClass("mandatory");
            if(msgRef!=null && msgRef!=undefined)
                msgRef.style.display="none";
            if(patternRef!=null & patternRef!=undefined){
                patternRef.style.display="none";
                toggleErrorTooltip(controlRef,msgRef,patternRef,false,0);
            }
            return true;
        }
    }
    catch(ex){}
    return true;
}
function fetchCollapsedFrameHTML(listviewId){
    try{
        var parentNode;
    var url = "action_API.jsp";
    var requestString = "fetchCollapsedFrameHTML=yes&pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid);
    if(listviewId!=undefined)
        requestString+="&listviewId="+encode_utf8(listviewId);
    var anyVisible = false;
    var resp = iforms.ajax.processRequest(requestString,url).trim();
    if(resp!=''){
        $(".iform-table").floatThead('reflow');
        var jsonArray = JSON.parse(resp);
        for(var i=0;i<jsonArray.length;i++){
            
            if(jsonArray[i].type=="tabSheet"){
                $(".iform-table").floatThead('reflow');
                var tabhtml = jsonArray[i]["controlHTML"];
                var sheetId=jsonArray[i]["controlId"];
                parentNode=document.getElementById(sheetId);
                parentNode.innerHTML="";
                jQuery(parentNode).html(tabhtml);  
                document.getElementById(sheetId+"_link").removeAttribute("collapsed");//Bug 85740  
                doInit();
				return validateMandatoryFields(sheetId);
            }
            else{
                var frameId = jsonArray[i]["controlId"];
                if(isControlVisible(document.getElementById(frameId))){
                    anyVisible=true;
                }
                else{
                    continue;
                }
                parentNode=document.getElementById(frameId).parentNode;
                parentNode.innerHTML="";
                jQuery(parentNode).html(jsonArray[i]["controlHTML"]);
                doInit();
                var jsElm = document.createElement("script");
                var jsSrc="resources/scripts/"+processName+"/"+formName+"/"+frameId +".js";
                jsElm.type = "application/javascript";
                jsElm.src = jsSrc;
                if(!isScriptAlreadyIncluded(jsSrc))
                    document.getElementsByTagName("head")[0].appendChild(jsElm);
                executeLoadEvents('4',frameId);
                if(window.onLoadSection)
                    window.onLoadSection(frameId,"D");
				if(window.onChangeSectionState)
                    window.onChangeSectionState(frameId,"expanded");
				return validateMandatoryFields(frameId);
            }
        }
      
        if(anyVisible)
            return false;
        else{
            return true;
        }
    }
    else{
        return true;
    }
    }
    catch (ex){}
}


function validateMandatoryFields(frameid,isDoneClick)
{
    isDoneClick = (isDoneClick==undefined)?false:isDoneClick;
    var listViewControls = document.getElementsByClassName('tableControl');
    var advancedListviewControls=document.getElementsByClassName('advancedListviewControl');
    var mandatoryFields=[];
    var isListView = false;
    var listViewType="";
    var isRichText = false;
    var mandateControlInModal= false;
    var j;
    var tempMsg;
    if($('#listViewModal').hasClass('show')){
        for(j=0;j<listViewControls.length;j++){
            if(listViewControls[j].hasAttribute("required")||listViewControls[j].getAttribute('required')=='required'){
                mandatoryFields.push(listViewControls[j]);   
            }    
            mandateControlInModal=true;
        }
        listViewType="normal";
        isListView = true;
        
    }
    else if($('#advancedListViewModal').hasClass('show') && frameid !== "iFrameSubFormModal"){
        for(j=0;j<advancedListviewControls.length;j++){
            if(advancedListviewControls[j].hasAttribute("required")||advancedListviewControls[j].getAttribute('required')=='required'){
                mandatoryFields.push(advancedListviewControls[j]);
            }  
             mandateControlInModal=true;
 
        }
        listViewType="advance";
    }
    else{
        var additionalRequiredFields;
        if(frameid==undefined){
            mandatoryFields=jQuery( "[required='']" );
            additionalRequiredFields = jQuery( "[required='required']" );
        }
    else{
        mandatoryFields=jQuery("#"+frameid+ " [required='']");
        additionalRequiredFields = jQuery("#"+frameid+ " [required='required']");
        if(frameid==="iFrameSubFormModal")
           listViewType="iFrameSubFormModal";
    }
    if(additionalRequiredFields!=null && additionalRequiredFields!=undefined && additionalRequiredFields.length>0){
            for(var k=0;k<additionalRequiredFields.length;k++)
                mandatoryFields.push(additionalRequiredFields[k]);
        }
    }
    
    var blankField=false;
    var blankFieldControl;
    var mandatoryFieldCount = mandatoryFields.length;
    for(var i=0;i<mandatoryFields.length;i++)
    {
        isRichText=false;//Bug 85137
        var control=jQuery(mandatoryFields[i]);
        if(control.hasClass("richtexteditor"))
            isRichText=true;
        var isDisabled=$(control).is('[disabled]');
        var isReadOnly = $(control).is('[readonly]') && !control.hasClass("picklistStyle");
        if((isReadOnly || isDisabled) && control.attr("ismandatorydisable")==undefined)
            continue;
        //Bug 81852 - Mandatory validations not working in IForms when Frame is collapsed
        //var iscontrolvisible = isControlVisible(control.get(0),listViewType);
        //if(!iscontrolvisible)
           // continue;
        var ctrlType=control.attr("type");
        var patternRef = document.getElementById(control.attr("id")+"_patternMsg");
        var msgRef =  document.getElementById(control.attr("id")+"_msg"); 
        var value;
        var tab;
        var iscontrolvisible = isControlVisible(control.get(0),listViewType,blankField,blankFieldControl);
        if(!iscontrolvisible){
            mandatoryFieldCount--;
            delete ComponentValidatedMap[control.attr("id")];
        }
        if(iscontrolvisible)
        {
            if((!document.getElementById(control.attr("id")).style.display=="none" || control.attr("multple")!="undefined") && (!isRichText)){ //Bug 82172
            if(ctrlType === "email" || ctrlType === "text" || ctrlType==="textarea"|| typeof ctrlType=="undefined")
            {
                value=getControlValue(document.getElementById(control.attr("id")));
                if(typeof ctrlType=="undefined")
                    value=control.get(0).value;
                
                if(value=="" || value==null || (control.hasClass("editableCombo") && (value=="Select" || value == "select")))
                {
                    
                    //Bugzilla – Bug 59009
                    ComponentValidatedMap[control.attr("id")]=false;
                    if(jQuery(control).parent().parent().parent().hasClass("floating-label-form-group"))
                        jQuery(control).parent().parent().parent().addClass("mandatory");
                    else
                        jQuery(control).addClass("mandatory");
                    if(control.attr("multiple")!="undefined"){
                        jQuery(control).siblings().find('.dropdown-toggle').addClass("mandatory");
                    }
                    if(patternRef!=null && patternRef!=undefined)
                        patternRef.style.display="none";
                    tempMsg=getIformCustomMsg(control.attr("id"),"MAND_MSG");
                    if(tempMsg!=""){
                        msgRef.innerHTML=tempMsg;
                    }
                    toggleErrorTooltip(control,msgRef,patternRef,true,1);
                    if(!blankField){                    
                        setFocus(control.attr("id"),isListView,null,null,isDoneClick);
                        blankFieldControl=control;
                    }
                    blankField=true;
                }
                else
                {
                    if(value!=null && value!='' && !validateValue(document.getElementById(control.attr("id")), ctrlType))//Bug 83904 Start
                        ComponentValidatedMap[control.attr("id")]=false;
                    else{
                        mandatoryFieldCount--;
                        delete ComponentValidatedMap[control.attr("id")];//Bug 83904 End
                    }
                }

            }
            else if(ctrlType=="radio")
            {
                if(document.querySelector('input[name="'+control.prop("name")+'"]:checked') == null)
                {
                    ComponentValidatedMap[control.prop("name")]=false;//Bug 83904
                    
                    if(jQuery(control).parent().parent().parent().hasClass("floating-label-form-group"))
                        jQuery(control).parent().parent().parent().addClass("mandatory");
                    else
                        jQuery(control).addClass("mandatory");
                    var radioPatternRef = document.getElementById(control.attr("id")+"_patternMsg");
                    var radioMsgRef = document.getElementById(control.attr("id").substr(0,control.attr("id").lastIndexOf("_"))+"_msg");
                    if(radioPatternRef!=null && radioPatternRef!=undefined){
                    jQuery(radioPatternRef).css("display","none"); 
                    }
                    tempMsg=getIformCustomMsg(control.attr("id"),"MAND_MSG");
                    if(tempMsg!=""){
                        radioMsgRef.innerHTML=tempMsg;
                    }
                    if(radioMsgRef!=null && radioMsgRef!=undefined){
                        toggleErrorTooltip(control,radioMsgRef,radioPatternRef,true,1);
                    }
                    if(!blankField){                    
                        setFocus(control.attr("id"),isListView,null,null,isDoneClick);
                        blankFieldControl=control;
                    }
                    blankField=true;
                }
                else
                {
                    var reference = document.getElementById(control.attr("id").substr(0,control.attr("id").lastIndexOf("_"))+"_msg");
                    jQuery(reference).css("display","none");
                    delete ComponentValidatedMap[control.prop("name")];//Bug 83904
                }
            }
            else if(ctrlType=="checkbox")
            {
                value=control.prop("checked");
                if(!value)
                {
                    ComponentValidatedMap[control.attr("id")]=false;
                    if(jQuery(control).parent().parent().parent().hasClass("floating-label-form-group"))
                        jQuery(control).parent().parent().parent().addClass("mandatory");
                    else
                        jQuery(control).addClass("mandatory");
                    var checkPatternRef = document.getElementById(control.attr("id")+"_patternMsg");
                    var checkMsgRef = document.getElementById(control.attr("id")+"_msg");
                    if(checkPatternRef!=null && checkPatternRef!=undefined){
                        jQuery(checkPatternRef).css("display","none");
                    }
                    tempMsg=getIformCustomMsg(control.attr("id"),"MAND_MSG");
                    if(tempMsg!=""){
                        checkMsgRef.innerHTML=tempMsg;
                    }
                    if(checkMsgRef!=null && checkMsgRef!=undefined){
                        toggleErrorTooltip(control,checkMsgRef,null,true,1);
                        
                    }
                    if(!blankField){                    
                        setFocus(control.attr("id"),isListView,null,null,isDoneClick);
                        blankFieldControl=control;
                    }
                    blankField=true;
                }
                else
                {
                    mandatoryFieldCount--;
                    delete ComponentValidatedMap[control.attr("id")];
                }
            } 
        }
        }
        else if(isRichText){
            value=getValue(control.attr("id"));
            var richTextRef = document.getElementById("expandibleDiv_"+control.attr("id"));
            if(value=="" || value==null){
                if(richTextRef.getAttribute("state")=="collapsed"){
                    richTextRef.click();
                }
            }
            if(value=="" || value==null)
            {
                iscontrolvisible = isControlVisible(richTextRef,listViewType,blankField,blankFieldControl);
                if(!iscontrolvisible)
                    continue;
                ComponentValidatedMap[control.attr("id")]=false;
                jQuery(control).addClass("mandatory");
                tempMsg=getIformCustomMsg(control.attr("id"),"MAND_MSG");
                if(tempMsg!=""){
                    msgRef.innerHTML=tempMsg;
                }

                toggleErrorTooltip(control,msgRef,null,true,1);
                if(!blankField){                    
                    //setFocus(control.attr("id"),isListView,null,null,isDoneClick);
                    //frolaMapper[control.attr("id")].events.focus(true);
                    richTextRef.scrollIntoView();
                    blankFieldControl=control;
                }
                blankField=true;
            }
            else{
                if(value==null || value=='')
                    ComponentValidatedMap[control.attr("id")]=false;
                else{
                    mandatoryFieldCount--;
                    delete ComponentValidatedMap[control.attr("id")];
                }
            }
        }
    }
	if(!TileMandatory(mandateControlInModal))
        return false;
if(Object.keys(ComponentValidatedMap).length > 0 && mandatoryFieldCount > 0) {
 	return false;
 }
 if(typeof applicationName!='undefined' && (applicationName==null || applicationName=='')){
     return !blankField && validateMandatoryDoument(mandateControlInModal,frameid);
 } else if(window.opener!=null && typeof window.opener.applicationName!='undefined' && (window.opener.applicationName==null || window.opener.applicationName=='')) {
      return !blankField && validateMandatoryDoument(mandateControlInModal);
 } else   
     return !blankField;
}

function validateMandatoryDoument(mandateControlInModal,frameid){
    var mandatoryFields=[];
    var control;
    var i;
    var tempMsg;
    if (frameid != 'undefined' && typeof frameid != 'undefined' && frameid != null){
        var docControl = document.getElementById(frameid).getElementsByClassName('doc-list-wrapper');
    }else{
        //if(frameid==undefined){
	var docControl=document.getElementsByClassName('doc-list-wrapper');
        //}
    }
    if(docControl == null || typeof docControl == 'undefined' || docControl.length == 0 )
    { 
        docControl=$('#iFrameSubFormModal').find('doc-list-wrapper');
    }
    if (!mandateControlInModal) {
        if (docControl != null && typeof docControl != 'undefined' && docControl.length > 0) {
            if (frameid != 'undefined' && typeof frameid != 'undefined' && frameid != null){
                var mandateDocControltemp = document.getElementById(frameid).getElementsByClassName('doc-list-mandate');
            }else{
                var mandateDocControltemp = document.getElementsByClassName('doc-list-mandate');
            }
            if (mandateDocControltemp != null && typeof mandateDocControltemp != 'undefined' && mandateDocControltemp.length > 0) {
                for (var k = 0; k < mandateDocControltemp.length; k++) {
                    control = document.getElementById($(mandateDocControltemp[k]).attr("id"));
                    if(control.style.display!="none"){
                        var mandateDocControl=control.getElementsByClassName("doc-unit-mandate");
                        for(i=0;i< mandateDocControl.length;i++)
                        {
                            var docExists = false;
                            if(mandateDocControl[i].firstElementChild != null)
                                docExists = true;
                            if (!docExists) {
                            mandatoryFields.push(mandateDocControl[i]);
                        } else {
                            delete ComponentValidatedMap[$(mandateDocControl[i]).attr("id")];
                        }
                        }    
                    }
                }
            }

        }
    }
    var blankField=false;
    var blankFieldControl;
    for(i=0;i<mandatoryFields.length;i++){
        control=jQuery(mandatoryFields[i]);
        var patternRef = document.getElementById(control.attr("id")+"_patternMsg");
        var msgRef =  document.getElementById(control.attr("id")+"_msg"); 
        var ctrlType=control.attr("type");
        if (ctrlType=="docList"){
                ComponentValidatedMap[control.attr("id")]=false;
                jQuery(control).addClass("mandatory");
                tempMsg=getIformCustomMsg(control.attr("id"),"MAND_MSG");
                if(tempMsg!=""){
                   msgRef.innerHTML=tempMsg;
                }
                if (frameid != 'undefined' && typeof frameid != 'undefined' && frameid != null){
                    
                }else{
                    toggleErrorTooltip(control,msgRef,patternRef,true,1);
                }
                if(!blankField){                    
                        document.getElementById(control.attr("id")+'_label').scrollIntoView(false);
                        setFocus(control.attr("id"),false);
                        blankFieldControl=control;
                    }
                blankField=true;
            }
    }
    return !blankField;
}

function isControlVisible(ref,ListViewType,isFirstFieldFocused,blankFieldControl){
    var terminateId = "oforms_iform";
    if(ListViewType=="normal")
        terminateId="iFrameListViewModal";
    else if(ListViewType=="advance")
        terminateId="iFrameAdvancedListViewModal";
    else if(ListViewType=="iFrameSubFormModal")
        terminateId="iFrameSubFormModal";
    var tempControl=ref;
    var isVisible = true;
    while(tempControl!=null&&tempControl.id!=terminateId){
        if(tempControl.classList.contains("container-fluid")){
            break;
        }
        if(tempControl.style.display=="none" || tempControl.multiple){ ////Bug 82172
            if(tempControl.multiple){ //Bug 82172
                 if(jQuery("#"+tempControl.id+"_label").css("display")=="none"){
                     isVisible=false;
                     break;
                 }else{
                      tempControl=tempControl.parentNode;
                      continue;
                 }
            }
            if($(tempControl).hasClass("panel-body")){
                if(isFirstFieldFocused){
                    var isAlreadyExpanded=false;
                    var blankFieldParents=$(blankFieldControl).parents(".panel.panel-default.FrameControl");
                    for(var i=0;i<blankFieldParents.length;i++){
                        if(tempControl.parentNode.id===blankFieldParents[i].id){
                            isAlreadyExpanded=true;
                            break;
                        }
                    }
                    if(!isAlreadyExpanded){
                        var lockNode = tempControl.parentNode.getElementsByClassName("sectionStyle");        
                        lockNode[0].click();
                    }
                }           
            }else{
                isVisible=false;
                break;
            }            
        }
        tempControl=tempControl.parentNode;
    }
    return isVisible;
}

function showUserDefinedMsg(controlId){
    var patternRef = document.getElementById(controlId+"_patternMsg");
    if(patternRef!=null && patternRef!=undefined){
        if(customMsgJSON!=null && customMsgJSON!=undefined && customMsgJSON[controlId]!=undefined)
            patternRef.innerHTML = customMsgJSON[controlId];
    }
}

function validateMinMaxValue(controlId){
    var controlRef = document.getElementById(controlId);
    var patternRef = document.getElementById(controlId+"_patternMsg");
    var invalidValue = false;
    var controlValue = getControlValue(controlRef);
    var minValue,maxValue;
    if(controlRef.getAttribute("minvalue")!=null && controlRef.getAttribute("minvalue")!=undefined && controlRef.getAttribute("minvalue")!='')
       minValue = controlRef.getAttribute("minvalue");
    if(controlRef.getAttribute("maxvalue")!=null && controlRef.getAttribute("maxvalue")!=undefined && controlRef.getAttribute("maxvalue")!='')
       maxValue = controlRef.getAttribute("maxvalue");
    if(controlValue!='' && !isNaN(controlValue) && (Number(controlValue)<Number(minValue) || Number(controlValue)>Number(maxValue)))
        invalidValue = true;
            
   
    if(invalidValue){
        ComponentValidatedMap[controlId]=false;
        if(patternRef!=null && patternRef!=undefined){
            var validationMessage=MINMAXVALUEMSG + minValue + MSG_AND + maxValue;
            var tempMsg=getIformCustomMsg(controlId,"MINMAX_MSG");
            if(tempMsg!=""){
                validationMessage=tempMsg;
            }
            patternRef.innerHTML = validationMessage;
            toggleErrorTooltip(controlRef,null,patternRef,false,1);
        }
        return false;
    }
    else{
        delete ComponentValidatedMap[controlId];
        if(patternRef!=null && patternRef!=undefined){
            toggleErrorTooltip(controlRef,null,patternRef,false,0);
        }
        return true;
    }
        
}

function getIformCustomMsg(controlId,key){
    var msg="";
    if(customMsgJSON!=null && customMsgJSON!=undefined && customMsgJSON[controlId]!=undefined){
        var obj=customMsgJSON[controlId];
        if(obj[key]!=null &&obj[key]!=undefined){
            msg=obj[key];
            return msg;
        }
        if(key!="MAND_MSG" && msg==""){
            key="GENERAL_MSG";
            if(obj[key]!=null &&obj[key]!=undefined){
                msg=obj[key];
            }
        }
    }
    if(key=="CUSTOMPATTERN_MSG" && window.showCustomErrorMessage)
        msg = showCustomErrorMessage(controlId,msg);
    return msg;
}

function toggleErrorTooltip(ref,mndRef,patternRef,isMandatory,type){
    var id=$(ref).attr("id");
    var errorMsg = "";
    if(type==1){
        if(isMandatory){
            if(mndRef!=null){
                mndRef.setAttribute("showMessage", "true");
                errorMsg = $(mndRef).text();
            }
            if(patternRef!=null){
                patternRef.removeAttribute("showMessage");
            }
        }
        else{
            $(ref).addClass("mandatory");
            if(mndRef!=null){
                mndRef.removeAttribute("showMessage");
            }
            if(patternRef!=null){
                patternRef.setAttribute("showMessage", "true");
                errorMsg = $(patternRef).text();
            }
        }
        if($(ref).attr("type")!=null&&$(ref).attr("type")==="radio"){
            id=$(ref).attr("name");
        }
        if($(ref).attr("required")!=null){
            if(document.getElementById(id+"_label")!=null){
                $(document.getElementById(id+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                $(document.getElementById(id+"_label")).append('<span class="icon-errorMandatoryMessageIconClass"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span></span>');
                $(document.getElementById(id+"_label")).removeClass('mandatoryLabel');
            }
        } else if($(ref).attr("type")!=null && $(ref).attr("type")==="docList"){
            if(document.getElementById(id+"_label")!=null){
                $(document.getElementById(id+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                $(document.getElementById(id+"_label")).append('<span class="icon-errorMandatoryMessageIconClass"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span></span>');
                $(document.getElementById(id+"_label")).removeClass('mandatoryLabel');
            }
        }
        else{
            if(document.getElementById(id+"_label")!=null){
                $(document.getElementById(id+"_label")).find(".icon-errorMessageIconClass").remove();
                $(document.getElementById(id+"_label")).append('<span class="icon-errorMessageIconClass"><span class="path1"></span><span class="path2"></span><span class="path3"></span></span>');
            }
        }
        
    }
    else{
        if(mndRef!=null){
            mndRef.removeAttribute("showMessage");
        }
        if(patternRef!=null){
            patternRef.removeAttribute("showMessage");
        }
        $(ref).removeClass("mandatory");
        if($(ref).attr("type")!=null&&$(ref).attr("type")==="radio"){
            id=$(ref).attr("name");
        }
        if($(ref).attr("required")!=null){
            if(document.getElementById(id+"_label")!=null){
                $(document.getElementById(id+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                $(document.getElementById(id+"_label")).addClass('mandatoryLabel');
            }
        }
        else{
            if(document.getElementById(id+"_label")!=null){
                $(document.getElementById(id+"_label")).find(".icon-errorMessageIconClass").remove();
            }
        }
    }
    var tooltipOpenerInfo = {
		animation: 'fade',
		delay: 200,
		trigger:"custom",
		content: errorMsg ,
		triggerOpen: {
		click: true,
		hover: true,
		tap: true
		},
		triggerClose: {
		click: true,
		hover: true,
		tap: true
		}
	}
	
    if(document.getElementById("listViewModal") && document.getElementById("listViewModal").style.display == 'block'){
	jQuery("#listViewModal").find(".icon-errorMandatoryMessageIconClass").tooltipster(tooltipOpenerInfo);
    }else if(document.getElementById("advancedListViewModal") && document.getElementById("advancedListViewModal").style.display == 'block'){
	jQuery("#advancedListViewModal").find(".icon-errorMandatoryMessageIconClass").tooltipster(tooltipOpenerInfo);
    }else if(document.getElementById("subFormModal") && document.getElementById("subFormModal").style.display == 'block'){
	jQuery("#subFormModal").find(".icon-errorMandatoryMessageIconClass").tooltipster(tooltipOpenerInfo);
    }else{
	jQuery(".icon-errorMandatoryMessageIconClass").tooltipster(tooltipOpenerInfo);
    }
}

function toggleTableErrorTooltip(ref,message,type){
    var typeofvalue;
    if($(ref).hasClass('tabletextbox')){
        var cellRef=$(ref).closest('td');
        if(type==1){
            cellRef.removeClass("fpadding3");
            cellRef.addClass("errorTableCell");
            var cellDiv=document.createElement("div");
            $(cellDiv).css("border","1px solid");
            $(cellDiv).addClass("fpadding3");
            $(cellDiv).addClass("mandatory");
            cellDiv.appendChild(ref);
            $(ref).css("width", "calc(100% - 15px)");
            $(ref).css("display", "inline-block");
            $(cellDiv).append('<span class="icon-errorMessageIconClass"><span class="path1"></span><span class="path2"></span><span class="path3"></span></span>');
            cellRef.empty();
            $(cellDiv).appendTo(cellRef);
            $(cellRef).tooltipster("content",message);
            typeofvalue=typeof ref.getAttribute("typeofvalue")=='undefined'?'':ref.getAttribute("typeofvalue");//Bug 84631 Start
            if((ref.getAttribute("maskingpattern")!="nomasking" && ref.getAttribute("maskingpattern")!="")
            || (typeofvalue=='Float' && ref.getAttribute("maskingpattern")=="nomasking" && ref.getAttribute("custommasking")!=='true'))
            {
                maskfield(ref,'input');
            }//Bug 84631 End
            customMaskHook({ref : ref,type : "tabletextbox",case : "init"});
        }
        else if($(cellRef).hasClass("errorTableCell")){//Bug 84631
            $(ref).css("display", "");
            $(ref).css("width", "");
            cellRef.empty();
            $(ref).appendTo(cellRef);
            $(cellRef).addClass("fpadding3");
            $(cellRef).removeClass("errorTableCell");
            $(cellRef).tooltipster("content","");
            typeofvalue=typeof ref.getAttribute("typeofvalue")=='undefined'?'':ref.getAttribute("typeofvalue");//Bug 84631 Start
            if((ref.getAttribute("maskingpattern")!="nomasking" && ref.getAttribute("maskingpattern")!="")
            || (typeofvalue=='Float' && ref.getAttribute("maskingpattern")=="nomasking" && ref.getAttribute("custommasking")!=='true'))
            {
                maskfield(ref,'input');
            }//Bug 84631 End
            customMaskHook({ref : ref,type : "tabletextbox",case : "init"});
        }
    }
}
function getCurrentTime(){
    return ((new Date().getHours().toString().length==1)?"0"+new Date().getHours():new Date().getHours())+":"+((new Date().getMinutes().toString().length==1)?"0"+new Date().getMinutes():new Date().getMinutes())+":"+((new Date().getSeconds().toString().length==1)?"0"+new Date().getSeconds():new Date().getSeconds());
}

function getSelectedDate(thisRef){
    var selectedDate;
    var value = getControlValue(thisRef);
    var dateFormatString=thisRef.getAttribute("dateformat").split("_");
    var dateFormat=dateFormatString[0];
    var ds = ["/","-","."];
    var dateSeperator = ds[dateFormatString[1]-1];
    var valueEnteredparts=value.split(dateSeperator);
    var valueEntered ;
    var valueEnteredDay;
    var valueEnteredMonth;
        
    if($(thisRef).hasClass('myjquerydatetimepicker') || $(thisRef).hasClass('mydatetimepicker')) {
        valueEnteredparts=value.split(" ")[0].split(dateSeperator);
    }
    
    if(dateFormat==1)
        valueEntered = new Date(valueEnteredparts[2],valueEnteredparts[1]-1,valueEnteredparts[0]);  
    else if(dateFormat==2)
        valueEntered = new Date(valueEnteredparts[2],valueEnteredparts[0]-1,valueEnteredparts[1]);                    
    else if(dateFormat==3)
        valueEntered = new Date(valueEnteredparts[0],valueEnteredparts[1]-1,valueEnteredparts[2]);
    else if(dateFormat==4){
        if(dateSeperator=="-")
            valueEntered = new Date(value.replace(/-/g,'/'));
        else if(dateSeperator==".")
            valueEntered = new Date(value.replace(/./g,'/'));
        else
            valueEntered = new Date(value); //Bug 92721
    }
    valueEnteredDay = (valueEntered.getDate().toString().length>1)?valueEntered.getDate():"0"+valueEntered.getDate().toString(); 
    valueEnteredMonth = ((valueEntered.getMonth()+1).toString().length>1)?valueEntered.getMonth()+1:"0"+(valueEntered.getMonth()+1).toString();
    selectedDate = valueEnteredDay + "/" + valueEnteredMonth +"/" + valueEntered.getFullYear();
    
    return selectedDate;
}

function getCurrentDate(df,ds){  
    var currentdate;
    var seperators = ["/","-","."];
    ds = seperators[ds-1];
    var cd = (new Date().getDate().toString().length>1)?new Date().getDate():"0"+new Date().getDate().toString(); 
    var cm = ((new Date().getMonth()+1).toString().length>1)?(new Date().getMonth()+1):"0"+(new Date().getMonth()+1).toString(); 
    if(df==1)
        currentdate=cd+ds+cm+ds+new Date().getFullYear();
    else if(df==2)
        currentdate=cm+ds+cd+ds+new Date().getFullYear();                 
    else if(df==3)
        currentdate=new Date().getFullYear()+ds+cm+ds+cd;
    else if(df==4){
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        currentdate=cd+ds+months[cm-1]+ds+new Date().getFullYear();
    }
    return currentdate;            
}

function getCurrentDateTime(df,ds,timeFlag){
        var currentDate = getCurrentDate(df,ds);
        if(timeFlag)
            currentDate +=" "+getCurrentTime();
        return currentDate;
}