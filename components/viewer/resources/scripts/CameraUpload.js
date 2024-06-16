var cid,dtype,docBodyDiv;
var mobilePattern=/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i;

function openCameraDiv(event){
    var isMobile = checkIsMobile(mobilePattern);
    var w=window.innerWidth;
    var h=window.innerHeight;
    dtype=$(event.target).closest('.doc-unit-header')[0].firstElementChild.firstElementChild.id;
    if(dtype=='' || dtype === undefined || dtype === 'undefined'){  
        dtype=$($(event.target).closest('.doc-unit-header')[0].firstElementChild).find("p").prop("id");
    }
    cid=jQuery($(event.target).closest(".doc-list-wrapper"))[0].firstElementChild.children[1].id;
    docBodyDiv=jQuery($(event.target).closest(".doc-unit-header")).siblings(".doc-unit-body")[0];
    var divRef=document.getElementById('cameraViewer');
    divRef.style.width= (w) + "px";
    divRef.style.height=(h - 100) + "px";
    divRef.style.top= ((h-(h-120))/2) + "px";
    divRef.style.display="block";
    var videoRef= document.getElementById('videoShower');
    videoRef.style.width="100%";
    videoRef.style.height="90%";
    if(!isMobile){
        videoRef.style.left = "10%";
    }
    videoRef.style.display="block";
    var videoPlayerRef = document.getElementById('videoPlayer');
    if(videoPlayerRef) {
     videoPlayerRef.style.width="100%";
     videoPlayerRef.style.height="100%";
     videoPlayerRef.style.display="block";
    }
    var imageRef= document.getElementById('imageClicker');
    imageRef.style.left = (((w)/2)- 30)+ "px";
    imageRef.style.display="block";
    var autoRotate= document.getElementById('autoRotateOption');
    autoRotate.style.left = (((w)/2) + 30 )+ "px";
    autoRotate.style.display="block";
    var closeRef = document.getElementById('cameraCloser');
    closeRef.style.left = (w - 25) + "px";
    var retakeOption = document.getElementById('retakeOption');
    retakeOption.style.left = (((w)/2) - 30 )+ "px";
    retakeOption.style.display = "none";
    var canvasRef = document.getElementById('canvasShower');
    canvasRef.style.width = "100%";
    canvasRef.style.height = "90%";
    canvasRef.style.display = "none";
    var photoCanvas = document.getElementById('takePhotoCanvas');
    if (photoCanvas != null) {
        photoCanvas.style.width = (w - 10) + "px";
        photoCanvas.style.height = (h - 150) + "px";
        photoCanvas.style.paddingTop = "25px";
        photoCanvas.style.display = "none";
    }
    var uploadCameraRef= document.getElementById('uploadImageCamera');
    uploadCameraRef.style.left = (((w)/2) +30) + "px";
    uploadCameraRef.style.display="none";
    lattitude='';
    longitude='';
    getLocation();
}

var imageCapture;
var cameraOption;
function onGetUserMediaButtonClick(mode) {
    try{
  cameraOption=mode;
  var divRef=document.getElementById('cameraViewer');
  var camref=$(event.target).closest('.doc-list-body')[0]     
  var imgWidthMob=camref.getAttribute("cameraResolution").split("X")[0];
  var imgHeightMob=camref.getAttribute("cameraResolution").split("X")[1];
  var imgWidthSys=imgWidthMob;
  var imgHeightSys=imgHeightMob;
  var w=divRef.style.width.split("p")[0]-0;
  var h=divRef.style.height.split("p")[0]-80;
   if(imgWidthMob=='null' || typeof imgWidthMob=='undefined' || imgWidthMob=='' || 
      imgHeightMob=='null' || typeof imgHeightMob=='undefined' || imgHeightMob=='')
   {imgWidthMob=w;
   imgHeightMob=h;
   imgWidthSys=640;
   imgHeightSys=480;} 
  var isMobile = checkIsMobile(mobilePattern);
  if(typeof mode=='undefined' || mode =='back'){      
        Webcam.set({
          width: isMobile==true?imgWidthMob:imgWidthSys,
          height: isMobile==true?imgHeightMob:imgHeightSys,
          image_format: 'jpeg',
          jpeg_quality: 90,
          constraints: {
             video: true,
             facingMode: "environment"
          }
        });        
  } else if(mode == 'front'){
     Webcam.set({
          width: isMobile==true?imgWidthMob:imgWidthSys,
          height: isMobile==true?imgHeightMob:imgHeightSys,
          image_format: 'jpeg',
          jpeg_quality: 90,
          constraints: {
             video: true,
             facingMode: "user"
          }
        });
  }
  Webcam.attach('#videoShower');
    }catch(e){}
}

function onTakePhotoButtonClick() {
    try{
        var divRef = document.getElementById('cameraViewer');
        var w="";
        var h="";
        var isMobile = checkIsMobile(mobilePattern);
        var ow;
        var oh;
        var vid;
        if(!isMobile){
            ow = divRef.style.width.split("p")[0];
            oh = divRef.style.height.split("p")[0];
            vid = jQuery(document.getElementById("videoShower")).find("video")[0];
            divRef.style.width = vid.videoWidth + "px";
            divRef.style.height = vid.videoHeight + "px";
            w = divRef.style.width.split("p")[0];
            h = divRef.style.height.split("p")[0];
        }else{
            w = divRef.style.width.split("p")[0]-0;
            h = divRef.style.height.split("p")[0]-80;
	}
        if(document.getElementById('takePhotoCanvas')!=null){
            divRef= document.getElementById('canvasShower');
            divRef.removeChild(document.getElementById('takePhotoCanvas'));
        }
        Webcam.snap(function(data_uri) {
            // display results in page
            document.getElementById('canvasShower').innerHTML ='<img id="takePhotoCanvas" style="position:absolute;top:30px;" width="'+w+'" height="'+h+'" src="' + data_uri + '"/>';
            hideShowCanvas();
            stopStreamedVideo(document.querySelector('video'));
            updateLocation();
            if(!isMobile){
                document.getElementById('cameraViewer').style.width = ow + "px";
                document.getElementById('cameraViewer').style.height = oh + "px";
                document.getElementById('canvasShower').style.left = "25%";
                document.getElementById("retakeOption").style.left = ( window.innerWidth / 2 - 30 ) + "px";
                document.getElementById("retakeOption").style.top = (parseInt(h) + 80) + "px";
                document.getElementById("uploadImageCamera").style.left = ( window.innerWidth / 2 + 30 );
                document.getElementById("uploadImageCamera").style.top = (parseInt(h) + 80) + "px";
            }
        });
        }catch(e){}
}

function hideShowCanvas(flag){
    var autoRotate;
    var canvasRef;
    var photoCanvas;
    var retakeOption;
    var imageRef;
    var uploadCameraRef;
    var videoRef;
    var videoPlayerRef;
    if (typeof flag == "undefined"){        
        try{
            videoRef = document.getElementById('videoShower');
        if(videoRef!=null)
            videoRef.style.display = "none";
        videoPlayerRef = document.getElementById('videoPlayer');
        if(videoPlayerRef!=null)
          videoPlayerRef.style.display = "none";
        autoRotate = document.getElementById('autoRotateOption');
        if(autoRotate!=null)
            autoRotate.style.display = "none";
        canvasRef = document.getElementById('canvasShower');
        if(canvasRef!=null)
            canvasRef.style.display = "block";
        photoCanvas = document.getElementById('takePhotoCanvas');
        if(photoCanvas!=null)
          photoCanvas.style.display = "block";
        retakeOption = document.getElementById('retakeOption');
        if(retakeOption!=null)
          retakeOption.style.display = "block";
        imageRef= document.getElementById('imageClicker');
        if(imageRef!=null)
          imageRef.style.display = "none";
        uploadCameraRef= document.getElementById('uploadImageCamera');
        if(uploadCameraRef!=null)
          uploadCameraRef.style.display="block";
        } catch(e) {
            alert(e);
        }
    } else if(flag=='video'){
        videoRef = document.getElementById('videoShower');
        if(videoRef!=null)
         videoRef.style.display = "block";
        videoPlayerRef = document.getElementById('videoPlayer');
        if(videoPlayerRef!=null)
          videoPlayerRef.style.display = "block";
        autoRotate = document.getElementById('autoRotateOption');
        if(autoRotate!=null)
          autoRotate.style.display = "block";
        canvasRef = document.getElementById('canvasShower');
        if(canvasRef!=null)
          canvasRef.style.display = "none";
        photoCanvas = document.getElementById('takePhotoCanvas');
        if(photoCanvas!=null)
          photoCanvas.style.display = "none";
        retakeOption = document.getElementById('retakeOption');
        if(retakeOption!=null)
          retakeOption.style.display = "none";
        imageRef= document.getElementById('imageClicker');
        if(imageRef!=null)
          imageRef.style.display = "block";
        uploadCameraRef= document.getElementById('uploadImageCamera');
        if(uploadCameraRef!=null)
          uploadCameraRef.style.display="none";
    }
    
}

function closeCameraViewer(){
    stopStreamedVideo(document.querySelector('video'));
    var divRef=document.getElementById('cameraViewer');
    divRef.style.removeProperty('width');
    divRef.style.removeProperty('height');
    divRef.style.removeProperty('top');
    divRef.style.removeProperty('left');
    divRef.style.display="none";
    var videoRef= document.getElementById('videoShower');
    videoRef.style.removeProperty('width');
    videoRef.style.removeProperty('height');
    videoRef.style.removeProperty('top');
    videoRef.style.removeProperty('left');
    videoRef.style.display="none";
    var videoPlayerRef = document.getElementById('videoPlayer');
    if(videoPlayerRef) {
     videoPlayerRef.style.removeProperty('width');
     videoPlayerRef.style.removeProperty('height');
     videoPlayerRef.style.removeProperty('top');
     videoPlayerRef.style.removeProperty('left');
     videoPlayerRef.style.display="none";
    }
    var canvasRef= document.getElementById('canvasShower');
    canvasRef.style.removeProperty('width');
    canvasRef.style.removeProperty('height');
    canvasRef.style.removeProperty('top');
    canvasRef.style.removeProperty('left');
    canvasRef.style.display="none";
    var photoCanvas= document.getElementById('takePhotoCanvas');
    photoCanvas.style.removeProperty('width');
    photoCanvas.style.removeProperty('height');
    photoCanvas.style.removeProperty('top');
    photoCanvas.style.removeProperty('left');
    photoCanvas.style.display="none";
    var imageRef= document.getElementById('imageClicker');
    imageRef.style.removeProperty('left');
    var autoRotate= document.getElementById('autoRotateOption');
    autoRotate.style.removeProperty('left');
    var closeRef = document.getElementById('cameraCloser');
    closeRef.style.removeProperty('left');
    var retakeOption = document.getElementById('retakeOption');
    retakeOption.style.removeProperty('left');
    var uploadCameraRef= document.getElementById('uploadImageCamera');
    uploadCameraRef.style.removeProperty('left');
}

function stopStreamedVideo(videoElem) {
  try{  
   var stream = videoElem.srcObject;
   if(stream!=null){
    var tracks = stream.getTracks();

    tracks.forEach(function(track) {
       track.stop();
    });

    videoElem.srcObject = null;
   }
  } catch(e) {
      
  }
}

function autoRotateCamera(){
    stopStreamedVideo(document.querySelector('video'));
    if(cameraOption=='front'){
        onGetUserMediaButtonClick('back');
    } else {
        onGetUserMediaButtonClick('front');
    }
}

function retakeImage(){
    hideShowCanvas('video');
    onGetUserMediaButtonClick(cameraOption);
}

function uploadImageFromCamera(){
    CreateIndicator('cameraUpload');
    document.getElementById('fade').style.display="block";
    var base64Data = document.getElementById('takePhotoCanvas').src;
    var docUnitDetails = "";
    var file = dataURLtoFile(base64Data, "IMG_" + new Date().getDate() + new Date().getMonth() + new Date().getFullYear() + new Date().getMilliseconds() + ".jpeg");
    var docUnitDiv = docBodyDiv;
    var isMobile = checkIsMobile(mobilePattern);
    var isRestrictMultipleDocUpload=false;
    var emptyUnit = true;
    if($(docUnitDiv).find(".doc-unit-detail").length>0){
        emptyUnit = false;
    }
    if(window.restrictMultipleDocUpload)
    {
        isRestrictMultipleDocUpload=restrictMultipleDocUpload(cid,dtype);
        if(isRestrictMultipleDocUpload === true && emptyUnit==false)
        {
            var docid=$($(docUnitDiv).find(".doc-unit-detail")).find(".doc-unit-name").attr("data-docid");
            deletedoc(cid,docid);
            $($(docUnitDiv).find(".doc-unit-detail")).parent().remove();
        }
    }
    uploadFileToOD(file, cid, dtype, function (docID) {
        $("#spinnerdiv").hide();    
        var fileName;
        var type;
        var icon;
        var fileSize;
        if ('name' in file) {
            fileName = file.name;
            type = fileName.split('.')[fileName.split('.').length - 1];
            icon = getIcon(type);
        }
        if ('size' in file) {
            fileSize = (file.size / 1024).toFixed(0) + " (KB)";

        }
        
            docUnitDetails = "           <div class=\"row doc-unit-detail\">\n" +
                               "            <div class=\"col-md-6 col-sm-8 col-xs-12 \" style=\"padding-left:0px;padding-right:0px;padding-top:6px;border: 1px solid #EBEBEB;border-radius: 1px;background-color: #F9F9F9;margin-bottom:20px;\">\n";
            if((applicationName!=null && applicationName!='') || isMobile)           
              docUnitDetails +=   "             <div class=\"col-8 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ;
            else if((window.opener!=null && typeof window.opener.applicationName!='undefined' && (window.opener.applicationName!=null && window.opener.applicationName!='')) || isMobile) 
              docUnitDetails +=   "             <div class=\"col-8 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"docUnitName(event)\">\n" ;
            else
              docUnitDetails +=   "             <div class=\"col-8 doc-unit-name\"data-docID=\""+ docID +"\" onclick=\"openDocInViewer(this)\">\n" ;  
            
            docUnitDetails +=   "               <img src=\""+ icon +"\" style=\"width: 18px; height: 21px;\"> <p title=\""+fileName+"\">"+ fileName +"</p>\n" +
                               // "               <p class='add-doc-size' style='font-size:10px;font-weight:400;margin-top:0px;'>"+ fileSize+"</p>\n" +
                                "             </div>\n" +
                                "             <div class=\"col-1 doc-unit-size\">\n" +
                                "               <p style=\"white-space: nowrap;\">"+ fileSize +"</p>\n" +
                                "             </div>\n" +
                                "             <span class=\"col-1 doc-unit-open d-none d-sm-inline\"  data-docID=\""+ docID +"\" onclick=\"openDocInViewer(this)\">\n" +
                                "              <img class=\"delete-item\" src='../../components/viewer/resources/images/Open.svg'   /> \n" +
                                "             </span>\n" +
                                "             <span class=\"col-1 doc-unit-download d-none d-sm-inline\" data-docID=\""+ docID +"\" onclick=\"docUnitName(this)\">\n" +
                                "               <img class=\"download-item\" src='../../components/viewer/resources/images/Download.svg'   /> \n" +
                                "             </span>\n" +
                                "             <div class=\"col-1 col-xs-1 doc-unit-delete d-none d-sm-inline\" >\n" +
                                "            <span  onclick=\"deleteItem(event,this)\" style=\"cursor:pointer;\" ><?xml version=\"1.0\" encoding=\"UTF-8\"?><svg width=\"14px\" height=\"14px\"  viewBox=\"0 0 14 14\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>"+DELETE+"</title><g id=\"Portal\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><path d=\"M13.5,2 C13.7761424,2 14,2.22385763 14,2.5 C14,2.77614237 13.7761424,3 13.5,3 L13.5,3 L12,3 L12,13 C12,13.6 11.6,14 11,14 L11,14 L3,14 C2.4,14 2,13.6 2,13 L2,13 L2,3 L0.5,3 C0.223857625,3 3.38176876e-17,2.77614237 0,2.5 C-3.38176876e-17,2.22385763 0.223857625,2 0.5,2 L0.5,2 Z M11,3 L3,3 L3,13 L11,13 L11,3 Z M5.5,5 C5.77614237,5 6,5.22385763 6,5.5 L6,10.5 C6,10.7761424 5.77614237,11 5.5,11 C5.22385763,11 5,10.7761424 5,10.5 L5,5.5 C5,5.22385763 5.22385763,5 5.5,5 Z M8.5,5 C8.77614237,5 9,5.22385763 9,5.5 L9,10.5 C9,10.7761424 8.77614237,11 8.5,11 C8.22385763,11 8,10.7761424 8,10.5 L8,5.5 C8,5.22385763 8.22385763,5 8.5,5 Z M9.5,0 C9.77614237,-5.07265313e-17 10,0.223857625 10,0.5 C10,0.776142375 9.77614237,1 9.5,1 L4.5,1 C4.22385763,1 4,0.776142375 4,0.5 C4,0.223857625 4.22385763,5.07265313e-17 4.5,0 L9.5,0 Z\" id=\"Combined-Shape\" fill=\"#000000\" fill-rule=\"nonzero\"></path></g></svg></span>"+
                                "             </div>\n" +
                                "             <div class=\"col-1 doc-unit-mob d-block d-sm-none\" >\n" +
                                "            <span class=\"dropdown\">"+
                                "               <img class=\"more-item\" src='../../components/viewer/resources/images/More.png' data-bs-toggle=\"dropdown\" aria-expanded=\"false\" />"+
                                "               <ul class=\"dropdown-menu dropdown-menu-left\" style=\"text-align:left; padding-top:0px; padding-bottom:0px;padding:5px;font-size:12px;font-family:'Open Sans';\">"+
						"<li style=\"cursor:pointer;\" onclick=\"openDocInViewer($(this).closest('.doc-unit-mob'))\" ><img src='../../components/viewer/resources/images/Open.svg'/><span style=\"padding-left:10px;\" >Open</span></li>"+
                                                "<li style=\"cursor:pointer;\" onclick=\"docUnitName($(this).closest('.doc-unit-mob'))\"><img src=\"../../components/viewer/resources/images/Download.svg\"/><span style=\"padding-left:10px;\" >Download</span></li>  "+
                                                "<li style=\"cursor:pointer;\" onclick=\"deleteItem(event,$(this).closest('.dropdown'))\" ><?xml version=\"1.0\" encoding=\"UTF-8\"?><svg width=\"14px\" height=\"14px\"  viewBox=\"0 0 14 14\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><title>DELETE</title><g id=\"Portal\" stroke=\"none\" stroke-width=\"1\" fill=\"none\" fill-rule=\"evenodd\"><path d=\"M13.5,2 C13.7761424,2 14,2.22385763 14,2.5 C14,2.77614237 13.7761424,3 13.5,3 L13.5,3 L12,3 L12,13 C12,13.6 11.6,14 11,14 L11,14 L3,14 C2.4,14 2,13.6 2,13 L2,13 L2,3 L0.5,3 C0.223857625,3 3.38176876e-17,2.77614237 0,2.5 C-3.38176876e-17,2.22385763 0.223857625,2 0.5,2 L0.5,2 Z M11,3 L3,3 L3,13 L11,13 L11,3 Z M5.5,5 C5.77614237,5 6,5.22385763 6,5.5 L6,10.5 C6,10.7761424 5.77614237,11 5.5,11 C5.22385763,11 5,10.7761424 5,10.5 L5,5.5 C5,5.22385763 5.22385763,5 5.5,5 Z M8.5,5 C8.77614237,5 9,5.22385763 9,5.5 L9,10.5 C9,10.7761424 8.77614237,11 8.5,11 C8.22385763,11 8,10.7761424 8,10.5 L8,5.5 C8,5.22385763 8.22385763,5 8.5,5 Z M9.5,0 C9.77614237,-5.07265313e-17 10,0.223857625 10,0.5 C10,0.776142375 9.77614237,1 9.5,1 L4.5,1 C4.22385763,1 4,0.776142375 4,0.5 C4,0.223857625 4.22385763,5.07265313e-17 4.5,0 L9.5,0 Z\" id=\"Combined-Shape\" fill=\"#000000\" fill-rule=\"nonzero\"></path></g></svg><span style=\"padding-left:10px;\" >Delete</span></li> "+
                                                 "</ul>"+
                                "             </span>"+
                                "             </div>\n" +
                                          "           </div>\n" +
                                            "<div class=\"col-md-5 col-sm-4 col-xs-12 doc-unit-comments errorMessageHoverDiv\">\n"+
                                            "<textarea class=\"form-textarea form-input control-class\" style=\"resize:none;margin-bottom:12px;border-color:#ccc;width:100%;padding:5px;padding-top: 12px;padding-bottom: 0px;\" maxlength=\"4000\" onmouseover=\"this.title=this.value\" rows=\"2\" onchange=\"updateDocComment(this)\" id=\"textarea_"+docID+"\" datatype=\"textarea\" type=\"textarea\"";
            if($(docUnitDiv).hasClass("doc-comments-mandate") == true)
                docUnitDetails +=" required";    
            docUnitDetails +="                                ></textarea>\n"+
                                            "<label style=\"position:relative;top:0px; \"  class=\"form-label control-label inputLabelStyle ";
            if($(docUnitDiv).hasClass("doc-comments-mandate") == true)
                docUnitDetails +=" mandatoryLabel";
            docUnitDetails +="\"  id=\"textarea_"+docID+"_label\">"+Doc_Comments_label+"</label>\n"+"<div class=\"mandatoryMessageDiv mndErrorMsgDiv\" id=\"textarea_"+docID+"_msg\" style=\"display:none;\">"+Doc_Comments_Msg+"</div></div>";
            docUnitDetails += "\n";                  
            var docUnitHtml = "          <div class=\"col-md-12 col-sm-12 col-xs-12 doc-detail-wrapper px-4 my-1\">\n" + docUnitDetails + 
                                "           </div>\n";
            $(docUnitDiv).append(docUnitHtml);
            initFloatingMessagesForPrimitiveFields('.errorMessageHoverDiv');
            initializeTextArea();
            if (document.getElementById(cid + "_" + dtype + "_label") != null) {
                $(document.getElementById(cid + "_" + dtype + "_label")).find(".icon-errorMandatoryMessageIconClass").remove();
                $(document.getElementById(cid + "_" + dtype + "_label")).addClass('mandatoryLabel');
                document.getElementById(cid + "_" + dtype + "_msg").removeAttribute("showMessage");
                $(document.getElementById(cid + "_" + dtype)).removeClass('mandatory');
                delete ComponentValidatedMap[cid + "_" + dtype];
            }

            RemoveIndicator('cameraUpload');
            document.getElementById('fade').style.display = "none";
            showAlertDialog(CAMERA_FILE_UPLOAD, false);
            closeCameraViewer();
			if(window.postCameraUpload){
                window.postCameraUpload(cid,dtype,docID,lattitude,longitude); 
             }
        });
}


function dataURLtoFile(dataurl, filename) {
 
        var arr = dataurl.split(','),
            mime = arr[0].match(/:(.*?);/)[1],
            bstr = atob(arr[1]), 
            n = bstr.length, 
            u8arr = new Uint8Array(n);
            
        while(n--){
            u8arr[n] = bstr.charCodeAt(n);
        }
        
        return new File([u8arr], filename, {type:mime});
}

function checkIsMobile(pattern){
    if(pattern.test(navigator.userAgent)) {
        return true;
    }
    return false;
}