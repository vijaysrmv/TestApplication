var timerStart = true;
this.onmessage = function(e) {
    this.remainingTime = e.data * 1000;
}

function myTimer(d0) {
    var d = (new Date()).valueOf();
    var diff = this.remainingTime - (d-d0);
    if(diff <= 0) {
        diff = 0;
    }
    postMessage(Math.floor(diff/1000));
}

if (timerStart) {
    var d0 = (new Date()).valueOf();
    setInterval(function () {
        myTimer(d0);
    }, 1000);
    timerStart = false;
}