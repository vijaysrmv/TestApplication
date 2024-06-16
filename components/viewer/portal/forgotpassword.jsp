<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix ="fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<jsp:useBean id="resetPasswordBean" class="com.newgen.iforms.login.PortalResetPasswordBean" scope="request"></jsp:useBean>
<jsp:setProperty name="resetPasswordBean" property="request" value="${pageContext.request}"></jsp:setProperty>
<jsp:setProperty name="resetPasswordBean" property="response" value="${pageContext.response}"></jsp:setProperty>
<fmt:bundle basename="ifgen">
    <!DOCTYPE html>
    <html>
        <head>
            <link href="${contextPath}/favicon/logo.ico" rel="icon" type="image/x-icon">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title><fmt:message key="LABEL_FORGOT_PASSWORD" /></title>
            <link type="text/css" rel="stylesheet" href="${contextPath}/components/viewer/resources/css/login.css">
            <script src="${contextPath}/components/viewer/resources/scripts/login.js"></script>
            <script>
                var init = '${resetPasswordBean.init}';
                var contextPath = '${contextPath}';
            </script>
        </head>
        <body class="bg-color">
            <div class="cpMainDiv">
                <div class="cpCardStyle">
                    <form action="${contextPath}/resetpassword" method="post">
                        <div style="width: 100%;text-align: center;">
                            <img src="${pageContext.request.contextPath}/components/viewer/resources/images/ibps.png">
                        </div>
                        <h4 class="cpFormTitle">
                            <fmt:message key="LABEL_FORGOT_PASSWORD" />
                        </h4>
                        <div class="cpInputDiv">
                            <label class="cpInputLabel" style="font-weight: bold">${resetPasswordBean.redirectMessage}</label>
                        </div>
                        <c:if test="${resetPasswordBean.errorFlag}">
                            <div class="cpInputDiv">
                                <table class="errorDiv" cellpadding="0" cellspacing="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td style="width: 100%;">
                                                <span class="messagediv" style="width: 100%">${resetPasswordBean.errorMessage}</span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${resetPasswordBean.successFlag}">
                            <div class="cpInputDiv">
                                <label class="cpInputLabel" style="font-weight: bold">${resetPasswordBean.errorMessage}</label>
                            </div>
                        </c:if>
                        <div class="cpInputDiv">
                            <label class="cpInputLabel" for="username"><fmt:message key="USER_NAME" /></label>
                            <input class="cpInput" type="text" id="username" name="username" value="${resetPasswordBean.userName}">
                        </div>
                        <div class="cpInputDiv">
                            <label class="cpInputLabel" for="emailId"><fmt:message key="LABEL_EMAIL_ID" /></label>
                            <input class="cpInput" type="text" id="emailId" name="emailId" value="${resetPasswordBean.emailId}">
                        </div>
                        <div class="cpInputDiv" style="flex-direction: row; margin-top: 15px;">
                            <input class="loginbuttonstyle" type="submit" style="margin-right: 5px;" value="<fmt:message key="RESET" />">
                            <input class="loginbuttonstyle" type="submit" style="margin-left: 5px;" value="<fmt:message key="CLOSE" />" onclick="window.close();return false;">
                        </div>
                    </form>
                </div>
            </div>
        </body>
    </html>
</fmt:bundle>