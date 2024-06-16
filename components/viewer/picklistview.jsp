<%@page import="java.util.HashMap"%>
<%@page import="com.newgen.iforms.controls.util.EControlHelper"%>
<%@page import="com.newgen.iforms.EControlBase"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : picklistview
    Created on : Dec 17, 2015, 12:54:26 PM
    Author     : nancy.goyal

    06/03/2018      Mohit Sharma    Bug 75296 - Performance Issue: User picklist loading is slow & loading icon should be shown in case of slowness instead of blank page
    22/03/2018      Gaurav Sharma   batching is not working proper in F3 Getpicklist event since given  batchsize 2, but only one item is showing in one batch
    12/11/2018      Aman Khan       Bug 81174 - Picklist functionality not working . 
    03/12/2018      Minakshi Sharma Bug 81682 - Picklist functionality not working on nested complex variable     
    03/12/2018      Aman Khan       Bug 81586 - iOS|| Android :- On Picklist window batching not working
    04/01/2018      Aman Khan       Bug 82332 - Error on F3 load for field inside a listview form 
    14/02/2019      Gaurav          Bug 83107 - Issue in select row in picklist with double click
    22/05/2019      Gaurav          Bug 84849 - picklist window taking almost 2 mins to load
    19/06/2019      Rohit Kumar     Bug 85341 - Vietnamese character not working for Picklist in iform
    25/06/2019      Gaurav          Bug 85424 - searching not working in picklist
    03/07/2019      Rohit Kumar     Bug 85495 - Provide product API to insert data into Picklist
    10/07/2019      Abhishek        Bug 85552 - Vietnam character in Picklist search box
    12/07/2019      Aman Khan       Bug 85605 - Picklist on button and java settabstyle not working
    13/12/2019      Aman Khan       Bug 89069 - Require Advance Search Drop down in Table.
    31/01/2020      Abhishek        Bug 90464 - hidden picklist column not hiding
    09/03/2020      Aman Khan       Bug 91238 - Picklist data UI is distorted
    13/03/2020      Aman Khan       Bug 91237 - Need to use up/key/tab keys in the picklist window
    12/06/2020      Aman Khan       Bug 92821 - Need to focus on searchbox when picklist is opened
    07/09/2020      Aman Khan       Bug 94427 - PickListCancelPostHook should not be called on double clicking a picklist row
--%>

<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%@page import="com.newgen.iforms.custom.IFormCustomHooks"%>
<%@page import="com.newgen.iforms.custom.IFormReference"%>
<%@page import="com.newgen.iforms.custom.IFormAPIHandler"%>
<%@page import="com.newgen.iforms.custom.IFormAPIHandler"%>
<%@page import="com.newgen.iforms.custom.IFormServerEventHandler"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.newgen.iforms.controls.EFrameControl"%>
<%@page import="com.newgen.iforms.controls.ETableControl"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="nu.xom.Document"%>
<%@page import="com.newgen.iforms.EControl"%>
<%@page import="com.newgen.iforms.controls.Picklist"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.IControl"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="com.newgen.iforms.db.DatabaseUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.newgen.iforms.EControlBase"%>
<%@page import="java.util.Locale"%>
<%
String randomId = IFormUtility.getRid();
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

%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap.css?rid=<%= randomId%>">
        <link rel="stylesheet" href="resources/bootstrap/css/bootstrap-glyphicons.css?rid=<%= randomId%>">
        <link rel="stylesheet" href="resources/bootstrap/css/jquery-ui.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery-ui.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap.min.js?rid=<%= randomId%>"> </script>
        <script type="text/javascript" src="resources/scripts/iformview.js?rid=<%= randomId%>"> </script>
        <script type="text/javascript" src="resources/scripts/net.js?rid=<%= randomId%>"> </script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead.min.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/bootstrap/js/jquery.floatThead.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/css/ifomstyle.css?rid=<%= randomId%>">
        <link type="text/css" rel="stylesheet" href="resources/css/customcss.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/purify.js?rid=<%= randomId%>"></script>      
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/font-awesome.min.css?rid=<%= randomId%>">
        <script type="text/javascript">
              window.addEventListener('keydown', function (e) {
                var evtObj = window.event || e;
                var keycode = evtObj.keyCode || evtObj.which;
                if(window.parent.document.getElementById("searchModal")!=null&&window.parent.document.getElementById("searchModal").className==="modal in"){
                    if(keycode=="40" || keycode=="38"){
                        cancelBubble(e);
                        togglePicklistRow(e,true);     
                    }
                    if(keycode=="9"){
                        cancelBubble(e);
                        handleTabKeyEvent(true);
                    }
                }
            });
            
            function showSelectedRow(){
                var picklistTable;
                try{
                    picklistTable = window.parent.frames["iFrameSearchModal"].contentWindow.document.getElementById("myTable");
                }
                catch(ex){
               if(window.parent.frames["iFrameSearchModal"]!=null && window.parent.frames["iFrameSearchModal"]!=undefined){
                if(window.parent.frames["iFrameSearchModal"].document!=null && window.parent.frames["iFrameSearchModal"].document!=undefined){
                    picklistTable = window.parent.frames["iFrameSearchModal"].document.getElementById("myTable");
                }
                else{
                    picklistTable = window.parent.frames["iFrameSearchModal"].contentWindow.document.getElementById("myTable");
                }
            }
            else{
                if(window.frames["iFrameSearchModal"].document!=null && window.frames["iFrameSearchModal"].document!=undefined){
                    picklistTable = window.frames["iFrameSearchModal"].document.getElementById("myTable");
                }
                else{
                    picklistTable = window.frames["iFrameSearchModal"].contentWindow.document.getElementById("myTable");
                }
                 
            }
            
        }
                var firstRowRef = picklistTable.tBodies[0].getElementsByTagName("tr")[0];
                firstRowRef.click();
            }
         function selectRow(rowRef)
         {
//            $(rowId).css("background-color", "#000000");
              if(jQuery(rowRef).hasClass('info')){
               jQuery(rowRef).removeClass('table-info'); 
               jQuery(rowRef).removeClass('info');
               } else {
              jQuery(rowRef).siblings().removeClass('table-info');
              jQuery(rowRef).siblings().removeClass('info');
              jQuery(rowRef).addClass('table-info');
              jQuery(rowRef).addClass('info')
               }
         }
         
         function setRowValue(rowRef){
             if(!jQuery(rowRef).hasClass('info'))
                selectRow(rowRef);
             window.parent.setSelectedRow();
             disablePrevious(true);
            
         }
         function disableNext(){
             window.parent.document.getElementById("picklistNext").disabled = true;
         }
        </script>
        <%
            IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
            HashMap<String,Integer> pickListWidthMap  = new HashMap<String,Integer>();
			IFormCustomHooks hookObject=null;			
            String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
            String rid_picklistview = IFormUtility.generateTokens(request,request.getRequestURI());
            response.setHeader("WD_RID", IFormUtility.removeSpecial(rid_picklistview));
          
            String controlId = com.newgen.iforms.util.IFormUtility.escapeHtml4(request.getParameter("controlId"));
            String rowId = com.newgen.iforms.util.IFormUtility.escapeHtml4(request.getParameter("rowId"));
            String colId = com.newgen.iforms.util.IFormUtility.escapeHtml4(request.getParameter("colId"));
            EControl objControl=null;
            boolean isMobile = formviewer.getM_objFormDef().isIsMobile();
            String isModal=(com.newgen.iforms.util.IFormUtility.escapeHtml4(request.getParameter("isListModal"))!=null&&"1".equalsIgnoreCase(com.newgen.iforms.util.IFormUtility.escapeHtml4(request.getParameter("isListModal"))))?"1":"0";
            //if(request.getParameter("isListModal")!=null&&"1".equalsIgnoreCase(request.getParameter("isListModal"))){
                //ETableControl tempcontrol=(ETableControl)formviewer.getM_objFormDef().getFormField(controlId.substring(0,controlId.indexOf('_')));
                //EFrameControl tableFrameControl=(EFrameControl)tempcontrol.getM_arrColumFrameLayoutList().get(0);
                //for(int j=0;j<tableFrameControl.getM_arrEControls().size();j++){
                    //if(controlId.equalsIgnoreCase(tableFrameControl.getM_arrEControls().get(j).getControlId()))
                        //objControl=(EControl)(tableFrameControl.getM_arrEControls().get(j));
                //}
            //  }
            //else
            //Bug 81682 - Picklist functionality not working on nested complex variable 
            if(IFormUtility.escapeHtml4(request.getParameter("buttonId"))!=null && !"".equals(IFormUtility.escapeHtml4(request.getParameter("buttonId")))){
                objControl = (EControl)formviewer.getM_objFormDef().getSubFormField((EControl)formviewer.getM_objFormDef().getFormField(IFormUtility.escapeHtml4(request.getParameter("buttonId"))), controlId);
            }
            else
            {                  
                objControl = (EControl)formviewer.getM_objFormDef().getFormField(controlId);
            }
            IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
            IFormReference objFormReference = null;
           try{
                IFormServerEventHandler objCustomCodeInstance = objIFormSession.getObjServerEventHandler();
                objFormReference = objIFormSession.getObjFormReference();
                if( objCustomCodeInstance != null &&objCustomCodeInstance instanceof IFormCustomHooks){
                    hookObject=(IFormCustomHooks)objCustomCodeInstance;
                    if(hookObject.picklistPreHook(controlId, objFormReference))
                        ((EControlBase)objControl).getM_objPicklist().setM_bCustomPicklist(true);
                    pickListWidthMap = hookObject.getPickListWidth(controlId);
                }
            }    
            catch(Exception ex){
                NGUtil.writeErrorLog(objIFormSession.getM_strCabinetName(), IFormConstants.VIEWER_LOGGER_NAME, "Exception in in picklistpreHook :controlID="+controlId+"..."+ex.getMessage(),ex);  //Bug 83510 
            }
            catch(Error error){
                //NGUtil.writeErrorLog(objIFormSession.getM_strCabinetName(), IFormConstants.VIEWER_LOGGER_NAME,"Errot in in calling hideCellHook:tableId="+ctrlId+"..."+error.getMessage());     //Bug 83510
            }     
            //int batchSize = objControl.getM_objControlStyle().getM_batchSize();
            int batchSize=objControl.getM_objPicklist().getM_iBatchSize();
            if(!objControl.getM_objPicklist().isM_bSkipDbPickListData())    //Bug 85495
            objControl.getM_objPicklist().fetchPicklistDatafromDB();
            objControl.getM_objPicklist().setM_iBatchCounter(batchSize);
            objControl.getM_objPicklist().setM_strLastSearchedData("");
            List<List<String>> dbResult=null;
            HashMap<String, List> customResultMap = null;
            List headerList = null;
            if(hookObject != null)
            {
               customResultMap = hookObject.populateDataFromCustom(controlId, objFormReference);
               if(customResultMap != null && !customResultMap.isEmpty())
               {
                    dbResult = customResultMap.get("dataList");
                    headerList = customResultMap.get("headerList");
               } else {
                    dbResult = objControl.getM_objPicklist().getPickListDataCopy();
                    headerList = objControl.getM_objPicklist().getHeaderList();
               }
            } else {
                dbResult = objControl.getM_objPicklist().getPickListDataCopy();
                headerList = objControl.getM_objPicklist().getHeaderList();
            }
            
            int columnWidth = 0;
            if((!((EControlBase)objControl).getM_objPicklist().isM_bCustomPicklist()&&dbResult.size()<= batchSize)||(((EControlBase)objControl).getM_objPicklist().isM_bCustomPicklist()&&!((EControlBase)objControl).getM_objPicklist().isM_bEnableNext())){%>            
            <script>
                disableNext();
            </script>
               <%}
            if(dbResult.size()>=batchSize)
                dbResult = dbResult.subList(0,batchSize);
               
            //objControl.getM_objPicklist().setM_iBatchCounter(batchSize+1);
        %>
        <style>
            <%= formviewer.getM_objFormDef().getRenderCSS()%>		
        </style>
        <script type="text/javascript" src="resources/<%= lbls.getString("Path")%>scripts/constants.js?rid=<%= randomId%>"></script>    
    </head>
    <body onload="picklistLoad('<%=IFormUtility.forHtmlAttribute(controlId)%>');showSelectedRow()">
        <div class="container">
            <input type="hidden" id="sid" name="sid" value= "<%=IFormUtility.forHtmlAttribute(sid)%>" >
            <input type="hidden" id="batchSize" value="<%=objControl.getM_objPicklist().getM_iBatchCounter()%>"/>
            <input type="hidden" id="controlId" value="<%= IFormUtility.forHtmlAttribute(controlId)%>"/>
            <input type="hidden" id="rowId" value="<%=IFormUtility.forHtmlAttribute(rowId)%>"/>
            <input type="hidden" id="colId" value="<%=IFormUtility.forHtmlAttribute(colId)%>"/>
            <input type="hidden" id="isModal" value="<%= IFormUtility.forHtmlAttribute(isModal)%>"/>   
            <input type="hidden" id="rid_Action" name="rid_Action" value= "" />
            <div class="row row-last" style="">
                <div class="col-8" style="padding-right: 0px;display: flex;position:relative;">
                    <span class="fa fa-search" style="top:10px;right:10px;position:absolute" onclick="searchPicklistData();return true;"></span>
                     <input placeholder="<%=lbls.getString("SEARCH")%>" style="border-radius:0px;height:31px;" id="searchBox" class="form-control inputStyle" onkeyup="searchPicklistData(event.keyCode);return true;">
                </div>
                <div class="col-4" style="padding-left: 0px;">
                    <%
                        String defaultSearchVal="";
                        if(hookObject!=null)
                            defaultSearchVal = hookObject.getPicklistSearchDefaultValue(controlId);
                    %>
                    <select style="border-radius:0px;height:31px;font-size:11px;width:100%;border:1px solid #ccc;" id="selectedColumn">
                         <%
                        if (headerList.size() >1){
                        %>
                        <%
                        Boolean searchAllColumns=true;
                        for (int head=0;head<headerList.size(); head++){
                            if(!"HiddenPicklistColumn".equalsIgnoreCase(String.valueOf(headerList.get(head)))){
                                if(hookObject!=null){
                                    if(!hookObject.isEnableSearchOnColumn(controlId, String.valueOf(headerList.get(head))))
                                        searchAllColumns=false;
                                }
                            }
                        }
                        if(searchAllColumns)
                        {
                            %>
                            <option value="---"><%=lbls.getString("ALL_COLUMNS")%></option>
                            <%
                        }

                        }
                         %>
                        <%
                        if(headerList != null){
                        for (int head=0;head<headerList.size(); head++){
                            if(!"HiddenPicklistColumn".equalsIgnoreCase(String.valueOf(headerList.get(head)))){
                                if(hookObject!=null){
                                    if(hookObject.isEnableSearchOnColumn(controlId, String.valueOf(headerList.get(head))))
                                    {
                                     if(headerList.get(head).equals(defaultSearchVal))
                                        {
                                        %>
                                            <option selected><%=headerList.get(head)%></option>
                                        <%
                                        }
                                        else
                                        {
                                        %>
                                            <option><%=headerList.get(head)%></option>
                                        <%
                                        }   
                                    }
                                }
                                else{
                                    %>
                                      <option><%=headerList.get(head)%></option>
                                    <%
                                }
                            }
                        }
                      }
                        %>
                    </select>
                </div>
            </div>
            <div class="row mx-0">      
                <%if(isMobile){%>
                    <div id="fetchedData" class="px-0" style="overflow:auto; height:auto;min-height:20px; border:unset!important;max-height:180px;">
                <%}else{%>
                    <div id="fetchedData" class="px-0" style="overflow:auto; height:auto;min-height:20px; border:unset!important;max-height:225px;">
                <%}%>
                    <table class="table table-bordered table-condensed" id="myTable" style="margin-bottom:0px;">
                        <thead>
                            <%
                            if(headerList != null){
                            for (int head=0;head<headerList.size(); head++){
                                if(pickListWidthMap.containsKey(String.valueOf(headerList.get(head))))
                                    columnWidth = pickListWidthMap.get(headerList.get(head));
                                if(!"HiddenPicklistColumn".equalsIgnoreCase(String.valueOf(headerList.get(head)))){
                            %>
                                    <th style="background-color:#efefef;width:<%=columnWidth%>px"><%= headerList.get(head) %></th>
                            <%  
                                }
                                else
                                {
                             %>
                                    <th style="display:none"><%= headerList.get(head) %></th>
                             <%
                                }
                            }
                             }
                            %>
                        </thead>

                        <tbody>
                            <%  if (dbResult != null) {
                                    for (List<String> rowData : dbResult) {
                                        int colCount=0;
                            %> 
                            <tr onclick="selectRow(this)" ondblclick="setRowValue(this)">
                                <%
                                for (String colData : rowData) {
                                 String disp = "HiddenPicklistColumn".equalsIgnoreCase(String.valueOf(headerList.get(colCount++))) ? "display:none;" : "display:table-cell;" ;
                                %>
                                <td  class="labelStyle" style="<%=disp%>font-weight: normal;white-space:pre-wrap;word-break:break-all;width:<%=columnWidth%>px"><%= IFormUtility.forHtmlAttribute(colData)%></td>
                                <%
                                }%>
                            </tr>
                            <% }
                        }%>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
                        <script>
                          /*  var $table = $('#myTable');
                            $table.floatThead({
                                scrollContainer: function($table){
                                    return $('#fetchedData')
                                }
                            });
                            $('#myTable').floatThead('reflow');*/
                            var fid=window.parent.fid;
                            var pid=window.parent.pid;//Bug 85424
                            var wid=window.parent.wid;//Bug 85424
                            var tid=window.parent.tid;//Bug 85424
                            window.parent.RemoveIndicator("application");
                        </script>
    </body>
</html>

