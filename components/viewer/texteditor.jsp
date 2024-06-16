<%-- 
    Document   : textarea
    Created on : 17 Jan, 2019, 10:34:26 AM
    Author     : aman.khan
--%>

<%@page import="com.newgen.iforms.controls.ERootControl"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.newgen.mvcbeans.model.WorkdeskModel"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>
<%@page import="com.newgen.iforms.viewer.IFormViewer"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.iforms.controls.ETextAreaControl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title></title>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
        <script type="text/javascript" src="resources/bootstrap/js/jquery.js?rid=<%= randomId%>"></script>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/css/bootstrap.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/bootstrap.js?rid=<%= randomId%>"></script>
        <link rel="stylesheet" href="resources/bootstrap/css/jquery-ui.css?rid=<%= randomId%>">
        <script type="text/javascript" src="resources/bootstrap/js/jquery-ui.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/ckeditor/ckeditor.js?rid=<%= randomId%>"></script>
        <script type="text/javascript" src="resources/scripts/rte.js?rid=<%= randomId%>"></script>
    </head>
    <body style="overflow-x:hidden" onload="viewRichTextData('<%=IFormUtility.forHtmlAttribute(IFormUtility.escapeHtml4(request.getParameter("textareaId")))%>')">
        <%
        String randomId = IFormUtility.getRid();
		IFormSession objIFormSession = (IFormSession) session.getAttribute(IFormUtility.getIFormSessionUID(request));
        IFormViewer formviewer = objIFormSession.getM_objFormViewer();
        String textareaId = IFormUtility.escapeHtml4(request.getParameter("textareaId"));
        ETextAreaControl textareaRef = ((ETextAreaControl)formviewer.getM_objFormDef().getFormField(textareaId));
        if(textareaRef==null)
             textareaRef = ((ETextAreaControl)formviewer.getM_objFormDef().getSubFormField(((ERootControl)formviewer.getM_objFormDef().getM_objRootControl()).getBtnRef(),textareaId));
        WorkdeskModel objWorkdeskModel = null;
        String tid = IFormUtility.escapeHtml4(request.getParameter("tid"));
            String pid = IFormUtility.escapeHtml4(request.getParameter("pid"));
            String wid = IFormUtility.escapeHtml4(request.getParameter("wid"));
        WDWorkitems wisessionbean = (WDWorkitems) session.getAttribute("wDWorkitems");
        if (wisessionbean != null) {
                LinkedHashMap workitemMap = wisessionbean.getWorkItems();
                if (tid == null || tid.isEmpty()) {
                    objWorkdeskModel = (WorkdeskModel) workitemMap.get(pid + "_" + wid);
                } else {
                    objWorkdeskModel = (WorkdeskModel) workitemMap.get(pid + "_" + wid + "_" + tid);
                }
            }
      
    %>
        <%=textareaRef.getRenderBlock(formviewer.getM_objFormDef(),objIFormSession,objWorkdeskModel)%>
        
       
    </body>
</html>
