<%-- 
    Document   : redirector
    Created on : Feb 2, 2020, 11:11:34 PM
    Author     : mohit.sharma
--%>

<%@page import="com.newgen.ibps.security.csrf.SECCSRFUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.newgen.iforms.xmlapi.IFormCallBroker"%>
<%@page import="com.newgen.commonlogger.NGUtil"%>
<%@page import="com.newgen.iforms.util.AESEncryption"%>
<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page import="com.newgen.iforms.webapp.AppConfiguration"%>
<%@page import="com.newgen.iforms.util.IFormINIConfiguration"%>
<%@page import="com.newgen.iforms.controls.util.IFormConstants"%>
<%

    AppConfiguration appConf = new AppConfiguration();
    String buildPath = application.getRealPath("/");
    IFormINIConfiguration.loadConfigurationFile(request);
    appConf.setWebAppLocation(buildPath);
    appConf.loadConfigurationFile(request);
    IFormCallBroker.setWebAppLocation(buildPath);
    IFormCallBroker.loadConfigurationFile(request);
    String contextPath = request.getContextPath();
    String callFrom = AppTasks.getValueFromINI(IFormConstants.CALL_FROM, request); 
    String url = contextPath+"/components/viewer/portal/initializePortal.jsp";
    String sessionToken = SECCSRFUtil.getNewSessionToken(request);
    String requestToken = SECCSRFUtil.getNewRequestToken(request, url);
    if(request.getParameter("QueryString") != null){
		String QueryString = URLEncoder.encode(request.getParameter("QueryString"),"UTF-8").replace("+","%20");
		if(QueryString!=null)
			url=url+"?QueryString="+QueryString;
    }
    if(request.getParameter("AdditionalParams") != null){
    String additionalParams =IFormUtility.escapeHtml4(request.getParameter("AdditionalParams"));
    if(additionalParams!=null)
        url=url+"?AdditionalParams="+additionalParams;
   }
    if(request.getParameter("ExtendSession") != null){
		String ExtendSession= URLEncoder.encode(request.getParameter("ExtendSession"),"UTF-8").replace("+","%20");
		if(ExtendSession!=null)
                    url=url+"?rid="+System.currentTimeMillis()+"&ExtendSession="+ExtendSession; 
		if("Y".equalsIgnoreCase(ExtendSession) && ((request.getParameter("UserDBId") != null) || (request.getParameter("IsTokenizedAuth") != null)) && request.getParameter("ExtendUserIndex") != null)
		{       
                    String UserDBId="";
                    String ExtendUserIndex=URLEncoder.encode(request.getParameter("ExtendUserIndex"),"UTF-8").replace("+","%20");
                    if("Y".equalsIgnoreCase(request.getParameter("IsTokenizedAuth"))){
                        String AuthToken = request.getParameter("AuthToken");
                        String IsTokenizedAuth = request.getParameter("IsTokenizedAuth");
                        if(AuthToken!=null && ExtendUserIndex!=null)
                            url=url+"&AuthToken="+AuthToken+"&IsTokenizedAuth="+IsTokenizedAuth+"&ExtendUserIndex="+ExtendUserIndex;
                    }else{
                        UserDBId=URLEncoder.encode(request.getParameter("UserDBId"),"UTF-8").replace("+","%20");
                        if(UserDBId!=null && ExtendUserIndex!=null)
                            url=url+"&UserDBId="+UserDBId+"&ExtendUserIndex="+ExtendUserIndex;
                    }
                    if(request.getParameter("PTId") != null)
                    {
                    String PTId= URLEncoder.encode(request.getParameter("PTId"),"UTF-8").replace("+","%20");
                   if(PTId!=null)
                    url=url+"&PTId="+PTId;
                   if("Y".equalsIgnoreCase(PTId) && request.getParameter("TransactionId") != null)
                   {
                      String TranscationId=URLEncoder.encode(request.getParameter("TransactionId"),"UTF-8").replace("+","%20"); 
                      if(TranscationId != null)
                      {
                          url=url+"&TranscationId="+TranscationId;
                      }
                     }

                }
		}
   }
    if(url.indexOf("?")>0){
        url += "&WD_SID="+sessionToken+"&WD_RID="+requestToken;
    }else{
        url += "?WD_SID="+sessionToken+"&WD_RID="+requestToken;
    }
    if(request.getParameter("navigationPage") != null){
        String navigationPage = URLEncoder.encode(request.getParameter("navigationPage"),"UTF-8").replace("+","%20");
        if(navigationPage!=null)
            url += url.indexOf("?") > 0 ? "&" : "?";
        url += "navigationPage="+navigationPage;
    }
   String isParallelSessionCheck=AppTasks.getValueFromINI("isParallelSessionCheck", request);
   //response.sendRedirect(IFormUtility.removeSpecial(url));
  %>
<!DOCTYPE html>  
<html lang="en">
    <head>
     <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body onload="isParallelCheck();">
        <form name="redirectiform" id="redirectiform" action="<%=url%>" method="post" target="_self">
    <script>
	function isParallelCheck()
        {
            var isCheck=document.getElementById("isParallelSessionCheck").value;
            var callFrom=document.getElementById("callFrom").value;
            if(isCheck==='Y' && (callFrom==="Link" || callFrom==="NewUser"))
            {
                var isParallel=localStorage.getItem('isParallel');
                if(isParallel!==undefined && isParallel!==null && isParallel==="true"){
                    if(window.customParallelError)
                        window.customParallelError();
                    else{    
                        document.getElementById("isParallelSessionCheck").value="N";
                        window.location.href = "components/viewer/portal/error.html";
                        
                    }
                }
                else
                    redirectToApp();
            }
            else
                redirectToApp();
            
        }
	function redirectToApp(){
            var xhttp = new XMLHttpRequest();
            var url ="<%= contextPath %>/components/viewer/portal/appTask.jsp";
            var sessionTkn = "<%= sessionToken %>";
            var requestTkn = "<%= SECCSRFUtil.getNewRequestToken(request, contextPath+"/components/viewer/portal/appTask.jsp") %>";
            xhttp.onload = function() {
            }
            xhttp.open("POST",url, true);
            xhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    localStorage.setItem('isParallel','true');
                    var attributeFrom = window.document.forms["redirectiform"];
                    attributeFrom.submit();
                }
            };
            var dataToSend = "oper=clearSession&WD_SID="+sessionTkn+"&WD_RID="+requestTkn;
            xhttp.send(dataToSend);
	}
    </script>
	<input type="hidden" name="callFrom" id="callFrom" value="<%=callFrom%>"/>
    <input type="hidden" name="isParallelSessionCheck" id="isParallelSessionCheck" value="<%=isParallelSessionCheck%>"/>
  </form>
 </body>
 </html>