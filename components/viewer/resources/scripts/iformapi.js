
var navigationClick="";
var isNavigationNextClick = false;
function refreshFrame(frameId, syncFlag) {
    var requesthandler;
    var frameHTML;
    syncFlag = (""+syncFlag).toUpperCase() == "TRUE";
    var url = "action_API.jsp";
    var requestString = "frameId=" + frameId + "&frameStateAPI=collapsed&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
    if (jQuery(jQuery("#" + frameId).children()[0]).attr("painted") != undefined) {
        if (jQuery(jQuery("#" + frameId).children()[0]).attr("state") == "collapsed")
            requestString += "&refreshCollapsed=true";
        if (syncFlag == true) {
            frameHTML = iforms.ajax.processRequest(requestString, url);
            refreshFrameHelper(frameId, frameHTML)
        }
        else{
            if(document.getElementById('fade')!=null)
              document.getElementById('fade').style.display="block";
            new net.ContentLoader(url, refreshFrameResponseHandler, frameErrorHandler, "POST", requestString, true);
        }
        }
    else if(document.getElementById(frameId).childNodes.length === 1){
        if (syncFlag == true) {
            frameHTML = iforms.ajax.processRequest(requestString, url);
            refreshFrameHelper(frameId, frameHTML)
        }
        else{
            if(document.getElementById('fade')!=null)
               document.getElementById('fade').style.display="block";
            new net.ContentLoader(url, refreshFrameResponseHandler, frameErrorHandler, "POST", requestString, true);
        }
    }
}

function refreshFrameResponseHandler() {

    var framehtml = this.req.responseText;
    framehtml=sanitize(framehtml.trim(),'html');
    var frameid = getQueryVariable(this.params, "frameId");
    refreshFrameHelper(frameid, framehtml);
    if(document.getElementById('fade')!=null)
       document.getElementById('fade').style.display="none";
}

function refreshFrameExt(frameId,queueVar ,syncFlag) {
    var frameHTML;
    syncFlag = (""+syncFlag).toUpperCase() == "TRUE";
    var url = "action_API.jsp";
    var requestString = "frameId=" + frameId + "&frameStateAPI=collapsed&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid)+"&queueVar="+queueVar;
    if (jQuery(jQuery("#" + frameId).children()[0]).attr("painted") != undefined) {
        if (jQuery(jQuery("#" + frameId).children()[0]).attr("state") == "collapsed")
            requestString += "&refreshCollapsed=true";
        if (syncFlag == true) {
            frameHTML = iforms.ajax.processRequest(requestString, url);
            refreshFrameHelper(frameId, frameHTML)
        }
        else{
            if(document.getElementById('fade')!=null)
              document.getElementById('fade').style.display="block";
            new net.ContentLoader(url, refreshFrameResponseHandler, frameErrorHandler, "POST", requestString, true);
        }
        }
    else if(document.getElementById(frameId).childNodes.length === 1){
        if (syncFlag == true) {
            frameHTML = iforms.ajax.processRequest(requestString, url);
            refreshFrameHelper(frameId, frameHTML)
        }
        else{
            if(document.getElementById('fade')!=null)
               document.getElementById('fade').style.display="block";
            new net.ContentLoader(url, refreshFrameResponseHandler, frameErrorHandler, "POST", requestString, true);
        }
    }
}

function refreshFrameHelper(frameid, framehtml) {
    $(".iform-table").floatThead('reflow');
    var parentNode = document.getElementById(frameid).parentNode;
    if(framehtml!=""){
      parentNode.innerHTML = "";
      jQuery(parentNode).html(sanitize(framehtml,'html'));
    }
    doInit();
    executeLoadEvents('4', frameid);
    if (window.onLoadSection)
        window.onLoadSection(frameid);
}

function setDateRange(controlId, minDate, maxDate) {
    try{
    var dateControl = getControlElement(controlId);
    if( dateControl != null && dateControl != undefined )
        controlId = dateControl.getAttribute("id");
    var el = dateControl.cloneNode(true);
    var par = dateControl.parentNode;
    par.removeChild(dateControl);
    el.removeAttribute("xd");
    par.insertBefore(el,par.childNodes[0]);

    if($(el).attr('format')!=undefined && $(el).attr('format')!=""){
        if(minDate!=""&& minDate!==undefined){
            if(!($(el).attr('format').toUpperCase()=="MM/DD/YYYY" || $(el).attr('format').toUpperCase()=="MM.DD.YYYY" || $(el).attr('format').toUpperCase()=="MM-DD-YYYY")){
               minDate = moment(minDate,'DD/MM/YYYY').format($(el).attr('format').toUpperCase());
            }
                el.setAttribute("mindate", minDate);
        }
        if(maxDate != undefined && maxDate != ''){
                if(!($(el).attr('format').toUpperCase()=="YYYY/MM/DD" ||$(el).attr('format').toUpperCase()=="YYYY.MM.DD" || $(el).attr('format').toUpperCase()=="YYYY-MM-DD")){
                    maxDate = moment(maxDate,'DD/MM/YYYY').format($(el).attr('format').toUpperCase());
                }
                el.setAttribute("maxdate", maxDate);
        }
    }
    else{
				if (maxDate != undefined && maxDate != '')
				{
                    if(moment(maxDate,'DD/MM/YYYY').format('DD/MM/YYYY')===maxDate){
                        el.setAttribute("maxdate", maxDate);
                    }else{
                        el.setAttribute("maxdate", moment(maxDate).format('DD/MM/YYYY'));
                    }
				
				}
				if (minDate != undefined && minDate != '')
				{
                    if(moment(minDate,'DD/MM/YYYY').format('DD/MM/YYYY')===minDate){
                        el.setAttribute("mindate", minDate);
                    }else{
                        el.setAttribute("mindate", moment(minDate).format('DD/MM/YYYY'));
                    }
				}
                        }
    attachDatePickerInSpecificControl(el);
     $(el).on('dp.change', function (e) {
        ctrOnchangeHandler(this, 1);
        var customMethodName = el.getAttribute("method");
        if (customMethodName != null && customMethodName != undefined){
                customMethodName = customMethodName.split('(')[0];
                window[customMethodName](controlId, e);
        }
	});

    }
    catch(ex){}
}

//Bug 84949 Start
function checkFieldMandatoryCondition(thisRef) {
    var validateMapKey = thisRef.id;//Bug 83970 Start
    if (thisRef.name != null && thisRef.name != undefined && thisRef.name != "")
        validateMapKey = thisRef.name;
    var value = getControlValue(thisRef);
    var required=jQuery(thisRef).attr("required");
    required=sanitize(required,'string');
    if (value != "" && required != undefined)
    {
        var msgRef = document.getElementById(thisRef.id + "_msg");
        var patternRef = document.getElementById(thisRef.id + "_patternMsg");
        jQuery(msgRef).css("display", "none");
        jQuery(patternRef).css("display", "none");
        toggleErrorTooltip(thisRef, msgRef, patternRef, true, 0);
        if (jQuery(jQuery(thisRef)[0]).parent().parent().parent().hasClass("floating-label-form-group"))
            jQuery(jQuery(thisRef)[0]).parent().parent().parent().removeClass("mandatory");
        else
            jQuery(jQuery(thisRef)[0]).removeClass("mandatory");
        if (validateMapKey in ComponentValidatedMap)
            delete ComponentValidatedMap[validateMapKey];
    }
}//Bug 84949 End

function showConfirm(msg)
{
    var btns = {
        confirm: {
            label: YES,
            className: 'btn-success'
        },
        cancel: {
            label: NO,
            className: 'btn-danger'
        }
    }
    var callback = function (result) {
        if (result) {
            var control = document.getElementById("listViewModal");
            var controlAdvance = document.getElementById("advancedListViewModal");
            if (control.style.display == 'block' && controlAdvance.style.display == 'block')
            {
                removerowToModify();
                $('#listViewModal').modal('hide')
            }
            else
            {
                if(control.style.display == 'block')
                {
                    removerowToModify();   
                }
                else if(controlAdvance.style.display == 'block')
                {
                    removeAdvancedListviewrowToModify();
                }
                $('.modal.in').modal('hide'); 
            }
        }
    }
    showConfirmDialog(msg, btns, callback);
}

function listViewOverlay(controlId)
{
    var isAdvanceListViewOpened=false;
        if(document.getElementById("advancedListViewModal")!=null && (document.getElementById("advancedListViewModal").className==="modal in" || document.getElementById("advancedListViewModal").className==="modal show"))
        {
            isAdvanceListViewOpened=true;
        }
        var textareas = $('#iFrameAdvancedListViewModal').find(".richtexteditor");
        if(!isAdvanceListViewOpened){
            textareas = $('#iFrameListViewModal').find(".richtexteditor");
        }
        for(var i=0;i<textareas.length;i++){
            jQuery("#"+textareas[i].id).removeAttr("contentChanged");
        }
        if($('#'+controlId).hasClass('advancedListviewControl')){
            $('#LVcloseButton').attr("state","close");
        }
        else{
            $('#advLVcloseButton').attr("state","close");
        }
    var boolMsgTobeDisplay = false;
    var msg;
    if (window.msgOnCloseOverLay)
    {
        msg = msgOnCloseOverLay(controlId);
        if (!("" == msg)) {
            boolMsgTobeDisplay = true;
        }
    }
    if (boolMsgTobeDisplay)
        showConfirm(msg);
    else
    {
        var control = document.getElementById("listViewModal");
        var controlAdvance = document.getElementById("advancedListViewModal");
        if (control.style.display == 'block' && controlAdvance.style.display == 'block')
        {
            removerowToModify();
            $('#listViewModal').modal('hide')
        }
        else
        {
           if(control.style.display == 'block')
           {
            removerowToModify();   
           }
           else if(controlAdvance.style.display == 'block')
           {
            removeAdvancedListviewrowToModify();
           }
           $('.modal.show').modal('hide'); 
           $('.modal-backdrop').remove();
        }
            
    }

}

function getMandatoryFieldList(controlId, index)
{
    var tab = document.getElementById(controlId);
    var controls;
    if (tab != null && tab != undefined)
    {
        if (index == undefined)
            controls = $('#' + controlId + " .control-class");
        else
        {
            var sheet = tab.getElementsByClassName("tab-pane fade")[index];
            controls = sheet.getElementsByClassName("control-class");
        }
        var mandatoryJsonArray = [];
        for (var i = 0; i < controls.length; i++)
        {
            var boolValidate = false;
            if (controls[i].getAttribute("required") != undefined)
            {
                var mandatoryJson = {};
                if (getValue(controls[i].id))
                    boolValidate = true;
                mandatoryJson["ControlId"] = controls[i].id;
                mandatoryJson["Validate"] = boolValidate;
                mandatoryJsonArray.push(mandatoryJson);
            }
        }
        return mandatoryJsonArray;
    }
}
//Bug 85154 Start
function moveScroller() {
    var anchor = $(".iformTabControl")[0];
    var scrollerButtons = null, scroller = null;
    var isTabStyle4 = false;
    if ($('.iformTabUL.fixed-tabmenu.tabtheme4')[0] != null) {
        isTabStyle4 = true;
        if ($('.tabButtonsDiv')[0] != null)
            scrollerButtons = $('.tabButtonsDiv')[0];
        scroller = $('.scrtabs-tab-container')[0];

        }
        else
            scroller = $('.iformTabUL.fixed-tabmenu')[0];


    var move = function () {
        var offset = 0;
        if (document.getElementById("headerDiv") != null)
            offset = $($("#headerDiv")[0]).outerHeight() + $($("#headerDiv")[0]).offset().top - 5;
        var st = $(window).scrollTop();
        var ot = $(anchor).offset().top - offset;
        if (st > ot && ot > 0) {
            $(scroller).css({
                position: "fixed",
                top: offset + "px",
                zIndex: 990
            });
            if (isTabStyle4)
                $(scroller).css({
                    "background": "inherit"
                });
            if (scrollerButtons != null) {
                var buttonLeft = $(scroller).offset().left + $(scroller).outerWidth();
                var buttonHeight = $(scroller).outerHeight();
                $(scrollerButtons).css({
                    position: "fixed",
                    top: offset + "px",
                    zIndex: 990,
                    left: buttonLeft,
                    height: buttonHeight,
                    "background": "inherit"
                });
            }
        } else {
            $(scroller).css({
                top: offset + "px",
                zIndex: "",
                "background": ""
            });
            if (scrollerButtons != null) {
                $(scrollerButtons).css({
                    top: offset + "px",
                    left: "",
                    zIndex: "",
                    height: "",
                    "background": ""
                });
            }
        }
    };
    if (scroller != null) {
        document.addEventListener(
                'scroll',
                function (event) {
                    jQuery('.myjquerydatepicker').datetimepicker('hide');
                    jQuery('.myjquerydatetimepicker').datetimepicker('hide');
                    move();
                },
                true
                );
        move();
        }
        else{
        document.addEventListener(
                'scroll',
                function (event) {
                    jQuery('.myjquerydatepicker').datetimepicker('hide');
                    jQuery('.myjquerydatetimepicker').datetimepicker('hide');
                },
                true
                );
    }
}
//Bug 85154 End
//Bug 85226 Start
function addZone(zoneName, top, left, width, height, controlId) {
    var control = document.getElementById(controlId);
    if (control != null) {
        var onFocusData = control.getAttribute("onfocus");
        if (onFocusData == null)
            onFocusData = "";
        if (onFocusData.indexOf("attachZoneBehaviour", 0) != -1) {
            var attachZoneIndex = onFocusData.indexOf("attachZoneBehaviour", 0);
            var attachZonelastIndex = onFocusData.indexOf(";", attachZoneIndex);
            onFocusData = onFocusData.substring(0, attachZoneIndex) + onFocusData.substr(attachZonelastIndex + 1);
        }
        onFocusData += "attachZoneBehaviour(this,'" + zoneName + "','" + left + "','" + top + "','" + width + "','" + height + "');";
        control.setAttribute("onfocus", sanitize(onFocusData,'string'));

    }
}

function setSliderAttributes(id,attrib,value){
    var box = $('#'+id).parents().eq("1").find(".textRangeValue");
    var slider = $("#"+id).parent().find(".slider2");
    if(attrib==="min"){        
        $(box).attr('min',value);
        slider.attr("min",value);
        $("#"+id).parent().find(".leftRange").find("p")[0].innerHTML=value;        
    } else if(attrib==="max") {
        $(box).attr('max',value);
        slider.attr("max",value);   
        $("#"+id).parent().find(".rightRange").find("p")[0].innerHTML=value;
    }    
}

function setSliderValueApi(id,sliderValue){
    var box = $('#'+id).parents().eq("1").find(".textRangeValue");
    
    if(sliderValue===""){
        $(box).parent().parent().parent().parent().find(".slider2").val($(box).attr('min'));
    } else {
                if(parseFloat(sliderValue)>parseFloat($(box).attr('max')))
                {
                    showAlertDialog(TILE_MAX+parseFloat($(box).attr('max')), false);
                } 
                else if(parseFloat(sliderValue)<parseFloat($(box).attr('min')))
                    {
                        showAlertDialog(TILE_MIN+parseFloat($(box).attr('min')), false);
                    }
                else{
                    $(box).val(sliderValue);
                    $(box).attr('value',sliderValue);
                    $(box).attr('title',sliderValue);
                    $(box).parent().parent().parent().parent().find(".slider2").val(sliderValue);
                    $(box).parent().parent().parent().parent().find(".slider2").attr('value',sliderValue);
                    $(box).parent().parent().parent().parent().find(".slider2").attr('title',sliderValue);
                    var slider = $("#"+id).parent().find(".slider2");
                    var max = slider.attr("max");
                    var min = slider.attr("min");
                    var percentage = (sliderValue - min) / (max - min);
                    percentage*=100;
                    document.getElementById(id).style.width=percentage+"%";
                }    
    }
    
}
//Bug 85226 End
function setValue(controlName, controlValue) {
    controlName=sanitize(controlName,'string');
    var objComp = document.getElementById(controlName);
    var i;
    if (objComp == null || objComp.classList.contains("iform-radio"))
    {
        objComp = document.getElementsByName(controlName)[0];
    }
     
    if (objComp != null) {
        //Bug 84373 Start
        if (objComp.type == 'date' || objComp.type == 'datetime-local')
            objComp.value = controlValue;
        //Bug 84373 End
        if($(objComp).hasClass("colorRange")){
            setSliderValueApi(controlName, controlValue);
        } else if ($(objComp).hasClass("slider2")){
            setSliderValueApi($("#"+controlName).parent().find(".colorRange").attr("id"), controlValue);
        }

        //Bug 76737 Start
        if (objComp.type == 'text' || objComp.type == "textarea" || objComp.type == 'email') {
            if(objComp.getAttribute("datatype") == "text" || objComp.getAttribute("datatype") == "textarea"){
            if(!fieldValidation(objComp, controlValue,false) && validateSetValue){
                return false;
            }}
            if ($(objComp).hasClass("editableCombo")) {//Bug 83221 Start
                var ul = objComp.parentNode.childNodes[2];
                for (i = ul.childNodes.length - 1; i >= 0; i--) {
                   if(ul.childNodes[i].getAttribute("value")==controlValue || ul.childNodes[i].getAttribute("originalValue")==controlValue){
                        $(objComp).val(ul.childNodes[i].innerText); //85761
                        $(objComp).editableSelect("filter");
                        return controlValue;
                    }
                }
                $(objComp).val("Select");
                $(objComp).editableSelect("filter");
                return "";
            }//Bug 83221 End
            if (objComp.maxLength > -1) {
                if (objComp.maxLength < controlValue.length)
                    controlValue = controlValue.substr(0, objComp.maxLength);
            }
            if(objComp.getAttribute("xd") !== null ){
                   var el = objComp.cloneNode(true);
                   var par = objComp.parentNode;
                   par.removeChild(objComp);
                   el.removeAttribute("xd");
                   par.insertBefore(el,par.childNodes[0]);
                   attachDatePickerInSpecificControl(el);
                   $(el).on('dp.change', function (e) {
                       ctrOnchangeHandler(this, 1);
                       var customMethodName = el.getAttribute("method");
                       if (customMethodName != null && customMethodName != undefined)
                            window[customMethodName](document.getElementById(controlName),event);                       
                   });
                   objComp = el;
            }
            objComp.value = controlValue;
            //Changes start for Bug-130925
             if(objComp.type=='text' && objComp.classList.contains("textbox")){
                objComp.title = controlValue;
            }
            //Changes end for Bug-130925
	    if(objComp.hasAttribute('autocompletevalue')&&controlValue===''){
                objComp.setAttribute('autocompletevalue','');
            }
            if (objComp.getAttribute("maskingPattern") != null && objComp.getAttribute("maskingPattern") != 'undefined') {
                if (objComp.getAttribute("maskingPattern").toString() != 'nomasking' && objComp.getAttribute("maskingPattern").toString() != '')//Bug 81232
                    controlValue = applyMaskingValue(objComp, controlValue);//Bug 81232
            }
            if(objComp.getAttribute("custommasking") != null && objComp.getAttribute("custommasking") != 'undefined'){
                if(objComp.getAttribute("custommasking")=="true"){
                    controlValue = applyMaskingValue(objComp, controlValue);
                }
            }
            if ((objComp.type == 'text' || objComp.type == 'email') && objComp.classList.contains("form-input") && controlValue != '') {
                objComp.classList.add("input-focus");
                document.getElementById(controlName + "_label").classList.add("input-focus-label");
            }
            if (objComp.type == "textarea" && objComp.classList.contains("form-textarea") && controlValue != '') {
                objComp.classList.add("input-focus");
                objComp.classList.add("textarea-focus");
                document.getElementById(controlName + "_label").classList.add("input-focus-label");
                document.getElementById(controlName + "_label").classList.add("textarea-focus-label");
            }

        }//Bug 76737 End
        if (objComp.type == 'select-one' || objComp.type == 'ComboBox')
        {
            objComp.value = controlValue;
        }
        if (objComp.type == 'select-multiple')
        {
            for (i = 0; i < objComp.options.length; i++) {
                objComp.options[i].selected = false;
            }
            for (i = 0; i < objComp.options.length; i++) {
                for (var j = 0; j < controlValue.length; j++) {
                    if (controlValue[j] == objComp.options[i].value)
                        objComp.options[i].selected = true;
                }
            }
            reloadListBoxLayout(controlName);
        }
        else if(objComp.tagName=='LABEL'||objComp.tagName=='A')
        {
            objComp.innerHTML = sanitize(controlValue);
            objComp.setAttribute("title",sanitize(controlValue));
            if (objComp.getAttribute("maskingPattern") != null && objComp.getAttribute("maskingPattern") != 'undefined') {
                if (objComp.getAttribute("maskingPattern").toString() != 'nomasking' && objComp.getAttribute("maskingPattern").toString() != '')//Bug 81232
                    controlValue = applyMaskingValue(objComp, controlValue);//Bug 81232
            }
            if(objComp.getAttribute("custommasking") != null && objComp.getAttribute("custommasking") != 'undefined'){
                if(objComp.getAttribute("custommasking")=="true"){
                    controlValue = applyMaskingValue(objComp, controlValue);
                }
            }
        }
        else if(objComp.type=='radio')
        {
            var options = document.getElementsByName(controlName);
            for (i = 0; i < options.length; i++) {
                options[i].checked=false;
            }
            $("#" + controlName).children(".active").removeClass("active");
			
			var mainDiv = document.getElementById(controlName); 
            var inputChildren = mainDiv.getElementsByTagName("input") ; 
            for(var inputchild=0 ;inputchild < inputChildren.length; inputchild++){  
                if(inputChildren[inputchild].value==controlValue){  
                    inputChildren[inputchild].parentElement.classList.add("active"); 
                    inputChildren[inputchild].checked=true ; 
                }  
            }   		
        }
        else if(objComp.type=='checkbox')
        {
            if (controlValue.toLowerCase() == "true")
            {
                objComp.checked = true;
                objComp.setAttribute("value", objComp.checked);
                ctrOnchangeHandler(objComp, 1); 
            }
            else
            {
                objComp.checked = false;
                objComp.setAttribute("value", objComp.checked);
                ctrOnchangeHandler(objComp, 1);
            }
        }
        checkFieldMandatoryCondition(objComp);//Bug 84949
    }
    return controlValue;//Bug 81232
}
//Bug 85533 Start
function setTableCellDateRange(tableId, rowIndex, colIndex, minDate, maxDate) {
    var dateControl = getCellControl(tableId, rowIndex, colIndex);
    if (maxDate != undefined && maxDate != '')
        dateControl.setAttribute("maxdate", maxDate);
    if (minDate != undefined && minDate != '')
        dateControl.setAttribute("mindate", minDate);
}
//Bug 85533 End
function escapeStringForHTML(data) {
    if (typeof data == "string")
        return data.replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    else
        return data;
}

function getQueryVariable(queryString, variable) {
    var vars = queryString.split('&');
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split('=');
        if (decodeURIComponent(pair[0]) == variable) {
            return decodeURIComponent(pair[1]);
        }
    }
}

//Bug 85784 Start
function deleteRowsFromGridAction(tableControlId, rowIndices, altRowColor, batchCounter) {
    tableControlId=sanitize(tableControlId,'string');
    for (var i = rowIndices.split(",").length - 1; i >= 0; i--) {
        var rowIndex = rowIndices.split(",")[i];
        if (rowIndex != "") {
            document.getElementById(tableControlId).tBodies[0].deleteRow(rowIndex);
        }
    }
    var rows = document.getElementById(tableControlId).tBodies[0].getElementsByTagName("tr");
    var visibleRows = [];
    for (var j = 0; j < rows.length; j++) {
        if (rows[j].style.display != "none")
            visibleRows.push(rows[j]);
    }
    if (altRowColor != undefined && altRowColor != null) {
        for (var m = 0; m < visibleRows.length; m++) {
            if (m % 2 == 1)
                visibleRows[m].style.backgroundColor = "#" + altRowColor;
            else
                visibleRows[m].style.backgroundColor = "#fff";
        }
    }
    $("#" + tableControlId).floatThead('reflow');
    checkTableHeight(tableControlId);
    reshuffleIndices(tableControlId, "", batchCounter);

    calculateTotalForGrid(tableControlId);
    if (window.deleteRowPostHook)
    {
        deleteRowPostHook(tableControlId, rowIndices);
    }
    document.getElementById("delete_"+tableControlId).disabled = true;
    if(document.getElementById("delete_"+tableControlId).childNodes[0].childElementCount > 0)
            document.getElementById("delete_"+tableControlId).childNodes[0].childNodes[0].setAttribute("src","./resources/images/DeleteIconDisabled.png");
        
}
//Bug 85784 End

//Bug 85784 Start
function calculateTotalForGrid(tableId) {
    var totalValueElements = document.getElementById('totallabel_' + tableId).innerHTML.split(",!,");
    for (var i = 0; i < totalValueElements.length; i++) {
        if (totalValueElements[i] != '') {
            $(document.getElementsByClassName(totalValueElements[i].replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&amp;/g, '&'))).each(function () {
                var typeofvalue = typeof this.getAttribute("typeofvalue") == 'undefined' ? '' : this.getAttribute("typeofvalue");
                if ((this.getAttribute("maskingpattern") != "nomasking" && this.getAttribute("maskingpattern") != "")
                        || (typeofvalue == 'Float' && this.getAttribute("maskingpattern") == "nomasking"))
                {
                    maskfield(this, 'label');
                }
            });
        }
        showTotal('', totalValueElements[i]);
    }
}
//Bug 85784 End

function refreshIndexes(xml) {
    var url = "ifhandler.jsp";
    var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&op=5&AttribXML=" + encode_utf8(xml.trim());
    return iforms.ajax.processRequest(requestString, url);
}
if (!String.prototype.endsWith) {
    String.prototype.endsWith = function (search, this_len) {
        if (this_len === undefined || this_len > this.length) {
            this_len = this.length;
        }
        return this.substring(this_len - search.length, this_len) === search;
    };
}

var footerFrameName = "";
function sectionAsFooter(frameName) {
    if (frameName !== "") {
        var sectionEle = document.getElementById(frameName);
        if (sectionEle !== null) {
            footerFrameName = frameName;
            var parentElem = sectionEle.parentNode.parentNode;
            var heightOfSection = jQuery(parentElem).height();
            jQuery("#oforms_iform").css("height", "auto");
            jQuery("#oforms_iform").css("height", parseInt(jQuery("#oforms_iform").visibleHeight()) - parseInt(heightOfSection) - 8);
            if (parentElem.parentNode.parentNode.id === "oforms_iform") {
                document.body.style.overflow = "hidden";
                document.getElementById("oforms_iform").style.overflow = "auto";
                var container = document.createElement("div");
                container.className = "container-fluid";
                parentElem.style.position = "fixed";
                parentElem.style.bottom = "0px";
                parentElem.style.width = "100%";
                container.appendChild(parentElem);
                document.body.appendChild(container);
            }
            jQuery(parentElem).width(parseInt(jQuery("#oforms_iform").width()) - 8);
        }
    }
}

$.fn.visibleHeight = function () {
    var elBottom, elTop, scrollBot, scrollTop, visibleBottom, visibleTop;
    scrollTop = $(window).scrollTop();
    scrollBot = scrollTop + $(window).height();
    elTop = this.offset().top;
    elBottom = elTop + this.outerHeight();
    visibleTop = elTop < scrollTop ? scrollTop : elTop;
    visibleBottom = elBottom > scrollBot ? scrollBot : elBottom;
    return visibleBottom - visibleTop;
}


function changeSectionCaption(frameName, captionName) {
    var imgNode = document.getElementById(frameName).childNodes[0].childNodes[1];
    document.getElementById(frameName).childNodes[0].innerText = captionName;
    document.getElementById(frameName).childNodes[0].appendChild(imgNode);
}
//Bug 87917
function redirectToOmniApp() {
    var msgId = '-8002';
    var headingId = '8002';
    var redirectCode = msgId;
    var url = '/omniapp/pages/error/errorpage.app?u_sc=iform&msgID=' + redirectCode + "&HeadingID=" + headingId;

    var WindowHeight = 150;
    var WindowWidth = 400;
    var WindowLeft = 0;
    var WindowTop = 0;
    window.close();
    var wFeatures = 'height=' + WindowHeight + ',width=' + WindowWidth + ',resizable=0,status=1,scrollbars=auto,top=' + WindowTop + ',left=' + WindowLeft;
    var win = window.open(url, 'oapwebmain', wFeatures, false);
    win.focus();
}
//Bug 89941
function redirectToApplication()
{
    window.location.href = contextPath;
}

function tableCellKeyPress(tableId, cellRef, evtObj) {
    var rowIndex = $(cellRef).closest('tr').index();
    var colIndex = parseInt($(cellRef).closest('td').index()) - 1;
    var json = {};
    json["tableId"] = tableId;
    json["rowIndex"] = rowIndex;
    json["colIndex"] = colIndex;
    if (window.onTableCellKeyPress) {
        if (onTableCellKeyPress(tableId, colIndex, evtObj, rowIndex)) {
            executeServerEvent("", "PicklistOnTableCell", JSON.stringify(json), true);
            cancelBubble(evtObj);
        }
    }

}

function tableCellFocus(tableId, cellRef, evtObj){
    var rowIndex = $(cellRef).closest('tr').index();
    var colIndex = parseInt($(cellRef).closest('td').index()) - 1;
    if(window.onTableCellFocus){
        onTableCellFocus(tableId,rowIndex,colIndex,evtObj);
    }
}

function reloadTabSheet(tabId, sheetIndex) {
    var tabRef = document.getElementById(tabId);
    if (tabRef != null && tabRef != undefined) {
        var sheetLIElems = tabRef.getElementsByClassName("tabSheetLink");
        if (sheetLIElems[sheetIndex] != null && sheetLIElems[sheetIndex] != undefined) {
            var sheetId = sheetLIElems[parseInt(sheetIndex)].getAttribute("href").split('#')[1];
            LoadTab(sheetLIElems[sheetIndex], tabId, sheetId, sheetIndex, "Y");
        }
    }
}

function navigationSelection(ref) {
    var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&controlId=" + ref.id;
    var url = "portal/appTask.jsp?oper=NavigationSelection";
    CreateIndicator("application");
    new net.ContentLoader(url, navigHandler, generalErrorHandler, "POST", requestString, true);
}

function routeToNavigation(ref, parameters) {
    if(!ref.classList.contains("tile")){
        var tileCtrls=$("[groupname]");
        var grpname="";
        var isGroupSelected=false;
        for(var i=0;i<tileCtrls.length;i++)
        {
            if($(tileCtrls[i]).attr('mandatory')==="true"&&$(tileCtrls[i]).attr('groupname')!==grpname&&$(tileCtrls[i]).attr('groupname')!=="")
            {
                grpname=$(tileCtrls[i]).attr('groupname');
                isGroupSelected=false;
                var tempCtrls=$("[groupname="+grpname+"]");
                for(var j=0;j<tempCtrls.length;j++)
                {
                    var tileBtn=tempCtrls[j];
                    if(tileBtn.style.display==='none')
                    {
                        isGroupSelected=true;
                        break;
                    }
                }
            }else if($(tileCtrls[i]).attr('groupname')==="")
                isGroupSelected=true;
            if(!isGroupSelected)
            {
                break;
            }
        }
        if(!isGroupSelected&&tileCtrls.length!=0)
        {
            getTileGrpError(grpname);
            return false;
        }
    }
    var requestString = "oper=NavigationRoute&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&controlId=" + ref.id + "&parameters=" + encode_utf8(JSON.stringify(parameters));
    var url = "portal/appTask.jsp";
    CreateIndicator("application");
    new net.ContentLoader(url, navigHandler, generalErrorHandler, "POST", requestString, true);
}

function routeToOTP(ref, parameters,flag) {
    var userNameVal;
    if(flag==="1")
    {
        userNameVal= document.getElementById(parameters.UserName).value;
        parameters["UserNameControl"] = parameters.UserName;
        parameters["UserName"] = userNameVal;
        parameters["GetOTP"] = ref.id;        
    }
    else{
        parameters=JSON.parse(parameters);
        userNameVal= parameters.UserName;
    }    
    if (userNameVal == "" || userNameVal == undefined || userNameVal == null) {
       showSplitMessage(parameters.UserName, AUTH_INVALIDUSER,AUTH_INVALIDUSER_TITLE,"error");
    } else {
        var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&controlId=" + ref.id + "&parameters=" + encode_utf8(JSON.stringify(parameters));
        var url = "portal/appTask.jsp?oper=GetOTP";
        CreateIndicator("application");
        new net.ContentLoader(url, OTPHandler, generalErrorHandler, "POST", requestString, true);
    }
}

function generateAppendSidRidInUrl(url)
{
    var sid = sanitize(jQuery("#sid").val(),'string');
    var context = '/' + window.location.pathname.split("/")[1];
    var reqTok = iforms.ajax.processRequest("formuri="+encode_utf8(url), context+"/GetReqToken");
    url = url + "?WD_SID=" + sid + "&WD_RID="+reqTok;
    return url;
}

function navigHandler() {
    RemoveIndicator("application");
    var responseText = this.req.responseText.trim();
    if (responseText != '') {
        var json = JSON.parse(responseText);
        if (json["status"] == "1") {
            var context = '/' + window.location.pathname.split("/")[1];
            var url = context + "/components/viewer/portal/initializePortal.jsp";
            url = generateAppendSidRidInUrl(url);
            if(extendSession == "Y")
                  url += "&ExtendSession=Y";
            window.location.href = url;
        }
        else{ 
            showSplitMessage("", json["message"],NAV_TITLE, "error");
        }
    }
}

function routeToNextForm(ref, parameters) {
    var userNameVal = document.getElementById(parameters.UserName).value;
    var passWordVal = document.getElementById(parameters.UserAuth).value;
    parameters["userNameVal"] = userNameVal;
    parameters["passWordVal"] = passWordVal;
    
    if (userNameVal == "" || userNameVal == undefined || userNameVal == null) {
        showSplitMessage(parameters.UserName, AUTH_UNSUCCESSFUL,AUTH_UNSUCCESSFUL_TITLE, "error",false);
    } else if (passWordVal == "" || passWordVal == undefined || passWordVal == null) {
        showSplitMessage(parameters.UserAuth, BLANK_AUTH,AUTH_UNSUCCESSFUL_TITLE,"error",false);
    } else {
        if(window.routeCriteriaForm)
        {
            var formName=window.routeCriteriaForm();
            if(formName!="")
                parameters.FormName=formName;
        }
        var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&controlId=" + ref.id + "&parameters=" + encode_utf8(JSON.stringify(parameters));
        var url = "portal/appTask.jsp?oper=Authorization";
        CreateIndicator("application");
        new net.ContentLoader(url, routingHandler, generalErrorHandler, "POST", requestString, true);
    }
}

function getTileGrpError(tileGroupId)
{
    var requestString = "oper=getTileGrpError&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&tileGroupId=" + tileGroupId;
    var url = "portal/appTask.jsp";
    CreateIndicator("application");
    new net.ContentLoader(url, showTileMandatoryMsg, generalErrorHandler, "POST", requestString, true);
}

function showTileMandatoryMsg()
{
    RemoveIndicator("application");
    showSplitMessage(" ",this.req.getResponseHeader("errorMessage"),MANDATORY_TITLE,"warning",false);
}

function generalErrorHandler() {
    RemoveIndicator("application");
    if (this.req.getHeader("InvalidSession") == "Y")
        showAlertDialog("<b>" + INVALID_SESSION + "</b>", false);
    else
        showConfirm("There is some Error in Processing Request.Please try again.")
}

function OTPHandler() {
    RemoveIndicator("application");
    var responseText = this.req.responseText.trim();
    responseText=sanitize(responseText);
    if (responseText != '') {
        var json = JSON.parse(responseText);
        var userName = sanitize(json["UserName"],'string');
        var OTPField = sanitize(json["OTPField"],'string');
        var LOGIN = sanitize(json["LOGIN"],'string');
        var CANCELLOGIN = sanitize(json["CANCELLOGIN"],'string');
        var RESEND = sanitize(json["RESEND"],'string');
        var OTPEXPIRESIN = sanitize(json["OTPEXPIRESIN"],'string');
        var GETOTP = sanitize(json["GetOTP"],'string');
        var UserNameControl = sanitize(json["UserNameControl"],'string');
        var FormName = sanitize(json["FormName"],'string');
        if (json["status"] === "1") {
           document.getElementById(UserNameControl).style.display="none";
           if(document.getElementById(UserNameControl+"_label"))
            document.getElementById(UserNameControl+"_label").style.display="none";
           document.getElementById(OTPField).style.display="";
           document.getElementById(GETOTP).style.display="none";
           if(document.getElementById(OTPField+"_label")){
                document.getElementById(OTPField+"_label").style.display="";
                document.getElementById(OTPField+"_label").parentNode.parentNode.style.display="";
                document.getElementById(OTPField+"_label").parentNode.parentNode.parentNode.style.display="";
            }
           document.getElementById(OTPField).parentNode.parentNode.style.display="";
           document.getElementById(LOGIN).style.display="";
           document.getElementById(LOGIN).parentNode.parentNode.style.display="";
           document.getElementById(LOGIN).setAttribute("onclick","matchOTP('"+userName+"','"+OTPField+"','"+FormName+"')");
           document.getElementById(CANCELLOGIN).style.display="";
           document.getElementById(CANCELLOGIN).parentNode.parentNode.style.display="";
           document.getElementById(CANCELLOGIN).setAttribute("onclick","cancelLogin('"+sanitize(responseText)+"')");
           document.getElementById(RESEND).style.display="";
           document.getElementById(RESEND).parentNode.parentNode.style.display="";
           var ref=document.getElementById(GETOTP);
           var parameters = {"OTPField":OTPField,"LOGIN":LOGIN,"CANCELLOGIN":CANCELLOGIN,"RESEND":RESEND,"OTPEXPIRESIN":OTPEXPIRESIN,"FormName":FormName,"UserNameControl":UserNameControl,"UserName":userName,"GetOTP":GETOTP};
           var refNode=document.querySelector('#'+RESEND);
           var didntgetotp = document.createElement('label');
           didntgetotp.id="didntgetotp";
           didntgetotp.innerHTML=DIDNT_GET_OTP;
           didntgetotp.className="labelStyle";
           didntgetotp.style="padding-right:15px;";
           refNode.before(didntgetotp);
           var otpSendLabel = document.createElement('label');
           otpSendLabel.id="OTPSendLabel";
           otpSendLabel.innerHTML=sanitize(OPT_SEND_MSG+" "+userName,'string');
           otpSendLabel.className="labelStyle col-sm-12";
           document.getElementById(RESEND).setAttribute("onclick","clearControls();routeToOTP('"+ref.id+"','"+JSON.stringify(parameters)+"','2')");
           var timerLabel = document.createElement('label');
           timerLabel.id="timerLabel";
           timerLabel.className="labelStyle";
           var referenceNode = document.querySelector('#'+OTPField);
           referenceNode.after(timerLabel);
           if(document.getElementById(OTPField+"_label")){
               var referenceNode1 = document.querySelector('#'+OTPField+"_label").parentNode.parentNode.parentNode;
               referenceNode1.before(otpSendLabel);
           }
           else
               referenceNode.before(otpSendLabel);
           var timeLeft = OTPEXPIRESIN;
           var elem = document.getElementById('timerLabel');
           var timerId = setInterval(countdown, 1000);
           function countdown() {
              if (timeLeft == 0) {
                clearTimeout(timerId);
                var otpExpireMsg=OTP_EXPIRED_MSG;
                otpExpireMsg=otpExpireMsg.replace("<>",userName);
                elem.innerHTML=sanitize(OTP_EXPIRED+"<br>"+otpExpireMsg);
                elem.className="labelStyle";
                document.getElementById(LOGIN).style.display="none";
                document.getElementById(LOGIN).parentNode.parentNode.style.display="none";
                document.getElementById(LOGIN).removeAttribute('onclick');
                didntgetotp = document.getElementById('didntgetotp');
                didntgetotp.parentNode.removeChild(didntgetotp);
                otpSendLabel = document.getElementById('OTPSendLabel');
                otpSendLabel.parentNode.removeChild(otpSendLabel);
                document.getElementById(OTPField).style.display="none";
                if(document.getElementById(OTPField+"_label")){
                     document.getElementById(OTPField+"_label").style.display="none";
                     document.getElementById(OTPField+"_label").parentNode.parentNode.style.display="none";
                     document.getElementById(OTPField+"_label").parentNode.parentNode.parentNode.style.display="none";
                 }
                document.getElementById(OTPField).parentNode.parentNode.style.display="none";
                referenceNode = document.querySelector('#'+RESEND).parentNode.parentNode;
                referenceNode.before(elem);
                clearOTP(userName);
              } else {
                elem.innerHTML = timeLeft + ' seconds remaining';
                elem.className="labelStyle";
                timeLeft--;
              }
        }
        }
        else if(json["status"]=="0"){  
            if (userName == null || userName == undefined) {
                showSplitMessage(json.un, json["message"],AUTH_UNSUCCESSFUL_TITLE, "error");
            } 
        }
    }
}

function clearControls()
{
    var otpSendLabel = document.getElementById('OTPSendLabel');
    otpSendLabel.parentNode.removeChild(otpSendLabel);
    otpSendLabel = document.getElementById('timerLabel');
    otpSendLabel.parentNode.removeChild(otpSendLabel);
    otpSendLabel = document.getElementById('didntgetotp');
    otpSendLabel.parentNode.removeChild(otpSendLabel);
}

function clearOTP(userNameVal)
{
    var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&userNameVal=" + encode_utf8(userNameVal);
    var url = "portal/appTask.jsp?oper=ClearOTP";
    CreateIndicator("application");
    new net.ContentLoader(url, clearOTPHandler, generalErrorHandler, "POST", requestString, true);

}

function clearOTPHandler()
{
    RemoveIndicator("application");
}
function cancelLogin(responseText)
{
    if (responseText != '') {
        var json = JSON.parse(responseText);
        var OTPField = json["OTPField"];
        var LOGIN = json["LOGIN"];
        var CANCELLOGIN = json["CANCELLOGIN"];
        var RESEND = json["RESEND"];
        var GETOTP = json["GetOTP"];
        var userNameControl=json["UserNameControl"];
        document.getElementById(userNameControl).removeAttribute("disabled");
        document.getElementById(userNameControl).value="";
        document.getElementById(userNameControl).style.display="";
        if(document.getElementById(userNameControl+"_label"))
            document.getElementById(userNameControl+"_label").style.display="";
        document.getElementById(OTPField).style.display="none";
        document.getElementById(OTPField).value="";
        document.getElementById(OTPField+"_label").style.display="";
        document.getElementById(OTPField+"_label").parentNode.parentNode.style.display="none";
        document.getElementById(OTPField+"_label").parentNode.parentNode.parentNode.style.display="none";
        document.getElementById(OTPField).parentNode.parentNode.style.display="none";
        document.getElementById(LOGIN).style.display="none";
        document.getElementById(LOGIN).removeAttribute('onclick');
        document.getElementById(CANCELLOGIN).style.display="none";
        document.getElementById(RESEND).style.display="none";
        document.getElementById(GETOTP).style.display="";
        var timerLabel = document.getElementById('timerLabel');
        timerLabel.parentNode.removeChild(timerLabel);
        timerLabel = document.getElementById('didntgetotp');
        timerLabel.parentNode.removeChild(timerLabel);
        
    }
}

function matchOTP(userName,OTPField,FormName)
{
    var otp=document.getElementById(OTPField).value;
    if (otp == "" || otp == undefined || otp == null) {
        showSplitMessage(otp, AUTH_INVALIDUSER,AUTH_UNSUCCESSFUL_TITLE,"error");
    } else {
        var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) +  "&userName="+userName+"&otp="+otp+"&nextFormName="+FormName;
        var url = "portal/appTask.jsp?oper=CheckOTP";
        CreateIndicator("application");
        new net.ContentLoader(url, CheckOTPHandler, generalErrorHandler, "POST", requestString, true);
    }
    
}

function CheckOTPHandler()
{
    RemoveIndicator("application");
    var responseText = this.req.responseText.trim();
    if (responseText != '') {
        var json = JSON.parse(responseText);
        if (json["status"] == "1") {
            alert("OTP match");
            var context = '/' + window.location.pathname.split("/")[1];
            var url = context + "/components/viewer/portal/initializePortal.jsp";
            url = generateAppendSidRidInUrl(url);
            window.location.href = url;
        }
        else{
            if (userName == null || userName == undefined) {
                showSplitMessage(json.un, json["message"],AUTH_UNSUCCESSFUL_TITLE,"error");
            } 
        }       
    }
}

function routingHandler() {
    RemoveIndicator("application");
    var responseText = this.req.responseText.trim();
    if (responseText != '') {
        var json = JSON.parse(responseText);
        var userName = json["UserName"];
        if (json["status"] == "1") {
            var context = '/' + window.location.pathname.split("/")[1];
            var url = context + "/components/viewer/portal/initializePortal.jsp";
            url = generateAppendSidRidInUrl(url);
            window.location.href = url;
        }
        else if(json["status"]=="0"){  
            if (userName == null || userName == undefined) {
                document.getElementById(json.un).value = "";
                document.getElementById(json.pw).value = "";
                showSplitMessage(json.un, json["message"],AUTH_UNSUCCESSFUL_TITLE,"error");
            } else {
                document.getElementById(json.un).value = userName;
                document.getElementById(json.pw).value = "";
                showSplitMessage(json.pw, json["message"],AUTH_UNSUCCESSFUL_TITLE,"error");
            }
        }else if(json["status"]=="2"){ //Bug 99827 
            var captchacontrol=document.getElementById(json.captchacontrol+'_btnRefreshCaptcha');
            renderCaptchaImage(captchacontrol);
            showSplitMessage(json.un, json["message"],AUTH_UNSUCCESSFUL_TITLE,"error");            
        }
    }
}

function generateSequenceForApp() {
    var seqNo = "";
    if (window.customSequenceForApp) {
        seqNo = window.customSequenceForApp();
    }

    var url = "portal/appTask.jsp";
    var queryString = "oper=UpdateUniqueNo&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&seqNo=" + encode_utf8(seqNo);
    var responseText = iforms.ajax.processRequest(queryString, url);
    if (responseText.trim() !== "0") {
        showMessage("", "Error in Generating Sequence..", "error");
    }
}

function loadFragment(ref, parentIndex, childIndex) {
    var url = "action_API.jsp";
    if(navigationClick==="1"){
        var queryStr = "&pid=" + pid + "&wid=" + wid + "&taskid=" + tid + "&fid=" + fid + "&checkValidationOnStep=Y";
        var resp = iforms.ajax.processRequest(queryStr, url);
        resp = resp.trim();
        if (resp == "true") {
            validateMandatoryFields();
            return true;
        }
    }
    if(ref.classList.contains("active") && navigationClick !== "2" && !getDeviceType()){
        return;
    }
    if(document.getElementById("menuParentDiv")!=null || document.getElementById("menuParentDiv")!=undefined){
            $("#menuModal").css("display","none");
    }
    var queryString = "loadFragment=Y&parentIndex=" + parentIndex + "&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid)+"&RegisteredMode="+registeredMode + "&filterValue=" + filterValue+"&navigationClick="+navigationClick;
    if (ref.getAttribute("type") != undefined)
        queryString += "&type=" + ref.getAttribute("type");
    if (parentIndex == '0' && (childIndex == 0 || childIndex == undefined)) {
        jQuery('#navigationBackBtn').css('pointer-events', 'none');
        jQuery('#navigationBackBtn').css('cursor', 'auto');
        jQuery('#navigationBackBtn').css('opacity', '0.50');
        jQuery('#navigationBackBtn').css('box-shadow', 'none');
    } else {
        jQuery('#navigationBackBtn').css('pointer-events', 'all');
        jQuery('#navigationBackBtn').css('cursor', 'pointer');
        jQuery('#navigationBackBtn').css('opacity', '6');
    }
    if (typeof childIndex != "undefined") {
        queryString += "&childIndex=" + childIndex;
    }
    if(getDeviceType()){
        if(typeof applicationName!='undefined' && (applicationName==null || applicationName==''))
            saveForm("S", true); 
        else{
            if(isNavigationNextClick === true)
                saveForm("SF", true);
            else
                saveForm("SB", true);
        }
        
        setMenuStyle(ref);
    }
    else{
        if (window.enableNavigationStepClickHook)
        {
            var enableNavigationStepClick = false;
            enableNavigationStepClick = enableNavigationStepClickHook();
            if (enableNavigationStepClick) {
                if (!validations()) {
                    return false;
                }
                if (typeof applicationName != 'undefined' && (applicationName == null || applicationName == ''))
                    saveForm("S", true);
                else{
                    if(isNavigationNextClick === true)
                        saveForm("SF", true);
                    else
                        saveForm("SB", true);
            }
        }
        }
        setNavigationStyle(ref);
    }
    
    new net.ContentLoader(url, loadFragmentHandler, generalErrorHandler, "POST", queryString, true);


}
function setMenuStyle(ref){
    var childStep;
    var parentStep;
    if(document.getElementById("menuParentDiv")==null && document.getElementById("menuParentDiv")==undefined){
        $('#submenu').css('width','0');
        $("#fade").css({"width":"100%" , "left":"0" , "display":"none"});
         $(".sideMenuNavigationBar li").each(function(){
                $(this).removeClass("active");
            });
            $(ref).addClass("active");
        if($(ref).hasClass("sideMenuItem")){
                parentStep = $(ref).find(".sideMenuLabelParent").text();
               $(".parentStep").text(parentStep);
               $(".parentStep").addClass("stepcolor");
               $(".childStep").text(" ");
        } else if ($(ref).hasClass("sideSubMenuChild")){
                $(ref).parent().parent().parent().parent().parent().addClass("active");
                 childStep = $(ref).find(".sideMenuChildLabelParent").text();
                 parentStep = $(ref).parent().parent().parent().find(".sideMenuLabelParent").text();
                 $(".parentStep").text(parentStep+' / ');
                 $(".parentStep").removeClass("stepcolor");
                 $(".childStep").text(childStep);
                 $(".childStep").addClass("stepcolor");
        }
    } else {
            var index , elem;

            $(".sideMenuNavigationBar li").each(function(){
                $(this).removeClass("active");
            });
            $(".menuSelected").each(function(){$(this).removeClass("menuSelected")})
            $(ref).addClass("active");
            if($(ref).hasClass("sideMenuItem")){
                $(ref).find(".sideMenuLabelParent").addClass("menuSelected")
                parentStep = $(ref).find(".sideMenuLabelParent").text();
               $(".parentStep").text(parentStep);
               $(".parentStep").addClass("stepcolor");
               $(".childStep").text(" ");
                index = $(ref).index();
                elem = $($(".stepNavigationContainerParent .navigationProgressBar li")[index]);
                $(".stepNavigationContainerParent .navigationProgressBar li").each(function(){
                      $(this).removeClass("active");
                      $(this).removeClass("completed");
                  });
                elem.prevAll().each(function(){
                    $(this).removeClass("active");
                    $(this).addClass("completed");
                });

                elem.attr('class','active');

            } else if ($(ref).hasClass("sideSubMenuChild")){
                $(ref).find(".sideMenuChildLabelParent").addClass("menuSelected");
                 childStep = $(ref).find(".sideMenuChildLabelParent").text();
                 parentStep = $(ref).parent().parent().parent().find(".sideMenuLabelParent").text();
                 $(".parentStep").text(parentStep+' / ');
                 $(".parentStep").removeClass("stepcolor");
                 $(".childStep").text(childStep.substring(3));
                 $(".childStep").addClass("stepcolor");
                  index = $(ref).parent().parent().parent().parent().parent().index();
                  elem = $($(".stepNavigationContainerParent .navigationProgressBar li")[index]);
                  $(".stepNavigationContainerParent .navigationProgressBar li").each(function(){
                      $(this).removeClass("active");
                      $(this).removeClass("completed");
                  });
                  elem.prevAll().each(function(){
                    $(this).addClass("completed");
                });
                 elem.attr('class','active');
                 $(ref).parent().parent().parent().parent().parent().addClass("active");
            }
    }
        
    
}
function putDataInMenu(){
    if(document.getElementById("menuParentDiv")==null){
    var queryString = "createMenu=Y" + "&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid)+"&RegisteredMode="+registeredMode + "&filterValue=" + filterValue;
    var url = "action_API.jsp";
    new net.ContentLoader(url, loadMenu, generalErrorHandler, "POST", queryString, true);
    }
}
function createMenu(){
     if(document.getElementById("menuModal")!=null && document.getElementById("menuModal")!=undefined){
         if(typeof applicationName!='undefined' && (applicationName==null || applicationName==''))
            saveForm("S", true); 
         else
            saveForm("SF", true);
         $("#menuModal").css("display","block");
     }
}
function loadMenu(){
    var resp = sanitize(this.req.responseText.trim(),'html');
    $("#menuModal").find(".appendmenumodal").append(resp);
}

function checkForExistingApplication() {
    if (typeof (filterValue) !== 'undefined' && filterValue === "") {
        var url = "portal/appTask.jsp";
        var queryString = "oper=CheckExisting&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
        new net.ContentLoader(url, checkHandler, commonErrorHandler, "POST", queryString, true);
    }
}

function updateDocComment(ref) {
    var comment = ref.value;
    var controlid=ref.id;
    var fileName = $($(ref).parent().parent().find('.doc-unit-name p')[0]).text();
    var documentType = ref.closest(".doc-list-unit").querySelector(".doc-unit-header .identifer").id;
    if(jQuery(ref).attr("required") != undefined){
    if(document.getElementById(controlid+"_label")!=null){
                 $(document.getElementById(controlid+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                 $(document.getElementById(controlid+"_label")).addClass('mandatoryLabel');
                 document.getElementById(controlid+"_msg").removeAttribute("showMessage");
                 $(document.getElementById(controlid)).removeClass('mandatory');
                 delete ComponentValidatedMap[controlid];
            }
    }
    var docId = jQuery(ref).parent().prev().find(".doc-unit-name").attr("data-docid");
    ref = jQuery(ref).parent().parent();
    var ctrId = jQuery(ref.parents(".doc-list-body")[0]).attr("id");
    var url = "portal/appTask.jsp";
    var queryString = "oper=UpdateDocComment&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&ctrId=" + encode_utf8(ctrId) + "&docId=" + docId + "&comment=" + encode_utf8(comment) + "&fileName=" + encode_utf8(fileName)+ "&doctype=" + encode_utf8(documentType);
    iforms.ajax.processRequest(queryString, url);
}


function updateWaiverDocComment(ref) {
    var comment = ref.value;
    var controlid=ref.id;
    if(jQuery(ref).attr("required") != undefined){
    if(document.getElementById(controlid+"_label")!=null){
        $(document.getElementById(controlid+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
        $(document.getElementById(controlid+"_label")).addClass('mandatoryLabel');
        document.getElementById(controlid+"_msg").removeAttribute("showMessage");
        $(document.getElementById(controlid)).removeClass('mandatory');
        delete ComponentValidatedMap[controlid];
    }
    }
    ref = jQuery(ref).parent().parent();
    var docId = jQuery(ref).parent().find(".doc-unit-detail").attr("data-docid");    
    var ctrId = jQuery(ref.parents(".doc-list-body")[0]).attr("id");
    var url = "portal/appTask.jsp";
    var queryString = "oper=UpdateWaiverDocComment&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&ctrId=" + encode_utf8(ctrId) + "&docId=" + encode_utf8(docId) + "&comment=" + encode_utf8(comment);
    iforms.ajax.processRequest(queryString, url);   
}


function deletedoc(ctrId, docId, fileName) {
    var url = "portal/appTask.jsp";
    var queryString = "oper=DeleteDoc&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&ctrId=" + encode_utf8(ctrId) + "&docId=" + docId + "&fileName=" + encode_utf8(fileName);
    var contentLoaderRef = new net.ContentLoader(url,commonHandler,commonErrorHandler, "POST", queryString, false);        
}

function commonHandler(){
    
}

function commonErrorHandler(){
    
}

function showAlertDialog(msg, isClose, timeoutInMills)
{
    var defaultTimeout = 3000;
    if(timeoutInMills !== null && timeoutInMills !== undefined && timeoutInMills !== 'undefined' && timeoutInMills !== ''){
        defaultTimeout = timeoutInMills;
    }
    var box = bootbox.dialog({
        message: msg,
        closeButton: isClose,
        size: "small"
    });

    setTimeout(function () {
        box.modal('hide');
    }, defaultTimeout);
}

function checkHandler() {
    var resp = this.req.responseText;
    resp=sanitize(resp.trim(),'string');
    var jsonobj,filterval,context,url;
    if (resp !== "" && (alwaysCreate==null || alwaysCreate=='' || alwaysCreate=='N') && (DeleteOldApplicationData==null || DeleteOldApplicationData=='' || DeleteOldApplicationData=='Y')) {
        var btns = {
            confirm: {
                label: OPEN_APPLICATION,
                className: 'btn-success'
            },
            cancel: {
                label: CREATE_NEW,
                className: 'btn btn-primary'
            }
        }
        jsonobj = JSON.parse(decode_utf8(resp));
        filterval = sanitize(jsonobj.txnid,'string');
        var stage = sanitize(jsonobj.currentstage,'string');
        var navigationPage="";
        if(window.redirectToNavigation)
        {
            navigationPage=window.redirectToNavigation();
        }
        context = '/' + window.location.pathname.split("/")[1];
        url = context + "/components/viewer/portal/initializePortal.jsp";
        url = generateAppendSidRidInUrl(url);
        var redirectURL = url+"&FilterValue=" + filterval;
        if(navigationPage.trim != "")
            redirectURL+="&navigationPage="+navigationPage;
        var userAction = function (result) {
            
            if (result === true) {
                openExistingTransaction(redirectURL,context,stage);                 
            }
            else if(result === false){
                window.location.href = redirectURL + "&new=Y";
            }
        }
        if(alwaysOpenOldTransaction!=='' && alwaysOpenOldTransaction==='Y'){
            openExistingTransaction(redirectURL,context,stage);
        }else{
            showConfirmDialog("<b>"+EXIST_APPLICATION+"<br>"+SELECT_EXIST_APPLICATION+"<b>", btns, userAction);
        }
    } else if(resp !== "" && (alwaysCreate!=null || alwaysCreate=='Y' || DeleteOldApplicationData!=null || DeleteOldApplicationData=='N')) {
        jsonobj = JSON.parse(decode_utf8(resp));
        filterval = sanitize(jsonobj.txnid,'string');
        context = '/' + window.location.pathname.split("/")[1];
        url = context + "/components/viewer/portal/initializePortal.jsp";
        url = generateAppendSidRidInUrl(url);
        window.location.href = url+"&FilterValue=" + filterval+"&new=Y";
    }
}

function openExistingTransaction(redirectURL,context,stage){
    var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
    var url = context + "/components/viewer/portal/appTask.jsp";
    url = generateAppendSidRidInUrl(url);
    url = url+"&oper=fetchSavedState";
    CreateIndicator("application");
    var responseText = iforms.ajax.processRequest(requestString, url);
    if (responseText.trim() != '') {
        var json = JSON.parse(responseText);
        var isWidget = json["ISWidget"];
        if(isWidget === "No"){
            var url = context + "/components/viewer/portal/initializePortal.jsp";
            url = generateAppendSidRidInUrl(url);
            window.location.href = url;
        }
        else
        {
            var widgetHTML = json["widgetHTML"];
            var parentHTML = json["parenttHTML"];
            var parentIndex = json["ParentIndex"];
            var childIndex = json["ChildIndex"];
            var firstStep = json["FirstStep"];
            var lastStep = json["LastStep"];
            loadwidget(parentHTML,widgetHTML,parentIndex,childIndex,firstStep,lastStep);      
        }
    }else{
        window.location.href = redirectURL + "&AppStage=" + stage;
    }
    RemoveIndicator("application");   
}
function loadFragmentHandler() {
    var transactionIdHeader = this.req.getResponseHeader("transactionId");
    if (transactionIdHeader !== null && transactionIdHeader !== "") {
        transactionId = transactionIdHeader;
    }
    var parentIndex = getQueryVariable(this.params, "parentIndex");
    var childIndex = getQueryVariable(this.params, "childIndex");
    var fragmentContainer;  
    var responseText = this.req.responseText;
    responseText=sanitize(responseText.trim(),'html');
    if(responseText=="false"){
        document.getElementById("navigationBackBtn").click();
        document.getElementById("fade").style.display="none";        
        return;
    }
    try{
    if (typeof childIndex != "undefined") {
        fragmentContainer = document.getElementById("fragmentContainer");
        jQuery(fragmentContainer).html(responseText);
    }
    else{
        var verNavFragParent = document.getElementById("verNavFragParent");
        if (verNavFragParent != null) {
            jQuery(verNavFragParent).html(sanitize(responseText,'html'));
        }
        else{
            fragmentContainer = document.getElementById("fragmentContainer");
            jQuery(fragmentContainer).html(sanitize(responseText,'html'));
        }
    }
    }catch(ex){}
    if(window.stepLoadPostHook){
        stepLoadPostHook(parentIndex,childIndex);
    }
    var isFirst = "Y" === this.req.getResponseHeader("FirstStep");
    if (isFirst) {
        jQuery('#navigationBackBtn').css('pointer-events', 'none');
        jQuery('#navigationBackBtn').css('cursor', 'auto');
        jQuery('#navigationBackBtn').css('opacity', '0.50');
        jQuery('#navigationBackBtn').css('box-shadow', 'none');
    } else {
        jQuery('#navigationBackBtn').css('pointer-events', 'all');
        jQuery('#navigationBackBtn').css('cursor', 'pointer');
        jQuery('#navigationBackBtn').css('opacity', '6');
    }



    var isLast = "Y" === this.req.getResponseHeader("LastStep")
    if (isLast) {
        document.getElementById("finalSubmitBtn").style.display = "";
        document.getElementById("navigationNextBtn").style.display = "none";
        if(getDeviceType()==true)
        document.getElementById("navigationNextBtn").parentNode.style.display = "none";
    }
    else
    {
        document.getElementById("finalSubmitBtn").style.display = "none";
        document.getElementById("navigationNextBtn").style.display = "";
        document.getElementById("navigationNextBtn").parentNode.style.display = "";
    }
    var type = getQueryVariable(this.params, "type");
    if (type === "5")
    {
        if(document.getElementsByClassName("verticalNavigationContainer")[0]!=undefined)
        {
            var subStepParent = document.getElementsByClassName("verticalNavigationContainer")[0].childNodes[0];
            if (subStepParent.childNodes.length != 0)
            {
                var lastIndex = subStepParent.childNodes.length - 1;
                var b = $("[type=5]").length;
                for (var i = 0; i < b; i++)
                {
                    $($("[type=5]")[0]).removeAttr('type');
                }
                //Clicking the last substep.
                subStepParent.childNodes[lastIndex].click();
            }
    }    
    }
    setProgressBar();
    alignNavigationContainerStyle();
    doInit('fragment',navigationClick);
    navigationClick="";
    executeLoadEvents("7");
    document.getElementById("fade").style.display="none"; //Bug 102425 
}

function setNavigationStyle(ref) {
    if ($(ref).hasClass("verticalNavigationProgressBar-item")) {
        $($(ref).closest('ul')[0]).find('li').each(function () {
            $(this).removeClass("current");
            $(this).removeClass("completed");
            $(this).removeClass("over50");
        });
        $(ref).prevAll().each(function () {
            $(this).addClass("completed");
        });
        $(ref).addClass("current");
        $(ref).addClass("over50");
    }
    else if($(ref).hasClass("sideMenuItem")){
        $($(ref).closest('ul')[0]).find('.sideMenuItem').each(function () {
            $(this).removeClass("active");
        });
        $(ref).addClass("active");
        $($(ref).find(".sideMenuChildNavigationBar")[0]).find('li').each(function () {
            $(this).removeClass("active");
        });
        $($($(ref).find(".sideMenuChildNavigationBar")[0]).find('li')[0]).addClass("active");
    }
    else{
        $($(ref).closest('ul')[0]).find('li').each(function () {
            $(this).removeClass("active");
            $(this).removeClass("completed");
        });
        $(ref).prevAll().each(function () {
            $(this).addClass("completed");
        });
        $(ref).addClass("active");
    }
}

function alignNavigationContainerStyle() {
    var headerHeight = 0;
    var isheader=false;
    if(typeof $(".headerframe")[0] !== "undefined" && $($(".headerframe")[0]).find(".form-group").length > 0){
        if(typeof $(($(".headerframe").eq(0).parent())[0]).attr('id')!= "undefined" && $(($(".headerframe").eq(0).parent())[0]).attr('id') == "oforms_iform")
        {
            headerHeight=document.getElementsByClassName('headerframe')[0].firstElementChild.offsetHeight+8;
            isheader=true;
        }
    }
    
    if(isheader && (parseInt(window.innerHeight)<parseInt(headerHeight*3))){
        headerHeight=0;
    }
    if(document.getElementById("subformbtndiv")!=null){
        var subDivHeight=document.getElementById("subformbtndiv").offsetHeight;
        jQuery("#oforms_iform").css("height",jQuery("body").height()-subDivHeight);
        jQuery("#oforms_iform").css("padding-bottom","0px");
        jQuery("#oforms_iform").css("overflow","auto");
    }
    else
        jQuery("#oforms_iform").css("height",jQuery("body").height());
    
    var footer = 0;
    if($(".fragmentFooter").css("display")!="none"){
        footer = $(".fragmentFooter").outerHeight();
    }
    var portal = 0;
    if(document.getElementById("portalicon")!=null){ 
        portal = $("#portalicon").outerHeight();
    }
    var windowHeight = $(window).outerHeight();
    var containerHeight;
    var stepNavigationTopBarHeight;
    var menu;
    if ($('.stepNavigationContainerParent')[0] != null) {  //NavStyle 1
        
        if(document.getElementById("menuContainer")!=null){  //PWA
            var step = 0;
            if($(".stepName").css("display")!="none")
               step = $(".navigationContainer").outerHeight()+ $(".stepName").outerHeight();
            $($(".stepNavigationContainerParent")[0]).outerHeight(step);
            containerHeight = windowHeight - step; 
            containerHeight -= portal;
            
            if(isheader && document.getElementById("portalicon")!=null)
                   $($(".headerframe")[0]).css("margin-top", 15+portal+"px");
            if(!isheader && document.getElementById("portalicon")!=null ){  
                if($($(".stepNavigationContainerParent")[0]).css("display")!="none")
                    $($(".stepNavigationContainerParent")[0]).css("margin-top", (portal+headerHeight)+"px");
                else
                    $($(".fragmentContainerParent")[0]).css("margin-top", (portal+headerHeight)+"px");
            } 
            
            $($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);
            $($(".fragmentContainer")[0]).outerHeight(containerHeight - headerHeight - footer);
        }
        else if(document.getElementById("verticalNavigationContainerParent")!=null){ //Web
            stepNavigationTopBarHeight = 0;
            if($($('.stepNavigationContainerParent')[0]).css("display")!="none")
                 stepNavigationTopBarHeight = $($('.stepNavigationContainerParent')[0]).outerHeight();
            containerHeight = windowHeight - stepNavigationTopBarHeight ;
            if(document.getElementById("portalicon")){
                if($($(".headerframe")[0]).find(".form-group").length > 0 && isheader == true)
                {
                    $($(".headerframe")[0]).css("margin-top", 15+portal+"px");
                    if($($(".stepNavigationContainerParent")[0]).css("display")!="none")
                          $($(".stepNavigationContainerParent")[0]).css("margin-top", "0px");
                    else
                         $($(".fragmentContainerParent")[0]).css("margin-top", "0px");
                }
                else 
                {
                    if($($(".stepNavigationContainerParent")[0]).css("display")!="none")
                        $($(".stepNavigationContainerParent")[0]).css("margin-top", portal+"px");
                    else
                        $($(".fragmentContainerParent")[0]).css("margin-top", portal+"px");
                }
            	containerHeight -= portal;
            	$($(".verticalNavigationContainerParent")[0]).outerHeight(containerHeight - headerHeight);
            	$($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);
               $($(".fragmentContainer")[0]).outerHeight(containerHeight - headerHeight - footer);
            }
            else
            {
                $($(".verticalNavigationContainerParent")[0]).outerHeight(containerHeight - headerHeight);
            	$($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);
               $($(".fragmentContainer")[0]).outerHeight(containerHeight - headerHeight - footer);
            }
        }
        else
        { //WEB
            stepNavigationTopBarHeight = 0;
            if($($('.stepNavigationContainerParent')[0]).css("display")!="none")
                 stepNavigationTopBarHeight = $($('.stepNavigationContainerParent')[0]).outerHeight();
            containerHeight = windowHeight - stepNavigationTopBarHeight;
            if(document.getElementById("portalicon")){
            	containerHeight -= portal;
                if(isheader==true)
                {
                    $($(".headerframe")[0]).css("margin-top", 15+portal+"px");
                }
                else
                {
                  if($($('.stepNavigationContainerParent')[0]).css("display")!="none")
                    $($(".stepNavigationContainerParent")[0]).css("margin-top", portal+"px");
                  else
                      $($(".fragmentContainerParent")[0]).css("margin-top", portal+"px");
                }
                $($(".verticalNavigationContainerParent")[0]).outerHeight(containerHeight - headerHeight);
            	$($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);
               $($(".fragmentContainer")[0]).outerHeight(containerHeight - headerHeight - footer);
                
            }
            else{
            	$($(".verticalNavigationContainerParent")[0]).outerHeight(containerHeight - headerHeight);
            	$($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);
               $($(".fragmentContainer")[0]).outerHeight(containerHeight - headerHeight - footer);
            }
        }
        menu = $(".stepNavigationContainerParent .navigationProgressBar li");
        $(menu).each(function(i,elem){
            $(elem).find("svg").attr("width","20px");
            $(elem).find("svg").attr("height","20px");
            $(elem).find("svg").attr("top","20px");
            jQuery(elem).find(".progressBarText").css("display","");
            if ($(elem).hasClass("active")){
                recursion($(elem).find("svg"),$(elem).attr("activecolor"));
            } else {
                recursion($(elem).find("svg"),$(elem).attr("inactivecolor"));
            }
        });
    }
    else if($('.sideMenuNavigationBarParent')[0]!=null){ //Nav Style 2 submenu checks for PWA
        containerHeight = windowHeight;
        if(document.getElementById("submenu")!=null && document.getElementById("submenu")!=undefined && $(".stepName").css("display")!="none")
            containerHeight = containerHeight -  $(".stepName").outerHeight();
        if(document.getElementById("portalicon")){
            containerHeight -= portal;
            if(document.getElementById("submenu")!=null && document.getElementById("submenu")!=undefined){
        	$($(".sideMenuNavigationBarParent")[0]).outerHeight(windowHeight);
                 $($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);
                 $("#fragmentContainer").outerHeight(containerHeight - headerHeight - footer);
            }
            else{
        	$($(".sideMenuNavigationBarParent")[0]).outerHeight(containerHeight - headerHeight);
                $($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);
                 $("#fragmentContainer").outerHeight(containerHeight - headerHeight - footer);
            }
            
                if(isheader==true)
                {
                   $($(".headerframe")[0]).css("margin-top", 15+portal+"px"); 
                }
                else
                {
                    if(document.getElementById("submenu")!=null && document.getElementById("submenu")!=undefined && $(".stepName").css("display")!="none"){
                       $(".stepName").css("margin-top" , portal+"px");
                    }
                    else{
                        if($(".sideMenuNavigationBarParent").css("display")!="none")
                            $(".sideMenuNavigationBarParent").css( 'margin-top' , portal+"px");   
                       $(".fragmentContainerParent").css( 'margin-top' , portal+"px");
                    }
                }
               
        }
        else
        {
            if($(".sideMenuNavigationBarParent").css("display")!="none"){
                if(document.getElementById("submenu")!=null && document.getElementById("submenu")!=undefined)
                    $($(".sideMenuNavigationBarParent")[0]).outerHeight(windowHeight);
                else
                    $($(".sideMenuNavigationBarParent")[0]).outerHeight(containerHeight - headerHeight);
            }
            $($(".fragmentContainerParent")[0]).outerHeight(containerHeight - headerHeight);	
            $("#fragmentContainer").outerHeight(containerHeight - headerHeight - footer);
        }
        //icons only for web 
        menu = $(".sideMenuNavigationBarParent  .sideMenuNavigationBar li");
        if(  document.getElementById("submenu")==null || document.getElementById("submenu")==undefined  ){
            var activecolor = $(menu).attr("activecolor");
            var inactivecolor = $(menu).attr("inactivecolor");
            var bgactivecolor = $(menu).attr("bgactivecolor");
            var bginactivecolor = $(menu).attr("bginactivecolor");
            if(bginactivecolor!=''){
                    $("#sideMenuNavigationBarParent").css("background-color" , '#'+bginactivecolor);
            }
                $(menu).each(function(i,elem){
                    if($(elem).find("svg")!=null && $(elem).find("svg")!=undefined){
                        $(elem).find("svg").attr("width","20px");
                        $(elem).find("svg").attr("height","20px");
                        $(elem).find("svg").attr("top","20px");
                    }
                    if($(elem).hasClass("active")){
                        if($(elem).hasClass("sideSubMenuChild")){ //substep
                            if(bgactivecolor!=''){
                                $(elem).find(".sideMenuChildLabelParent").css('background-color','#'+bgactivecolor); //bg
                            }
                            if(activecolor!=''){
                                $(elem).css('background-color','#'+activecolor); //strip
                                $(elem).find('.sideMenuChildLabelParent').css('color','#'+activecolor); //font
                                if($(elem).find("svg")!=null && $(elem).find("svg")!=undefined)
                                    recursion($(elem).find("svg"),activecolor); //icon
                            }
                        }
                        else if( $(elem).hasClass("sideMenuChildWithChild") ){ //step has substeps
                            if(bginactivecolor!=''){
                                $(elem).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                            }
                            if(inactivecolor!=''){
                                $(elem).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(elem).find("svg")!=null && $(elem).find("svg")!=undefined)
                                    recursion($(elem).find("svg"),inactivecolor); //icon
                            }
                        } else { //only steps
                            if(bgactivecolor!=''){
                                $(elem).find(".sideMenuLabelParent").css('background-color','#'+bgactivecolor); //bg
                            }
                            if(activecolor!=''){
                                $(elem).css('background-color','#'+activecolor); //strip
                                $(elem).find('.sideMenuLabelParent').css('color','#'+activecolor); //font
                                if($(elem).find("svg")!=null && $(elem).find("svg")!=undefined)
                                    recursion($(elem).find("svg"),activecolor); //icon
                            }
                        }
                    } else { //inactive
                        if($(elem).hasClass("sideSubMenuChild")){ //substep
                            if(bginactivecolor!=''){
                                $(elem).find(".sideMenuChildLabelParent").css('background-color','#'+bginactivecolor);
                                $(elem).css('background-color','#'+bginactivecolor);
                            }
                            if(inactivecolor!=''){
                                $(elem).find('.sideMenuChildLabelParent').css('color','#'+inactivecolor);
                                if($(elem).find("svg")!=null && $(elem).find("svg")!=undefined)
                                    recursion($(elem).find("svg"),inactivecolor); 
                            }
                        }
                        else if( $(elem).hasClass("sideMenuChildWithChild") ){ //step has substeps 
                            if(bginactivecolor!=''){
                                $(elem).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                            }
                            if(inactivecolor!=''){
                                $(elem).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(elem).find("svg")!=null && $(elem).find("svg")!=undefined)
                                    recursion($(elem).find("svg"),inactivecolor); //icon
                            }
                        } 
                        else { //only steps
                            if(bginactivecolor!=''){
                                $(elem).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                                $(elem).css('background-color','#'+bginactivecolor);
                            }
                            if(inactivecolor!=''){
                                $(elem).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(elem).find("svg")!=null && $(elem).find("svg")!=undefined)
                                    recursion($(elem).find("svg"),inactivecolor); //icon
                            }
                        }
                    }
                });
        } //icons end
    }
}

function navigationBackClick(ref) {
	ComponentValidatedMap={};
    var currentElement;
    var parentIndex;
    var childCurrentElement;
    var prevChildElements;
    var totalchild;
    var childIndex;
    document.getElementById("fade").style.display="block"; //Bug 102425 
    navigationClick="2";
    isNavigationNextClick = false;
    var validate = true;
    if (window.validateForm) {
        var stepName = getCurrentStepName();
        validate = window.validateForm(stepName,navigationClick);
    }
    if (!validate){
        document.getElementById("fade").style.display="none"; //Bug 102425 
        return false;
    }
    if(typeof applicationName!='undefined' && (applicationName==null || applicationName==''))
        saveForm("S", true); 
    else
        saveForm("SB", true);//Save the form without mandatory check
    if(getDeviceType()){
        
        if(document.getElementById("menuParentDiv")!=null && document.getElementById("menuParentDiv")!=undefined ){
            currentElement = $("#menuParentDiv .sideMenuNavigationBar").find(".parentMenuItem.active");
        } else {
            currentElement = $($('.sideMenuNavigationBar')[0]).find('li.active.sideMenuItem')[0];
        }
        parentIndex = $(currentElement).index();
        if ($(currentElement).find('.sideMenuChildNavigationBar')[0] != null) {
            childCurrentElement = $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0];
            childIndex = $($($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0]).index();
            if (childIndex == 0) {
                if (parentIndex != 0) {
                  prevChildElements= $($(currentElement).prev()).find('.sideMenuChildNavigationBar li').length;
                  if (prevChildElements > 0){
                     $($($(currentElement).prev()).find('.sideMenuChildNavigationBar li')[prevChildElements-1]).click();
                  }
                  else{  $(currentElement).prev().click(); }
                }
            }
            else{
                childCurrentElement.previousSibling.click();
                $("#submenu").animate({
                    scrollTop: $("#submenu").scrollTop() - 50
                });
            }
        }
        else{
            if (parentIndex != 0) {
                  prevChildElements= $($(currentElement).prev()).find('.sideMenuChildNavigationBar li').length;
                  if (prevChildElements > 0){
                     $($($(currentElement).prev()).find('.sideMenuChildNavigationBar li')[prevChildElements-1]).click();
                  }
                  else{  $(currentElement).prev().click(); }
            }
        }
    }
    else if ($('.stepNavigationContainerParent')[0] != null) {
        currentElement = $($('.navigationProgressBar')[0]).find('li.active')[0];        
        var a = $(currentElement).children('span')[0];
        var b = $(a).children('span')[2];
        var c = $(b).children('span')[0];
        var activeColor = $(c).attr("activecolor");
        var inActiveColor = $(c).attr("inactivecolor");
        var svgObj = $(c).find("svg");
        recursion(svgObj,inActiveColor);
     
        parentIndex = $($($('.navigationProgressBar')[0]).find('li.active')[0]).index();
        if ($($('.verticalNavigationProgressBar')[0]).find('li')[0] != null) {
            childCurrentElement = $($('.verticalNavigationProgressBar')[0]).find('li.current')[0];
            childIndex = $($($('.verticalNavigationProgressBar')[0]).find('li.current')[0]).index();
            if (childIndex == 0) {
                if (parentIndex != 0) {
                    currentElement.previousSibling.classList.remove("disableList");
                    currentElement.classList.add("disableList");
                    currentElement.previousSibling.setAttribute("type", "5");
                    currentElement.previousSibling.click();
                }
            }
            else{
                childCurrentElement.previousSibling.classList.remove("disableList");
                childCurrentElement.classList.add("disableList");
                childCurrentElement.previousSibling.click();
                $("#verticalNavigationContainerParent").animate({
                    scrollTop: $("#verticalNavigationContainerParent").scrollTop() - 50
                });
            }
        }
        else{
            if (parentIndex != 0) {
                currentElement.previousSibling.classList.remove("disableList");
                currentElement.classList.add("disableList");
                currentElement.previousSibling.setAttribute("type", "5");
                currentElement.previousSibling.click();
                
                var e = currentElement.previousSibling;
                var f = $(e).children('span')[0];
                var g = $(f).children('span')[2];
                var h = $(g).children('span')[0];
                
                svgObj = $(h).find("svg");
                recursion(svgObj,activeColor);
                
            }
        }
    }
    else if($('.sideMenuNavigationBarParent')[0]!=null){
        currentElement = $($('.sideMenuNavigationBar')[0]).find('li.active.sideMenuItem')[0];
        var activeMenu = currentElement;
        var nextMenu;
        parentIndex = $(currentElement).index();
        if ($(currentElement).find('.sideMenuChildNavigationBar')[0] != null) {
            childCurrentElement = $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0];
            activeMenu = childCurrentElement;
            childIndex = $($($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0]).index();
            if (childIndex == 0) {
                if (parentIndex != 0) {
                    if(!currentElement.previousSibling.classList.contains("sideMenuChildWithChild"))  //PWA
                        currentElement.previousSibling.classList.remove("disableList");
                    currentElement.classList.add("disableList");
                    nextMenu = currentElement.previousSibling;
                if(currentElement.previousSibling.classList.contains("sideMenuChildWithChild")){ //PWA
                    currentElement.previousSibling.classList.add("active");
                    currentElement.classList.remove("active");
                    totalchild = $($(currentElement.previousSibling).find('.sideMenuChildNavigationBar')[0]).children().length;
                    $($(currentElement.previousSibling).find('.sideMenuChildNavigationBar')[0]).find('li')[totalchild-1].click();
                }
                else
                    currentElement.previousSibling.click();
                }
            }
            else{
                childCurrentElement.previousSibling.classList.remove("disableList");
                childCurrentElement.classList.add("disableList");
                nextMenu = childCurrentElement.previousSibling;
                childCurrentElement.previousSibling.click();
                $("#sideMenuNavigationBarParent").animate({
                    scrollTop: $("#sideMenuNavigationBarParent").scrollTop() - 50
                });
            }
        }
        else{
            if (parentIndex != 0) {
                if(!currentElement.previousSibling.classList.contains("sideMenuChildWithChild"))  //PWA
                    currentElement.previousSibling.classList.remove("disableList");
                currentElement.classList.add("disableList");
                nextMenu = currentElement.previousSibling;
                if(currentElement.previousSibling.classList.contains("sideMenuChildWithChild")){ //PWA
                    currentElement.previousSibling.classList.add("active");
                    currentElement.classList.remove("active");
                    totalchild = $($(currentElement.previousSibling).find('.sideMenuChildNavigationBar')[0]).children().length;
                    $($(currentElement.previousSibling).find('.sideMenuChildNavigationBar')[0]).find('li')[totalchild-1].click();
                }
                else
                    currentElement.previousSibling.click();
            }
        }
        
        if( document.getElementById("submenu")==null || document.getElementById("submenu")==undefined  ){
            var activecolor = $(activeMenu).attr("activecolor");
            var inactivecolor = $(activeMenu).attr("inactivecolor");
            var bgactivecolor = $(activeMenu).attr("bgactivecolor");
            var bginactivecolor = $(activeMenu).attr("bginactivecolor");
            if($(activeMenu).hasClass("sideSubMenuChild")){ //substep
                            if(bginactivecolor!=''){
                                $(activeMenu).find(".sideMenuChildLabelParent").css('background-color','#'+bginactivecolor);
                                $(activeMenu).css('background-color','#'+bginactivecolor); //remove strip
                            }
                            if(inactivecolor!=''){
                                $(activeMenu).find('.sideMenuChildLabelParent').css('color','#'+inactivecolor);
                                if($(activeMenu).find("svg")!=null && $(activeMenu).find("svg")!=undefined)
                                    recursion($(activeMenu).find("svg"),inactivecolor); 
                            }
                        }
                        else if( $(activeMenu).hasClass("sideMenuChildWithChild") ){ //step has substeps 
                            if(bginactivecolor!=''){
                                $(activeMenu).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                            }
                            if(inactivecolor!=''){
                                $(activeMenu).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(activeMenu).find("svg")!=null && $(activeMenu).find("svg")!=undefined)
                                    recursion($(activeMenu).find("svg"),inactivecolor); //icon
                            }
                        } 
                        else { //only steps
                            if(bginactivecolor!=''){
                                $(activeMenu).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                                $(activeMenu).css('background-color','#'+bginactivecolor); //remove strip
                            }
                            if(inactivecolor!=''){
                                $(activeMenu).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(activeMenu).find("svg")!=null && $(activeMenu).find("svg")!=undefined)
                                    recursion($(activeMenu).find("svg"),inactivecolor); //icon
                            }
                        }
            
            
                        if($(nextMenu).hasClass("sideSubMenuChild")){ //substep
                            if(bgactivecolor!=''){
                                $(nextMenu).find(".sideMenuChildLabelParent").css('background-color','#'+bgactivecolor); //bg
                            }
                            if(activecolor!=''){
                                $(nextMenu).css('background-color','#'+activecolor); //strip
                                $(nextMenu).find('.sideMenuChildLabelParent').css('color','#'+activecolor); //font
                                if($(nextMenu).find("svg")!=null && $(nextMenu).find("svg")!=undefined)
                                    recursion($(nextMenu).find("svg"),activecolor); //icon
                            }
                        }
                        else if( $(nextMenu).hasClass("sideMenuChildWithChild") ){ //step has substeps
                            if(bginactivecolor!=''){
                                $(nextMenu).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                            }
                            if(inactivecolor!=''){
                                $(nextMenu).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(nextMenu).find("svg")!=null && $(nextMenu).find("svg")!=undefined)
                                    recursion($(nextMenu).find("svg"),inactivecolor); //icon
                            }
                        } else { //only steps
                            if(bgactivecolor!=''){
                                $(nextMenu).find(".sideMenuLabelParent").css('background-color','#'+bgactivecolor); //bg
                            }
                            if(activecolor!=''){
                                $(nextMenu).css('background-color','#'+activecolor); //strip
                                $(nextMenu).find('.sideMenuLabelParent').css('color','#'+activecolor); //font
                                if($(nextMenu).find("svg")!=null && $(nextMenu).find("svg")!=undefined)
                                    recursion($(nextMenu).find("svg"),activecolor); //icon
                            }
                        }
            
        }
    }
    executeLoadEvents("5");
}

function SubmitData(ref) {
	 
    navigationClick="3";
    var validate = true;
    if (window.validateForm) {
        var stepName = getCurrentStepName();
        validate = window.validateForm(stepName,navigationClick);
    }
    if (!validate)
        return false;
    if (Object.keys(ComponentValidatedMap).length > 0) { 
        setFocus(Object.keys(ComponentValidatedMap)[0], false, null, null, true);
        return false;
    }
    if (!validateMandatoryFields())
        return false;
    if(!validateMandatoryDoument(false))
        return false;
    if(typeof applicationName!='undefined' && (applicationName==null || applicationName==''))
        saveForm("S", true); 
    else
        saveForm("SF", true);

   if(typeof applicationName!='undefined' && (applicationName==null || applicationName==''))
   {
      showAlertDialog(FORM_SAVE_MSG, false); 
      if(window.postHookOnSaveWorkItemFragment){
        window.postHookOnSaveWorkItemFragment(ref);
      }
   }
   else{
    var btns = {
        confirm: {
            label: YES,
            className: 'btn-success'
        },
        cancel: {
            label: NO,
            className: 'btn btn-primary'
        }
    }

    var userAction = function (result) {
        if (result === true) {
            var cleansession="Y";
            if(window.redirectToNavigation){
                var navPage = window.redirectToNavigation();
                if(navPage.trim() != "")
                    cleansession=navPage;
            }
            document.getElementById('finalSubmitBtn').disabled = 'disabled';
            if(document.getElementById('navigationBackBtn') != null && document.getElementById('navigationBackBtn') !=undefined)
                document.getElementById('navigationBackBtn').disabled = 'disabled';
            var url = "portal/appTask.jsp";
            var queryString = "oper=Introduce&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid)+"&cleanSession="+encode_utf8(cleansession);
            CreateIndicator("application");
            new net.ContentLoader(url, introHandler, introErrorHandler, "POST", queryString, true);
            }
    }
    showConfirmDialog(SUBMIT_APPLICATION, btns, userAction,false);
   }
}

function setCurrentTime(ref){
        $(ref).on('dp.change', function(e){
            console.log(e);
            console.log(e.date.format("DD/MM/YYYY HH:mm:ss").split(" ")[0]);
            var selectedDate = getSelectedDate(ref);
            console.log(selectedDate);
            if(e.date.format("DD/MM/YYYY HH:mm:ss").split(" ")[0] == selectedDate){
            var d = new Date() ;
            $(this).data('DateTimePicker').date(new Date(e.date._d.setHours(d.getHours(), d.getMinutes(), d.getSeconds())));               
            }    
        }); 
}

function cleanPortalSession() {
    var url = "cleanSession.jsp";
    var requestString = "pid=" + pid + "&wid=" + wid + "&taskid=" + tid + "&fid=" + fid;
    requestString += "&ps=Y";
    new net.ContentLoader(url, sessionClearHandler, commonErrorHandler, "POST", requestString, false);
}

function sessionClearHandler() {
    if(window.redirectToCustomPage){
        window.redirectToCustomPage();
    } else {
       redirectToApplication();
    }
}

function introHandler() {
    RemoveIndicator("application");
    var requestString;
    var navPage;
    var context,url,date;
    var responseText;
    if (typeof applicationName != 'undefined' && applicationName == '') {
        showAlertDialog(APP_SUB_SUCS, false);
    } else {
        if (window.showSuccessMessageInApplication || window.showFailureMessageInApplication) {
            if (this.req.getResponseHeader("WorkitemList") != null) {
                window.showSuccessMessageInApplication(this.req.getResponseHeader("WorkitemList"));
            } 
            else if(this.req.getResponseHeader("ResponseErrorFromCall") != null) {
                window.showFailureMessageInApplication(this.req.getResponseHeader("ResponseErrorFromCall"));
            }
            else {
                if(this.req.getResponseHeader("WorkitemStatus") == "true"){
                    window.showSuccessMessageInApplication(this.req.getResponseHeader("WorkitemList"));
                }
                else{
                    showAlertDialog(APP_SUB_SUCS, false);
                
                if(window.redirectToNavigation)
                {
                    navPage = window.redirectToNavigation();
                }
                if(navPage.trim() != ""){
                    context = '/' + window.location.pathname.split("/")[1];
                    url = context + "/components/viewer/portal/initializePortal.jsp";
                    url = generateAppendSidRidInUrl(url);
                    url = url + "&navigationPage="+navPage;
                    window.location.href = url;
                }
                else
                    cleanPortalSession();
                }
            }
            navPage="";
            if(window.redirectToNavigation)
            {
                navPage = window.redirectToNavigation();
            }
            if(extendSession=="Y"){
                url = "portal/appTask.jsp?oper=ExtendSession";
                requestString = "&pid=" + pid + "&wid=" + wid + "&taskid=" + tid + "&fid=" + fid;
                requestString += "&ExtendSession=Y";
                responseText = iforms.ajax.processRequest(requestString, url);
                if (responseText.trim() != '') {
                    date = new Date();
                    window.location.href = responseText.trim()+"&rid="+date.getMilliseconds();
                }
            }
            else if(navPage.trim() != ""){
                context = '/' + window.location.pathname.split("/")[1];
                url = context + "/components/viewer/portal/initializePortal.jsp";
                url = generateAppendSidRidInUrl(url);
                url = url + "&navigationPage="+navPage;
                window.location.href = url;
            }
            else
                cleanPortalSession();
        } else {
             if(this.req.getResponseHeader("WorkitemStatus") == "true"){
                 var msg = WORKITEM+" <b>"+this.req.getResponseHeader("WorkitemList")+"</b> "+CREATEMSG;
                 if(window.getCustomMessageOnPortalSubmit){
                     msg = getCustomMessageOnPortalSubmit(this.req.getResponseHeader("WorkitemList"));
                 }
                    showAlertDialog(msg,false);
                 }
              else{
                showAlertDialog(APP_SUB_SUCS, false);
                navPage="";
                if(window.redirectToNavigation)
                {
                navPage = window.redirectToNavigation();
                }
                if(extendSession=="Y"){
                    url = "portal/appTask.jsp?oper=ExtendSession";
                    requestString = "&pid=" + pid + "&wid=" + wid + "&taskid=" + tid + "&fid=" + fid;
                    requestString += "&ExtendSession=Y";
                    responseText = iforms.ajax.processRequest(requestString, url);
                    if (responseText.trim() != '') {
                        date = new Date();
                        window.location.href = responseText.trim()+"&rid="+date.getMilliseconds();
                    }                    
                }
                else if(navPage.trim() != ""){
                    context = '/' + window.location.pathname.split("/")[1];
                    url = context + "/components/viewer/portal/initializePortal.jsp";
                    url = generateAppendSidRidInUrl(url);
                    url = url + "&navigationPage="+navPage;
                    window.location.href = url;
                }
                else
                    cleanPortalSession();
                }
            
            }
    }      
}

function introErrorHandler() {
    RemoveIndicator("application");
}


function TileMandatory(mandateControlInModal){
    if (mandateControlInModal != undefined && !mandateControlInModal)
    {
        var tileCtrls = $("[groupname]");
        var grpname = "";
        var isGroupSelected = false;
        for (var i = 0; i < tileCtrls.length; i++)
        {
            if ($(tileCtrls[i]).attr('mandatory') === "true" && $(tileCtrls[i]).attr('groupname') !== grpname && $(tileCtrls[i]).attr('groupname') !== "")
            {
                grpname = $(tileCtrls[i]).attr('groupname');
                isGroupSelected = false;
                var tempCtrls = $("[groupname=" + grpname + "]");
                for (var j = 0; j < tempCtrls.length; j++)
                {
                    var tileBtn = tempCtrls[j];
                    if($(tileBtn).parents(".outerControlDiv").find(".tile-selected").css("display") == "block"){
                        isGroupSelected = true;
                        break;
                    }
                    if (tileBtn.style.display === 'none')
                    {
                        isGroupSelected = true;
                        break;
                    }
                }
            } else if ($(tileCtrls[i]).attr('groupname') === "")
                isGroupSelected = true;
            else if ($(tileCtrls[i]).attr('groupname') !== "" && $(tileCtrls[i]).attr('mandatory') === "false"){
                isGroupSelected = true;
            }
            if (!isGroupSelected)
            {
                break;
            }
        }
        if (!isGroupSelected && tileCtrls.length != 0)
        {
            getTileGrpError(grpname);
            return false;
        }
    }
    return true;
}


function validations(){
    var validate = true;
    var stepName;
    if (window.validateForm) {
        stepName = getCurrentStepName();
        validate = window.validateForm(stepName,navigationClick);
    }
    if (!validate)
        return false;
   
    if(isNavigationNextClick === true){
    if (!validateMandatoryFields())
        return false;
    
    if(!validateMandatoryDoument(false))
        return false;
    }
    
    var postValidate=true;
    if(window.postMandatoryValidation){
        stepName = getCurrentStepName();
        postValidate = window.postMandatoryValidation(stepName);       
    }
    if(!postValidate){
            return false;
    }
    return true;
}
function navigationNextClick(ref) {
    var url = "action_API.jsp";        
    var queryStr = "&pid=" + pid + "&wid=" + wid + "&checkValidationOnStep=Y"; 
    var resp = iforms.ajax.processRequest(queryStr, url);
	resp = resp.trim();
    if( resp == "true"){
	validateMandatoryFields();
        return true;
    }
    var currentElement , parentIndex , totalParentElements,childCurrentElement,totalChildElements,childIndex,nextChild;
    document.getElementById("fade").style.display="block"; //Bug 102425 
    isNavigationNextClick = true;
    navigationClick="1";
    var svgObj;
    if(!validations()){
        document.getElementById("fade").style.display="none"; //Bug 102425 
        return false;
    }
    
    if(typeof applicationName!='undefined' && (applicationName==null || applicationName==''))
        saveForm("S", true); 
    else
        saveForm("SF", true);
   if(getDeviceType()){       
       if(document.getElementById("menuParentDiv")!=null && document.getElementById("menuParentDiv")!=undefined ){
         currentElement = $("#menuParentDiv .sideMenuNavigationBar").find(".parentMenuItem.active");
         parentIndex = $(currentElement).index();
         totalParentElements = $($('.sideMenuNavigationBar')[0]).children().length;
       } else {
            currentElement = $($('.sideMenuNavigationBar')[0]).find('li.active.sideMenuItem')[0];
            parentIndex = $(currentElement).index();
            totalParentElements = $($('.sideMenuNavigationBar')[0]).children().length;
       }
        if ($(currentElement).find('.sideMenuChildNavigationBar')[0] != null) {
            childCurrentElement = $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0];
            totalChildElements = $($(currentElement).find('.sideMenuChildNavigationBar')[0]).children().length;
            childIndex = $($($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0]).index();
            if (childIndex == totalChildElements - 1) {
                if (parentIndex != totalParentElements - 1) {
                    nextChild= $($(currentElement).next()).find('.sideMenuChildNavigationBar li').length;
                    if (nextChild > 0){
                       $($($(currentElement).next()).find('.sideMenuChildNavigationBar li')[0]).click();
                    }
                    else{
                        $(currentElement).next().click(); 
                    }
                }
            }
            else{
                childCurrentElement.nextSibling.click();
                $("#submenu").animate({
                    scrollTop: 50 * (childIndex + 1)
                });
            }
        }
        else{
                if (parentIndex != totalParentElements - 1) {
                      nextChild= $($(currentElement).next()).find('.sideMenuChildNavigationBar li').length;
                      if (nextChild > 0){
                         $($($(currentElement).next()).find('.sideMenuChildNavigationBar li')[0]).click();
                      }
                      else{  $(currentElement).next().click(); }
                }
        }
        
      
   }
    else if ($('.stepNavigationContainerParent')[0] != null) {
        currentElement = $($('.navigationProgressBar')[0]).find('li.active')[0];
        var a = $(currentElement).children('span')[0];
        var b = $(a).children('span')[2];
        var c = $(b).children('span')[0];
        var activeColor = $(c).attr("activecolor");
        var inActiveColor = $(c).attr("inactivecolor");
        
        svgObj = $(c).find("svg");
        recursion(svgObj,inActiveColor);
        parentIndex = $($($('.navigationProgressBar')[0]).find('li.active')[0]).index();
        totalParentElements = $($('.navigationProgressBar')[0]).children().length;
        if ($($('.verticalNavigationProgressBar')[0]).find('li')[0] != null) {
            childCurrentElement = $($('.verticalNavigationProgressBar')[0]).find('li.current')[0];
            totalChildElements = $($('.verticalNavigationProgressBar')[0]).children().length;
            childIndex = $($($('.verticalNavigationProgressBar')[0]).find('li.current')[0]).index();
            if (childIndex == totalChildElements - 1) {
                if (parentIndex != totalParentElements - 1) {
                    currentElement.nextSibling.classList.remove("disableList");
                    currentElement.classList.add("disableList");
                    currentElement.nextSibling.click();
                }
            }
            else{
                childCurrentElement.nextSibling.classList.remove("disableList");
                childCurrentElement.classList.add("disableList");
                childCurrentElement.nextSibling.click();
                $("#verticalNavigationContainerParent").animate({
                    scrollTop: 50 * (childIndex + 1)
                });
            }
        }
        else{
            if (parentIndex != totalParentElements - 1) {
                currentElement.nextSibling.classList.remove("disableList");
                currentElement.classList.add("disableList");
                currentElement.nextSibling.click();
                var e = currentElement.nextSibling;
                var f = $(e).children('span')[0];
                var g = $(f).children('span')[2];
                var h = $(g).children('span')[0];
                svgObj = $(h).find("svg");
                recursion(svgObj,activeColor);
            }
        }
    }
    else if($('.sideMenuNavigationBarParent')[0]!=null){
        currentElement = $($('.sideMenuNavigationBar')[0]).find('li.active.sideMenuItem')[0];
        var activeMenu = currentElement;
        parentIndex = $(currentElement).index();
        var nextMenu; 
        totalParentElements = $($('.sideMenuNavigationBar')[0]).children().length;
        if ($(currentElement).find('.sideMenuChildNavigationBar')[0] != null) {
            childCurrentElement = $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0];
            activeMenu = childCurrentElement;
            totalChildElements = $($(currentElement).find('.sideMenuChildNavigationBar')[0]).children().length;
            childIndex = $($($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active')[0]).index();
            if (childIndex == totalChildElements - 1) {
                if (parentIndex != totalParentElements - 1) {
                    currentElement.nextSibling.classList.remove("disableList");
                    currentElement.classList.add("disableList");
                    nextMenu = currentElement.nextSibling;
                    currentElement.nextSibling.click();
                }
            }
            else{
                childCurrentElement.nextSibling.classList.remove("disableList");
                childCurrentElement.classList.add("disableList");
                nextMenu = childCurrentElement.nextSibling;
                childCurrentElement.nextSibling.click();
                $("#sideMenuNavigationBarParent").animate({
                    scrollTop: 50 * (childIndex + 1)
                });
            }
        }
        else{
            if (parentIndex != totalParentElements - 1) {
                if(!currentElement.nextSibling.classList.contains("sideMenuChildWithChild"))
                    currentElement.nextSibling.classList.remove("disableList");
                currentElement.classList.add("disableList");
                nextMenu = currentElement.nextSibling;
                currentElement.nextSibling.click();
            }
        }
        if(document.getElementById("submenu")==null || document.getElementById("submenu")==undefined ){
            var activecolor = $(activeMenu).attr("activecolor");
            var inactivecolor = $(activeMenu).attr("inactivecolor");
            var bgactivecolor = $(activeMenu).attr("bgactivecolor");
            var bginactivecolor = $(activeMenu).attr("bginactivecolor");
            if($(activeMenu).hasClass("sideSubMenuChild")){ //substep
                            if(bginactivecolor!=''){
                                $(activeMenu).find(".sideMenuChildLabelParent").css('background-color','#'+bginactivecolor);
                                $(activeMenu).css('background-color','#'+bginactivecolor); //remove strip
                            }
                            if(inactivecolor!=''){
                                $(activeMenu).find('.sideMenuChildLabelParent').css('color','#'+inactivecolor);
                                if($(activeMenu).find("svg")!=null && $(activeMenu).find("svg")!=undefined)
                                    recursion($(activeMenu).find("svg"),inactivecolor); 
                            }
                        }
                        else if( $(activeMenu).hasClass("sideMenuChildWithChild") ){ //step has substeps 
                            if(bginactivecolor!=''){
                                $(activeMenu).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                            }
                            if(inactivecolor!=''){
                                $(activeMenu).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(activeMenu).find("svg")!=null && $(activeMenu).find("svg")!=undefined)
                                    recursion($(activeMenu).find("svg"),inactivecolor); //icon
                            }
                        } 
                        else { //only steps
                            if(bginactivecolor!=''){
                                $(activeMenu).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                                $(activeMenu).css('background-color','#'+bginactivecolor); //remove strip
                            }
                            if(inactivecolor!=''){
                                $(activeMenu).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(activeMenu).find("svg")!=null && $(activeMenu).find("svg")!=undefined)
                                    recursion($(activeMenu).find("svg"),inactivecolor); //icon
                            }
                        }
            
            
                        if($(nextMenu).hasClass("sideSubMenuChild")){ //substep
                            if(bgactivecolor!=''){
                                $(nextMenu).find(".sideMenuChildLabelParent").css('background-color','#'+bgactivecolor); //bg
                            }
                            if(activecolor!=''){
                                $(nextMenu).css('background-color','#'+activecolor); //strip
                                $(nextMenu).find('.sideMenuChildLabelParent').css('color','#'+activecolor); //font
                                if($(nextMenu).find("svg")!=null && $(nextMenu).find("svg")!=undefined)
                                    recursion($(nextMenu).find("svg"),activecolor); //icon
                            }
                        }
                        else if( $(nextMenu).hasClass("sideMenuChildWithChild") ){ //step has substeps
                            if(bginactivecolor!=''){
                                $(nextMenu).find(".sideMenuLabelParent").css('background-color','#'+bginactivecolor); //bg
                            }
                            if(inactivecolor!=''){
                                $(nextMenu).find('.sideMenuLabelParent').css('color','#'+inactivecolor); //font
                                if($(nextMenu).find("svg")!=null && $(nextMenu).find("svg")!=undefined)
                                    recursion($(nextMenu).find("svg"),inactivecolor); //icon
                            }
                        } else { //only steps
                            if(bgactivecolor!=''){
                                $(nextMenu).find(".sideMenuLabelParent").css('background-color','#'+bgactivecolor); //bg
                            }
                            if(activecolor!=''){
                                $(nextMenu).css('background-color','#'+activecolor); //strip
                                $(nextMenu).find('.sideMenuLabelParent').css('color','#'+activecolor); //font
                                if($(nextMenu).find("svg")!=null && $(nextMenu).find("svg")!=undefined)
                                    recursion($(nextMenu).find("svg"),activecolor); //icon
                            }
                        }
        }
    }
    executeLoadEvents("6");
}
function recursion(obj , fillColor){
    jQuery(obj).find("*").each(function(i,elem){
    if(fillColor!=undefined && fillColor != ""){
            if(jQuery(elem).attr("fill")!=undefined && jQuery(elem).attr("fill")!="" && jQuery(elem).attr("fill") != "none")
                jQuery(elem).attr("fill" , "#"+fillColor);
            else if(jQuery(elem).attr("stroke")!=undefined && jQuery(elem).attr("stroke")!="" && jQuery(elem).attr("stroke") != "none")
              jQuery(elem).attr("stroke" , "#"+fillColor);
            else if(jQuery(elem).prop("tagName")=="path" && jQuery(elem).attr("stroke")==undefined && jQuery(elem).attr("fill")==undefined)
              jQuery(elem).attr("fill" , "#"+fillColor);
       }
    });
    }
function setProgressBar() {
    if ($('.stepNavigationContainerParent')[0] != null) {
        var currentElement = $($('.navigationProgressBar')[0]).find('li.active')[0];
        if ($($('.verticalNavigationProgressBar')[0]).find('li')[0] != null) {
            var totalChildElements = $($('.verticalNavigationProgressBar')[0]).children().length;
            var childIndex = $($($('.verticalNavigationProgressBar')[0]).find('li.current')[0]).index();
            var percentage = (childIndex) * 1.0 / (totalChildElements);
            var degrees = percentage * 360;
            if (percentage > 0.5)
                $(currentElement).addClass("over50");
            else
                $(currentElement).removeClass("over50");
            $(currentElement).find('.completedProgressSegmentValueBar').css("transform", "rotate(" + degrees + "deg)");
        }
        else{
            $(currentElement).removeClass("over50");
            $(currentElement).find('.completedProgressSegmentValueBar').css("transform", "rotate(0deg)");
        }
    }
}

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/*-------------------------------------------custom_dropdown.js-----------------------------------------------------*/


var phone_codeJson = {"BD": "880", "BE": "32", "BF": "226", "BG": "359", "BA": "387", "BB": "+1-246", "WF": "681", "BL": "590", "BM": "+1-441", "BN": "673", "BO": "591", "BH": "973", "BI": "257", "BJ": "229", "BT": "975", "JM": "+1-876", "BV": "", "BW": "267", "WS": "685", "BQ": "599", "BR": "55", "BS": "+1-242", "JE": "+44-1534", "BY": "375", "BZ": "501", "RU": "7", "RW": "250", "RS": "381", "TL": "670", "RE": "262", "TM": "993", "TJ": "992", "RO": "40", "TK": "690", "GW": "245", "GU": "+1-671", "GT": "502", "GS": "", "GR": "30", "GQ": "240", "GP": "590", "JP": "81", "GY": "592", "GG": "+44-1481", "GF": "594", "GE": "995", "GD": "+1-473", "GB": "44", "GA": "241", "SV": "503", "GN": "224", "GM": "220", "GL": "299", "GI": "350", "GH": "233", "OM": "968", "TN": "216", "JO": "962", "HR": "385", "HT": "509", "HU": "36", "HK": "852", "HN": "504", "HM": " ", "VE": "58", "PR": "+1-787 and 1-939", "PS": "970", "PW": "680", "PT": "351", "SJ": "47", "PY": "595", "IQ": "964", "PA": "507", "PF": "689", "PG": "675", "PE": "51", "PK": "92", "PH": "63", "PN": "870", "PL": "48", "PM": "508", "ZM": "260", "EH": "212", "EE": "372", "EG": "20", "ZA": "27", "EC": "593", "IT": "39", "VN": "84", "SB": "677", "ET": "251", "SO": "252", "ZW": "263", "SA": "966", "ES": "34", "ER": "291", "ME": "382", "MD": "373", "MG": "261", "MF": "590", "MA": "212", "MC": "377", "UZ": "998", "MM": "95", "ML": "223", "MO": "853", "MN": "976", "MH": "692", "MK": "389", "MU": "230", "MT": "356", "MW": "265", "MV": "960", "MQ": "596", "MP": "+1-670", "MS": "+1-664", "MR": "222", "IM": "+44-1624", "UG": "256", "TZ": "255", "MY": "60", "MX": "52", "IL": "972", "FR": "33", "IO": "246", "SH": "290", "FI": "358", "FJ": "679", "FK": "500", "FM": "691", "FO": "298", "NI": "505", "NL": "31", "NO": "47", "NA": "264", "VU": "678", "NC": "687", "NE": "227", "NF": "672", "NG": "234", "NZ": "64", "NP": "977", "NR": "674", "NU": "683", "CK": "682", "XK": "", "CI": "225", "CH": "41", "CO": "57", "CN": "86", "CM": "237", "CL": "56", "CC": "61", "CA": "1", "CG": "242", "CF": "236", "CD": "243", "CZ": "420", "CY": "357", "CX": "61", "CR": "506", "CW": "599", "CV": "238", "CU": "53", "SZ": "268", "SY": "963", "SX": "599", "KG": "996", "KE": "254", "SS": "211", "SR": "597", "KI": "686", "KH": "855", "KN": "+1-869", "KM": "269", "ST": "239", "SK": "421", "KR": "82", "SI": "386", "KP": "850", "KW": "965", "SN": "221", "SM": "378", "SL": "232", "SC": "248", "KZ": "7", "KY": "+1-345", "SG": "65", "SE": "46", "SD": "249", "DO": "+1-809 and 1-829", "DM": "+1-767", "DJ": "253", "DK": "45", "VG": "+1-284", "DE": "49", "YE": "967", "DZ": "213", "US": "1", "UY": "598", "YT": "262", "UM": "1", "LB": "961", "LC": "+1-758", "LA": "856", "TV": "688", "TW": "886", "TT": "+1-868", "TR": "90", "LK": "94", "LI": "423", "LV": "371", "TO": "676", "LT": "370", "LU": "352", "LR": "231", "LS": "266", "TH": "66", "TF": "", "TG": "228", "TD": "235", "TC": "+1-649", "LY": "218", "VA": "379", "VC": "+1-784", "AE": "971", "AD": "376", "AG": "+1-268", "AF": "93", "AI": "+1-264", "VI": "+1-340", "IS": "354", "IR": "98", "AM": "374", "AL": "355", "AO": "244", "AQ": "", "AS": "+1-684", "AR": "54", "AU": "61", "AT": "43", "AW": "297", "IN": "91", "AX": "+358-18", "AZ": "994", "IE": "353", "ID": "62", "UA": "380", "QA": "974", "MZ": "258"}

var country_codeJson = {"BD": "Bangladesh", "BE": "Belgium", "BF": "Burkina Faso", "BG": "Bulgaria", "BA": "Bosnia and Herzegovina", "BB": "Barbados", "WF": "Wallis and Futuna", "BL": "Saint Barthelemy", "BM": "Bermuda", "BN": "Brunei", "BO": "Bolivia", "BH": "Bahrain", "BI": "Burundi", "BJ": "Benin", "BT": "Bhutan", "JM": "Jamaica", "BV": "Bouvet Island", "BW": "Botswana", "WS": "Samoa", "BQ": "Bonaire, Saint Eustatius and Saba ", "BR": "Brazil", "BS": "Bahamas", "JE": "Jersey", "BY": "Belarus", "BZ": "Belize", "RU": "Russia", "RW": "Rwanda", "RS": "Serbia", "TL": "East Timor", "RE": "Reunion", "TM": "Turkmenistan", "TJ": "Tajikistan", "RO": "Romania", "TK": "Tokelau", "GW": "Guinea-Bissau", "GU": "Guam", "GT": "Guatemala", "GS": "South Georgia and the South Sandwich Islands", "GR": "Greece", "GQ": "Equatorial Guinea", "GP": "Guadeloupe", "JP": "Japan", "GY": "Guyana", "GG": "Guernsey", "GF": "French Guiana", "GE": "Georgia", "GD": "Grenada", "GB": "United Kingdom", "GA": "Gabon", "SV": "El Salvador", "GN": "Guinea", "GM": "Gambia", "GL": "Greenland", "GI": "Gibraltar", "GH": "Ghana", "OM": "Oman", "TN": "Tunisia", "JO": "Jordan", "HR": "Croatia", "HT": "Haiti", "HU": "Hungary", "HK": "Hong Kong", "HN": "Honduras", "HM": "Heard Island and McDonald Islands", "VE": "Venezuela", "PR": "Puerto Rico", "PS": "Palestinian Territory", "PW": "Palau", "PT": "Portugal", "SJ": "Svalbard and Jan Mayen", "PY": "Paraguay", "IQ": "Iraq", "PA": "Panama", "PF": "French Polynesia", "PG": "Papua New Guinea", "PE": "Peru", "PK": "Pakistan", "PH": "Philippines", "PN": "Pitcairn", "PL": "Poland", "PM": "Saint Pierre and Miquelon", "ZM": "Zambia", "EH": "Western Sahara", "EE": "Estonia", "EG": "Egypt", "ZA": "South Africa", "EC": "Ecuador", "IT": "Italy", "VN": "Vietnam", "SB": "Solomon Islands", "ET": "Ethiopia", "SO": "Somalia", "ZW": "Zimbabwe", "SA": "Saudi Arabia", "ES": "Spain", "ER": "Eritrea", "ME": "Montenegro", "MD": "Moldova", "MG": "Madagascar", "MF": "Saint Martin", "MA": "Morocco", "MC": "Monaco", "UZ": "Uzbekistan", "MM": "Myanmar", "ML": "Mali", "MO": "Macao", "MN": "Mongolia", "MH": "Marshall Islands", "MK": "Macedonia", "MU": "Mauritius", "MT": "Malta", "MW": "Malawi", "MV": "Maldives", "MQ": "Martinique", "MP": "Northern Mariana Islands", "MS": "Montserrat", "MR": "Mauritania", "IM": "Isle of Man", "UG": "Uganda", "TZ": "Tanzania", "MY": "Malaysia", "MX": "Mexico", "IL": "Israel", "FR": "France", "IO": "British Indian Ocean Territory", "SH": "Saint Helena", "FI": "Finland", "FJ": "Fiji", "FK": "Falkland Islands", "FM": "Micronesia", "FO": "Faroe Islands", "NI": "Nicaragua", "NL": "Netherlands", "NO": "Norway", "NA": "Namibia", "VU": "Vanuatu", "NC": "New Caledonia", "NE": "Niger", "NF": "Norfolk Island", "NG": "Nigeria", "NZ": "New Zealand", "NP": "Nepal", "NR": "Nauru", "NU": "Niue", "CK": "Cook Islands", "XK": "Kosovo", "CI": "Ivory Coast", "CH": "Switzerland", "CO": "Colombia", "CN": "China", "CM": "Cameroon", "CL": "Chile", "CC": "Cocos Islands", "CA": "Canada", "CG": "Republic of the Congo", "CF": "Central African Republic", "CD": "Democratic Republic of the Congo", "CZ": "Czech Republic", "CY": "Cyprus", "CX": "Christmas Island", "CR": "Costa Rica", "CW": "Curacao", "CV": "Cape Verde", "CU": "Cuba", "SZ": "Swaziland", "SY": "Syria", "SX": "Sint Maarten", "KG": "Kyrgyzstan", "KE": "Kenya", "SS": "South Sudan", "SR": "Suriname", "KI": "Kiribati", "KH": "Cambodia", "KN": "Saint Kitts and Nevis", "KM": "Comoros", "ST": "Sao Tome and Principe", "SK": "Slovakia", "KR": "South Korea", "SI": "Slovenia", "KP": "North Korea", "KW": "Kuwait", "SN": "Senegal", "SM": "San Marino", "SL": "Sierra Leone", "SC": "Seychelles", "KZ": "Kazakhstan", "KY": "Cayman Islands", "SG": "Singapore", "SE": "Sweden", "SD": "Sudan", "DO": "Dominican Republic", "DM": "Dominica", "DJ": "Djibouti", "DK": "Denmark", "VG": "British Virgin Islands", "DE": "Germany", "YE": "Yemen", "DZ": "Algeria", "US": "United States", "UY": "Uruguay", "YT": "Mayotte", "UM": "United States Minor Outlying Islands", "LB": "Lebanon", "LC": "Saint Lucia", "LA": "Laos", "TV": "Tuvalu", "TW": "Taiwan", "TT": "Trinidad and Tobago", "TR": "Turkey", "LK": "Sri Lanka", "LI": "Liechtenstein", "LV": "Latvia", "TO": "Tonga", "LT": "Lithuania", "LU": "Luxembourg", "LR": "Liberia", "LS": "Lesotho", "TH": "Thailand", "TF": "French Southern Territories", "TG": "Togo", "TD": "Chad", "TC": "Turks and Caicos Islands", "LY": "Libya", "VA": "Vatican", "VC": "Saint Vincent and the Grenadines", "AE": "United Arab Emirates", "AD": "Andorra", "AG": "Antigua and Barbuda", "AF": "Afghanistan", "AI": "Anguilla", "VI": "U.S. Virgin Islands", "IS": "Iceland", "IR": "Iran", "AM": "Armenia", "AL": "Albania", "AO": "Angola", "AQ": "Antarctica", "AS": "American Samoa", "AR": "Argentina", "AU": "Australia", "AT": "Austria", "AW": "Aruba", "IN": "India", "AX": "Aland Islands", "AZ": "Azerbaijan", "IE": "Ireland", "ID": "Indonesia", "UA": "Ukraine", "QA": "Qatar", "MZ": "Mozambique"}



$(document).ready(function () {

    try {
        for (var i = 0; i < Object.keys(phone_codeJson).length; i++) {
            $(".compund-dropdown2").append('<option value="' + Object.keys(phone_codeJson)[i] + '">' + getObjectValues(phone_codeJson)[i] + '</option>');
            $(".compund-input2").append('<option value="' + Object.keys(country_codeJson)[i] + '">' + getObjectValues(country_codeJson)[i] + '</option>');
        }

        $(document).on('change', '.compund-dropdown2', function () {
            $(this).next(".compund-input2").val($(this).val());
        });
        $(document).on('change', '.compund-input2', function () {
            $(this).prev(".compund-dropdown2").val($(this).val());
        });

        if(getDeviceType() && document.getElementById("menuContainer")!=null && document.getElementById("menuContainer")!=undefined){
            putDataInMenu();
        }       
        
    }
      catch(ex){}
});
function setSliderCss(){
    if($('.slidecontainer').width() < 390){
            $('.removePaddingSlider').css('float',LEFT);
            $('.removePaddingSlider').css('padding-top','6px');
        } else {
            $('.removePaddingSlider').css('float',RIGHT);
            $('.removePaddingSlider').css('padding-top','0px');
        }       
        
}
function setDocListClass(){
        $(".doc-list-unit").each(function(i,elem){
            if( $(elem).width() < 347 ) {
                $(elem).find('.doc-unit-delete p').css('display','none');
                $(elem).find('.doc-unit-delete').css('width','5%');
                $(elem).find('.doc-unit-delete').css('float','right');
                $(elem).find('.doc-unit-name img').css({'width' : '25px' , 'height': '30px' , 'margin-bottom': '14px' ,  'margin-top': '4px'});
                $(elem).find('.doc-unit-delete img').css({'height':'22px','width':'22px'});
                $(elem).find('.doc-detail-wrapper').css('padding-bottom' , '12px');
            } else {
                $(elem).find('.doc-unit-delete p').css('display','');
                $(elem).find('.doc-unit-delete').css('width','5%');
                $(elem).find('.doc-unit-name img').css({'width' : '18px' , 'height': '21px' });
                $(elem).find('.doc-unit-delete img').css({'height':'20px','width':'20px'});
                $(elem).find('.doc-detail-wrapper').css('padding-bottom' , '0px');
            }
            
        });
    }
function getObjectValues(obj) {
    var vals = Object.keys(obj).map(function (key) {
    return obj[key];})

    return vals;
}

/*-------------------------------------------custom_slider.js-----------------------------------------------------*/

function initialiseSlider(val, id) {
    var sliderRef=$("input[type='range']#range"+id);
    var sliderMax = sliderRef.attr("max");
    var sliderMin = sliderRef.attr("min");
    var sliderUnit =sliderRef.attr("unit");
    var sliderValue=sliderRef.attr("value");
    var language = (typeof iformLocale == "undefined")? 'en_us': iformLocale;
    sliderRef.parent().parent().find(".textRangeValue").attr('title',sliderValue);
    if(sliderUnit == ''||sliderUnit== null)
     {
         sliderRef.parent().parent().find(".textRangeValue").addClass('col-9');
     }
     else if(sliderUnit == 'Rs')
     {
         sliderRef.parent().parent().find(".textRangeValue").addClass('col-8')
     }
     if(language.startsWith("ar"))
     {
         sliderRef.parent().find(" .leftRange p").text(sliderMax);
         sliderRef.parent().find(" rightRange p").text(sliderMin);
     }
    else
     {
       sliderRef.parent().find(" .leftRange p").text(sliderMin);
       sliderRef.parent().find(".rightRange p").text(sliderMax);
    }
    if (val != 0)
    {
        var colorRange = $(document.getElementById(id));
        /*var value = document.getElementById("range" + id).getAttribute("value");
        var max = document.getElementById("range" + id).getAttribute("max");
        var min = document.getElementById("range" + id).getAttribute("min");*/
        var percentage = (val - sliderMin) / (sliderMax - sliderMin);
        percentage*=100;
        colorRange[0].style.width=percentage+"%";
    }


    /*var sliderClass = document.getElementsByClassName("slider2");
    for (var i = 0; i < sliderClass.length; i++) {
        sliderClass[i].addEventListener('change', updateSlider, false);
    }*/
    
    // Bug 127956
    var sliderId = document.getElementById("range"+id);
    if(sliderId===null)
        return;
    sliderId.addEventListener('change', updateSlider, false);
    

    $(document).on('change', '#range'+id+'.slider2', function () {
        $(this).parent().parent().find(".textRangeValue").val($(this).val());
        $(this).parent().parent().find(".textRangeValue").attr('title',$(this).val());
    });

   /*$(document).on('change', '.textRangeValue', function (e) {
        if(parseFloat($(this).val())>parseFloat($(this).attr('max'))&&$(this).val()!="")
        {
            showAlertDialog(TILE_MAX+parseFloat($(this).attr('max')), false);
            while(parseFloat($(this).val())>parseFloat($(this).attr('max')))
            {
                $(this).val("");
            }
        }
        else
        {
            if(parseFloat($(this).val())<parseFloat($(this).attr('min'))&&$(this).val()!="")
            {
                showAlertDialog(TILE_MIN+parseFloat($(this).attr('min')), false);
				$(this).val("");
                $(this).parent().parent().parent().parent().find(".slider2").val($(this).attr('min'));
            }
            else
            {
                if($(this).val()==="")
                    $(this).parent().parent().parent().parent().find(".slider2").val($(this).attr('min'));
                else    
                    $(this).parent().parent().parent().parent().find(".slider2").val($(this).val());
            }
        }
        updateSlider(e);
    });*/

    // Bug 127956
    var rangeTextControl = $(sliderId.parentElement.parentElement).find('.textRangeValue')[0];

    rangeTextControl.addEventListener('change', function (e) {
        if (parseFloat($(this).val()) > parseFloat($(this).attr('max')) && $(this).val() != "")
        {
            showAlertDialog(TILE_MAX + parseFloat($(this).attr('max')), false);
            while (parseFloat($(this).val()) > parseFloat($(this).attr('max')))
            {
                $(this).val("");
            }
        } else
        {
            if (parseFloat($(this).val()) < parseFloat($(this).attr('min')) && $(this).val() != "")
            {
                showAlertDialog(TILE_MIN + parseFloat($(this).attr('min')), false);
               // $(this).val("");
               // $(this).parent().parent().parent().parent().find(".slider2").val($(this).attr('min'));
			   $(this).val($(this).attr('value'));
            } else
            {
                if ($(this).val() === "")
                    $(this).parent().parent().parent().parent().find(".slider2").val($(this).attr('min'));
                else
                    $(this).parent().parent().parent().parent().find(".slider2").val($(this).val());
            }
        }

        updateSlider(e);
    }, false)


    $(document).on('mouseenter', '.slider2', function () {
        var titleVal = $(this).val();
        $(this).attr('title', titleVal);
    });

}


var width = $(window).width();
$(window).on('resize', function () {
    alignNavigationContainerStyle();
    if ($(this).width() != width) {
        width = $(this).width();
        setSliderCss();
        updateSlider();
        setDocListClass();
        }
});

    
function updateSlider(e) {
    var customSlider = $(".slider2");
    for (var i = 0; i < customSlider.length; i++) {
        var slider = jQuery(customSlider[i]);
        var val = slider.val();
        var max = slider.attr("max");
        var min = slider.attr("min");
        var percentage = (val - min) / (max - min);
        percentage*=100;
        $(".colorRange")[i].style.width=percentage+"%";
    }
    if (e != undefined)
    {
        var customAction = $(e.target).attr('customaction');
        e.target.setAttribute("value", parseFloat(e.target.value));
        var jsonobj = {};
        var id=e.target.id;
        if(id == undefined || id == "")
        {
            id = $(e.target).parent().parent().parent().parent().find(".slider2").attr("id");
            customAction = $(e.target).parent().parent().parent().parent().find(".slider2").attr("customaction");
        }
        jsonobj[id]=e.target.value;
        setValues(jsonobj,true);
        
        if (window[customAction]) {
            window[customAction]();
        }        
    }
}





function saveToggleData(ref)
{
    ref.setAttribute("value", ref.checked);
    ctrOnchangeHandler(ref, 1);
}
function openNavigationForm(opt, ref) {
    var tileName = ref.parentNode.parentNode.parentNode.id;
    if (window.setNavigationForm&&opt==1)
        setNavigationForm(opt, tileName);
}
/*-------------------------------------------tile.js-----------------------------------------------------*/

$(document).on('click', '.tile-button-select', function (event) {
    var current_btn = $(event.currentTarget);
    var grpname = current_btn.attr('groupname');
    var mode = current_btn.attr('mode');
    var buttons = document.querySelectorAll('[groupname="' + grpname + '"]');
    if (mode == 'Single')
    {
        for (var i = 0; i < buttons.length; i++)
        {
            if (!(buttons[i].id == current_btn.attr('id')))
            {
                if(document.getElementById(buttons[i].id).parentNode.parentNode.childNodes[0].classList.contains("clicked")==true)
                   document.getElementById(buttons[i].id).parentNode.parentNode.childNodes[0].classList.remove("clicked"); 
                removeTileButtonCss($(document.getElementById(buttons[i].id.split('-')[0] + '-false')));
                //Bug 101004
                var tileButtonRef=document.getElementById(buttons[i].id.split('-')[0] + '-false');
                ctrOnchangeHandler(tileButtonRef,1);
            }
        }
    }
	var current_btn_id = current_btn.attr('id');
    if (current_btn.attr('tileStyle') === 'Style2' || current_btn.attr('tileStyle') === 'Style3')
    {
        $(current_btn).parent().parent().parent().parent().css({"box-shadow": "0 3px 9px 0 rgba(0,0,0,0.14)"});
        $(current_btn).parent().parent().parent().parent().css('top',0);
        $(current_btn).parent().parent().parent().parent().addClass('tileborder');
        $(current_btn).parent().parent().parent().parent().parent().find(".tile-selected").show();
    }
    else 
    {
        document.getElementById(current_btn_id).parentNode.parentNode.parentNode.style["boxShadow"] = "0 3px 9px 0 rgba(0,0,0,0.14)";
        document.getElementById(current_btn_id).parentNode.parentNode.parentNode.style.top = '0px';
        document.getElementById(current_btn_id).parentNode.parentNode.parentNode.className += ' tileborder';
        document.getElementById(current_btn_id).parentNode.parentNode.parentNode.parentNode.firstChild.style.display = 'block';
    }

    
    $(current_btn).hide();
    $(current_btn).siblings().show();
});

$(document).on('click', '.tile-button-remove', function (event) {

    var current_btn = $(event.currentTarget);
    if (current_btn.attr('tileStyle') === 'Style2' || current_btn.attr('tileStyle') === 'Style3')
    {
        $(current_btn).parent().parent().parent().parent().css("box-shadow" , "none" );
        $(current_btn).parent().parent().parent().parent().css('top',22);
        $(current_btn).parent().parent().parent().parent().removeClass('tileborder');
        $(current_btn).parent().parent().parent().parent().parent().find(".tile-selected").hide();
    }
    else 
    {
        $(current_btn).parent().parent().parent().css("box-shadow" , "none" );
        $(current_btn).parent().parent().parent().css('top',22);
        $(current_btn).parent().parent().parent().removeClass('tileborder');
        $(current_btn).parent().parent().parent().parent().find(".tile-selected").hide();
    }

    $(current_btn).siblings().show();
    $(current_btn).hide();
});
function navSaveContinueClick(){
    var msg = SAVEEXITMSG;
    var context;
    var url;
    var date;
    var btns = {
        confirm: {
            label: YES,
            className: 'btn-success'
        },
        cancel: {
            label: CANCEL,
            className: 'btn-danger'
        }
    }
    var callback = function (result) {
        if(result){
            if (isPreview != "Y") {
                var validate = true;
                if (window.validateBeforeExit) {
                    var stepName = getCurrentStepName();
                    validate = window.validateBeforeExit(stepName);
                }
                if (!validate)
                    return false;
                saveForm("SC", true);
                var navPage="";
                if(window.redirectToCustomPage){
                    window.redirectToCustomPage();
                }
                else if(window.redirectToNavigation)
                {
                    navPage = window.redirectToNavigation();
                } 
                else if(extendSession=="Y"){
                    url = "portal/appTask.jsp?oper=ExtendSession";
                    var requestString = "&pid=" + pid + "&wid=" + wid + "&taskid=" + tid + "&fid=" + fid;
                    requestString += "&ExtendSession=Y";
                    var responseText = iforms.ajax.processRequest(requestString, url);
                    if (responseText.trim() != '') {
                        date = new Date();
                        window.location.href =responseText.trim()+"&rid="+date.getMilliseconds();
                    }
                } 
                else if(navPage.trim() != ""){
                    context = '/' + window.location.pathname.split("/")[1];
                    url = context + "/components/viewer/portal/initializePortal.jsp";
                    url = generateAppendSidRidInUrl(url);
                    url = url + "&navigationPage="+navPage;
                    window.location.href = url;
                }
                else {
                    window.location.href = contextPath;
                }
            }
        }
    }
    showConfirmDialog(msg, btns, callback);
}

function removeTileButtonCss(current_btn){
    if (current_btn.attr('tileStyle') === 'Style2' || current_btn.attr('tileStyle') === 'Style3')
    {
        $(current_btn).parent().parent().parent().parent().css("box-shadow" , "none" );
        $(current_btn).parent().parent().parent().parent().css('top',22);
        $(current_btn).parent().parent().parent().parent().removeClass('tileborder');
        $(current_btn).parent().parent().parent().parent().parent().find(".tile-selected").hide();
    }
    else 
    {
        $(current_btn).parent().parent().parent().css("box-shadow" , "none" );
        $(current_btn).parent().parent().parent().css('top',22);
        $(current_btn).parent().parent().parent().removeClass('tileborder');
        $(current_btn).parent().parent().parent().parent().find(".tile-selected").hide();
    }

    $(current_btn).siblings().show();
    $(current_btn).hide();
}

function getCurrentStepName()
{
    var stepName="";
    var currentElement;
    if(getDeviceType()){        
        currentElement = $($('.sideMenuNavigationBar')[0]).find('li.active.sideMenuItem')[0];
        stepName=   $($('.sideMenuNavigationBar')[0]).find('li.active.sideMenuItem').find(".sideMenuLabelParent").html();
        if ($(currentElement).find('.sideMenuChildNavigationBar')[0] != null) {
            stepName= $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active').find(".sideMenuChildLabelParent").html();
        }
        if(stepName !== null && stepName !== undefined && stepName.indexOf(".")!=-1){
          stepName = stepName.split(".")[stepName.split(".").length-1].trim();
        } else
          stepName = stepName.trim();
    }
    else {
    if ($('.stepNavigationContainerParent')[0] != null) {
        stepName= $($('.navigationProgressBar')[0]).find('li.active').find(".menuLabel").html();
        if ($($('.verticalNavigationProgressBar')[0]).find('li')[0] != null) {
            stepName = $($('.verticalNavigationProgressBar')[0]).find('li.current').find(".menuLabel").html();
        }
    }
    else if($('.sideMenuNavigationBarParent')[0]!=null){
        currentElement = $($('.sideMenuNavigationBar')[0]).find('li.active.sideMenuItem')[0];
        stepName=   $(currentElement).find(".sideMenuLabelParent").find(".parentStepName").text().trim();
        if ($(currentElement).find('.sideMenuChildNavigationBar')[0] != null) {
            stepName= $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li.active').find(".sideMenuChildLabelParent").find(".childStepName").text().trim();
        }
    }
    }
    return stepName;
}

function validateOTP(obj, parameters)
{
    var parameters1 = {"OTPField":parameters.OTPField};
    var result = executeServerEvent('controlName', 'click' , JSON.stringify(parameters1) , true);
    if(!result){//Bug 94440 
        if(window.customError)
            window.customError();
        else    
            window.location.href = "error.html";
    }
    else
        navigateToForm(obj, parameters);
}

function openTransaction(ref, parameters)
{
    var colName= parameters.TransactionColumnName;
    var routeColName = parameters.RouteJourneyColumnName;
    var navColName = parameters.NavigationFormColumnName;
    var listViewId= parameters.TransactionSelectionControl;
    var selectedRow;
    var transactionTable = document.getElementById(listViewId);
    for (var i in transactionTable.rows) {
       var row = transactionTable.rows[i];
       if(row.classList && row.classList.contains('highlightedRow')){
          selectedRow = i;
          selectedRow--;
          break;
        }
    }
    var transactionid = getValueFromColumnName(listViewId,selectedRow,colName);
    var routeJourneyColName="";
    if(routeColName!="")
        routeJourneyColName = getValueFromColumnName(listViewId,selectedRow,routeColName);
    var navFormColName="";
    if(navColName!="")
        navFormColName = getValueFromColumnName(listViewId,selectedRow,navColName);
    parameters.TransactionNumber=transactionid;
    parameters.SelectedRow=selectedRow;
    parameters.routeJourneyColName=routeJourneyColName;
    parameters.navFormColName=navFormColName;
    var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&controlId=" + ref.id + "&parameters=" + encode_utf8(JSON.stringify(parameters));
    var url = "portal/appTask.jsp?oper=OpenTransaction";
    CreateIndicator("application");
    new net.ContentLoader(url, openTransactionHandler, generalErrorHandler, "POST", requestString, true);
}

function openTransactionHandler(){
    RemoveIndicator("application");
    var responseText = this.req.responseText.trim();
    responseText=sanitize(responseText.trim());
    if (responseText != '') {
            var json = JSON.parse(responseText);
        var isWidget = json["ISWidget"];
        if(isWidget === "No"){
            var context = '/' + window.location.pathname.split("/")[1];
            var url = context + "/components/viewer/portal/initializePortal.jsp";
            url = generateAppendSidRidInUrl(url);
            if(extendSession=="Y")
                url += "&ExtendSession=Y";
            window.location.href = url;	
        }
        else
        {
            var widgetHTML = json["widgetHTML"];
            var parentHTML = json["parenttHTML"];
            var parentIndex = json["ParentIndex"];
            var childIndex = json["ChildIndex"];
            var firstStep = json["FirstStep"];
            var lastStep = json["LastStep"];
            loadwidget(parentHTML,widgetHTML,parentIndex,childIndex,firstStep,lastStep);      
        }
    }
}

function loadwidget(parentHTML,widgetHTML,parentIndex,childIndex,isFirst,isLast) {

        var responseText = widgetHTML;
        var verNavFragParent,i,fragmentContainer;
    if (childIndex != "-1") {
         verNavFragParent = document.getElementById("verNavFragParent");
        if (verNavFragParent != null) {
            verNavFragParent.innerHTML = "";
            jQuery(verNavFragParent).html(sanitize(parentHTML));
            
            if(childIndex!=0)
            {
                if(childIndex!=null && childIndex!=undefined && childIndex != 0 && childIndex>0 && childIndex<10000)
                {
                for(i=0;i<=childIndex;i++)
                {
                    if(i==childIndex){
                        document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.add("current");
                        document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.add("over50");
                        document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.remove("disableList");
                    }
                    else{
                        document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.remove("current");
                        document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.remove("over50");
                        document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.add("completed");
                    }
                        
                }
               }
            }
            if(parentIndex!=0)
            {
                if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                {
                for(i=0;i<=parentIndex;i++)
                {
                    if(i==parentIndex){
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("disableList");
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("active");
                    }
                    else
                    {
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("disableList");
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("completed");
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("active");
                    }
                }
               }
            }
        }
        else{
            if(parentIndex!=0)
            {
                if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                {
                for(i=0;i<=parentIndex;i++)
                {
                    if(i==parentIndex){
                        document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("active");
                        var currentElement = $($('.sideMenuNavigationBar')[0]).find('li.sideMenuItem')[i];
                        $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[0].classList.add("disableList");
                        $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[0].classList.remove("active");
                        $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[childIndex].classList.remove("disableList");    
                        $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[childIndex].classList.add("active");   
                    }
                    else
                    {
                        document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("disableList");
                        document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.remove("active");
                    }
                }
               }
            }
            
        }
        fragmentContainer = document.getElementById("fragmentContainer");
        fragmentContainer.innerHTML = "";
        jQuery(fragmentContainer).html(sanitize(responseText));
    }
    else{
        verNavFragParent = document.getElementById("verNavFragParent");        
        if (verNavFragParent != null) {
            verNavFragParent.innerHTML = "";
            jQuery(verNavFragParent).html(sanitize(responseText));
            if(parentIndex!=0)
            {
                if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                {
                for(i=0;i<=parentIndex;i++)
                {
                    if(i==parentIndex){
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("disableList");
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("active");
                    }
                    else
                    {
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("disableList");
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("completed");
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("active");
                    }
                }
               }
            }
        }
        else{
            fragmentContainer = document.getElementById("fragmentContainer");
            fragmentContainer.innerHTML = "";
            jQuery(fragmentContainer).html(sanitize(responseText));
            
            if(parentIndex!=0)
            {
                if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                {
                    for(i=0;i<=parentIndex;i++)
                    {
                        if(i==parentIndex){
                            document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("active");  
                        }
                        else
                        {
                            document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("disableList");
                            document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.remove("active");
                        }
                    }
                }
            }
        }
    }
    if (isFirst) {
        jQuery('#navigationBackBtn').css('pointer-events', 'none');
        jQuery('#navigationBackBtn').css('cursor', 'auto');
        jQuery('#navigationBackBtn').css('opacity', '0.50');
        jQuery('#navigationBackBtn').css('box-shadow', 'none');
    } else {
        jQuery('#navigationBackBtn').css('pointer-events', 'all');
        jQuery('#navigationBackBtn').css('cursor', 'pointer');
        jQuery('#navigationBackBtn').css('opacity', '6');
    }
    
    if (isLast) {
        document.getElementById("finalSubmitBtn").style.display = "";
        document.getElementById("navigationNextBtn").style.display = "none";
    }
    else
    {
        document.getElementById("finalSubmitBtn").style.display = "none";
        document.getElementById("navigationNextBtn").style.display = "";
    }
    setProgressBar();
    alignNavigationContainerStyle();
    doInit('fragment');
    executeLoadEvents("7");
}

function createTransaction(ref, parameters)
{
    var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&controlId=" + ref.id + "&parameters=" + encode_utf8(JSON.stringify(parameters));
    var url = "portal/appTask.jsp?oper=CreateTransaction";
    CreateIndicator("application");
    new net.ContentLoader(url, navigHandler, generalErrorHandler, "POST", requestString, true);
}

function encrypt_AES(strText, strPassPhrase) {
    try {
        var iv = CryptoJS.lib.WordArray.random(128/8).toString(CryptoJS.enc.Hex);
        var salt = CryptoJS.lib.WordArray.random(128/8).toString(CryptoJS.enc.Hex);
        var aesUtil = new AesUtil(128, 1000);
        var ciphertext = aesUtil.encrypt(salt, iv, strPassPhrase, strText);
        var strEncText = (iv + "::" + salt + "::" + ciphertext);
        if(window.btoa) {
            strEncText = btoa(strEncText);
        } else {
            strEncText = Base64.encode(strEncText);
        }
        return strEncText;
    } catch(e) {
        return strText;
    }
}
function navigateToForm(ref,parameters)
{
    if(window.routeCriteriaForm)
    {
        var formName=window.routeCriteriaForm();
        if(formName!="")
            parameters.FormName=formName;
    }
    var requestString = "pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&controlId=" + ref.id + "&parameters=" + encode_utf8(JSON.stringify(parameters));
    var url = "portal/appTask.jsp?oper=NavigateToForm";
    CreateIndicator("application");
    new net.ContentLoader(url, navigHandler, generalErrorHandler, "POST", requestString, true);

}

function showSplitMessage(control,msg,msgTitle,dialogType, isClose, customConfirmLabel, customCloseLabel){
        if(dialogType.toLowerCase() == "error")
        {
            msg="<div class='typeError' style='color:#ba3212;margin-bottom: 10px;'><span style='font-size:27px;padding-right: 10px;'><svg width=\"27px\" height=\"27px\" viewBox=\"0 0 27 27\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>Group 9</title><g id=\"Symbols\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><g id=\"Group-9\"><circle id=\"Oval-Copy\" fill=\"#C85050\" cx=\"13.5\" cy=\"13.5\" r=\"13.5\"></circle><path d=\"M9.20710678,7.79289322 L13.4582007,12.0439871 L13.4040904,12.081191 L17.6923882,7.79289322 C18.0829124,7.40236893 18.7160774,7.40236893 19.1066017,7.79289322 C19.497126,8.18341751 19.497126,8.81658249 19.1066017,9.20710678 L14.8634134,13.4502951 L19.1066017,17.6923882 C19.497126,18.0829124 19.497126,18.7160774 19.1066017,19.1066017 C18.7160774,19.497126 18.0829124,19.497126 17.6923882,19.1066017 L13.4491533,14.8633668 L9.20710678,19.1066017 C8.81658249,19.497126 8.18341751,19.497126 7.79289322,19.1066017 C7.40236893,18.7160774 7.40236893,18.0829124 7.79289322,17.6923882 L12.0354648,13.4498166 L7.79289322,9.20710678 C7.40236893,8.81658249 7.40236893,8.18341751 7.79289322,7.79289322 C8.18341751,7.40236893 8.81658249,7.40236893 9.20710678,7.79289322 Z\" id=\"Combined-Shape-Copy\" fill=\"#FFFFFF\" fill-rule=\"nonzero\"></path></g></g></svg></span><span  style='font-size:16px;font-weight: bold;font-family:Open Sans;line-height: 22px;'>"+msgTitle+"</span></div>"+msg;
        }
        if(dialogType.toLowerCase() == "warning")
        {
            msg="<div class='typeWarning' style='color:#b36106;margin-bottom: 10px;'><span style='font-size:27px;padding-right: 10px;'><svg width=\"27px\" height=\"27px\" viewBox=\"0 0 27 27\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>Group 6</title><g id=\"Symbols\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><g id=\"Group-6\"><circle id=\"Oval-Copy\" fill=\"#B36106\" cx=\"13.5\" cy=\"13.5\" r=\"13.5\"></circle><path d=\"M13.5,18.5 C14.3284271,18.5 15,19.1715729 15,20 C15,20.8284271 14.3284271,21.5 13.5,21.5 C12.6715729,21.5 12,20.8284271 12,20 C12,19.1715729 12.6715729,18.5 13.5,18.5 Z M15,6 L14.5,17.5 L12.5,17.5 L12,6 L15,6 Z\" id=\"Combined-Shape-Copy\" fill=\"#FFFFFF\"></path></g></g></svg></span><span style='font-size:16px;font-weight: bold;font-family:Open Sans;'>"+msgTitle+"</span></div>"+msg;
            dialogType="confirm";
        }
        if(dialogType.toLowerCase() == "success")
        {
            msg="<div class='typeSuccess' style='color:#268844;margin-bottom: 10px;'><span style='font-size:27px;padding-right: 10px;'><svg width=\"27px\" height=\"27px\" viewBox=\"0 0 27 27\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>Group 5</title><g id=\"Symbols\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><g id=\"Group-5\"><circle id=\"Oval-Copy\" fill=\"#268844\" cx=\"13.5\" cy=\"13.5\" r=\"13.5\"></circle><path d=\"M19.7928932,8.29289322 C20.1834175,7.90236893 20.8165825,7.90236893 21.2071068,8.29289322 C21.5675907,8.65337718 21.5953203,9.22060824 21.2902954,9.61289944 L21.2071068,9.70710678 L12.2071068,18.7071068 C11.8466228,19.0675907 11.2793918,19.0953203 10.8871006,18.7902954 L10.7928932,18.7071068 L5.79289322,13.7071068 C5.40236893,13.3165825 5.40236893,12.6834175 5.79289322,12.2928932 C6.15337718,11.9324093 6.72060824,11.9046797 7.11289944,12.2097046 L7.20710678,12.2928932 L11.5,16.585 L19.7928932,8.29289322 Z\" id=\"Path-9-Copy\" fill=\"#FFFFFF\" fill-rule=\"nonzero\"></path></g></g></svg></span><span style='font-size:16px;font-weight: bold;font-family:Open Sans;'>"+msgTitle+"</span></div>"+msg;
            dialogType="error";
        }
        if(dialogType.toLowerCase() == "info")
        {
            msg="<div class='typeInfo' style='color:#0072c6;margin-bottom: 10px;'><span style='font-size:27px;padding-right: 10px;'><svg width=\"27px\" height=\"27px\" viewBox=\"0 0 27 27\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>Group 4</title><g id=\"Symbols\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><g id=\"Group-4\"><circle id=\"Oval-Copy\" fill=\"#0072C6\" cx=\"13.5\" cy=\"13.5\" r=\"13.5\"></circle><path d=\"M15,10.5 L15,21.5 L12,21.5 L12,10.5 L15,10.5 Z M13.5,5.5 C14.3284271,5.5 15,6.17157288 15,7 C15,7.82842712 14.3284271,8.5 13.5,8.5 C12.6715729,8.5 12,7.82842712 12,7 C12,6.17157288 12.6715729,5.5 13.5,5.5 Z\" id=\"Combined-Shape-Copy\" fill=\"#FFFFFF\"></path></g></g></svg></span><span style='font-size:16px;font-weight: bold;font-family:Open Sans;'>"+msgTitle+"</span></div>"+msg;
            dialogType="error";
        }
        if( isClose == undefined ){
            isClose = true;
        }
        if(dialogType.toLowerCase() == "error"){
            showBootBox(control, msg, "error",isClose, customConfirmLabel, customCloseLabel)
        }
        else if(dialogType.toLowerCase() == "confirm"){
            showBootBox(control, msg, "confirm", isClose, customConfirmLabel, customCloseLabel)
        }
   
}

function  setDocListCss(){
    if($(".doc-list-unit")!=undefined){
        var len = $(".doc-list-unit").length;
        for(var i = 0 ; i < len-1 ; i++){
            $($(".doc-list-unit")[i]).css('border-bottom' , '1px solid #C1C1C1');
        }
    }
}


function logout() {
    var btns = {
        confirm: {
            label: YES,
            className: 'btn-success'
        },
        cancel: {
            label: NO,
            className: 'btn btn-primary'
        }
    }

    var userAction = function (result) {
        if (result === true) {
            var url = "portal/appTask.jsp";
            var queryString = "oper=Logout&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
            CreateIndicator("application");
            new net.ContentLoader(url, logoutHandler, generalErrorHandler, "POST", queryString, true);
            }
        }
    showConfirmDialog(LOGOUT_MSG, btns, userAction,false);
}

function customLogout()
{
    var url = "portal/appTask.jsp";
    var queryString = "oper=Logout&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
    CreateIndicator("application");
    new net.ContentLoader(url, window.parent.customLogoutHandler, generalErrorHandler, "POST", queryString, true);
}

function logoutHandler()
{
    showAlertDialog(SHOW_LOGOUT_MSG, false);
    cleanPortalSession();
}
function getDeviceType(){
    var userAgent = navigator.userAgent.toLocaleLowerCase();    
    var isMobile = false;
    if(userAgent.indexOf("mobile")!=-1 || userAgent.indexOf("android")!=-1 || userAgent.indexOf("ipod")!=-1 || userAgent.indexOf("webos")!=-1 || userAgent.indexOf("iphone")!=-1 || userAgent.indexOf("ipad")!=-1 || userAgent.indexOf("blackberry")!=-1 || userAgent.indexOf("iemobile")!=-1 || userAgent.indexOf("opera mini")!=-1)
        isMobile = true;    
    return isMobile;
}
function toggleMenuItems(ref){
    
        var hidden = $(ref).find(".sideMenuChildContainer").css("display");
        $(".sideMenuChildContainer").css("display","none");
        $(".menuImage").each(function(){
            $(this).html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="18px" height="10px" viewBox="0 0 18 10" version="1.1"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Wizard-Steps-Popup" transform="translate(-318.000000, -425.000000)" fill="#3E3E3E" fill-rule="nonzero"><path d="M322,420 C322.512836,420 322.935507,420.38604 322.993272,420.883379 L323,421 L323,430 L332,430 C332.512836,430 332.935507,430.38604 332.993272,430.883379 L333,431 C333,431.512836 332.61396,431.935507 332.116621,431.993272 L332,432 L322,432 C321.487164,432 321.064493,431.61396 321.006728,431.116621 L321,431 L321,421 C321,420.447715 321.447715,420 322,420 Z" id="Path-15-Copy" transform="translate(327.000000, 426.000000) rotate(-45.000000) translate(-327.000000, -426.000000) "></path></g></g></svg>');
        });
        if(hidden=="none"){
           $(ref).find(".sideMenuChildContainer").css("display","inline-block");
           $(ref).find(".menuImage").html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="18px" height="10px" viewBox="0 0 18 10" version="1.1"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Wizard-Steps-Popup" transform="translate(-318.000000, -189.000000)" fill="#3E3E3E" fill-rule="nonzero"><path d="M322,192 C322.512836,192 322.935507,192.38604 322.993272,192.883379 L323,193 L323,201.999 L332,202 C332.512836,202 332.935507,202.38604 332.993272,202.883379 L333,203 C333,203.512836 332.61396,203.935507 332.116621,203.993272 L332,204 L322,204 C321.487164,204 321.064493,203.61396 321.006728,203.116621 L321,203 L321,193 C321,192.447715 321.447715,192 322,192 Z" id="Path-15" transform="translate(327.000000, 198.000000) scale(1, -1) rotate(-45.000000) translate(-327.000000, -198.000000) "/></g></g></svg>');
        }
        else {
           $(ref).find(".sideMenuChildContainer").css("display","none"); 
           $(ref).find(".menuImage").html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="18px" height="10px" viewBox="0 0 18 10" version="1.1"><g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Wizard-Steps-Popup" transform="translate(-318.000000, -425.000000)" fill="#3E3E3E" fill-rule="nonzero"><path d="M322,420 C322.512836,420 322.935507,420.38604 322.993272,420.883379 L323,421 L323,430 L332,430 C332.512836,430 332.935507,430.38604 332.993272,430.883379 L333,431 C333,431.512836 332.61396,431.935507 332.116621,431.993272 L332,432 L322,432 C321.487164,432 321.064493,431.61396 321.006728,431.116621 L321,431 L321,421 C321,420.447715 321.447715,420 322,420 Z" id="Path-15-Copy" transform="translate(327.000000, 426.000000) rotate(-45.000000) translate(-327.000000, -426.000000) "></path></g></g></svg>');
        }
    
}
function closeMenuModal(){
    $("#menuModal").css("display","none");
}

function showHideDocType(docId,docType,showHide)
{
    var i,j;    
    var tempid="#"+docId;
    tempid=sanitize(tempid,'string');
    var parent=$(tempid);
    if(parent!=null)
    {
        var temptype="#"+docType;
        temptype=sanitize(temptype,'string');
        var child= $(tempid+" "+temptype);
        if(child!=null)
        {
            for(i=0;i<$(".doc-list-body").length;i++)
            {
                if($($(".doc-list-body")[i]).attr("id") == docId)
                {
            
                    for(j=0;j<$($(tempid)).find('.doc-list-unit').length;j++){
                    if($($($($(tempid)).find('.doc-list-unit')[j]).find(".identifer")).attr("id") == docType)
                    {
                        if(showHide == true)
                            $($($(tempid)).find('.doc-list-unit')[j]).css("display","block");
                        else
                            $($($(tempid)).find('.doc-list-unit')[j]).css("display","none");
                    
                    }
                }
            }
            }
        }
    }
}
function openNav(){
    $('#submenu').css('width','75%');
    $("#fade").css({"width":"25%" , "left":"75%" ,"display":"" });
    $("#fade").on('click' , function(){
    $('#submenu').css('width','0');
    $("#fade").css({"width":"100%" , "left":"0" ,"display":"none" });
    });
}
window.addEventListener("orientationchange", function(e) {
    var temporientation;	
    if(window.orientation == "0" || window.orientation == "180")
        temporientation = "portrait";
    else if(window.orientation == "90" || window.orientation == "-90")
        temporientation = "landscape"; 	
    var orientation= temporientation.startsWith("landscape") ? "landscape" : "portrait";
    if(getDeviceType()){
    if(orientation == "landscape")
   {
       alert(orientation_msg);
       document.getElementById('fade').style.display="block";
   }
   else
   {
       document.getElementById('fade').style.display="none";
   }
   }
  });
  
  function alignStepsCSS()
  {
    if(document.getElementById("mainStepNo")!=null && document.getElementById("mainStepNo")!=undefined && document.getElementById("substepNo")!=null && document.getElementById("substepNo")!=undefined){
        var parentIndex=document.getElementById("mainStepNo").value;
        var childIndex=document.getElementById("substepNo").value;
        var element = document.getElementById("mainStepNo");
        var i,childStep,parentStep,ref,verNavFragParent;
        element.parentNode.removeChild(element);
        element = document.getElementById("substepNo");
        element.parentNode.removeChild(element);
        
        if(getDeviceType())
        {
            if(document.getElementsByClassName("navigationProgressBar").length != 0)
            {
                $(".menuSelected").each(function(){$(this).removeClass("menuSelected")});
                if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                {
                for(i=0;i<=parentIndex;i++)
                {
                    if(i==parentIndex){
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("active");
                        document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("active");
                        if(childIndex != "" && childIndex!=0)
                        {
                            document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].childNodes[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].classList.remove("active");
                            document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].childNodes[0].childNodes[0].childNodes[1].childNodes[0].childNodes[childIndex].classList.add("active");
                            ref= document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].childNodes[0].childNodes[0].childNodes[1].childNodes[0].childNodes[childIndex];
                            childStep = $(ref).find(".sideMenuChildLabelParent").text();
                            parentStep = $(ref).parent().parent().parent().find(".sideMenuLabelParent").text();
                            $(".parentStep").text(parentStep+' / ');
                            $(".parentStep").removeClass("stepcolor");
                            $(".childStep").text(childStep.substring(3));
                            $(".childStep").addClass("stepcolor");
                            document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].childNodes[0].childNodes[0].childNodes[1].childNodes[0].childNodes[childIndex].childNodes[1].classList.add("menuSelected");
                        }
                        else
                        {
                            ref=document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].childNodes[0].childNodes[0].childNodes[0];
                            if($(ref).siblings().length==0)
                            {
                                $(ref).addClass("menuSelected");
                                parentStep = $(ref).innerHTML;
                                $(".parentStep").text(parentStep);
                                $(".parentStep").addClass("stepcolor");
                                $(".childStep").text(" ");
                            }
                            else{
                                childStep = $(ref).siblings()[0].childNodes[0].childNodes[0].childNodes[1].innerHTML;
                                parentStep = $(ref).parent().parent().parent().find(".sideMenuLabelParent").text();
                                $(".parentStep").text(parentStep+' / ');
                                $(".parentStep").removeClass("stepcolor");
                                $(".childStep").text(childStep.substring(3));
                                $(".childStep").addClass("stepcolor");
                                document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].childNodes[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[1].classList.add("menuSelected");
                            }
                        }
                    }
                    else
                    {
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("completed");
                        document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("active");
                        document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.remove("active");
                    }
                }
               }
            }    
	}	
        else
        {
            if (childIndex != "") {
                verNavFragParent = document.getElementById("verNavFragParent");
                if (verNavFragParent != null) {
                    if(childIndex!=0)
                    {
                        if(childIndex!=null && childIndex!=undefined && childIndex != 0 && childIndex>0 && childIndex<10000)
                        {
                        for(i=0;i<=childIndex;i++)
                        {
                            if(i==childIndex){
                                document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.add("current");
                                document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.add("over50");
                                document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.remove("disableList");
                            }
                            else{
                                document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.remove("current");
                                document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.remove("over50");
                                document.getElementsByClassName("verticalNavigationProgressBar-item")[i].classList.add("completed");
                            }

                        }
                      }
                    }
                    if(parentIndex!=0)
                    {
                        if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                        {
                        for(i=0;i<=parentIndex;i++)
                        {
                            if(i==parentIndex){
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("disableList");
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("active");
                            }
                            else
                            {
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("disableList");
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("completed");
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("active");
                            }
                        }
                      }
                    }
                }
                else{
                    if(parentIndex!=0)
                    {
                        if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                        {
                        for(i=0;i<=parentIndex;i++)
                        {
                            if(i==parentIndex){
                                document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("active");
                                var currentElement = $($('.sideMenuNavigationBar')[0]).find('li.sideMenuItem')[i];
                                if($(currentElement).find('.sideMenuChildNavigationBar')[0]!=undefined){
                                    $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[0].classList.add("disableList");
                                    $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[0].classList.remove("active");
                                    $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[childIndex].classList.remove("disableList");    
                                    $($(currentElement).find('.sideMenuChildNavigationBar')[0]).find('li')[childIndex].classList.add("active"); 
                                }
                            }
                            else
                            {
                                document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("disableList");
                                document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.remove("active");
                            }
                        }
                       }
                    }

                }
            }
            else{
                verNavFragParent = document.getElementById("verNavFragParent");
                if (verNavFragParent != null) {
                    if(parentIndex!=0)
                    {
                        if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                        {
                        for(i=0;i<=parentIndex;i++)
                        {
                            if(i==parentIndex){
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("disableList");
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("active");
                            }
                            else
                            {
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("disableList");
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.add("completed");
                                document.getElementsByClassName("navigationProgressBar")[0].childNodes[i].classList.remove("active");
                            }
                        }
                       }
                    }
                }
                else{
                    if(parentIndex!=0)
                    {
                        if(parentIndex!=null && parentIndex!=undefined && parentIndex != 0 && parentIndex>0 && parentIndex<10000)
                        {
                        for(i=0;i<=parentIndex;i++)
                        {
                            if(i==parentIndex){
                                document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("active");  
                            }
                            else
                            {
                                document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.add("disableList");
                                document.getElementsByClassName("sideMenuNavigationBar")[0].childNodes[i].classList.remove("active");
                            }
                        }
                       }
                    }
                }
            }
        }   
    }
  }
  
  function getZoneList()
{
    var url = "action_API.jsp";
    var requestString = "getZoneList=Y";

        var resp = iforms.ajax.processRequest(requestString, url);
        return JSON.parse(decode_utf8(resp));
}
function setStatusTag(controlId,StatusMsg,Status)
{
    controlId=sanitize(controlId,'string');
    Status=sanitize(Status,'string');
    var id=controlId+"_statustag";
    if(document.getElementById(id) != null)
    {
        $('#'+id).removeClass();
        Status=Status.toLowerCase();
        if(Status=="positive")
    {
        $('#'+id).addClass('statustagPositive');
       
    }
    else if(Status == "negative")
    {
        $('#'+id).addClass('statustagNegative');
        
    }
    else if(Status=="neutral")
    {
         $('#'+id).addClass('statustagNetural');
       
    }
        $('#'+id).html(sanitize(StatusMsg,'html'));
    }
    else{
    var htmlValue="<span id='"+id+"' class='";
    Status=Status.toLowerCase();
    if(Status=="positive")
    {
        htmlValue=htmlValue+"statustagPositive'>";
    }
    else if(Status == "negative")
    {
        htmlValue=htmlValue+"statustagNegative'>";
    }
    else if(Status=="neutral")
    {
        htmlValue=htmlValue+"statustagNetural'>";
    }
    htmlValue=htmlValue+StatusMsg+"</span>";
   var tempid='#'+controlId;
    if($(tempid).hasClass('FrameControl') == false)
    {
        $(tempid).append(sanitize(htmlValue,'html'));
    }
    else{
        $(tempid).find('.sectionStyle ').append(sanitize(htmlValue,'html'));
    }
    }
}
function enableNavigationOnStepClick(){
    if($(".stepNavigationContainerParent") != null && $(".stepNavigationContainerParent") != undefined){ //NavStyle1
        $(".stepNavigationContainerParent").find(".navigationProgressBar").find(".disableList").each(function(){ //Web
            $(this).removeClass("disableList");
        });
        if ($("#verticalNavigationContainerParent") != null && $("#verticalNavigationContainerParent") != undefined) { //NavStyle2
            $("#verticalNavigationContainerParent").find(".verticalNavigationProgressBar").find(".disableList").each(function() { //Web
                $(this).removeClass("disableList");
            });
        }
    }
    if($(".sideMenuNavigationBar") != null && $(".sideMenuNavigationBar") != undefined){ //NavStyle2
        $(".sideMenuNavigationBar").find(".disableList").each(function(){ //Web
            $(this).removeClass("disableList");
        });
    }
}
function enabledocument(docIndex)
{
    var id='textarea_'+docIndex;
    $(document.getElementById(id)).removeClass("disabledBGColor");
    $(document.getElementById(id)).prop("disabled", false);
    $($(document.getElementById(id).parentElement.parentElement).find(".doc-unit-delete")).css("display",'');
    
}
function disableNavigationStepClick(){
    if ($('.stepNavigationContainerParent')[0] != null) {  //NavStyle 1
        if(document.getElementById("menuContainer")!=null){  //PWA
            $("#menuParentDiv").find(".sideMenuNavigationBar li").each(function(){
                $(this).addClass("disableList");
            });
            $("#menuParentDiv").find(".sideMenuChildNavigationBar li").each(function(){
                $(this).addClass("disableList");
            });
        }
    }
}

window.addEventListener("message",function(e){
    var jsonObject = JSON.parse(e.data);
    var function_name = window[jsonObject.methodName];
    var param1 = jsonObject.param1;
    var param2 = jsonObject.param2;
    if(param1 == undefined){
        function_name();
    }else if(param2 == undefined){
        function_name(param1);
        }else{
        function_name(param1,param2);
        }                  
    });
    
function getFormDataWithTask()
{
    var url = "ifhandler.jsp";
    var requestString = "pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid)+
            "&fid="+encode_utf8(fid)+"&attrName="+encode_utf8("")+"&attrValue="+encode_utf8("")+
            "&attrType="+""+"&dateformat="+dateFormat+"&dateseparator="+dateSeparator+
            "&timeflag="+""+"&mobileMode=N&webdateFormat="+""+"&op=9";//timeFlag

    var responseText = iforms.ajax.processRequest(requestString, url);
    if(responseText.trim() != ""){
        var jsonObj = JSON.parse(responseText);
        window.parent.postMessage(jsonObj,domainURL);
        //return jsonObj;
    }
    return "";
}
function fieldValidation(ref,controlValue,isPaste){
        var validation=0;
        var patternStringRef=document.getElementById(ref.id+"_patternString");
        var letters = /^[A-Za-z]+$/;
        for(var i=0;i<controlValue.length&&validation!=1;i++)
        {
            var character=controlValue[i];
            if(patternStringRef.getAttribute("allowSpaces")==='false')
            {
                if(character==" ")
                {
                    validation=1;
                    if(isPaste)
                        showSplitMessage(ref,SPACE_NOT_ALLOWED, DATA_TITLE,"error");
                    else
                        showSplitMessage(ref,SPACE_NOT_ALLOWED_FOR+ref.id, DATA_TITLE,"error");
                }
            }    
            if(patternStringRef.getAttribute("allowNumbers")==='false')
            {
                if(!c_isNaN(character)) 
                {
                    validation=1;
                    if(isPaste)
                        showSplitMessage(ref,NUMBER_NOT_ALLOWED,DATA_TITLE, "error");
                    else
                        showSplitMessage(ref,NUMBER_NOT_ALLOWED_FOR+ref.id,DATA_TITLE, "error");
                }         
            } 
            if(patternStringRef.getAttribute("allowAlphabets")==='false')
            {
                if(character.match(letters)) 
                {
                    validation=1;
                    if(isPaste)
                        showSplitMessage(ref,ALPHABET_NOT_ALLOWED,DATA_TITLE, "error");
                    else
                        showSplitMessage(ref,ALPHABET_NOT_ALLOWED_FOR+ref.id,DATA_TITLE, "error");
                }      
            }
            if(patternStringRef.getAttribute("specialcharacters")!='')
            {
                if(!character.match(letters)&&isNaN(character)&&character!=" ")
                {
                    if(patternStringRef.getAttribute("specialcharacters").indexOf(character)>=0) 
                    {
                        validation=1;
                        if(isPaste)
                            showSplitMessage(ref,character +NOT_ALLOWED,DATA_TITLE, "error");
                        else
                            showSplitMessage(ref,character +IS_NOT_ALLOWED_FOR+ref.id,DATA_TITLE, "error");
                    }      
                } 
            }
        } 
        if(validation==1)
        {
               return false;
        }
        return true;
}  

function setDocMandateCommentColor(doclistId , color){
    var noOfDocs = $("#"+doclistId).find(".doc-comments-mandate");
    var element;
    if(noOfDocs!=null && noOfDocs!=undefined)
        for(var i = 0 ; i < noOfDocs.length ; i++){
            element = $($(noOfDocs)[i]).find(".doc-unit-comments");
            if(element!=null && element!=undefined){
            for(var j = 0 ; j < element.length ; j++){
                if($($(element)[j]).find(".form-textarea").val()==""){
                    $($(element)[j]).find(".form-textarea").css("background-color",color);
                }
            }
            }
      }
}

function setTableCellReadOnly(tableId,rowIndex,colIndex,flag)
{
    var table = document.getElementById(tableId);
    var childElement;
    if (table != null && table != undefined)
    {
        var row = table.tBodies[0].getElementsByTagName("tr")[rowIndex];
        var col = row.getElementsByTagName("td")[colIndex + 1];
        var k,c;
        if(row != null && row != undefined )
        {
            var control = col.getElementsByClassName("control-class")[0];
            if (col != null && col != undefined)
            {
                if (flag){
                    control.setAttribute("readonly", true);
                    if(jQuery(control).hasClass("radio-group")==true){
                        childElement = control.children;
                        for(k=0;k<childElement.length;k++){
                           c = childElement[k].children[0];
                           c.setAttribute("readonly", true);
                           applyPointerEvents(c, "none");
                        }
                    }
                    else if(control.attributes !== null && control.attributes != undefined && control.attributes.controltype !== null && control.attributes.controltype != undefined && control.attributes.controltype.nodeValue == 'date'){
                        applyPointerEvents(control, "none");
                    }
                    else if(control.type == 'checkbox' || control.type == 'select-one'){
						applyPointerEvents(control, "none");
                    }
                }
                else {
                    control.removeAttribute("readonly");
                    if(jQuery(control).hasClass("radio-group")==true){
                         childElement = control.children;
                         for(k=0;k<childElement.length;k++){
                            c = childElement[k].children[0];
                            c.removeAttribute("readonly");
                            applyPointerEvents(c, "auto");
                         }
                    } 
                    else if(control.attributes !== null && control.attributes !== undefined && control.attributes.controltype !== null && control.attributes.controltype !== undefined && control.attributes.controltype.nodeValue == 'date'){
                        applyPointerEvents(control, "auto");
                    }
                    else if(control.type == 'checkbox' || control.type == 'select-one'){
                        applyPointerEvents(control, "auto");
                    }
                }
            }
        }
    }
}

function applyPointerEvents(control, pointerEventType){
    jQuery(control).parent().css("pointerEvents",pointerEventType);
    jQuery(control).css("pointerEvents",pointerEventType);
    jQuery(control).parent().css("cursor","default");
}

function getTileIdAndStatus(tileId){
    var count = tileId.lastIndexOf("-");
    var dataArray = [];
    dataArray.push(tileId.substring(0, count));
    dataArray.push(tileId.substring(count+1));
    return dataArray;
}

function updateInsertionOrderId(xml){
    var url = "ifhandler.jsp";
    var requestString = "pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid)+"&fid="+encode_utf8(fid)+"&op=5&AttribXML="+encode_utf8(xml.trim());
    var responseText = iforms.ajax.processRequest(requestString, url);
    return responseText;
}

function getControlElement(controlId) {
    var control = null;
    control = document.getElementById(controlId);
    if (control == null || control == undefined) {
        control = document.getElementsByName(controlId)[0];
        if (document.getElementsByName(controlId).length > 1) {
            console.warn("Duplicate elements found for controlId :" + controlId);
        }
    }
    if (control == null || control == undefined) {
        //console.error("Element missing for controlID : " + controlId);
    }
    return control;
}