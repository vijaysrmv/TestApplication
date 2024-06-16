var frolaMapper = {};
function saveRichTextEditorData(modalId,dataValue,isCopyRow){
    var textareas;
    textareas = document.getElementsByClassName("richtexteditor");
    if(modalId==undefined && dataValue==undefined && isCopyRow==undefined)
        textareas = document.getElementsByClassName("richtexteditor");
    else{
        textareas = $('#'+modalId).find(".richtexteditor");
    }
    
    var richTextEditorData=[];   
    if(window.getCustomRichTextEditorData){
        richTextEditorData=window.getCustomRichTextEditorData(textareas);
    }else{
        for(var i=(textareas.length-1);i>=0;i--){
           if(textareas[i]!=undefined && (jQuery("#"+textareas[i].id).attr("contentChanged")=="true" || isCopyRow)){
                    var editorData={};
                    editorData.id=textareas[i].id;
                    editorData.data=frolaMapper[editorData.id].html.get(true);
		    editorData.IndexString=$("#"+textareas[i].id).attr('IndexString'); //Bug 102785 
                    if(editorData.data.length == 0){
                        editorData.data="";
                    }
                    richTextEditorData.push(editorData);
                    if(modalId=="iFrameListViewModal")
                        dataValue[formatJSONValue(textareas[i].getAttribute("labelName"))]=editorData.data;
                    else if(modalId=="iFrameAdvancedListViewModal")
                        dataValue[formatJSONValue(textareas[i].id)]=editorData.data;
               
               jQuery("#"+textareas[i].id).removeAttr("contentChanged");
					
            }
        } 
    }           
    saveRichTextEditor(richTextEditorData);
    if(dataValue!=undefined)
        return dataValue;
}

function populateRichTextEditor(richTextEditorJSON){
    if(richTextEditorJSON.length>0){
        var url = "ifhandler.jsp";
        var requestString = "pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid)+"&op=6&fid="+encode_utf8(fid)+"&richTextEditorJSON="+JSON.stringify(richTextEditorJSON);
        var responseData = iforms.ajax.processRequest(requestString, url);    
        return responseData;
    }
    return "";
}

function saveRichTextEditor(richTextEditorData){
    if(richTextEditorData!=undefined && richTextEditorData.length>0){
        var url = "ifhandler.jsp";
        var requestString = "pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid)+"&fid="+encode_utf8(fid);
        requestString=requestString+"&op=7&richTextEditorData="+encode_utf8(JSON.stringify(richTextEditorData));
        var responseText=iforms.ajax.processRequest(requestString, url);
        if(responseText.trim()!=''){
        var jsonObj = JSON.parse(responseText.trim());
        if(jsonObj["status"]=="error"){
            showSplitMessage("",jsonObj["message"],SAVE_TITLE,"error");
        }
        else
            documentIndex=jsonObj["message"];
        }

    }
}

function expandTextareaSection(ref,textareaId){
    var control = getControlElement(textareaId);
    if(control != null)
       textareaId = control.getAttribute('id');
    if(jQuery(ref).attr("state") == "collapsed")
    {
        jQuery("#"+textareaId+"_expandcollapseicon").attr("src","resources/images/rte-up-arrow.png");
        jQuery(ref).attr("state","expanded");
        if(jQuery(ref).attr("painted")=="false"){            
            jQuery(ref).attr("painted","true");
            viewRichTextData(textareaId);
        }else
            jQuery(ref).parent().find(".fr-box").css("display", "block");
    }
    else
    {
        jQuery(ref).parent().find(".fr-box").css("display", "none");
        jQuery("#"+textareaId+"_expandcollapseicon").attr("src","resources/images/rte-down-arrow.png");
        jQuery(ref).attr("state","collapsed");            
    }  
    
    
}

function viewRichTextData(id){
    var control = getControlElement(id);
    if( control != null && control != undefined )
        id = control.getAttribute("id");
    if(window.customRichTextEditor){
        window.customRichTextEditor();
    }else{
        var richTextEditorJSON=[];
        var editor={};   
        var numOfRows;        
       try{
             numOfRows = document.getElementById(id).getAttribute("rows");
        }
        catch(ex){
          
        }
		var fonts = {
	      'Arial,Helvetica,sans-serif': 'Arial',
	      'Arial Black,Arial Bold,Gadget, sans-serif': 'Arial Black',
	      'Arial Narrow,Arial,sans-serif': 'Arial Narrow',
	      'Georgia,serif': 'Georgia',
	      'Impact,Charcoal,sans-serif': 'Impact',
	      'Tahoma,Geneva,sans-serif': 'Tahoma',
	      'Times New Roman,Times,serif,-webkit-standard': 'Times New Roman',
	      'Verdana,Geneva,sans-serif': 'Verdana',
	      'Helvetica Neue,Helvetica,Arial,sans-serif': 'Helvetica',
              'Roboto,sans-serif': 'Roboto',
              'Oswald,sans-serif': 'Oswald',
              'Montserrat,sans-serif': 'Montserrat',
              'Open Sans Condensed,sans-serif': 'Open Sans Condensed'
	    };
        var jsonArray=getFeatureForRichTextEditor();
		 var language = (typeof iformLocale == "undefined") ? 'en_us' : iformLocale;
        language = language.replace('/', '');
        var direction = "ltr";
        if (language.startsWith("ar"))
        {
            direction = "rtl"
        }
        var locale = "";
        switch (language) {
            case "ar":
                locale = "ar";
                break;
            case "ar_sa":
                locale = "ar";
                break;
            case "de":
                locale = "de";
                break;
            case "es":
                locale = "es";
                break;
            case "es_do":
                locale = "es";
                break;
            case "fr_fr":
                locale = "fr";
                break;
            case "nl":
                locale = "nl";
                break;
            case "pt":
                locale = "pt_pt";
                break;
        }

      var frolaEditor =  new FroalaEditor("#"+id, {
             key: 'eHE5C-11D2A2C1G2C6A4D-17d1F1FOOLb2KOPQGe1CWCQVTDWXGcA5A4D4C3E4C2E2E3D1B1==',
             toolbarSticky:false,
             toolbarButtons:jsonArray,
             heightMax:parseInt(numOfRows)*20,
             height: parseInt(numOfRows)*20,
             fontFamily: fonts,
             quickInsertEnabled: false,
             charCounterMax:maxCharacterLimitInRichTextEditor(id),
             charCounterCount:showCharCountInRichTextEditor(id),
             direction:direction,
             language:locale,
             zIndex:900,
             attribution: false,
             enter:froalaEnterKeyOption(id),
              events: {
            keydown: function (e) {
            updateSessionTimeout();
            },
            contentChanged: function (e, editor) {
            jQuery("#"+id).attr("contentChanged","true");
            onChangeRTE(id);
            },
            'blur': function () {
                if(window.onChangeEventInRichTextEditor){
                    window.onChangeEventInRichTextEditor(id);
                }
            },
            'image.beforeUpload' :  function (files) {
                var editor = this;
                if (files.length) {
                  var reader = new FileReader();
                  var currentImage = editor.image.get();
                  reader.onload = function (e) {
                    var result = e.target.result;
                    editor.image.insert(result, null, null, currentImage);
                  };
                  reader.readAsDataURL(files[0]);
                }
                editor.popups.hideAll();
                return false;

             },
             'image.error': function (error, response) {
                console.log(this);
                alert('error-->'+error);
             }
          }
        }, function(){             
        var responseText=populateRichTextEditor(richTextEditorJSON);        
        if(responseText.trim()!="")
        {   
            var jsonObj=JSON.parse(decode_utf8(responseText.trim()));
            for (var count = 0; count < jsonObj.length; count++) 
            {
                var ctrlId=jsonObj[count].id;
                var ctrlValue=jsonObj[count].value;
                var indexString=jsonObj[count].IndexString; //Bug 102785 
                $("#"+ctrlId).attr('indexString',indexString);
		frolaEditor.html.set(ctrlValue.replace("base href","base hreff"));
                if(richTextDiv.classList.contains("disabledTextarea")){
               frolaEditor.edit.off();
               } else {
               frolaEditor.edit.on();
           }
            }
        }  
        })
        
         frolaMapper[id] = frolaEditor;
    
        jQuery("#"+id).attr("painted","true");
        jQuery("#"+id).attr("initialized","true");        
        
        editor.id=id;
        richTextEditorJSON.push(editor);
        if(window.parent!=undefined && window.setDefaultRichTextData && window.setDefaultRichTextData(id)){
            var customData=window.setDefaultRichTextData(id);
           frolaMapper[id].html.set(customData.replace("base href","base hreff"));
		   
        }
        var richTextDiv = document.getElementById("expandibleDiv_"+id);        
        if(window.parent!=undefined && window.onLoadRichTextEditor)
            {
                try
                {
                    if(typeof window.onLoadRichTextEditor)
                        window.onLoadRichTextEditor(id);
                } 
                catch(e)
                {}
            }    
       
    }
}

var ENCODING="UTF-8";
var hexArr = new Array('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
function encode_utf8(ch)
{
    if (ENCODING.toUpperCase() != "UTF-8")
        return escape(ch);

    return encodeURIComponent(ch);

}

function getRichTextData(textareaId){
    return frolaMapper[textareaId].html.get(true); 
}

function saveRichTextData(textareaId,HTMLData){
    var i=0;
    var setIntervalid = setInterval(() =>{
        try{
            i++;
            valueChanged=false;
            frolaMapper[textareaId].html.set(HTMLData.replace("base href","base hreff"));
            $("#"+textareaId).attr("contentChanged","true");
            valueChanged=true;
            clearInterval(setIntervalid);
        }catch(e){
            if(i>=4){
                clearInterval(setIntervalid);
                console.error("saveRichTextData called on RTE with id="+textareaId+" which is not yet initialized.");
            }
        }
    },100);
}

function toggleRichTextEditor(textareaId,state){
    var richtextFrame = document.getElementById("expandibleDiv_"+textareaId);
    if(richtextFrame!=null && richtextFrame!=undefined){
        if(state=="expanded"){
            if(richtextFrame.getAttribute("state")=="collapsed")
                richtextFrame.click();    
        }
        else if(state=="collapsed"){
            if(richtextFrame.getAttribute("state")=="expanded")
                richtextFrame.click();    
        }
    }
}

function onChangeRTE(textareaId){
    var msgRef =  document.getElementById(textareaId+"_msg");
    if(jQuery("#"+textareaId).attr("required")!=undefined){
        if(getRichTextData(textareaId)!='' ){
            delete ComponentValidatedMap[textareaId];
            toggleErrorTooltip(jQuery("#"+textareaId),msgRef,null,true,0);
        }
        else{
            ComponentValidatedMap[textareaId]=false;
            toggleErrorTooltip(jQuery("#"+textareaId),msgRef,null,true,1);
        }
    }
    valueChanged=true;
    if(window.formChangeHook)
        formChangeHook(document.getElementById(textareaId));
}