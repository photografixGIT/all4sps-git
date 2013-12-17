function imageSwitchEx(lID, nID, cImagePath, cBigImagePath)
{
   var image = $('#image' + nID);
   var src = image.attr("src");
   if (typeof cImagePath != "undefined")
   {
      var overlay = $('#overlay' + nID);
      overlay.css("display", "block");
      objImage = new Image();
      objImage.onload = function() {
         imagePreloadedEx(nID, cImagePath, cBigImagePath);
      };
      objImage.src = cImagePath;
   }
   else {
      image.attr("src", images_arr[nID]);
   }
}

function imagePreloadedEx(nID, cImagePath, cBigImagePath)
{
   imagePreloaded(nID, cImagePath);
   if (nID == 0)
   {
      $('#zoom1').attr('href', cBigImagePath);
      $('#zoom1 img').attr('src', cImagePath);

      if ($('#zoom1').hasClass('cloud-zoom'))
      {
         $('#zoom1').data('zoom').destroy();
         $('#zoom1').CloudZoom();
      }
   }
}

var images_arr = new Array();
function imageSwitch(nID, cImagePath)
{
   var image = $('#image' + nID);
   var src = image.attr("src");
   if (typeof cImagePath != "undefined")
   {
      var overlay = $('#overlay' + nID);
      overlay.css("display", "block");
      objImage = new Image();
      objImage.onload = function() {
         imagePreloaded(nID, cImagePath);
      };
      objImage.src = cImagePath;
   }
   else {
      image.attr("src", images_arr[nID]);
   }
}

function imagePreloaded(nID, cImagePath)
{
   var overlay = $('#overlay' + nID);
   var image = $('#image' + nID);
   var src = image.attr("src");
   images_arr[nID] = src;
   image.attr("src", cImagePath);
   overlay.css("display", "none");
}

// Falls nVLKeys gesetzt ist und 1 ist, dann soll die Funktion die Vergleichsliste nicht aus der Session aufbauen
// Sondern die Keys der Artikel?bersicht nutzen
function showCompareList(nVLKeys, bWarenkorb)
{
   if(typeof(nVLKeys) == "undefined")
      nVLKeys = 0;
      
   if(typeof(bWarenkorb) == "undefined")
      bWarenkorb = 1;

   myCallback = xajax.callback.create();
   myCallback.onComplete = function(obj) {
      data = obj.context.compareHTML;
      if (typeof data == 'string' && data.length > 0)
      {
         $.modal(data, {
            close: true,
            opacity: 30,
            appendTo: '#page',
            persist: true,
            onOpen: function (dialog) {
               dialog.overlay.fadeIn('slow', function () {
                  dialog.data.hide();
                  dialog.container.fadeIn('slow', function () {
                     dialog.data.slideDown('slow');
                  });
               });
            }
         });
      }
   }
   xajax.call('gibVergleichsliste', { parameters: [nVLKeys, bWarenkorb], callback: myCallback, context: this } );
   return false;
}

function setSelectionWizardAnswer(kMerkmalWert, kAuswahlAssistentFrage, nFrage, kKategorie)
{
    myCallback = xajax.callback.create();
   myCallback.onComplete = function(obj) {
        data = obj.context.response;
    }
    xajax.call('setSelectionWizardAnswerAjax', { parameters: [kMerkmalWert, kAuswahlAssistentFrage, nFrage, kKategorie], callback: myCallback, context: this } );
   return false;
}

function resetSelectionWizardAnswer(nFrage, kKategorie)
{
    myCallback = xajax.callback.create();
   myCallback.onComplete = function(obj) {
        data = obj.context.response;
    }
    xajax.call('resetSelectionWizardAnswerAjax', { parameters: [nFrage, kKategorie], callback: myCallback, context: this } );
   return false;
}

function getPLZList()
{
   if ($('input.plz_input').length == 0 ||
       $('select.country_input').length == 0)
      return;

   var plz = $('input.plz_input').val();
   var country = $('select.country_input').val();

   if (plz.length < 4 || country.length == 0)
      return;

   myCallback = xajax.callback.create();
   myCallback.onComplete = function(obj) {
      data = obj.context.plz_data;

      if ($('input.city_input').length <= 0)
         return;

      if ($('#form_city_dropdown').length || data.length > 0)
      {
         $('#form_city_dropdown').slideUp();
         $('#form_city_dropdown').remove();
      }

      if (data.length == 0)
         return;

      var dropdown = $('<div></div>')
         .attr('id', 'form_city_dropdown')
         .css({
            display: 'none',
            width: $('input.city_input').outerWidth(true),
            position: 'absolute',
            left: $('input.city_input').offset().left,
            top: $('input.city_input').offset().top + $('input.city_input').outerHeight(true),
            zIndex: 1004
         })
         .appendTo('body');

      var list = $('<ul></ul>');
      $.each(data, function(index, o) {
         var item = $('<li></li>').html(o.cOrt);
         item.click(function() {
            $('#form_city_dropdown').slideUp();
            $('input.city_input').val($(this).html());
         });
         list.append(item);
      });
      dropdown.append(list).slideDown();
   }
   xajax.call('gibPLZInfo', { parameters: [plz, country], callback: myCallback, context: this } );
}

/*
 *  shipping costs
 */
function calcShippingCosts(kArtikel_arr, container)
{
   myCallback = xajax.callback.create();
   myCallback.onComplete = function(obj) {
      data = obj.context.response;

      if ($(container).length == 0)
         return;

      if (typeof data == "object") {
         $(container).html(data.cText);
         $(container).slideDown(250);
      }
      else {
         $(container).hide();
      }
   }
   xajax.call('ermittleVersandkostenAjax', { parameters: [kArtikel_arr], callback: myCallback, context: this } );
}


/*
 *  extended design
 */
function switchStyle(ed, style)
{
   $('.styled_view:last > li').each(function(idx, item) {
      $(item).removeClass('list').removeClass('gallery').removeClass('mosaic');
      $(item).addClass(style);
   });

   $('#ed_list, #ed_gallery, #ed_mosaic').removeClass('active');
   $('#ed_' + style).addClass('active');

   xajax_setzeErweiterteDarstellung(ed);
}

/*
 *  overlay
 */
function set_overlay(id, pos, margin, image)
{
   $(id).load(function() {
      $(id).wrap('<span class="overlay_image_wrapper" />');
      var off = $(this).position();
      $(id).after('<div class="overlay_image overlay_image'+pos+'" style="top:'+(parseInt(off.top)+parseInt(margin))+'px;left:'+(parseInt(off.left)+parseInt(margin))+'px;width:'+ (parseInt($(this)[0].offsetWidth) - parseInt((margin*2))) +'px;height:'+ (parseInt($(this)[0].offsetHeight) - parseInt((margin*2))) +'px;background-image:url(\''+image+'\')" />');
   });
}

/*
 *  popups
 */
function show_popup(mixed, bData, bFast, fnCreated) {
   var dialog = bData ? mixed : '#popup' + mixed;
   $(dialog).modal({
      opacity: 30,
      appendTo: '#page',
      persist: true,
      close: true,
      onOpen: function (dialog) {
         dialog.overlay.fadeIn((typeof bFast != 'undefined' && bFast) ? 'fast' : 'slow', function () {
            dialog.data.hide();
            dialog.container.fadeIn((typeof bFast != 'undefined' && bFast) ? 'fast' : 'slow', function () {
               dialog.data.slideDown((typeof bFast != 'undefined' && bFast) ? 'fast' : 'slow');
               if (typeof fnCreated == 'function')
                  fnCreated();
            });
         });
      },
      onShow: function (dialog) {

      }
   });
}

/*
 *  image popups
 */
function show_image(url) {
   var dialog = $('<div class="tcenter"><img src="'+url+'" />');
   $(dialog).modal({close: true, onOpen: function (dialog) {
      dialog.overlay.fadeIn('slow', function () {
         dialog.data.hide();
         dialog.container.fadeIn('slow', function () {
            dialog.data.slideDown('slow');
         });
      });
   }});
}

/*
 *  register available popups
 */
function register_popups() {
   if ($('.popup_image').length > 0)
   {
      $('.popup_image').each(function(idx, item) {
         $(item).bind('click', function() {
            var href = $(this).attr('href');
            show_image(href);
            return false;
         });
      });
   }

   if ($('.popup').length > 0)
   {
      $('.popup').each(function(idx, item) {
         $(item).bind('click', function() {
            show_popup($(this).attr('id'));
            return false;
         });
      });
   }
}

/*
 *  expander
 */
function register_expander() {
   $('.expander').each(function(idx, item) {
      var ex = '#ep_' + $(this).attr('id');
      var lnk = '#' + $(this).attr('id');

      $(this).click(function(e) {
         e.preventDefault();
         $(ex).toggle();
         $(lnk).toggleClass("active");
      });

      $(ex).mouseup(function() {
         return false;
      });

      $(document).mouseup(function(e) {
         if ($(lnk).hasClass("active"))
         {
            $(lnk).removeClass("active");
            $(ex).hide();
         }
      });
   });
}

/*
 *  switch style
 */
function switchStylestyle(styleName)
{
   $('link[@rel*=style][title]').each(function(i)
   {
      this.disabled = true;
      if (this.getAttribute('title') == styleName) this.disabled = false;
   });
   $.cookie('style', styleName, { expires: 7 });
}

function loadStyle()
{
   $('.styleswitch').click(function() {
      var newStyle = this.getAttribute("rel");
      $('body').fadeOut("fast", function()
      {
         switchStylestyle(newStyle);
         $('body').fadeIn("fast");
      });
      return false;
   });

   var style = $.cookie('style');
   if (style) switchStylestyle(style);
}

/*
 *  placeholder
 */
function register_placeholder()
{
   $(".placeholder").each(function(idx, item)
   {
      var item = $(this);
      var text = item.attr("title");
      var form = item.parents("form:first");

      if (item.val() === "")
         item.val(text);

      item.bind("focus.placeholder", function(event) {
         if (item.val() === text)
            item.val("");
      });

      item.bind("blur.placeholder", function(event) {
         if (item.val() === "")
            item.val(text);
      });

      form.bind("submit.placeholder", function(event) {
         if (item.val() === text)
            item.val("");
      });
   });
}

function m_submit_form( nameAttr, valueAttr, formId ) {
   if (nameAttr) { $("#"+formId).prepend("<input type=\"hidden\" name=\"" + nameAttr + "\" value=\""+valueAttr+"\" />"); }
   $("#"+formId).submit();
   $(this).replaceWith("<span class=\"styledbutton\"><span>"+$(this).text()+"</span></span>");
}

function styleButtons() {
   $("button.cnt_button").each(function() {
      var btnContent = $(this).text();
      if($(this).attr('onclick')) {
         var onClickValue = $(this).attr('onclick');
      } else {
         var onClickValue = "m_submit_form('"+$(this).attr('name')+"', '"+$(this).text()+"', '"+$(this).parents('form').attr('id')+"')";
         //"document.getElementById('" + $(this).parents('form').attr('id') + "').submit(); return false";
      }
      //$(this).removeClass('submitbutton');
      $(this).replaceWith("<a "+($(this).attr('id') ? "id=\""+$(this).attr('id')+"\" " : "")+"class=\""+$(this).attr('class')+"\" href=\"#"+$(this).attr('name')+"\" onclick=\""+onClickValue+"\"><span>"+btnContent+"</span></a>");
   });
}

/*
 *  comment helpful element
 */
function register_helpful() {
   $(".use_helpful").each(function() {
      var a = $(this).attr('id');
      if (!$('#' + a).hasClass('jsenabled'))
         $('#' + a).addClass('jsenabled');

      $(this).mouseenter(function() {
         $('#' + a).addClass('active');
         $('#' + a + ' p.helpfully').fadeIn(250);
      }).mouseleave(function() {
         $('#' + a + ' p.helpfully').fadeOut(100);
         $('#' + a).removeClass('active');
      });
   });
}

function add_url_param(url, params) {
   var newAdditionalURL = '';
   var tempArray = url.split('?');
   var baseURL = tempArray[0];
   var aditionalURL = tempArray[1]; 
   var temp = '';
   
   if (aditionalURL) {
      var tempArray = aditionalURL.split('&');
      for (var i in tempArray) {
         newAdditionalURL += temp + tempArray[i];
         temp = '&';
      }
   }
   
   var finalURL = baseURL + '?' + newAdditionalURL + temp + params;
   return finalURL;
}

/*
 *  vat info
 */
function register_vatinfo() {
   if ($('.vat_info a').length > 0) {
      $('.vat_info a').each(function(idx, item) {
         $(item).bind('click', function() {
            var url = add_url_param($(this).attr('href'), 'exclusive_content=1');
            open_window(url);
            return false;
         });
      });
   }
}

/*
 *  submit default on key enter
 */
/*
function submit_default_enter() {
   $('form').each(function() {
      $('input').keypress(function(e) {
         if(e.which == 10 || e.which == 13)
            this.form.submit();
      });
   });
}
*/

/*
 *  window popup
 */
function open_window(url, width, height) {

   width = width || 1000;
   height = height || 480;

   var left = (screen.width - width)/2;
   var top = (screen.height - height)/2;
   
   var opt = 'width=' + width + ',height=' + height + ',top=' + top + ',left=' + left + ',scrollbars=yes,location=no,directories=no,status=no,menubar=no,toolbar=no,resizable=yes,dependent=no';
   var wnd = window.open(url, "mypopup", opt);
   
   wnd.focus();
   
   return false;
}

function increaseQuantity(obj, min, max) {
   var val = parseInt($(obj).val());
   
   if (typeof max == 'number')
      if (val + 1 > parseFloat(max))
         return false;
   
   $(obj).val(++val);
   $(obj).trigger('change');
   return false;
}

function decreaseQuantity(obj, min, max) {
   var val = parseInt($(obj).val());
   
   if (typeof min == 'number')
      if (val - 1 < parseFloat(min))
         return false;
   
   $(obj).val(--val);
   $(obj).trigger('change');
   return false;
}

function register_sidebox_autoscroll() {
   $('body').waitForImages(function() {
      $("#sidepanel_left .sidebox:last, #sidepanel_right .sidebox:last").each(function(idx, item) {
         if ($(this).hasClass('autoscroll')) {
            $(item).css({
               'position' : 'relative',
               'height' : 'auto',
               'top' : 0
            });
            
            // we LOVE IE, NOT
            $(item).show();
            var top = $(item).offset().top;
            $(item).hide();
            
            $(window).scroll(function() {        
                
               var offset = $(document).scrollTop();
               var max = $('#content').offset().top + $('#content').outerHeight();
               
               if (offset < top) offset = top;
               if (offset > top) offset += 10;
                  
               var maxoff = offset + $(item).outerHeight();
               
               if (maxoff <= max) {
                  $(item).stop();
                  $(item).animate({top: offset - top}, 250, 'swing');
               }
            });
         }
      });
   });
}

/*
 *  format file size
 */
function formatSize(size) {

   var fileSize = Math.round(size / 1024);
   var suffix   = 'KB';
   
   if (fileSize > 1000)
   {
      fileSize = Math.round(fileSize / 1000);
      suffix   = 'MB';
   }
   
   var fileSizeParts = fileSize.toString().split('.');
   fileSize = fileSizeParts[0];
   
   if (fileSizeParts.length > 1)
      fileSize += '.' + fileSizeParts[1].substr(0,2);

   fileSize += suffix;
   
   return fileSize;
}

/*
 *  basket quantity
 */
function renew_basket_quantity(inputdiv, id, old_qty) {
   var quantity = parseFloat($(inputdiv).val());
   if (quantity > 0 && quantity < 1000 && quantity != old_qty) {
      $('#quantity_lst' + id).val(quantity);
      $('#quantity_lst' + id).text(quantity);
      $('#quantity_lst' + id).attr('selected', true);
      $('#quantity_lst' + id).parent().trigger('change');
   }
   else {
      $('#quantity_lst' + id).parent().val(old_qty);
   }   
   $(inputdiv).remove();
}
 
function register_basket_quantity() {
   $("select.quantity_sel").each(function(idx, item) {
      var old_qty = $(this).val();
      $(this).change(function() {
         var id = $(this).attr('ref');
         var quantity = $(this).val();

         if (quantity == 0) {
            var inputdiv = $('<input />').attr({
               'type' : 'text',
               'id' : 'quantity_text' + id
            });
            
            $(inputdiv).css({
               'position' : 'absolute',
               'width' : $(this).width(),
               'height' : $(this).height(),
               'top' : $(this).position().top,
               'left' : $(this).position().left,
               'text-align' : 'center'
            });

            $(inputdiv).keypress(function(e) {
               if (e.keyCode == 13) {
                  renew_basket_quantity($(this), id, old_qty);
               }
            });
            
            $(inputdiv).blur(function() {
               renew_basket_quantity($(this), id, old_qty);
            });
            
            $(document).keydown(function(e) {
               var code = e.keyCode ? e.keyCode : e.which;
               if (code == 27)
                  renew_basket_quantity($(inputdiv), id, old_qty);
            });
            
            $(this).before(inputdiv);
            $(inputdiv).val(old_qty);
            $(inputdiv).focus();
            $(inputdiv).select();
         }
         else {
            $('#warenkorb_form').submit();
         }
      });
   });
}

// highlight input labels
function register_highlight_input() {
   $(':input').focus(function() {
      var id = $(this).attr('id');
      $("label[for$='"+id+"']").addClass('active');
   }).blur(function() {
      var id = $(this).attr('id');
      $("label[for$='"+id+"']").removeClass('active');
   });
}

// ie outline fix
function register_ie_fix() {
   $('a').focus(function() {
      $(this).attr("hideFocus", "hidefocus");
   });
}

// maintenance
function register_maintenance() {
   if ($('#maintenance_mode').length > 0)
      $('#maintenance_mode').delay(5000).slideUp(500);
}

// jcarousel
function register_jcarousel() {
   $('.carousel_loader ul').each(function(idx, item) {
      if(!$(this).hasClass('jcarousel-list')) {
         $(this).jcarousel({
            scroll: 1,
            wrap: 'last',
            visible: $(this).attr('ref')
         });
      }
   });
}

//textarea expander
function register_textarea_expander() {
   var a = $('textarea.expander');
   if ( a.length > 0) {
      a.attr("rows", "1");
   	  a.focus(function(idx, item) {
         if (!a.hasClass("expanded")) {
	        a.animate({height : "100px"}, function() {
	           a.attr("rows", "10");
	           a.addClass("expanded");	 
	        });
	     }
      });
   }
}

// adds .naturalWidth() and .naturalHeight()
(function($){
  var
  props = ['Width', 'Height'],
  prop;

  while (prop = props.pop()) {
    (function (natural, prop) {
      $.fn[natural] = (natural in new Image()) ? 
      function () {
        return this[0][natural];
      } : 
      function () {
        var 
        node = this[0],
        img,
        value;

        if (node.tagName.toLowerCase() === 'img') {
          img = new Image();
          img.src = node.src,
          value = img[prop];
        }
        return value;
      };
    }('natural' + prop, prop.toLowerCase()));
  }
}(jQuery));

// jquery wait
$.fn.wait = function(time, type) {
    time = time || 1000;
    type = type || "fx";
    return this.queue(type, function() {
        var self = this;
        setTimeout(function() {
            $(self).dequeue();
        }, time);
    });
};

// Bundesland
function register_region() {
   if ($('#state').length == 0)
      return;

   var title = $('#state').attr('title');
   
   $('#country').change(function() {
      var val = $(this).find(':selected').val();      
      myCallback = xajax.callback.create();
      myCallback.onComplete = function(obj) {
         data = obj.context.response;
		 var def = $('#state').val();
         if (data != null && data.length > 0) {
            var state = $('<select />').attr({ id: 'state', name: 'bundesland'});
            state.append('<option value="">' + title + '</option>');
            $(data).each(function(idx, item) {
               state.append(
                  $('<option></option>').val(item.cCode).html(item.cName)
                     .attr('selected', item.cCode == def || item.cName == def ? 'selected' : '')
               );
            });            
            $('#state').replaceWith(state);
         }
         else {
            var state = $('<input />').attr({ type: 'text', id: 'state', name: 'bundesland'});
            $('#state').replaceWith(state);
         }
      }
      xajax.call('gibRegionzuLand', { parameters: [val], callback: myCallback, context: this } );
      return false;

   }).trigger('change');
}

function register_slide_to_hash() {
   $('a[href*=#]').bind("click", function(event) {
      var hash = $(this).attr("href");
      if (hash.length > 1) {
         
         var name = hash.substring(1);
         var item = $("a[name='" + name + "']");
         
         if (item.length == 0)
            item = $(hash);
         
         var target = 'html,body';
         if ($.browser.opera)
            target = 'html';
         
         if ($(item).length > 0) {
         
            event.preventDefault();
            
            $(target).animate({
               scrollTop: $(item).offset().top
            }, 500 , function () { 
               location.hash = hash;
            });
         }
      } 
   });
};

function register_autoheight() {
   $('body').waitForImages(function() {
	   $('.autoheight').each(function(idx, container) {
	      var maxheight = 0;
	      $(container).find('.resize').each(function(idx, item) {
	         var height = $(item).height();
	         if (height > maxheight)
	            maxheight = height;
	      });
	      
	      $(container).find('.resize').css('height', maxheight);
	   });
   });
}

function register_popover() {
	$('.popover').each(function(){
		var content = $(this).find('.popover-content');
		content.addClass('hidden');
		$(this).mouseenter(function() {
        	hover = true;
	        $(this).oneTime(750, function() {
	           if (hover)
	              $(content).fadeIn(500);
	        }).mouseleave(function() {
	           hover = false;
	           $(content).stop(true, true);
	           $(content).hide();
	        });
		});
	});
	
}

function register_quantity() {
    $('#quantity').keypress(function (e) {
        if (e.keyCode == 13)
        {
            e.preventDefault();
            $('#buy_form').submit();
            return false;
        }
    });
}

function register_free_property() {
    $('input[type=text][name^=eigenschaftwert]').live('keypress',function (e) {
        if (e.keyCode == 13)
        {
            e.preventDefault();
            $('#buy_form').submit();
            return false;
        }
    });
}


function register_submit_once() {
	$('.submit_once').click(function(){
		$(this).closest('form').submit();
		$(this).attr("disabled", true).addClass('loading').addClass('disabled');
		return false;
	});
}

function backTop() {
   $("#back-top").hide();
   $(window).scroll(function () {
      if ($(this).scrollTop() > 100) {
         $('#back-top').fadeIn();
      } else {
         $('#back-top').fadeOut();
      }
   });
   $('#back-top a').click(function () {
      $('body,html').animate({
         scrollTop: 0
      }, 800);
         return false;
   });
}

function moveBreadcrumb() {
   $("#breadcrumb").insertAfter("#topnavi");
   /*$("#improve_search").prependTo("#page_wrapper");*/
   /*$("div.pageTitle").prependTo("#page_wrapper");*/
   /*$("h1.fn").insertAfter(".article_details .branditem");*/
}

	function loadSlider(min, max, minold, maxold) {
		var rmin = min;
		var rmax = max;
		var rminold = minold;
		var rmaxold = maxold;
		var sliderstartmin = parseInt(rmin);
		var sliderstartmax = parseInt(rmax);
		
        $("#slider-range").slider({
			range: true,
            min: parseFloat(minold),
            max: parseFloat(maxold),
            values: [parseFloat(sliderstartmin), parseFloat(sliderstartmax)],
            slide: function (event, ui) {
                $("#sliamount").val("CHF" + (ui.values[0]) + " bis \u20AC " + (ui.values[1]));
				var val1 = parseInt(ui.values[0]) - 1;
				var val2 = parseInt(ui.values[1]) + 1;
				val1 = val1.toFixed(0);
				var linkspanne = val1 + "_" + val2;
            },
            change: function (event, ui) {
				var pfmin = document.getElementById('pfmin').value;
				var pfmax = document.getElementById('pfmax').value;
				pfmin = parseInt(ui.values[0]) - 1;
				if(pfmin < 0){
					pfmin = 0;
				}
				pfmax = parseInt(ui.values[1]) + 1;

				var pfrminold = document.getElementById('pfminold').value;
				var pfrmaxold = document.getElementById('pfmaxold').value;
				if(pfmin > 0){
					var pfxmin = pfmin + 1;
				}else{
					var pfxmin = pfmin;
				}
				var pfxmax = pfmax - 1;
				var linkspanne = pfmin + "_" + pfmax + "&pfrminold=" + pfrminold + "&pfrmaxold=" + pfrmaxold + "&pfxmin=" + pfxmin + "&pfxmax=" + pfxmax;
				setUrlOnly(linkspanne);
            }
        });
			
        $("#sliamount").val(parseInt(rmin) + ' \u20AC - ' + parseInt(rmax) + ' \u20AC');
    }
    
	function setUrlOnly(linkspanne) {
		var pfurl = document.getElementById('pfurl').value;
		pfurl = pfurl + "&pf=" + linkspanne;
		location.href = pfurl;
    }
    
/*img switcher */
function switchImageAttrib(id,image) {
   $("#"+id).hover(function() { this.src = image; });
}

(function($) {
$.fn.orangemenu = function(options) {
    $(this).data($.extend($.fn.orangemenu.defaults,options));
	
	return this.each(function() {
		$(this).find('li').hover(
			  function () {
				$(this).children('ul').stop(true,true);
			  	switch(options.effect){
				case('fade'):$(this).children('ul').show().css({opacity:0}).animate({opacity:1},options.duration);break;
				case('slide'):$(this).children('ul').slideDown(options.duration);break;
				case('show'):$(this).children('ul').show();break;
				case('diagonal'):$(this).children('ul').animate({width:'show',height:'show'},options.duration);break;
				case('left'):$(this).children('ul').animate({width:'show'},options.duration);break;
				case('slidefade'):$(this).children('ul').animate({height:'show',opacity:1});break
				case('diagonalfade'):$(this).children('ul').animate({width:'show',height:'show',opacity:1},options.duration);break;
				default:$(this).children('ul').fadeIn(options.duration);
				}
			  },
			  function () {
			  	switch(options.effect){
				case('fade'):$(this).children('ul').fadeOut(options.duration);break;
				case('slide'):$(this).children('ul').slideUp(options.duration);break;
				case('show'):$(this).children('ul').hide();break;
				case('diagonal'):$(this).children('ul').animate({width:'hide',height:'hide'},options.duration);break;
				case('left'):$(this).children('ul').animate({width:'hide'},options.duration);break;
				case('slidefade'):$(this).children('ul').animate({height:'hide',opacity:0},options.duration);break
				case('diagonalfade'):$(this).children('ul').animate({width:'hide',height:'hide',opacity:0},options.duration);break;
				default:$(this).children('ul').fadeOut(options.duration);
				}
			  }
		);
		$(this).find('ul').show().hide();//fire the show and hide to prevent the default css behaviour
	});
}
$.fn.orangemenu.defaults = {
duration: 'slow',
effect: 'fade'
};
})(jQuery);

/*
 *  document ready
 */
$(document).ready(function() {   
   $(".tooltip").tipTip();
   $("#suggest").autocomplete([]);
   $("#mymenu").orangemenu();
   register_popups();
   register_expander();
   register_highlight_input();
   register_ie_fix();
   register_maintenance();
   //submit_default_enter();
   register_helpful();
   register_vatinfo();
   register_sidebox_autoscroll();
   register_basket_quantity();
   register_placeholder();
   register_jcarousel();
   image_preview();
   register_textarea_expander();
   register_region();
   register_slide_to_hash();
   register_autoheight();
   register_popover();
   register_quantity();
   register_submit_once();
   register_free_property();
   backTop();
   moveBreadcrumb();
   
   $('#boxPreisSlider').css('display', 'block');
	
	var min = $("#pfmin").val();
	var max = $("#pfmax").val();
	var minold = $("#pfminold").val();
	var maxold = $("#pfmaxold").val();
	loadSlider(min, max, minold, maxold);	

});