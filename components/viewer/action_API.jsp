<%@page import="com.newgen.pci.util.EncryptionDecryption"%>
<%@page import="com.newgen.iforms.custom.IFormCustomHooks"%>
<%@page import="com.newgen.iforms.custom.IFormServerEventHandler"%>
<%@page import="com.newgen.iforms.custom.IFormContext"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.newgen.iforms.custom.IFormAPIHandler"%>
<%@page import="com.newgen.iforms.custom.IFormReference"%>
<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page import="com.newgen.iforms.nav.Menu"%>
<%@page import="com.newgen.iforms.nav.IFormFragInfo"%>
<%@page import="com.newgen.iforms.util.CommonUtility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--
    Document   : action_API
    Created on : 18 Aug, 2017, 4:37:56 PM
    Author     : aman.khan

11/07/2018           Aman Khan               Bug 79007 - API to set mapping for Grid, in iForms
07/09/2018           Aman Khan             Bug 80062 - We are having a custom jsp on which data comes from web service. we need to populate this data from jsp to grid on the IForm. Thus requires the function to add data from jsp to grid
30/10/2018          Gaurav Sharma           Bug 81096 - need function calling capability on link in listview
06/11/2018          Gaurav                  Bug 81231 - setTableCellData not working after deletion of row in table
16/11/2018          Gaurav                  Bug 81361 - precision not working properly on float fields
04/01/2018          Aman Khan               Bug 82335 - Row index fetched in the label method is wrong
16/11/2018          Abhishek                Bug 82333 - Issue in displaying special characters in Table and ListView in IForms
25/01/2019          Aman Khan               Bug 82662 - checkboxes for selecting the row hides when we hide delete and add button
21/02/2019          Gaurav                  Bug 83234 - Data not getting set using server side adddatatogrid api if the control type is label
21/02/2019          Abhishek                Bug 83244 - alignment of table entries
28/02/2019          Gaurav                  Bug 83339 - addDatatogrid Api data now showing properly in grid
01/03/2019          Aman Khan               Bug 83358 - The set values function is not accepting two consecutive \n separators between texts.
06/03/2019          Gaurav                  Bug 83424 - Provide API to add,remove and clear Combo in table Cell
01/03/2019          Abhishek                Bug 83363 - cell data being cut off.
11/03/2019          Aman Khan               Bug 83508 - we are using getValueFromTableCell() function to get the value of the cell but data is coming without space
15/03/2019          Gaurav                  Bug 83662 - Unable to Add data into the Advance list view when the advancedgrid have one parent queue variable
25/03/2019          Gaurav                  Bug 83738 - issue in saving of advanced listview
25/03/2019          Abhishek                Bug 83733 - masking option for datetime and date picker
25/03/2019          Abhishek                Bug 83732 - filling date without opening date picker
03/04/2019          Gaurav                  Bug 83972 - combo not getting rendered in advanced listview if frame is initially collapsed and some value is set as default
04/04/2019			Gaurav					Bug 84017 - DB linking is not getting called in subform
19/04/2019          Gaurav                  Bug 84280 - Buttons in grid don't function right when disabled
30/04/2019          Gaurav                  Bug 84399 - data not saving in main form using setValues API if overlay is open
03/05/2019          Gaurav                  Bug 84471 - Add DataToGrid api is not working when the grid is not rendered
03/05/2019          Gaurav                  Bug 84470 - Listview data deleted from table on Save event when using setTableCellData APi for advanced listview
06/05/2019          Gaurav                  Bug 84494 - total not working in table due to issue with tooltipster
27/05/2019          Gaurav                  Bug 84916 - initially collapsed section inside advanced listview is coming as expanded for new row/modify once section is expanded
20/06/2019          Gaurav                  Bug 85361 - data not saving in table when task is opened with case form
23/09/2019           Abhishek                Bug 86823 - Require return flag for saveSection API
26/11/2019          Rohit Kumar             Bug 89369 - List view rows getting deleted automatically
15/02/2020          Karishma Rastogi        Bug 88795 - On Application if defined substep on end step than unable to fill data on it  Finish should not be display .
--%>
<%@page import="com.newgen.iforms.controls.ETabSheetControl"%>
<%@page import="com.newgen.iforms.base.IFormEventInfo"%>
<%@page import="com.newgen.iforms.EControlOption"%>
<%@page import="com.newgen.iforms.designer.ColumnInfo"%>
<%@page import="com.newgen.iforms.xmlapi.IFormXMLParser"%>
<%@page import="com.newgen.iforms.xmlapi.IFormCallBroker"%>
<%@page import="com.newgen.iforms.xmlapi.IFormInputXml"%>
<%@page import="com.newgen.iforms.controls.util.EControlHelper"%>
<%@page import="com.newgen.iforms.IControl"%>
<%@page import="com.newgen.iforms.controls.EFrameControl"%>
<%@page import="com.newgen.json.JSONArray"%>
<%@page import="java.io.StringReader"%>
<%@page import="com.newgen.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.Reader"%>
<%@page import="javax.print.DocFlavor.READER"%>
<%@page import="com.newgen.json.parser.JSONParser"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDTaskInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDTaskTemplateInfo"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.newgen.iforms.FormDef"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.iforms.viewer.IFormHandler"%>
<%@page import="com.newgen.mvcbeans.model.WiAttribHashMap"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WorkdeskAttribute"%>
<%@page import="com.newgen.iforms.controls.ETableControl"%>
<%@page import="com.newgen.iforms.EControl"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="com.newgen.iforms.db.DatabaseUtil"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.StringBuilder"%>
<%@page import="com.newgen.iforms.api.IFormAPI"%>
<%@page import="com.newgen.iforms.EControlStyle" %>
<%@page import="com.newgen.iforms.controls.ERootControl" %>
<%@page import="com.newgen.iforms.controls.ETabControl" %>
<%@page import="com.newgen.iforms.controls.ETextControl"%>
<%
    request.setCharacterEncoding("UTF-8");
    String getZoneList= request.getParameter("getZoneList");
    if(getZoneList != null && "Y".equals(getZoneList))
    {
       out.print(IFormAPI.getZoneDefinition(request, response));
       return;
    }
%>

<%	
	String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
    String rid_ActionAPI = IFormUtility.generateTokens(request,request.getRequestURI());
    response.setHeader("WD_RID", rid_ActionAPI);
	
	/* 
	// Sometimes WD_RID set in HTTP Response Header  is not being returned in client response
	
	String strReloadFlag = IFormUtility.escapeHtml4(request.getParameter("reloadTab"));
	
	if((rid_ActionAPI != null) && (rid_ActionAPI.length() > 0) && strReloadFlag != null){	
<if_rid style='display:none'><%=rid_ActionAPI % ></if_rid>
	
	}*/
%>
	

	
<%
    if(getZoneList != null && "Y".equals(getZoneList))
    {
       out.print(IFormAPI.getZoneDefinition(request, response));
       return;
    }
    /*IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
    String queryString=null;
    String requestString = request.getParameter("getquery");
    String cacheRequestString = request.getParameter("getcachedquery");
    String updateString = request.getParameter("savequery");
    if(requestString!=null) queryString = "getquery";
    if(cacheRequestString!=null) queryString = "getcachedquery";*/
    //String s = request.getParameter("controls");
    //out.print(s);
    //response.setHeader("controls",s);
     String framehtml="";
    String fromEvent = IFormUtility.escapeHtml4(request.getParameter("fromEvent"));
    Object jSONObject = IFormAPI.execute(request,response);
    if(jSONObject != null) out.print(jSONObject);

    // JSONObject jsonObj = IFormAPI.execute(request, response);

    /* List<List<String>> lsdata = null;
    if (requestString != null) {
    lsdata = DatabaseUtil.getDataFromDataSource(requestString, objIFormSession);
    } else if (cacheRequestString != null) {
    lsdata = DatabaseUtil.getCachedData(cacheRequestString, objIFormSession);
    } else if (updateString != null) {
    int updatedCount = DatabaseUtil.saveDataInDataSource(updateString, objIFormSession);
    out.println(updatedCount);
    }
    if (requestString != null || cacheRequestString != null) {
    JSONObject jsonObj = new JSONObject();
    for (int i = 0; i < lsdata.size(); i++) {
    List<String> coldata = lsdata.get(i);
    jsonObj.put(i, coldata);
    }
    out.print(jsonObj);
    }*/
    
  else{
        IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
            IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
            FormDef m_objFormDef = formviewer.getM_objFormDef();
   String visibleFlag = IFormUtility.escapeHtml4(request.getParameter("visibleFlag"));
   if(visibleFlag != null){
       String tableId = IFormUtility.escapeHtml4(request.getParameter("tableId"));
       String colIndex = IFormUtility.escapeHtml4(request.getParameter("colIndex"));
       //response.setHeader("tableId", tableId);
       //response.setHeader("colIndex", colIndex);
       //response.setHeader("visibleFlag", visibleFlag);
       //IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
       EControl objControl = new EControl();
       objControl = (EControl) IFormUtility.getFormField(tableId,formviewer);

       ETableControl objTable=(ETableControl)objControl;
       objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).setVisibility(Boolean.parseBoolean(visibleFlag));
       objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).setM_strVisibility(visibleFlag);
   }
   
   String disableFlag = IFormUtility.escapeHtml4(request.getParameter("disableFlag"));
   if(disableFlag != null){
       String tableId = IFormUtility.escapeHtml4(request.getParameter("tableId"));
       String colIndex = IFormUtility.escapeHtml4(request.getParameter("colIndex"));
	   boolean isMulti = false;
       if(request.getParameter("multi")!= null){
            isMulti = "Y".equals(IFormUtility.escapeHtml4(request.getParameter("multi")));
       }
       //response.setHeader("tableId", tableId);
       //response.setHeader("colIndex", colIndex);
       //response.setHeader("disableFlag", disableFlag);
       //IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
       EControl objControl = new EControl();
        objControl = (EControl) IFormUtility.getFormField(tableId,formviewer);

       ETableControl objTable=(ETableControl)objControl;
       if(isMulti){
           String [] cols = colIndex.split(",");
           for( int p=0; p < cols.length; p++ ){
               objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(cols[p].trim())).setM_bDisable(Boolean.parseBoolean(disableFlag));
           }
       }
       else{
         objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).setM_bDisable(Boolean.parseBoolean(disableFlag));
       }
  }
    
    String deleteTableFlag = IFormUtility.escapeHtml4(request.getParameter("deleteTableFlag"));
    String controlId = IFormUtility.escapeHtml4(request.getParameter("controlId"));
    if (deleteTableFlag != null && controlId != null) {
            //IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
                EControl objControl = new EControl();

        if (("yes").equals(deleteTableFlag)) {
            String deleteRowArray[]=IFormUtility.escapeHtml4(request.getParameter("deleterow")).split(",");
            objControl = (EControl) IFormUtility.getFormField(controlId,formviewer);
         
            ETableControl objTable = (ETableControl) objControl;
            List<List<String>> objModel = objTable.getObj_eTableModal().getM_TableData();
            for (int i = objModel.size()-1; i >= 0; i--) {//Bug 82255
                if (deleteRowArray[i].equalsIgnoreCase("y")) {
                    objModel.remove(i);
                }
            }
            WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);//Bug 85361
            WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
            if (wiAttr != null) {
                wiAttr.setModifiedFlag("Y");
                IFormUtility.setAdvancedListviewRowModifyFlag(objTable,request,"Y");
                ArrayList attribList = (ArrayList) wiAttr.getAttribValue();
                for (int rowIndex = attribList.size()-1; rowIndex > 0; rowIndex--) {//Bug 82255
                    WiAttribHashMap attriSubMap = (WiAttribHashMap) attribList.get(rowIndex);//Bug 82255
                    WorkdeskAttribute attribute1 = (WorkdeskAttribute) attriSubMap.get("<INS_ORDER_ID>");
                    int insertionOrderId = attribute1.getInsertionOrderId();
                    if (insertionOrderId == 0) {
                        attribute1.setStatus(0);
                        attribute1.setModifiedFlag("N");
                        attribList.remove(rowIndex);//Bug 82255
                    } else if(insertionOrderId>0){
                        attribute1.setInsertionOrderId(-insertionOrderId);
                        attribute1.setStatus(2);
                        attribute1.setModifiedFlag("Y");
                    }
                }
            }
            int rowId=-1;
            if(wiAttr==null){
                objTable.setCurrentRowID(objTable.getObj_eTableModal().getM_TableData().size());
            }
            else
                objTable.setCurrentRowID(((ArrayList)wiAttr.getAttribValue()).size()-2);
            //response.setHeader("tableControlId", controlId);
        }
    }

    String setValuesFlag = IFormUtility.escapeHtml4(request.getParameter("setValuesFlag"));
    String setTableDataFlag = IFormUtility.escapeHtml4(request.getParameter("setTableDataFlag"));

    if (("yes").equals(setValuesFlag)) {
        //IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));

        WorkdeskModel wdmodel;
        String pid = IFormUtility.escapeHtml4(request.getParameter("pid"));
        String wid = IFormUtility.escapeHtml4(request.getParameter("wid"));
        String jsonString = request.getParameter("jsonString");
        String attrTypesJSONString = request.getParameter("attrTypesJSONString");
        String tid = IFormUtility.getIFormTaskId(request);
        String fid = objIFormSession.getFid();
        String attrName="",attrValue="",attrType="";
        StringBuffer controls = new StringBuffer();
        StringBuffer values = new StringBuffer();
        WDWorkitems wisessionbean = (WDWorkitems) request.getSession().getAttribute("wDWorkitems");
        LinkedHashMap workitemMap = wisessionbean.getWorkItems();
//        FormDef m_objFormDef = formviewer.getM_objFormDef();

        JSONParser jSONParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jSONParser.parse(new StringReader(jsonString));
        JSONObject jsonObjAttrTypes = (JSONObject) jSONParser.parse(new StringReader(attrTypesJSONString));
        Set<Object> set = jsonObj.keySet();
            Iterator<Object> iterator = set.iterator();
        //String attrTypes = request.getParameter("attrTypes");
        int count=0;
        while(iterator.hasNext()){
            Object obj = iterator.next();
            attrName = obj.toString();
            controls.append(attrName+",");
            attrValue = jsonObj.get(obj).toString();
            values.append(attrValue+",");
            String value = jsonObj.get(obj).toString();
            attrType = jsonObjAttrTypes.get(obj).toString();
            //out.print(value);   //Bug 83358
        //out.print(jsonObj);     //Bug 83358
        if (tid == null || tid.isEmpty()) {
            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
        } else {
            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
        }
        try{
        EControl controlObj = (EControl) IFormUtility.getFormField(attrName,formviewer);
        if(controlObj==null)
            controlObj=(EControl)m_objFormDef.getSubFormField(((ERootControl)m_objFormDef.getM_objRootControl()).getBtnRef(), attrName);
        String saveencrypt = controlObj.getM_objControlStyle().getM_strSaveEncrypted();
        
        if(("Text".equals(attrType) || "password".equals(attrType)) && "Y".equalsIgnoreCase(saveencrypt)){
                try{
                     EncryptionDecryption ed=(EncryptionDecryption) Class.forName("com.newgen.pci.util.EncryptionDecryption").newInstance();                  
                     attrValue = ed.encryptFormField(attrValue,wdmodel.getM_objGeneralData().getM_strEngineName());                  
                }
                catch (Exception ex) {
                    NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in encrypting value passed from setValues API for attributeName : "+attrName+".." + ex.getMessage(), ex);
               }
                 catch(Error err){
                     NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in encrypting value passed from setValues API for attributeName : "+attrName+".." + err.getMessage(), err);
                }
        }
      //  String attrName = request.getParameter("attrName");
       // String attrValue = request.getParameter("attrValue");
       // String attrType = request.getParameter("attrType");
        String valueArray[] = attrName.toString().split("\\.");
        String masking="";
        String placeholder="";
        //response.setHeader("controlId", attrName);
        //response.setHeader("controls", controls.toString());     //Bug 83358
        //response.setHeader("values", values.toString());         //Bug 83358
        //String attrType = "";
        //String attrType = attrTypes.split(",")[count++];
        //response.setHeader("controlValue", attrValue);
        if ("textarea".equals(attrType)) {
        }
        if ("date".equals(attrType)&&!"".equals(attrValue)) {//Bug 82554
             boolean isMobileMode=("ios".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode())||"android".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode()))?true:false;
            String strDBFormat = "yyyy-MM-dd HH:mm:ss";
            Date date = null;
            try {
                //String strDateFormat = wdmodel.getM_objGeneralData().getM_strDateFormat();
                 String dateFormat = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat();
                String dateSeparator = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator();
                
                IControl eControl = (IControl) IFormUtility.getFormField(attrName,formviewer);

                String pickerType = eControl.getM_objControlStyle().getM_strPickerType();
             
                    String ds = "", df = "";
                    if (dateSeparator.equalsIgnoreCase("1")) {
                        ds = "/";
                    } else if (dateSeparator.equalsIgnoreCase("2")) {
                        ds = "-";
                    } else if (dateSeparator.equalsIgnoreCase("3")) {
                        ds = ".";
                    }
                    if (isMobileMode) {
                        ds = "-";
                    }
                    if (dateFormat.equalsIgnoreCase("1")) {
                        df = "dd" + ds + "MM" + ds + "yyyy";
                    }
                    if (dateFormat.equalsIgnoreCase("2")) {
                        df = "MM" + ds + "dd" + ds + "yyyy";
                    }
                    if (dateFormat.equalsIgnoreCase("3")) {
                        df = "yyyy" + ds + "MM" + ds + "dd";
                    }
                    if (dateFormat.equalsIgnoreCase("4")) {
                        df = "dd" + ds + "MMM" + ds + "yyyy";
                    }
                    if (pickerType.equalsIgnoreCase("2")) {
                        df += " HH:mm:ss";
                    }
                    if (isMobileMode) {
                        df = "yyyy" + ds + "MM" + ds + "dd";
                        if (pickerType.equalsIgnoreCase("2")) {
                            df += "'T'HH:mm";
                        }
                    }
                
                
                date = new SimpleDateFormat(df, Locale.ENGLISH).parse(attrValue);
                //date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(attrValue);
            } catch (ParseException ex) {
               // NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in method IFormHandler:updateAttributeValue()..." + ex.getMessage(), ex);
            }
            attrValue = new SimpleDateFormat(strDBFormat).format(date);
        }


        if ("TaskForm".equals(fid)) {
            if (true) {
                WDTaskTemplateInfo tempInfo = null;

                for (int i = 0; i < wdmodel.getM_objTaskInfo().getM_arrTaskTemplateInfo().size(); i++) {
                    tempInfo = wdmodel.getM_objTaskInfo().getM_arrTaskTemplateInfo().get(i);

                    if (!tempInfo.isM_boolIsReadOnly()) {
                        if (attrName.equals(tempInfo.getM_strFieldName())) {
                            if (!attrValue.equals(tempInfo.getM_strFieldInput())) {
                                tempInfo.setM_strModified("Y");
                                tempInfo.setM_strFieldInput(attrValue);
                            }
                        }
                    }
                }
            }
        } else if ("TemplateTaskForm".equals(fid)) {
            WDTaskInfo wDTaskInfo = (WDTaskInfo) request.getSession(false).getAttribute("TemplateTaskInfo");
            if (wDTaskInfo != null) {
                if (true) {
                    WDTaskTemplateInfo tempInfo = null;

                    for (int i = 0; i < wDTaskInfo.getM_arrTaskTemplateInfo().size(); i++) {
                        tempInfo = wDTaskInfo.getM_arrTaskTemplateInfo().get(i);

                        if (!tempInfo.isM_boolIsReadOnly()) {
                            if (attrName.equals(tempInfo.getM_strFieldName())) {
                                if (!attrValue.equals(tempInfo.getM_strFieldInput())) {
                                    tempInfo.setM_strModified("Y");
                                    tempInfo.setM_strFieldInput(attrValue);
                                }
                            }
                        }
                    }
                }
            }
        } else if ("DataTemplateTaskForm".equals(fid)) {
            return;
        } else {
            boolean advancedListviewValueSet=false;
            if(request.getSession().getAttribute(IFormUtility.escapeHtml4(request.getParameter("fid"))+"_AdvancedListviewMap")!=null){
                    WiAttribHashMap wiAttribMap=(WiAttribHashMap)request.getSession().getAttribute(IFormUtility.escapeHtml4(request.getParameter("fid"))+"_AdvancedListviewMap");
                    if ("listbox".equalsIgnoreCase(attrType)){
                        ArrayList options = new ArrayList();
                        JSONParser lbJSONParser = new JSONParser();
                        JSONObject lbJsonObj = null;
                        try {
                            lbJsonObj = (JSONObject) lbJSONParser.parse(new StringReader(attrValue));
                        } catch (Exception ex) {
                        }

                        Set<Object> lbSet = lbJsonObj.keySet();
                        for (Object lbKey : lbSet) {
                            String selectedValue = lbJsonObj.get(lbKey).toString();
                            options.add(selectedValue);
                        }
                        advancedListviewValueSet=IFormUtility.setAdvancedListviewRowMemberAttribute(valueArray, wiAttribMap, options);
                    }
                    else{
                        advancedListviewValueSet=IFormUtility.setAdvancedListviewRowMemberAttribute(valueArray, wiAttribMap, attrValue);
                    }
                }
            if(!advancedListviewValueSet){
                 if ("listbox".equalsIgnoreCase(attrType)) {
                     WorkdeskAttribute lbwattr = ((WorkdeskAttribute) wdmodel.getAttributeMap().get(valueArray[0]));
                     ArrayList options = new ArrayList();
                     JSONParser lbJSONParser = new JSONParser();
                     JSONObject lbJsonObj = null;
                     try {
                         lbJsonObj = (JSONObject) lbJSONParser.parse(new StringReader(attrValue));
                     } catch (Exception ex) {
                     }

                     Set<Object> lbSet = lbJsonObj.keySet();
                     for (Object lbKey : lbSet) {
                         String selectedValue = lbJsonObj.get(lbKey).toString();
                         options.add(selectedValue);
                     }
                     if (lbwattr != null) {
                         lbwattr.setModifiedFlag("Y");
                         if (valueArray.length > 1) {
                             IFormUtility.parseAttribute(lbwattr, valueArray, valueArray.length, options);
                         }
                     else{
                            lbwattr.setValue(options);
                        }
                    }
                 }
                else{
                    WorkdeskAttribute wAttr = null;
                    if(wdmodel!=null)
                        wAttr = ((WorkdeskAttribute) wdmodel.getAttributeMap().get(valueArray[0]));
                    if (wAttr != null) {
                        wAttr.setModifiedFlag("Y");
                        if (valueArray.length > 1) {
                            IFormUtility.parseAttribute(wAttr, valueArray, valueArray.length, attrValue);
                        } else {
                            wAttr.setValue(attrValue);
                        }
                    } else {
                        m_objFormDef.getM_unMappedControls().put(attrName, attrValue);
                    }
                }
            }
        }
        controlObj.setM_strControlValue(attrValue);
        } catch (Exception | Error ex) {
            NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in encrypting value passed from setValues API for attributeName : "+attrName+" and attributeValue: "+attrValue+".."+ ex.getMessage(), ex);
        }
        /*    String jsonString = request.getParameter("jsonObj");
        //             JSONObject jsonObj = new JSONObject();
        //             jsonObj.put("jsonString", jsonString);
        String attrName = request.getParameter("attrName");
        String attrValue = request.getParameter("attrValue");
        String attrType = request.getParameter("attrType");
        String valueArray[] = attrName.toString().split("\\.");
        
        response.setHeader("controlId", controlId);
        String pid = request.getParameter("pid");
        String wid =  request.getParameter("wid");
        String tid =   IFormUtility.getIFormTaskId(request);
        WorkdeskModel wdmodel;
        WDWorkitems wisessionbean = (WDWorkitems) request.getSession().getAttribute("wDWorkitems");
        LinkedHashMap workitemMap = wisessionbean.getWorkItems();
        if (tid == null || tid.isEmpty()) {
        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
        } else {
        wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
        }
        FormDef m_objFormDef = formviewer.getM_objFormDef();
        WorkdeskAttribute wAttr = ((WorkdeskAttribute) wdmodel.getAttributeMap().get(valueArray[0]));
        wAttr.setModifiedFlag("Y");
        if (wAttr != null) {
        wAttr.setValue(attrValue);
        
        } else {
        m_objFormDef.getM_unMappedControls().put(attrName, attrValue);
        }
        
        response.setHeader("controlId", controlId);
        out.print(jsonString);*/
        }
    } else if (("yes").equals(setTableDataFlag)) {
        
        StringBuffer rowIndices = new StringBuffer();
        StringBuffer colIndices = new StringBuffer();
        StringBuffer cellDatas = new StringBuffer();
       // String rowIndex = request.getParameter("rowIndex");
       // String colIndex = request.getParameter("colIndex");
      //  String cellData = request.getParameter("cellData");
        String tableId = IFormUtility.escapeHtml4(request.getParameter("tableId"));
        String jsonString = IFormUtility.escapeHtml4(request.getParameter("jsonString"));
        String rowIndex="",colIndex="",cellData="";
        //response.setHeader("rowIndex", rowIndex);
        //response.setHeader("colIndex", colIndex);
        //response.setHeader("cellData", cellData);
//        IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
        EControl objControl = new EControl();
        objControl = (EControl) IFormUtility.getFormField(tableId,formviewer);

        ETableControl objTable = (ETableControl) objControl;
        List<List<String>> objModel = objTable.getObj_eTableModal().getM_TableData();
         JSONParser jSONParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jSONParser.parse(new StringReader(jsonString));
        Set<Object> set = jsonObj.keySet();
        Iterator<Object> iterator = set.iterator();
        while(iterator.hasNext()){
            Object obj = iterator.next();
             rowIndex = obj.toString().split(",")[0];
             colIndex = obj.toString().split(",")[1];
             cellData = jsonObj.get(obj).toString();
             rowIndices.append(rowIndex+",");
             colIndices.append(colIndex+",");
             cellDatas.append(cellData+",");
            
        List<String> lsdata = objModel.get(Integer.parseInt(rowIndex));
        if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 7) {
           String strDBFormat = "yyyy-MM-dd HH:mm:ss";
           Date date = null;
            try {
                String strDateFormat = "dd/MMM/yyyy";
                date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(cellData);
            } catch (Exception ex) {
                //System.out.println(ex);
//                               NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in method IFormHandler:updateAttributeValue()..."+ex.getMessage(),ex); 
            }
                cellData = new SimpleDateFormat(strDBFormat).format(date);
            objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
            if (EControlHelper.getHTML(objTable, "PickerType").equalsIgnoreCase("2") && "2".equals(objTable.getM_objControlStyle().getM_strTimeZone())) {
                if (objIFormSession != null) {
                    int iMinutes = objIFormSession.getM_iClientTimeDiff() - objIFormSession.getM_iServerTimeDiff();
                    boolean isMobileMode = ("ios".equalsIgnoreCase(objIFormSession.getM_objFormViewer().getM_objFormDef().getM_strMobileMode()) || "android".equalsIgnoreCase(objIFormSession.getM_objFormViewer().getM_objFormDef().getM_strMobileMode())) ? true : false;
                    if (!cellData.isEmpty() && iMinutes != 0) {
                        cellData = IFormUtility.addMinutesToDate(cellData, iMinutes, "yyyy-MM-dd",isMobileMode);
                    }
                }
            }
           
        }

        lsdata.set(Integer.parseInt(colIndex), cellData);
        WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);//Bug 85361
        WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
        ArrayList attribList = (ArrayList) wiAttr.getAttribValue();
       
        IFormUtility.setAdvancedListviewRowModifyFlag(objTable,request,"Y");
		//Bug 81231 Start
        int k=0,l=0;
        WiAttribHashMap attriSubMap = null;
        WorkdeskAttribute attribute1 = null;
        while(k<Integer.parseInt(rowIndex)+1){
            attriSubMap = (WiAttribHashMap) attribList.get(l + 1);
            attribute1 = (WorkdeskAttribute) attriSubMap.get("<INS_ORDER_ID>");
            if(attribute1.getInsertionOrderId()>=0)
                k++;
            l++;
        }
        WiAttribHashMap attribMap = (WiAttribHashMap) attribList.get(l);
		//Bug 81231 End
		String valueArray[] = objTable.getM_strDataClassName().toString().split("\\.");
        String dataClassName = "";
        for (int i = 0; i < valueArray.length; i++) {
            if (i == 0) {
                dataClassName = dataClassName + valueArray[i];
            } else {
                dataClassName = dataClassName + "-" + valueArray[i];
            }
        }
        WorkdeskAttribute attribute = (WorkdeskAttribute) attribMap.get(dataClassName + "-" + objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
        if(attribute !=null){   //Bug 89369
        wiAttr.setModifiedFlag("Y");    
        attribute.setUnbounded("N");
        attribute.setModifiedFlag("Y");
        attribute.setSimpleName(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
        attribute.setValue(cellData);
         }
        }
              //response.setHeader("tableId", tableId);
              response.setHeader("rowIndices", IFormUtility.forJava(rowIndices.toString()));
              response.setHeader("colIndices", IFormUtility.forJava(colIndices.toString()));
              response.setHeader("celldatas", IFormUtility.forJava(cellDatas.toString()));
    }
    else if(fromEvent != null && fromEvent.equalsIgnoreCase("executeServerEvent")) {
        out.print(IFormAPI.executeServerEvent(request, response));
        return;
    }
    
        String frameState = IFormUtility.escapeHtml4(request.getParameter("frameState"));
        String frameStateAPI= IFormUtility.escapeHtml4(request.getParameter("frameStateAPI"));
        String frameId = IFormUtility.escapeHtml4(request.getParameter("frameId"));
        if( frameState != null || frameStateAPI!=null){
            boolean callFromAPI=false;
            if(frameStateAPI!=null){
                callFromAPI=true;
				frameState = frameStateAPI; 
            }
            WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
            WorkdeskModel objWorkdeskModel = null;
            String tid = IFormUtility.escapeHtml4(request.getParameter("tid"));
            String pid = IFormUtility.escapeHtml4(request.getParameter("pid"));
            String wid = IFormUtility.escapeHtml4(request.getParameter("wid"));
            if (wisessionbean != null) {
                LinkedHashMap workitemMap = wisessionbean.getWorkItems();
                if (tid == null || tid.isEmpty()) {
                    objWorkdeskModel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                } else {
                    objWorkdeskModel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                }
            }
            EFrameControl frameObj = null;
            
            for (IControl eframe : ((ERootControl) m_objFormDef.getM_objRootControl()).getM_arrFrameControls()) {
                if (eframe.getControlId().equalsIgnoreCase(frameId) || (frameId).equalsIgnoreCase(eframe.getM_objControlStyle().getM_strCustomControlId())) {
                    frameObj = (EFrameControl) eframe;
                    break;
                }
            }
            if (frameObj == null) {
                    for (IControl eframe : ((ERootControl) m_objFormDef.getM_objRootControl()).getM_arrFrameControls()) {
                        for(IControl eControl : eframe.getM_arrEControls()){
                            if(eControl.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_TAB)){
                                ETabControl eTab = (ETabControl) eControl;
                                for(IControl sheetControl : eTab.getM_arrTabSheetControls()){
                                    for(IControl mainFrame : sheetControl.getM_arrEControls()){
                                         if (mainFrame.getControlId().equalsIgnoreCase(frameId) || (frameId).equalsIgnoreCase(mainFrame.getM_objControlStyle().getM_strCustomControlId())) {
                                                 frameObj = (EFrameControl) mainFrame;
                                                 break;
                                }
                            }
                            
                        }
                        }
                       
                    }
                }
                  frameObj = (EFrameControl) IFormUtility.getFormField(frameId,formviewer);   
            }
           
            if(frameObj==null){
                frameObj = (EFrameControl)formviewer.getM_objFormDef().getSubFormField(((ERootControl)formviewer.getM_objFormDef().getM_objRootControl()).getBtnRef(), frameId);
            }
            
            if ("collapsed".equals(frameState)) {
                //EControl objControl=(EControl)m_objFormDef.getFormField(frameId);
                // EFrameControl frameObj = (EFrameControl)objControl;
                boolean initialState=frameObj.getM_objControlStyle().isM_bFrameCollapsed();//Bug 84916
                if(request.getParameter("refreshCollapsed")!=null)
                    frameObj.setRefreshCollapsedFrame(true);
                frameObj.getM_objControlStyle().setM_bFrameCollapsed(false);
                if(IFormUtility.escapeHtml4(request.getParameter("queueVar"))!=null){
                    frameObj.setM_strDataOnDemandQVar(request.getParameter("queueVar"));
                }
                for(String variable : frameObj.getM_arrRemovedObj()){
                    m_objFormDef.getM_objUnloadedVariables().add(variable);
                }
                if(frameObj.isM_bAdvancedModal()){//Bug 83972
                    framehtml = frameObj.getRenderBlock(m_objFormDef, objIFormSession, null,callFromAPI).toString();//Bug 83972
                }
                else
                {
                    framehtml = frameObj.getRenderBlock(m_objFormDef, objIFormSession, objWorkdeskModel,callFromAPI).toString();
                }
                frameObj.setRefreshCollapsedFrame(false);
                frameObj.getM_objControlStyle().setM_bFrameCollapsed(initialState);//Bug 84916
                //response.setHeader("framehtml", framehtml);
                //response.setHeader("frameid", frameId);
                //String s = "<script>document.getElementById('"+frameId+"').outerHTML = framehtml;</script>";
                out.print(framehtml);
            } else if ("expanded".equals(frameState)) {
               frameObj.saveSection(frameObj, objWorkdeskModel, objIFormSession);
            }
        }
        
        String tabState = IFormUtility.escapeHtml4(request.getParameter("tabState"));
        if(tabState!=null){
            String sheetIndex=IFormUtility.escapeHtml4(request.getParameter("sheetIndex"));
            String sheetID=IFormUtility.escapeHtml4(request.getParameter("sheetID"));
            String tabID=IFormUtility.escapeHtml4(request.getParameter("tabID"));
            String reloadFlag = IFormUtility.escapeHtml4(request.getParameter("reloadTab"));
            WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
            WorkdeskModel objWorkdeskModel = null;
            String tid = IFormUtility.escapeHtml4(request.getParameter("tid"));
            String pid = IFormUtility.escapeHtml4(request.getParameter("pid"));
            String wid = IFormUtility.escapeHtml4(request.getParameter("wid"));
            if (wisessionbean != null) {
                LinkedHashMap workitemMap = wisessionbean.getWorkItems();
                if (tid == null || tid.isEmpty()) {
                    objWorkdeskModel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                } else {
                    objWorkdeskModel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                }
            }
            ETabSheetControl tabSheetObj = null;
            tabSheetObj=(ETabSheetControl)IFormUtility.getFormField(sheetID,formviewer);
           
            
            Iterator iter = tabSheetObj.getM_arrQueueVar().keySet().iterator();
            try{
                while(iter.hasNext()) {
                    String variable=String.valueOf(iter.next());
                    IFormUtility.getVariableData(variable, objIFormSession, objWorkdeskModel);
                    if("N".equals(reloadFlag))
                        formviewer.getM_objFormDef().getM_objUnloadedVariables().remove(variable);
                }
            }
            catch(Exception ex){
                NGUtil.writeErrorLog(null,IFormConstants.VIEWER_LOGGER_NAME, "Exception in while rendering tab html"+ex.getMessage(),ex);
            }
            String tabhtml=tabSheetObj.getRenderBlock(formviewer.getM_objFormDef(), objIFormSession, objWorkdeskModel).toString();
            //response.setHeader("tabID", tabID);
            //response.setHeader("sheetIndex", sheetIndex);
            //response.setHeader("sheetID", sheetID);
            out.print(tabhtml);
        }
        String setTableCellDataFlag = IFormUtility.escapeHtml4(request.getParameter("setTableCellDataFlag"));
        
        if (setTableCellDataFlag != null && !setTableCellDataFlag.isEmpty() && !"undefined".equalsIgnoreCase(setTableCellDataFlag)) {
            WorkdeskModel wdmodel;//Bug 84470 Start
            String pid = request.getParameter("pid");
            String wid = request.getParameter("wid");
            String tid = IFormUtility.getIFormTaskId(request);
            WDWorkitems wisessionbean = (WDWorkitems) request.getSession().getAttribute("wDWorkitems");
            LinkedHashMap workitemMap = wisessionbean.getWorkItems();
            if (tid == null || tid.isEmpty()) {
                wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
            } else {
                wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
            }//Bug 84470 End
            boolean isMobileMode=false;
            isMobileMode=("ios".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode())||"android".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode()))?true:false;
            String tableId = IFormUtility.escapeHtml4(request.getParameter("tableId"));
            boolean isMulti = false;
            if (request.getParameter("multi") != null) {
               isMulti = "Y".equals(IFormUtility.escapeHtml4(request.getParameter("multi")));
            }   
                if (!isMulti) {
                        String rowIndex = IFormUtility.escapeHtml4(request.getParameter("rowIndex"));
                        String colIndex = IFormUtility.escapeHtml4(request.getParameter("colIndex"));
                        String cellData = request.getParameter("cellData");
                        EControl objControl = (EControl) IFormUtility.getFormField(tableId, formviewer);
                        ETableControl objTable = (ETableControl) objControl;
                        if (objTable.getM_objControlStyle().isM_bAdvancedListview()) {//Bug 84470
                            IFormUtility.setAdvancedGridTableCellValue(objTable, Integer.parseInt(rowIndex), Integer.parseInt(colIndex), cellData, formviewer, wdmodel, request);//Bug 84470
                        }//Bug 84470
                        else {
                            List<List<String>> objModel = objTable.getObj_eTableModal().getM_TableData();
                            List<String> lsdata = objModel.get(Integer.parseInt(rowIndex));
                            String dateFormat = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat();
                            String dateSeparator = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator();

                            if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 7 || Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 9) {

                                String ds = "", df = "";
                                if (dateSeparator.equalsIgnoreCase("1")) {
                                    ds = "/";
                                } else if (dateSeparator.equalsIgnoreCase("2")) {
                                    ds = "-";
                                } else if (dateSeparator.equalsIgnoreCase("3")) {
                                    ds = ".";
                                }
                                if (dateFormat.equalsIgnoreCase("1")) {
                                    df = "dd" + ds + "MM" + ds + "yyyy";
                                }
                                if (dateFormat.equalsIgnoreCase("2")) {
                                    df = "MM" + ds + "dd" + ds + "yyyy";
                                }
                                if (dateFormat.equalsIgnoreCase("3")) {
                                    df = "yyyy" + ds + "MM" + ds + "dd";
                                }
                                if (dateFormat.equalsIgnoreCase("4")) {
                                    df = "dd" + ds + "MMM" + ds + "yyyy";
                                }

                                String strDBFormat = "yyyy-MM-dd HH:mm:ss";
                                Date date = null;
                                try {
                                    //String strDateFormat = "dd/MMM/yyyy";
                                    String strDateFormat = df;
                                    if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 9) {
                                        strDateFormat = strDateFormat + " HH:mm:ss";
                                    }
                                    if (isMobileMode) {
                                        strDateFormat = "yyyy-MM-dd";
                                        if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 9) {
                                            strDateFormat += "'T'HH:mm";
                                        }
                                    }

                                    date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(cellData);
                                } catch (Exception ex) {
                                }
                                if (date == null) {
                                    cellData = "";
                                } else {
                                    cellData = new SimpleDateFormat(strDBFormat).format(date);
                                }
                                objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
                                if (EControlHelper.getHTML(objTable, "PickerType").equalsIgnoreCase("2") && "2".equals(objTable.getM_objControlStyle().getM_strTimeZone())) {
                                    if (objIFormSession != null) {
                                        int iMinutes = objIFormSession.getM_iClientTimeDiff() - objIFormSession.getM_iServerTimeDiff();
                                        //                   boolean isMobileMode = ("ios".equalsIgnoreCase(objIFormSession.getM_objFormViewer().getM_objFormDef().getM_strMobileMode()) || "android".equalsIgnoreCase(objIFormSession.getM_objFormViewer().getM_objFormDef().getM_strMobileMode())) ? true : false;
                                        if (!cellData.isEmpty() && iMinutes != 0) {
                                            cellData = IFormUtility.addMinutesToDate(cellData, iMinutes, "yyyy-MM-dd", isMobileMode);
                                        }
                                    }
                                }
                            }

                            lsdata.set(Integer.parseInt(colIndex), cellData);
                            WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable, wdmodel, request);//Bug 85361
                            ArrayList attribList = (ArrayList) wiAttr.getAttribValue();
                            IFormUtility.setAdvancedListviewRowModifyFlag(objTable, request, "Y");
                            //Bug 81231 Start
                            int k = 0, l = 0;
                            WiAttribHashMap attriSubMap = null;
                            WorkdeskAttribute attribute1 = null;
                            while (k < Integer.parseInt(rowIndex) + 1) {
                                attriSubMap = (WiAttribHashMap) attribList.get(l + 1);
                                attribute1 = (WorkdeskAttribute) attriSubMap.get("<INS_ORDER_ID>");
                                if (attribute1.getInsertionOrderId() >= 0) {
                                    k++;
                                }
                                l++;
                            }
                            WiAttribHashMap attribMap = (WiAttribHashMap) attribList.get(l);
                            //Bug 81231 End
                            String valueArray[] = objTable.getM_strDataClassName().toString().split("\\.");
                            String dataClassName = "";
                            for (int i = 0; i < valueArray.length; i++) {
                                if (i == 0) {
                                    dataClassName = dataClassName + valueArray[i];
                                } else {
                                    dataClassName = dataClassName + "-" + valueArray[i];
                                }
                            }
                            WorkdeskAttribute attribute = (WorkdeskAttribute) attribMap.get(dataClassName + "-" + objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
                            if (attribute != null) {   //Bug 89369
                                wiAttr.setModifiedFlag("Y");
                                attribute.setUnbounded("N");
                                attribute.setModifiedFlag("Y");
                                attribute.setSimpleName(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
                                attribute.setValue(cellData);
                            }
                        }
                    } else {
                         String multipleData = IFormUtility.escapeHtml4(URLDecoder.decode(request.getParameter("multipleData"), "UTF-8"));
                         org.json.simple.parser.JSONParser jSONParser = new org.json.simple.parser.JSONParser();
                         org.json.simple.JSONArray jsonArray = (org.json.simple.JSONArray) jSONParser.parse(multipleData);
                         for (int i = 0; i < jsonArray.size(); i++) {
                                 org.json.simple.JSONObject rowJSONObj = (org.json.simple.JSONObject) jsonArray.get(i);
                                 String rowIndex = (String) rowJSONObj.get("rowIndex");
                                 String colIndex = (String) rowJSONObj.get("colIndex");
                                 String cellData = (String) rowJSONObj.get("cellData");
                                 EControl objControl = (EControl) IFormUtility.getFormField(tableId, formviewer);
                                 ETableControl objTable = (ETableControl) objControl;
                                 if (objTable.getM_objControlStyle().isM_bAdvancedListview()) {//Bug 84470
                                     IFormUtility.setAdvancedGridTableCellValue(objTable, Integer.parseInt(rowIndex), Integer.parseInt(colIndex), cellData, formviewer, wdmodel, request);//Bug 84470
                                 }//Bug 84470
                                 else {
                                     List<List<String>> objModel = objTable.getObj_eTableModal().getM_TableData();
                                     List<String> lsdata = objModel.get(Integer.parseInt(rowIndex));
                                     String dateFormat = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat();
                                     String dateSeparator = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator();

                                     if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 7 || Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 9) {

                                         String ds = "", df = "";
                                         if (dateSeparator.equalsIgnoreCase("1")) {
                                             ds = "/";
                                         } else if (dateSeparator.equalsIgnoreCase("2")) {
                                             ds = "-";
                                         } else if (dateSeparator.equalsIgnoreCase("3")) {
                                             ds = ".";
                                         }
                                         if (dateFormat.equalsIgnoreCase("1")) {
                                             df = "dd" + ds + "MM" + ds + "yyyy";
                                         }
                                         if (dateFormat.equalsIgnoreCase("2")) {
                                             df = "MM" + ds + "dd" + ds + "yyyy";
                                         }
                                         if (dateFormat.equalsIgnoreCase("3")) {
                                             df = "yyyy" + ds + "MM" + ds + "dd";
                                         }
                                         if (dateFormat.equalsIgnoreCase("4")) {
                                             df = "dd" + ds + "MMM" + ds + "yyyy";
                                         }

                                         String strDBFormat = "yyyy-MM-dd HH:mm:ss";
                                         Date date = null;
                                         try {
                                             //String strDateFormat = "dd/MMM/yyyy";
                                             String strDateFormat = df;
                                             if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 9) {
                                                 strDateFormat = strDateFormat + " HH:mm:ss";
                                             }
                                             if (isMobileMode) {
                                                 strDateFormat = "yyyy-MM-dd";
                                                 if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 9) {
                                                     strDateFormat += "'T'HH:mm";
                                                 }
                                             }

                                             date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(cellData);
                                         } catch (Exception ex) {
                                         }
                                         if (date == null) {
                                             cellData = "";
                                         } else {
                                             cellData = new SimpleDateFormat(strDBFormat).format(date);
                                         }
                                         objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
                                         if (EControlHelper.getHTML(objTable, "PickerType").equalsIgnoreCase("2") && "2".equals(objTable.getM_objControlStyle().getM_strTimeZone())) {
                                             if (objIFormSession != null) {
                                                 int iMinutes = objIFormSession.getM_iClientTimeDiff() - objIFormSession.getM_iServerTimeDiff();
                                                 //                   boolean isMobileMode = ("ios".equalsIgnoreCase(objIFormSession.getM_objFormViewer().getM_objFormDef().getM_strMobileMode()) || "android".equalsIgnoreCase(objIFormSession.getM_objFormViewer().getM_objFormDef().getM_strMobileMode())) ? true : false;
                                                 if (!cellData.isEmpty() && iMinutes != 0) {
                                                     cellData = IFormUtility.addMinutesToDate(cellData, iMinutes, "yyyy-MM-dd", isMobileMode);
                                                 }
                                             }
                                         }
                                     }

                                     lsdata.set(Integer.parseInt(colIndex), cellData);
                                     WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable, wdmodel, request);//Bug 85361
                                     ArrayList attribList = (ArrayList) wiAttr.getAttribValue();
                                     IFormUtility.setAdvancedListviewRowModifyFlag(objTable, request, "Y");
                                     //Bug 81231 Start
                                     int k = 0, l = 0;
                                     WiAttribHashMap attriSubMap = null;
                                     WorkdeskAttribute attribute1 = null;
                                     while (k < Integer.parseInt(rowIndex) + 1) {
                                         attriSubMap = (WiAttribHashMap) attribList.get(l + 1);
                                         attribute1 = (WorkdeskAttribute) attriSubMap.get("<INS_ORDER_ID>");
                                         if (attribute1.getInsertionOrderId() >= 0) {
                                             k++;
                                         }
                                         l++;
                                     }
                                     WiAttribHashMap attribMap = (WiAttribHashMap) attribList.get(l);
                                     //Bug 81231 End
                                     String valueArray[] = objTable.getM_strDataClassName().toString().split("\\.");
                                     String dataClassName = "";
                                     for (int q = 0; q < valueArray.length; q++) {
                                         if (q == 0) {
                                             dataClassName = dataClassName + valueArray[q];
                                         } else {
                                             dataClassName = dataClassName + "-" + valueArray[q];
                                         }
                                     }
                                     WorkdeskAttribute attribute = (WorkdeskAttribute) attribMap.get(dataClassName + "-" + objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
                                     if (attribute != null) {   //Bug 89369
                                         wiAttr.setModifiedFlag("Y");
                                         attribute.setUnbounded("N");
                                         attribute.setModifiedFlag("Y");
                                         attribute.setSimpleName(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
                                         attribute.setValue(cellData);
                                     }
                                 }
                             }
                         
                    }
                
         //response.setHeader("tableId", tableId);
             //response.setHeader("rowIndices", rowIndex);
             //response.setHeader("colIndices", colIndex);
             //response.setHeader("celldatas", cellData);
       }
        
        
       String addDataGridFlag = IFormUtility.escapeHtml4(request.getParameter("addgriddata"));
       if ("yes".equalsIgnoreCase(addDataGridFlag)) {
               String tableId = IFormUtility.escapeHtml4(request.getParameter("tableId"));
               WorkdeskModel wdmodel=null;
               String pid = request.getParameter("pid");
               String wid = request.getParameter("wid");
               String tid = IFormUtility.getIFormTaskId(request);
               String fid = objIFormSession.getFid();
               WDWorkitems wisessionbean = (WDWorkitems) request.getSession().getAttribute("wDWorkitems");
               if(wisessionbean!=null){
               LinkedHashMap workitemMap = wisessionbean.getWorkItems();
               if (tid == null || tid.isEmpty()) {
                   wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
               } else {
                   wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
               }
              }

               org.json.simple.parser.JSONParser jSONParser = new org.json.simple.parser.JSONParser();
               org.json.simple.JSONArray jsonData = (org.json.simple.JSONArray) jSONParser.parse(new StringReader(request.getParameter("jsonData").toString()));
               String responseHTML = IFormUtility.addDataToGrid(tableId, jsonData, formviewer, objIFormSession, wdmodel, request,response);
               //response.setHeader("tableId", tableId);
               out.print(responseHTML);
           }
       if(IFormUtility.escapeHtml4(request.getParameter("executeFormLoadEvent"))!=null){
           String pid = IFormUtility.escapeHtml4(request.getParameter("pid"));
            String wid =  IFormUtility.escapeHtml4(request.getParameter("wid"));
            String tid =   IFormUtility.getIFormTaskId(request);
            String isListViewControl = "NO";
            WorkdeskModel wdmodel=null;
            WDWorkitems wisessionbean= (WDWorkitems) request.getSession().getAttribute("wDWorkitems");            
            if(wisessionbean!=null){
            LinkedHashMap workitemMap = wisessionbean.getWorkItems();
            if (tid == null || tid.isEmpty()) {
            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
            } else {
            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
            }
            }
           String type=IFormUtility.escapeHtml4(request.getParameter("type"));
           JSONObject jsonData=new JSONObject();
           IFormEventInfo eventInfo=null;
           if("1".equals(type)){
                if( ((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo() != null && (!((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().isEmpty()) ){
                    if(((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(0)!=null){
                        eventInfo=((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(0);
                    }
                }
            }
           else if("2".equals(type)||"3".equals(type)||"4".equals(type)){

                EControl control=(EControl)IFormUtility.getFormField(IFormUtility.escapeHtml4(request.getParameter("FormLoadEventControlId")),formviewer);//Bug 84017
                for(int i=0;i<control.getM_objControlEvent().getM_arrIFormEventInfo().size();i++){
                    if(control.getM_objControlEvent().getM_arrIFormEventInfo().get(i).getM_strEventType().equals(IFormConstants.EVENT_TYPE_LOAD)){
                        eventInfo=control.getM_objControlEvent().getM_arrIFormEventInfo().get(i);
                    }
                }
            }
           else if( "5".equals(type)){
                if( ((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo() != null && (!((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().isEmpty()) ){
                    if(((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(1)!=null){
                        eventInfo=((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(1);
                    }
                }
           }
           else if("6".equals(type)){
                if( ((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo() != null && (!((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().isEmpty()) ){
                    if(((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(2)!=null){
                        eventInfo=((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(2);
                    }
                }
           }
           else if("7".equals(type)){
                if( ((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo() != null && (!((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().isEmpty()) ){
                    if(((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(0)!=null){
                        eventInfo=((EControl)m_objFormDef.getM_objRootControl()).getM_objControlEvent().getM_arrIFormEventInfo().get(0);
                    }
                }
           }
           if(eventInfo!=null){
                String customAction=eventInfo.getM_strCustomActionString();
                jsonData.put("customAction", customAction);
                JSONArray dbLinkingArray=new JSONArray();
                List<List<String>> lsData=new ArrayList<List<String>>();
                JSONArray dbLinkingListViewArray = new JSONArray();
                for(int i=0;i<eventInfo.getM_arrDBLinkingInfo().size();i++){
                    String query=eventInfo.getM_arrDBLinkingInfo().get(i).getM_strQuery();
                    String controls=eventInfo.getM_arrDBLinkingInfo().get(i).getM_strControls();
                    boolean isCaching=eventInfo.getM_arrDBLinkingInfo().get(i).isM_bCaching();
                    if(isCaching){
                        lsData=DatabaseUtil.getCachedData(query, objIFormSession);
                    }
                    else{
                        lsData=DatabaseUtil.getDataFromDataSource(query, objIFormSession);
                    }
                    String[] controlArray=controls.split(",");
                    for(int t=0;t<controlArray.length;t++){
                        EControl control=(EControl)IFormUtility.getFormField(controlArray[t],formviewer);
                        if(control!=null){
                            String a = control.getM_strControlType();
                            if(control.getM_strControlType().equals(IFormConstants.ETYPE_LISTVIEW) || control.getM_strControlType().equals(IFormConstants.ETYPE_TABLE)){
                                    try{
                                         String fid = objIFormSession.getFid();
                                         String tableControlId = control.getControlId();
                                         if(control.getM_objControlStyle().getM_strCustomControlId()!=null && !control.getM_objControlStyle().getM_strCustomControlId().equals(""))
                                             tableControlId = control.getM_objControlStyle().getM_strCustomControlId();
                                         IFormReference iFormReference = AppTasks.getAPIHandler(request, response, fid);
                                         objIFormSession.setObjFormReference(iFormReference);
                                         ((IFormAPIHandler)objIFormSession.getObjFormReference()).getAPIList().clear();
                                         ArrayList<ColumnInfo> columninfo = ((ETableControl)control).getObj_eTableModal().getM_arrColumnInfo();
                                         org.json.simple.JSONArray jsonArray = IFormAPI.constructJSONArray(lsData, columninfo);
                                         ((IFormAPIHandler)objIFormSession.getObjFormReference()).addDataToGrid(tableControlId, jsonArray);
                                         org.json.simple.JSONArray addJSONArray = ((IFormAPIHandler)objIFormSession.getObjFormReference()).getAPIList(); 
                                         dbLinkingListViewArray.add(addJSONArray.get(0));
                                         isListViewControl = "YES";
                                    } catch (Exception ex){
                                        NGUtil.writeErrorLog(null,IFormConstants.VIEWER_LOGGER_NAME, "Exception in ListView" + ex.getMessage() , ex);
                                      }
                            }
                            else if(!control.getM_strControlType().equals(IFormConstants.ETYPE_COMBO)){
                                try{
                                    String value =  lsData.get(0).get(t);
                                     if(control.getM_strControlType().equals(IFormConstants.ETYPE_DATEPICK)){
                                        String df = IFormUtility.getDateFormat(m_objFormDef, control);
                                        value = IFormUtility.dateLocaltoDb(value, df, "/",request);
                                     }
                                     IFormUtility.setControlValue(control, value, control.getM_strDataClassName(), wdmodel, m_objFormDef, objIFormSession, request);
                                     control.setM_strControlValue(value);
                                }
                                catch(Exception ex){
                                    control.setM_strControlValue("");
                                }
                            }
                        }
                    }
                    if(isListViewControl.equals("NO")){
                        JSONObject obj=new JSONObject();
                        obj.put("controls",controls);
                        obj.put("data",IFormAPI.constructJSON(lsData));
                        dbLinkingArray.add(obj);
                    }
                }
                if(isListViewControl.equals("YES")){
                   // dbLinkingResObj.put("DbLinkingListView",dbLinkingListViewArray);
                    jsonData.put("DbLinkingListView",dbLinkingListViewArray);
                    //out.print(jsonData);
                   // response.setStatus(200);
                }
                if(isListViewControl.equals("NO")){
                    jsonData.put("dbLinking",dbLinkingArray);
                }
            }
//           if(isListViewControl.equals("NO")){
//               out.print(jsonData);
//           }
           if(jsonData != null && jsonData.size()>0)
           {
                out.print(jsonData);
                response.setStatus(200);
           }
       }
       
       String addAdvancedGridData = request.getParameter("addAdvancedGridData");
       if(addAdvancedGridData!=null && "yes".equals(addAdvancedGridData)){
           String tableId = IFormUtility.escapeHtml4(request.getParameter("tableId"));
           WorkdeskModel wdmodel;//Bug 84471 Start
           String pid = request.getParameter("pid");
            String wid = request.getParameter("wid");
            String tid = IFormUtility.getIFormTaskId(request);
            String fid = objIFormSession.getFid();
           WDWorkitems wisessionbean = (WDWorkitems) request.getSession().getAttribute("wDWorkitems");
        LinkedHashMap workitemMap = wisessionbean.getWorkItems();
        if (tid == null || tid.isEmpty()) {
            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
        } else {
            wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
        }//Bug 84471 End
           
           org.json.simple.parser.JSONParser jSONParser = new org.json.simple.parser.JSONParser();
           org.json.simple.JSONArray jsonData =  (org.json.simple.JSONArray)jSONParser.parse(new StringReader(request.getParameter("jsonData").toString()));
           String responseHTML = IFormUtility.addDataToAdvancedGrid(tableId, jsonData, formviewer, objIFormSession,wdmodel,request,response);//Bug 84471
            //response.setHeader("tableId", tableId);
           out.print(responseHTML);
       }
       String fetchCollapsedFrameHTML = request.getParameter("fetchCollapsedFrameHTML");
           if (fetchCollapsedFrameHTML != null && "yes".equals(fetchCollapsedFrameHTML)) {
                   String listviewId = request.getParameter("listviewId");
                   WorkdeskModel wdmodel = null;
                   String pid = request.getParameter("pid");
                   String wid = request.getParameter("wid");
                   String tid = IFormUtility.getIFormTaskId(request);
                   WDWorkitems wisessionbean = (WDWorkitems) request.getSession().getAttribute("wDWorkitems");
                   if (wisessionbean != null) {
                       LinkedHashMap workitemMap = wisessionbean.getWorkItems();
                       if (tid == null || tid.isEmpty()) {
                           wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                       } else {
                           wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                       }


                   }
                   String fetchedJSON = "";
                   if (listviewId != null) {
                           fetchedJSON = IFormUtility.fetchCollapsedFrameHTMLForGrid(listviewId, wdmodel, request, formviewer);
                       } else {
                           fetchedJSON = IFormUtility.fetchCollapsedFrameHTML(wdmodel, request, formviewer);
                       }
                       out.print(fetchedJSON);
               }
       String checkValidationOnStep = request.getParameter("checkValidationOnStep");
        if (checkValidationOnStep != null) {
                   WorkdeskModel wdmodel = IFormUtility.getWDModel(request);
                   out.print(IFormUtility.isFieldMandatoryOnStep(wdmodel, request, formviewer));
               }
        
       String loadFragment=request.getParameter("loadFragment");
       if (loadFragment != null && "Y".equals(loadFragment)) {
               if (objIFormSession != null) {
                       String applicationNo = objIFormSession.getM_strApplicationNo();
                       if (applicationNo != null) {
                           response.setHeader("transactionId", applicationNo);
                       }
                   }
               WorkdeskModel wdmodel = IFormUtility.getWDModel(request);
               boolean isValid=Boolean.FALSE;
               String navigationClick=IFormUtility.escapeHtml4(request.getParameter("navigationClick"));
               if(!"2".equals(navigationClick))
                    isValid = IFormUtility.isFieldMandatoryOnStep(wdmodel, request, formviewer);
               String mainMenuIndex = IFormUtility.escapeHtml4(request.getParameter("parentIndex"));
               String childMenuIndex = IFormUtility.escapeHtml4(request.getParameter("childIndex"));
               objIFormSession.setM_strStage(mainMenuIndex);
               objIFormSession.setM_strSubStage(childMenuIndex);
               List<Menu> menuList = new ArrayList();
               if (formviewer.getM_objFormDef().isChangeList()) {
                   menuList = formviewer.getM_objFormDef().getObjChangeList();
               } else {
                   menuList = formviewer.getM_objFormDef().getM_objNav().getObjMenuList();
               }
               if (!isValid) {
                   if (childMenuIndex == null) {
                       objIFormSession.setM_strSubStage("0");
                       if (Integer.parseInt(mainMenuIndex) == 0) {
                           response.setHeader("FirstStep", "Y");
                       }
                       IFormFragInfo fragmentObj = null;
                       if ((menuList.size() - 1) == Integer.parseInt(mainMenuIndex)) {
                           response.setHeader("LastStep", "Y");
                       }
                       Menu objmenu = menuList.get(Integer.parseInt(mainMenuIndex));
                       if (objmenu.getM_objSubMenuList().isEmpty()) {
                           fragmentObj = objmenu.getObjFragment();
                       } else {
                           fragmentObj = objmenu.getM_objSubMenuList().get(0).getObjFragment();
                           if (objmenu.getM_objSubMenuList().size() > 1)//Bug 88795
                           {
                               response.setHeader("LastStep", "N");
                           }
                       }
                       String pid = request.getParameter("pid");
                       String wid = request.getParameter("wid");
                       IFormReference objFormReference = new IFormAPIHandler(request, response, "Form_" + pid + "_" + wid);
                       IFormContext iFormContextObj = new IFormContext();
                       IFormServerEventHandler objCustomCodeInstance = iFormContextObj.getInstance(objFormReference);
                       if (objCustomCodeInstance != null && objCustomCodeInstance instanceof IFormCustomHooks) {
                           IFormCustomHooks hookObject = (IFormCustomHooks) objCustomCodeInstance;
                           boolean isValidWidget = hookObject.validateWidget(objFormReference, fragmentObj.getM_strFragname());
                           if (isValidWidget) {
                               boolean isPreview = "Y".equals(request.getSession().getAttribute("IsPreview"));
                               if (isPreview) {
                                   IFormUtility.populateFragmentBuffer(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                               } else {
                                   CommonUtility.populateFormDefForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                               }
                               CommonUtility.populateModelForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                               wdmodel = IFormUtility.getWDModel(request);
                               if (formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objNavigationStyle().getM_strControlStyle().equals("Style2")) {
                                   out.print(CommonUtility.fetchAndPopulateFragmentData(formviewer.getM_objFormDef(), menuList.get(Integer.parseInt(mainMenuIndex)).getObjFragment(), wdmodel, objIFormSession));
                               } else {
                                   out.print(CommonUtility.populateMainMenuData(formviewer.getM_objFormDef(), wdmodel, objIFormSession, menuList, Integer.parseInt(mainMenuIndex)));
                               }
                           } else {
                               out.print(isValidWidget);
                           }
                       }else{
                            boolean isPreview = "Y".equals(request.getSession().getAttribute("IsPreview"));
                            if (isPreview) {
                                IFormUtility.populateFragmentBuffer(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                            } else {
                                CommonUtility.populateFormDefForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                            }
                            CommonUtility.populateModelForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                            wdmodel = IFormUtility.getWDModel(request);
                            if (formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objNavigationStyle().getM_strControlStyle().equals("Style2")) {
                                out.print(CommonUtility.fetchAndPopulateFragmentData(formviewer.getM_objFormDef(), menuList.get(Integer.parseInt(mainMenuIndex)).getObjFragment(), wdmodel, objIFormSession));
                            } else {
                                out.print(CommonUtility.populateMainMenuData(formviewer.getM_objFormDef(), wdmodel, objIFormSession, menuList, Integer.parseInt(mainMenuIndex)));
                            }
                       }
                   }
                else {
                   if (Integer.parseInt(mainMenuIndex) == 0 && Integer.parseInt(childMenuIndex) == 0) {
                       response.setHeader("FirstStep", "Y");
                   }
                   IFormFragInfo fragmentObj = menuList.get(Integer.parseInt(mainMenuIndex)).getM_objSubMenuList().get(Integer.parseInt(childMenuIndex)).getObjFragment();
                   if ((menuList.size() - 1) == Integer.parseInt(mainMenuIndex) && ((menuList.get(Integer.parseInt(mainMenuIndex)).getM_objSubMenuList().size() - 1) == Integer.parseInt(childMenuIndex))) {
                       response.setHeader("LastStep", "Y");
                   }
                   String pid = request.getParameter("pid");
                   String wid = request.getParameter("wid");

                   IFormReference objFormReference = new IFormAPIHandler(request, response, "Form_" + pid + "_" + wid);
                   IFormContext iFormContextObj = new IFormContext();
                   IFormServerEventHandler objCustomCodeInstance = iFormContextObj.getInstance(objFormReference);
                   if (objCustomCodeInstance != null && objCustomCodeInstance instanceof IFormCustomHooks) {
                       IFormCustomHooks hookObject = (IFormCustomHooks) objCustomCodeInstance;
                       boolean isValidWidget = hookObject.validateWidget(objFormReference, fragmentObj.getM_strFragname());
                       if (isValidWidget) {
                           boolean isPreview = "Y".equals(request.getSession().getAttribute("IsPreview"));
                           if (isPreview) {
                               IFormUtility.populateFragmentBuffer(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                           } else {
                               CommonUtility.populateFormDefForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                           }
                           CommonUtility.populateModelForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                           //String fragmentName=menuList.get(Integer.parseInt(mainMenuIndex)).getM_objSubMenuList().get(Integer.parseInt(childMenuIndex)).getObjFragment().getM_strFragname();
                           wdmodel = IFormUtility.getWDModel(request);
                           out.print(CommonUtility.fetchAndPopulateFragmentData(formviewer.getM_objFormDef(), fragmentObj, wdmodel, objIFormSession));
                       } else {
                           out.print(isValidWidget);
                       }
                   }else{
                        boolean isPreview = "Y".equals(request.getSession().getAttribute("IsPreview"));
                        if (isPreview) {
                           IFormUtility.populateFragmentBuffer(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                        } else {
                            CommonUtility.populateFormDefForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                        }
                        CommonUtility.populateModelForFragment(request, formviewer.getM_objFormDef(), fragmentObj, objIFormSession);
                        //String fragmentName=menuList.get(Integer.parseInt(mainMenuIndex)).getM_objSubMenuList().get(Integer.parseInt(childMenuIndex)).getObjFragment().getM_strFragname();
                        wdmodel = IFormUtility.getWDModel(request);
                        out.print(CommonUtility.fetchAndPopulateFragmentData(formviewer.getM_objFormDef(), fragmentObj, wdmodel, objIFormSession));
                   }
               }
             }
           }
       String createMenu=request.getParameter("createMenu");
       if(createMenu!=null && "Y".equals(createMenu) && formviewer.getM_objFormDef().isM_bNavigationAdded()){
           StringBuilder html = IFormUtility.createMenuHtml(formviewer.getM_objFormDef());
         out.print(html);
       }
     }
   
%>
