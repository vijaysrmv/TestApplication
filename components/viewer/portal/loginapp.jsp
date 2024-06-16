<%@page import="com.newgen.iforms.webapp.AppTasks"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix ="fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<c:set var="appName" value="${fn:substring(contextPath, 1, fn:length(contextPath))}"></c:set>
<jsp:useBean id="encryptionUtil" class="com.newgen.iforms.login.RSAEncryptionUtility" scope="application"></jsp:useBean>
<jsp:useBean id="portalLoginBean" class="com.newgen.iforms.login.PortalLoginBean" scope="request"></jsp:useBean>
<jsp:setProperty name="portalLoginBean" property="request" value="${pageContext.request}"></jsp:setProperty>
<jsp:setProperty name="portalLoginBean" property="response" value="${pageContext.response}"></jsp:setProperty>
<fmt:bundle basename="ifgen">
    <!DOCTYPE html>
    <html>
        <head>
            <link href="${contextPath}/favicon/logo.ico" rel="icon" type="image/x-icon">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Portal Login</title>
            <link type="text/css" rel="stylesheet" href="${contextPath}/components/viewer/resources/bootstrap/css/bootstrap.css">
            <link type="text/css" rel="stylesheet" href="${contextPath}/components/viewer/resources/css/login.css">
            <c:if test="${portalLoginBean.loadAppSpecificCss}">
                <link type="text/css" rel="stylesheet" href="${contextPath}/components/viewer/resources/css/login_${appName}.css">
            </c:if>
            <script src="${contextPath}/components/viewer/resources/bootstrap/js/jquery.min.js"></script>
            <script src="${contextPath}/components/viewer/resources/bootstrap/js/bootstrap.min.js"></script>
            <script src="${contextPath}/components/viewer/resources/scripts/jsencrypt.min.js"></script>
            <script src="${contextPath}/components/viewer/resources/scripts/login.js"></script>
            <c:if test="${portalLoginBean.loadAppSpecificJs}">
                <script src="${contextPath}/components/viewer/resources/scripts/login_${appName}.js"></script>
            </c:if>
            <%--    PWA Changes--%>
            <% boolean isPWA = "Y".equals(AppTasks.getValueFromINI("PWAEnabled", request));%>
            <% String adminLogin = AppTasks.getValueFromINI("AdminLogin", request);%>
            <%--    PWA Changes--%>
            <%if(isPWA){%>
            <%if(request.getParameter("QueryString")!=null && !"".equalsIgnoreCase(request.getParameter("QueryString"))){%>
            <link rel="manifest" id="dynaimcManifest"></link>
            <%} else{ %>
            <link rel="manifest" href="../../../manifest.json" type="application/json"></link>
            <% } %>
            <meta name="apple-mobile-web-app-capable" content="yes"></meta>
            <meta name="apple-mobile-web-app-status-bar-style" content="default"></meta>
            <link rel="apple-touch-icon" sizes="180x180" href="../../../pwalogo/LandMarkMobileApp-apple-touch-icon.png"></link>
            <%}%>
            
            <script>
                var init = '${portalLoginBean.init}';
                var pageDirection = '<fmt:message key="HTML_DIR" />';
                var contextPath = '${contextPath}';
                var appName = '${appName}';
                var bCaptchaAuthentication = ('${portalLoginBean.captchaAuthentication}' === 'true');
                var maxOtpLength = parseInt('${portalLoginBean.maxOtpLength}');
                var resendOtpInterval = parseInt('${portalLoginBean.resendOtpInterval}');
                var renderResendOtp = ('${portalLoginBean.renderOtpResendLink}' === 'true');
                var publicKey = '${encryptionUtil.publicKey}';
                var passwordEncryptFlag = ('${portalLoginBean.passwordEncryptFlag}' === 'true');
                var queryString="<%=request.getParameter("QueryString")%>";
                var adminLogin='<%=adminLogin%>';
            </script>
        </head>
        <body class="bg-color" onload="checkusername('onload');renderCaptchaImage();scheduleResendOtpEnable();focusField()">
            <div class="container-fluid">
                <div class="row" style="height: 100vh;">
                    <div id="leftdiv" class="d-none d-md-none d-lg-flex col-lg-7 col-xl-8" style="padding-left:0px;padding-right:0px;">
                        <div id="imgCont" class="py-4" style="padding-left:50px;">
                            <div id="imgRow" class="row">
                                <img src="${contextPath}/components/viewer/resources/images/background.png" class="imageLeftDiv">
                                <div class="bottomtext">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td class="w-100 text-center">
                                                    <span class="text-footer"><fmt:message key="PRODUCT_BEST_VIEWED_ON"/></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="w-100 text-center">
                                                    <span class="text-footer"><fmt:message key="NEWGEN_COPYRIGHT_TEXT"/></span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="logindiv" class="col-md-12 col-lg-5 col-xl-4" style="padding-left:20px;padding-right:20px;">
                        <div class="py-4 pl-3 pl-md-10">
                            <div class="w-100 loginRightDiv row">
                                <div class="col-12 text-center mt-3">
                                    <img src="${contextPath}/components/viewer/resources/images/ibps.png">
                                </div>
                                <div class="col-12 text-center mt-3">
                                    <label class="login-heading"><fmt:message key="LOGIN"/></label>
                                </div>
                                <form method="post" action="${contextPath}/logincontroller">
                                    <input type="hidden" id="WD_SID" name="WD_SID" value="${portalLoginBean.sessionToken}">
                                    <input type="hidden" id="WD_RID" name="WD_RID" value="${portalLoginBean.requestToken}">
                                    <input type="hidden" id="MFA" name="MFA" value="${portalLoginBean.showMultifactorAuth ? 'Y' : 'N'}">
                                    <input type="hidden" id="FL" name="FL" value="${portalLoginBean.forcedLogin ? 'Y' : 'N'}">
                                    <input type="hidden" id="ResendOtpFlag" name="ResendOtpFlag" value="${portalLoginBean.resendOtpFlag ? 'Y' : 'N'}">
                                    <input type="hidden" id="RenderOtpResendLink" name="RenderOtpResendLink" value="${portalLoginBean.renderOtpResendLink ? 'Y' : 'N'}">
                                    <c:if test="${!portalLoginBean.showMultifactorAuth}">
                                        <div class="col-12 mt-3">
                                            <table class="group inputborder" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td class="w-0 imageborder">
                                                            <img src="${contextPath}/components/viewer/resources/images/userimage.png">
                                                        </td>
                                                        <td class="w-100">
                                                            <input type="text" id="username" name="username" class="inputlogin" onblur="checkusername('blur');" onfocus="checkusername('focus1');" placeholder="UserName" onkeydown="return disCutCopyPasteWrapper(event);" style="width: 99%;" autocomplete="off" value="${portalLoginBean.username}" ${portalLoginBean.forcedLogin ? 'disabled' : ''}>
                                                            <span class="highlight"></span>
                                                            <span class="bar"></span>
                                                            <label id="lbl_username" class="userlabel" style="display: none; top: 5px; font-size: 13px; color: rgb(153, 153, 153);"><fmt:message key="USERNAME" /></label>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="col-12">
                                            <table class="group inputborder" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td class="w-0 imageborder">
                                                            <img src="${contextPath}/components/viewer/resources/images/passimage.png">
                                                        </td>
                                                        <td class="w-100">
                                                            <input type="password" id="password" name="password" class="inputlogin" onblur="checkusername('blur');" onfocus="checkusername('focus2');" placeholder="Password" onkeydown="return disCutCopyPasteWrapper(event);" style="width: 99%;" autocomplete="off" value="${portalLoginBean.password}" ${portalLoginBean.forcedLogin ? 'disabled' : ''}>
                                                            <span class="highlight"></span>
                                                            <span class="bar"></span>
                                                            <label id="lbl_password" class="userlabel" style="display: none; top: 5px; font-size: 13px; color: rgb(153, 153, 153);"><fmt:message key="PASSWORD" /></label>
                                                        </td>
                                                        <td class="w-0 px-2">
                                                            <img src="${contextPath}/components/viewer/resources/images/revealcred.png" style="width: 25px;height: 25px;" onclick="toggleViewPassword(this, 'password');return false;">
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <c:if test="${portalLoginBean.captchaAuthentication}">
                                            <div class="col-12">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td class="w-40 captchabg">
                                                                <img id="imgcaptcha" src="" style="width: 90px;height: 32px;">
                                                            </td>
                                                            <td class="w-10 text-center">
                                                                <img id="btnRefreshCaptcha" src="${contextPath}/components/viewer/resources/images/refresh1.png" onclick="renderCaptchaImage();return false;" style="width: 15px; height: 15px; cursor: pointer;">
                                                            </td>
                                                            <td class="w-50">
                                                                <table class="group inputborder" border="0" cellpadding="0" cellspacing="0" style="margin-bottom:0px !important;" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td class="w-100 imageborder">
                                                                                <input type="text" id="captcha" name="captcha" class="inputlogin" onblur="checkusername('blur');" onfocus="checkusername('focus3');" onkeydown="return disCutCopyPasteWrapper(event);" style="width: 99%; letter-spacing: 0.6em; top: 5px; left: 15px; font-size: 13px; color: rgb(153, 153, 153); display: inline;" spellcheck="false" autocomplete="off" value="${portalLoginBean.captcha}" ${portalLoginBean.forcedLogin ? 'disabled' : ''}>
                                                                                <span class="highlight"></span>
                                                                                <span class="bar"></span>
                                                                                <label id="lbl_captcha" class="userlabel" style="left: 15px;"><fmt:message key="CAPTCHA" /></label>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:if>
                                        <div class="col-12 mt-1 text-end">
                                            <label class="forgot-password-label-style" onclick="forgetPassword();return false;" style="display: ${portalLoginBean.forcedLogin ? 'none' : ''}">Forgot Password</label>
                                        </div>
                                    </c:if>
                                    <c:if test="${portalLoginBean.showMultifactorAuth}">
                                        <div class="col-12 text-center mt-3">
                                            <label class="login-heading" style="border: none;"><fmt:message key="LABEL_TWO_FACTOR_AUTH"/></label>
                                        </div>
                                        <div style="margin-top: 15px;">
                                            <span class="${portalLoginBean.otpMessageCssClassName}" style="width: 100%;">${portalLoginBean.otpMessage}</span>
                                            <table class="group inputborder" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td class="w-0 imageborder">
                                                            <img src="${contextPath}/components/viewer/resources/images/cabinetimage.png">
                                                        </td>
                                                        <td class="w-100">
                                                            <input type="password" id="inputOtp" name="inputOtp" onblur="checkusername('blur');" onfocus="checkusername('focus4');" onkeydown="limitOtpLength();return disCutCopyPasteWrapper(event);" onkeyup="limitOtpLength();" style="width: 99%;letter-spacing: 0.6em" class="inputlogin" value="${portalLoginBean.otp}">
                                                            <span class="highlight"></span>
                                                            <span class="bar"></span>
                                                            <label id="inputOtpLabel" class="userlabel">OTP</label>
                                                        </td>
                                                        <td class="w-0 px-2">
                                                            <img src="${contextPath}/components/viewer/resources/images/revealcred.png" style="width: 25px;height: 25px;" onclick="toggleViewPassword(this, 'inputOtp');return false;">
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td class="w-50 text-start">
                                                            <label class="forgot-password-label-style" onclick="redirectToLoginPage();return false;"><fmt:message key="NOT" /> ${portalLoginBean.username}?</label>
                                                        </td>
                                                        <td class="w-50 text-end">
                                                            <label id="linkResendOtp" onclick="resendOtpClick();return false;" class="forgot-password-label-style" style="display: none;"><fmt:message key="LABEL_RESEND_OTP" /></label>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <div class="col-12 mt-3 ${portalLoginBean.errorFlag ? '' : 'mb-3'}">
                                        <input type="submit" id="loginbtn" value="<fmt:message key="LOGIN" />" class="loginbuttonstyle" onclick="return handleLoginClick();" style="display: ${portalLoginBean.forcedLogin ? 'none' : 'inline'};">
                                    </div>
                                    <c:if test="${portalLoginBean.errorFlag}">
                                        <div class="col-12 mt-2 mb-3">
                                            <table class="errorDiv" cellpadding="0" cellspacing="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td class="w-100">
                                                            <span class="messagediv" style="width: 100%">${portalLoginBean.errorMessage}</span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <c:if test="${portalLoginBean.forcedLogin}">
                                        <div class="col-12 mt-2 mb-3">
                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td class="w-50 pe-2">
                                                            <input type="submit" id="contloginbtn" onclick="return forcedLogin('Y');" class="loginbuttonstyle" value="<fmt:message key="YES" />">
                                                        </td>
                                                        <td class="w-50 ps-2">
                                                            <input type="submit" id="cancelloginbtn" onclick="return forcedLogin('N');" class="loginbuttonstyle" value="<fmt:message key="NO" />">
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <div class="col-12 text-center mb-3">
                                        <img src="${contextPath}/components/viewer/resources/images/newgenlogo.gif">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                    <%--    PWA Changes--%>
            <%if(isPWA){%>
                <script src="${contextPath}/pwa/firebase-app.js"></script>
                <script src="${contextPath}/pwa/firebase-messaging.js"></script>
                <script src="${contextPath}/pwa/configuration.js"></script>
		<script src="${contextPath}/pwa/firebase-sw-init.js"></script>
            <%}%>
        </body>
    </html>
</fmt:bundle>
