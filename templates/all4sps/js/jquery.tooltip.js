this.image_preview = function() {
   var yOffset = 10;
   var xOffset = 30;
   var nPercent = 80;
   var width = 0;
   var height = 0;
   
   $(".image_preview").hover(function(e) {
      if ($("#image_preview").length > 0)
         $("#image_preview").remove();
   
      var maxwidth = $(this).attr('maxwidth');
      var maxheight = $(this).attr('maxheight');
      
      var url = $(this).attr('ref');
      var image = new Image();

      $(this).attr('title', '');
      
      $(image).bind("load", function () {
      
         width = $(this).attr('width');
         height = $(this).attr('height');
         
         if (parseInt(maxwidth) > 0 || parseInt(maxheight) > 0)
         {
            if (width > maxwidth)
            {
               height /= (width / maxwidth);
               width = maxwidth;
            }
            
            if (height > maxheight)
            {
               width /= (height / maxheight);
               height = maxheight;
            }
         }
         else
         {
            width *= (nPercent / 100);
            height *= (nPercent / 100);
         }
         
         var xoff = Math.max(0, e.pageX + xOffset);
         var yoff = e.pageY - yOffset;
         
         $("body").append("<div id='image_preview'><img src='"+ $(this).attr('src') +"' width='"+width+"px' height='"+height+"px' alt='' /></div>");
         $("#image_preview")
         .css("top",(yoff) + "px")
         .css("left",(xoff) + "px");
         
         $("#image_preview").fadeIn("slow");
      });
      
      image.src = url;
   },
   function() {
      $("#image_preview").remove();
   });
   
   $(".image_preview").mousemove(function(e) {      
      var xoff = Math.max(0, e.pageX + xOffset);
      var yoff = e.pageY - yOffset;
   
      $("#image_preview")
      .css("top",(yoff) + "px")
      .css("left",(xoff) + "px");
   });			
};
