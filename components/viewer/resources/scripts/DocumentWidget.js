


function getIcon(type){
 if( type )
    type= type.toLowerCase();

 switch(type){

  case "pdf":
    return "resources/images/Icons/Group 7.png";
  case "png":
    return  "resources/images/Icons/Group 5.png";
  case "jpeg":
  case "jpg":
    return "resources/images/Icons/Group 6.png";
 case "docx": 
 case "doc":
    return "resources/images/Icons/Group 7 Copy 2.png";
 case "xlsx":  
 case "xls":
    return "resources/images/Icons/Group 8.png";
case "pptx":   
case "ppt":
    return "resources/images/Icons/Group 9.png";
  default:
    return "resources/images/Icons/Group 7 Copy 3.png"      
 }

}

function uploadFileToOD(files,ctrid,doctype, callback){
      CreateIndicator('cameraUpload');
      var formData = new FormData();
      //Bug 101202
      var fileName;
      var type;
      if(files.length !== undefined){          
          for (var x = 0; x < files.length; x++) {
            var file=files[x];  
            formData.append('filesData',file,encode_utf8(file.name));
            formData.append('fileName',encode_utf8(file.name));
            if ('name' in file) {
                  fileName = file.name; 
                  type=fileName.split('.')[fileName.split('.').length-1];
                  formData.append('fileType',type);
            }
            else{
                formData.append('fileType',file.type.split('/')[1]);
            }
          }
      }else{
        formData.append('filesData',files,encode_utf8(files.name));
        formData.append('fileName',encode_utf8(files.name));
        if ('name' in files) {
              fileName = files.name; 
              type=fileName.split('.')[fileName.split('.').length-1];
              formData.append('fileType',type);
        }
        else{
          formData.append('fileType',files.type.split('/')[1]);
        }  
      }
      formData.append('pid',encode_utf8(pid));
      formData.append('wid',wid);
      formData.append('tid',tid);
      formData.append('fid',encode_utf8(fid));
      formData.append('ctrId',encode_utf8(ctrid));
      formData.append('docType',encode_utf8(doctype));
      formData.append('Latitude',lattitude);
      formData.append('Longitude',longitude);            
      var timeoutInMills = 3000;
      if(window.getTimeoutInMills){
        timeoutInMills = getTimeoutInMills(ctrid,doctype);
      }
      
      jQuery.ajax({
        url: '../../DocumentUpload',
        data: formData,
        cache: false,
        contentType: false,
        processData: false,
        method: 'POST',
        type: 'POST', // For jQuery < 1.9
        success: function(response){
             if (response) {
                 //Bug 101202
                 var responsedataObj = JSON.parse(JSON.stringify(response));       
                 var dataObj = JSON.parse(responsedataObj.responseData);       
                    for(var i=0;i<dataObj.length;i++){
                        var obj=dataObj[i];
                       if(obj.errorFlag == false)
                          callback(obj.DocId,obj.fileName,obj.fileType,obj.fileSize);
                        else
                        {
                            showAlertDialog(obj.errorMessage,false,timeoutInMills);
                            RemoveIndicator('browseUpload');
                        }
                    }
                    if(responsedataObj.APIData!=null)
                        renderExecuteServerEventAPIData(responsedataObj.APIData);
            }else{
            	showAlertDialog(DOC_ERROR,false,timeoutInMills);
                RemoveIndicator('browseUpload');
            }
        },
        complete:function(){
            RemoveIndicator('cameraUpload');            
        }
    });
}

function docUnitName(ref){
    try{
    var dbid = "";
    var url = "portal/appTask.jsp";
    var queryString = "oper=GetDBId&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
    dbid = iforms.ajax.processRequest(queryString, url);
    var docID = $(ref).parent().parent().find('.doc-unit-name').attr("data-docid");
    var fileName = $(ref).parent().parent().find('.doc-unit-name').find("p").get(0).title;
    url = "../../docDownload?pid=" + pid + "&wid=" + wid + "&tid=" + tid + "&fid=" + fid + "&cabinetName=" + cabinetName + "&DocId=" + docID + "&DocName=" + fileName + "&Userdbid=" + dbid+"&ApplicationName="+applicationName;
    if (typeof iosDtype!='undefined' && iosDtype && (typeof mobileMode!='undefined' && mobileMode==='')) {
        var aTag = document.getElementById("docDowloada");
        if (aTag === null) {
            aTag = document.createElement("a");
            aTag.id = "docDownloadhi";
            aTag.style.display = "none";
            document.getElementById("oforms_iform").appendChild(aTag);
            $('#docDowloada').attr('target', '_blank');
        }
        aTag.href = url;
        aTag.click();
    } else {
        var iframess = document.getElementById("docDownloadhi");
        if (iframess === null) {
            iframess = document.createElement("iframe");
            iframess.id = "docDownloadhi";
            iframess.style.display = "none";
            document.getElementById("oforms_iform").appendChild(iframess);
        }
        iframess.src = url;
    }
    
    } catch(e){
    }
    
}

var globalref=null;
function deleteItem(event,ref){
    var fileName = $($(ref).parent().parent().find('.doc-unit-name p')[0]).text();  
    globalref=ref;
    var msg = DELETE_DOC_MSG+ fileName + " ?";
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
        if (result) {
            var itemToDelete = $(globalref).parent().parent().parent();   
            var docid =  itemToDelete.find(".doc-unit-name").attr("data-docid");
            var ctrid = jQuery(itemToDelete.parents(".doc-list-body")[0]).attr("id");
            var isDeleteDoc = true;
            if(window.preHookDeleteDocument){
                isDeleteDoc = preHookDeleteDocument(ctrid, docid, fileName);
            }
            if(isDeleteDoc){
                deletedoc(ctrid,docid, fileName);
                  $(itemToDelete).parent().remove();
                }
        }
    }
    showConfirmDialog(msg, btns, callback);
   
}

function attachmentDropdownToggle(event){
    var dropdown = $(event.target).parent().parent().siblings(".unit-attach-dropdown");
    if(dropdown.is(":visible")){
        dropdown.hide();
    }else{
        dropdown.show();
    }
}

function attachmentOptionToggle(event){
    var that = $(event.target);
    that.parent(".unit-attach-dropdown").children(".unit-attach-option").children(".hollow-star").show();
    that.parent(".unit-attach-dropdown").children(".unit-attach-option").children(".solid-star").hide();
    that.children(".solid-star").show();
    that.children(".hollow-star").hide();
    that.parent(".unit-attach-dropdown").hide();
}
//Bug 100451 
function addWaiverDocumentUnit(ref){
    var controlid = jQuery(jQuery(ref).parents(".doc-list-body")[0]).attr("id");
    var doctype = jQuery(ref).parents(".doc-unit-header").children()[0];
    doctype=doctype.getElementsByClassName("identifer");
    doctype=$(doctype).attr("id");
    var docUnitDetails="";
    var docUnitDiv = $(ref).closest(".doc-unit-header").siblings(".doc-unit-body");
    var url;
    var queryString;
    if(ref.checked){
        docUnitDetails += "<div class=\"col-md-12 col-sm-12 col-xs-12 doc-unit-detail\" data-docid=\""+doctype+"\">\n<div class=\"col-md-12 col-sm-12 col-xs-12 doc-unit-comments errorMessageHoverDiv\">\n";
        docUnitDetails += "<textarea class=\"form-textarea form-input control-class\" style=\"resize:none;margin-bottom:12px;border-color:#ccc;width:100%;padding:5px;padding-top: 12px;padding-bottom: 0px;\" maxlength=\"4000\" onmouseover=\"this.title=this.value\" rows=\"2\" onchange=\"updateWaiverDocComment(this)\" id=\"textarea_waiver_"+controlid+"_"+doctype+"\" datatype=\"textarea\" type=\"textarea\" required";
        docUnitDetails +="                                ></textarea>\n"+
                      "<label style=\"top:80px; \"  class=\"form-label control-label inputLabelStyle mandatoryLabel";
        docUnitDetails +="\"  id=\"textarea_waiver_"+controlid+"_"+doctype+"_label\">"+Doc_Comments_label+"</label>\n"+"<div class=\"mandatoryMessageDiv mndErrorMsgDiv\" id=\"textarea_waiver_"+controlid+"_"+doctype+"_msg\" style=\"display:none;\">"+Doc_Comments_Msg+"</div>           </div>\n" +
                                  "           </div>";
        docUnitDetails += "\n";                  
        docUnitDiv.append(docUnitDetails);
        url = "portal/appTask.jsp";
        queryString = "oper=UpdateWaiverModel&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&ctrId=" + encode_utf8(controlid) + "&doctype=" + encode_utf8(doctype)+"&waiver=Y";
        iforms.ajax.processRequest(queryString, url);
        initializeTextArea();
        initFloatingMessagesForPrimitiveFields('.errorMessageHoverDiv');
        if(document.getElementById(controlid+"_"+doctype+"_label")!=null){
            $(document.getElementById(controlid+"_"+doctype+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
            $(document.getElementById(controlid+"_"+doctype+"_label")).addClass('mandatoryLabel');
            document.getElementById(controlid+"_"+doctype+"_msg").removeAttribute("showMessage");
            $(document.getElementById(controlid+"_"+doctype)).removeClass('mandatory');
            delete ComponentValidatedMap[controlid+"_"+doctype];
       }
    }else{
           docUnitDiv.find(".doc-unit-detail").remove();
           url = "portal/appTask.jsp";
           queryString = "oper=UpdateWaiverModel&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid) + "&ctrId=" + encode_utf8(controlid) + "&doctype=" + encode_utf8(doctype)+"&waiver=N";
           iforms.ajax.processRequest(queryString, url);           
           initializeTextArea();
           initFloatingMessagesForPrimitiveFields('.errorMessageHoverDiv');
           if(document.getElementById(controlid+"_"+doctype+"_label")!=null){               
                 $(document.getElementById(controlid+"_"+doctype)).addClass('mandatory');                
           }
           delete ComponentValidatedMap["textarea_waiver_"+controlid+"_"+doctype];
          
    }    
}

function pickDocumentListFiles(event){
    var id = $(event.target).attr("id");
    var x = document.getElementById(id);// element id
    lattitude='';
    longitude='';
    var docUnitDiv = $(event.target).closest(".doc-unit-header").siblings(".doc-unit-body");
    var emptyUnit = true, docUnitDetails="";
    if(docUnitDiv.find(".doc-unit-detail").length>0){
      emptyUnit = false;
    }
    var controlid;
    var doctype;
    if ('files' in x) {
      if (x.files.length != 0) {
         for(var count=0;count<x.files.length;count++){
          var file = x.files[count];
           controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
           doctype = jQuery(x).parents(".doc-unit-header").children()[0];
           doctype=doctype.getElementsByClassName("identifer");
           doctype=$(doctype).attr("id");
           if(window.validateDocumentConfiguration)
           {
                var type;
               if ('name' in file) {
                   var fileName = file.name; 
                   type=fileName.split('.')[fileName.split('.').length-1];
                   
                }
                else
                {
                    type=file.type.split('/')[1];
                }
                  if(!validateDocumentConfiguration(controlid,doctype,file.size,type))
                  {
                       return false;
                  }
           }
           else
           {
               if('size' in file)
                {
                    var fileSize;
                    fileSize = (file.size/1024).toFixed(4);
                    if(fileSize>10240)
                    {
						x.onclick = function () {
                         this.value = null;
                    };
                        showAlertDialog(MAX_FILE_SIZE_ERROR,false);
                        return false;
                     }
                 }
                
           }
       }
         controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
         doctype = jQuery(x).parents(".doc-unit-header").children()[0];
         doctype=doctype.getElementsByClassName("identifer");
         doctype=$(doctype).attr("id");
          CreateIndicator('browseUpload');
          var isRestrictMultipleDocUpload=false;
          if(window.restrictMultipleDocUpload)
          {
              isRestrictMultipleDocUpload=restrictMultipleDocUpload(controlid,doctype);
              if(isRestrictMultipleDocUpload === true && emptyUnit==false)
              {
                  var docid=$(docUnitDiv.find(".doc-unit-detail")).find(".doc-unit-name").attr("data-docid");
                  deletedoc(controlid,docid);
                  $(docUnitDiv.find(".doc-unit-detail")).parent().remove();
              }
          }
           uploadFileToOD(x.files,controlid,doctype, function(docID,fileName,type,fileSize){ //Bug 101202
            
            $("#spinnerdiv").hide();
            fileSize = Math.floor(fileSize) + " KB";
            var icon= getIcon(type);
            docUnitDetails = "           <div class=\"row doc-unit-detail\">\n" +
                               "            <div class=\"col-md-6 col-sm-8 col-xs-12 \" style=\"padding-left:0px;padding-right:0px;padding-top:6px;border: 1px solid #EBEBEB;border-radius: 1px;background-color: #F9F9F9;margin-bottom:20px;\">\n";
            if((applicationName!=null && applicationName!='') || ((mobileMode=="ios") || (mobileMode=="android")))           
              docUnitDetails +=   "             <div class=\"col-8 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ;
            else if((window.opener!=null && typeof window.opener.applicationName!='undefined' && (window.opener.applicationName!=null && window.opener.applicationName!='')) || ((mobileMode=="ios") || (mobileMode=="android"))) 
              docUnitDetails +=   "             <div class=\"col-8 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ;
            else
              docUnitDetails +=   "             <div class=\"col-8 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"openDocInViewer(this)\">\n" ;  
            
            docUnitDetails +=   "               <img src=\""+ icon +"\" style=\"width: 18px; height: 21px;\"> <p title=\""+fileName+"\">"+ fileName +"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"col-1 doc-unit-size\">\n" +
                                "               <p style=\"white-space: nowrap;\">"+ fileSize +"</p>\n" +
                                "             </div>\n" +
                                "             <span class=\"col-1 doc-unit-open d-none d-sm-inline\"  data-docID=\""+ docID +"\" onclick=\"openDocInViewer(this)\">\n" +
                                "              <img class=\"delete-item\" src='../../components/viewer/resources/images/Open.svg'   /> \n" +
                                "             </span>\n" +
                                "             <span class=\"col-1 doc-unit-download d-none d-sm-inline\" data-docID=\""+ docID +"\" onclick=\"docUnitName(this)\">\n" +
                                "               <img class=\"download-item\" src='../../components/viewer/resources/images/Download.svg'   /> \n" +
                                "             </span>\n" +
                                "             <div class=\"col-1 col-xs-1 doc-unit-delete d-none d-sm-inline\" >\n" +
                                "            <span  onclick=\"deleteItem(event,this)\" style=\"cursor:pointer;\" ><?xml version=\"1.0\" encoding=\"UTF-8\"?><svg width=\"14px\" height=\"14px\"  viewBox=\"0 0 14 14\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>"+DELETE+"</title><g id=\"Portal\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><path d=\"M13.5,2 C13.7761424,2 14,2.22385763 14,2.5 C14,2.77614237 13.7761424,3 13.5,3 L13.5,3 L12,3 L12,13 C12,13.6 11.6,14 11,14 L11,14 L3,14 C2.4,14 2,13.6 2,13 L2,13 L2,3 L0.5,3 C0.223857625,3 3.38176876e-17,2.77614237 0,2.5 C-3.38176876e-17,2.22385763 0.223857625,2 0.5,2 L0.5,2 Z M11,3 L3,3 L3,13 L11,13 L11,3 Z M5.5,5 C5.77614237,5 6,5.22385763 6,5.5 L6,10.5 C6,10.7761424 5.77614237,11 5.5,11 C5.22385763,11 5,10.7761424 5,10.5 L5,5.5 C5,5.22385763 5.22385763,5 5.5,5 Z M8.5,5 C8.77614237,5 9,5.22385763 9,5.5 L9,10.5 C9,10.7761424 8.77614237,11 8.5,11 C8.22385763,11 8,10.7761424 8,10.5 L8,5.5 C8,5.22385763 8.22385763,5 8.5,5 Z M9.5,0 C9.77614237,-5.07265313e-17 10,0.223857625 10,0.5 C10,0.776142375 9.77614237,1 9.5,1 L4.5,1 C4.22385763,1 4,0.776142375 4,0.5 C4,0.223857625 4.22385763,5.07265313e-17 4.5,0 L9.5,0 Z\" id=\"Combined-Shape\" fill=\"#000000\" fill-rule=\"nonzero\"></path></g></svg></span>"+
                                "             </div>\n" +
                                "             <div class=\"col-1 doc-unit-mob d-block d-sm-none\" >\n" +
                                "            <span class=\"dropdown\">"+
                                "               <img class=\"more-item\" src='../../components/viewer/resources/images/More.png' data-bs-toggle=\"dropdown\" aria-expanded=\"false\" />"+
                                "               <ul class=\"dropdown-menu dropdown-menu-left\" style=\"text-align:left; padding-top:0px; padding-bottom:0px;padding:5px;font-size:12px;font-family:'Open Sans';\">"+
						"<li style=\"cursor:pointer;\" onclick=\"openDocInViewer($(this).closest('.doc-unit-mob'))\" ><img src='../../components/viewer/resources/images/Open.svg'/><span style=\"padding-left:10px;\" >Open</span></li>"+
                                                "<li style=\"cursor:pointer;\" onclick=\"docUnitName($(this).closest('.doc-unit-mob'))\"><img src=\"../../components/viewer/resources/images/Download.svg\"/><span style=\"padding-left:10px;\" >Download</span></li>  "+
                                                "<li style=\"cursor:pointer;\" onclick=\"deleteItem(event,$(this).closest('.dropdown'))\" ><?xml version=\"1.0\" encoding=\"UTF-8\"?><svg width=\"14px\" height=\"14px\"  viewBox=\"0 0 14 14\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>DELETE</title><g id=\"Portal\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><path d=\"M13.5,2 C13.7761424,2 14,2.22385763 14,2.5 C14,2.77614237 13.7761424,3 13.5,3 L13.5,3 L12,3 L12,13 C12,13.6 11.6,14 11,14 L11,14 L3,14 C2.4,14 2,13.6 2,13 L2,13 L2,3 L0.5,3 C0.223857625,3 3.38176876e-17,2.77614237 0,2.5 C-3.38176876e-17,2.22385763 0.223857625,2 0.5,2 L0.5,2 Z M11,3 L3,3 L3,13 L11,13 L11,3 Z M5.5,5 C5.77614237,5 6,5.22385763 6,5.5 L6,10.5 C6,10.7761424 5.77614237,11 5.5,11 C5.22385763,11 5,10.7761424 5,10.5 L5,5.5 C5,5.22385763 5.22385763,5 5.5,5 Z M8.5,5 C8.77614237,5 9,5.22385763 9,5.5 L9,10.5 C9,10.7761424 8.77614237,11 8.5,11 C8.22385763,11 8,10.7761424 8,10.5 L8,5.5 C8,5.22385763 8.22385763,5 8.5,5 Z M9.5,0 C9.77614237,-5.07265313e-17 10,0.223857625 10,0.5 C10,0.776142375 9.77614237,1 9.5,1 L4.5,1 C4.22385763,1 4,0.776142375 4,0.5 C4,0.223857625 4.22385763,5.07265313e-17 4.5,0 L9.5,0 Z\" id=\"Combined-Shape\" fill=\"#000000\" fill-rule=\"nonzero\"></path></g></svg><span style=\"padding-left:10px;\" >Delete</span></li> "+
                                                 "</ul>"+
                                "             </span>"+
                                "             </div>\n" +
                                          "           </div>\n" +
                                            "<div class=\"col-md-5 col-sm-4 col-xs-12 doc-unit-comments errorMessageHoverDiv\">\n"+
                                            "<textarea class=\"form-textarea form-input control-class\" style=\"resize:none;margin-bottom:12px;border-color:#ccc;width:100%;padding:5px;padding-top: 12px;padding-bottom: 0px;\" maxlength=\"4000\" onmouseover=\"this.title=this.value\" rows=\"2\" onchange=\"updateDocComment(this)\" id=\"textarea_"+docID+"\" datatype=\"textarea\" type=\"textarea\"";
            if($(docUnitDiv).hasClass("doc-comments-mandate") == true)
                docUnitDetails +=" required";    
            docUnitDetails +="                                ></textarea>\n"+
                                  "<label style=\"position:relative;top:0px; \"  class=\"form-label control-label inputLabelStyle ";
            if($(docUnitDiv).hasClass("doc-comments-mandate") == true)
                docUnitDetails +=" mandatoryLabel";
            docUnitDetails +="\"  id=\"textarea_"+docID+"_label\">"+Doc_Comments_label+"</label>\n"+"<div class=\"mandatoryMessageDiv mndErrorMsgDiv\" id=\"textarea_"+docID+"_msg\" style=\"display:none;\">"+Doc_Comments_Msg+"</div></div>";
            docUnitDetails += "\n";                  
            var docUnitHtml = "          <div class=\"col-md-12 col-sm-12 col-xs-12 doc-detail-wrapper px-4 my-1\">\n" + docUnitDetails + 
                                "           </div>\n";
            docUnitDiv.append(docUnitHtml); 
            initFloatingMessagesForPrimitiveFields('.errorMessageHoverDiv');
            initializeTextArea();
            if(document.getElementById(controlid+"_"+doctype+"_label")!=null){
                 $(document.getElementById(controlid+"_"+doctype+"_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                 $(document.getElementById(controlid+"_"+doctype+"_label")).addClass('mandatoryLabel');
                 document.getElementById(controlid+"_"+doctype+"_msg").removeAttribute("showMessage");
                 $(document.getElementById(controlid+"_"+doctype)).removeClass('mandatory');
                 delete ComponentValidatedMap[controlid+"_"+doctype];
            }
            if(window.postBrowseUpload){
                 postBrowseUpload(controlid,doctype,docID); 
            } 
            
           RemoveIndicator('browseUpload');
                 
           });
           setTimeout(5000);
       
       x.value="";      
    }
    } 
    else { // handling cases when files property isnt supported
      if (x.value == "") {
         alert("Please select a file.");
      } else {
        alert("The files property is not supported by your browser!");
      }
    }
}
function initializeTextArea()
{
    var $input = $('.form-input');
    var $textarea = $('.form-textarea');
    $input.focusout(function() {
                if($(this).val().length > 0) {
                    $(this).addClass('input-focus');
                    $(this).next('.form-label').addClass('input-focus-label');
                }
                else {
                    $(this).removeClass('input-focus');
                    $(this).next('.form-label').removeClass('input-focus-label');

                }
            });


            $textarea.focusout(function() {
                if($(this).val().length > 0) {
                    $(this).addClass('textarea-focus');
                    $(this).next('.form-label').addClass('textarea-focus-label');
                }
                else {
                    $(this).removeClass('textarea-focus');
                    $(this).next('.form-label').removeClass('textarea-focus-label');

                }
            });
}


function triggerLabelClick(event){
	if(window.customizeAllowedDocType)
    {
       var id = $(event.target).attr("id");
       var doctype;
       var controlid ;
       if(id != undefined)
       {
       var x = document.getElementById(id);
       controlid = jQuery(jQuery(x).parents(".doc-list-body")[0]).attr("id");
       doctype = jQuery(x).parents(".doc-unit-header").children()[0];
       doctype=doctype.getElementsByClassName("identifer");
       doctype=$(doctype).attr("id");
        var str=customizeAllowedDocType(controlid,doctype);
        document.getElementById(id).accept=str;
       }
    }
    $(event.target).nextAll("input").trigger("click");
}

var lattitude,longitude;    
function getLocation() {
  lattitude='';
  longitude='';  
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition, showError);
  } 
}

function updateLocation(){
    lattitude='';
    longitude=''; 
    if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
    } 
}

function showPosition(position) {
   lattitude=position.coords.latitude;
   longitude=position.coords.longitude;
}

function showError(error) {
  switch(error.code) {
    case error.PERMISSION_DENIED:
      showAlertDialog(ACCESS_DENIED_LOCATION,false);
      break;
    case error.POSITION_UNAVAILABLE:
      showAlertDialog(LOCATION_UNAVILABLE,false);
      break;
    case error.TIMEOUT:
      showAlertDialog(TIME_OUT_LOCATION,false);
      break;
    case error.UNKNOWN_ERROR:
      showAlertDialog(ERROR_OCCURRED,false);
      break;
  }
}


function openDocInViewer(ref){
    var dbid = "";
    var url = "portal/appTask.jsp";
    var queryString = "oper=GetDBId&pid=" + encode_utf8(pid) + "&wid=" + encode_utf8(wid) + "&tid=" + encode_utf8(tid) + "&fid=" + encode_utf8(fid);
    dbid = iforms.ajax.processRequest(queryString, url);
	dbid = dbid.trim();
    var docID;
    $($(ref).parent().parent().find('.doc-unit-name p')[0]).text()
    if($(ref).parent().parent().find('.doc-unit-name').attr("data-docid")==undefined){
        docID = $(ref).attr("data-docid");
    }else{
        docID = $(ref).parent().parent().find('.doc-unit-name').attr("data-docid");
    }
    
    // Bug 102271
    if(applicationName!=null && applicationName!=''){
        if(window.fetchDocumentIndex){
            var docindex=window.fetchDocumentIndex(docID);
            if(docindex!="")
                docID=docindex;
        }
    }
    url = "/omnidocs/WebApiRequestRedirection?Application=DocView&cabinetName="+cabinetName+"&sessionIndexSet=false&DocumentId="+docID+"&Userdbid="+dbid+"&S=S&enableDCInfo=true";
    var ScreenHeight=screen.height;
    var ScreenWidth=screen.width;
    var windowH=450;
    var windowW=950;
    var WindowHeight=windowH-100;
    var WindowWidth=windowW;
    var WindowLeft=parseInt(ScreenWidth/2)-parseInt(WindowWidth/2);
    var WindowTop=parseInt(ScreenHeight/2)-parseInt(WindowHeight/2)-50;
    window.open(url, 'DocView', 'scrollbars=yes,left='+WindowLeft+',top='+WindowTop+',height='+windowH+',width='+windowW+',resizable=yes')
     
}