
<%@page import="com.newgen.iforms.validation.IFormValidation"%>
<%@page import="com.newgen.iforms.integration.FormEntity"%>
<%@page import="com.newgen.iforms.integration.EntityAttribute"%>
<%@page import="com.newgen.iforms.util.CommonUtility"%>
<%@page import="com.newgen.iforms.integration.DataObjectInterface"%>
<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : newjsp
    Created on : Dec 21, 2015, 1:28:28 PM
    Author     : rohit_kumar
01/02/2018                                    Bug 75601
08/02/2018                                    Bug 75603 - EAP6.4+SQL: if Comboitem is lengthy in table, provide tool tip to see the complete value of cell in table 
28/02/2018       Minakshi Sharma              Bug 75125 - Table > No validation message when user tries to input incorrect data in any cell
11/03/2018       Aman Khan                    Bug 75909 - Allow null, Formats, Column Total & Tool tip features are not available in column of Table
11/03/2018     Aman Khan                      Bug 75697 - Performance Issue: Unnecessary exception regarding iform/ngf form should not be printed in server.log
11/03/2018     Aman Khan                      Bug 75523 - No provision to configure duplicate value of column in table like ngf Form
20/03/2018      Gaurav Sharma                 Bug 75603 - EAP6.4+SQL: if Comboitem is lengthy in table, provide tool tip to see the complete value of cell in table
21/03/2018      Gaurav Sharma                 Bug 76652 - EAP6.4+SQL: Checkboxes get distorted and calendar is trimmed if opened from first three-four rows of table
22/03/2018      Gaurav Sharma                 batching is not working proper in F3 Getpicklist event since given  batchsize 2, but only one item is showing in one batch
26/03/2018      Gaurav Sharma                 Bug 76740 - EAP6.4+SQL: Checkbox and radio button inside table remains same irrespective of style selected for both
26/03/2018      Gaurav Sharma                 Bug 76730 - EAP6.4+SQL: Issues related to Input tab of theme
27/03/2018           Aman Khan                Bug 76719 - EAP6.4+SQL: Theme color is not getting applied to date picker icon inside tabel
26/04/2018      Aman Khan                     Bug 77364 - Listview and Table controls total for "Date" and "Date & Time" fields are not calculated correctly .
30/04/2018      Gaurav Sharma                 Bug 77363 - For Listview and Table controls combo controls list not shown properly
18/05/2018      Minakshi Sharma               Bug 76692 - Performance issue in loading the iform if huge data in table & listview
31/05/2018      Gaurav                        Bug 78172 - JbossEAP7+postgres+iphone5s:-Under Listview control for "Date and Time" column calendar not shown properly due to this unable to select date and time.
06/07/2018      Aman Khan                     Bug 78853 - IForm:Under listview control lablel link url not working
10/07/2018      Aman Khan                     Bug 78860 - IForm:Listview,listbox and table controls entries are not saved
30/10/2018      Gaurav Sharma                 Bug 81096 - need function calling capability on link in listview
09/11/2018      Aman Khan                     Bug 80327 - User is able to add duplicate values in the field for which the allow duplicate checkbox is not selected in case of List view
16/11/2018      Gaurav                        Bug 81361 - precision not working properly on float fields
26/11/2018      Abhishek Chaudhary            Bug 81573 - Data Added in Grid is not in proper style.
30/11/2018      Aman Khan                     Bug 80327 - User is able to add duplicate values in the field for which the allow duplicate checkbox is not selected in case of List view
03/12/2018      Minakshi Sharma               Bug 81616 - Android || iOS :- Under Listview and Picklist window searching on All columns and columns not working.
04/12/2018      Aman Khan                     Bug 81577 - iOS :- Combo control UI not shown properly ,icon should be shown for select value from the list 
05/12/2018      Minakshi Sharma               Bug 81746 - JbossEAP7.0+Postgres+OD9.1SP2+iBPS3.0 SP2: batching is not working in Table of iForm  
05/12/2018      Aman Khan                     Bug 80809 - Android device:- Under Table control ,click on lable link url 2nd window open after that unable to return on existing form
05/12/2018      Aman Khan                     Bug 81579 - iOS:- Selected date not shown properly (hidden )
06/12/2018		Minakshi Sharma				  Bug 81828 - Issue in Search functionality in ListView IForms	
15/12/2018      Aman Khan                     Bug 81946 - Under Listview and Table controls wrong show total shown for float variable
16/12/2018      Aman Khan                     Bug 81934 - Arabic:- Wrong data shown on added row under Advance Listview
17/12/2018      Gaurav                        Bug 81586 on picklist window batching not working
01/04/2018      Abhishek                      Bug 82333 - Issue in displaying special characters in Table and ListView in IForms
25/01/2019      Aman Khan                     Bug 82662 - checkboxes for selecting the row hides when we hide delete and add button
01/02/2019      Aman Khan                     Bug 82834 - In iForm, List-view while clicking on checkbox some other checkbox is selected in the list-view, whenever new lines are added into existing rows
14/02/2019      Gaurav                        Bug 83107 - Issue in select row in picklist with double click
21/02/2019      Gaurav                        Bug 83234 - Data not getting set using server side adddatatogrid api if the control type is label
21/02/2019      Abhishek                      Bug 83244 - alignment of table entries
28/02/2019      Gaurav                        Bug 83339 - addDatatogrid Api data now showing properly in grid
06/03/2019      Gaurav                        Bug 83424 - Provide API to add,remove and clear Combo in table Cell
01/03/2019      Abhishek                      Bug 83363 - cell data being cut off.
11/03/2019      Aman Khan                     Bug 83508 - we are using getValueFromTableCell() function to get the value of the cell but data is coming without space
12/03/2019      Abhishek                      Bug 83572 - Restriction of multiSelect in grid 
13/03/2019      Aman Khan                     Bug 83576 - We are in need of provision for digit grouping in list view controls with precision of 2 decimal points
15/03/2019      Gaurav                        Bug 83662 - Unable to Add data into the Advance list view when the advancedgrid have one parent queue variable
25/03/2019      Gaurav                        Bug 83731 - Issue in fetching grid data in case of Listbox
25/03/2019      Gaurav                        Bug 83738 - issue in saving of advanced listview
25/03/2019      Abhishek                      Bug 83733 - masking option for datetime and date picker
25/03/2019      Abhishek                      Bug 83732 - filling date without opening date picker
29/03/2019      Gaurav                        Bug 83861 - Save changes is not working in advanced list view
05/04/2019      Gaurav                        Bug 84041 - The date value not showing in grid while adding row in advnaced listview in mobile
19/04/2019      Gaurav                        Bug 84281 - After Batching, table values not fetched properly
24/04/2019      Rohit Kumar                   Bug 84333 - Need visible Hyperlink on all fields of a column
06/05/2019      Gaurav                        Bug 84494 - total not working in table due to issue with tooltipster
22/05/2019      Abhishek                      Bug 84832 - Not able to set default of a dropdown inside grid.
22/05/2019      Gaurav                        Bug 84849 - picklist window taking almost 2 mins to load
20/06/2019      Gaurav                        Bug 85361 - data not saving in table when task is opened with case form
18/06/2019      Aman Khan                     Bug 85317 - SecureContent not working in the listview inside an advanced listview
19/06/2019      Aman Khan                     Bug 85322 - While adding a entry in list view, with a dropdown field with yes or no value it is not able to add the field instead Select is added to the the table.
19/06/2019      Rohit Kumar                   Bug 85341 - Vietnamese character not working for Picklist in iform
27/06/2019      Aman Khan                     Bug 85456 - Multiple RTE are saved with the same data in a listview
03/07/2019      Gaurav                        Bug 85496 - Entries inside grid changes after saving of workitem
23/07/2019      Aman Khan                     Bug 85706 - Issue in grid batching
30/07/2019      Gaurav                        Bug 85784 - Need server API to delete rows in grid
07/08/2019      Aman Khan                     Bug 85857 - Link and img clicks not getting disabled if table is disabled from the designer.
10/09/2019      Aman Khan                     Bug 86443 - Auto Increment functionality not working on Batching (Table and Listview Control)
12/09/2018      Aman Khan                     Bug 86568 - Searching not working on full table but in batches
03/12/2019      Abhishek                      Bug 88846 - Previous and Next icon of batching gets enabled on searching in grid.
08/01/2020      Aman Khan                     Bug 89827 - Need confirmation to save added rows before seaarching when the batching is not enabled
31/01/2020      Abhishek                      Bug 90464 - hidden picklist column not hiding
31/01/2020      Aman Khan                     Bug 90468 - Need to show label on listview combobox instead of value
12/02/2020      Aman Khan                     Bug 90659 - Not able to add rows in table
14/02/2020      Aman Khan                     Bug 90715 - Require sorting in each batch of table data
09/03/2020      Aman Khan                     Bug 91238 - Picklist data UI is distorted
01/04/2020      Rohit Kumar                   Bug 91541 - List view row is not updating after modifying data in over lay with multiline text
02/04/2020      Aman Khan                     Bug 91555 - User is able to delete rows from a disable table when securecontent is Y
21/04/2020      Aman Khan                     Bug 91887 - Searching notworking in an unmapped listview
23/06/2020      Aman Khan                     Bug 92940 - Grid Combo label is not working in case of execute DB linking
27/01/2020      Aman Khan                     Bug 97479 - In case of Table when we put value with & operator in DB its getting saved after conversion i.e, &
24/06/2021      Minakshi Sharma               Bug 99468 - iBPS 5.0 SP2 +jboss-eap-7.3 + OD 10.1 Patch 4 + JDK 1.8.0_281:-After Sorting data inside Advanced ListView, Data is not getting displayed.  
--%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%@page import="com.newgen.iforms.custom.IFormCustomHooks"%>
<%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
<%@page import="com.newgen.iforms.controls.EComboControl"%>
<%@page import="com.newgen.iforms.util.CustomEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.text.ParseException"%>
<%@page import="com.rits.cloning.Cloner"%>
<%@page import="com.newgen.iforms.custom.IFormContext"%>
<%@page import="com.newgen.iforms.custom.IFormAPIHandler"%>
<%@page import="com.newgen.iforms.custom.IFormReference"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="com.newgen.iforms.controls.EButtonControl"%>
<%@page import="com.newgen.iforms.controls.ERootControl"%>
<%@page import="com.newgen.iforms.controls.util.EControlHelper"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.iforms.controls.EFrameControl"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.db.DatabaseUtil"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="com.newgen.iforms.EControlOption"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WorkdeskAttribute"%>
<%@page import="com.newgen.mvcbeans.model.WiAttribHashMap"%>
<%@page import="com.newgen.iforms.ETableModal"%>
<%@page import="com.newgen.iforms.designer.ColumnInfo"%>
<%@page import="com.newgen.iforms.controls.ETableControl"%>
<%@page import="com.newgen.iforms.controls.ETextControl"%>
<%@page import="com.newgen.iforms.controls.ETextAreaControl"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.newgen.iforms.custom.IFormServerEventHandler"%>
<%@page import="com.newgen.iforms.EControl"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.newgen.iforms.viewer.IFormHandler"%>


<%
    request.setCharacterEncoding("UTF-8");
    String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
    String rid_ActionAPI = IFormUtility.generateTokens(request,request.getRequestURI());
    response.setHeader("WD_RID", rid_ActionAPI);
    IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
    String controlId = IFormUtility.escapeHtml4(request.getParameter("controlId"));
    String from = IFormUtility.escapeHtml4(request.getParameter("from"));
    String tableData = request.getParameter("tabledata");
    String modifyFlag = IFormUtility.escapeHtml4(request.getParameter("modifyFlag"));
    String deleteFlag = IFormUtility.escapeHtml4(request.getParameter("deleteFlag"));
    String tableAction=IFormUtility.escapeHtml4(request.getParameter("Action"));
    String saveCurrentBatch=IFormUtility.escapeHtml4(request.getParameter("SaveCurrentBatch"));
    boolean SaveCurrentBatchInGrid=(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SAVE_CURRENT_BATCH_IN_GRID) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SAVE_CURRENT_BATCH_IN_GRID)) || IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SAVE_CURRENT_BATCH_IN_GRID)==null);
    String clearAdvancedListviewMap=IFormUtility.escapeHtml4(request.getParameter("clearListviewMap"));
    List<List<String>> dbResult = null;
    List headerList = null;
    String dateFormat =  formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateFormat();
    String dateSeparator = formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateSeparator();
    String dateStyleTime="";
    String dateStyle="";
    String checkboxStyle=formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strControlStyleCheckbox();
    String radioStyle=formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strControlStyleRadio();
    String isImagePath = "";
    if(IFormUtility.escapeHtml4(request.getParameter("getImagePath"))!=null){
        isImagePath = IFormUtility.escapeHtml4(request.getParameter("getImagePath"));
    }
    if("Y".equals(isImagePath))
        IFormUtility.getImagePath(request, response);
        
    if(formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objInputFormStyle().getM_strDateStyle().equalsIgnoreCase("1")){
        dateStyleTime="mydatetimepicker";
        dateStyle="mydatepicker";
    }
    else{
        dateStyleTime="myjquerydatetimepicker";
        dateStyle="myjquerydatepicker";
    }
    EControl objControl = new EControl();
    if (from != null && !"serverEvent".equals(from)) {
        IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
            objControl = (EControl) IFormUtility.getFormField(controlId,formviewer); 
        //int batchSize = objControl.getM_objControlStyle().getM_batchSize();
        int batchSize = objControl.getM_objPicklist().getM_iBatchSize();
        int batchCounter = objControl.getM_objPicklist().getM_iBatchCounter();
        if(objControl.getM_objPicklist().isM_bCustomPicklist()){
            if("next".equals(from)){
                try{
                    IFormServerEventHandler objCustomCodeInstance = objIFormSession.getObjServerEventHandler();
                    IFormReference objFormReference=objIFormSession.getObjFormReference();
                    if( objCustomCodeInstance != null &&objCustomCodeInstance instanceof IFormCustomHooks){
                        IFormCustomHooks hookObject=(IFormCustomHooks)objCustomCodeInstance;
                        hookObject.picklistNextClickHook(controlId, objFormReference);
                        objControl.getM_objPicklist().fetchPicklistDatafromDB();
                    }
                }
                catch(Exception ex){
                    NGUtil.writeErrorLog(objIFormSession.getM_strCabinetName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in in picklistNextClickHook :controlID="+controlId+"..."+ex.getMessage(),ex);
                }
            }
            else if("previous".equals(from)){
                try{
                    IFormServerEventHandler objCustomCodeInstance = objIFormSession.getObjServerEventHandler();
                    IFormReference objFormReference=objIFormSession.getObjFormReference();
                    if( objCustomCodeInstance != null &&objCustomCodeInstance instanceof IFormCustomHooks){
                        IFormCustomHooks hookObject=(IFormCustomHooks)objCustomCodeInstance;
                        hookObject.picklistPreviousClickHook(controlId, objFormReference);
                        objControl.getM_objPicklist().fetchPicklistDatafromDB();
                    }
                }
                catch(Exception ex){
                    NGUtil.writeErrorLog(objIFormSession.getM_strCabinetName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in in picklistNextClickHook :controlID="+controlId+"..."+ex.getMessage(),ex);
                }
            }
            else if("search".equals(from)){
                try{
                    IFormServerEventHandler objCustomCodeInstance = objIFormSession.getObjServerEventHandler();
                    IFormReference objFormReference=objIFormSession.getObjFormReference();
                    if( objCustomCodeInstance != null &&objCustomCodeInstance instanceof IFormCustomHooks){
                        IFormCustomHooks hookObject=(IFormCustomHooks)objCustomCodeInstance;
                        String columnName=request.getParameter("columnName");
                        int colIndex=-1;
                        headerList = objControl.getM_objPicklist().getHeaderList();
                        if("---".equals(columnName))
                            colIndex=-1;
                        else{
                            for(int columnIndex=0;columnIndex<headerList.size();columnIndex++){
                                if(headerList.get(columnIndex).equals(columnName)){
                                    colIndex=columnIndex;
                                    break;
                                }
                            }
                        }
                        objControl.getM_objPicklist().setM_iLastSearchedColIndex(colIndex);
                        hookObject.picklistSearchHook(controlId, objFormReference,request.getParameter("searchString"),colIndex);
                        objControl.getM_objPicklist().fetchPicklistDatafromDB();
                    }
                }
                catch(Exception ex){
                    NGUtil.writeErrorLog(objIFormSession.getM_strCabinetName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in in picklistNextClickHook :controlID="+controlId+"..."+ex.getMessage(),ex);
                }
            }
        }
        String searchString=request.getParameter("searchString");
        if(from!=null&&"search".equals(from)){
            objControl.getM_objPicklist().setM_strLastSearchedData(searchString);
        }
        else{
            searchString=objControl.getM_objPicklist().getM_strLastSearchedData();
        }
        
        IFormServerEventHandler objCustomCodeInstance = objIFormSession.getObjServerEventHandler();
        IFormReference objFormReference = objIFormSession.getObjFormReference();
        IFormCustomHooks hookObject = null;
        HashMap<String, List> customResultMap = null;
        if( objCustomCodeInstance != null &&objCustomCodeInstance instanceof IFormCustomHooks){
            hookObject = (IFormCustomHooks)objCustomCodeInstance;
        }
        
        if(!objControl.getM_objPicklist().isM_bCustomPicklist()){    
            if(hookObject != null)
            {
                customResultMap = hookObject.populateDataFromCustom(controlId, objFormReference);
                if(customResultMap != null && !customResultMap.isEmpty())
                {
                    dbResult = customResultMap.get("dataList");
                    headerList = customResultMap.get("headerList");
                } else {
                    headerList = objControl.getM_objPicklist().getHeaderList();
                    dbResult= objControl.getM_objPicklist().getPickListDataCopy();
                }
            } else {
                headerList = objControl.getM_objPicklist().getHeaderList();
                dbResult= objControl.getM_objPicklist().getPickListDataCopy();
            }
            
            //dbResult = objControl.getM_objPicklist().getPickListData();
            int sizeOfList = 0;
            if (dbResult != null) {
                sizeOfList = dbResult.size();
            }
            List<List<String>> filteredData=dbResult;
            int startIndex = 0;
            int endIndex = 0;
            
            if(searchString!=null&&sizeOfList!=0&&!searchString.isEmpty()){
                int colSize=headerList.size();
                String columnName=IFormUtility.escapeHtml4(request.getParameter("columnName"));
                boolean isLks = "Y".equals(IFormUtility.escapeHtml4(request.getParameter("lks")));
                boolean likeSearch = true;
				int starPostionChecker = -1;
                if(isLks){
                    if(searchString.startsWith("*") && searchString.endsWith("*") && searchString.length() > 2 ){
                        searchString = searchString.substring(1, searchString.length() - 1);
                    }
                    else if(searchString.endsWith("*") && searchString.length() > 1) {
                        searchString = searchString.substring(0, searchString.length() - 1);
						starPostionChecker = 1;
                    } else if(searchString.startsWith("*") && searchString.length() > 1) {
                        searchString = searchString.substring(1);
						starPostionChecker = 2;
                    } else {
                        likeSearch = false;
                    }
                }
                boolean isAllColumn=true;
                if(!"---".equals(columnName))
                    isAllColumn=false;
                int columnIndex;
                for(columnIndex=0;columnIndex<headerList.size();columnIndex++){
                    if(headerList.get(columnIndex).equals(columnName))
                        break;
                }
                boolean rowAdded=false;
                for(int i=0;i<sizeOfList;i++){
                    rowAdded=false;
                    if(isAllColumn){
                        for(int j=0;j<colSize;j++){
                            if(filteredData.get(i).get(j)!=null){
                                if(likeSearch){
                                                                    if(starPostionChecker == -1){
                                      if(filteredData.get(i).get(j).toUpperCase().contains(searchString.toUpperCase())){
                                        rowAdded=true;
                                        break;
                                      }
                                                                    }
                                    else if(starPostionChecker == 1){
                                        if(filteredData.get(i).get(j).toUpperCase(objIFormSession.getObjLocale()).startsWith(searchString.toUpperCase(objIFormSession.getObjLocale()))){
                                        rowAdded=true;
                                        break;
                                      }
                                    }
                                    else{
                                        if(filteredData.get(i).get(j).toUpperCase(objIFormSession.getObjLocale()).endsWith(searchString.toUpperCase(objIFormSession.getObjLocale()))){
                                        rowAdded=true;
                                        break;
                                      }
                                    } 								
                                }
                                else{
                                    if(filteredData.get(i).get(j).toUpperCase(objIFormSession.getObjLocale()).equals(searchString.toUpperCase(objIFormSession.getObjLocale()))){
                                        rowAdded=true;
                                        break;
                                    }
                                }
                            }    
                        }
                    }
                    else{
                        if(filteredData.get(i).get(columnIndex)!=null){
                            if(likeSearch){
                                                            if(starPostionChecker == -1){
                                  if(filteredData.get(i).get(columnIndex).toUpperCase().contains(searchString.toUpperCase())){
                                    rowAdded=true;
                                  }
                                                            }
                                                            else if(starPostionChecker == 1){
                                  if(filteredData.get(i).get(columnIndex).toUpperCase(objIFormSession.getObjLocale()).startsWith(searchString.toUpperCase(objIFormSession.getObjLocale()))){
                                    rowAdded=true;
                                  }
                                }
                                else{
                                  if(filteredData.get(i).get(columnIndex).toUpperCase(objIFormSession.getObjLocale()).endsWith(searchString.toUpperCase(objIFormSession.getObjLocale()))){
                                    rowAdded=true;
                                  }
                                }
                            }
                            else{
                                if(filteredData.get(i).get(columnIndex).toUpperCase(objIFormSession.getObjLocale()).equals(searchString.toUpperCase(objIFormSession.getObjLocale()))){
                                    rowAdded=true;
                                }
                            }
                        }    
                    }
                    if(!rowAdded){
                        filteredData.remove(i);
                        i--;
                        sizeOfList--;
                    }
                }
            }
                sizeOfList=filteredData.size();

                if (from != null && "next".equals(from)) {
                    response.setHeader("Previous", "true");
                    if ((sizeOfList - batchCounter) > batchSize) {
                        response.setHeader("Next", "true");

                        startIndex = batchCounter;
                        endIndex = startIndex + batchSize;
                    } else {
                        startIndex = batchCounter;
                        endIndex = sizeOfList;
                        response.setHeader("Next", "false");
                    }
                    objControl.getM_objPicklist().setM_iBatchCounter(batchCounter + batchSize);
                }

                if (from != null && "previous".equals(from)) {
                    response.setHeader("Next", "true");
                    if (batchCounter - batchSize == batchSize) {
                        response.setHeader("Previous", "false");
                    } else {
                        response.setHeader("Previous", "true");
                    }
                    endIndex = batchCounter - batchSize;
                    startIndex = endIndex - batchSize;
                    objControl.getM_objPicklist().setM_iBatchCounter(endIndex);

                }
                if(from!=null&&"search".equals(from)){
                    batchCounter=0;
                    response.setHeader("Previous", "false");
                    if ((sizeOfList - batchCounter) > batchSize) {
                        response.setHeader("Next", "true");
                        startIndex = batchCounter;
                        endIndex = startIndex + batchSize;
                    } else {
                        startIndex = batchCounter;
                        endIndex = sizeOfList;
                        response.setHeader("Next", "false");
                    }
                    objControl.getM_objPicklist().setM_iBatchCounter(endIndex);
                }

                dbResult = filteredData.subList(startIndex, endIndex);
            }
            else{
                if(hookObject != null)
                {
                    customResultMap = hookObject.populateDataFromCustom(controlId, objFormReference);
                    if(customResultMap != null && !customResultMap.isEmpty())
                    {
                        dbResult = customResultMap.get("dataList");
                        headerList = customResultMap.get("headerList");
                    } else {
                        dbResult= objControl.getM_objPicklist().getPickListDataCopy();
                        headerList = objControl.getM_objPicklist().getHeaderList();
                    }
                } else {
                    dbResult= objControl.getM_objPicklist().getPickListDataCopy();
                    headerList = objControl.getM_objPicklist().getHeaderList();
                }
                response.setHeader("Previous", Boolean.toString(objControl.getM_objPicklist().isM_bEnablePrevious()));
                response.setHeader("Next", Boolean.toString(objControl.getM_objPicklist().isM_bEnableNext()));
            }
    }

    if (from != null && "serverEvent".equals(from)) {
        String pid = (String) IFormUtility.escapeHtml4(request.getParameter("pid"));
        String wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
        String tid = IFormUtility.getIFormTaskId(request);

        WorkdeskModel wdmodel = null;
        try {
            WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
            if (wisessionbean != null) {
                LinkedHashMap workitemMap = wisessionbean.getWorkItems();
                if (tid == null || tid.isEmpty()) {
                    wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                } else {
                    wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                }
            }
        } catch (Exception e) {
          
        }
        String eventType = IFormUtility.escapeHtml4(request.getParameter("EventType"));
        IFormReference objFormReference = new IFormAPIHandler(request,response,null);
        JSONArray jsonArray = null;
        IFormContext iFormContextObj = new IFormContext();
        IFormServerEventHandler objCustomCodeInstance = iFormContextObj.getInstance(objFormReference);
        if( objCustomCodeInstance != null )        
        {    
            jsonArray = objCustomCodeInstance.executeEvent(formviewer.getM_objFormDef(), objFormReference, controlId, eventType);
            out.println(jsonArray);
        }
    }
%>

<% if (from != null && !"serverEvent".equals(from)) {%>

        <%
            IFormCustomHooks hookObject=null;
            HashMap<String, Integer> pickListWidthMap = new HashMap<String, Integer>();
            IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
            IFormServerEventHandler objCustomCodeInstance = objIFormSession.getObjServerEventHandler();
            if (objCustomCodeInstance != null && objCustomCodeInstance instanceof IFormCustomHooks) {
                hookObject = (IFormCustomHooks) objCustomCodeInstance;
                pickListWidthMap = hookObject.getPickListWidth(controlId);
            }
            String cellStyle = (pickListWidthMap != null && pickListWidthMap.size() > 0) ? "" : "white-space:pre-wrap;word-break:break-all;";
            String mapSize = "0";
            if(pickListWidthMap!=null)
            {
                mapSize=String.valueOf(pickListWidthMap.size());
            }
            response.setHeader("pickListWidthMapSize",mapSize);
            for (List<String> rowData : dbResult) {
				int colCount=0;
        %> 
        <tr onclick="selectRow(this)" ondblclick="setRowValue(this)">
            <%
                      for (String colData : rowData) 
		      {
			     String disp = "HiddenPicklistColumn".equalsIgnoreCase(String.valueOf(headerList.get(colCount++))) ? "display:none;" : "display:table-cell;" ;
            %>
            <td class="labelStyle " style="<%=IFormUtility.forHtmlAttribute(disp)%> font-weight: normal;<%=IFormUtility.forHtmlAttribute(cellStyle)%>"><%= IFormUtility.forHtmlAttribute(colData)%></td>
                    <%}%>
        </tr>
        <% }%>
<%} else if (("yes").equals(tableData)) {
    WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);
     ResourceBundle genRSB = ResourceBundle.getBundle("ifgen", formviewer.getM_objFormDef().getObjLocale());
     boolean isRemoveMargins = false;
     if(formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objSectionFormStyle().isM_bRemoveMargins())
         isRemoveMargins = true;
     String selectDateBackground = "background:inherit;";
     String selectDateBorder = "border:0px;";
     String dateLineHeight = "";
     String dateTextAlign = "text-align:center;";
     if (formviewer.getM_objFormDef().getM_strMobileMode().equalsIgnoreCase("ios")) {
             selectDateBackground = "";
             selectDateBorder = "";
             dateLineHeight="line-height:normal";
             dateTextAlign="";
         }
    boolean isDisabled=false;
    if(IFormUtility.escapeHtml4(request.getParameter("isDisabled"))!=null&&"true".equalsIgnoreCase(IFormUtility.escapeHtml4(request.getParameter("isDisabled"))))
        isDisabled=true;
        
    boolean isShowGridComboLabel = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL)));
    boolean isMobileMode=false;
    boolean isStyle2="style2".equalsIgnoreCase(formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objTableStyle().getM_strControlStyle());
    isMobileMode=("ios".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode())||"android".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode()))?true:false;
    JSONParser parser = new JSONParser();
    JSONObject json=new JSONObject();
    if(request.getParameter("dataValue")!=null)
        json = (JSONObject) parser.parse(request.getParameter("dataValue"));
    
    objControl = (EControl) IFormUtility.getFormField(controlId,formviewer);
     
    ETableControl objTable = (ETableControl) objControl;
    int rowId = objTable.getCurrentRowID(); //Bug 82834
    IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request)); 
    String rowIndex = String.valueOf(objTable.getObj_eTableModal().getM_TableData().size()+1);
    /*
    String sessionKey = IFormUtility.getIFormSessionUID(request)+ controlId;
    if( request.getSession(false).getAttribute(sessionKey) != null ){
        Cloner objcloner = new Cloner();
        List<List<String>> objDupList = (List<List<String>>)objcloner.deepClone((List<List<String>>)request.getSession(false).getAttribute(sessionKey));
        objTable.getObj_eTableModal().setM_TableData(objDupList);
        request.getSession(false).removeAttribute(sessionKey);
    }
    */

    List<ColumnInfo> lsCols = objTable.getObj_eTableModal().getM_arrColumnInfo();
    List<List<String>> listViewData = new ArrayList();
    List<String> row = new ArrayList<String>();
    //WiAttribHashMap wiAttribMap = new WiAttribHashMap();
    WiAttribHashMap wiAttribMap= null;
    Cloner objCloner = new Cloner();
    WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);
    if (wiAttr!=null)
       wiAttribMap=(WiAttribHashMap)objCloner.deepClone(((ArrayList)wiAttr.getAttribValue()).get(0));//Bug 85361
    else{
        wiAttribMap = new WiAttribHashMap();        
    }
    String valueArray[] = objTable.getM_strDataClassName().toString().split("\\.");
    String dataClassName = "";
    for (int i = 0; i < valueArray.length; i++) {
        if (i == 0) {
            dataClassName = dataClassName + valueArray[i];
        } else {
            dataClassName = dataClassName + "-" + valueArray[i];
        }
    }
     String dgroupColumns="";
     String maskedColumns = "";
         String maskedLabels = "";         
       String masking="";
       String placeholder="";  
       int insertId = 0;
      if(!objTable.getM_objControlStyle().isM_bAdvancedListview()){
           List<String> visibleRowData = new ArrayList<String>();
        for (int i = 0; i < lsCols.size(); i++) {
            
            masking="";placeholder="";
            if(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strTextformat()!=""){
                String dgroupFormat = objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strTextformat();
                String dgroupColumn = i +"_"+dgroupFormat;
                dgroupColumns +=dgroupColumn+",";
            } 

            if(!objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strMaskingValue().equalsIgnoreCase("nomasking")){
                String maskValue = objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strMaskingValue();
                String maskColumn = i +"_"+maskValue;
                maskedColumns +=maskColumn+",";
            }

            String columnName=objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnName();
            WorkdeskAttribute wdAttr = new WorkdeskAttribute();
            wdAttr.setValue("");
            String value="";
            wdAttr.setStrDateFormat(dateFormat);
            try{
                if(request.getParameter("dataValue")!=null)
                    value=json.get(columnName).toString().equalsIgnoreCase("")?"" : json.get(columnName).toString();

            if(!objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW) && Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField())==8)
            {
                for (EControlOption control : objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getComboOptions().getM_arrOptions())
                {
                    if(control.isM_default())
                    {
                        value=control.getM_strOptionValue();
                        break;
                    }
                }
            }    
            if(!objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW) && Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField())==10)
            {
                for (EControlOption control : objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getComboOptions().getM_arrOptions())
                {
                    if(control.isM_default())
                    {
                        value=control.getM_strOptionValue();
                        break;
                    }
                }
            }
                 EControl tempColumnControl=null;//Bug 85496
                 if (objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW)){
                        tempColumnControl=(EControl)IFormUtility.getNormalListviewControl(objTable, columnName);//Bug 85496
                        
                            if (isShowGridComboLabel && !( "L".equals(tempColumnControl.getM_objControlStyle().getM_strSaveValueType()) ) && tempColumnControl.getM_strControlType().equalsIgnoreCase(IFormConstants.ETYPE_COMBO)) {
                                String dbQuery = objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getComboOptions().getM_strQuery();
                                    
                                if (!"".equals(dbQuery)) {
                                    value = IFormUtility.getComboLabelForValue(null, null, value, dbQuery, objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getComboOptions().isM_bisCaching(), objIFormSession,wdmodel);
                                } else {
                                    value = IFormUtility.getComboLabelForValue(tempColumnControl, objTable.getObj_eTableModal().getM_arrColumnInfo().get(i), value, dbQuery, objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getComboOptions().isM_bisCaching(), objIFormSession,wdmodel);
                                }
                            }
                        if(tempColumnControl.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_TEXTAREA)
                        && ((ETextAreaControl) tempColumnControl).getM_objControlStyle().getM_strRichTextEditor().equalsIgnoreCase("2")) {
                            value = ((ETextAreaControl) tempColumnControl).getM_strControlValue();//Bug 85496
                        }
                       }
               
            }
            catch(Exception e){}

            if("Y".equalsIgnoreCase(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strInsertionOrderId())){
                value = String.valueOf(AppTasks.getUniqueRowId());
                insertId = Integer.parseInt(value);
            }
            visibleRowData.add(value);
            if((Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField())==7||Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField())==9) && !lsCols.get(i).getM_strMappedFieldType().equalsIgnoreCase("Text")){
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
        String strDateFormat = df;
        Date date = null;
            try {
                //String strDateFormat = "dd/MMM/yyyy";
                
                if(Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField()) == 9)
                    strDateFormat=strDateFormat+" HH:mm:ss";
                if(isMobileMode){
                    strDateFormat="yyyy-MM-dd";
                    if(Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField()) == 9)
                        strDateFormat+="'T'HH:mm";
                }
                date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(json.get(columnName).toString());
            } catch (Exception ex) {
                //System.out.println(ex);
    //                               NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in method IFormHandler:updateAttributeValue()..."+ex.getMessage(),ex); 
            }
            if(date==null)
                value = "";
            else
                value = new SimpleDateFormat(strDBFormat).format(date);
            
            if (EControlHelper.getHTML(objTable, "PickerType").equalsIgnoreCase("2") && "2".equals(objTable.getM_objControlStyle().getM_strTimeZone())) {
                if (objIFormSession != null) {
                    int iMinutes = objIFormSession.getM_iClientTimeDiff() - objIFormSession.getM_iServerTimeDiff();
                    if (!value.isEmpty() && iMinutes != 0) {
                        value = IFormUtility.addMinutesToDate(value, iMinutes, strDateFormat,isMobileMode);
                    }
                }
            }
                    }

            if(!objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW) && Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField())==8)
            {
                for (EControlOption control : objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getComboOptions().getM_arrOptions())
                {
                    if(control.isM_default())
                    {
                        value=control.getM_strOptionValue();
                        break;
                    }
                }
            }
            if(!objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW) && Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strColumnMappedField())==10)
            {
                for (EControlOption control : objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getComboOptions().getM_arrOptions())
                {
                    if(control.isM_default())
                    {
                        value=control.getM_strOptionValue();
                        break;
                    }
                }
            }
                
            if(json.get(columnName)!=null && json.get(columnName).toString().equalsIgnoreCase("")){
                row.add( json.get(columnName).toString());
            }
            else{
                row.add(value);
                }
            if ("".equals(lsCols.get(i).getM_strMappedField())) {
                continue;
            }
            //wiAttribMap.put(dataClassName + "-" + lsCols.get(i).getM_strMappedField(), wdAttr);
            if(wiAttribMap.isEmpty() || wiAttribMap.get(dataClassName + "-" + lsCols.get(i).getM_strMappedField())==null) {
               wdAttr.setType("321");            
               wdAttr.setVarType(lsCols.get(i).getM_strMappedFieldType());
               wdAttr.setUnbounded("N");
               wiAttribMap.put(dataClassName + "-" + lsCols.get(i).getM_strMappedField(), wdAttr); 
            }else
               wdAttr=(WorkdeskAttribute)wiAttribMap.get(dataClassName + "-" + lsCols.get(i).getM_strMappedField());
            //wdAttr.setType("321");            
            //wdAttr.setVarType(lsCols.get(i).getM_strMappedFieldType());
            //wdAttr.setUnbounded("N");
            wdAttr.setModifiedFlag("Y");
            EControl controlRef = null;
            if(objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW) && (!objTable.getM_arrColumFrameLayoutList().isEmpty()) ){
                controlRef = (EControl)IFormUtility.getNormalListviewControl(objTable, columnName);//Bug 85496
            }
            wdAttr.setSimpleName(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strMappedField());
            if (controlRef!=null && controlRef.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_TEXTAREA)
            && ((ETextAreaControl) controlRef).getM_objControlStyle().getM_strRichTextEditor().equalsIgnoreCase("2")) {
                 wdAttr.setValue(IFormUtility.escapeHtml4(controlRef.getM_strControlValue()));
            } else {
                
                String isSecureContent = IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SECURE_CONTENT);
                        if (isSecureContent != null && "Y".equals(isSecureContent)) {
                            if (controlRef != null && "false".equals(controlRef.getM_objControlStyle().getM_strEnable())) {
                                wdAttr.setValue(controlRef.getM_strControlValue());
                            } else {
                                if (controlRef!=null && controlRef.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_COMBO)){ 
                                if (isShowGridComboLabel) {
                                     wdAttr.setM_strLabel(value);
                                     wdAttr.setValue(controlRef.getM_strControlValue());
                                }
                                    else{
                                        wdAttr.setValue(value);
                                    }
                                }
                             else {
                                wdAttr.setValue(value);
                            }
                        }
                        }
                    else {
                        if (controlRef!=null && controlRef.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_COMBO)){ 
                            if (isShowGridComboLabel) {
                                wdAttr.setM_strLabel(value);
                                wdAttr.setValue(controlRef.getM_strControlValue());
                            }
                            else{
                                wdAttr.setValue(value);
                            }
                            
                        } else {
                            wdAttr.setValue(value);
                        }
                               
                    }
                }
        }
           listViewData.add(visibleRowData);
           objTable.getObj_eTableModal().getM_TableData().add(row);
               }
    else{

          //issue with copy row in advanced listview - Start
          boolean copyRowFlag=false;
          if(IFormUtility.escapeHtml4(request.getParameter("copyRowOp"))!=null&&"1".equals(IFormUtility.escapeHtml4(request.getParameter("copyRowOp"))))
              copyRowFlag=true;
          //issue with copy row in advanced listview - End
          WiAttribHashMap advancedListviewWiAttribMap=(WiAttribHashMap)request.getSession().getAttribute(IFormUtility.escapeHtml4(request.getParameter("fid"))+"_AdvancedListviewMap");
          Cloner clone=new Cloner();
          wiAttribMap=clone.deepClone(advancedListviewWiAttribMap);
          //issue with copy row in advanced listview - Start
          if(copyRowFlag){
              IFormUtility.setRowAttributeModifiedFlag(wiAttribMap,"Y");
          }
          //issue with copy row in advanced listview - End
          List<String> visibleRowData = new ArrayList<String>();
          for (int i = 0; i < lsCols.size(); i++) {
              ColumnInfo columnInfo=lsCols.get(i);
              String columnInfoMappedField=columnInfo.getM_strMappedField();
              if("".equals(columnInfoMappedField))
                columnInfoMappedField=columnInfo.getM_strMappedControlField();
                WorkdeskAttribute workdeskAttribute=IFormUtility.getAdvancedListviewRowMemberAttribute(columnInfoMappedField.split("\\."), advancedListviewWiAttribMap);
                String tempValue="";
                if(workdeskAttribute!=null){
                   tempValue=workdeskAttribute.getORGValue();
                }
                String []dtArr = objTable.getM_strDataClassName().toString().split("\\.");
                String tableName = dtArr[dtArr.length-1];
                if( !"".equals(tableName)){
                    DataObjectInterface tableObject  = CommonUtility.getDataObject(objIFormSession.getM_objFormViewer().getM_objFormDef(), tableName);
                    if( tableObject != null ){
                        Set iset = advancedListviewWiAttribMap.keySet();
                        Iterator iter = iset.iterator();
                        while(iter.hasNext()){   
                           String attrnem = String.valueOf(iter.next());
                           WorkdeskAttribute worg=(WorkdeskAttribute)wiAttribMap.get(attrnem);
                           if( worg != null ){    
                               String fieldnem = attrnem.substring(attrnem.lastIndexOf("-")+1);
                               if( ((FormEntity)tableObject).getM_strForeignKey() != null && ((FormEntity)tableObject).getM_strForeignKey().equalsIgnoreCase(fieldnem)){
                                   worg.setValue(objIFormSession.getM_strApplicationNo());
                                   break;
                               }
                           }
                        }                        
                    }
                }
                if("Y".equalsIgnoreCase(objTable.getObj_eTableModal().getM_arrColumnInfo().get(i).getM_strInsertionOrderId())){
                    WorkdeskAttribute insid = (WorkdeskAttribute) wiAttribMap.get("<INS_ORDER_ID>");
                    tempValue =  insid != null ? String.valueOf(insid.getInsertionOrderId()) : String.valueOf(AppTasks.getUniqueRowId());                        
                    insertId = Integer.parseInt(tempValue);
                    WorkdeskAttribute worg=IFormUtility.getAdvancedListviewRowMemberAttribute(columnInfoMappedField.split("\\."), wiAttribMap);             
                    worg.setValue(tempValue);
                }
              EControl tempControl = (EControl) IFormUtility.getFormField(columnInfo.getM_strMappedControlField(),formviewer);
                if(tempControl != null && !tempControl.getM_strControlType().equals(IFormConstants.ETYPE_LISTBOX)){
                                  row.add(tempValue);//Bug 82645
                }
                if(tempControl!=null && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_COMBO)){
                  if (isShowGridComboLabel && !( "L".equals(tempControl.getM_objControlStyle().getM_strSaveValueType()) )) {
                          String dbQuery = tempControl.getM_objControlOptions().getM_strQuery();
                          if (!"".equals(dbQuery)) {
                              tempValue = IFormUtility.getComboLabelForValue(null, null, tempValue, dbQuery, tempControl.getM_objControlOptions().isM_bisCaching(), objIFormSession,wdmodel);
                          } else {
                              tempValue = IFormUtility.getComboLabelForValue(tempControl, null, tempValue, dbQuery, tempControl.getM_objControlOptions().isM_bisCaching(), objIFormSession,wdmodel);
                          }
                      }  
              }  
              if(tempControl != null && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_DATEPICK)){
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
                  String dateFormatTimeZone=df;
                  
                  if("2".equals(tempControl.getM_objControlStyle().getM_strPickerType()))
                      df+=" HH:mm:ss";
                  if(isMobileMode){//Bug 84041 Start
                    df="yyyy-MM-dd";
                    if("2".equals(tempControl.getM_objControlStyle().getM_strPickerType()))
                        df+="'T'HH:mm";
                }//Bug 84041 End
                  String strDateFormat = df;
                  String strDBFormat = "yyyy-MM-dd HH:mm:ss";
                  Date date = null;
                  try {

                        date = new SimpleDateFormat(strDBFormat, Locale.ENGLISH).parse(tempValue);
                    } catch (ParseException ex) {
                        strDBFormat = "yyyy-MM-dd";
                        try
                        {
                            date = new SimpleDateFormat(strDBFormat, Locale.ENGLISH).parse(tempValue);
                        }
                        catch(ParseException pex){
                            try{
                                if(EControlHelper.getHTML(tempControl, "PickerType").equalsIgnoreCase("2"))
                                    date = new SimpleDateFormat(strDateFormat+" HH:mm:ss", Locale.ENGLISH).parse(tempValue);
                                else if(EControlHelper.getHTML(tempControl, "PickerType").equalsIgnoreCase("1"))
                                    date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(tempValue);
                            }
                            catch(ParseException ex1){
                                //NGUtil.writeErrorLog(objWorkdeskModel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in getRenderBlock..."+ex1.getMessage(),ex1); 
                            }
                            //NGUtil.writeErrorLog(objWorkdeskModel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in getRenderBlock..."+pex.getMessage(),pex); 
                        }
                    // NGUtil.writeErrorLog(objWorkdeskModel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in getRenderBlock..."+ex.getMessage(),ex); 
                    }
                  if(date!=null)
                    tempValue = new SimpleDateFormat(df).format(date);
                  
                  if (EControlHelper.getHTML(tempControl, "PickerType").equalsIgnoreCase("2") && tempControl.getM_objControlStyle().isM_bTimeZone()) {
                        if (objIFormSession != null) {
                            int iMinutes = objIFormSession.getM_iClientTimeDiff() - objIFormSession.getM_iServerTimeDiff();
                            if (!tempValue.isEmpty() && iMinutes != 0) {
                                tempValue = IFormUtility.addMinutesToDate(tempValue, iMinutes, dateFormatTimeZone,isMobileMode);
                            }
                        }
                    }
                  
              }else if(tempControl != null && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_LISTBOX)){
                    ArrayList<String> selectedOptions = null;
                    if(workdeskAttribute!=null){
                        selectedOptions = ((ArrayList)workdeskAttribute.getAttribValue());
                    }
                    if (selectedOptions != null && !selectedOptions.isEmpty()) {
                         for (String selectedOption : selectedOptions) {
                             boolean matched=false;//Bug 83731
                            ArrayList<EControlOption> arrControlOptions=((EComboControl)tempControl).getM_objControlOptions().getM_arrOptions();
                            for(EControlOption controlOption :arrControlOptions){
                                if(controlOption.getM_strOptionValue().equals(selectedOption)){
                                    tempValue+=controlOption.getM_strOptionLabel()+",";
                                    matched=true;//Bug 83731
                                    break;
                                }
                            }
                            if(!matched){//Bug 83731
                                tempValue+=selectedOption+",";
                            }
                         }                         
                        tempValue=tempValue.substring(0, tempValue.lastIndexOf(","));
                        
                    }
                    row.add(tempValue);
              }
              visibleRowData.add(tempValue);
}
            listViewData.add(visibleRowData);
            objTable.getObj_eTableModal().getM_TableData().add(row);
    }
    // Insertion Order Id 
    WorkdeskAttribute attribute = (WorkdeskAttribute) wiAttribMap.get("<INS_ORDER_ID>");
    if( attribute == null ){
        attribute = new WorkdeskAttribute("", "321", "0", "N", "", "", "", "", "");
        attribute.setInsertionOrderId(insertId);
        attribute.setStatus(1);
        attribute.setModifiedFlag("Y");
        wiAttribMap.put("<INS_ORDER_ID>", attribute);
    }
    //WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);//Bug 85361
    //wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361

    AppTasks.insertForeignKey(wiAttribMap,objTable,request,response,objIFormSession);

    //String precision="";
    if (wiAttr != null) {
        ((ArrayList) wiAttr.getAttribValue()).add(wiAttribMap);
        IFormUtility.setAdvancedListviewRowModifyFlag(objTable,request,"Y");//Bug 83738
        wiAttr.setModifiedFlag("Y");
       // precision = wiAttr.getPrecision();
    }
    //response.setHeader("TableId", controlId);
    response.setHeader("dgroupColumns", dgroupColumns);
    if(wdmodel!=null && wdmodel.getM_objGeneralData()!=null && !"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()))
        response.setHeader("batchCounter", String.valueOf(objTable.getM_iBatchCounter()));
    //response.setHeader("maskedColumns", maskedColumns);
    
   // int rowId = -1;
   //int numOfRows = objTable.getObj_eTableModal().getM_TableData().size();
   //if(numOfRows>0)
   //rowId = numOfRows-1;
    objTable.setCurrentRowID(objTable.getCurrentRowID()+1);
   %>
    <%=IFormUtility.getGridRowHTML(objTable,listViewData,rowId,formviewer,objIFormSession,null,request)%>
<%  //response.setHeader("maskedLabels",maskedLabels);
    }
 else if (("yes").equals(modifyFlag)) {
    boolean isMobileMode=false;
    isMobileMode=("ios".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode())||"android".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode()))?true:false;
    boolean isShowGridComboLabel =  (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL)));
    IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
    String rowIndex = IFormUtility.escapeHtml4(request.getParameter("rowIndex"));
    String colIndex = IFormUtility.escapeHtml4(request.getParameter("colIndex"));
    String cellData = request.getParameter("cellData");
    String tableId = IFormUtility.escapeHtml4(request.getParameter("controlId"));
    JSONParser parser = new JSONParser();
    JSONObject json=new JSONObject();
    objControl = (EControl) IFormUtility.getFormField(controlId,formviewer);
     
    ETableControl objTable = (ETableControl) objControl;
    boolean isServerSideValidation = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SERVER_VALIDATION)));
    if (!objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW) && isServerSideValidation && !IFormValidation.validateTableControl(request, response, formviewer, IFormUtility.getWorkdeskModel(request))) {
        return;
    }
    /*
    String sessionKey = IFormUtility.getIFormSessionUID(request)+ controlId;
    if( request.getSession(false).getAttribute(sessionKey) != null ){
        Cloner objcloner = new Cloner();
        List<List<String>> objDupList = (List<List<String>>)objcloner.deepClone((List<List<String>>)request.getSession(false).getAttribute(sessionKey));
        objTable.getObj_eTableModal().setM_TableData(objDupList);
        request.getSession(false).removeAttribute(sessionKey);
    }
    */
    
    List<List<String>> objModel = objTable.getObj_eTableModal().getM_TableData();
    List<String> lsdata = objModel.get(Integer.parseInt(rowIndex));
    if(request.getParameter("dataValue")!=null){
        json = (JSONObject) parser.parse(request.getParameter("dataValue"));
    if(!objTable.getM_objControlStyle().isM_bAdvancedListview()){
        for(int tabcell=0;tabcell<objTable.getObj_eTableModal().getM_arrColumnInfo().size();tabcell++){
            String columnName=objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strColumnName();
            if(json.get(columnName)!=null)//Bug 83861 Start
                cellData=json.get(columnName).toString();
            else
                cellData="";//Bug 83861 End
            EControl controlRef = null;
            if(objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW) && (!objTable.getM_arrColumFrameLayoutList().isEmpty()) ){
                controlRef = (EControl)IFormUtility.getNormalListviewControl(objTable, columnName);//Bug 85496
            }
            if (controlRef!=null && controlRef.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_TEXTAREA)
                    && ((ETextAreaControl)controlRef).getM_objControlStyle().getM_strRichTextEditor().equalsIgnoreCase("2")) {
                cellData = controlRef.getM_strControlValue();
            }
            
            if (Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strColumnMappedField()) == 7 || Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strColumnMappedField()) == 9) {

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
        String strDateFormat = df;
        Date date = null;
            try {
                //String strDateFormat = "dd/MMM/yyyy";
                
                if(Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strColumnMappedField()) == 9)
                    strDateFormat=strDateFormat+" HH:mm:ss";
                if(isMobileMode){
                    strDateFormat="yyyy-MM-dd";
                    if(Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strColumnMappedField()) == 9)
                        strDateFormat+="'T'HH:mm";
                }
                date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(cellData);
            } catch (Exception ex) {
            // System.out.println(ex);
    //                               NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in method IFormHandler:updateAttributeValue()..."+ex.getMessage(),ex); 
            }
            if(date==null)
                cellData = "";
            else
                cellData = new SimpleDateFormat(strDBFormat).format(date);
            if (EControlHelper.getHTML(controlRef, "PickerType").equalsIgnoreCase("2") && "2".equals(controlRef.getM_objControlStyle().getM_strTimeZone())) {
                if (objIFormSession != null) {
                    int iMinutes = objIFormSession.getM_iClientTimeDiff() - objIFormSession.getM_iServerTimeDiff();
                    if (!cellData.isEmpty() && iMinutes != 0) {
                        cellData = IFormUtility.addMinutesToDate(cellData, iMinutes, strDateFormat,isMobileMode);
                    }
                }
            }
        // System.out.println(cellData);
        }

        lsdata.set(tabcell, cellData);
        WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);//Bug 85361
        WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
        if(wiAttr!=null){
            
        ArrayList attribList = (ArrayList) wiAttr.getAttribValue();
        IFormUtility.setAdvancedListviewRowModifyFlag(objTable,request,"Y");//Bug 83738
        wiAttr.setModifiedFlag("Y");
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
        String valueArray[] = objTable.getM_strDataClassName().toString().split("\\.");
        String dataClassName = "";
        for (int i = 0; i < valueArray.length; i++) {
            if (i == 0) {
                dataClassName = dataClassName + valueArray[i];
            } else {
                dataClassName = dataClassName + "-" + valueArray[i];
            }
        }
        if("Y".equalsIgnoreCase(objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strInsertionOrderId()) && "".equals(cellData)){
                cellData = String.valueOf(AppTasks.getUniqueRowId());
        }
        WorkdeskAttribute attribute = (WorkdeskAttribute) attribMap.get(dataClassName + "-" + objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strMappedField());
        if(attribute!=null){
            attribute.setUnbounded("N");
            attribute.setModifiedFlag("Y");
            attribute.setSimpleName(objTable.getObj_eTableModal().getM_arrColumnInfo().get(tabcell).getM_strMappedField());
            
           String isSecureContent = IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SECURE_CONTENT);
            

                if (isSecureContent != null && "Y".equals(isSecureContent)) {
                    if (controlRef != null && "false".equals(controlRef.getM_objControlStyle().getM_strEnable())) {
                        attribute.setValue(controlRef.getM_strControlValue());
                    }
                    else{
                        if (controlRef.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_COMBO)){ 
                                if (isShowGridComboLabel) {
                                    attribute.setM_strLabel(cellData);
                                    attribute.setValue(controlRef.getM_strControlValue());
                                }
                                    else{
                                        attribute.setValue(cellData);
                                    }
                                }
                             else {
                                attribute.setValue(cellData);
                            }
                        attribute.setValue(cellData);
                      }
                } else {
                    if (controlRef != null && controlRef.getControlType().equalsIgnoreCase(IFormConstants.ETYPE_COMBO)){ 
                            if (isShowGridComboLabel) {
                                attribute.setM_strLabel(cellData);
                                attribute.setValue(controlRef.getM_strControlValue());
                            }
                            else{
                                attribute.setValue(cellData);
                            }
                            
                        } else {
                            attribute.setValue(cellData);
                        }
                }
                    
        }
            }
        }
    }
    else{
          WiAttribHashMap advancedListviewWiAttribMap=(WiAttribHashMap)request.getSession().getAttribute(IFormUtility.escapeHtml4(request.getParameter("fid"))+"_AdvancedListviewMap");
          WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);//Bug 85361
          WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
          if(wiAttr!=null){
                ArrayList attribList = (ArrayList) wiAttr.getAttribValue();
                Cloner clone=new Cloner();
                Iterator it = advancedListviewWiAttribMap.entrySet().iterator();
                while (it.hasNext()) {
                    Map.Entry pair = (Map.Entry)it.next();
                    WorkdeskAttribute tempWDAttr=(WorkdeskAttribute)pair.getValue();
                    if("Y".equalsIgnoreCase(tempWDAttr.getModifiedFlag())){
                        wiAttr.setModifiedFlag("Y");
                        break;
                    }   
                }
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
                attribList.set(l,clone.deepClone(advancedListviewWiAttribMap));
            }
          JSONObject modifiedDataJson=new JSONObject();
          for (int i = 0; i < objTable.getObj_eTableModal().getM_arrColumnInfo().size(); i++) {
              ColumnInfo columnInfo=objTable.getObj_eTableModal().getM_arrColumnInfo().get(i);
              if("".equals(columnInfo.getM_strMappedControlField()))
                      continue;
              String columnInfoMappedField=columnInfo.getM_strMappedField();
              if("".equals(columnInfoMappedField))
                  columnInfoMappedField=columnInfo.getM_strMappedControlField();
              WorkdeskAttribute workdeskAttribute=IFormUtility.getAdvancedListviewRowMemberAttribute(columnInfoMappedField.split("\\."), advancedListviewWiAttribMap);
                String tempValue="";
                if(workdeskAttribute!=null){
                    tempValue=workdeskAttribute.getORGValue();
                }
              
              lsdata.set(i,tempValue);//Bug 82645
              EControl tempControl = (EControl) IFormUtility.getFormField(columnInfo.getM_strMappedControlField(),formviewer);
                if (tempControl != null && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_COMBO)) {
                        if (isShowGridComboLabel && !( "L".equals(tempControl.getM_objControlStyle().getM_strSaveValueType()))) {
                           String dbQuery = tempControl.getM_objControlOptions().getM_strQuery();
                                if(!"".equals(dbQuery)){
                                    tempValue=IFormUtility.getComboLabelForValue(null,null,tempValue,dbQuery,tempControl.getM_objControlOptions().isM_bisCaching(),objIFormSession,wdmodel);
                                }
                                else{
                                        tempValue=IFormUtility.getComboLabelForValue(tempControl,null,tempValue,dbQuery,tempControl.getM_objControlOptions().isM_bisCaching(),objIFormSession,wdmodel);
                                 }
                        }
                    } 
              if(tempControl != null && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_DATEPICK)){
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
                  String dateFormatTimeZone=df;
                  
                  if("2".equals(tempControl.getM_objControlStyle().getM_strPickerType()))
                      df+=" HH:mm:ss";
                  
                  String strDateFormat = df;
                  String strDBFormat = "yyyy-MM-dd HH:mm:ss";
                  Date date = null;
                  try {

                        date = new SimpleDateFormat(strDBFormat, Locale.ENGLISH).parse(tempValue);
                    } catch (ParseException ex) {
                        strDBFormat = "yyyy-MM-dd";
                        try
                        {
                            date = new SimpleDateFormat(strDBFormat, Locale.ENGLISH).parse(tempValue);
                        }
                        catch(ParseException pex){
                            try{
                                if(EControlHelper.getHTML(tempControl, "PickerType").equalsIgnoreCase("2"))
                                    date = new SimpleDateFormat(strDateFormat+" HH:mm:ss", Locale.ENGLISH).parse(tempValue);
                                else if(EControlHelper.getHTML(tempControl, "PickerType").equalsIgnoreCase("1"))
                                    date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(tempValue);
                            }
                            catch(ParseException ex1){
                                //NGUtil.writeErrorLog(objWorkdeskModel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in getRenderBlock..."+ex1.getMessage(),ex1); 
                            }
                            //NGUtil.writeErrorLog(objWorkdeskModel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in getRenderBlock..."+pex.getMessage(),pex); 
                        }
                    // NGUtil.writeErrorLog(objWorkdeskModel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in getRenderBlock..."+ex.getMessage(),ex); 
                    }
                  if(date!=null)
                    tempValue = new SimpleDateFormat(df).format(date);
                  if (EControlHelper.getHTML(tempControl, "PickerType").equalsIgnoreCase("2") && tempControl.getM_objControlStyle().isM_bTimeZone()) {
                        if (objIFormSession != null) {
                            int iMinutes = objIFormSession.getM_iClientTimeDiff() - objIFormSession.getM_iServerTimeDiff();
                            if (!tempValue.isEmpty() && iMinutes != 0) {
                                tempValue = IFormUtility.addMinutesToDate(tempValue, iMinutes, dateFormatTimeZone,isMobileMode);
                            }
                        }
                    }                 
              }else if(tempControl != null && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_LISTBOX)){
                    ArrayList<String> selectedOptions = null;
                    if(workdeskAttribute!=null){
                        selectedOptions = ((ArrayList)workdeskAttribute.getAttribValue());
                    }
                    if (selectedOptions != null && !selectedOptions.isEmpty()) {
                         for (String selectedOption : selectedOptions) {
                             boolean matched=false;//Bug 83731
                            ArrayList<EControlOption> arrControlOptions=((EComboControl)tempControl).getM_objControlOptions().getM_arrOptions();
                            for(EControlOption controlOption :arrControlOptions){
                                if(controlOption.getM_strOptionValue().equals(selectedOption)){
                                    tempValue+=controlOption.getM_strOptionLabel()+",";
                                    matched=true;//Bug 83731
                                    break;
                                }
                            }
                            if(!matched){//Bug 83731
                                tempValue+=selectedOption+",";
                            }
                             
                         }                                                              
                        tempValue=tempValue.substring(0, tempValue.lastIndexOf(","));
                        }
                    lsdata.set(i,tempValue);//data not setting in tabledata for listbox
                    
              }
              modifiedDataJson.put(columnInfo.getM_strColumnName(),IFormUtility.encode("UTF-8",tempValue));
            }
          response.setHeader("modifiedRowData", IFormUtility.forJava(IFormUtility.encode("UTF-8",modifiedDataJson.toString())));//Bug 91541
    }
    }
    else
    {
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
                if(isMobileMode){
                    strDateFormat="yyyy-MM-dd";
                    if(Integer.parseInt(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strColumnMappedField()) == 9)
                        strDateFormat+="'T'HH:mm";
                }
                
                date = new SimpleDateFormat(strDateFormat, Locale.ENGLISH).parse(cellData);
            } catch (Exception ex) {
                //System.out.println(ex);
    //                               NGUtil.writeErrorLog(wdmodel.getM_objGeneralData().getM_strEngineName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in method IFormHandler:updateAttributeValue()..."+ex.getMessage(),ex); 
            }
            if(date==null)
                cellData = "";
            else
                cellData = new SimpleDateFormat(strDBFormat).format(date);
    //        System.out.println(cellData);
        }

        lsdata.set(Integer.parseInt(colIndex), cellData);
        WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);//Bug 85361
        WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
        ArrayList attribList = new ArrayList();
        if(wiAttr!=null){
             attribList = (ArrayList) wiAttr.getAttribValue(); 
        }
        IFormUtility.setAdvancedListviewRowModifyFlag(objTable,request,"Y");//Bug 83738
        wiAttr.setModifiedFlag("Y");
        
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
        String valueArray[] = objTable.getM_strDataClassName().toString().split("\\.");
        String dataClassName = "";
        for (int i = 0; i < valueArray.length; i++) {
            if (i == 0) {
                dataClassName = dataClassName + valueArray[i];
            } else {
                dataClassName = dataClassName + "-" + valueArray[i];
            }
        }
        if (attribMap != null) {
                WorkdeskAttribute attribute = (WorkdeskAttribute) attribMap.get(dataClassName + "-" + objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
                if(attribute!=null){    
                    attribute.setUnbounded("N");
                    attribute.setModifiedFlag("Y");
                    attribute.setSimpleName(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strMappedField());
                    String isSecureContent=IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SECURE_CONTENT);
                if (isSecureContent != null && "Y".equals(isSecureContent)) {
                    if (!"false".equals(objTable.getM_objControlStyle().getM_strEnable())) {
                        attribute.setValue(cellData);
                    }
                } else {
                    attribute.setValue(cellData);
                }
                }
            }

    }
    String dgroupColumns="";
    /*if(objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(colIndex)).getM_strTextformat()!=""){
                 String dgroupFormat = objTable.getObj_eTableModal().getM_arrColumnInfo().get(Integer.parseInt(rowIndex)).getM_strTextformat();
                 String dgroupColumn = rowIndex +"_"+dgroupFormat;
                 dgroupColumns +=dgroupColumn+",";
     }*/
    //response.setHeader("TableId", controlId);
    response.setHeader("dgroupColumns", dgroupColumns);
} else if (("yes").equals(deleteFlag)) {
    //String rowIndex= request.getParameter("rowIndex");
    EControl tableRef = (EControl) IFormUtility.getFormField(controlId,formviewer);
    boolean isDelete = false;
    String isSecureContent = IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SECURE_CONTENT);
    if (isSecureContent == null) {
            isDelete = true;
        } else {
            if ("Y".equalsIgnoreCase(isSecureContent)) {
                if ("true".equalsIgnoreCase(tableRef.getM_objControlStyle().getM_strEnable()) || "".equalsIgnoreCase(tableRef.getM_objControlStyle().getM_strEnable())) {
                    isDelete = true;
                }
            } else {
                isDelete = true;
            }
    }
    if(isDelete){
    String rowIndices = IFormUtility.escapeHtml4(request.getParameter("rowIndices"));
    String deleteRowArray[]=rowIndices.split(",");
    
    int[] deletedRowIndexes=new int[deleteRowArray.length];
    
    for(int i=0;i<deletedRowIndexes.length;i++){
        String rowIndex = deleteRowArray[i];
        deletedRowIndexes[i]=Integer.parseInt(rowIndex);
    }
    
    IFormUtility.deleteRowsFromGrid(controlId, deletedRowIndexes, request, formviewer);
    //response.setHeader("tableControlId", controlId);
    
    //response.setHeader("rowIndex",rowIndex );
    //response.setHeader("rowIndices", rowIndices);
    if( formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objTableStyle().getM_bAltRowColor())
         response.setHeader("altrowcolor",  formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objTableStyle().getM_strAltRowColor());
    WorkdeskModel wdmodel = IFormUtility.getWDModel(request);
    EControl tableControl = (EControl) IFormUtility.getFormField(controlId,formviewer);
    ETableControl objTable = (ETableControl) tableControl;
    WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
    int rowId=-1;

    if(wiAttr==null){
        objTable.setCurrentRowID(objTable.getObj_eTableModal().getM_TableData().size());
    }
    else
        objTable.setCurrentRowID(((ArrayList)wiAttr.getAttribValue()).size());
    if(wdmodel!=null && wdmodel.getM_objGeneralData()!=null && !"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()))
         response.setHeader("batchCounter",String.valueOf(objTable.getM_iBatchCounter()));
    %>  


<%
  }  
}else if("yes".equals(clearAdvancedListviewMap)){
    IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
    objIFormSession.setAdvancedListviewRowMap(null);
    session.removeAttribute(IFormUtility.escapeHtml4(request.getParameter("fid"))+"_AdvancedListviewMap");
}
    else if (!("").equals(tableAction)) {
        ResourceBundle genRSB = ResourceBundle.getBundle("ifgen", formviewer.getM_objFormDef().getObjLocale());
     boolean isRemoveMargins = false;
     if(formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objSectionFormStyle().isM_bRemoveMargins())
         isRemoveMargins = true;    
    boolean isMobileMode=false;
    ArrayList rowIndexArr = null;
    boolean isStyle2="style2".equalsIgnoreCase(formviewer.getM_objFormDef().getM_objGlobalFormStyle().getM_objTableStyle().getM_strControlStyle());
    isMobileMode=("ios".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode())||"android".equalsIgnoreCase(formviewer.getM_objFormDef().getM_strMobileMode()))?true:false;
    boolean isDisabled=false;
    if(IFormUtility.escapeHtml4(request.getParameter("isDisabled"))!=null&&"true".equalsIgnoreCase(IFormUtility.escapeHtml4(request.getParameter("isDisabled"))))
        isDisabled=true;
    objControl = (EControl) IFormUtility.getFormField(controlId,formviewer);
    
    ETableControl objTable = null;
    String pid = (String) IFormUtility.escapeHtml4(request.getParameter("pid"));
    String wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
    String tid = IFormUtility.getIFormTaskId(request);
    IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
    WorkdeskModel wdmodel = null;
    String preEnabled="false";
    String nextEnabled="false";
    String dgroupColumns="";
    if(objControl instanceof ETableControl){
        objTable =(ETableControl) objControl;
    try {
        WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
        if (wisessionbean != null) {
            LinkedHashMap workitemMap = wisessionbean.getWorkItems();
            if (tid == null || tid.isEmpty()) {
                wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
            } else {
                wdmodel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
            }
        }   
    
    if("Y".equals(saveCurrentBatch) && SaveCurrentBatchInGrid){         
        IFormHandler iFormHandler = new IFormHandler(request,response,formviewer);
        String code = objTable.saveTableData(wdmodel.getM_objGeneralData(),wdmodel,iFormHandler);
        if( !"0".equals(code)){
            out.println(IFormUtility.forJava(code));
            return;
        }
    }
    int batchingType=0;
    boolean batchEnabled=(!"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()));
    boolean sortingEnabled = false;
    boolean searchingEnabled = false;
    boolean dataRequiredFromDB = true;    
    String valToBeSearch = null;
    String searchCriterion = request.getParameter("SearchCriterion");
    String colIndex = null;
    String filterType = IFormUtility.escapeHtml4(request.getParameter("FilterType"));
    String sortCriterion = IFormUtility.escapeHtml4(request.getParameter("SortCriterion"));
    int batchSize=0;
    WorkdeskAttribute tableAttribute = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);
    if(wdmodel!=null && wdmodel.getM_objGeneralData()!=null && !"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()))
     batchSize= Integer.parseInt(wdmodel.getM_objGeneralData().getNoOfRecordToFetch());
    int batchCounter = objTable.getM_iBatchCounter();
    
    if("NextBatch".equals(tableAction)){
        preEnabled="true";
        batchingType=1;
        if(batchSize>0)
            objTable.setM_iBatchCounter(batchSize+batchCounter);
       }

    else if("PreBatch".equals(tableAction)) {
        nextEnabled="true";
        batchingType=2;
    }
    colIndex = request.getParameter("ColumnIndex");
    if("Sort".equals(filterType)){
        sortingEnabled = true;
        tableAction = filterType;
        colIndex = IFormUtility.escapeHtml4(request.getParameter("ColumnIndex")); 
        if(sortCriterion != null && !"".equals(sortCriterion)) {
            objTable.setM_strCurrentSortingOrder(sortCriterion);
        }
        if(colIndex != null) {
            objTable.setM_iCurrentSortingColumnIndex(Integer.valueOf(colIndex));
        }
        if( !"N".equals(sortCriterion)){
            if (wdmodel==null || tableAttribute==null && (objIFormSession.getM_strApplicationName()==null || objIFormSession.getM_strApplicationName().isEmpty())) {
                    dataRequiredFromDB = false;
                    rowIndexArr = objTable.filterData(filterType, objTable.getM_strCurrentSortingOrder(), searchCriterion, colIndex);
            } /*else {
                objTable.executeBatchXMLFromMDM(objIFormSession, wdmodel.getM_objGeneralData(), wdmodel, batchingType, sortingEnabled, dataRequiredFromDB, searchingEnabled, colIndex, sortCriterion, formviewer, request);
            }*/
        }
        else{
            if(wdmodel != null)
                dataRequiredFromDB = true;
            else{
                dataRequiredFromDB = false;
                if(!"Sort".equals(filterType))                    
                    sortCriterion = "N";
                rowIndexArr = objTable.filterData(filterType, sortCriterion,"", colIndex );
            }    
        }
    }

    if("Search".equals(filterType)){
        if ("Y".equals(saveCurrentBatch) && SaveCurrentBatchInGrid) {
                 IFormHandler iFormHandler = new IFormHandler(request, response, formviewer);
                 String code = objTable.saveTableData(wdmodel.getM_objGeneralData(), wdmodel, iFormHandler);
                 if (!"0".equals(code)) {
                     out.println(IFormUtility.forJava(code));
                 }
         }
        tableAction=filterType;
        searchingEnabled = true;
        valToBeSearch = request.getParameter("SearchCriterion");
        objTable.setM_strLastSearchedData(valToBeSearch);
        objTable.setM_iLastColumnSearched(Integer.parseInt(colIndex));
        if(wdmodel==null || tableAttribute==null || Integer.parseInt(colIndex)==-1) {
             dataRequiredFromDB=false;
             rowIndexArr = objTable.filterData(filterType, "",valToBeSearch, colIndex );
         }
    }
    if(!"".equals(objTable.getM_strLastSearchedData())){
        searchingEnabled = true;
        valToBeSearch = objTable.getM_strLastSearchedData();
        colIndex=Integer.toString(objTable.getM_iLastColumnSearched());
        if(wdmodel==null|| tableAttribute==null) dataRequiredFromDB=false;
    }
   
    if (dataRequiredFromDB) {
        if (objIFormSession.getM_strApplicationName() == null || "".equals(objIFormSession.getM_strApplicationName())) {
            if (searchingEnabled) {
                objTable.executeBatchXML(objIFormSession, wdmodel.getM_objGeneralData(), wdmodel, batchingType, sortingEnabled, dataRequiredFromDB, searchingEnabled, colIndex, valToBeSearch, formviewer, objTable.getM_strCurrentSortingOrder(), null);
            } else {
                objTable.executeBatchXML(objIFormSession, wdmodel.getM_objGeneralData(), wdmodel, batchingType, sortingEnabled, dataRequiredFromDB, searchingEnabled, colIndex, formviewer, objTable.getM_strCurrentSortingOrder());
            }
        } else {
            if(objIFormSession.isM_isMicroservice()){
             objTable.executeBatchJSONFromMDMService(objIFormSession, wdmodel.getM_objGeneralData(), wdmodel, batchingType, sortingEnabled, dataRequiredFromDB, searchingEnabled, colIndex, valToBeSearch, formviewer, request,sortCriterion);
            }else{
            objTable.executeBatchXMLFromMDM(objIFormSession, wdmodel.getM_objGeneralData(), wdmodel, batchingType, sortingEnabled, dataRequiredFromDB, searchingEnabled, colIndex, valToBeSearch, formviewer, request,sortCriterion);
        }
    }
}
  /* Deepak Changes Reverted
    else {
        if (formviewer.getM_objFormDef().getM_objUnloadedVariables().contains(objTable.getM_strDataClassName())) {
            IFormUtility.getVariableData(objTable.getM_strDataClassName(), objIFormSession, wdmodel); 
            WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
            objTable.getObj_eTableModal().setM_wiAttribute(wiAttr);
            }            
    }*/
    List<List<String>> objTableModel = objTable.getObj_eTableModal().getM_TableData();    
    if("PreBatch".equals(tableAction)&&!objTable.getM_objControlStyle().isM_bAdvancedListview() && (request.getParameter("ClearPreviousOper")==null || "N".equalsIgnoreCase(request.getParameter("ClearPreviousOper"))))
    {
        Collections.reverse(objTableModel);
        if(batchSize>0)
            objTable.setM_iBatchCounter(batchCounter-batchSize);
    }
    if("PreBatch".equals(tableAction) && objTable.getM_objControlStyle().isM_bAdvancedListview() && (request.getParameter("ClearPreviousOper")!=null && "Y".equalsIgnoreCase(request.getParameter("ClearPreviousOper"))))
    {
        Collections.reverse(objTableModel);        
    }    

    if(objIFormSession.getM_strApplicationName()!=null && !"".equals(objIFormSession.getM_strApplicationName())){
        String valueArray[]=objTable.getM_strDataClassName().split("\\.");
        String tableName = valueArray[valueArray.length - 1];
        DataObjectInterface tableObject = CommonUtility.getDataObject(objIFormSession.getM_objFormViewer().getM_objFormDef(), tableName);
        if(batchingType == 1 && (request.getParameter("ClearPreviousOper")==null || "N".equalsIgnoreCase(request.getParameter("ClearPreviousOper")))){
            preEnabled="true";
            if(tableObject!=null && tableObject.getTotalRecordsFetched() != null && !"".equals(tableObject.getTotalRecordsFetched())){
                if(objIFormSession.getNoOfRecordFetched() != null && !"".equals(objIFormSession.getNoOfRecordFetched())){
                    if(Integer.parseInt(tableObject.getTotalRecordsFetched()) > Integer.parseInt(objIFormSession.getNoOfRecordFetched()) ){
                        nextEnabled="true";
                    }
                }
            }
        }
        else if(batchingType == 2 && (request.getParameter("ClearPreviousOper")==null || "N".equalsIgnoreCase(request.getParameter("ClearPreviousOper")))){
            nextEnabled="true";
            if(tableObject!=null && tableObject.getTotalRecordsFetched() != null && !"".equals(tableObject.getTotalRecordsFetched())){
                if(objIFormSession.getNoOfRecordFetched() != null && !"".equals(objIFormSession.getNoOfRecordFetched())){
                    if(Integer.parseInt(tableObject.getTotalRecordsFetched()) > Integer.parseInt(objIFormSession.getNoOfRecordFetched()) ){
                        preEnabled="true";
                    }
                }
            }
        } else {
             if(tableObject!=null && tableObject.getTotalRecordsFetched() != null && !"".equals(tableObject.getTotalRecordsFetched())){
                if(request.getParameter("ClearPreviousOper")!=null && "Y".equalsIgnoreCase(request.getParameter("ClearPreviousOper"))){
                   preEnabled="false";
                }
                if(objIFormSession.getNoOfRecordFetched() != null && !"".equals(objIFormSession.getNoOfRecordFetched())){
                     if(Integer.parseInt(tableObject.getTotalRecordsFetched()) > Integer.parseInt(objIFormSession.getNoOfRecordFetched()) ){
                          nextEnabled="true";
                     }
                }
             }
         
        }
    }else{//wdmodel.getM_objGeneralData().getNoOfRecordToFetch()
        /*if (objTable != null && objTable.getRetrievedCount() >= objTable.getTotalCount()) {
            if(wdmodel!=null && wdmodel.getM_objGeneralData()!=null && !"".equals(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()) && Integer.parseInt(wdmodel.getM_objGeneralData().getNoOfRecordToFetch()) > objTable.getTotalCount()) {
                preEnabled = "true";
            }
        }
        if (objTable != null && objTable.getRetrievedCount() < objTable.getTotalCount()) {
            nextEnabled = "true";
        }*/
            if("PreBatch".equals(tableAction)) {
                if(objTable != null && objTable.getRetrievedCount() < objTable.getTotalCount()) {
                    preEnabled="true";
                }
            } else if("NextBatch".equals(tableAction)) {
                if(objTable != null && objTable.getRetrievedCount() < objTable.getTotalCount()) {
                    nextEnabled="true";
                }
            } else {
                if(objTable != null && objTable.getRetrievedCount() < objTable.getTotalCount()) {
                    nextEnabled="true";
                }
            }
        }
    response.setHeader("preEnabled", preEnabled);
    response.setHeader("nextEnabled", nextEnabled);
    //response.setHeader("ColumnIndex",colIndex);
    ArrayList prevOper= objTable.getPreviousOperation();
    if(prevOper!=null && objIFormSession.getM_strApplicationName()!=null && !"".equals(objIFormSession.getM_strApplicationName()) && prevOper.size()>0){
       response.setHeader("SortOrder",IFormUtility.forJava(String.valueOf(prevOper.get(1))));
       response.setHeader("ColumnIndex",IFormUtility.forJava(String.valueOf(prevOper.get(0))));
    } else
       response.setHeader("SortOrder",IFormUtility.forJava(objTable.getM_strCurrentSortingOrder()));
    if(batchSize>0)
        response.setHeader("batchCounter",String.valueOf(objTable.getM_iBatchCounter()));
        response.setHeader("ColumnIndex", String.valueOf(objTable.getM_iCurrentSortingColumnIndex()));
    //response.setHeader("filterType",filterType);
    WorkdeskAttribute wiAttr = IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
    int rowId=-1;

    if(wiAttr==null){
        objTable.setCurrentRowID(objTable.getObj_eTableModal().getM_TableData().size());
    }
    else
        objTable.setCurrentRowID(((ArrayList)wiAttr.getAttribValue()).size()-2);
    
    IFormServerEventHandler objCustomCodeInstance=null;
    IFormCustomHooks hookObject=null;
    if( objCustomCodeInstance != null ){
        hookObject=(IFormCustomHooks)objCustomCodeInstance;
    }
    List<List<String>> gridData = new ArrayList();
        boolean isShowGridComboLabel = (IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL) != null && "Y".equals(IFormINIConfiguration.getM_hINIHashMap().get(IFormConstants.SHOW_GRID_COMBO_LABEL)));
        List<ColumnInfo> lsCols = objTable.getObj_eTableModal().getM_arrColumnInfo();
            for (int i = 0; i < objTableModel.size(); i++) {
                List<String> visibleRowData = new ArrayList<String>();
                    for (int j = 0; j < lsCols.size(); j++) {
                        if (objTable.getM_objControlStyle().isM_bAdvancedListview()) {
                            String columnInfoMappedField = lsCols.get(j).getM_strMappedField();
                            if ("".equals(columnInfoMappedField)) {
                                columnInfoMappedField = lsCols.get(j).getM_strMappedControlField();
                            }
                         EControl tempControl = (EControl) IFormUtility.getFormField(lsCols.get(j).getM_strMappedControlField(), formviewer);
                            if (tempControl!=null && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_DATEPICK)) {
                                
                                visibleRowData.add(IFormUtility.getDateLocalValue(objTableModel.get(i).get(j), EControlHelper.getHTML(tempControl, "PickerType").equalsIgnoreCase("2"), formviewer.getM_objFormDef(),isMobileMode));
                            } else {
                                String visibleValue = objTableModel.get(i).get(j);
                                if (isShowGridComboLabel && tempControl!=null && !( "L".equals(tempControl.getM_objControlStyle().getM_strSaveValueType())) && tempControl.getM_strControlType().equals(IFormConstants.ETYPE_COMBO)) {
                                    visibleValue = IFormUtility.getOrgTableCellValue(controlId, i, j, formviewer, wdmodel, request);    
                                    String dbQuery = tempControl.getM_objControlOptions().getM_strQuery();
                                        if (hookObject != null) {
                                                visibleValue = hookObject.fetchData(controlId, i, j, tempControl.getM_strControlType(), visibleValue, objIFormSession);
                                        }
                                        if(!("".equalsIgnoreCase(visibleValue) || visibleValue==null)){
                                            if (!"".equals(dbQuery)) {
                                            visibleValue = IFormUtility.getComboLabelForValue(null, null, visibleValue, dbQuery, tempControl.getM_objControlOptions().isM_bisCaching(), objIFormSession,wdmodel);
                                        } else {
                                            visibleValue = IFormUtility.getComboLabelForValue(tempControl, null, visibleValue, dbQuery, tempControl.getM_objControlOptions().isM_bisCaching(), objIFormSession,wdmodel);
                                        }
                                    }
                                }
                                visibleRowData.add(visibleValue);
                            }
                            } else {
                            if(Integer.parseInt(lsCols.get(j).getM_strColumnMappedField())==7||Integer.parseInt(lsCols.get(j).getM_strColumnMappedField())==9){
                                 visibleRowData.add(IFormUtility.getDateLocalValue(objTableModel.get(i).get(j),Integer.parseInt(lsCols.get(j).getM_strColumnMappedField())==9, formviewer.getM_objFormDef(),isMobileMode));                          
                            }
                              else {
                                String visibleValue = objTableModel.get(i).get(j);
                                   EControl tempControl = null;
                                    if(objTable.getM_strControlTypeLabel().equalsIgnoreCase(IFormConstants.ETYPE_LISTVIEW)){
                                        tempControl = (EControl) IFormUtility.getNormalListviewControl(objTable, lsCols.get(j).getM_strColumnName());
                                    }
                                    if (tempControl!=null && isShowGridComboLabel && !( "L".equals(tempControl.getM_objControlStyle().getM_strSaveValueType()) ) && tempControl.getM_strControlType().equalsIgnoreCase(IFormConstants.ETYPE_COMBO)) {
                                        visibleValue = IFormUtility.getOrgTableCellValue(controlId, i, j, formviewer, wdmodel, request);
                                        String dbQuery = lsCols.get(j).getComboOptions().getM_strQuery();
                                            
                                        if (!"".equals(dbQuery)) {
                                            visibleValue = IFormUtility.getComboLabelForValue(null, null, visibleValue, dbQuery, objTable.getObj_eTableModal().getM_arrColumnInfo().get(j).getComboOptions().isM_bisCaching(), objIFormSession, wdmodel);
                                        } else {
                                            visibleValue = IFormUtility.getComboLabelForValue(null, objTable.getObj_eTableModal().getM_arrColumnInfo().get(j), visibleValue, dbQuery, objTable.getObj_eTableModal().getM_arrColumnInfo().get(j).getComboOptions().isM_bisCaching(), objIFormSession, wdmodel);
                                        }
                                    }
                                visibleRowData.add(visibleValue);
                            }
                        }
                    }
                  
            gridData.add(visibleRowData);
            
           
                }
             out.print(IFormUtility.getGridRowHTML(objTable, gridData, -1, formviewer, objIFormSession,rowIndexArr,request));
        
       
    } catch (Exception e) {
       
    }
    }
    //System.out.println("tableControlId>>"+controlId);
    //response.setHeader("tableControlId", controlId);
    //response.setHeader("preEnabled", preEnabled);
    //response.setHeader("nextEnabled", nextEnabled);
    //response.setHeader("dgroupColumns", dgroupColumns);    
}
%>
