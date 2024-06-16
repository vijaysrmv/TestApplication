function focusField() {
    var inputUsernameRef = document.getElementById("username");
    var inputOtpRef = document.getElementById("inputOtp");
    var btnContLogin = document.getElementById('contloginbtn');
    
    if(typeof inputUsernameRef != 'undefined' && inputUsernameRef != null && inputUsernameRef.style.display != 'none') {
        inputUsernameRef.focus();
    } else if(typeof inputOtpRef != 'undefined' && inputOtpRef != null && inputOtpRef.style.display != 'none') {
        inputOtpRef.focus();
    } else if(typeof btnContLogin != 'undefined' && btnContLogin != null && btnContLogin.style.display != 'none') {
        btnContLogin.focus();
    }
}

function checkusername(data) {
    var inputUsernameRef = document.getElementById("username");
    var labelUsernameRef = document.getElementById('lbl_username');
    var inputPasswordRef = document.getElementById("password");
    var labelPasswordRef = document.getElementById("lbl_password");
    var inputCaptchaRef = document.getElementById("captcha");
    var labelCaptchaRef = document.getElementById('lbl_captcha');
    var inputOtpRef = document.getElementById("inputOtp");
    var labelOtpRef = document.getElementById('inputOtpLabel');
    inputUsernameRef.placeholder=labelUsernameRef.innerHTML;
    inputPasswordRef.placeholder=labelPasswordRef.innerHTML;
    if (data == "blur" || data == "onload") {
        if (typeof inputUsernameRef != 'undefined' && inputUsernameRef != null && typeof labelUsernameRef != 'undefined' && labelUsernameRef != null) {
            if (inputUsernameRef.value.length != 0 || document.activeElement.id == "username") {
               // labelUsernameRef.style.display = "none";
            } else {
               /* labelUsernameRef.style.top = "5px";
                labelUsernameRef.style.fontSize = "13px";
                labelUsernameRef.style.color = '#999';
                labelUsernameRef.style.display = "inline";*/
            }
            //inputUsernameRef.setAttribute("readonly", true);
        }

        if (typeof inputPasswordRef != 'undefined' && inputPasswordRef != null && typeof labelPasswordRef != 'undefined' && labelPasswordRef != null) {
            if (inputPasswordRef.value.length != 0 || document.activeElement.id == "password") {
                //labelPasswordRef.style.display = "none";
            } else {
                /*labelPasswordRef.style.top = "5px";
                labelPasswordRef.style.fontSize = "13px";
                labelPasswordRef.style.color = '#999';
                labelPasswordRef.style.display = "inline";*/
            }
            //inputPasswordRef.setAttribute("readonly", true);
        }

        if (bCaptchaAuthentication) {
            if (typeof inputCaptchaRef != 'undefined' && inputCaptchaRef != null && typeof labelCaptchaRef != 'undefined' && labelCaptchaRef != null) {
                if (inputCaptchaRef.value.length != 0 || document.activeElement.id == "captcha") {
                    labelCaptchaRef.style.display = "none";
                    inputCaptchaRef.spellcheck = false;
                } else {
                    if (pageDirection.toLowerCase() == 'rtl') {
                        labelCaptchaRef.style.top = "7px";
                        labelCaptchaRef.style.right = "15px";
                    } else {
                        labelCaptchaRef.style.top = "5px";
                        labelCaptchaRef.style.left = "15px";
                    }
                    labelCaptchaRef.style.fontSize = "13px";
                    labelCaptchaRef.style.color = '#999';
                    labelCaptchaRef.style.display = "inline";
                }
                //inputCaptchaRef.setAttribute("readonly", true);
            }
        }

        if (typeof inputOtpRef != 'undefined' && inputOtpRef != null && typeof labelOtpRef != 'undefined' && labelOtpRef != null) {
            if (inputOtpRef.value.length != 0 || document.activeElement.id == "inputOtp") {
                labelOtpRef.style.display = "none";
            } else {
                labelOtpRef.style.top = "5px";
                labelOtpRef.style.fontSize = "13px";
                labelOtpRef.style.color = '#999';
                labelOtpRef.style.display = "inline";
            }
            //inputOtpRef.setAttribute("readonly", true);
        }
    }

    if (data == "focus1") {
        /*if (typeof labelUsernameRef != 'undefined' && labelUsernameRef != null) {
           // labelUsernameRef.style.display = "none";
        }*/
        //inputUsernameRef.removeAttribute("readonly");
    } else if (data == "focus2") {
           /*if (typeof labelPasswordRef != 'undefined' && labelPasswordRef != null) {
            labelPasswordRef.style.display = "none";
        }*/
        //inputPasswordRef.removeAttribute("readonly");
    } else if (data == "focus3" && bCaptchaAuthentication) {
        if (typeof labelCaptchaRef != 'undefined' && labelCaptchaRef != null) {
            labelCaptchaRef.style.display = "none";
        }
        //inputCaptchaRef.removeAttribute("readonly");
    } else if (data == "focus4") {
        if (typeof labelOtpRef != 'undefined' && labelOtpRef != null) {
            labelOtpRef.style.display = "none";
        }
        //inputOtpRef.removeAttribute("readonly");
    }
}

function disCutCopyPasteWrapper(e) {
    var keyCode = e.keyCode || e.charCode;
    var flag1 = checkSpecialChar(e);
    if (!flag1) {
        return false;
    }
    var flag = disCutCopyPaste(e);
}

function checkSpecialChar(event) {
    /**
     * 
     * This function is given to check special charaters in username on login page.
     * By default this function returns true which means special characters are allowed in username on login page.
     */

    /**
     var keyCode = event.which || event.keyCode;
     if (keyCode == 16 || keyCode == 8 || keyCode == 13 || keyCode == 37 || keyCode == 39) {
     return true;
     }
     
     if (event.shiftKey && keyCode >= 48 && keyCode <= 57) {
     event.preventDefault();
     return false;
     }
     
     if ((keyCode >= 48 && keyCode <= 90)) {
     return true;
     } else {
     event.preventDefault();
     return false;
     }
     */
    return true;
}

function checkPasswordLength(event) {
    /**
     * 
     * This function is given to password length on login page.
     * By default this function returns true.
     */


    /**
     if(document.getElementById('password').value.length > 20){   
     event.preventDefault();
     return false;
     }
     */
    return true;
}

function disCutCopyPaste(e) {
    var keyCode = e.keyCode || e.charCode;
    var flagpwd = checkPasswordLength(e);
    if (!flagpwd) {
        //customAlert(PASSWORD_LENGTH);
        return false;
    }
    if (e.ctrlKey && (keyCode == '67' || keyCode == '86' || keyCode == '88')) {
        e.preventDefault();
        return false;
    } else {
        return true;
    }
}

function renderCaptchaImage() {
    if (bCaptchaAuthentication) {
        var ref = document.getElementById('imgcaptcha');
        var fl = document.getElementById('FL').value === 'Y';
        if (ref) {
            if (fl) {
                ref.src = "";
                ref.style.display = 'none';
            } else {
                ref.src = contextPath + '/getcaptcha?rid=' + Math.random();
                ref.style.display = 'inline';
            }
        }

        ref = document.getElementById('captcha');
        if (ref) {
            ref.value = '';
        }
    }
}

function toggleViewPassword(ref, id) {
    var inputPasswordRef = document.getElementById(id);
    if (typeof ref != 'undefined' && ref != null) {
        if (ref.src.indexOf('revealcred.png') != -1) {
            inputPasswordRef.type = 'text';
            ref.src = contextPath + '/components/viewer/resources/images/maskcred.png';
        } else if (ref.src.indexOf('maskcred.png') != -1) {
            inputPasswordRef.type = 'password';
            ref.src = contextPath + '/components/viewer/resources/images/revealcred.png';
        }
    }
}

function limitOtpLength() {
    var inputOtpRef = document.getElementById("inputOtp");
    if (typeof inputOtpRef != 'undefined' && inputOtpRef != null) {
        if (maxOtpLength > 0 && inputOtpRef.value.length >= maxOtpLength) {
            inputOtpRef.value = inputOtpRef.value.substr(0, maxOtpLength);
        }
    }
}

function forcedLogin(action) {
    if (action == 'N') {
        window.location.href = contextPath + '/components/viewer/portal/loginapp.jsp';
        return false;
    } else if (action == 'Y') {
        return true;
    }
}

var resendOtpTimerId;
function scheduleResendOtpEnable() {
    var mfa = document.getElementById("MFA").value === 'Y';
    if (mfa && renderResendOtp) {
        if (resendOtpTimerId) {
            clearTimeout(resendOtpTimerId);
        }
        resendOtpTimerId = setTimeout(enableResendOtpLink, resendOtpInterval * 1000);
    }
}

function enableResendOtpLink() {
    var linkResendOtp = document.getElementById("linkResendOtp");
    if (typeof linkResendOtp != 'undefined' && linkResendOtp != null) {
        linkResendOtp.style.display = '';
    }
}

function disableResendOtpLink() {
    var linkResendOtp = document.getElementById("linkResendOtp");
    if (typeof linkResendOtp != 'undefined' && linkResendOtp != null) {
        linkResendOtp.style.display = 'none';
    }
}

function redirectToLoginPage() {
    window.location.href = contextPath + '/components/viewer/portal/loginapp.jsp';
}

function resendOtpClick() {
    document.getElementById('ResendOtpFlag').value = 'Y';
    document.forms[0].submit();
}

function encryptData(data, publicKey) {
    var RSAEncrypt = new JSEncrypt();
    RSAEncrypt.setPublicKey(publicKey);
    var encryptedData = RSAEncrypt.encrypt(data);
    return encryptedData;
}

function handleLoginClick() {
    var mfa = document.getElementById("MFA").value === 'Y';
    if (!mfa) {
        var encryptedVal;
        var inputPasswordRef = document.getElementById("password");
        if (typeof inputPasswordRef != 'undefined' && inputPasswordRef != null) {
            var pwd = inputPasswordRef.value;
            if (pwd.length > 0) {
                if (passwordEncryptFlag) {
                    try {
                        encryptedVal = encryptData(pwd, publicKey);
                    } catch (e) {
                        console.log(e);
                        return false;
                    }
                } else {
                    encryptedVal = pwd;
                }
                inputPasswordRef.value = encodeURIComponent(encryptedVal).replace(/\+/g, "%20");
            }
        }
    }
    return true;
}

function encryptFields() {
    if (passwordEncryptFlag) {
        try {
            var encryptedVal;
            var inputOldPasswordRef = document.getElementById("oldpassword");
            if (typeof inputOldPasswordRef != 'undefined' && inputOldPasswordRef != null) {
                var oldpwd = inputOldPasswordRef.value;
                if (oldpwd.length > 0) {
                    try {
                        encryptedVal = encryptData(oldpwd, publicKey);
                    } catch (e) {
                        console.log(e);
                        return false;
                    }
                    inputOldPasswordRef.value = encodeURIComponent(encryptedVal).replace(/\+/g, "%20");
                }
            }
            
            var inputNewPasswordRef = document.getElementById("password");
            if (typeof inputNewPasswordRef != 'undefined' && inputNewPasswordRef != null) {
                var newpwd = inputNewPasswordRef.value;
                if (newpwd.length > 0) {
                    try {
                        encryptedVal = encryptData(newpwd, publicKey);
                    } catch (e) {
                        console.log(e);
                        return false;
                    }
                    inputNewPasswordRef.value = encodeURIComponent(encryptedVal).replace(/\+/g, "%20");
                }
            }
            
            var inputConfirmPasswordRef = document.getElementById("confirmPassword");
            if (typeof inputConfirmPasswordRef != 'undefined' && inputConfirmPasswordRef != null) {
                var confpwd = inputConfirmPasswordRef.value;
                if (confpwd.length > 0) {
                    try {
                        encryptedVal = encryptData(confpwd, publicKey);
                    } catch (e) {
                        console.log(e);
                        return false;
                    }
                    inputConfirmPasswordRef.value = encodeURIComponent(encryptedVal).replace(/\+/g, "%20");
                }
            }
        } catch (e) {
            console.log(e);
            return false;
        }
    }
    return true;
}

function forgetPassword() {
    var url = contextPath + '/components/viewer/portal/forgotpassword.jsp';
    var features = 'top=100,left=350,height=450,width=600,toolbar=no,menubar=no,status=yes,scrollbars=no';
    window.open(url, 'ForgotPassword', features);
}