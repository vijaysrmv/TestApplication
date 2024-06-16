<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : advancedListViewModal
    Created on : Oct 10, 2018, 3:52:24 PM
    Author     : g.sharma
* 20/02/2019   Aman Khan    Bug 83215 - Overlay Heading for some sections not appearing completely. They are written with ... like this "Head..." (edit)
* 03/04/2019	Gaurav		Bug 83970 - done click not working in mandatory checkbox case.
* 22/04/2019    Gaurav          Bug 84293 - Need configuration to hide prev next button on listview overlay
* 28/05/2019    Abhishek        Bug 84964 - Custom alert on cross icon of grid 
* 20/06/2019    Gaurav          Bug 85361 - data not saving in table when task is opened with case form
* 12/09/2019    Aman Khan       Bug 86568 - Searching not working on full table but in batches
--%>


<%@page import="com.rits.cloning.Cloner"%>
<%@page import="com.newgen.iforms.controls.ERootControl"%>
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
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.newgen.iforms.custom.IFormServerEventHandler"%>
<%@page import="com.newgen.iforms.EControl"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="com.newgen.iforms.controls.EFrameControl"%>
<%@page import="com.newgen.iforms.IControl"%>
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
    } catch (Exception | Error ex) {
        NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception omniapp locale.." + ex.getMessage(), ex);
    }
%>

        <script>
        var $input = $('.form-input');
    
        var $textarea = $('.form-textarea');
        var $combo = $('select');
        if($input.attr("datatype")=="date"){
            $(this).focus({
                
                })
        }
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
        
         $('.mdb-select').each(function() {
              var isIncludeSelectAllOption = (this.classList.contains("hideSelectAll"))?false:true;
              var isIncludeSearchBoxOption = (this.classList.contains("hideSearchBox"))?false:true;
        $(this).multiselect({
            buttonWidth: '100%',
            includeSelectAllOption: isIncludeSelectAllOption,
            enableFiltering : isIncludeSearchBoxOption,
            enableCaseInsensitiveFiltering:isIncludeSearchBoxOption
        });
    });
        $( "select[multiple='']").each(function() {
          $(this).siblings().find('.multiselect-container .checkbox').css("text-align",$(this).css("text-align"));
          $(this).siblings().find('.multiselect-container .checkbox').css("font-size",$(this).css("font-size"));
          $(this).siblings().find('.multiselect-container .checkbox').css("font-weight",$(this).css("font-weight"));
          $(this).siblings().find('.multiselect-container .checkbox').css("font-style",$(this).css("font-style"));
          $(this).siblings().find('.multiselect-container .checkbox').css("font-family",$(this).css("font-family"));
          $(this).siblings().find('.multiselect-container .checkbox').css("background-color",$(this).css("background-color"));
          $(this).siblings().find('.multiselect-container .checkbox').css("color",$(this).css("color"));   
          $(this).siblings().find('.dropdown-toggle').css("text-align",$(this).css("text-align"));
          $(this).siblings().find('.dropdown-toggle').css("font-size",$(this).css("font-size"));
          $(this).siblings().find('.dropdown-toggle').css("font-weight",$(this).css("font-weight"));
          $(this).siblings().find('.dropdown-toggle').css("font-style",$(this).css("font-style"));
          $(this).siblings().find('.dropdown-toggle').css("font-family",$(this).css("font-family"));
          $(this).siblings().find('.dropdown-toggle').css("background-color",$(this).css("background-color"));
          $(this).siblings().find('.dropdown-toggle').css("color",$(this).css("color"));    
         
        });
        $('.multiselect-container .checkbox').addClass('inputStyle');
        $('.multiselect-container .checkbox').css("border","0px");
        $('.dropdown-toggle').addClass('inputStyle');        
        $('.dropdown-toggle .caret').css('float',"right");   
        $("#advancedListViewModalContent").draggable({
                handle: ".modal-header"
            });
    
        </script>
        <%
          try {
           IFormViewer formviewer = (IFormViewer) session.getAttribute(IFormUtility.getIFormVSessionUID(request));
           WorkdeskModel wdmodel=IFormUtility.getWorkdeskModel(request);//Bug 85361
           String sid = (String) IFormUtility.escapeHtml4(request.getParameter("WD_SID"));
           String rid_advancelistviewmodal = IFormUtility.generateTokens(request,request.getRequestURI());
           response.setHeader("WD_RID", IFormUtility.forJava(rid_advancelistviewmodal));

        request.setCharacterEncoding("UTF-8");
        String controlId = IFormUtility.forHtmlAttribute(com.newgen.iforms.util.IFormUtility.escapeHtml4(request.getParameter("controlId")));
        String modifyFlag = IFormUtility.escapeHtml4(request.getParameter("modifyFlag"));
        IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
        EControl objControl = new EControl();
        String displayModify="display:none;";
        String displayAdd="";
        objControl = (EControl) formviewer.getM_objFormDef().getFormField(controlId);
        if(objControl==null){
            objControl = (EControl) formviewer.getM_objFormDef().getSubFormField(((ERootControl)formviewer.getM_objFormDef().getM_objRootControl()).getBtnRef(), controlId);
        }
        ETableControl objTable = (ETableControl) objControl;

        if(objTable.getControlSetInfo()!=null)
            formviewer.getM_objFormDef().parseControlGroupInfo(objTable.getControlSetInfo(), "advancedlistview", controlId);
        String rowIndex = com.newgen.iforms.util.IFormUtility.escapeHtml4(request.getParameter("rowIndex"));
        objIFormSession.setOpenedAdvancedListviewDataClassName(objControl.getM_strDataClassName());//Bug 82812
        String pid = (String) IFormUtility.escapeHtml4(request.getParameter("pid"));
        String wid = (String) IFormUtility.escapeHtml4(request.getParameter("wid"));
        String tid = IFormUtility.getIFormTaskId(request);

        //WorkdeskModel wDModel = null;
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
        } catch (Exception | Error ex) {
            NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in advancedListViewModal.jsp 000..." + ex.getMessage(), ex);
            }
        if(wdmodel!=null && wdmodel.getM_objGeneralData()!=null)   
            objIFormSession.setNoOfRecordFetched(wdmodel.getM_objGeneralData().getNoOfRecordToFetch());
        
        if("yes".equalsIgnoreCase(modifyFlag))
        {   
            displayAdd="display:none;";
            displayModify="";
        }
        String deviceType=request.getHeader("User-Agent").toLowerCase();
        Boolean isMobile=false;
        if(deviceType.contains("mobile") || deviceType.contains("android") || deviceType.contains("ipod") || deviceType.contains("webos") || deviceType.contains("iphone") || deviceType.contains("ipad") || deviceType.contains("blackberry") || deviceType.contains("iemobile") || deviceType.contains("opera mini")){
            isMobile=true;
        }
        Boolean enormousNames = false;
        if (lbls.getString("Path").equals("de/") || lbls.getString("Path").equals("nl/") || lbls.getString("Path").equals("pt/")) {
              enormousNames = true;
        }
        String displayTopButtons = "";
        String overFlowLabelCSS = "";
        if(isMobile || enormousNames || !"0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment())){
            displayTopButtons = "display:none;";
        }
        if("".equals(displayTopButtons) || isMobile || enormousNames)
            overFlowLabelCSS="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;";
        String displayDuplicateButton = "";
        String displaySaveChanges = "";
        if ("false".equals(objTable.getM_objControlStyle().getM_strDuplicateRow())) 
        {
            displayDuplicateButton = "display:none";
            //displaySaveChanges = "margin-left:70px;";
        }
        ArrayList<String> classList=new ArrayList< String>();
        if( objControl.getM_strControlLabel().length() < 8 ){
            classList.add("col-2");
            classList.add("col-8");
            classList.add("col-2");
        }
        else{
            classList.add("col-4");
            classList.add("col-7");
            classList.add("col-1");
        }
        if("".equals(displayModify)){
            if("".equals(displayDuplicateButton)){
               if( objControl.getM_strControlLabel().length() < 8 ){
                    classList.set(0,"col-2");
                    classList.set(1,"col-8");
                    classList.set(2,"col-2");
                }
                else{
                    classList.add("col-4");
                    classList.add("col-7");
                    classList.add("col-1");
                }
            }
            else{
                classList.set(0,"col-4");
                classList.set(1,"col-4");
                classList.set(2,"col-4");
            }
        }
        %>
        <div id="advancedListViewModalContent" class="listviewmodalContent modal-content">
            <div class="modal-header" style="padding-bottom: 9px;">
                <div style="width:100%;display:flex;" class="row">
                    <%if("".equals(displayTopButtons)){%>
                        <span class="<%= classList.get(0)%> pull-<%=lbls.getString("LEFT")%>" style="display:flex;">
                            <%}else{%>
                            <span class="col-10" style="display:flex;">
                            <%}%>
                            <%
                                boolean showPrevNextButtons=true;
                                if("Y".equals(objTable.getM_objControlStyle().getM_strHideListviewPrevNextBtn()))
                                    showPrevNextButtons=false;
                                
                            %>
                            <button type="button" onclick="showNextPreviousResultAdvancedListview('<%= IFormUtility.forHtmlAttribute(controlId)%>','previous')" id="AdvancedListviewlistPrevious" style="<%if(!showPrevNextButtons){%>display:none;<%}%>background: #fff;border-bottom-left-radius: 4px;border-top-left-radius: 4px;padding: 3px;border: 1px solid #ccc;<% if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>margin-top:0px;<% }%>" class="pull-<%=lbls.getString("LEFT")%> glyphicon glyphicon-chevron-<%=lbls.getString("LEFT")%> nextPrevButton" disabled=""></button>
                            <button type="button" onclick="showNextPreviousResultAdvancedListview('<%= IFormUtility.forHtmlAttribute(controlId)%>','next');" id="AdvancedListviewlistNext" style="<%if(!showPrevNextButtons){%>display:none;<%}%>background: #fff;border-bottom-right-radius: 4px;border-top-right-radius: 4px;padding: 3px;border: 1px solid #ccc;<% if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>margin-top:0px;<% }%>;" class="pull-<%=lbls.getString("LEFT")%> glyphicon glyphicon-chevron-<%=lbls.getString("RIGHT")%> nextPrevButton" disabled=""></button>
                            <% if(!objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>
                                <div class="container-fluid" style="text-align:center;padding:0px;">
                                <label title="<%=objControl.getM_strControlLabel()%>" class="modal-title listViewHeader labelstyledesigner" style="font-weight:bold;<%if(showPrevNextButtons){%>width:calc(100% - 50px);<%}%>font-size: 16px;padding-<%=lbls.getString("LEFT")%>: 10px;display:inline-block;text-align:center;<%=overFlowLabelCSS%>"><%=objControl.getM_strControlLabel()%></label>
                                </div>
                            <%}else{%>
                                <label title="<%=objControl.getM_strControlLabel()%>" class="modal-title pull-<%=lbls.getString("LEFT")%> listViewHeader labelstyledesigner" style="font-weight:bold;<%if(showPrevNextButtons){%>width:calc(100% - 50px);<%}%>font-size: 16px;padding-<%=lbls.getString("LEFT")%>: 10px;display:inline-block;text-align:<%=lbls.getString("LEFT")%>;margin-top:1px;<%=overFlowLabelCSS%>"><%=objControl.getM_strControlLabel()%></label>
                            <%}%>
                        </span>

                        <%if("".equals(displayTopButtons)){%>
                        <span class="<%= classList.get(1)%> pull-<%=lbls.getString("LEFT")%> row ms-1" style="text-align:center;display:flex;">
                            <%if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>
                                <%if("".equals(displayAdd)){%>
                                    <div class="col-6" style="padding:0px;">
                                        <button style="width:100%;<%=displayTopButtons%><%=displayAdd%>" type="button" onclick="addRowToAdvancedListview('<%= IFormUtility.forHtmlAttribute(controlId)%>',false,true);" id="addAdvancedListviewrowNext_<%=controlId%>" class="iform-button control-class buttonStyle "><%= lbls.getString("SAVE_AND_ADD_ANOTHER")%></button> 
                                    </div>
                                    <div class="col-6" style="padding:0px;padding-<%=lbls.getString("LEFT")%>:3px;">
                                        <button style="width:100%;<%=displayTopButtons%><%=displayAdd%>" type="button" onclick="addRowToAdvancedListview('<%= IFormUtility.forHtmlAttribute(controlId)%>');" id="addAdvancedListviewrow_<%=controlId%>" class="iform-button control-class buttonStyle"><%= lbls.getString("ADD_AND_CLOSE")%></button>                     
                                    </div>
                                <%}else{%>
                                    <%if("".equals(displayDuplicateButton)){%>
                                    <div class="col-6" style="padding:0px;">
                                        <button style="width:100%;<%=displayTopButtons%><%=displayModify%>" type="button" id="saveAdvancedListviewchanges_<%=controlId%>" onclick="modifyAdvancedRowTableData('<%= IFormUtility.forHtmlAttribute(controlId)%>');"  class="iform-button control-class buttonStyle"><%=lbls.getString("SAVE_CHANGES")%></button>
                                    </div>
                                    <div class="col-6" style="padding:0px;padding-<%=lbls.getString("LEFT")%>:3px;">
                                        <button style="width:100%;<%=displayTopButtons%><%=displayModify%><%=displayDuplicateButton%>" type="button" id="duplicateAdvancedListviewchanges_<%=controlId%>" onclick="copyAdvancedListViewRowData('<%= IFormUtility.forHtmlAttribute(controlId)%>');"  class="iform-button control-class buttonStyle "><%=lbls.getString("COPY_ROW")%></button>
                                    </div>
                                    <%}else{%>
                                        <div class="col-md-3 col-sm-3 col-xs-3" style="padding:0px;"></div>
                                        <div class="col-6" style="padding:0px;">
                                            <button style="width:100%;<%=displayTopButtons%><%=displayModify%>" type="button" id="saveAdvancedListviewchanges_<%=controlId%>" onclick="modifyAdvancedRowTableData('<%= IFormUtility.forHtmlAttribute(controlId)%>');"  class="iform-button control-class buttonStyle "><%=lbls.getString("SAVE_CHANGES")%></button>
                                        </div>
                                    <%}%>
                                <%}%>
                            <%}%>
                        </span>
                        <%}%>
                         <%if("".equals(displayTopButtons)){%>
                        <span class="<%= classList.get(2)%>" style="float:right;text-align:end;">
                            <%}else{%>
                             <span class="col-2" style="float:right;text-align:end;position:relative;">
                            <%}%>
                            <button  style="<% if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("0")){%>margin-top:-2px;<% }else{%>margin-top:0px;<%}%> %> " type="button" id="advLVcloseButton" class="close btn" onclick="listViewOverlay('<%= IFormUtility.forHtmlAttribute(controlId)%>');">
                                <span class="glyphicon glyphicon-remove"></span>
                            </button>
                        </span>
                </div>
            </div>
            <div  class="modal-body" style="height:auto;-webkit-overflow-scrolling : auto;">

                        <div class="">
        <div class="container" style="padding: 0px;width: 100%;">
            <div id="fetchedData" >  
            </div>
        </div>
                    
                     </div>
                     
                     <%
        int rowId = Integer.parseInt(IFormUtility.escapeHtml4(request.getParameter("RowId")));
        WiAttribHashMap wiAttribMap = new WiAttribHashMap();
        WorkdeskAttribute tableAttribute=IFormUtility.getControlModelAttribute(objTable,wdmodel, request);//Bug 85361
        if("yes".equalsIgnoreCase(modifyFlag)){
            if(objTable.getObj_eTableModal().getM_wiAttribute()!=null){
                int k=0,l=0;
                ArrayList attribList=((ArrayList)tableAttribute.getAttribValue());//Bug 85361
                WiAttribHashMap attriSubMap = null;
                WorkdeskAttribute attribute1 = null;
                while(k<Integer.parseInt(rowIndex)+1){
                    attriSubMap = (WiAttribHashMap) attribList.get(l + 1);
                    attribute1 = (WorkdeskAttribute) attriSubMap.get("<INS_ORDER_ID>");
                    if(attribute1.getInsertionOrderId()>=0)
                        k++;
                    l++;
                }
                Cloner objCloner = new Cloner();
                wiAttribMap=(WiAttribHashMap)objCloner.deepClone(((ArrayList)tableAttribute.getAttribValue()).get(l));//Bug 85361
                objIFormSession.setAdvancedListviewRowMap(wiAttribMap);
            }
        }
        else{
            if(objTable.getObj_eTableModal().getM_wiAttribute()!=null){
                Cloner objCloner = new Cloner();
                wiAttribMap=(WiAttribHashMap)objCloner.deepClone(((ArrayList)tableAttribute.getAttribValue()).get(0));//Bug 85361
                objIFormSession.setAdvancedListviewRowMap(wiAttribMap);
            }
        }
        session.setAttribute(IFormUtility.forHtml(IFormUtility.escapeHtml4(request.getParameter("fid")))+"_AdvancedListviewMap", wiAttribMap);
        for(int i=0;i<objTable.getM_arrColumFrameLayoutList().size();i++){
         EFrameControl frameObj = null;
           IControl eframe=(IControl)objTable.getM_arrColumFrameLayoutList().get(i);
                  //((EControl)eframe).setM_bModal(true);
                    ((EControl)eframe).setM_bAdvancedModal(true);
                   frameObj = (EFrameControl) eframe;
                   frameObj.setObj_tableControl(objTable);
                   if(rowIndex!=null)
                    frameObj.setRowIndex(rowIndex);
                   //frameObj.parseControlElement(frame);
           
           
         //frameObj.getRenderBlock(formviewer.getM_objFormDef(), objIFormSession, null);
        %>  <div>
                     <%= frameObj.getRenderBlock(formviewer.getM_objFormDef(), objIFormSession, null)%> 
        </div>
                     <%}%>
                     
                    </div>
                     <%
                         if(isMobile || enormousNames || !"0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment())){
                                 
                         String alignment="";
                        if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("1"))
                         alignment="end";
                      if(objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("2"))
                      {
                        alignment ="start"; 
                      }
                      if(isMobile || enormousNames || objTable.getM_objControlStyle().getM_strListBtnAlignment().equalsIgnoreCase("3"))
                      {
                        alignment ="center"; 
                      }
                     %>
                    <%if(enormousNames){%>
                     <div class="modal-footer table-responsive container-fluid" style="justify-content:<%=alignment%>;padding:10px;">                   
                        <button style="<%=displayAdd%>" type="button" onclick="addRowToAdvancedListview('<%= controlId%>',false,true);" id="addAdvancedListviewrowNext_<%=controlId%>"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_AND_ADD_ANOTHER")%></button> 
                        <button style="<%=displayAdd%>" type="button" onclick="addRowToAdvancedListview('<%= controlId%>');" id="addAdvancedListviewrow_<%=controlId%>"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("ADD_AND_CLOSE")%></button>
                        <button style="<%=displayModify%>" type="button" id="saveAdvancedListviewchanges_<%=controlId%>" onclick="modifyAdvancedRowTableData('<%= controlId%>');"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_CHANGES")%></button>
                        <button style="<%=displayModify%>;<%=displayDuplicateButton%>" type="button" id="duplicateAdvancedListviewchanges_<%=controlId%>" onclick="copyAdvancedListViewRowData('<%= controlId%>');"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("COPY_ROW")%></button>
                    </div>   
                    <%} else if ((!"0".equals(objTable.getM_objControlStyle().getM_strListBtnAlignment()))||isMobile) {%>
                    <div class="modal-footer table-responsive container-fluid" style="justify-content:<%=alignment%>;padding:10px;">                   
                        <button style="padding-left:0px;padding-right:0px;width:138px;<%=displayAdd%>" type="button" onclick="addRowToAdvancedListview('<%= IFormUtility.forHtmlAttribute(controlId)%>',false,true);" id="addAdvancedListviewrowNext_<%=IFormUtility.forHtmlAttribute(controlId)%>"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_AND_ADD_ANOTHER")%></button> 
                        <button style="padding-left:0px;padding-right:0px;width:140px;<%=displayAdd%>" type="button" onclick="addRowToAdvancedListview('<%= IFormUtility.forHtmlAttribute(controlId)%>');" id="addAdvancedListviewrow_<%=IFormUtility.forHtmlAttribute(controlId)%>"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("ADD_AND_CLOSE")%></button>
                        <button style="padding-left:0px;padding-right:0px;width:100px;<%=displayModify%>" type="button" id="saveAdvancedListviewchanges_<%=IFormUtility.forHtmlAttribute(controlId)%>" onclick="modifyAdvancedRowTableData('<%= IFormUtility.forHtmlAttribute(controlId)%>');"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("SAVE_CHANGES")%></button>
                        <button style="padding-left:0px;padding-right:0px;width:138px;<%=displayModify%>;<%=displayDuplicateButton%>" type="button" id="duplicateAdvancedListviewchanges_<%=IFormUtility.forHtmlAttribute(controlId)%>" onclick="copyAdvancedListViewRowData('<%= IFormUtility.forHtmlAttribute(controlId)%>');"  class="iform-button control-class buttonStyle button-viewer "><%= lbls.getString("COPY_ROW")%></button>
                    </div> 
                        <%} }
                        } catch(Exception | Error ex){
                        NGUtil.writeErrorLog(null, IFormConstants.VIEWER_LOGGER_NAME, "Exception in advancedListViewModal.jsp..." + ex.getMessage(), ex);
                        }
                        %>
                </div>
