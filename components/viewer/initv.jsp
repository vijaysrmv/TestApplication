<%@page import="com.newgen.iforms.util.CommonUtility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : initv
    Created on : Nov 20, 2015, 4:18:01 PM
    Author     : puneet.pahuja
--%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.newgen.mvcbeans.controller.workdesk.WDWorkitems"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%@page import="java.io.IOException"%>
<%@page import="com.newgen.iforms.xmlapi.IFormXmlResponse"%>
<%@page import="java.util.Locale"%>
<%@page import="com.newgen.iforms.session.IFormSession"%>

<%
     response.setHeader("Pragma", "no-cache"); //HTTP 1.0
     response.setDateHeader("Expires", -1); //prevents caching at the proxy server
        
    String returnResult = "failure";
    try {
        IFormSession formsession = new IFormSession(request,true);
        WDWorkitems wisessionbean = new WDWorkitems();

        session.setAttribute(IFormUtility.forHtml(IFormUtility.getIFormSessionUID(request)), formsession);
        formsession.setFid(IFormUtility.getIFormSessionUID(request));
        if("Y".equalsIgnoreCase(IFormUtility.escapeHtml4(request.getParameter(IFormConstants.IS_TOKENIZEDAUTH)))) {
            session.setAttribute("sessionId",CommonUtility.getSessionIdFromToken(request));
        } else {
            session.setAttribute("sessionId",IFormUtility.escapeHtml4( request.getParameter("SessionId")));
        }
        session.setAttribute("wDWorkitems", wisessionbean);
        
        returnResult = "success";
    } catch (Exception ex) {
        returnResult = "failure";
    }

    String callBack = IFormUtility.escapeHtml4(request.getParameter("callback"));
    String finalResult = callBack + "(" + returnResult + ");";
    PrintWriter outObject = response.getWriter();
    outObject.println(IFormUtility.forJava(finalResult));
%>