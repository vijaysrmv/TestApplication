<%-- 
    Document   : appTask
    Created on : Oct 20, 2019, 11:11:34 PM
    Author     : mohit.sharma
--%>

<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.ibps.security.csrf.SECCSRFUtil"%>

<%
   request.setCharacterEncoding("UTF-8");
   String operation = request.getParameter("oper");
   Object oldSessionToken = session.getAttribute(SECCSRFUtil.SESSION_TOKEN_KEY);
   Object oldRequestToken = session.getAttribute(SECCSRFUtil.REQUEST_TOKENS_KEY);
   if(operation.equals("clearSession"))
   {
       session.invalidate();
       request.getSession().setAttribute(SECCSRFUtil.SESSION_TOKEN_KEY, oldSessionToken);
       request.getSession().setAttribute(SECCSRFUtil.REQUEST_TOKENS_KEY, oldRequestToken);
   }
   else{
   String rid_appTask = IFormUtility.generateTokens(request,request.getRequestURI());
   response.setHeader("WD_RID", IFormUtility.forJava(IFormUtility.removeSpecial(rid_appTask)));
   AppTasks.performOperation(operation,request,response);
   }
%>