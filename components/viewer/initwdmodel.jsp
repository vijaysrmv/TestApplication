<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : initv
    Created on : Nov 20, 2015, 4:18:01 PM
    Author     : puneet.pahuja
--%>

<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.wfdesktop.xmlapi.WFAttribParser"%>
<%@page import="com.newgen.iforms.api.IFormTransactions"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="java.io.IOException"%>
<%@page import="com.newgen.iforms.xmlapi.IFormXmlResponse"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>

<%
    String processvariablesxml = "<?xml version=\"1.0\"?><WFGetProcessVariablesExt_Output><Option>WFGetProcessVariablesExt</Option><Exception><MainCode>0</MainCode></Exception><Attributes><int1 DefaultValue=\"null\" EntityName=\"\" SystemDefinedName=\"VAR_INT1\" Type=\"133\" Unbounded=\"N\" VarFieldId=\"0\" VariableId=\"1\"/><float1 DefaultValue=\"null\" EntityName=\"\" Length=\"255\" Precision=\"0\" SystemDefinedName=\"VAR_FLOAT1\" Type=\"136\" Unbounded=\"N\" VarFieldId=\"0\" VariableId=\"9\"/><date1 DefaultValue=\"null\" EntityName=\"\" SystemDefinedName=\"VAR_DATE1\" Type=\"138\" Unbounded=\"N\" VarFieldId=\"0\" VariableId=\"11\"/><long1 DefaultValue=\"null\" EntityName=\"\" SystemDefinedName=\"VAR_LONG1\" Type=\"134\" Unbounded=\"N\" VarFieldId=\"0\" VariableId=\"15\"/><text1 DefaultValue=\"null\" EntityName=\"\" Length=\"255\" SystemDefinedName=\"VAR_STR1\" Type=\"1310\" Unbounded=\"N\" VarFieldId=\"0\" VariableId=\"19\"/></Attributes></WFGetProcessVariablesExt_Output>";
    //String strAttributeDataXml = "<Attributes><int1 Length=\"255\" Type=\"133\" VarFieldId=\"0\" VariableId=\"1\">1</int1><float1 Length=\"255\" Precision=\"0\" Type=\"136\" VarFieldId=\"0\" VariableId=\"9\">2.00</float1><date1 Length=\"255\" Type=\"138\" VarFieldId=\"0\" VariableId=\"11\"></date1><long1 Length=\"255\" Type=\"134\" VarFieldId=\"0\" VariableId=\"15\">4</long1><text1 Length=\"255\" Type=\"1310\" VarFieldId=\"0\" VariableId=\"19\">Hi</text1><ItemIndex Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"53\">1589</ItemIndex><ItemType Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"54\">F</ItemType><VAR_REC_3 Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"55\"></VAR_REC_3><VAR_REC_4 Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"56\"></VAR_REC_4><VAR_REC_5 Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"57\"></VAR_REC_5><HoldStatus Length=\"255\" Type=\"323\" VarFieldId=\"0\" VariableId=\"39\"></HoldStatus><CheckListCompleteFlag Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"50\">N</CheckListCompleteFlag><InstrumentStatus Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"37\">N</InstrumentStatus><SaveStage Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"34\">StartEvent1</SaveStage><Status Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"42\"></Status><CalendarName Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"10001\"></CalendarName><ProcessInstanceState Length=\"255\" Type=\"323\" VarFieldId=\"0\" VariableId=\"40\">1</ProcessInstanceState><CreatedDateTime Length=\"255\" Type=\"318\" VarFieldId=\"0\" VariableId=\"28\">2015-11-23 10:51:40</CreatedDateTime><CreatedByName Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"32\">admin</CreatedByName><IntroductionDateTime Length=\"255\" Type=\"318\" VarFieldId=\"0\" VariableId=\"35\"></IntroductionDateTime><IntroducedBy Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"36\"></IntroducedBy><IntroducedAt Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"10003\">StartEvent1</IntroducedAt><PriorityLevel Length=\"255\" Type=\"323\" VarFieldId=\"0\" VariableId=\"38\">1</PriorityLevel><WorkItemState Length=\"255\" Type=\"323\" VarFieldId=\"0\" VariableId=\"41\">2</WorkItemState><ActivityId Length=\"255\" Type=\"323\" VarFieldId=\"0\" VariableId=\"43\">1</ActivityId><LockedByName Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"46\">admin</LockedByName><LockedTime Length=\"255\" Type=\"328\" VarFieldId=\"0\" VariableId=\"47\">2015-11-23 15:46:03</LockedTime><LockStatus Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"48\">Y</LockStatus><ActivityName Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"49\">StartEvent1</ActivityName><AssignmentType Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"51\">S</AssignmentType><ProcessedBy Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"52\">admin</ProcessedBy><EntryDateTime Length=\"255\" Type=\"318\" VarFieldId=\"0\" VariableId=\"29\">2015-11-23 10:51:40</EntryDateTime><ValidTillDateTime Length=\"255\" Type=\"318\" VarFieldId=\"0\" VariableId=\"30\"></ValidTillDateTime><WorkItemName Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"31\">htmlform-0000000001-process</WorkItemName><PreviousStage Length=\"255\" Type=\"3110\" VarFieldId=\"0\" VariableId=\"33\">StartEvent1</PreviousStage><TurnAroundDateTime Length=\"255\" Type=\"318\" VarFieldId=\"0\" VariableId=\"10002\"></TurnAroundDateTime><WorkItemId Length=\"255\" Type=\"323\" VarFieldId=\"0\" VariableId=\"10004\">1</WorkItemId><CurrentDateTime Length=\"255\" Type=\"318\" VarFieldId=\"0\" VariableId=\"27\">2015-11-23 15:46:03</CurrentDateTime><QueueName Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"45\">htmlform_StartEvent1</QueueName><QueueType Length=\"255\" Type=\"3210\" VarFieldId=\"0\" VariableId=\"44\">I</QueueType></Attributes>";

    // Get workitem data
    IFormSession objFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
    try{
    String workitemDataExt = IFormTransactions.WFGetWorkitemDataExt(objFormSession.getM_objIFormCabinetInfo().getM_strServerIP(), Integer.parseInt(objFormSession.getM_objIFormCabinetInfo().getM_strServerPort()), objFormSession.getM_objIFormCabinetInfo().getM_strCabinetName(), objFormSession.getM_strSessionId(), "htmlform-0000000001-process", "1", "1192", "I", null, null, "5", "A", "W,D", "Y", "N", "Y", null, null, null, null);
     IFormXmlResponse GetWIDataExtXmlResponse = new IFormXmlResponse(workitemDataExt);
     String strAttributeDataXml = "<Attributes>" + GetWIDataExtXmlResponse.getVal("Attributes") + "</Attributes>";
     WFAttribParser.prepareWorkitemModel(request, processvariablesxml, strAttributeDataXml, "");
    }
    catch(IOException ex)
    {
      NGUtil.writeErrorLog("ibps30sep", IFormConstants.VIEWER_LOGGER_NAME, "Error in getting field data from xml in function WFTransactions:WFGetWorkitemDataExt()");   
    }
    catch(Exception ex)
    {
      NGUtil.writeErrorLog("ibps30sep", IFormConstants.VIEWER_LOGGER_NAME, "Error in getting field data from xml in function WFTransactions:WFGetWorkitemDataExt()");   
    }
   
    
%>