<%--

--%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="com.newgen.iforms.base.IFormCabinetList"%>
<%@page import="com.newgen.iforms.base.IFormCabinetInfo"%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedHashMap,java.util.HashMap,com.newgen.iforms.xmlapi.IFormCallBroker"%>

<%
//             String routeID = null;
//             String jtsIP = null;
//             int jtsPort = 0;
//             String activityId = null;
//             String workstepName = null;
//             String attributeData = null;
//             String dataBaseType = null;
//             String multitenancyVar = null;
//             String appServerName = null;
//             boolean mobilemode = ("ios".equalsIgnoreCase(request.getParameter("mobileMode"))||"android".equalsIgnoreCase(request.getParameter("mobileMode")));
//            
//
//        //HashMap parameterMap = (HashMap)request.getParameterMap();
//         //if(parameterMap != null && parameterMap.size() > 0)
//            // {            
//              routeID = request.getParameter("ProcessDefId");
//                try {
//                    jtsIP = request.getParameter("JTSIP");
//                    jtsPort = Integer.parseInt(request.getParameter("JTSPort"));
//                } catch (Exception ex) {
//                    IFormCabinetInfo objCabInfo = null;
//                    if(request.getParameter("UDBEncrypt") != null && "Y".equalsIgnoreCase(request.getParameter("UDBEncrypt")) && !mobilemode) {
//                        objCabInfo = IFormCabinetList.GetCabinetDetails(IFormUtility.decryptStringData(request.getParameter("CabinetName")));
//                    } else {
//                        objCabInfo = IFormCabinetList.GetCabinetDetails(request.getParameter("CabinetName"));
//                    }
//                    if (objCabInfo != null) {
//                        jtsIP = objCabInfo.getM_strServerIP();
//                        jtsPort = Integer.parseInt(objCabInfo.getM_strServerPort());
//                        appServerName = objCabInfo.getM_strAppServerType().toString();
//                    }
//                }
//              activityId = request.getParameter("ActivityId");
//              workstepName = request.getParameter("workstepName");
//              attributeData = request.getParameter("AttributeData");
////              dataBaseType = request.getParameter("wdesk:DatabaseType");
//              multitenancyVar = request.getParameter("multitenancyvar");
////              appServerName = request.getParameter("appservername");
//            if("Y".equalsIgnoreCase(IFormUtility.escapeHtml4(request.getParameter(IFormConstants.IS_TOKENIZEDAUTH)))) {
//                customSession.setDMSSessionId(CommonUtility.getSessionIdFromToken(request));
//            }
//            else if (request.getParameter("UDBEncrypt") != null && "Y".equalsIgnoreCase(request.getParameter("UDBEncrypt"))) {
//                 customSession.setDMSSessionId(IFormUtility.decryptStringData(request.getParameter("SessionId")));
//             }
//             else {
//             customSession.setDMSSessionId(request.getParameter("SessionId"));
//             }
//             if(request.getParameter("DebugValue")!=null && !"".equals(request.getParameter("DebugValue")))
//                customSession.setDebugValue(Integer.parseInt(request.getParameter("DebugValue")));
//             if (request.getParameter("UDBEncrypt") != null && "Y".equalsIgnoreCase(request.getParameter("UDBEncrypt")) && !mobilemode) {
//                 customSession.setEngineName(IFormUtility.decryptStringData(request.getParameter("CabinetName")));
//             } else {
//             customSession.setEngineName(request.getParameter("CabinetName"));
//             }
//             customSession.setJtsIp(jtsIP);
//             customSession.setJtsPort(jtsPort);
//             customSession.setLocale(request.getParameter("locale"));
////             customSession.setStrDatabaseType(request.getParameter("wdesk:DataBaseType"));
//             if(request.getParameter("UserIndex")!=null &&!"".equals(request.getParameter("UserIndex")))
//                customSession.setUserIndex(Integer.parseInt(request.getParameter("UserIndex")));
//             customSession.setUserName(request.getParameter("UserName"));            
//             customSession.setWebContextPath(request.getParameter("context"));
//             customSession.setM_strMultiTenancyVar(multitenancyVar);
//             customSession.setAppServerName(appServerName);
//             if(appServerName!=null && jtsIP!=null)
//                IFormCallBroker.setAppServer(appServerName,jtsIP.trim(),String.valueOf(jtsPort));
            //}
%>
