/*
 *  dynamic basket handler
 */

function addToBasket(kArtikel, nAnzahl, cImageWrapper, bSpecial)
{
   kArtikel = parseInt(kArtikel);
   nAnzahl = parseFloat(nAnzahl);
   if (typeof bSpecial == 'undefined')
      bSpecial = false;
   
   if (nAnzahl > 0)
      pushToBasket(kArtikel, nAnzahl, cImageWrapper, bSpecial);
   
   return false;
}

function pushToBasket(kArtikel, nAnzahl, cImageWrapper, bSpecial)
{
   if ($('#basket_loader').length)
      $("#basket_loader").show();
      
   if ($('#submit' + kArtikel).length)
      $('#submit' + kArtikel).attr("disabled", true);
   
   var oEigenschaftwerte_arr = xajax.getFormValues('buy_form' + kArtikel);
   
   myBasketCallback = xajax.callback.create();
   myBasketCallback.onFailure = function(args) {
      console.log('onFailure');
      console.log(args);
   }
   
   myBasketCallback.onComplete = function(obj) {
      var response = obj.context.response;	  
      if (response) {
         switch (response.nType) {
            case 0: // error
               alert(response.cNachricht);
            break;
            case 1: // forwarding
               forwardingPopup(response, false);
            break;
            case 2: // added to basket
               if (bSpecial)
                  basketAnimationSpecial(response, cImageWrapper);
               else
                  basketAnimation(response, cImageWrapper);
            break;
         }
      }
   }
   
   xajax.call('fuegeEinInWarenkorbAjax', { parameters: [kArtikel, nAnzahl, oEigenschaftwerte_arr], callback: myBasketCallback, context: this } );
}

function forwardingPopup(response, bPopup)
{
   if (typeof bPopup != 'undefined' && bPopup)
   {
      show_popup(response.cPopup);
      $('#submit' + response.oArtikel.kArtikel).attr("disabled", false);
      
      window.setTimeout(function() {
         window.location.href = response.cLocation;
      }, 5000);
   }
   else
   {
      window.location.href = response.cLocation;
   }
   pushedToBasket();
}

function basketAnimation(response, cImageWrapper)
{  
   // Warenkorb (Box)
   if ($('#basket_text').length)
   {
      var cWarenkorbText = html_entity_decode(response.cWarenkorbText, 'HTML_SPECIALCHARS');
      $('#basket_text').stop().animate({opacity: 1.0}, 10).animate({opacity: 0.2}, 250, function() {     
         $('#basket_text').text(cWarenkorbText);
         $('#basket_text').animate({opacity: 1.0}, 250);
      });
   }
   
   if ($("#basket_drag_area").length)
   {
      if (!$("#basket_drag_area").hasClass('pushed'))
         $("#basket_drag_area").addClass('pushed');
   }
   
   // Warenkorb (Header)
   if ($('#headlinks li.basket a span').length)
   {
      var cWarenkorbLabel = html_entity_decode(response.cWarenkorbLabel, 'HTML_SPECIALCHARS');
      $('#headlinks li.basket a span').stop().animate({opacity: 1.0}, 10).animate({opacity: 0.2}, 250, function() {     
         $('#headlinks li.basket a span').text(cWarenkorbLabel);
         $('#headlinks li.basket a span').animate({opacity: 1.0}, 250);
      });
   }
   
   // Warenkorb (Header, Mini)
   $('#headlinks li.basket div').remove();
   $('#headlinks li.basket').addClass('items');
   $('#headlinks li.basket').append(response.cWarenkorbMini);
   
   // Popup
   popup = $(response.cPopup);
   show_popup(popup, true, true, function() {
      jQuery('#mycarousel_pushed').jcarousel({
         scroll: 1,
         visible: 1,
         wrap: 'last'
      });
   });
   
   popup.find('.article_pushed_xseller').parent().show();
   pushedToBasket();
}

function pushedToBasket()
{
   $('#submit' + response.oArtikel.kArtikel).attr("disabled", false);
   if ($('#basket_loader').length)
      $('#basket_loader').hide();
}

function basketAnimationSpecial(response, cImageWrapper)
{
   var productID = response.oArtikel.kArtikel;
   
   var productX = $(cImageWrapper + productID).offset().left;
   var productY = $(cImageWrapper + productID).offset().top;
   
   var basketX = 0; var basketY = 0;
   
   if ($("#basket_drag_area").length)
   {
      basketX = $("#basket_drag_area").offset().left;
      basketY = $("#basket_drag_area").offset().top;
   }
   else if ($("#headlinks li.basket").length)
   {
      basketX = $("#headlinks li.basket").offset().left;
      basketY = $("#headlinks li.basket").offset().top;   
   }
   
   var newImageWidth = $(cImageWrapper + productID).width() / 3;
   var newImageHeight = $(cImageWrapper + productID).height() / 3;

   var posX = basketX - productX;
   var posY = basketY - productY;
   
   $(cImageWrapper + productID + " img")
   .clone()
   .prependTo(cImageWrapper + productID)
   .css({'position' : 'absolute'})
   .animate({opacity: 1.0}, 100 )
   .animate({opacity: 0.1, marginLeft: posX, marginTop: posY, width: newImageWidth, height: newImageHeight}, 1000, function() {
      basketAnimation(response, cImageWrapper);
      $(this).remove();
   });
}

function html_entity_decode (string, quote_style) {
    var hash_map = {}, symbol = '', tmp_str = '', entity = '';
    tmp_str = string.toString();
    
    if (false === (hash_map = get_html_translation_table('HTML_ENTITIES', quote_style))) {
        return false;
    }

    delete(hash_map['&']);
    hash_map['&'] = '&amp;';

    for (symbol in hash_map) {
        entity = hash_map[symbol];
        tmp_str = tmp_str.split(entity).join(symbol);
    }
    tmp_str = tmp_str.split('&#039;').join("'");
    
    return tmp_str;
}

function get_html_translation_table (table, quote_style) {   
    var entities = {}, hash_map = {}, decimal = 0, symbol = '';
    var constMappingTable = {}, constMappingQuoteStyle = {};
    var useTable = {}, useQuoteStyle = {};
    
    constMappingTable[0]      = 'HTML_SPECIALCHARS';
    constMappingTable[1]      = 'HTML_ENTITIES';
    constMappingQuoteStyle[0] = 'ENT_NOQUOTES';
    constMappingQuoteStyle[2] = 'ENT_COMPAT';
    constMappingQuoteStyle[3] = 'ENT_QUOTES';

    useTable       = !isNaN(table) ? constMappingTable[table] : table ? table.toUpperCase() : 'HTML_SPECIALCHARS';
    useQuoteStyle = !isNaN(quote_style) ? constMappingQuoteStyle[quote_style] : quote_style ? quote_style.toUpperCase() : 'ENT_COMPAT';

    if (useTable !== 'HTML_SPECIALCHARS' && useTable !== 'HTML_ENTITIES') {
        throw new Error("Table: "+useTable+' not supported');
        // return false;
    }

    entities['38'] = '&amp;';
    if (useTable === 'HTML_ENTITIES') {
        entities['160'] = '&nbsp;';
        entities['161'] = '&iexcl;';
        entities['162'] = '&cent;';
        entities['163'] = '&pound;';
        entities['164'] = '&curren;';
        entities['165'] = '&yen;';
        entities['166'] = '&brvbar;';
        entities['167'] = '&sect;';
        entities['168'] = '&uml;';
        entities['169'] = '&copy;';
        entities['170'] = '&ordf;';
        entities['171'] = '&laquo;';
        entities['172'] = '&not;';
        entities['173'] = '&shy;';
        entities['174'] = '&reg;';
        entities['175'] = '&macr;';
        entities['176'] = '&deg;';
        entities['177'] = '&plusmn;';
        entities['178'] = '&sup2;';
        entities['179'] = '&sup3;';
        entities['180'] = '&acute;';
        entities['181'] = '&micro;';
        entities['182'] = '&para;';
        entities['183'] = '&middot;';
        entities['184'] = '&cedil;';
        entities['185'] = '&sup1;';
        entities['186'] = '&ordm;';
        entities['187'] = '&raquo;';
        entities['188'] = '&frac14;';
        entities['189'] = '&frac12;';
        entities['190'] = '&frac34;';
        entities['191'] = '&iquest;';
        entities['192'] = '&Agrave;';
        entities['193'] = '&Aacute;';
        entities['194'] = '&Acirc;';
        entities['195'] = '&Atilde;';
        entities['196'] = '&Auml;';
        entities['197'] = '&Aring;';
        entities['198'] = '&AElig;';
        entities['199'] = '&Ccedil;';
        entities['200'] = '&Egrave;';
        entities['201'] = '&Eacute;';
        entities['202'] = '&Ecirc;';
        entities['203'] = '&Euml;';
        entities['204'] = '&Igrave;';
        entities['205'] = '&Iacute;';
        entities['206'] = '&Icirc;';
        entities['207'] = '&Iuml;';
        entities['208'] = '&ETH;';
        entities['209'] = '&Ntilde;';
        entities['210'] = '&Ograve;';
        entities['211'] = '&Oacute;';
        entities['212'] = '&Ocirc;';
        entities['213'] = '&Otilde;';
        entities['214'] = '&Ouml;';
        entities['215'] = '&times;';
        entities['216'] = '&Oslash;';
        entities['217'] = '&Ugrave;';
        entities['218'] = '&Uacute;';
        entities['219'] = '&Ucirc;';
        entities['220'] = '&Uuml;';
        entities['221'] = '&Yacute;';
        entities['222'] = '&THORN;';
        entities['223'] = '&szlig;';
        entities['224'] = '&agrave;';
        entities['225'] = '&aacute;';
        entities['226'] = '&acirc;';
        entities['227'] = '&atilde;';
        entities['228'] = '&auml;';
        entities['229'] = '&aring;';
        entities['230'] = '&aelig;';
        entities['231'] = '&ccedil;';
        entities['232'] = '&egrave;';
        entities['233'] = '&eacute;';
        entities['234'] = '&ecirc;';
        entities['235'] = '&euml;';
        entities['236'] = '&igrave;';
        entities['237'] = '&iacute;';
        entities['238'] = '&icirc;';
        entities['239'] = '&iuml;';
        entities['240'] = '&eth;';
        entities['241'] = '&ntilde;';
        entities['242'] = '&ograve;';
        entities['243'] = '&oacute;';
        entities['244'] = '&ocirc;';
        entities['245'] = '&otilde;';
        entities['246'] = '&ouml;';
        entities['247'] = '&divide;';
        entities['248'] = '&oslash;';
        entities['249'] = '&ugrave;';
        entities['250'] = '&uacute;';
        entities['251'] = '&ucirc;';
        entities['252'] = '&uuml;';
        entities['253'] = '&yacute;';
        entities['254'] = '&thorn;';
        entities['255'] = '&yuml;';
        entities['8364'] = '&euro;'; 
    }

    if (useQuoteStyle !== 'ENT_NOQUOTES') {
        entities['34'] = '&quot;';
    }
    if (useQuoteStyle === 'ENT_QUOTES') {
        entities['39'] = '&#39;';
    }
    entities['60'] = '&lt;';
    entities['62'] = '&gt;';

    for (decimal in entities) {
        symbol = String.fromCharCode(decimal);
        hash_map[symbol] = entities[decimal];
    }
    
    return hash_map;
}
