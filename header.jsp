<%--

--%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedHashMap,java.util.HashMap,com.newgen.iforms.xmlapi.IFormCallBroker"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session">
</jsp:useBean>

<%
             String routeID = null;
             String jtsIP = null;
             int jtsPort = 0;
             String activityId = null;
             String workstepName = null;
             String attributeData = null;
             String dataBaseType = null;
             String multitenancyVar = null;
             String appServerName = null;
            

        //HashMap parameterMap = (HashMap)request.getParameterMap();
         //if(parameterMap != null && parameterMap.size() > 0)
            // {            
              routeID = request.getParameter("ProcessDefId");
              jtsIP = request.getParameter("JTSIP");
              jtsPort = Integer.parseInt(request.getParameter("JTSPort"));
              activityId = request.getParameter("ActivityId");
              workstepName = request.getParameter("workstepName");
              attributeData = request.getParameter("AttributeData");
//              dataBaseType = request.getParameter("wdesk:DatabaseType");
              multitenancyVar = request.getParameter("multitenancyvar");
              appServerName = request.getParameter("appservername");
            
             customSession.setDMSSessionId(request.getParameter("SessionId"));
             customSession.setDebugValue(Integer.parseInt(request.getParameter("DebugValue")));
             customSession.setEngineName(request.getParameter("CabinetName"));
             customSession.setJtsIp(request.getParameter("JTSIP"));
             customSession.setJtsPort(Integer.parseInt(request.getParameter("JTSPort")));
             customSession.setLocale(request.getParameter("locale"));
//             customSession.setStrDatabaseType(request.getParameter("wdesk:DataBaseType"));
             customSession.setUserIndex(Integer.parseInt(request.getParameter("UserIndex")));
             customSession.setUserName(request.getParameter("UserName"));            
             customSession.setWebContextPath(request.getParameter("context"));
             customSession.setM_strMultiTenancyVar(multitenancyVar);
             customSession.setAppServerName(appServerName);
            
             IFormCallBroker.setAppServer(appServerName,jtsIP.trim(),String.valueOf(jtsPort));
            //}
%>
