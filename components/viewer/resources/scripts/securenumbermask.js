(function($) {

    $.fn.securenumbermask = function(options) {
    var options = $.extend( {
    mask: '#',
    maxlength:10
    }, options);      
        
        this.each(function () {
            var refrence=$(this).prop('id')+'-original';
             
            $(this).attr('input-original',refrence);
            $('<input id="'+refrence+'" type="hidden" value="'+$(this).val()+'"/>').insertAfter($(this));
               $(this).val(Array(($('#'+refrence).val().length)+1).join(options.mask));
               $(this).val($(this).val().substring(0,options.maxlength));
              $('#'+refrence).val($('#'+refrence).val().substring(0,options.maxlength));
              
        });
        
       this.keydown(function(e){
          
           
           if(e.keyCode==37 || e.keyCode==38 || e.keyCode==39 || e.keyCode==40)
        {
            e.preventDefault();
        }
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||(e.keyCode == 65 && e.ctrlKey === true) || (e.keyCode >= 35 && e.keyCode <= 39))  {    return;  }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) { e.preventDefault();}
        if($(this).val().length>=options.maxlength)
           {
               e.preventDefault();
           }
       
       });
    this.keyup(function(e){
      
      var originalRef=$(this).attr('input-original');
      if(e.keyCode==8)
      {
         
          if($(this).val().length<$('#'+originalRef).val().length)
       {
           $('#'+originalRef).val($('#'+originalRef).val().substring(0,$(this).val().length));
       }
          return;
      }
      
       if($(this).val().length==$('#'+originalRef).val().length)
       {
         return;
       }
       
        var lastChar=$(this).val().substring($(this).val().length-1,$(this).val().length);
        $('#'+originalRef).val($('#'+originalRef).val()+lastChar);
         $(this).val(Array(($('#'+originalRef).val().length)+1).join(options.mask));
         
       if($(this).val().length>$('#'+originalRef).val().length)
       {
            $(this).val($(this).val().substring(0,$('#'+originalRef).val().length));
       }
  
    });   
    
    this.click(function(e){
        var cursorLast = '';
        var data=$(this).val();
           $(this).focus().val('').val(data + cursorLast);
    });
    return this;

    };

}(jQuery));