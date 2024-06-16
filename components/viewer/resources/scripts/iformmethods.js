function changeLocale(locale){
    if(locale==iformLocale.replace('/',''))
        return;
    var prevLocale = iformLocale;
    var url = "portal/appTask.jsp";
    var queryString = "oper=localeReset&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid)+"&locale="+locale;
    var response = iforms.ajax.processRequest(queryString, url);
    if(response!=""){
        var res = JSON.parse(response);
	$("#oforms_iform").html(res.formHTML);
        document.dir = res.HTML_DIR;
         iformLocale = res.path;
        reloadlocaleSpecicificFiles(res,prevLocale);
        doInit('form');
    }
}

function reloadlocaleSpecicificFiles(res,prevLocale){
    var newPath = res.path;
    var rid = res.rid;
    var i,fileName,srcc,cssElem;
    var files = {"js":["constants.js","iformCustomMsg.js"],"css":["ifomstyle.css","floating-labels.css","bootstrap-rtl.min.css","jquery-ui-1.8.21.custom.css","froala"]};
    //reload JS files
    for(i=0;i<files.js.length;i++){
        //remove
        fileName=files.js[i];
        srcc = "resources/"+prevLocale+"scripts/"+fileName+"?rid="+rid;
        $("script[src='"+srcc+"']").remove();
        //add
        var jsElm = document.createElement("script");
        var jsSrc = "resources/" + newPath + "scripts/"+fileName+"?rid=" + rid;
        jsElm.type = "text/javascript";
        jsElm.src = jsSrc;
        document.getElementsByTagName("head")[0].appendChild(jsElm);
    }
    //reload CSS files
    for(i=0;i<files.css.length;i++){
        //removeCSS
        fileName=files.css[i];
        if(fileName=="bootstrap-rtl.min.css"){
            srcc = "resources/bootstrap/css/bootstrap-rtl.min.css?rid="+rid;
            if(prevLocale=='ar/'){
                $("link[href='"+srcc+"']").remove();
            }
            if(newPath=='ar/'){
                cssElem = document.createElement("link");
                cssElem.href = srcc;
                cssElem.rel = "stylesheet"; 
                cssElem.type = "text/css";
                document.getElementsByTagName("head")[0].appendChild(cssElem);
            }
        }
        else if(fileName=="froala"){
            var lcc = {"ar":"ar","ar_sa":"ar","de":"de","es":"es","es_do":"es","fr_fr":"fr","nl":"nl","pt":"pt_pt"};
            if(prevLocale!='en_us/'){
                srcc = "resources/scripts/froala_editor/js/languages/"+lcc[prevLocale.replace('/','')]+".js?rid="+rid;
                $("link[href='"+srcc+"']").remove();
            }
            if(newPath!='en_us/'){
                cssElem = document.createElement("link");
                cssElem.href = "resources/scripts/froala_editor/js/languages/"+lcc[newPath.replace('/','')]+".js?rid="+rid;
                cssElem.rel = "stylesheet"; 
                cssElem.type = "text/css";
                document.getElementsByTagName("head")[0].appendChild(cssElem);
            }
        }
        else{
            //remove
            srcc = "resources/"+prevLocale+"css/"+fileName+"?rid="+rid;
            $("link[href='"+srcc+"']").remove();
            //add
            cssElem = document.createElement("link");
            cssElem.href = "resources/" + newPath + "css/"+fileName+"?rid=" + rid;;
            cssElem.rel = "stylesheet";
            cssElem.type = "text/css";
            document.getElementsByTagName("head")[0].appendChild(cssElem);
        }
    }
}

function changePassword() {
    var sid = jQuery("#sid").val();
    var url = contextPath + "/getChangePasswordURL";
    var reqTok = iforms.ajax.processRequest("formuri=" + encode_utf8(url), contextPath + "/GetReqToken");
    var requestString = "pid=Emp001&wid=1&fid=Form&WD_SID=" + sid + "&WD_RID=" + reqTok;
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", url, false);
    xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            var cpUrl = xhttp.getResponseHeader("cpURL");
            var features = 'top=10,left=350,height=' + Math.min(window.screen.height - 50, 550) + ',width=600,toolbar=no,menubar=no,status=yes,scrollbars=no';
            window.open(cpUrl, "Change Password", features);
        }
    };
    xhttp.send(requestString);
}
function clearDatePickerValue(ref){
    if($(ref).hasClass('mydatepicker')){
        $(ref).datetimepicker1('clear');
    }
    else if($(ref).hasClass('mydatepicker1')){
        $(ref).datepicker('clear');
    }
    else if($(ref).hasClass('mydatetimepicker')){
        $(ref).datetimepicker1('clear');
    }
}