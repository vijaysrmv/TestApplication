<%-- 
    Document   : webservice
    Created on : Jan 18, 2016, 4:17:00 PM
    Author     : shaveta.rani
    02/03/2016           Shaveta Rani        Bugzilla ? Bug 59366 Need Webservice support in Iform
    15/03/2016           Mohit Sharma        Bug 59517 - RHEL-7 + Weblogic 12.1.2C + Oracle 11g: webservice functionality not working
    11/03/2018           Gaurav Sharma       Bug 75529 - Some commands/events for e.g: WFSave, WFClear etc. are not present in iForm
    13/05/2018           Gaurav Sharma       Bug 77691 - Event and webservice not working in Task.
    25/03/2019           Guarav              Bug 83729 - CustomService input is not correct when listview modal is opened
    04/07/2019           Gaurav              Bug 85519 - custom service not working on subform
    30/08/2019           Aman Khan           Bug 86252 - Need to execute setstyle in execute custom service
    28/01/2020           Rohit Kumar         Bug 90342 - getting unnecessary alert /n/n/n/ on calling customservice
    22/04/2020           Aman Khan           Bug 91950 - Rest webservice is not working
	22/06/2020           Deepak Singh Rawat  Bug 92920 - iBPS 4.0SP1 Complex array support in case of SOAP webservices
    23/08/2021           Sri Prakash     Replicated Bug 100437 - pre hook and post hook support on Iform web Service
    01/07/2022          Maaz Ali            Changes for Portal integration with microservices.
--%>
<%@page import="java.util.HashMap"%>
<%@page import="java.lang.String"%>
<%@page import="java.util.Map"%>
<%@page import="com.newgen.iforms.xmlapi.IFormRestCallBroker"%>
<%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
<%@page import="com.newgen.iforms.custom.IFormAPIHandler"%>
<%@page import="com.newgen.iforms.custom.IFormCustomHooks"%>
<%@page import="com.newgen.iforms.util.CommonUtility"%>
<%@page import="com.newgen.iforms.api.IFormAPI"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="com.newgen.iforms.webservice.CustomWebServiceMapping"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.newgen.iforms.xmlapi.IFormCallBroker"%>
<%@page import="com.newgen.iforms.webservice.WebServiceMapping"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.newgen.iforms.EControl"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%    
    String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));    
    String rid_webservice = IFormUtility.generateTokens(request,request.getRequestURI());
    response.setHeader("WD_RID", rid_webservice);
    WorkdeskModel wdmodel = null;
    try
    {
        IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));                        
        IFormSession formsession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));                
        String pid = (String) IFormUtility.escapeHtml4(request.getParameter("pid"));
        String wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
        String tid = IFormUtility.getIFormTaskId(request);
        boolean isTaskForm="TaskForm".equalsIgnoreCase(formsession.getFid())?true:false;
        LinkedHashMap workitemMap=null;
        WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
        if (wisessionbean != null)
        {
                workitemMap = wisessionbean.getWorkItems();
                if(tid == null || tid.isEmpty()){
                wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                } else {
                wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                }
        }


        String controlId = IFormUtility.escapeHtml4(request.getParameter("controlId"));
        String eventType=IFormUtility.escapeHtml4(request.getParameter("eventType"));
        String webServiceType= IFormUtility.escapeHtml4(request.getParameter("webServiceType"));
        if(IFormUtility.escapeHtml4(request.getParameter("listviewOpened"))!=null)//Bug 82812 Start
            formsession.setIsListviewOpened(true);
        else
            formsession.setIsListviewOpened(false);
        if(IFormUtility.escapeHtml4(request.getParameter("advancedListviewOpened"))!=null)
            formsession.setIsAdvancedListviewOpened(true);
        else
            formsession.setIsAdvancedListviewOpened(false);//Bug 82812 End
        EControl objControl = (EControl)IFormUtility.getFormField(controlId, formviewer);//Bug 85519
        String controlName=objControl.getM_strDataClassName();
        if("".equals(controlName)){
            controlName=objControl.getM_objControlStyle().getM_strCustomControlId();
            if("".equals(controlName))
                controlName=objControl.getControlId();
        }
        if(webServiceType!=null&&"custom".equalsIgnoreCase(webServiceType)){
            JSONArray respJSON=new JSONArray();
            String m_strCWSjson = "";
            JSONObject m_objCWSjson = null;
            String strOutXml ="";//"<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CUSTOMER_EXPOSURE</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>CAS</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>CAS153984246089589</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>2018-10-18T10:01:02.490+04:00</Extra2></EE_EAI_HEADER><CustomerExposureResponse><RequestType>ExternalExposure</RequestType><ReferenceNumber>171416</ReferenceNumber><ReportUrl>https://ant2a2aapps01.rakbanktst.ae:446/GetPdf.aspx?refno=ntfzUCo9OAg%3d</ReportUrl><IsDirect>N</IsDirect><CustInfo><FullNm>ACCOUNT NAME FOR       2539327XXXXXXXXXXXX</FullNm><Activity>0</Activity><TotalOutstanding>0</TotalOutstanding><TotalOverdue>0.00</TotalOverdue><NoOfContracts>0</NoOfContracts><CustInfoListDet><ReferenceNumber>171416</ReferenceNumber><InfoType>NameENInfo</InfoType><CustName>ACCOUNT NAME FOR       2539327XXXXXXXXXXXX</CustName><CustNameType>CompanyTradeName</CustNameType><ActualFlag>true</ActualFlag><ProviderNo>B01</ProviderNo><CreatedOn>2018-10-17</CreatedOn><DateOfUpdate>2018-10-17</DateOfUpdate></CustInfoListDet><CustInfoListDet><ReferenceNumber>171416</ReferenceNumber><InfoType>TradeLicenseHistorylst</InfoType><ActualFlag>true</ActualFlag><ProviderNo>B01</ProviderNo><RegistrationPlace>3</RegistrationPlace><LicenseNumber>724906</LicenseNumber><CreatedOn>2018-10-17</CreatedOn><DateOfUpdate>2018-10-17</DateOfUpdate></CustInfoListDet><PhoneInfo><ReportedDate>2018-10-17</ReportedDate></PhoneInfo><InquiryInfo><ContractCategory>C</ContractCategory></InquiryInfo></CustInfo><ScoreInfo></ScoreInfo><RecordDestributions><RecordDestribution><ContractType>TotalSummary</ContractType><Contract_Role_Type></Contract_Role_Type><TotalNo>1</TotalNo><DataProvidersNo>1</DataProvidersNo><RequestNo>1</RequestNo><DeclinedNo>0</DeclinedNo><RejectedNo>0</RejectedNo><NotTakenUpNo>0</NotTakenUpNo><ActiveNo>0</ActiveNo><ClosedNo>0</ClosedNo></RecordDestribution><RecordDestribution><ContractType>Installments</ContractType><Contract_Role_Type>Holder</Contract_Role_Type><TotalNo>0</TotalNo><DataProvidersNo>0</DataProvidersNo><RequestNo>0</RequestNo><DeclinedNo>0</DeclinedNo><RejectedNo>0</RejectedNo><NotTakenUpNo>0</NotTakenUpNo><ActiveNo>0</ActiveNo><ClosedNo>0</ClosedNo></RecordDestribution><RecordDestribution><ContractType>NotInstallments</ContractType><Contract_Role_Type>Holder</Contract_Role_Type><TotalNo>0</TotalNo><DataProvidersNo>0</DataProvidersNo><RequestNo>0</RequestNo><DeclinedNo>0</DeclinedNo><RejectedNo>0</RejectedNo><NotTakenUpNo>0</NotTakenUpNo><ActiveNo>0</ActiveNo><ClosedNo>0</ClosedNo></RecordDestribution><RecordDestribution><ContractType>CreditCards</ContractType><Contract_Role_Type>Holder</Contract_Role_Type><TotalNo>1</TotalNo><DataProvidersNo>0</DataProvidersNo><RequestNo>1</RequestNo><DeclinedNo>0</DeclinedNo><RejectedNo>0</RejectedNo><NotTakenUpNo>0</NotTakenUpNo><ActiveNo>0</ActiveNo><ClosedNo>0</ClosedNo></RecordDestribution><RecordDestribution><ContractType>Services</ContractType><Contract_Role_Type>Holder</Contract_Role_Type><TotalNo>0</TotalNo><DataProvidersNo>0</DataProvidersNo><RequestNo>0</RequestNo><DeclinedNo>0</DeclinedNo><RejectedNo>0</RejectedNo><NotTakenUpNo>0</NotTakenUpNo><ActiveNo>0</ActiveNo><ClosedNo>0</ClosedNo></RecordDestribution></RecordDestributions><Derived><Total_Exposure>01-12-2018 12:12:12</Total_Exposure><WorstCurrentPaymentDelay>0</WorstCurrentPaymentDelay><Worst_PaymentDelay_Last24Months>0</Worst_PaymentDelay_Last24Months><Nof_Records>0</Nof_Records><NoOf_Cheque_Return_Last3>0</NoOf_Cheque_Return_Last3><Nof_DDES_Return_Last3Months>0</Nof_DDES_Return_Last3Months><Nof_DDES_Return_Last6Months>0</Nof_DDES_Return_Last6Months><Nof_Cheque_Return_Last6>0</Nof_Cheque_Return_Last6><DPD30_Last6Months>0</DPD30_Last6Months><Nof_Enq_Last90Days>0</Nof_Enq_Last90Days><Nof_Enq_Last60Days>0</Nof_Enq_Last60Days><Nof_Enq_Last30Days>0</Nof_Enq_Last30Days><TotOverDue_GuarteContrct>0</TotOverDue_GuarteContrct></Derived><ProductExposureDetails><ChequeDetails><ChqType></ChqType><Number></Number><Amount></Amount><ReturnDate></ReturnDate><ProviderNo></ProviderNo><ReasonCode></ReasonCode><Severity></Severity></ChequeDetails></ProductExposureDetails></CustomerExposureResponse></EE_EAI_MESSAGE>";
            ArrayList<CustomWebServiceMapping> lsWS=new ArrayList<CustomWebServiceMapping>();
            if(objControl.getM_objControlEvent().getM_arrIFormEventInfo().size()>0){
                for(int j=0;j<objControl.getM_objControlEvent().getM_arrIFormEventInfo().size();j++){
                    if(objControl.getM_objControlEvent().getM_arrIFormEventInfo().get(j).getM_strEventType().equalsIgnoreCase(eventType)){
                        lsWS=(ArrayList<CustomWebServiceMapping>)objControl.getM_objControlEvent().getM_arrIFormEventInfo().get(j).getM_lsCustomWebService();
                        break;
                    }
                }
            }
            String[] message=new String[2];      //message[SuccessMsg,ErrorMsg]
            String[] tempMsg=new String[2];
            message[0]=message[1]="";
            String ResponseCode="0";
            boolean successFlag=true;
            if(lsWS.size()>0){
                for(int i=0;i<lsWS.size();i++)
                {
                        CustomWebServiceMapping objService= (CustomWebServiceMapping)lsWS.get(i);
                        m_objCWSjson=IFormAPI.executeCustomService(request,response,objService.getInputXml(wdmodel, formviewer,formsession,request),formviewer.getM_objFormDef(),controlName);
                        strOutXml = String.valueOf(m_objCWSjson.get("responseData"));
                        if (strOutXml == null || strOutXml.trim().length() == 0)
                        {
                            continue;
                        }
                        tempMsg=objService.setOutputJSON(strOutXml,formviewer,response,wdmodel,respJSON,isTaskForm,formsession,request);
                        
                        if(tempMsg[0].equalsIgnoreCase("0")){
                            message[0]=tempMsg[1];
                        }else{
                            successFlag=false;
                            message[1]+=tempMsg[1];
                            ResponseCode=tempMsg[0];
                        }
//                        if(i<lsWS.size()-1)
//                            message+="\\n";
                }
            }
            if(successFlag)
                response.setHeader("message",IFormUtility.forJava(IFormUtility.removeSpecial(message[0])));
            else
                response.setHeader("message",IFormUtility.forJava(IFormUtility.removeSpecial(message[1])));
            response.setHeader("ResponseCode",IFormUtility.forJava(IFormUtility.removeSpecial(ResponseCode)));
            if( m_objCWSjson != null ){
                m_objCWSjson.put("responseData", respJSON);
                out.print(m_objCWSjson.toString());
            }
        }
        else{
            ArrayList<WebServiceMapping> lsWS=new ArrayList<WebServiceMapping>();
            if(objControl.getM_objControlEvent().getM_arrIFormEventInfo().size()>0){
                for(int j=0;j<objControl.getM_objControlEvent().getM_arrIFormEventInfo().size();j++){
                    if(objControl.getM_objControlEvent().getM_arrIFormEventInfo().get(j).getM_strEventType().equalsIgnoreCase(eventType)){
                        lsWS=(ArrayList<WebServiceMapping>)objControl.getM_objControlEvent().getM_arrIFormEventInfo().get(j).getM_lsWebService();
                        break;
                    }
                }
            }
			JSONObject objWSData = new JSONObject();
            JSONArray objMsgList = new JSONArray();
            JSONArray respWSJSON=new JSONArray();
            if(lsWS.size()>0){
                for(int i=0;i<lsWS.size();i++)
                {
                        WebServiceMapping objService= (WebServiceMapping)lsWS.get(i);
                        IFormCustomHooks objWSHook = CommonUtility.getHookObject(request);
                        ((IFormAPIHandler)formsession.getObjFormReference()).getAPIList().clear();
                        objWSData.put("error", "true");
                        boolean isMicroserviceMode = IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.IS_MICROSERVICE_MODE) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.IS_MICROSERVICE_MODE)); 
                        String inputXml = null;
                        if (isMicroserviceMode) {
                                inputXml = objService.getInputJson(wdmodel, formviewer.getM_objFormDef(), request);
                            } else {
                                inputXml = objService.getInputXml(wdmodel, formviewer.getM_objFormDef(), request);
                            }
                        if (null != objWSHook) {
                            inputXml = objWSHook.preHookWebService(objService.getService(), inputXml, formsession.getObjFormReference());
                        }
                        String strOutXml = null;
                        if (isMicroserviceMode) {
                            String httpMethod = "POST";
                            StringBuilder url = new StringBuilder();
                            url.append(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.GATEWAY_URI));
                            url.append(IFormConstants.WEB_SERVICE_NAME);
                            url.append(IFormConstants.WEB_SERVICE_INVOKER_END_POINT);
                            
                            Map<String, String> headers = new HashMap<>();
                            headers.put("UserId", formsession.getM_strUserIndex());
                            headers.put("Accept-Language", formsession.getObjLocale().toLanguageTag());
                            headers.put("Tenant-Id", formsession.getM_strCabinetName());
                            headers.put("Authorization", formsession.getM_strSessionId());
                            Map<String, String> queryParams = new HashMap<>();
                            Map<String, String> pathParams = new HashMap<>();
                            strOutXml = IFormRestCallBroker.executeWrapper(inputXml,
                                    url.toString(), httpMethod, headers, queryParams, pathParams, formsession);
                        } else {
                            strOutXml = IFormCallBroker.execute(inputXml, formsession.getM_objIFormCabinetInfo().getM_strServerIP(), Integer.parseInt(formsession.getM_objIFormCabinetInfo().getM_strServerPort()));
                        }
                        if (strOutXml == null || strOutXml.trim().length() == 0) {
                            return;
                        }
                        if(null != objWSHook)
                            strOutXml = objWSHook.postHookWebService(objService.getService(), strOutXml, formsession.getObjFormReference(), objMsgList);
                        objWSData.put("error", "false");    
                        boolean isOldMethod=false;
                        if(objService.isIsOldWSScreen())
                            isOldMethod=false;
                        else
                            isOldMethod=objService.isIsRestService();
                        if (isMicroserviceMode) {
                        if (isOldMethod) {
                          // For Rest Service
                          objService.setOutputJsonService(strOutXml, formviewer, response, wdmodel, respWSJSON, isTaskForm, formsession, request, objService.isIsBRMSRest());
                        } else {
                          if (objService.isIsOldWSScreen()) {
                          //For SOAP service with basic structure
                            objService.setOutputXmlService(strOutXml, formviewer.getM_objFormDef(), response, wdmodel, respWSJSON, isTaskForm, objService.isIsRestService(), objService.isIsBRMSRest());
                          } else {
                          //For SOAP service with complex structure
                            objService.setOutputXmlService(strOutXml, formviewer, response, wdmodel, respWSJSON, isTaskForm, formsession, request);
                          }
                        }
                      } else {
                        if (isOldMethod) {
                          objService.setOutputJSON(strOutXml, formviewer, response, wdmodel, respWSJSON, isTaskForm, formsession, request, objService.isIsBRMSRest());
                        } else {
                          if (objService.isIsOldWSScreen()) {
                            objService.setOutputXml(strOutXml, formviewer.getM_objFormDef(), response, wdmodel, respWSJSON, isTaskForm, objService.isIsRestService(), objService.isIsBRMSRest());
                          } else {
                            objService.setOutputXml(strOutXml, formviewer, response, wdmodel, respWSJSON, isTaskForm, formsession, request);
                          }
                        }
                      }
                }
            }
                if(!objMsgList.isEmpty())
                objWSData.put("responseData", objMsgList);

                objWSData.put("WSDATA", respWSJSON);
                if(!((IFormAPIHandler)formsession.getObjFormReference()).getAPIList().isEmpty()){
                    objWSData.put("APIData",((IFormAPIHandler)formsession.getObjFormReference()).getAPIList());//Bug 84292
                }
                String repo = objWSData.toString();                    
                out.print(URLEncoder.encode(repo, "UTF-8").replaceAll("\\+", "%20"));
        }
    }
    catch (Exception e) 
    {
        //NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception while executing Webservice..."+e.getMessage(),e); 
    }


%>
