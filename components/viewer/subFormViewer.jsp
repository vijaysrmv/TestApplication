<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.newgen.iforms.controls.EButtonControl"%>
<%@page import="com.newgen.iforms.controls.ERootControl"%>
<%@page import="java.util.Locale"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.iforms.controls.util.EControlHelper"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="com.newgen.iforms.util.StringUtils"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>

<%
ResourceBundle lbls = ResourceBundle.getBundle("ifgen",request.getLocale());
Locale omnilocale = null;
try {
        if (session != null && session.getAttribute("Omniapp_Locale") != null) {
            String omniappLocale = String.valueOf(session.getAttribute("Omniapp_Locale"));
            if (omniappLocale.split("_").length > 1) {
                String localeStr = omniappLocale.split("_")[0];
                String countryStr = omniappLocale.split("_")[omniappLocale.split("_").length - 1];
                omnilocale = new Locale(localeStr, countryStr);
            } else if (omniappLocale.split("-").length > 1) {
                String localeStr = omniappLocale.split("-")[0];
                String countryStr = omniappLocale.split("-")[omniappLocale.split("-").length - 1];
                omnilocale = new Locale(localeStr, countryStr.toUpperCase());
            } else {
                omnilocale = new Locale(omniappLocale);
            }
            lbls = ResourceBundle.getBundle("ifgen", omnilocale);
        }
    } catch (Exception ex) {
        NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception omniapp locale.." + ex.getMessage(), ex);
    }
  request.setCharacterEncoding("UTF-8");
            response.setHeader("Pragma", "no-cache"); //HTTP 1.0
            response.setDateHeader("Expires", -1); //prevents caching at the proxy servers
            
            WorkdeskModel wdmodel = null;
			String randomId = IFormUtility.getRid();
            String fSessionId = IFormUtility.getIFormSessionUID(request);   
            IFormSession formsession = (IFormSession) session.getAttribute(fSessionId);
            boolean isMasonaryEnabled=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.ENABLE_MASONARY)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.ENABLE_MASONARY) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.ENABLE_MASONARY)));
            boolean isEditableComboOnLoad=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)));
            boolean isShowGridComboLabel=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL)));boolean isReadOnlyForm = false;
            boolean isGridBatchingEnabled = false;      
            boolean isCheckboxValueChange=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.GRID_CHECKBOX_VALUE) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.GRID_CHECKBOX_VALUE)));
            boolean enableMobileViewForTiles=((AppTasks.getValueFromINI(IFormConstants.ENABLE_MOBILE_VIEW_FOR_TILES, request))!=null && "Y".equals(AppTasks.getValueFromINI(IFormConstants.ENABLE_MOBILE_VIEW_FOR_TILES, request))); 
            boolean isServerValidation = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION)));
			boolean isSkipResponseData = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SKIPRESPONSEDATA) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SKIPRESPONSEDATA)));
			boolean isReverseButtonOrder = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT)));
            String pid = "";
            if(IFormUtility.escapeHtml4(request.getParameter("pid"))!=null && IFormUtility.escapeHtml4(request.getParameter("pid"))!="")
                pid=IFormUtility.escapeHtml4(request.getParameter("pid"));
            String wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
            String tid = IFormUtility.getIFormTaskId(request);   
            String dateFormat = "dd/MMM/yyyy";
            String activityName="";
            String processName="";
            String processInstanceId = "";
            String cabinetName = "";
            String appServerIp = "";
            String appServerPort = "";
            String isDatePicker=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.HIDE_DATEPICKER_ON_DISABLE);
            String isOverlayOpen=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.RESTRICT_CLOSE_OVERLAY);
            boolean autoIncrementLabelDisplay=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_AUTO_INCREMENT_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_AUTO_INCREMENT_LABEL)));
            String listViewCharacterLimit =IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.LISTVIEW_CHARACTER_LIMIT);
            boolean multipleRowDuplicate=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MULTIPLE_ROW_DUPLICATE) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MULTIPLE_ROW_DUPLICATE)));
            String CleanMapOnCloseModal=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.CLEAN_MAP_ON_CLOSE_MODAL);
            String disableFieldFontColor=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.DISABLE_FIELD_FONT_COLOR);
            String userName = "";
            String activityID = "";
            String userIndex = "";
            String sessionID = "";
            String mobileMode = "";
            String subTaskId = "";
            String taskName = "";
            String assignedTo = "";
            String priorityLevel = "";
            String lockedByName = "";
            String processedBy = "";
            String introductionDateTime = "";
            String introducedAt = "";
            String queueId = "";
            String lockStatus = "";
            String userEmailId = "";
            String userPersonalName = "";
            String userFamilyName = "";
			String queueName = "";
            boolean validateSetValue=!(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.VALIDATE_SET_VALUE)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.VALIDATE_SET_VALUE) != null && "N".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.VALIDATE_SET_VALUE)));
            try {
                WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
                if (wisessionbean != null) {
                    LinkedHashMap workitemMap = wisessionbean.getWorkItems();                    
                    if(tid==null || tid.isEmpty()){
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                    } else {
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                    }
                    
                    activityName=wdmodel.getM_objGeneralData().getM_strActivityName();
                    processName=wdmodel.getM_objGeneralData().getM_strProcessName();
                    processInstanceId = wdmodel.getM_objGeneralData().getM_strProcessInstanceId();
					queueName = wdmodel.getM_objGeneralData().getM_strQueueName();
                    cabinetName = wdmodel.getM_objGeneralData().getM_strEngineName();
                    appServerIp = wdmodel.getM_objGeneralData().getM_strJTSIP();
                    appServerPort = wdmodel.getM_objGeneralData().getM_strJTSPORT();
                    userName =wdmodel.getM_objGeneralData().getM_strUserName();
                    activityID = wdmodel.getM_objGeneralData().getM_strActivityId();
                    sessionID = wdmodel.getM_objGeneralData().getM_strDMSSessionId();
                    subTaskId = wdmodel.getM_objGeneralData().getSubTaskId();
                    taskName = wdmodel.getM_objGeneralData().getTaskName();
                    isReadOnlyForm = "R".equals(wdmodel.getM_objGeneralData().getM_strMode());
                    isGridBatchingEnabled = (!"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()));
                    assignedTo = wdmodel.getM_objGeneralData().getM_strAssignedTo();
                    priorityLevel = wdmodel.getM_objGeneralData().getM_strPriorityLevel();
                    lockedByName = wdmodel.getM_objGeneralData().getM_strLockedByName();
                    processedBy = wdmodel.getM_objGeneralData().getM_strProcessedBy();
                    introducedAt = wdmodel.getM_objGeneralData().getM_strIntroducedAt();
                    introductionDateTime = wdmodel.getM_objGeneralData().getM_strIntroductionDateTime();
                    queueId = wdmodel.getM_objGeneralData().getM_strQueueId();
                    lockStatus = wdmodel.getM_objGeneralData().getM_strLockStatus();
                    userEmailId = wdmodel.getM_objGeneralData().getM_strUserEmailId();
                    userPersonalName = wdmodel.getM_objGeneralData().getM_strUserPersonalName();
                    userFamilyName = wdmodel.getM_objGeneralData().getM_strUserFamilyName();
                    userIndex = wdmodel.getM_objGeneralData().getM_strUserIndex();
                
                }
            } catch (Exception e) {
                
            }
             
            String iformVSessionUID = IFormUtility.getIFormVSessionUID(request);
            IFormViewer objViewer = (IFormViewer)session.getAttribute(iformVSessionUID);
            if (wdmodel != null) {
                dateFormat = wdmodel.getM_objGeneralData().getM_strDateFormat();
            }
            String applicationName="";
            mobileMode=objViewer.getM_objFormDef().getM_strMobileMode();
            applicationName=formsession.getM_strApplicationName();

            boolean isMobileMode=("ios".equalsIgnoreCase(mobileMode)||"android".equalsIgnoreCase(mobileMode))?true:false;
            String paddingLvw = "padding:70px;";
            String paddingAlvw = "padding:60px;";
            if( isMobileMode )
            {
                paddingLvw = "padding:5px;";
                paddingAlvw = "padding:10px;";
            }    
            String buttonId = IFormUtility.escapeHtml4(request.getParameter("buttonId"));
            EButtonControl buttonControl = (EButtonControl)objViewer.getM_objFormDef().getFormField(buttonId);
            if(buttonControl.getControlSetInfo()!=null)
            objViewer.getM_objFormDef().parseControlGroupInfo(buttonControl.getControlSetInfo(), "subform", buttonId);
            //for(int i=0;i<buttonControl.getFrameList().size();i++){
              //((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).getM_arrFrameControls().add(buttonControl.getFrameList().get(i));
           // }
          ((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).setBtnRef(buttonControl);
           
           
%>
<%if(isMobileMode){%>
<div class="modal-content">
            <div class="modal-header" style="padding-top:0px;padding-bottom:0px;border-bottom:0px;">
                <div style="width:100%;">
                        <span style="padding:0px 3px;float:right;text-align:end;">   
                            <button  style="margin-top:4px; float:<%=lbls.getString("RIGHT")%> " type="button" id="closeButton" class="close btn" data-bs-dismiss="modal">
                            <span><img width="15px" src="./resources/images/normal-cross.png"/></span>
                            </button>
                        </span>
                </div>
            </div>
            <div class="modal-body" id="mobileSubFormModal" style="height:auto;padding-top:0px;padding:0px;">
                <input type="hidden" id="subFormId" value="<%=buttonId%>" /> 
               <%=objViewer.getM_objFormDef().getRenderBlock(formsession, wdmodel)%>
               <div class="modal-footer" style="text-align:center;padding:7px;">
                <button id="SubFormDone" onclick="subformDone('<%=buttonId%>');" type="button" class="buttonStyle button-viewer" style="border-radius: 3px;"  data-bs-dismiss="modal"><%=lbls.getString("SUBFORM_DONE")%></button>
               </div>
            </div>

</div>
<%}else{%>
<!DOCTYPE html>
<html lang="en" dir=<%=lbls.getString("HTML_DIR")%>>
    <head>

        <title><%= buttonControl.getM_strControlLabel() %></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8,EmulateIE9,EmulateIE10,EmulateIE11" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-multiselect.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery-ui.js?rid=<%= randomId%>"></script>
        <link rel="stylesheet" href="resources/bootstrap/css/bootstrap-glyphicons.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery-editable-select.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.formError.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap.bundle.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/moment.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/purify.js?rid=<%= randomId%>"></script>      
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/constants.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-multiselect.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/iformCustomMsg.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/commonmethods.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/net.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/iformview.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/iformclient.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/floating-labels.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/editable-select.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/ifomstyle.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.min.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/navigation.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/floating-labels.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/css/common.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/css/customcss.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead.js?rid=<%= randomId%>"></script>
        <%if(enableMobileViewForTiles){%>        
        <link rel="stylesheet" type="text/css" href="resources/slick/slick.css?rid=<%= randomId%>"/>
         <link rel="stylesheet" type="text/css" href="resources/slick/slick-theme.css?rid=<%= randomId%>"/>
         <script type="text/javascript" src="resources/slick/slick.min.js?rid=<%= randomId%>"></script> 
          <%}%>
        
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datetimepicker.css?rid=<%= randomId%>">      
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-hijri-datetimepicker.css?rid=<%= randomId%>">      
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datetimepicker.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-hijri-datetimepicker.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/moment-hijri.js?rid=<%= randomId%>"></script>        
        <script type="text/javascript" src="resources/bootstrap/js/HijriGeoConversion.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.mask.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/jquery.datetimepicker.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.datetimepicker.full.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/autoNumeric.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/font-awesome.min.css?rid=<%= randomId%>">
	<script type="text/javascript" src="resources/scripts/securenumbermask.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/html2canvas.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/jquery.plugin.html2canvas.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/ajax.js?rid=<%= randomId%>"></script>
         <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/jquery-ui-1.8.21.custom.css?rid=<%= randomId%>">
         <script type="text/javascript" src="resources/bootstrap/js/bootbox.min.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/rte.js?rid=<%= randomId%>"></script>
         <link rel="stylesheet" href="resources/bootstrap/css/jquery.scrolling-tabs.css?rid=<%= randomId%>"/>
         <script type="text/javascript" src="resources/bootstrap/js/jquery.scrolling-tabs.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/tooltipster.bundle.min.js?rid=<%= randomId%>"></script>
         <link rel="stylesheet" href="resources/css/tooltipster.bundle.css?rid=<%= randomId%>"/>
         <link href="resources/scripts/froala_editor/css/froala_editor.pkgd.min.css?rid=<%= randomId%>" rel="stylesheet" type="text/css" />
         <link href="resources/scripts/froala_editor/css/froala_style.min.css?rid=<%= randomId%>" rel="stylesheet" type="text/css" />    
         <script type="text/javascript" src="resources/scripts/froala_editor/js/froala_editor.pkgd.min.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/rte.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/aes.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/pbkdf2.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/AesUtil.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/base64.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/iformapi.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/blowfish.js?rid=<%= randomId%>"></script>
         <link href="resources/css/openSans.css?rid=<%= randomId%>" rel="stylesheet" type="text/css">
         <script type="text/javascript" src="resources/bootstrap/js/masonrybootstrap5.js?rid=<%= randomId%>"></script>
         <script>
              var validateSetValue = "<%= validateSetValue %>";
            var contextPath = "<%= request.getContextPath() %>";
            var enableMasonary=<%=isMasonaryEnabled%>;
            var pid = "<%=pid%>";
            var wid = "<%=wid%>";
            var tid = "<%=tid%>";
            var dateFormat = "<%=dateFormat%>";
            var processName = "<%=processName%>";
            var activityName = "<%=activityName%>";
            var fid = "<%=IFormUtility.getIFormUID(request)%>";
            var isReadOnlyForm = <%=isReadOnlyForm%>;
            var processInstanceId="<%=processInstanceId%>";
            var cabinetName="<%=cabinetName%>";
            var userName = "<%=userName%>";
            var fSessionId = "<%=fSessionId%>";
            var sessionId = "<%=sessionID%>";
            var activityID = "<%=activityID%>";
            var userIndex = "<%=userIndex%>";
            var mobileMode = "<%=mobileMode%>";
            var subTaskId = "<%=subTaskId%>";
            var taskName = "<%=taskName%>";
            var globalDateFormat="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat()%>";
            var globalDateSeparator="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator()%>";
            var iformLocale="<%=lbls.getString("Path")%>";
			var formName = "<%=objViewer.getM_objFormDef().getM_strFormAlias()%>";//Bug 84017
            
			var queueName = "<%=queueName%>";
            var isEditableComboOnLoad = "<%=isEditableComboOnLoad%>";
            var isOverlayOpen = "<%=isOverlayOpen%>";
            var CleanMapOnCloseModal = "<%=CleanMapOnCloseModal%>";
            var disableFieldFontColor = "<%=disableFieldFontColor%>";    
            var isDatePicker = "<%=isDatePicker%>";
            var isGridBatchingEnabled = "<%=isGridBatchingEnabled%>";
            var isShowGridComboLabel = "<%=isShowGridComboLabel%>";
            var isCheckboxValueChange="<%=isCheckboxValueChange%>";
            var autoIncrementLabelDisplay = "<%=autoIncrementLabelDisplay%>";
            var listViewCharacterLimit = "<%=listViewCharacterLimit%>";
            var enableMobileViewForTiles = <%=enableMobileViewForTiles%>;
            var isServerValidation = "<%=isServerValidation%>";
			var isSkipResponseData = "<%=isSkipResponseData%>";
			var isReverseButtonOrder = "<%=isReverseButtonOrder%>";
            var multipleRowDuplicate = "<%=multipleRowDuplicate%>";
            var assignedTo = "<%=assignedTo%>";
            var priorityLevel = "<%=priorityLevel%>";
            var lockedByName = "<%=lockedByName%>";
            var processedBy = "<%=processedBy%>";
            var introductionDateTime = "<%=introductionDateTime%>";
            var introducedAt = "<%=introducedAt%>";
            var queueId = "<%=queueId%>";
            var lockStatus = "<%=lockStatus%>";
            var userEmailId = "<%=userEmailId%>";
            var userPersonalName = "<%=userPersonalName%>";
            var applicationName="<%=applicationName%>";
            var userFamilyName = "<%=userFamilyName%>";
            var queryString="<%=IFormUtility.escapeHtml4(request.getParameter("QueryString"))%>";
            window.onresize = function (e) {
                 var scrollerWidthofBrowser = getBrowserScrollSize().width;
                if(document.getElementById("headerDiv"))
                    document.getElementById("headerDiv").style.width=$(window).width()+"px";
                if(document.getElementById("affix_padding") && document.getElementById("headerDiv")){
                if(parseInt(window.innerHeight)>parseInt(document.getElementById("headerDiv").clientHeight*3)){
                
                    document.getElementById("affix_padding").style.paddingTop= (parseInt(document.getElementById("headerDiv").clientHeight))+"px";
                    if(document.getElementById("headerDiv").style.position!='fixed'){
                        document.getElementById("headerDiv").style.position='fixed';
                        document.getElementById("headerDiv").style.top='0';
                        document.getElementById("headerDiv").style.width=($(window).width() - scrollerWidthofBrowser )+"px";
                        }
                    
                    }
                else{
                    document.getElementById("headerDiv").style.position='';
                    document.getElementById("headerDiv").style.top='';
//                    document.getElementById("headerDiv").classList.remove("affix");
                   document.getElementById("headerDiv").style.width=($(window).width() - scrollerWidthofBrowser )+"px";
                    }
                }
                makeStickyTabs();
            }
        </script>  
         <style>
                    .input-group {
                        flex-wrap: inherit;
                    }
                    .datepicker .datepicker-days {
                        display: block;               
                    }
                    <%= objViewer.getM_objFormDef().getRenderCSS()%>		
			html,body{
                                margin:0;
                                padding:0;
                                height:100%;
                                width:100;
			}
			
                       /*.squaredTwo input[type=checkbox]:checked + label{
                           background-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                         }*/
                       .squaredTwo input[type=checkbox]:checked + div{
                           background-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                         }
                       .radioTwo input[type=radio]:checked + label{
                           background-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .squaredOne label:after{
                           border-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .radioOne label:after {
                             background-color: #<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .squaredOne input[type=checkbox]:checked + label,.radioOne input[type=radio]:checked + label{
                           border: 2px solid #<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       #oforms_iform{
                           margin: 0 auto;
                           padding:0px 0px 50px 0px;
                       }
                       .bootbox.modal {
                           z-index: 9999 !important;
                       }
                       .multiselect-container {
                            width: 100% !important;
                        }
                        .multiselect-container>li>a>label>input[type=checkbox] {
                            margin-left : 5px;
                            position : relative;
                        }
                        .multiselect-container>li>a>label {
                            padding: 3px 20px;
                        }
                        .disabledBGColor{
                            background-color: #e4e4e4 !important;
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
                        }
                        .disabledTableBGColor{
                            background-color: #e4e4e438 !important;
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
                        }
                        .disabledTableFont{
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
							opacity: 0.8 ;
                        }
                       <%if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objSectionFormStyle().isM_bRemoveMargins()){%>
                        .iform-table .radioTwo label:after{
                            top: 3px !important;
                            left: 3px !important;
                        }
                        .iform-table .radioOne label:after{
                            top: 1px !important;
                            left: 1px !important;
                        }
                        .fr-top{
                            border-top:0 !important;
                        }
                        <%}%>
                        
                        .fr-top{
                            border-top:0 !important;
                        }
                        .bootbox .btn:hover{
                             color:#<%= objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objButtonFormStyle().getM_strFontColor()%>;
                         }
        </style>
    </head>
    <body onload="doInit('subForm','<%=buttonId%>');" onkeydown="bodykeyDown(event);">
         <script>
            CreateIndicator("application");
        </script>
        <%
           String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
           String strKey = IFormUtility.getAesKey();
           String reqTok = (String) IFormUtility.escapeHtml4(request.getParameter("WD_RID"));
           String rid_Action = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/action.jsp");
           String rid_ActionAPI = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/action_API.jsp");
           String rid_IfHandler = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/ifhandler.jsp"); 
           String rid_listviewmodal = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/listViewModal.jsp");
           String rid_advancelistviewmodal = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/advancedListViewModal.jsp");
           String rid_picklistview = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/picklistview.jsp");
           String rid_texteditor = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/texteditor.jsp");
           String rid_webservice = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/webservice.jsp");
           String rid_appTask = IFormUtility.generateTokens(request,request.getContextPath() + "/components/viewer/portal/appTask.jsp");
         
        %>
        <input type="hidden" id="sid" name="sid" value= "<%=sid%>" >
        <input type="hidden" id="rid_Action" name="rid_Action" value= "<%=rid_Action%>" >
        <input type="hidden" id="rid_ActionAPI" name="rid_ActionAPI" value= "<%=rid_ActionAPI%>" >
        <input type="hidden" id="rid_IfHandler" name="rid_IfHandler" value= "<%=rid_IfHandler%>" >
        <input type="hidden" id="rid_listviewmodal" name="rid_listviewmodal" value= "<%=rid_listviewmodal%>" >
        <input type="hidden" id="rid_advancelistviewmodal" name="rid_advancelistviewmodal" value= "<%=rid_advancelistviewmodal%>" >
        <input type="hidden" id="rid_picklistview" name="rid_picklistview" value= "<%=rid_picklistview%>" >
        <input type="hidden" id="rid_texteditor" name="rid_texteditor" value= "<%=rid_texteditor%>" >
        <input type="hidden" id="rid_webservice" name="rid_webservice" value= "<%=rid_webservice%>" >
        <input type="hidden" id="rid_appTask" name="rid_appTask" value= "<%=rid_appTask%>" >
        <input type="hidden" id="pk" name="pk" value= "<%=strKey%>" >
         <div id="oforms_iform" style="padding-top:10px;">
           <%=objViewer.getM_objFormDef().getRenderBlock(formsession, wdmodel)%>
         </div>
         <div id="subformbtndiv">
             <button id="SubFormDone" onclick="subformDone('<%=buttonId%>');" type="button" class="buttonStyle button-viewer" style="border-radius: 3px;"  data-bs-dismiss="modal"><%=lbls.getString("SUBFORM_DONE")%></button>
         </div>
         <div class="modal"  id="searchModal" role="dialog" data-bs-backdrop="static" style="z-index:3003;">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title" id="picklistHeader" style="word-break: break-word;">Picklist</h4>
                         <div id="closeButton" class="close" onclick="disablePrevious()" data-bs-dismiss="modal">
                            <span class="glyphicon glyphicon-remove"></span>
                        </div>
                    </div>
                    <div  class="modal-body">

                        <div class="ratio ratio-16x9">
                            <iframe id="iFrameSearchModal" class="" src="" scrolling="no"></iframe>
                        </div>

                    </div>                        
                    <div class="modal-footer table-responsive container-fluid">
                        <button style="width:70px;" type="button" onclick="showNextPreviousResult('previous')" id="picklistPrevious" class=" btn btn-primary btn-sm pull-left" disabled="true"><%=lbls.getString("PREVIOUS")%></button>
                        <button style="width:50px;" type="button" onclick="showNextPreviousResult('next');" id="picklistNext" class="btn btn-primary pull-left btn-sm  "><%=lbls.getString("NEXT")%></button>
                        <button style="width:50px;" type="button" onclick="setSelectedRow();" data-bs-dismiss="modal" id="picklistOk" class=" btn btn-success btn-sm "><%=lbls.getString("OK")%></button> 
                        <button style="width:60px; padding-left:2px; padding-right:2px;" type="button" id="picklistCancel" class=" btn btn-danger btn-default btn-sm" onclick="disablePrevious()" data-bs-dismiss="modal"><span class="glyphicon "></span><%=lbls.getString("CANCEL")%></button>
                    </div>
                </div>
            </div>
        </div>
                    
        <div class="modal"  id="listViewModal" role="dialog" data-bs-backdrop="static" data-bs-keyboard="false" style="z-index:2000">
            <div id="iFrameListViewModal" style="<%= paddingLvw %>height:auto;" class="modal-dialog modal-xl modal-lg modal-sm">

            </div>
            <input id="table_id" style="display: none">
            <input id="rowCount" style="display: none">
        </div>
                    <div class="modal" id="advancedListViewModal" role="dialog" data-bs-keyboard="false" data-bs-backdrop="static">
                        <div id="iFrameAdvancedListViewModal" style="<%= paddingAlvw %>" class="modal-dialog modal-xl modal-lg modal-sm">
                            
                        </div>
                        <input id="advancedListview_id" style="display: none">
                        <input id="advancedListviewRowCount" style="display: none">
                    </div>
                    <div id="fade" class="black_overlay"/>
                    <button type="button" style="display:none" onclick="saveForm(1)"/>

              
            <script>
                $("#advancedListViewModal").on("hidden.bs.modal", function () {
                    var action=document.getElementById("advancedListViewModal").getAttribute("action");                 
                    var crossState=document.getElementById("advLVcloseButton").getAttribute("state");
                    clearAdvancedListviewMap(action,crossState);
                    removeAdvancedListviewrowToModify();
                });
                $(".headerframe").on("change",function(){initMasonry();});
            </script>      
            <script type="text/javascript" src="resources/scripts/DocumentWidget.js?rid=<%= randomId%>"></script>
    </body>
</html>
<%}%>