var gPopupMask = null;
var w = null;
var remainingSecs = 0;
function initTimerPopupDiv() {
    var url = '../../components/viewer/timerpopup.jsf';
    var ajaxReq = new XMLHttpRequest();
    var htmlString;
    ajaxReq.open("POST",  url, true);
    ajaxReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    ajaxReq.onreadystatechange = function() {
        if (ajaxReq.readyState == 4 && ajaxReq.status == 200) {
            var beginIndex = htmlString.indexOf('<body>');
            var endIndex = htmlString.lastIndexOf('</body>');
            if(beginIndex != -1 && endIndex != -1 && endIndex > beginIndex+6) {
                htmlString = htmlString.substring(beginIndex+6, endIndex);
            }
                
            if(htmlString.indexOf("bpanel") != -1) {
                var timerDiv = document.createElement('div');
                timerDiv.setAttribute("id", "TimerDiv");
                timerDiv.className = "iframeShadow";
                timerDiv.style.zIndex = "50001";
                timerDiv.style.display = "none";
                timerDiv.style.position="absolute";
                timerDiv.innerHTML = sanitize(htmlString);
                document.body.appendChild(timerDiv);
            }
                
            var oapWinRef = null;
            try {
                oapWinRef = getOAPWindowRef();
            } catch(ex) {
                oapWinRef = null;
            }
            if(oapWinRef != null) {
                oapWinRef.addToOAPSessionTimer(window);
            }
        }
    }
    ajaxReq.send();
}

function showSessionPopUp(height, width, remainingTime) {
    var ParentDocWidth = document.body.clientWidth;
    var ParentDocHeight = document.documentElement.clientHeight;
    var IFrameTop = ParentDocHeight / 2 - height / 2;
    var IFrameLeft = ParentDocWidth / 2 - width / 2;
    try {
        var timerDiv = document.getElementById('TimerDiv');
        if (typeof timerDiv != 'undefined' && timerDiv != null) {
            timerDiv.style.width = width + "px";
            timerDiv.style.height = height + "px";
            timerDiv.style.left = IFrameLeft + "px";
            timerDiv.style.top = IFrameTop + "px";
            timerDiv.style.display = "block";
            
            startTimer(remainingTime);
        }
    } catch (ex) {
    }
}

function setPopupMask() {
    var isSafari = false;
    if (navigator.userAgent.indexOf("Safari") != -1) {
        isSafari = true;
    }
    var isChrome = window.chrome;

    if (gPopupMask == null) {
        initPopUp();
    }

    if (gPopupMask != null) {
        gPopupMask.style.display = "block";
        if (typeof isChrome != 'undefined' && !isChrome && isSafari) {
            gPopupMask.style.height = (screen.height + window.document.documentElement.clientHeight) + "px";
        } else {
            gPopupMask.style.height = window.document.documentElement.scrollHeight + "px";
        }
        gPopupMask.style.width = document.documentElement.clientWidth + "px";
    }
}

function initPopUp() {
    if (gPopupMask == null) {
        var theBody = document.getElementsByTagName('BODY')[0];
        var popmask = document.createElement('div');
        popmask.id = 'popupMask';
        theBody.appendChild(popmask);
        gPopupMask = document.getElementById("popupMask");
        gPopupMask.style.display = "none";
        gPopupMask.style.position = "absolute";
        gPopupMask.style.zIndex = "50000";
        gPopupMask.style.top = "0px";
        gPopupMask.style.left = "0px";
        gPopupMask.style.width = "100%";
        gPopupMask.style.height = "100%";
        gPopupMask.style.opacity = "0.4";
        gPopupMask.style.filter = "alpha(opacity=40)";
        gPopupMask.style.backgroundColor = "#d8dce0";
        gPopupMask.onmouseup = function (event) {
            event.stopPropagation();
            event.preventDefault();
            return false;
        }
    }
}

function hidePopupMask() {
    if (gPopupMask != null) {
        gPopupMask.style.display = "none";
    }
}

function showSessionTimer(remainingtime) {
    sessionExpireWarnVisible = true;
    setPopupMask();
    showSessionPopUp(160, 380, remainingtime);
}

function hideSessionTimer() {
    hidePopupMask();
    closeTimer();
    sessionExpireWarnVisible = false;
}

function closeTimer(){
    stopTimer();
    var timerDiv = document.getElementById("TimerDiv");
    if (typeof timerDiv != 'undefined' && timerDiv != null) {
        timerDiv.style.display = "none";
    }
    var crminutes = document.getElementById('crminutes');
    if (typeof crminutes != 'undefined' && crminutes != null) {
        crminutes.innerHTML = "";
    }
    var crseconds = document.getElementById('crseconds');
    if (typeof crseconds != 'undefined' && crseconds != null) {
        crseconds.innerHTML = "";
    }
}

function startTimer(seconds) {
    stopTimer();
    var mins, secs;
    if (typeof(Worker) !== "undefined") {
        if (w == null){
            w = new Worker("../../components/viewer/resources/scripts/timerworker.js");
        }
        w.postMessage(seconds);
        w.onmessage = function (event) {
            remainingSecs = parseInt(event.data);
            mins = Math.floor(remainingSecs / 60);
            secs = remainingSecs - Math.round(mins *60);
            updateTimerDiv(mins, secs);
        };
    }
}

function stopTimer() {
    if(w != null) {
        w.terminate();
        w = null;
    }
}

function updateTimerDiv(mins, secs) {
    if(remainingSecs <= 0) {
        stopTimer();
        sessionTimeChecker();
        return;
    }
    
    var minutes1 = document.getElementById("crminutes");
    var seconds1 = document.getElementById("crseconds");
    if (typeof minutes1 != 'undefined' && typeof seconds1 != 'undefined') {        
        if (remainingSecs < 59) {
            seconds1.innerHTML  = secs;
        } else {                                    
            minutes1.innerHTML  = mins;
            seconds1.innerHTML  = secs;
        }
    }
}

function getTimerInSeconds(){
    return remainingSecs;
}

function extendWebSession() {
    extendTimeYesClick();
}