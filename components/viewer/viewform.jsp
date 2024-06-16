
<%@page import="java.io.StringReader"%>
<%@page import="com.newgen.iforms.custom.IFormCustomHooks"%>
<%@page import="com.newgen.iforms.util.MicroServiceSupportCommonUtility"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.IOException"%>
<%@page import="com.newgen.wfdesktop.xmlapi.WFAttribParser"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page import="com.newgen.iforms.nav.Menu"%>
<%@page import="com.newgen.iforms.util.CommonUtility"%>
<%@page import="com.newgen.iforms.nav.IFormFragInfo"%>
<%@page import="com.newgen.iforms.util.AESEncryption"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="com.newgen.iforms.custom.IFormContext"%>
<%@page import="com.newgen.iforms.custom.IFormServerEventHandler"%>
<%@page import="com.newgen.json.JSONArray"%>
<%@page import="com.newgen.iforms.custom.IFormAPIHandler"%>
<%@page import="com.newgen.iforms.custom.IFormReference"%>
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
<%@page import="nu.xom.Node"%>
<%@page import="nu.xom.*"%>
<%@page import="com.newgen.commonlogger.*"%>
<%@ include file="header.jsp"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session">
</jsp:useBean>

<%
ResourceBundle lbls = ResourceBundle.getBundle("ifgen",request.getLocale());
String omniappLocale = request.getParameter("locale");
Locale omnilocale = null;
try {
    if (session != null && omniappLocale != null && !"".equals(omniappLocale)) {
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
        session.setAttribute("Omniapp_Locale", IFormUtility.escapeHtml4(omniappLocale));
        lbls = ResourceBundle.getBundle("ifgen", omnilocale);
    }
} catch(Exception | Error ex) {
    NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp locale.." + ex.getMessage(), ex);
}
%>
<!DOCTYPE html>
<html lang="en" dir=<%= lbls.getString("HTML_DIR") %> >
    <head>
        <link href="../../favicon/logo.ico" rel="icon" type="image/x-icon">
        <%
            String randomId = IFormUtility.getRid();
            request.setCharacterEncoding("UTF-8");
            response.setHeader("Pragma", "no-cache"); //HTTP 1.0
            response.setDateHeader("Expires", -1); //prevents caching at the proxy server
            boolean isPWA = "Y".equals(AppTasks.getValueFromINI("PWAEnabled", request));
            boolean loginApplication=AppTasks.getValueFromINI("AdminLogin", request)!=null && "L".equalsIgnoreCase(AppTasks.getValueFromINI("AdminLogin", request));
            String adminLogin = loginApplication ? "L" : "";
            String AESENCRYPTION_STRING_FORM_VIEWER="FormViewer@2018";
            String mobileType = request.getParameter("mobileMode");
               if( mobileType == null || mobileType.equals("") )
                mobileType = "mobile";
               
            String ApplicationType = request.getParameter("FromApplication");
            if( ApplicationType == null || ApplicationType.equals("") )
                ApplicationType = "iforms";
             
            
            StringBuilder designMenu = new StringBuilder("");
            String callFrom = request.getParameter("callFrom");
            String extendSession = request.getParameter("ExtendSession");
            String authToken = request.getParameter("AuthToken");
            String isTokenizedAuth = request.getParameter("IsTokenizedAuth");
            WorkdeskModel wdmodel = null;
            IFormSession formsession = null;
            String pid = ""; 
            String wid = null;
            String formBufferPath = null;
            String additionalReqParams = null;
            String extraParams="";
            //Bug 100632 
            additionalReqParams=request.getParameter("additionalParams");
            extraParams=additionalReqParams;
            boolean isCustomEncryption= (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.IS_CUSTOM_ENCRYPTION) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.IS_CUSTOM_ENCRYPTION)));
            if(additionalReqParams!=null && !"".equals(additionalReqParams) && !isCustomEncryption){
            //if(additionalReqParams!=null && !"".equals(additionalReqParams)){
                extraParams="";
                try{
                    additionalReqParams = new String(Base64.decodeBase64(additionalReqParams.getBytes()));
                    additionalReqParams=AESEncryption.decrypt(additionalReqParams,"FormViewer@2018");
                }catch(Exception | Error ex){
                     NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in Decrypting Params..." + ex.getMessage() + "additionalReqParams = " + additionalReqParams, ex);
                }
               extraParams=IFormUtility.populateAdditionalParams(additionalReqParams);              
            }
            boolean isEncrypted = "Y".equalsIgnoreCase((String)request.getParameter("IsEncryptedAttributeXml"));
            if(ApplicationType.equals("pms") && request.getParameter("processInstanceId")!=null && request.getParameter("processInstanceId")!=""){
                 pid=IFormUtility.escapeHtml4(URLDecoder.decode(request.getParameter("processInstanceId"),"UTF-8"));
                 wid = (String)IFormUtility.escapeHtml4(request.getParameter("workItemId"));
                 additionalReqParams=(String)request.getParameter("additionalParams");
                 extraParams="";
                 if(additionalReqParams!=null){
                    extraParams=IFormUtility.populateAdditionalParams(additionalReqParams);
                 }
            }
            else if(IFormUtility.escapeHtml4(request.getParameter("pid"))!=null && IFormUtility.escapeHtml4(request.getParameter("pid"))!="") {
                pid= IFormUtility.escapeHtml4(URLDecoder.decode(request.getParameter("pid"),"UTF-8"));
                wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
            }
            
            
            String tid = IFormUtility.getIFormTaskId(request);   
            String fSessionId="";
            String pageformUID="";
            String fid = "";
            if(IFormUtility.escapeHtml4(request.getParameter("fid"))!=null)
                pageformUID= IFormUtility.escapeHtml4(URLDecoder.decode(request.getParameter("fid"),"UTF-8"));
            else
                pageformUID = "Form";
            
            //Bug 87917 
            if(pid == null || pid == ""){
                HttpSession session1=request.getSession(true);
            }
            if(ApplicationType.equals("pms") || mobileType.equals("android") || mobileType.equals("ios")){
                if("DataTemplateTaskForm".equals(pageformUID)){
                    fid=pageformUID;
                }else{
                    fid=pageformUID+"_"+pid+"_"+wid;
                }
                if(!"".equals(tid))
                    fid=fid+"_"+tid;
                fSessionId="i"+fid+"Session";
            } else {
                pageformUID=pageformUID+"_"+pid+"_"+wid;
                if(!"".equals(tid))
                    pageformUID=pageformUID+"_"+tid;
                fSessionId="i"+pageformUID+"Session";
            }
            
            if (session.getAttribute(fSessionId) == null || ApplicationType.equals("pms") || mobileType.equals("android") || mobileType.equals("ios")) {
                formsession = new IFormSession(request);
                session.setAttribute(fSessionId, formsession);
                customSession.setDMSSessionId(formsession.getM_strSessionId());
            } else {
                if(!ApplicationType.equals("pms") && (mobileType.equals("android") || mobileType.equals("ios")) && ("Form".equals(pageformUID) || "TemplateTaskForm".equals(pageformUID) || "CustomTemplateTaskForm".equals(pageformUID) || "DataTemplateTaskForm".equals(pageformUID)))
                    formsession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
                else
                    formsession = (IFormSession) session.getAttribute(fSessionId);
            }
            String contextPath = request.getContextPath();
            String extendUserIndex=IFormUtility.escapeHtml4Str((request.getParameter("ExtendUserIndex") != null) ? URLEncoder.encode(request.getParameter("ExtendUserIndex"),"UTF-8").replace("+","%20") : "");
            if("L".equalsIgnoreCase(AppTasks.getValueFromINI(IFormConstants.ADMIN_LOGIN, "N", request)) && "".equals(extendUserIndex) && "".equals(formsession.getM_strSessionId()) ) {
                response.sendRedirect(contextPath + "/components/viewer/portal/loginapp.jsp");
                return;
            }
            if(omnilocale != null){
                formsession.setObjLocale(omnilocale);
            }
            if( !ApplicationType.equals("pms") && mobileType.equals("mobile")){
                try {
                        formsession.setLocalIP(request.getLocalAddr());
                        formsession.setLocalPort(request.getLocalPort());
                        formsession.setClientIpAddr(IFormUtility.getClientIpAddr(request));
                    } catch (Exception | Error ex) {
                        NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp IP/Port..." + ex.getMessage(), ex);
                    }
                if(loginApplication && session.getAttribute("FormPath")==null){
                    CommonUtility.executeLoginBased(request, response);
                }
                else if(!"Y".equalsIgnoreCase(formsession.getExtendLogin())){
                if(request.getParameter("ExtendSession")!=null && !"".equalsIgnoreCase(request.getParameter("ExtendSession")) && "Y".equalsIgnoreCase(request.getParameter("ExtendSession"))){
                    String transcationId=IFormUtility.escapeHtml4Str(URLDecoder.decode(request.getParameter("TranscationId"),"UTF-8"));
                    CommonUtility.extendLogin(request,response,transcationId);
                } 
                else if(callFrom != null && session.getAttribute("FormPath")==null){
                      CommonUtility.executeLogin(request, response);
                }
            }
            }
            
                  
            customSession = CommonUtility.setWFCustomSessionObject(request, customSession);
            if(ApplicationType.equals("pms")){
//                if("Y".equalsIgnoreCase(IFormUtility.escapeHtml4(request.getParameter(IFormConstants.IS_TOKENIZEDAUTH)))) {
//                    formsession.setM_strSessionId(CommonUtility.getSessionIdFromToken(request));
//                }
//                else if(request.getParameter("SessionId")!=null) {
//                    if(request.getParameter("UDBEncrypt") != null && "Y".equalsIgnoreCase(request.getParameter("UDBEncrypt"))) {
//                        formsession.setM_strSessionId(IFormUtility.decryptStringData(request.getParameter("SessionId")));
//                        if(formsession.getM_strSessionId() == null)
//                        {
//                            formsession.setM_strSessionId(request.getParameter("SessionId"));
//                        }
//                    } else {
//                        formsession.setM_strSessionId(request.getParameter("SessionId"));
//                    }
//                }
            //&& request.getParameter("UDBEncrypt")== null)
           //formsession.setM_strSessionId(request.getParameter("SessionId"));  
                if(request.getParameter("authId")!=null) 
                    formsession.setM_strSessionId(request.getParameter("authId"));
                if(session.getAttribute("iFormWorkitemCount")==null){
                    session.setAttribute("iFormWorkitemCount",0);
                }
                else{
                    int updatedWICount = Integer.parseInt(session.getAttribute("iFormWorkitemCount").toString())+1;
                    session.setAttribute("iFormWorkitemCount",updatedWICount);
                 }
            }
            String alwaysCreateNew="";
            String applicationName="";
            String SessionExpireWarnTime="";
            String SessionWarnExtendTime="";
            String DeleteOldApplicationData="";
            String CreateTransactionOnLoad="";
            String alwaysOpenOldTransaction="";
            if( !ApplicationType.equals("pms") && mobileType.equals("mobile") )  {
                if(AppTasks.getINIMap(request) != null ){
                  applicationName= AppTasks.getValueFromINI("ApplicationName", request);
                  formsession.setM_strApplicationName(AppTasks.getValueFromINI("ApplicationName", request));
                  SessionExpireWarnTime=AppTasks.getValueFromINI("SessionExpireWarnTime", request);
                  SessionWarnExtendTime=AppTasks.getValueFromINI("SessionWarnExtendTime", request);
                } 
                if(AppTasks.getINIMap(request) != null ){
                    if(AppTasks.getINIMap(request).get("CreateNewApplication")!=null)
                       alwaysCreateNew=AppTasks.getValueFromINI("CreateNewApplication", request);
                    if(AppTasks.getINIMap(request).get("DeleteOldApplicationData")!=null)
                       DeleteOldApplicationData=AppTasks.getValueFromINI("DeleteOldApplicationData", request);
                    if(AppTasks.getINIMap(request).get("CreateTransactionOnLoad")!=null)
                       CreateTransactionOnLoad=AppTasks.getValueFromINI("CreateTransactionOnLoad", request);
                    if(AppTasks.getINIMap(request).get("AlwaysOpenOldTransaction")!=null)
                       alwaysOpenOldTransaction=AppTasks.getValueFromINI("AlwaysOpenOldTransaction", request);
                }    
            }
            boolean isMasonaryEnabled=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.ENABLE_MASONARY)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.ENABLE_MASONARY) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.ENABLE_MASONARY)));
            String domainURL=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.DOMAIN_URL);
            boolean isEditableComboOnLoad=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.EDITABLE_COMBO_ON_LOAD)));
            boolean isShowGridComboLabel = false;
            if(mobileType.equals("mobile"))
                isShowGridComboLabel=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL)));
            boolean isCheckboxValueChange=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.GRID_CHECKBOX_VALUE) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.GRID_CHECKBOX_VALUE)));
            boolean autoIncrementLabelDisplay=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_AUTO_INCREMENT_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_AUTO_INCREMENT_LABEL)));
            String listViewCharacterLimit =IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.LISTVIEW_CHARACTER_LIMIT);
            boolean multipleRowDuplicate=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MULTIPLE_ROW_DUPLICATE) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MULTIPLE_ROW_DUPLICATE)));
            boolean isGridBatchingEnabled = false;
            boolean isReadOnlyForm = false;
            boolean enableMobileViewForTiles=((AppTasks.getValueFromINI(IFormConstants.ENABLE_MOBILE_VIEW_FOR_TILES, request))!=null && "Y".equals(AppTasks.getValueFromINI(IFormConstants.ENABLE_MOBILE_VIEW_FOR_TILES, request)));
            boolean isServerValidation = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION)));
			boolean isSkipResponseData = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SKIPRESPONSEDATA) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SKIPRESPONSEDATA)));
			boolean isReverseButtonOrder = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.REVERSE_BUTTONS_IN_CUSTOM_ALERT)));
            boolean isSetWindowOpenerNull = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SET_WINDOW_OPENER_NULL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SET_WINDOW_OPENER_NULL)));
            //formBufferPath=(String) IFormUtility.escapeHtml4(request.getParameter("FormDir"));
            formBufferPath = formsession.getFormBufferPath(request);
            String dateFormat = "dd/MMM/yyyy";
            String dateDbFormat="";
            String dateSeparator="";
            String activityName="";
            String processName="";
            String processDefId="";		
            String processInstanceId = "";
            String cabinetName = "";
            String appServerIp = "";
            String appServerPort = "";
            String userName = "";
            String activityID = "";
            String userIndex = "";
            String sessionID = "";
            String mobileMode = "";
            String isDatePicker=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.HIDE_DATEPICKER_ON_DISABLE);
            String isOverlayOpen=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.RESTRICT_CLOSE_OVERLAY);
            String CleanMapOnCloseModal=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.CLEAN_MAP_ON_CLOSE_MODAL);
            String disableFieldFontColor=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.DISABLE_FIELD_FONT_COLOR);
            String subTaskId = "";
            String taskName = "";
            String calledForProcessReport=IFormUtility.escapeHtml4(request.getParameter("calledForProcessReport"));
            processDefId=request.getParameter("ProcessDefId");
            String registeredMode=request.getParameter("RegisteredMode");
            String mode=isReadOnlyForm?"R":"N";
            String formMode="W";//Bug 82321 
            String folderId = "";
            String formName=""; 
            String assignedTo = "";
            String priorityLevel = "";
            String lockedByName = "";
            String processedBy = "";
            String introductionDateTime = "";
//            String introducedAt = "";
            String queueId = "";
            String lockStatus = "";
//            String userEmailId = "";
            String userPersonalName = "";
            String userFamilyName = "";
            String pmwebtemp="";
			String queueName="";
             boolean allowEnableOnReadOnly= false;         //Bug:133243     
            boolean validateSetValue=!(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.VALIDATE_SET_VALUE)==null)||(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.VALIDATE_SET_VALUE) != null && "N".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.VALIDATE_SET_VALUE)));
            if(calledForProcessReport!=null){
                if(request.getParameter("FormName")!=null)
                  formName=IFormUtility.escapeHtml4(URLDecoder.decode(request.getParameter("FormName"),"UTF-8"));
                formName=IFormUtility.sanitizeForProcess(formName,true);
                pmwebtemp=IFormUtility.escapeHtml4(request.getParameter("pmwebtemp"));
                pmwebtemp=IFormUtility.sanitizeForProcess(pmwebtemp,true);
                File finput = IFormUtility.returnFile(pmwebtemp + File.separator + formsession.getM_strCabinetName() +File.separator+formsession.getM_strProcessDefId()+File.separator+formName+File.separator+formName+".xml");              
                formBufferPath=finput.getAbsolutePath();
            }
            String filterValue = "" , isNew = "";
            if(!ApplicationType.equals("pms") && mobileType.equals("mobile") ){
                applicationName= AppTasks.getValueFromINI("ApplicationName", request);
            }
            if( !ApplicationType.equals("pms") && mobileType.equals("mobile") )  {
                 filterValue = IFormUtility.escapeHtml4(request.getParameter("filterValue"));
                 isNew = IFormUtility.escapeHtml4(request.getParameter("isNew"));  
            }
            //filterValue = "1001";
     if( ApplicationType.equals("pms") ){
                FileOutputStream fosProcess=null;
            try {
             // String processDataDir=URLDecoder.decode(request.getParameter("ProcessDataDir"),"UTF-8");
               String processDataDir="";
               if(request.getParameter("ProcessDataDir")!=null){
                   processDataDir=URLDecoder.decode(request.getParameter("ProcessDataDir"),"UTF-8");
               }
               String strAttributeDataXml = URLDecoder.decode(request.getParameter("AttributeData"),"UTF-8");
               String generalData=URLDecoder.decode(request.getParameter("generaldata"),"UTF-8");
                if(formBufferPath!=null)
                 formBufferPath= URLDecoder.decode(formBufferPath,"UTF-8");                         
                if(isEncrypted){
                    strAttributeDataXml= AESEncryption.decrypt(strAttributeDataXml,"FormViewer@2018");
                    generalData= AESEncryption.decrypt(generalData,AESENCRYPTION_STRING_FORM_VIEWER);
                    if(formBufferPath!=null)
                        formBufferPath= AESEncryption.decrypt(formBufferPath,AESENCRYPTION_STRING_FORM_VIEWER);
                    if(!"".equals(processDataDir))
                         processDataDir= AESEncryption.decrypt(processDataDir,AESENCRYPTION_STRING_FORM_VIEWER);
                }
                activityID = IFormUtility.getGeneralDataParameter(generalData,"ActivityId");
                String processvariablesxml ="";
                //File f = IFormUtility.returnFile(processDataDir);
//                File processVarXMLFolder = f.getParentFile();
//                    if (processVarXMLFolder != null && !processVarXMLFolder.exists()) {
//                        processVarXMLFolder.mkdirs();
//                    }
                String formtempFolderPath = IFormINIConfiguration.getM_hINIHashMap().get("FormBufferDirectory");
                if (formtempFolderPath != null && !"".equals(formtempFolderPath)) {
                    formtempFolderPath += File.separator + IFormConstants.IFORMSCACHE + File.separator + formsession.getM_strCabinetName() + File.separator + formsession.getM_strProcessDefId()+ File.separator + activityID ;
                } else {
                    formtempFolderPath = ((IFormINIConfiguration.getNG_CACHE_LOCATION()!=null)?IFormINIConfiguration.getNG_CACHE_LOCATION():"") + IFormConstants.IFORMSCACHE + File.separator + formsession.getM_strCabinetName() + File.separator + formsession.getM_strProcessDefId()+File.separator+activityID;
                }
                File formsTempDir = IFormUtility.returnFile(formtempFolderPath);
                if (!(formsTempDir.isDirectory())) {
                    boolean bdircreated=formsTempDir.mkdirs();
                    if(!bdircreated){
                        NGUtil.writeConsoleLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Error in creating Directory :: " );
                    }
                }
                File f=null;
                if(!"".equals(processDataDir))
                     f = IFormUtility.returnFile(processDataDir);
                else
                     f = IFormUtility.returnFile(formtempFolderPath + File.separator + "processVarExt.log");
                boolean refreshCache = new IFormViewer().isRefreshCache(request);
                if(processDataDir.equals("") && (refreshCache || (f!=null && (!f.exists() || f.length()<=0)))){
                    try {
                            String fetchedProcessVariableXML = IFormUtility.getProcesVariableXML(request);
                            processvariablesxml = fetchedProcessVariableXML;
                            f.createNewFile();
                            fosProcess = IFormUtility.returnFileOutputStream(f);
                            fosProcess.write(fetchedProcessVariableXML.getBytes("UTF-8"));
                            fosProcess.flush();
                        } catch (Exception | Error ex) {
                            NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Error in creating processvarext :: " + ex.getMessage(), ex);
                        } finally {
                            if (fosProcess != null) {
                                try {
                                    fosProcess.close();
                                } catch (Exception | Error ex) {
                                    NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp file reading..." + ex.getMessage(), ex);
                                }
                            }
                        }
                }
                else if (f != null && f.exists()) {
                    Builder build = new Builder();
                    Document doc = null;
                    try
                    {
                        doc = build.build(f);
                    }
                    catch(Exception | Error ex){
                        NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp Document reading..." + ex.getMessage(), ex);

                    }
                    if( doc == null )
                    return;
                    processvariablesxml=doc.toXML();
                 }
                
               formsession.setWdtemptempPath(formBufferPath);
               WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
               if(wisessionbean==null){
                    wisessionbean = new WDWorkitems();
                    session.setAttribute("wDWorkitems", wisessionbean);
                }
               if("Form".equals(pageformUID) || "TaskForm".equals(pageformUID)  ){
                   WFAttribParser.prepareWorkitemModel(request, processvariablesxml, strAttributeDataXml, generalData,formsession);                  
                
                   if (wisessionbean != null) {
                        LinkedHashMap workitemMap = wisessionbean.getWorkItems();  
                        if(tid==null || tid.isEmpty()){
                           wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
			   isReadOnlyForm = "R".equals(wdmodel.getM_objGeneralData().getM_strMode());
                       } else {
                            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
							if(wdmodel != null ){
								String strMode = wdmodel.getM_objGeneralData().getM_strMode();
								if(!"R".equals(strMode)){
									strMode = wdmodel.getWfForm().getFormViewModeForTask();   
									if("R".equals(strMode)){
										wdmodel.getM_objGeneralData().setM_strMode("R");
									}
								}
								isReadOnlyForm = "R".equals(strMode);							
							}
                        }                    
                        activityName=wdmodel.getM_objGeneralData().getM_strActivityName();
                        if(formsession.getM_objIFormCabinetInfo()!=null){
                            wdmodel.getM_objGeneralData().setM_strJTSIP(formsession.getM_objIFormCabinetInfo().getM_strServerIP());
                            wdmodel.getM_objGeneralData().setM_strJTSPORT(formsession.getM_objIFormCabinetInfo().getM_strServerPort());
                        }
                        processName=wdmodel.getM_objGeneralData().getM_strProcessName();
                        processInstanceId = wdmodel.getM_objGeneralData().getM_strProcessInstanceId();
			queueName = wdmodel.getM_objGeneralData().getM_strQueueName();
                        cabinetName = wdmodel.getM_objGeneralData().getM_strEngineName();
                        folderId = wdmodel.getM_objGeneralData().getM_strFolderId();
                        appServerIp = wdmodel.getM_objGeneralData().getM_strJTSIP();
                        appServerPort = wdmodel.getM_objGeneralData().getM_strJTSPORT();
                        userName =wdmodel.getM_objGeneralData().getM_strUserName();
                        sessionID = wdmodel.getM_objGeneralData().getM_strDMSSessionId();
                        subTaskId = wdmodel.getM_objGeneralData().getSubTaskId();
                        taskName = wdmodel.getM_objGeneralData().getTaskName();
                        isGridBatchingEnabled = (!"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()));
                    }
               }
               
               if("TemplateTaskForm".equals(pageformUID) || "CustomTemplateTaskForm".equals(pageformUID) || "DataTemplateTaskForm".equals(pageformUID)) 
               {
                   WFAttribParser.prepareWorkitemModel(request, processvariablesxml, strAttributeDataXml, generalData,formsession); 
                   LinkedHashMap workitemMap = wisessionbean.getWorkItems();  
                   if(tid==null || tid.isEmpty()){
                       wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                    } else {
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                        if(wdmodel==null){
                            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                        }
                    }               
                   WFAttribParser.fetchProcessSpecificTaskTemplateData(wdmodel,formsession, request);
               }
               wdmodel.getM_objGeneralData().setM_strDateFormat(request.getParameter("DateFormat"));    
               if(request.getParameter("ServerTimeDiff")!=null){
                    wdmodel.getM_objGeneralData().setM_strServerTimeZone(request.getParameter("ServerTimeDiff"));  
               }
               if(request.getParameter("ClientTimeDiff")!=null){
                    wdmodel.getM_objGeneralData().setM_strClientTimeZone(request.getParameter("ClientTimeDiff"));
               }
               formMode=wdmodel.getM_objGeneralData().getM_strMode();//Bug 82321 Start
               userIndex = wdmodel.getM_objGeneralData().getM_strUserIndex();
               if(IFormUtility.isTaskIForm(formsession)){
                   wdmodel.getM_objGeneralData().setM_strMode("W");
                   formMode="W";
               }
               if(isReadOnlyForm){
                   formMode="R";
                   mode=isReadOnlyForm?"R":"N";
               	wdmodel.getM_objGeneralData().setM_strMode(mode);
                }//Bug 82321 End
            } catch (Exception | Error ex) {
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in creating process variable XML "+ex.getMessage(),ex);
            }
            finally{
                if(fosProcess!=null){
                    try {
                        fosProcess.flush();
                        fosProcess.close();
                    } catch (IOException ex) {
                        NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in creating process variable XML "+ex.getMessage(),ex);
                    }
                }
            }
          }
     else if (  mobileType.equals("android") || mobileType.equals("ios") ){
         try {
                WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
                if(wisessionbean==null){
                    wisessionbean = new WDWorkitems();
                    session.setAttribute("wDWorkitems", wisessionbean);
                }
                if (wisessionbean != null) {
                    LinkedHashMap workitemMap = wisessionbean.getWorkItems();                    
                    if(tid==null || tid.isEmpty()){
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                    } else {
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                    }
                    activityName=wdmodel.getM_objGeneralData().getM_strActivityName();
                    processName=wdmodel.getM_objGeneralData().getM_strProcessName();
                    processDefId=wdmodel.getM_objGeneralData().getM_strProcessDefId();
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
                }
                if("TemplateTaskForm".equals(pageformUID) || "CustomTemplateTaskForm".equals(pageformUID) || "DataTemplateTaskForm".equals(pageformUID)) 
               {
                   LinkedHashMap workitemMap = wisessionbean.getWorkItems();  
                   if(tid==null || tid.isEmpty()){
                       wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                    } else {
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                        if(wdmodel==null){
                            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                        }
                    }               
                   WFAttribParser.fetchTaskTemplateData(wdmodel,formsession, request);
               }
                
            } catch (Exception | Error ex) {
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp pageformUID..." + ex.getMessage(), ex);
                
            }
     }
     else {
         try {
                WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
                if (wisessionbean != null) {
                    LinkedHashMap workitemMap = wisessionbean.getWorkItems();                    
                    if(tid==null || tid.isEmpty()){
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                        isReadOnlyForm = "R".equals(wdmodel.getM_objGeneralData().getM_strMode());
                    } else {
                        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);   
                        
                        String strMode = wdmodel.getM_objGeneralData().getM_strMode();
                            if(!"R".equals(strMode)){
                                strMode = wdmodel.getWfForm().getFormViewModeForTask();   
                                if("R".equals(strMode)){
                                    wdmodel.getM_objGeneralData().setM_strMode("R");
                                }
                            }
                            isReadOnlyForm = "R".equals(strMode);
                    }
                    
                    if(wdmodel != null){
                        activityName=wdmodel.getM_objGeneralData().getM_strActivityName();
                        processName=wdmodel.getM_objGeneralData().getM_strProcessName();
                        processDefId=wdmodel.getM_objGeneralData().getM_strProcessDefId();
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
                        isGridBatchingEnabled = (!"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()));
                        assignedTo = wdmodel.getM_objGeneralData().getM_strAssignedTo();
                        priorityLevel = wdmodel.getM_objGeneralData().getM_strPriorityLevel();
                        lockedByName = wdmodel.getM_objGeneralData().getM_strLockedByName();
                        processedBy = wdmodel.getM_objGeneralData().getM_strProcessedBy();
//                        introducedAt = wdmodel.getM_objGeneralData().getM_strIntroducedAt();
                        introductionDateTime = wdmodel.getM_objGeneralData().getM_strIntroductionDateTime();
                        queueId = wdmodel.getM_objGeneralData().getM_strQueueId();
                        lockStatus = wdmodel.getM_objGeneralData().getM_strLockStatus();
//                        userEmailId = wdmodel.getM_objGeneralData().getM_strUserEmailId();
                        userPersonalName = wdmodel.getM_objGeneralData().getM_strUserPersonalName();
                        userFamilyName = wdmodel.getM_objGeneralData().getM_strUserFamilyName();
                        userIndex = wdmodel.getM_objGeneralData().getM_strUserIndex();
                        
                    }    
                }
            } catch (Exception | Error ex) {
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp general data..." + ex.getMessage(), ex);
                
            }
     }      
            IFormViewer objViewer = new IFormViewer();
            objViewer.setM_bIsEncrypted(isEncrypted);
            
            if( !ApplicationType.equals("pms") && mobileType.equals("mobile") )  {                    
                    userIndex= formsession.getM_strUserIndex();
                    userName=formsession.getM_strUserName();
                    cabinetName= AppTasks.getValueFromINI("CabinetName", request);
                    objViewer.init(request);
                    sessionID = String.valueOf(session.getAttribute("sessionId"));
                    formsession.setM_objFormViewer(objViewer);
                    try {
                       if(request.getParameter("callFrom") == null ){
                           //                            if("Y".equalsIgnoreCase(IFormUtility.escapeHtml4(request.getParameter(IFormConstants.IS_TOKENIZEDAUTH)))) {
//                                formsession.setM_strSessionId(CommonUtility.getSessionIdFromToken(request));
//                            }
//                            else if(IFormUtility.escapeHtml4(request.getParameter("UDB")) != null)
//                                formsession.setM_strSessionId(AESEncryption.decrypt(IFormUtility.escapeHtml4(request.getParameter("UDB")),"UserCon@2020"));
//                            else if(IFormUtility.escapeHtml4(request.getParameter("SessionId")) != null && request.getParameter("UDBEncrypt")== null)
//                                formsession.setM_strSessionId(IFormUtility.escapeHtml4(request.getParameter("SessionId")));
                             if(IFormUtility.escapeHtml4(request.getParameter("authId")) != null)
                                formsession.setM_strSessionId(IFormUtility.escapeHtml4(request.getParameter("authId")));
                       }
                    }
                    catch(Exception | Error ex)
                    {
                     NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp callFrom..." + ex.getMessage(), ex);   
                    }
                    if(IFormUtility.escapeHtml4(request.getParameter("userIndex"))!= null )
                        formsession.setM_strUserIndex(IFormUtility.escapeHtml4(request.getParameter("userIndex")));
                    if(IFormUtility.escapeHtml4(request.getParameter("userName")) != null )
                        formsession.setM_strUserName(IFormUtility.escapeHtml4(URLDecoder.decode(request.getParameter("userName"),"UTF-8")));
                    if(IFormUtility.escapeHtml4(request.getParameter("existingFid")) != null ){
                        session.setAttribute("IsPreview", "Y");
                        formsession.setM_strExistingFid(IFormUtility.escapeHtml4(request.getParameter("existingFid")));
                    }
                    else{
                        session.setAttribute("IsPreview", "N");
                    }
                    if( IFormUtility.escapeHtml4(request.getParameter("appName")) != null )
                        formsession.setM_strApplicationName(IFormUtility.escapeHtml4(request.getParameter("appName")));
                    if (omnilocale != null) {
                            objViewer.getM_objFormDef().setObjLocale(omnilocale);
                        }
            }
            String url="";
            //Bug 100632             
        if( applicationName!=null && !applicationName.isEmpty())
             objViewer.getM_objFormDef().setM_strExtraParams(extraParams);
        if( ApplicationType.equals("pms") ) {
            cabinetName = formsession.getM_strCabinetName();
            try{ 
                    objViewer.init(request,formBufferPath);
                     formsession.setM_objFormViewer(objViewer);
                    session.setAttribute("obj"+fid+"Viewer", objViewer);
                    if (wdmodel != null) {
                        dateFormat = wdmodel.getM_objGeneralData().getM_strDateFormat();
                    }
                    mobileMode=objViewer.getM_objFormDef().getM_strMobileMode();
                    objViewer.getM_objFormDef().setM_strExtraParams(extraParams);
                    String buttonId = request.getParameter("buttonId");
                    if(buttonId!=null && !buttonId.isEmpty()){
                        EButtonControl buttonControl = (EButtonControl)objViewer.getM_objFormDef().getFormField(buttonId);
                        ((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).setBtnRef(buttonControl);
                    }
                    url=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
                    if(calledForProcessReport!=null){
                        pmwebtemp=IFormUtility.escapeHtml4(request.getParameter("pmwebtemp"));
                        pmwebtemp=IFormUtility.sanitizeForProcess(pmwebtemp,true);
                        objViewer.getM_objFormDef().dumpHTMLforProcessReport(url,formsession,wdmodel,pmwebtemp,formName);
                    }
               if(omnilocale != null){
                   objViewer.getM_objFormDef().setObjLocale(omnilocale);
               }
            } catch(Exception | Error ex){
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp pmwebtemp..." + ex.getMessage(), ex);
            }
        }
		if( !ApplicationType.equals("pms") &&  (mobileType.equals("android") || mobileType.equals("ios"))  ){
                    objViewer.init(request);;
                    formsession.setM_objFormViewer(objViewer);
                    session.setAttribute("obj"+fid+"Viewer", objViewer);
                    if (wdmodel != null) {
                        dateFormat = wdmodel.getM_objGeneralData().getM_strDateFormat();
                    }
                    mobileMode=objViewer.getM_objFormDef().getM_strMobileMode();
                     String buttonId = IFormUtility.escapeHtml4(request.getParameter("buttonId"));
                    if(buttonId!=null && !buttonId.isEmpty()){
                        EButtonControl buttonControl = (EButtonControl)objViewer.getM_objFormDef().getFormField(buttonId);
                        ((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).setBtnRef(buttonControl);
                    }
                    url=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
                    if(calledForProcessReport!=null){
                        objViewer.getM_objFormDef().dumpHTMLforProcessReport(url,formsession,wdmodel,request.getParameter("pmwebtemp"),formName);
                    }
                    if (omnilocale != null) {
                            objViewer.getM_objFormDef().setObjLocale(omnilocale);
                        }
		}
        if(mobileType.equals("mobile")) {
            dateDbFormat=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat();
            boolean useWebClientDateFormat = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.USEWEBCLIENTDATEFORMAT) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.USEWEBCLIENTDATEFORMAT)));
            
            if(useWebClientDateFormat)
            dateDbFormat =  request.getParameter("DateFormat");
			dateSeparator = objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator();
            String ds="",df="";
            if(dateSeparator.equalsIgnoreCase("1"))
                ds = "/";
            else if(dateSeparator.equalsIgnoreCase("2"))
                ds = "-";
            else if(dateSeparator.equalsIgnoreCase("3"))
                ds = ".";
           
            if(dateDbFormat.equalsIgnoreCase("1"))
            {
                df = "dd"+ds+"MM"+ds+"yyyy";
            }
            if(dateDbFormat.equalsIgnoreCase("2"))
            {
                df = "MM"+ds+"dd"+ds+"yyyy";
            }
            if(dateDbFormat.equalsIgnoreCase("3"))
            {
                df = "yyyy"+ds+"MM"+ds+"dd";
            }
            if(dateDbFormat.equalsIgnoreCase("4"))
            {
                df = "dd"+ds+"MMM"+ds+"yyyy";
            }
            formsession.setM_strDateFormat(df);
        } 
            
    if( !ApplicationType.equals("pms") && mobileType.equals("mobile") ) {        
           
            CommonUtility.populateDataObjectInterfaces(formsession,objViewer.getM_objFormDef().getM_objMDMData().getSelectedTables());
            objViewer.retainMainTableData(objViewer.getM_objFormDef().getM_objMDMData().getSelectedTables());
            
            session.setAttribute("obj"+pageformUID+"Viewer", objViewer);
           
            boolean isMicroservice =(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.IS_MICROSERVICE_MODE) !=null) && "Y".equalsIgnoreCase(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.IS_MICROSERVICE_MODE));
            if( isNew != null ){
                if("Y".equalsIgnoreCase(isNew)){                   

                    if (isMicroservice) {
                        MicroServiceSupportCommonUtility.deleteExistingApplicationService(request, response);
                    } else {
                    AppTasks.deleteExistingApplication(request, response);
                } 
            } 
            } 
            if( filterValue != null ){
                session.removeAttribute("isLogin");               
            } 
            if (wdmodel != null) {
                dateFormat = wdmodel.getM_objGeneralData().getM_strDateFormat();
            }
            
            mobileMode=objViewer.getM_objFormDef().getM_strMobileMode();
             String buttonId = IFormUtility.escapeHtml4(request.getParameter("buttonId"));
            if(buttonId!=null && !buttonId.isEmpty()){
                EButtonControl buttonControl = (EButtonControl)objViewer.getM_objFormDef().getFormField(buttonId);
                ((ERootControl)objViewer.getM_objFormDef().getM_objRootControl()).setBtnRef(buttonControl);
            }
           
                url=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
                if(calledForProcessReport!=null){
                    pmwebtemp=IFormUtility.escapeHtml4(request.getParameter("pmwebtemp"));
                    pmwebtemp=IFormUtility.sanitizeForProcess(pmwebtemp,true);
                    objViewer.getM_objFormDef().dumpHTMLforProcessReport(url,formsession,wdmodel,pmwebtemp,formName);
                }
            
                
    }    
            
            
            String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
            formsession.setM_strWDSID(sid);
            String strKey = IFormUtility.getAesKey();
            String wd_sid = (String) IFormUtility.escapeHtml4(request.getParameter("WDESK_SID"));
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
            IFormReference objFormReference1;
            if(request.getParameter("QueryString")!=null && !"".equalsIgnoreCase(request.getParameter("QueryString")))
                objFormReference1 = new IFormAPIHandler(request,response,pageformUID);
			String locale = lbls.getString("Path").replace("/", "");
            String localeJS="";
            if(locale.equalsIgnoreCase("ar") || locale.equalsIgnoreCase("ar_sa"))
            localeJS="ar";
            if(locale.equalsIgnoreCase("de"))
            localeJS="de";
            if(locale.equalsIgnoreCase("es") || locale.equalsIgnoreCase("es_do"))
            localeJS="es";
            if(locale.equalsIgnoreCase("fr_fr"))
            localeJS="fr";
            if(locale.equalsIgnoreCase("nl"))
            localeJS="nl";
            if(locale.equalsIgnoreCase("pt"))
            localeJS="pt_pt";
        %>
        <% if( ApplicationType.equals("pms")||  mobileType.equals("android") || mobileType.equals("ios")  )  { %>
        <title><%= lbls.getString("PREVIEW")%></title>
        <%} else {%>
        <title><%= AppTasks.getValueFromINI("ApplicationName", request)%></title>
        <%}%>
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8,EmulateIE9,EmulateIE10,EmulateIE11" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap.css?rid=<%= randomId%>">
        <% if(lbls.getString("Path").equals("ar/")) { %>
        <link  rel="stylesheet" href="resources/bootstrap/css/bootstrap-rtl.min.css?rid=<%= randomId%>">
        <% } %>
        <link rel="stylesheet" href="resources/bootstrap/css/jquery-ui.css?rid=<%= randomId%>">        
        <link rel="stylesheet" href="resources/bootstrap/css/bootstrap-glyphicons.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap.bundle.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery-ui.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery-editable-select.js?rid=<%= randomId%>"></script>        
        <script type="text/javascript" src="resources/bootstrap/js/jquery.formError.js?rid=<%= randomId%>"></script>  
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/constants.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/moment.js?rid=<%= randomId%>"></script>      
        <script type="text/javascript" src="resources/bootstrap/js/purify.js?rid=<%= randomId%>"></script>      
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-datepicker.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap-multiselect.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/iformCustomMsg.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/commonmethods.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/net.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/timerpopup.js?rid=<%= randomId%>"></script>
        <%if(enableMobileViewForTiles){%>        
        <link rel="stylesheet" type="text/css" href="resources/slick/slick.css?rid=<%= randomId%>"/>
         <link rel="stylesheet" type="text/css" href="resources/slick/slick-theme.css?rid=<%= randomId%>"/>
         <script type="text/javascript" src="resources/slick/slick.min.js?rid=<%= randomId%>"></script> 
          <%}%>
        <script type="text/javascript" src="resources/scripts/iformview.js?rid=<%= randomId%>"></script>
        <script defer type="text/javascript" src="resources/scripts/iformclient.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/datevalidation.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/floating-labels.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/editable-select.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/ifomstyle.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-multiselect.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap-datepicker.min.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/navigation.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/<%= lbls.getString("Path")%>css/floating-labels.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/css/common.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/css/customcss.css?rid=<%= randomId%>">
       
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead.js?rid=<%= randomId%>"></script>
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
		 <% if(!lbls.getString("Path").equals("en_us/")) { %>
         <script type="text/javascript" src="resources/scripts/froala_editor/js/languages/<%= localeJS%>.js?rid=<%= randomId%>"></script>
        <% } %>
         <script type="text/javascript" src="resources/scripts/rte.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/aes.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/pbkdf2.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/AesUtil.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/base64.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/iformapi.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/iformmethods.js?rid=<%= randomId%>"></script>
         <link type="text/css" rel="stylesheet" href="resources/css/nav.css?rid=<%= randomId%>">
         <script type="text/javascript" src="resources/scripts/blowfish.js?rid=<%= randomId%>"></script>
         <script type="text/javascript" src="resources/scripts/webcam.min.js?rid=<%= randomId%>"></script>
         <link href="resources/css/merriweather.css?rid=<%= randomId%>" rel="stylesheet" type="text/css">
         <link href="resources/css/openSans.css?rid=<%= randomId%>" rel="stylesheet" type="text/css">
         <script type="text/javascript" src="resources/bootstrap/js/masonrybootstrap5.js?rid=<%= randomId%>"></script>

         <%--    PWA Changes--%>
         <%if(isPWA && !loginApplication){%>
         <%if(request.getParameter("QueryString")!=null && !"".equalsIgnoreCase(request.getParameter("QueryString"))){%>
         <link rel="manifest" id="dynaimcManifest"></link>
         <%} else{ %>
         <link rel="manifest" href="../../manifest.json" type="application/json"></link>
         <% } %>
         <meta name="apple-mobile-web-app-capable" content="yes"></meta>
         <meta name="apple-mobile-web-app-status-bar-style" content="default"></meta>
         <link rel="apple-touch-icon" sizes="180x180" href="../../pwalogo/LandMarkMobileApp-apple-touch-icon.png"></link>
         <%}%>
         <script>
            <% if(isSetWindowOpenerNull) { %>
                window.opener = null;
            <% }%>
			var randomId = "<%= randomId %>";
            var validateSetValue = "<%= validateSetValue %>";
			var contextPath = "<%= request.getContextPath() %>";
            var enableMobileViewForTiles = <%=enableMobileViewForTiles%>;
            var enableMasonary=<%=isMasonaryEnabled%>;
            var domainURL="<%=domainURL%>";
            var pid = "<%=StringEscapeUtils.escapeHtml4(pid)%>";
            var wid = "<%=wid%>";
            var tid = "<%=tid%>";
            var dateFormat = "<%=dateFormat%>";
            var processName = "<%=processName%>";
            var processDefId = "<%=processDefId%>";
            var activityName = "<%=activityName%>";
            var extendSession="<%=extendSession%>";
            var authToken="<%=authToken%>";
            var isTokenizedAuth="<%=isTokenizedAuth%>";
            var fid = "";   
            <%if( (!ApplicationType.equals("pms") && mobileType.equals("mobile")) || (!ApplicationType.equals("pms") && (mobileType.equals("android") || mobileType.equals("ios")) && ("CustomTemplateTaskForm".equals(pageformUID) || "DataTemplateTaskForm".equals(pageformUID)) ) ) {%> 
                fid = "<%=StringEscapeUtils.escapeHtml4(pageformUID)%>";//"TemplateTaskForm".equals(pageformUID) || 
            <%} else {%>
                fid = "<%=StringEscapeUtils.escapeHtml4(fid)%>";
            <%}%>
            var isReadOnlyForm = <%=isReadOnlyForm%>;
            var processInstanceId="<%=StringEscapeUtils.escapeHtml4(processInstanceId)%>";
            var cabinetName="<%=cabinetName%>";
            var userName = "<%=userName%>";
            var fSessionId = "<%=StringEscapeUtils.escapeHtml4(fSessionId)%>";
            var queueName = "<%=queueName%>";
			
            var activityID = "<%=activityID%>";
            var userIndex = "<%=userIndex%>";
            var mobileMode = "<%=mobileMode%>";
            var isDatePicker = "<%=isDatePicker%>";
            var isOverlayOpen = "<%=isOverlayOpen%>";
            var CleanMapOnCloseModal = "<%=CleanMapOnCloseModal%>";
            var disableFieldFontColor = "<%=disableFieldFontColor%>";        
            var subTaskId = "<%=subTaskId%>";
            var taskName = "<%=taskName%>";
            var registeredMode= "<%=registeredMode%>";
	        var isReverseButtonOrder = "<%=isReverseButtonOrder%>";
            var applicationName="<%=applicationName%>";
            var SessionExpireWarnTime ="<%=SessionExpireWarnTime%>";
            var SessionWarnExtendTime = "<%=SessionWarnExtendTime%>";
            var alwaysCreate="<%=alwaysCreateNew%>";
            var DeleteOldApplicationData="<%=DeleteOldApplicationData%>";
            var alwaysOpenOldTransaction="<%=alwaysOpenOldTransaction%>";
            var globalDateFormat="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat()%>";
            var globalDateSeparator="<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator()%>";
            var formName = "<%=objViewer.getM_objFormDef().getM_strFormAlias()%>";
            var formMode="W";//Bug 82321
            var iformLocale="<%=lbls.getString("Path")%>";
            var isEditableComboOnLoad = "<%=isEditableComboOnLoad%>";
            var isGridBatchingEnabled = "<%=isGridBatchingEnabled%>";
            var autoIncrementLabelDisplay = "<%=autoIncrementLabelDisplay%>";
            var listViewCharacterLimit = "<%=listViewCharacterLimit%>";
            var applicationName="<%=applicationName%>";
            var multipleRowDuplicate = "<%=multipleRowDuplicate%>";
            var isServerValidation = "<%=isServerValidation%>";
			var isSkipResponseData = "<%=isSkipResponseData%>";
            var isShowGridComboLabel = false;
            var isCheckboxValueChange="<%=isCheckboxValueChange%>";
            var isPreview="<%=request.getSession().getAttribute("IsPreview")%>";
            var queryString="<%=request.getParameter("QueryString")%>";
            var adminLogin='<%=adminLogin%>';
            <% if( mobileType.equals("mobile") ) { %>
              isShowGridComboLabel = "<%=isShowGridComboLabel%>";
            <% } %>  
            <%if( !ApplicationType.equals("pms") && mobileType.equals("mobile") ) {%> 
                var assignedTo = "<%=assignedTo%>";
                var priorityLevel = "<%=priorityLevel%>";
                var lockedByName = "<%=lockedByName%>";
                var processedBy = "<%=processedBy%>";
                var introductionDateTime = "<%=introductionDateTime%>";
                var queueId = "<%=queueId%>";
                var lockStatus = "<%=lockStatus%>";
                var userPersonalName = "<%=userPersonalName%>";
                var userFamilyName = "<%=userFamilyName%>";
            <%}%> 
            <%
                if(request.getHeader("User-Agent")!=null){
                    if(request.getHeader("User-Agent").toLowerCase().contains("ipod")  || request.getHeader("User-Agent").toLowerCase().contains("iphone") || request.getHeader("User-Agent").toLowerCase().contains("ipad")){                                 
            %>     var iosDtype= true;
            <%
                    }
               }
            %>
            
           <%if( ApplicationType.equals("pms") ) {%> 
               
            var folderId="<%=folderId%>";
            var webdateFormat = "<%=dateFormat%>";
            var processDefId="<%=processDefId%>";
            var isProcessSpecific="Y";
            
            <%}%> 
            var filterValue = "<%=filterValue%>";
            
            window.onresize = function (e) {
                var scrollerWidthofBrowser = getBrowserScrollSize().width;
                if(document.getElementById("headerDiv"))
                    document.getElementById("headerDiv").style.width=($(window).width() - scrollerWidthofBrowser )+"px";
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
                    document.getElementById("affix_padding").style.paddingTop = "";
                    document.getElementById("headerDiv").style.position='';
                    document.getElementById("headerDiv").style.top='';
//                    document.getElementById("headerDiv").classList.remove("affix");
                   document.getElementById("headerDiv").style.width=($(window).width() - scrollerWidthofBrowser )+"px";
                    }
                }
                sectionAsFooter(footerFrameName);
                makeStickyTabs();
                if(enableMasonary){
                    window.setTimeout( layoutMasonry , 1000 );
                }
            }
        </script>  

        <style>
           
           .datepicker .datepicker-days {
                display: block;               
            }
            
            .affix {
              top: 0;
              width: 100%;
              <%if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bHideHeader()){%>
              padding-right: 17px;
              <%}%> 
            }
            .affix + .affix_padding {
                <%if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bHideHeader()){%>
                    
                <%}
                else if(StringUtils.isEmpty(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strLogoPath())){
                     if(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bShowHeader()){
                %>
                  padding-top:<%=(Integer.parseInt(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strLogoHeight()))+52%>px;
                  <%}
                 else{%>
                  padding-top:<%=(Integer.parseInt(objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strLogoHeight()))+25%>px;
                  <%}}
                    else{%>
                  padding-top:50px;
                  <%}%>
              }
            .affix-top {
              /*width: 100%;*/
            }

            .affix-bottom {
                /*top: 0;*/
              /*width: 100%;*/
              /*position: absolute;*/
            }
             <%objViewer.getM_objFormDef().setDeviceType(request.getHeader("User-Agent"));%>		
        </style>
        
		<style>
                   
			html{
				height: 100%;
				overflow: auto;
				-webkit-overflow-scrolling: touch;
			}
			body{
				height: 100%;     
				/*overflow: auto;*/
				-webkit-overflow-scrolling: auto;
                                -ms-overflow-style: scrollbar;
			}
                       .squaredTwo input[type=checkbox]:checked + div{
                           background-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                         }
                         .squaredTwo input[disabled=disabled][type=checkbox] + div{
                           background-color:#ccc !important;
                           border-color:#ccc !important;
                         }
                       .squaredTwo input[disabled=disabled][type=checkbox]:checked + div{
                           background-color:#ccc !important;
                           border-color:#ccc !important;
                         } 
                       .input-group input[controltype=date][disabled=disabled] + label span{
                             color:#ccc !important;
                         } 
                         .input-group input[controltype=date][disabled] + label span{
                             color:#ccc !important;
                         }
                       .radioTwo input[type=radio]:checked + div{
                           background-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .squaredOne label:after,.squaredOne div:after{
                           border-color:#<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       .radioOne label:after,.radioOne div:after {
                             background-color: #<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
                       }
                       squaredOne input[type=checkbox]:checked + div,.radioOne input[type=radio]:checked + div,.squaredOne input[type=checkbox]:checked + label,.radioOne input[type=radio]:checked + label{
                           border: 2px solid #<%=objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().getM_strThemeColor()%> !important;
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
                        
                        .dropdown-toggle::after{
                            content: initial;
                        }
                        
                        .disabledBGColor{
                            background-color: #e4e4e4 !important;
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
                            opacity : 0.8 ;
                        }
                        .disabledTableBGColor{
                            background-color: #e4e4e438 !important;
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
                            opacity : 0.8 ;
                        }
                        .disabledTableFont{
                            <%if(disableFieldFontColor != null && (!"".equals(disableFieldFontColor))){%>
                                color: #<%=disableFieldFontColor%> !important;
                            <%}
                            else{%>
                                color: #2f4f4f !important;
                            <%}%>
							opacity : 0.8 ;
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
                        <%}%>
                        .fr-top{
                            border-top:0 !important;
                        }
                        <%
                          if(request.getHeader("User-Agent")!=null){
                              String deviceType=request.getHeader("User-Agent").toLowerCase();
                              if(deviceType.contains("ipod")  || deviceType.contains("iphone") || deviceType.contains("ipad")){                                 
                        %>
                            .modal-backdrop {
                                 z-index: -1;
                            }
                        <%
                           }
                          }
                        %>
                        .carousel
                        {
                            position: absolute;
                            top:0;
                            left:0;
                            width:100%;
                            height:100%;                           
                        } 

                        .carousel-inner{
                            z-index:-99;
                        }
                        .carousel .active.left {
                             z-index:2;
                         }
                         .carousel .active.right {
                            z-index:2;
                         }
                         .bootbox .btn:hover{
                             color:#<%= objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objButtonFormStyle().getM_strFontColor()%>;
                         }

        </style>
    </head>
    <body onload="doInit('form');" onunload="closeSubForm()" onkeydown="bodykeyDown(event);stopFormRefreshing(event);" onkeypress="stopFormRefreshing(event);" onbeforeunload="closeSubForm()" style="overflow:auto;overscroll-behavior:contain;" class="iBodyStyle">
         <div id="TimerDiv" class="iframeShadow" style="z-index: 50001; display: none; position: absolute;">
             <table cellpadding="0" cellspacing="0" width="100%">
                 <thead><th></th></thead>
                <tbody>
                    <tr>
                        <td style="width: 100%;">
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <thead><th></th></thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="bluepanelcontent containerShadow" style="width: 382px;height: 158px;">
                                                <div class="containerHeaderRadius themeBackGroundStyle sectionStyle" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <thead><th></th></thead>
                                                        <tbody>
                                                            <tr>
                                                                <td style="width:100%;vertical-align: top;">
                                                                    <table id="bpanel:bp:bluepanel" border="0" cellpadding="0" cellspacing="0" style="padding: 0px; margin: 0px;" width="100%">
                                                                        <thead><th></th></thead>
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="lImgColumn">
                                                                                    <div class="lBlueBg"></div></td>
                                                                                <td class="headerColumn"><label style="white-space: nowrap;">
                                                                                        Session Expiry Alert</label></td>
                                                                                <td class="menuButtonColumn"></td>
                                                                                <td class="rImgColumn">
                                                                                    <div class="rBlueBg"></div></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>

                                                </div>
                                                <table border="0" cellpadding="0" cellspacing="2" width="100%">
                                                    <thead><th></th></thead>
                                                    <tbody>
                                                        <tr>
                                                            <td><span style="visibility: hidden;">.</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table class="informationmsgdiv" border="0" cellpadding="0" cellspacing="2">
                                                                    <thead><th></th></thead>
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <table id="bpanel:bp:timerinfodiv" border="0" cellpadding="0" cellspacing="2">
                                                                                    <thead><th></th></thead>
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td><span class="glyphicon glyphicon-info-sign"></span></td>
                                                                                            <td><span class="informatinostyleblue">You will be logged out in</span></td>
                                                                                            <td><span style="visibility: hidden;">.</span></td>
                                                                                            <td>
                                                                                                <span id="crminutes" class="informatinostyleblue"></span></td>
                                                                                            <td><span class="informatinostyleblue">:</span></td>
                                                                                            <td>
                                                                                                <span id="crseconds" class="informatinostyleblue"></span></td>
                                                                                            <td><span style="visibility: hidden;">.</span></td>
                                                                                            <td><span class="informatinostyleblue">(mm:ss)</span></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <table id="bpanel:bp:expiryinfodiv" border="0" cellpadding="0" cellspacing="2" style="display: none;">
                                                                                    <thead><th></th></thead>
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td><span class="glyphicon glyphicon-info-sign"></span></td>
                                                                                            <td><span class="informatinostyleblue">Session Expired</span></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span style="visibility: hidden;">.</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellpadding="0" cellspacing="2" width="100%">
                                                                    <thead><th></th></thead>
                                                                    <tbody>
                                                                        <tr>
                                                                            <td style="width:100%;text-align: center;">                                        
                                                                                <a href="#" class="control-label labelStyle" onclick="extendWebSession();return false;" style="margin-bottom:0px;cursor:pointer;text-decoration: underline !important;color:#0000ff !important;">Click Here to stay logged in</a></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                            </div></td>
                                    </tr>
                                </tbody>
                                </table>                          
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="fade" class="black_overlay"></div>		
        <script>
            CreateIndicator("application");
            document.getElementById("fade").style.display="block";
        </script>
        <input type="hidden" id="sid" name="sid" value= "<%=sid%>" >
        <input type="hidden" id="rid_Action" name="rid_Action" value= "<%=rid_Action%>" >
	<input type="hidden" id="wd_sid" name="wd_sid" value= "<%=wd_sid%>" >
        <input type="hidden" id="rid_ActionAPI" name="rid_ActionAPI" value= "<%=rid_ActionAPI%>" >
        <input type="hidden" id="rid_IfHandler" name="rid_IfHandler" value= "<%=rid_IfHandler%>" >
        <input type="hidden" id="rid_listviewmodal" name="rid_listviewmodal" value= "<%=rid_listviewmodal%>" >
        <input type="hidden" id="rid_advancelistviewmodal" name="rid_advancelistviewmodal" value= "<%=rid_advancelistviewmodal%>" >
        <input type="hidden" id="rid_picklistview" name="rid_picklistview" value= "<%=rid_picklistview%>" >
        <input type="hidden" id="rid_texteditor" name="rid_texteditor" value= "<%=rid_texteditor%>" >
        <input type="hidden" id="rid_webservice" name="rid_webservice" value= "<%=rid_webservice%>" >
	<input type="hidden" id="rid_appTask" name="rid_appTask" value= "<%=rid_appTask%>" >
        <input type="hidden" id="mainStepNo" name="mainStepNo" value= "<%=formsession.getMainMenuData()%>" >
        <input type="hidden" id="substepNo" name="substepNo" value= "<%=formsession.getSubMenuData()%>" >
        <input type="hidden" id="pk" name="pk" value= "<%=strKey%>" >
        <%=  objViewer.getM_objFormDef().getRenderCarouselBlock(request,formsession, wdmodel)%>
        <div id="oforms_iform" style="min-height:100%;height:auto;margin:auto;margin-top:0px;overflow-y: auto;overflow-x: hidden;" class="iFormStyle">
        <%if(!objViewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objFormStyle().isM_bHideHeader()){%>
        <div style="width: 100%;text-align:center" class="affix_padding"></div>
        <%}%>
        <%if(objViewer!=null){%>
        <% 
        if(objViewer.getM_objFormDef().isChangeList()){
             objViewer.getM_objFormDef().setListChanged(false);
        }
        List<Menu> menuList = new ArrayList(); 
        try{
            if(objViewer.getM_objFormDef().isChangeList() && objViewer.getM_objFormDef()!=null){
                menuList = objViewer.getM_objFormDef().getObjChangeList();
            }
            else if(objViewer.getM_objFormDef().getM_objNav() != null){
                menuList = objViewer.getM_objFormDef().getM_objNav().getObjMenuList();
            }
        } catch(Exception | Error ex){
            NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp menuList..." + ex.getMessage(), ex);
        }
       if( !ApplicationType.equals("pms") || (!ApplicationType.equals("pms") && (mobileType.equals("android") || mobileType.equals("ios"))) )  {   
            WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
            if (wisessionbean == null) {
                wisessionbean = new WDWorkitems();
                session.setAttribute("wDWorkitems", wisessionbean);
            }
            
            
                if ( "Link".equals(callFrom) || "NewUser".equals(callFrom) || ( formsession.getM_strSessionId()!=null && !"".equals(formsession.getM_strSessionId()) ) ||  ( formsession.getM_strExistingFid() != null && !"".equals(formsession.getM_strExistingFid()) && objViewer.getM_objFormDef().isM_bNavigationAdded() )) {
                    if(session.getAttribute("isLogin") == null || ( formsession.getM_strExistingFid() != null && !"".equals(formsession.getM_strExistingFid()) )) {
                        if(formsession.getM_strApplicationName()!=null && !formsession.getM_strApplicationName().equals(""))    
                              session.setAttribute("isLogin", "false");
                        
                            IFormFragInfo fragmentObj=null;
                            if( objViewer.getM_objFormDef().getM_objNav() != null ){
                                if(!menuList.isEmpty()){
                                    Menu obj_menu=menuList.get(0);
                                    formsession.setM_strStage("0");
                                    formsession.setM_strSubStage("0");
                                    if(!formsession.getMainMenuData().isEmpty()){
                                        int mainstep=Integer.parseInt(formsession.getMainMenuData());
                                        formsession.setM_strStage(formsession.getMainMenuData());
                                        obj_menu=menuList.get(mainstep);
                                    } else if (objViewer.getM_objFormDef().isChangeList()){
                                        obj_menu = menuList.get(objViewer.getM_objFormDef().getCurrentStep());
                                    }
                                    if(obj_menu.getM_objSubMenuList().isEmpty())    
                                        fragmentObj = obj_menu.getObjFragment();
                                    else
                                    {
                                        if(!obj_menu.getM_objSubMenuList().isEmpty()){
                                            if(!formsession.getSubMenuData().isEmpty() && !"0".equalsIgnoreCase(formsession.getSubMenuData())){
                                                int stepnumber = Integer.parseInt(formsession.getSubMenuData());
                                                formsession.setM_strSubStage(formsession.getSubMenuData());
                                                fragmentObj = obj_menu.getM_objSubMenuList().get(stepnumber).getObjFragment();
                                            } else if(objViewer.getM_objFormDef().isChangeList() && objViewer.getM_objFormDef().getCurrentSubStep()!= -1){
                                                fragmentObj = obj_menu.getM_objSubMenuList().get(objViewer.getM_objFormDef().getCurrentSubStep()).getObjFragment();
                                            } else {
                                                fragmentObj = obj_menu.getM_objSubMenuList().get(0).getObjFragment();
                                            }
                                        }   
                                    }
                                    formsession.setM_strProcessDefId(processDefId);
                                    if( fragmentObj != null ){
                                        try{
                                            boolean isPreview = "Y".equals(request.getSession().getAttribute("IsPreview"));
                                            if( isPreview ){
                                                 IFormUtility.populateFragmentBuffer(request,objViewer.getM_objFormDef(),fragmentObj , formsession);
                                            }
                                            else
                                                CommonUtility.populateFormDefForFragment(request,objViewer.getM_objFormDef(), fragmentObj,formsession);
                                            if(!"N".equalsIgnoreCase(DeleteOldApplicationData))
                                                AppTasks.checkApplicationAlreadyFilled(request, response,false);
                                            CommonUtility.populateModelForFragment(request, objViewer.getM_objFormDef(), fragmentObj,formsession);
                                            if(!"N".equalsIgnoreCase(CreateTransactionOnLoad) && ("NewUser".equals(callFrom)&& !"Y".equalsIgnoreCase(formsession.getApplicationRecordCreated()) || "Link".equals(callFrom)) && ("Y".equals(formsession.getIsFirstTime()))){
                                               AppTasks.createNewRecord(request, response);
                                               formsession.setIsFirstTime("N");
                                            }
                                            
                                        }
                                        catch(Exception | Error ex){
                                             NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp fragmentObj..." + ex.getMessage(), ex);
                                        }
                                    }    else
                                        CommonUtility.populateModelForFragment(request, objViewer.getM_objFormDef(), null,formsession);
                                
                                }
                            }  else
                                CommonUtility.populateModelForFragment(request, objViewer.getM_objFormDef(), null,formsession);
                        
                        }
                        wdmodel=IFormUtility.getWDModel(request);
                        
                                designMenu = IFormUtility.createMenuHtml(objViewer.getM_objFormDef());
                            
                        }
            } else if(ApplicationType.equals("pms")) {
				IFormFragInfo fragmentObj = null;
                if (objViewer.getM_objFormDef().getM_objNav() != null) {
                    if (!menuList.isEmpty()) {
                        Menu obj_menu = menuList.get(0);
                        if (obj_menu.getM_objSubMenuList().isEmpty()) {
                            fragmentObj = obj_menu.getObjFragment();
                        } else if (!obj_menu.getM_objSubMenuList().isEmpty()) {
                            fragmentObj = obj_menu.getM_objSubMenuList().get(0).getObjFragment();
                        }
                        formsession.setM_strStage("0");
                        formsession.setM_strSubStage("0");
                        if (fragmentObj != null) {
                            try {
                                IFormUtility.populateFragmentBuffer(request, objViewer.getM_objFormDef(), fragmentObj, formsession);
                                CommonUtility.populateModelForFragment(request, objViewer.getM_objFormDef(), fragmentObj,formsession);
                                designMenu = IFormUtility.createMenuHtml(objViewer.getM_objFormDef());
                            } catch(Exception | Error ex) {
                                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp designMenu..." + ex.getMessage(), ex);
                            }
                        }
                    }
                }
			}
            String getRenderBlockValue = "";
            try{
                String pagefid=fid;
                if(!ApplicationType.equals("pms") && mobileType.equals("mobile"))
                    pagefid=pageformUID;
                IFormReference objFormReference = new IFormAPIHandler(request,response,pagefid);
                IFormContext iFormContextObj = new IFormContext();
                IFormServerEventHandler objCustomCodeInstance = iFormContextObj.getInstance(objFormReference);
                if( objCustomCodeInstance != null )        
                {  
                    allowEnableOnReadOnly = objCustomCodeInstance.allowEnableOnReadOnly();// Bug:133243
                    formsession.setObjServerEventHandler(objCustomCodeInstance);
                    formsession.setObjFormReference(objFormReference);
                    objViewer.getM_objFormDef().setListChanged(true); //To change only list
                    objCustomCodeInstance.beforeFormLoad(objViewer.getM_objFormDef(), objFormReference);
                    try{
                        IFormCustomHooks objCustomHook = (IFormCustomHooks)objCustomCodeInstance;
                        extraParams = objCustomHook.decryptCustomData(extraParams);
                    } catch(Exception | Error ex){
			NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp decryptCustomData..." + ex.getMessage(), ex);
                    }                  
                }
                
            }catch(Exception | Error ex){
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp beforeFormLoad / getRenderBlockValue..." + ex.getMessage(), ex);
            }
            catch(Throwable ex){
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp..." + ex.getMessage(), ex);
            }       
            try{
                getRenderBlockValue = objViewer.getM_objFormDef().getRenderBlock(formsession, wdmodel);
            }catch(Exception | Error ex){
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp beforeFormLoad / getRenderBlockValue..." + ex.getMessage(), ex);
            }
            catch(Throwable ex){
                NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in viewform.jsp..." + ex.getMessage(), ex);
            } 
        %>
        <%=  getRenderBlockValue %>
        <%}%>
        <%       
                if(objViewer.getM_objFormDef().isChangeList()){
                    objViewer.getM_objFormDef().setListChanged(true);
                } 
        %>
        <% 
            String paddingLvw = "padding:70px;";
            String paddingAlvw = "padding:60px;";
            if( mobileMode.equals("mobile") || mobileMode.equals("android") || mobileMode.equals("ios") )
            {
                paddingLvw = "padding:5px;";
                paddingAlvw = "padding:10px;";
            }
            
                String isShowHideBtn = "none";
                boolean MoveToTopButton=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MOVE_TO_TOP_BUTTON) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.MOVE_TO_TOP_BUTTON)));
                if (MoveToTopButton) {
                    if (!objViewer.getM_objFormDef().getDeviceType() || applicationName.equals("") || !objViewer.getM_objFormDef().isM_bNavigationAdded()) {
                        isShowHideBtn = "block";
                    }
                } else {
                    isShowHideBtn = "none";
                }
       %>
        <button id="moveToTopMainForm" style="z-index: 3001; position: fixed;width: 55px;height: 45px;bottom: 10px;right: 20px;border: none;background-color: transparent;display: <%=isShowHideBtn%>;float: right;"><svg width="34px" height="34px" viewBox="0 0 34 34" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <title><%= lbls.getString("BACK_TO_TOP")%></title>
            <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                <g id="1.0---Client-&amp;-Deal-Details" transform="translate(-1309.000000, -1667.000000)">
                    <g id="Group" transform="translate(1309.000000, 1667.000000)">
                        <circle id="Oval-3" fill="#344456" cx="17" cy="17" r="17"></circle>
                        <path d="M17.1479396,20.8533252 C17.3423382,21.0488734 17.6575841,21.0489098 17.852019,20.8533252 L22.7760684,15.9004463 C23.1652108,15.5090034 23.0342067,15.1919648 22.4837892,15.1919648 L19.4934233,15.1919648 L19.4934233,10.0006276 C19.4934233,9.44790259 19.0473186,9 18.4970284,9 L16.5029121,9 C15.9526945,9 15.5064808,9.44797554 15.5064808,10.0005912 L15.5064808,15.1919648 L12.5161876,15.1919648 C11.9656975,15.1919648 11.834875,15.5091858 12.2238902,15.9004463 L17.1479578,20.8533434 L17.1479396,20.8533252 Z M23.0001849,23 L10.9998151,23 C10.4479635,23 10,23.4477267 10,24 C10,24.5524009 10.4476172,25 10.9998151,25 L23.0001849,25 C23.552,25 24,24.5522733 24,24 C24,23.4475991 23.5523828,23 23.0001849,23 Z" id="Shape" fill="#FFFFFF" transform="translate(17.000000, 17.000000) scale(1, -1) translate(-17.000000, -17.000000) "></path>
                    </g>
                </g>
            </g>
        </svg></button>
        </div>
        <div class="modal"  id="menuModal" role="dialog" data-backdrop="static" style="z-index:2004;">
            <div class="modal-dialog" style="width:90%;margin:0px;top:50%;left:50%;transform:translate(-50%,-50%);">
                <div class="modal-content" style="height:400px;">
                    <div class="modal-header" style="padding: 5px 15px;"><%= lbls.getString("SELECT_STEPS")%></div>
                    <div  class="modal-body appendmenumodal" style="height:324px;overflow: auto;">
                        <%=designMenu%>

                    </div>                        
                    <div class="modal-footer table-responsive container-fluid" style="padding: 0px 12px 12px 0px; border: none;">
                        <button class="menuButton"><span class="menuButtonSpan" onclick="closeMenuModal();">Cancel</span></button>
                       </div>
                </div>
            </div>
        </div>
        <div class="modal"  id="searchModal" role="dialog" data-bs-backdrop="static" style="z-index:3004;">
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
                        <button type="button" onclick="showNextPreviousResult('previous')" id="picklistPrevious" class=" btn btn-primary btn-sm pull-<%=lbls.getString("LEFT")%>" disabled="true"><%=lbls.getString("PREVIOUS")%></button>
                        <button style="width:50px;" type="button" onclick="showNextPreviousResult('next');" id="picklistNext" class="btn btn-primary pull-<%=lbls.getString("LEFT")%> btn-sm  "><%=lbls.getString("NEXT")%></button>
                        <button style="width:50px;background-color:#285D28; " type="button" onclick="setSelectedRow();" data-bs-dismiss="modal" id="picklistOk" class=" btn btn-primary btn-sm "><%=lbls.getString("LABEL_OK")%></button> 
                        <button style="width:60px; padding-left:2px; padding-right:2px;background-color:#A32824;" type="button" id="picklistCancel" class=" btn btn-primary btn-default btn-sm" onclick="disablePrevious()" data-bs-dismiss="modal"><span class="glyphicon "></span><%=lbls.getString("CANCEL")%></button>
                    </div>
                </div>
            </div>
        </div>      
                    
                    <div class="modal"  id="listViewModal" role="dialog" style="z-index:3003" data-bs-backdrop="static" data-bs-keyboard="false">
            <div id="iFrameListViewModal"  style="<%= paddingLvw %>height:auto;" class="modal-dialog modal-xl modal-lg modal-sm">
            </div>
            <input id="table_id" style="display: none" aria-labelledby="table_id">
            <input id="rowCount" style="display: none" aria-labelledby="rowCount">
        </div>
                    <div class="modal"  id="subFormModal" role="dialog" data-bs-backdrop="static" style="z-index:3000">
                        <div id="iFrameSubFormModal" style="padding:60px" class="modal-dialog modal-xl modal-lg modal-sm">
                        </div>
                    </div>
                     <div  id="LinkModal" style="display:none;">
                         <iframe id="iFrameLinkModal" style="width:100%;height:100%"></iframe>
                    </div>
                    <div class="modal" id="advancedListViewModal" role="dialog" data-bs-backdrop="static" data-bs-keyboard="false" style="z-index:3002" >
                        <div id="iFrameAdvancedListViewModal" style="<%= paddingAlvw %>" class="modal-dialog modal-xl modal-lg modal-sm">
                            
                        </div>
                        <input id="advancedListview_id" style="display: none" aria-labelledby="advancedListview_id">
                        <input id="advancedListviewRowCount" style="display: none" aria-labelledby="advancedListviewRowCount">
                    </div>
                    <div id="cameraViewer" style="position: absolute;z-index: 199;background-color: #ffffff;border: 1px solid #d7d7d7;display: none">
                        <div id="cameraCloser" style="position: absolute;width: 20px;height: 20px;top: 5px;z-index: 200" title="Close" class="closeCamera" onclick="closeCameraViewer()"></div>
                        <div id="videoShower" style="position: absolute;padding-top: 25px;">
                            <video id="videoPlayer" autoplay=""></video>
                        </div>
                        <div id="imageClicker" style="position: absolute;width: 36px;height: 36px;bottom: 10px;" class="recapture" title="Capture Image" onclick="onTakePhotoButtonClick()"></div>
                        <div id="uploadImageCamera" style="position: absolute;width: 36px;height: 36px;bottom: 10px;" class="importImage" title="Upload Image" onclick="uploadImageFromCamera(event)"></div>
                        <div id="canvasShower" style="display: none;position: absolute;z-index: 199;">

                        </div>
                        <div id="autoRotateOption" style="position: absolute;width: 36px;height: 36px;bottom: 10px;" class="switchcamera" title="Rotate Camera View" onclick="autoRotateCamera()"></div>
                        <div id="retakeOption" style="position: absolute;width: 36px;height: 36px;bottom: 10px;display:none" class="recapture" title="Capture Image" onclick="retakeImage()"></div>
                    </div>
                    <iframe id="iFrameDownloadPDF" src="" style="display: none;"></iframe>
                    <button type="button" style="display:none" onclick="saveForm(1)"/>

            <style>
                /*fthfoot{
                    display:initial ! important;
                }*/
                .table > :not(caption) > * > * {
                    padding:0px;
                }
                select {
                    /* for Firefox */
                    -moz-appearance:inherit !important;
                    appearance:inherit !important;
                    /* for Chrome */
                    -webkit-appearance: auto !important;
                }
                .input-group{
                 flex-wrap: inherit;
                }
                <%= objViewer.getM_objFormDef().getRenderCSS()%>
            </style>
            <script>
                var additionalParams="<%=extraParams.replaceAll("[\\n\\r]", "")%>";
                $("#advancedListViewModal").on("hidden.bs.modal", function () {
                   <% if(mobileType.equals("mobile")) { %> 
                   var action=document.getElementById("advancedListViewModal").getAttribute("action");
                   var crossState=$("#advLVcloseButton").attr("state");                                                                                             
                   clearAdvancedListviewMap(action,crossState);
                   removeAdvancedListviewrowToModify();
                   <% } else { %>
                   var action=document.getElementById("advancedListViewModal").getAttribute("action");
                   var crossState=$("#advLVcloseButton").attr("state");                                                                                              
                   clearAdvancedListviewMap(action,crossState);
                   <% } %>    
                });
                $("#listViewModal").on("hidden.bs.modal", function () {                    
                    removerowToModify();
                });
                var transactionId = "<%=formsession.getM_strApplicationNo()%>";
                var allowEnableOnReadOnly="<%=allowEnableOnReadOnly%>";// Bug:133243
            </script>   
            <script type="text/javascript" src="resources/scripts/DocumentWidget.js?rid=<%= randomId%>"></script>
            <script type="text/javascript" src="resources/scripts/CameraUpload.js?rid=<%= randomId%>"></script>
            <%if(isPWA && !loginApplication){%>

                    <%--    PWA Changes--%>
            <script type="text/javascript" src="../../pwa/firebase-messaging.js?rid=<%= randomId%>"></script>          
            <script type="text/javascript" src="../../pwa/firebase-app.js?rid=<%= randomId%>"></script>       
            <script type="text/javascript" src="../../pwa/configuration.js?rid=<%= randomId%>"></script>
            <script type="text/javascript" src="../../pwa/firebase-sw-init.js?rid=<%= randomId%>"></script>
            <%}%>
    </body>
   
</html>
