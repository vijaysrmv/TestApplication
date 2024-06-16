


function customValidation(op){
     switch (op) {
        case 'S':
            
            break;
        case 'I':
            
            break;
        case 'D':
           
            break;
        default:
            break;
    }
    
    return true;
}

function formLoad(){
  
}

function onRowClick(tableId,rowIndex){
    return true;
}

function customListViewValidation(controlId,flag){
    return true;
}   

function listViewLoad(controlId,action){
    
}

function clickLabelLink(labelId){
    if(labelId=="createnewapplication"){
        var ScreenHeight=screen.height;
        var ScreenWidth=screen.width;
        var windowH=600;
        var windowW=1300;
        var WindowHeight=windowH-100;
        var WindowWidth=windowW;
        var WindowLeft=parseInt(ScreenWidth/2)-parseInt(WindowWidth/2);
        var WindowTop=parseInt(ScreenHeight/2)-parseInt(WindowHeight/2)-50;
        var wiWindowRef = window.open("../viewer/portal/initializePortal.jsp?NewApplication=Y&pid="+encode_utf8(pid)+"&wid="+encode_utf8(wid)+"&tid="+encode_utf8(tid)+"&fid="+encode_utf8(fid), 'NewApplication', 'scrollbars=yes,left='+WindowLeft+',top='+WindowTop+',height='+windowH+',width='+windowW+',resizable=yes')
    }
}
function allowPrecisionInText(){
    return 2;
}

function maxCharacterLimitInRichTextEditor(id){
    
    // return no of characters allowed as per condition based on id of the field
    return -1;
}
function showCharCountInRichTextEditor(id){
    
    // return true; -- To show character count in RTE
   // return false; -- To hide character count in RTE
   return true;
}
function onChangeEventInRichTextEditor(id){
    // Write code here on change of Rich Text Editor
}
function froalaEnterKeyOption(id){
    
    //When ENTER key is hit, a BR / DIV tag is inserted.
    //return FroalaEditor.ENTER_DIV
    //return FroalaEditor.ENTER_BR;
    return FroalaEditor.ENTER_P;
}

function showCustomErrorMessage(controlId,errorMsg){
    return errorMsg;
}

function resizeSubForm(buttonId){
    return {
        "Height":450,
        "Width":950
    };
}

function selectFeatureToBeIncludedInRichText(){
    return {
        'bold' :true,
        'italic':true,
        'underline':true,
        'strikeThrough':true,
        'subscript':true,
        'superscript':true,
        'fontFamily':true,
        'fontSize':true,
        'color':true,
        'inlineStyle':false,
        'inlineClass':false,
        'clearFormatting':true,
        'emoticons':false,
        'fontAwesome':false,
        'specialCharacters':false,
        'paragraphFormat':true,
        'lineHeight':true,
        'paragraphStyle':true,
        'align':true,
        'formatOL':false,
        'formatUL':false,
        'outdent':false,
        'indent':false,
        'quote':false,
        'insertLink':false,
        'insertImage':false,
        'insertVideo':false,
        'insertFile':false,
        'insertTable':true,
        'insertHR':true,
        'selectAll':true,
        'getPDF':false,
        'print':false,
        'help':false,
        'html':false,
        'fullscreen':false,
        'undo':true,
        'redo':true
        
    }
}

function allowDuplicateInDropDown(comboName){
    return false;
}

function postChangeEventHandler(controlId, responseData)
{
    
}
function isSectionWiseJSRequired()
{
    
  return false;  
}
function openBAMWindow(){
    var sessionId=getWorkItemData("sessionid");
    /*var URL="http://192.168.158.104:8080/bam/login/ExtendSession.app?CalledFrom=EXT&UserId="+getWorkItemData('userinfo').username+"&UserIndex="+getWorkItemData('userinfo').userindex+"&SessionId="+sessionId+"&CabinetName="+cabinetName+"&LaunchClient=RI&ReportIndex=36&AjaxRequest=Y&OAPDomHost=192.168.158.104:8080&CalledAs=MS&OAPDomPrt=http:";
    */
	/* userIndex
     * userName
     * cabinetName
     * sessionid--getWorkItemData("sessionid")
    */
    window.open(URL);
}


function restrictMultipleDocUpload(){
    return false;
}

