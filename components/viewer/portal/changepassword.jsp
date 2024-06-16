<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix ="fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<c:set var="appName" value="${fn:substring(contextPath, 1, fn:length(contextPath))}"></c:set>
<jsp:useBean id="encryptionUtil" class="com.newgen.iforms.login.RSAEncryptionUtility" scope="application"></jsp:useBean>
<jsp:useBean id="portalChangePasswordBean" class="com.newgen.iforms.login.PortalChangePasswordBean" scope="request"></jsp:useBean>
<jsp:setProperty name="portalChangePasswordBean" property="request" value="${pageContext.request}"></jsp:setProperty>
<jsp:setProperty name="portalChangePasswordBean" property="response" value="${pageContext.response}"></jsp:setProperty>
<fmt:bundle basename="ifgen">
    <!DOCTYPE html>
    <html>
        <head>
            <link href="${contextPath}/favicon/logo.ico" rel="icon" type="image/x-icon">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title><fmt:message key="LABEL_CHANGE_PASSWORD" /></title>
            <link type="text/css" rel="stylesheet" href="${contextPath}/components/viewer/resources/css/login.css">
            <script src="${contextPath}/components/viewer/resources/scripts/jsencrypt.min.js"></script>
            <script src="${contextPath}/components/viewer/resources/scripts/login.js"></script>
            <script>
                var init = '${portalChangePasswordBean.init}';
                var publicKey = '${encryptionUtil.publicKey}';
                var passwordEncryptFlag = ('${portalChangePasswordBean.passwordEncryptFlag}' === 'true');

                function setOpr(val) {
                    document.getElementById('opr').value = val;
                }

                function doInit() {

                }
            </script>
        </head>
        <body class="bg-color" onload="doInit();">
            <div class="cpMainDiv">
                <div class="cpCardStyle">
                    <div style="display: ${portalChangePasswordBean.passwordChangeSuccess ? 'none' : 'inline'}">
                        <form action="${contextPath}/changepassword" method="post">
                            <input type="hidden" name="CabinetName" value="${portalChangePasswordBean.cabinetName}">
                            <input type="hidden" name="Type" value="${portalChangePasswordBean.oprType}">
                            <input type="hidden" name="ServerType" value="${portalChangePasswordBean.appServerType}">
                            <input type="hidden" name="DataBaseType" value="${portalChangePasswordBean.databaseType}">
                            <input type="hidden" name="Encoding" value="${portalChangePasswordBean.encoding}">
                            <input type="hidden" name="UserName" value="${portalChangePasswordBean.userName}">
                            <input type="hidden" name="UserIndex" value="${portalChangePasswordBean.userIndex}">
                            <input type="hidden" name="encryption" value="${portalChangePasswordBean.passwordEncryptFlag ? 'Y' : 'N'}">
                            <input type="hidden" name="entryID" value="${portalChangePasswordBean.currentPassword}">
                            <input type="hidden" id="opr" name="opr">
                            <div style="width: 100%;text-align: center;">
                                <img src="${pageContext.request.contextPath}/components/viewer/resources/images/ibps.png">
                            </div>
                            <h4 class="cpFormTitle">
                                <fmt:message key="LABEL_CHANGE_PASSWORD" />
                            </h4>
                            <div class="cpInputDiv">
                                <label class="cpInputLabel" style="font-weight: bold">${portalChangePasswordBean.redirectMessage}</label>
                            </div>
                            <c:if test="${portalChangePasswordBean.errorFlag}">
                                <div class="cpInputDiv">
                                    <table class="errorDiv" cellpadding="0" cellspacing="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td style="width: 100%;">
                                                    <span class="messagediv" style="width: 100%">${portalChangePasswordBean.errorMessage}</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                            <div class="cpInputDiv">
                                <label class="cpInputLabel"><fmt:message key="LABEL_LOGGED_IN_USER" />: ${portalChangePasswordBean.userName}</label>
                            </div>
                            <div class="cpInputDiv">
                                <label class="cpInputLabel" for="oldpassword"><fmt:message key="LABEL_OLD_PASSWORD" /></label>
                                <input class="cpInput" type="password" id="oldpassword" name="oldpassword">
                            </div>
                            <div class="cpInputDiv">
                                <label class="cpInputLabel" for="password"><fmt:message key="LABEL_NEW_PASSWORD" /></label>
                                <input class="cpInput" type="password" id="password" name="password">
                            </div>
                            <div class="cpInputDiv">
                                <label class="cpInputLabel" for="confirmPassword"><fmt:message key="LABEL_CONFIRM_PASSWORD" /></label>
                                <input class="cpInput" type="password" id="confirmPassword" name="confirmPassword">
                            </div>
                            <div class="cpInputDiv" style="flex-direction: row; margin-top: 15px;">
                                <input class="loginbuttonstyle" type="submit" style="margin-right: 5px;" value="<fmt:message key="SAVE" />" onclick="setOpr('save');
                                        return encryptFields();">
                                <input class="loginbuttonstyle" type="submit" style="margin-left: 5px;" value="<fmt:message key="CLOSE" />" onclick="setOpr('close');${portalChangePasswordBean.oprType eq 'UCP' ? 'window.close();return false;' : 'return true;'}">
                            </div>
                        </form>
                    </div>
                    <div style="display: ${portalChangePasswordBean.passwordChangeSuccess ? 'inline' : 'none'}">
                        <div style="width: 100%;text-align: center;">
                            <img src="${pageContext.request.contextPath}/components/viewer/resources/images/greentick.png">
                        </div>
                        <h4 class="cpFormTitle">
                            <fmt:message key="PASSWORD_CHANGED" />
                        </h4>
                        <h6 class="cpFormTitle">
                            <fmt:message key="PASSWORD_CHANGED_SUCCESSFULLY" />
                        </h6>
                        <div style="width: 100%;text-align: center;">
                            <input class="loginbuttonstyle" type="button" value="<fmt:message key="CLOSE" />" onclick="window.close();return false;" style="width: 130px;">
                        </div>
                    </div>
                </div>
            </div>
        </body>
    </html>
</fmt:bundle>