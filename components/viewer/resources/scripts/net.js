
var net=new Object();

net.READY_STATE_UNINITIALIZED=0;
net.READY_STATE_LOADING=1;
net.READY_STATE_LOADED=2;
net.READY_STATE_INTERACTIVE=3;
net.READY_STATE_COMPLETE=4;
net.pUrl = null;

/*--- content loader object for cross-browser requests ---*/
net.ContentLoader=function(url,onload,onerror,method,params,async,contentType){
    var indicatorId = randomANString();
    var rid = null; 
    valueChanged = true;
            var sid = jQuery("#sid").val();
            if(url == "action.jsp"){
               rid = jQuery("#rid_Action").val();
            } else if (url == "action_API.jsp")  {
               rid = jQuery("#rid_ActionAPI").val();
            } else if (url == "ifhandler.jsp") {
               rid = jQuery("#rid_IfHandler").val();
            } else if (url == "listViewModal.jsp") {
               rid = jQuery("#rid_listviewmodal").val();
            } else if (url == "advancedListViewModal.jsp") {
               rid = jQuery("#rid_advancelistviewmodal").val();
            } else if (url == "picklistview.jsp") {
               rid = jQuery("#rid_picklistview").val();
            } else if (url == "texteditor.jsp") {
               rid = jQuery("#rid_texteditor").val();
            } else if (url == "webservice.jsp") {
               rid = jQuery("#rid_webservice").val();
            }else if (url == "portal/appTask.jsp") {
               rid = jQuery("#rid_appTask").val();
            }
            if(rid != null && rid!=''){
               if(url.indexOf('?') == -1) 
                    url += "?WD_SID=" + sid + "&WD_RID="+rid;
               else
                    url += "&WD_SID=" + sid + "&WD_RID="+rid;
            }
    
    if(url.indexOf("?")>0)
    {
        url=url + "&sid="+  getRandomNo();
    }
    else
    {
        url=url + "?sid="+  getRandomNo();
    }
    if(url.indexOf("&fid")<0)
        url+="&fid="+encode_utf8(fid);
    if(url.indexOf("&pid")<0)//Bug 85361 Start
        url+="&pid="+encode_utf8(pid);
    if(url.indexOf("&wid")<0)
        url+="&wid="+wid;
    if(url.indexOf("&tid")<0)
        url+="&tid="+tid;//Bug 85361 End
    this.indicatorId = indicatorId;
    CreateIndicator(indicatorId);
    this.params=params;
    this.req=null;
    this.onload=onload;
	this.reqURL=url;
    this.onerror=(onerror) ? onerror : this.defaultError;
    this.loadXMLDoc(url,method,params,async,contentType);
}

net.ContentLoader.prototype.loadXMLDoc=function(url,method,params,async,contentType){
    
    if (!method){
        method="GET";
    }

    if(contentType == undefined)
        contentType = '';

    if (contentType == '' && method=="POST"){
        contentType='application/x-www-form-urlencoded';
    }
    if (window.XMLHttpRequest){
        this.req=new XMLHttpRequest();
    } 
    if (this.req){
        try{
            var loader=this;
            this.req.onreadystatechange=function(){
                net.ContentLoader.onReadyState.call(loader);
            }
            if(async == null)
                async = true;
         
            this.req.open(method,url,async);
            if (contentType){
                this.req.setRequestHeader('Content-Type', contentType);
            }
            this.req.send(params);
            if(!async) {          
                RemoveIndicator(this.indicatorId);          
            }
        }catch (err){
            this.onerror.call(this);
        }
    }
}

net.ContentLoader.onReadyState=function(){
    try{  
        var req=this.req;
        var ready=req.readyState;
        if (ready==net.READY_STATE_COMPLETE){
            var httpStatus=req.status;
            if (httpStatus==200 || httpStatus==0){
                                var accessible=false;
                                try{
                                    var dummy=window.opener.document.getElementById("rid_Action");
                                    accessible=true;
                                }catch(e){

                                }                   
				var rid = req.getResponseHeader("WD_RID");
				var reqURL = (typeof this.reqURL == 'undefined')? '': this.reqURL;
				
				if(reqURL.indexOf("action.jsp") > -1){
				  jQuery("#rid_Action").val(rid);
                                  if(accessible && window.opener && window.opener.document.getElementById("rid_Action")!=null)
                                    window.opener.document.getElementById("rid_Action").value = rid;
				} else if (reqURL.indexOf("action_API.jsp") > -1)  {
				  jQuery("#rid_ActionAPI").val(rid);
                                  if(accessible && window.opener && window.opener.document.getElementById("rid_ActionAPI")!=null)
                                     window.opener.document.getElementById("rid_ActionAPI").value = rid;
				} else if (reqURL.indexOf("ifhandler.jsp") > -1 ) {
				  jQuery("#rid_IfHandler").val(rid);
                                  if(accessible && window.opener && window.opener.document.getElementById("rid_IfHandler")!=null)
                                    window.opener.document.getElementById("rid_IfHandler").value = rid;
				} else if (reqURL.indexOf("listViewModal.jsp") > -1 ) {
				  jQuery("#rid_listviewmodal").val(rid);
                                  if( accessible && window.opener && window.opener.document.getElementById("rid_listviewmodal")!=null)
                                        window.opener.document.getElementById("rid_listviewmodal").value = rid;
				} else if (reqURL.indexOf("advancedListViewModal.jsp") > -1) {
				  jQuery("#rid_advancelistviewmodal").val(rid);
                                  if(accessible && window.opener && window.opener.document.getElementById("rid_advancelistviewmodal")!=null)
                                        window.opener.document.getElementById("rid_advancelistviewmodal").value = rid;
				} else if (reqURL.indexOf("picklistview.jsp") > -1 ) {
				  jQuery("#rid_picklistview").val(rid);
                                  if(accessible && window.opener && window.opener.document.getElementById("rid_picklistview")!=null)
                                        window.opener.document.getElementById("rid_picklistview").value = rid;
				} else if (reqURL.indexOf("texteditor.jsp") > -1 ) {
				  jQuery("#rid_texteditor").val(rid);
                                   if(accessible && window.opener && window.opener.document.getElementById("rid_texteditor")!=null)
                                    window.opener.document.getElementById("rid_texteditor").value = rid;
				} else if (reqURL.indexOf("webservice.jsp") > -1 ) {
				  jQuery("#rid_webservice").val(rid);
                                  if(accessible && window.opener && window.opener.document.getElementById("rid_webservice")!=null)
                                        window.opener.document.getElementById("rid_webservice").value = rid;
				}else if (reqURL.indexOf("portal/appTask.jsp") > -1 ) {
                                    jQuery("#rid_appTask").val(rid);
                                    if(accessible && window.opener && window.opener.document.getElementById("rid_appTask")!=null )
                                        window.opener.document.getElementById("rid_appTask").value = rid;
                                }
				
                this.onload.call(this);       
            }else{
                this.onerror.call(this);     
            }
    
            RemoveIndicator(this.indicatorId);
        }
    }
    catch(e){
        try{
            RemoveIndicator(this.indicatorId);
        }catch(ex){}
    }
}

net.ContentLoader.prototype.defaultError=function(){
    if(this.req.status==250)
    {       
        generateErrorAjaxCalls(this.req.getResponseHeader("ErrorMsg"));
    }
    else if(this.req.status==12029){
        alert(ERROR_SERVER); 
    }
    else
    {
   
        alert(ERROR_DATA);    
    }
}

function randomANString() {
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
    var string_length = 10;
    var randomstring = '';
    for (var i=0; i<string_length; i++) {
        var rnum = Math.floor(getRandomNo() * chars.length);
        randomstring += chars.substring(rnum,rnum+1);
    }
    return randomstring;
}

function CreateIndicator(indicatorFrameId){
    var ParentDocWidth = document.documentElement.clientWidth;
    var ParentDocHeight = document.documentElement.clientHeight;    
    
    var top = 0;
    var isSafari = navigator.userAgent.toLowerCase().indexOf('safari/') > -1;
    if(isSafari){
        top = window.document.body.scrollTop;
    }
    
    var ImgTop=ParentDocHeight/2-10 + window.document.documentElement.scrollTop + top;
    var ImgLeft=ParentDocWidth/2-25;
 
    try {
        if(document.getElementById(indicatorFrameId) != null){
            return;
        }
        var img = document.createElement("IMG");
        img.setAttribute("src", "../../components/viewer/resources/images/loading.svg");
        img.setAttribute("name", indicatorFrameId);
        img.setAttribute("id", indicatorFrameId);
        img.style.left = ImgLeft+"px";
        img.style.top = ImgTop+"px";
        img.style.width = "54px";
        img.style.height = "55px";
        img.style.position="absolute";
        img.style.zIndex = "9999999";
        img.style.visibility="visible";
        document.body.appendChild(img);
        document.getElementById("fade").style.display="";
    }
    catch(ex) {}
    document.body.style.cursor='wait';
}
 
function RemoveIndicator(indicatorFrameId){
    try {
        var img = document.getElementById(indicatorFrameId);
        document.body.removeChild(img);
        document.getElementById("fade").style.display="none";
    }
    catch(ex) {
        
    }
    document.body.style.cursor='auto';
}
