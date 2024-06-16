<%@page import="java.util.ResourceBundle"%>
<%@page import="com.newgen.iforms.util.IFormUtility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>  
<%
    ResourceBundle lbls = ResourceBundle.getBundle("ifgen",request.getLocale());
    ResourceBundle lblsErr = ResourceBundle.getBundle("iferror", request.getLocale());
    String strErrorCode = request.getParameter("errorCode");

    String strErrMsg = lbls.getString("SESSION_EXPIRED");
    if ("7006".equals(strErrorCode) || "11".equals(strErrorCode)) {
        try {
            strErrMsg = lblsErr.getString(strErrorCode);
            session.invalidate();
        } catch (Exception e) {
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <% String pageCode = IFormUtility.escapeHtml4(request.getParameter("page"));
         if (pageCode.equals("101")) { %>
            <title>Session Invalid Page</title>
        <% } else if (pageCode.equals("100")) { %>
            <title>Error Page</title>
        <% } else { %>
            <title>Not Found</title>
        <% }%>
        <style>
            .labelbluebold {
                font: bold 11pt Arial ;
                color: #0072c6;
             }  
        </style>
        <script>
            var context='<%=request.getContextPath()%>';
            function getContextPath() {
                return context;
            }
            function redirectToApplication(){
                if(window.parent.customLogoutHandler){
                    window.parent.customLogoutHandler();
                }else{
                    //var url=window.location.toString().split('/')[0]+"//"+window.location.toString().split('/')[2]+"/"+window.location.toString().split('/')[3];
                    window.location.href=getContextPath();
                }
            }
        </script>
    </head>
    <body>
        <% if (pageCode.equals("101")) { %>
            <div style="display:flex;justify-content: center;align-items: center;" style="padding-top: 10.5%;">
                <table>
                    <thead>
                       <th>                    
                       </th>
                   </thead>
                   <tbody>
                       <tr>
                           <td>
                              <h4 class="labelbluebold" style="text-align:center;"><span style="color:red"><%=strErrMsg%></span></h4>
                           </td>
                       </tr>
                       <tr>
                            <td>
                              <h5 style="text-align:center;"><b><a onclick="redirectToApplication()" style="cursor: pointer;text-decoration: underline;"><%= lbls.getString("CLICK_HERE")%></a></b> <%= lbls.getString("LOGIN_AGAIN")%></h5>
                            </td>
                       </tr>
                    </tbody>
                </table>
            </div> 
        <% } else if (pageCode.equals("100")) { %>
             <div style="text-align: center" style="padding-top: 10.5%;">
                <h3>An error has occurred due to some reason. Kindly contact system administrator.</h3>
                <h5 style="text-align:center;"><b><a onclick="redirectToApplication()" style="cursor: pointer;text-decoration: underline;"><%= lbls.getString("CLICK_HERE")%></a></b> <%= lbls.getString("LOGIN_AGAIN")%></h5>     
            </div>
        <% } else { %>
            <div style="text-align: center" style="padding-top: 10.5%;">
                <h3>The page you requested is not found</h3>
                <h5 style="text-align:center;"><b><a onclick="redirectToApplication()" style="cursor: pointer;text-decoration: underline;"><%= lbls.getString("CLICK_HERE")%></a></b> <%= lbls.getString("LOGIN_AGAIN")%></h5> 
            </div>
        <% }%>
    </body>
</html>
