
if( !iforms )
    var iforms = {};

if(!iforms.ajax)
{
    iforms.ajax =
    {        
        strResponse:null,
        url : null, 
        processRequest:function(pParam,pUrl)
        {   
            valueChanged = true;
            var rid = null;
            iforms.ajax.url = pUrl;
            var sid = sanitize(jQuery("#sid").val(),'string');
            if(pUrl === "action.jsp"){
               rid = jQuery("#rid_Action").val();
            } else if (pUrl === "action_API.jsp")  {
               rid = jQuery("#rid_ActionAPI").val();
            } else if (pUrl === "ifhandler.jsp") {
               rid = jQuery("#rid_IfHandler").val();
            } else if (pUrl === "listViewModal.jsp") {
               rid = jQuery("#rid_listviewmodal").val();
            } else if (pUrl === "advancedListViewModal.jsp") {
               rid = jQuery("#rid_advancelistviewmodal").val();
            } else if (pUrl === "picklistview.jsp") {
               rid = jQuery("#rid_picklistview").val();
            } else if (pUrl === "texteditor.jsp") {
               rid = jQuery("#rid_texteditor").val();
            } else if (pUrl === "webservice.jsp") {
               rid = jQuery("#rid_webservice").val();
            }else if (pUrl === "portal/appTask.jsp") {
               rid = jQuery("#rid_appTask").val();
            }
            rid=sanitize(rid,'string');
            if(rid != null && rid!=''){
               if(pUrl.indexOf('?') == -1) 
                    pUrl += "?WD_SID=" + sid + "&WD_RID="+rid;
               else
                    pUrl += "&WD_SID=" + sid + "&WD_RID="+rid;
            }
            this.strResponse = null;
            if( pUrl != undefined && pUrl != "undefined")
                this.sendRequest(pUrl, pParam);            
            else
                this.sendRequest("../action/actionhandler", pParam);            
            return this.strResponse;
        },
        createXMLHttpRequest:function()
        {
            try
            {
                return new XMLHttpRequest();
            } 
            catch(e)
            {}
            alert("XMLHttpRequest not supported");
            return null;
        },

        sendRequest:function(pUrl,pData)
        {
            if(pUrl.indexOf("?")>0) 
            {
                pUrl=pUrl + "&sid="+ getRandomNo();
            }
            else 
            {
                pUrl=pUrl + "?sid="+ getRandomNo();
            }
            if(pUrl.indexOf("&fid")<0)
                pUrl+="&fid="+encode_utf8(fid);
            if(pUrl.indexOf("&pid")<0)//Bug 85361 Start
                pUrl+="&pid="+encode_utf8(pid);
            if(pUrl.indexOf("&wid")<0)
                pUrl+="&wid="+wid;
            if(pUrl.indexOf("&tid")<0)
                pUrl+="&tid="+tid;//Bug 85361 End
            iforms.ajax.strResponse = "";
            objReq = this.createXMLHttpRequest();
            objReq.open("POST", pUrl, false);
            objReq.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8"); 
            objReq.onreadystatechange = this.onResponse;
            objReq.send(pData);
        },

        onResponse:function()
        { 
            try 
            {            
                    if (objReq.readyState==4) 
                    {   
                        if (objReq.status==200)
                        {
                            var accessible=false;
                            try{
                                var dummy=window.opener.document.getElementById("rid_Action");
                                accessible=true;
                            }catch(e){
                                
                            }                          
                            
                            var rid = objReq.getResponseHeader("WD_RID");
                            if(iforms.ajax.url == "action.jsp"){
                              jQuery("#rid_Action").val(rid);
                              if( accessible && window.opener && window.opener.document.getElementById("rid_Action") != null)
                                window.opener.document.getElementById("rid_Action").value = rid;
                            } else if (iforms.ajax.url == "action_API.jsp")  {
                              jQuery("#rid_ActionAPI").val(rid);
                              if(accessible && window.opener && window.opener.document.getElementById("rid_ActionAPI") != null)
                                window.opener.document.getElementById("rid_ActionAPI").value = rid;
                            } else if (iforms.ajax.url == "ifhandler.jsp") {
                              jQuery("#rid_IfHandler").val(rid);
                              if( accessible && window.opener && window.opener.document.getElementById("rid_IfHandler") != null)
                                window.opener.document.getElementById("rid_IfHandler").value = rid;
                        
                            } else if (iforms.ajax.url == "listViewModal.jsp") {
                              jQuery("#rid_listviewmodal").val(rid);
                               if( accessible && window.opener && window.opener.document.getElementById("rid_listviewmodal") != null)
                                window.opener.document.getElementById("rid_listviewmodal").value = rid;
                        
                            } else if (iforms.ajax.url == "advancedListViewModal.jsp") {
                              jQuery("#rid_advancelistviewmodal").val(rid);
                               if(accessible &&  window.opener &&  window.opener.document.getElementById("rid_advancelistviewmodal")!=null )
                                window.opener.document.getElementById("rid_advancelistviewmodal").value = rid;
                        
                            } else if (iforms.ajax.url == "picklistview.jsp") {
                              jQuery("#rid_picklistview").val(rid);
                               if(accessible &&  window.opener && window.opener.document.getElementById("rid_picklistview") != null)
                                window.opener.document.getElementById("rid_picklistview").value = rid;
                        
                            } else if (iforms.ajax.url == "texteditor.jsp") {
                              jQuery("#rid_texteditor").val(rid);
                              if(accessible &&  window.opener && window.opener.document.getElementById("rid_texteditor")!=null)
                                window.opener.document.getElementById("rid_texteditor").value = rid;
                        
                            } else if (iforms.ajax.url == "webservice.jsp") {
                              jQuery("#rid_webservice").val(rid);
                              if(accessible &&  window.opener && window.opener.document.getElementById("rid_webservice")!=null )
                                window.opener.document.getElementById("rid_webservice").value = rid;
                        
                            }else if (iforms.ajax.url == "portal/appTask.jsp") {
                                jQuery("#rid_appTask").val(rid);
                                if(accessible &&  window.opener && window.opener.document.getElementById("rid_appTask")!=null)
                                    window.opener.document.getElementById("rid_appTask").value = rid;
                        
                            }
                            
                            iforms.ajax.strResponse = objReq.responseText;                            
                        }
                        else if ( objReq.status==12029) //Bugzilla – Bug 53510
                        {
                            alert("Unable to connect to server");
                            return;
                        }
                    }
                }
            catch(e)
            {
                alert("Error fetching data.");
            }
        }
    }
}