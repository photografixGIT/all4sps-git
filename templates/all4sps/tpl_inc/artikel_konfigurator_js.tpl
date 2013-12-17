{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<script type="text/javascript">
{literal}
;(function($) {
   $.Konfig = function(options) {
      var baseQuantity = 1;
      var items = options.items;
      var groups = options.groups;
      var basePrice = options.basePrice;
      var basePriceScale = options.basePriceScale;
      var baseUnit = options.baseUnit;
      var baseName = options.baseName;
      var itemInit = options.itemInit;
      var groupQuantity = options.groupQuantity;
     
      if (itemInit.length > 0) {
         $.each(itemInit, function(i, id) {
            var itemObj = $('#item' + id);
            if (isNumeric(id) && $(itemObj).length > 0) {
               $(itemObj).attr($(itemObj).is('option')
                  ? 'selected' : 'checked', true);
               itemChanged($(itemObj));
            }
         });
      }
      
      if (groupQuantity.length > 0) {
         $.each(groupQuantity, function(i, arr) {
            if (isNumeric(arr[0]) && isNumeric(arr[1])) {
               var quantityObj = $('#quantity' + arr[0]);
               if ($(quantityObj).length > 0) {
                  $(quantityObj).val(arr[1]);
                  quantityChanged($(quantityObj));
               }
            }
         });
      }
      
      registerEvents();
      updateConfiguration();      
      
      function itemHover(obj, state) {
         var item = items[$(obj).children(':first-child').val()];         
         if (typeof item == 'object' && item.img[1].length > 0) {
            if (state) {
               $('#img' + item.gid).attr('src', item.img[1]);
            }
            else {
               updateImage(item);
            };
         }
      };
      
      function updateImage(item) {
         var img = groups[item.gid].img;
         var selectedItems = getSelectedItems(item.gid);
         
         if (selectedItems.length > 0) {
            var selectedItem = selectedItems[selectedItems.length - 1];
            if (selectedItem.img)
               img = selectedItem.img[1];
         }
      
         $('#img' + item.gid).attr('src', img);
      };

      function itemChanged(obj) {
         var item = items[$(obj).val()];
         if (typeof item == 'object') {
            // set item quantity
            var quantityObj = $("#quantity" + item.gid);
            $(quantityObj).val(item.quantity);
            if (item.min == item.max)
               $(quantityObj).removeClass('disabled')
                  .addClass('disabled');
            else
               $(quantityObj).removeClass('disabled');
               
            // switch image
            updateImage(item);
         }
         else {
            // unknown item, reset quantity input
            var gid = $(obj).attr('ref');           
            if (isNumeric(gid)) {
               var quantityObj = $("#quantity" + gid);
               $(quantityObj).removeClass('disabled');
               $(quantityObj).val(1);
            }
         }
         updateConfiguration();
      };
      
      function quantityChanged(obj) {
         var gid = $(obj).attr('ref');
         if (isNumeric(gid)) {
            var selectedItems = getSelectedItems(gid);
            if (selectedItems.length == 1) {
               var selectedItem = selectedItems[0];
               var tryQuantity = parseQuantity(obj, false, false);               
               var quantity = parseQuantity(obj, selectedItem.min, selectedItem.max);
               selectedItem.quantity = quantity;
               
               // error effect
               if (tryQuantity != quantity) {
                  $(obj).fadeOut(50, function() {
                     $(this).fadeIn(50);
                  });
               }
            }
            $(obj).val(quantity);
            updateConfiguration();
         }
      };
      
      function parseQuantity(obj, min, max) {
         var quantity = 0;
         if (isNumeric($(obj).val())) {
            quantity = parseInt($(obj).val());
         }
         if (isNumeric(min) && quantity < min) {
            quantity = min;
         }
         if (isNumeric(max) && quantity > max) {
            quantity = max;
         }
         return quantity;
      };
      
      function getSelectedItems(gid) {
         var selectedItems = [];
         $.each(items, function(idx, item) {
            if (typeof item == 'object' && item.gid == gid) {
               if (isActive(item))
                  selectedItems.push(item);
            }
         });
         return selectedItems;
      };
      
      function makeNumeric(input) {
         if (typeof input == 'string') {
            input = input.split(",");
            if (input) input = input.join(".");
         }
         return input;
      }
      
      function isNumeric(input, dot) {
         var regex = dot ? /^-{0,1}\d*\.{0,1}(\d*)+$/ :
            /^-{0,1}\d*\.{0,1}\d+$/;
         return (regex.test(input));
      };
      
      function registerEvents() {
         registerItemHover();
         registerItemChanged();
         registerQuantityChanged();
      };
      
      function registerItemHover() {
         $('#config_wrapper div.item label').each(function(){
            $(this).mouseover(function() {
               itemHover(this, true);
            }).mouseout(function() {
               itemHover(this, false);
            });
         });
      };
      
      function registerItemChanged() {
         $('#config_wrapper div.item input').each(function(){
            $(this).click(function() {
               itemChanged(this);
            });
         });
         
         $('#config_wrapper div.item select').each(function(){
            $(this).change(function() {
               itemChanged(this);
            }).keyup(function() {
               $(this).trigger('change');
            });
         });
      };
      
      function registerQuantityChanged() {
         $.each(groups, function(idx, group) {
            if (typeof group == 'object') {
               var quantityObj = $('#quantity' + group.id);
               if ($(quantityObj).length > 0) {
                  $(quantityObj).change(function() {
                     quantityChanged(this);
                  }).blur(function() {
                     quantityChanged(this);
                  });
               }
            }
         });
         
         /* main quantity */
         quantityObj = $('#quantity');
         if ($(quantityObj).length > 0) {
            updateMainQuantity(quantityObj);
            $(quantityObj).change(function() {
               updateMainQuantity(quantityObj);
            }).keyup(function() {
               updateMainQuantity(quantityObj);
            });
         }
      };
      
      function updateMainQuantity(quantityObj) {
         baseQuantity = $(quantityObj).val();
         baseQuantity = parseFloat(makeNumeric(baseQuantity));
         if (!isNumeric(baseQuantity, true)) {
            baseQuantity = 1;
         }
         $(quantityObj).val(baseQuantity);
         updateConfiguration();
      };
      
      function updateConfiguration() {
         html = $('<div />');
         $.each(groups, function(idx, group) {
            if (typeof group == 'object') {
               data = $('<ul />');
               data.append($('<li />')
                  .addClass('title')
                  .text(group.name));
                  
               $.each(items, function(idx, item) {
                  if (typeof item == 'object' && item.gid == group.id) {
                     if ($('#item' + item.id).attr('checked') || $('#item' + item.id).attr('selected')) {
                        var qty = $('<p />').addClass('quantity')
                           .text(item.quantity + 'x');
                        data.append($('<li />').html(qty)
                           .append($('<p />').html(item.name)));
                     }
                  }
               });
               
               if (data.find('li').length > 1)
                  html.append(data);
            }
         });
         
         var price = getPriceLocalized();
         $('.price.updateable').each(function(idx, item) {
            $(item).html(price);
         });
         
       /*
         var base = getBasePriceLocalized();
         $('.price_base.updateable').each(function(idx, item) {
            $(item).html(base);
         });
       */
            
         if ($('#box_config_list').length > 0)   
            $('#box_config_list').html(html);
            
         if (typeof config_price_changed == 'function')
            config_price_changed(getPrice());
      };
      
      function isActive(item) {
         return ($('#item' + item.id).attr('checked') || $('#item' + item.id).attr('selected'));
      };
      
      function getPrice() {
         var price = 0;
         $.each(items, function(idx, item) {
            if (typeof item == 'object') {
            var itemprice = 0;
               if (isActive(item)) {
                  itemprice += item.price * item.quantity;
              if (item.multiplier)
                 itemprice *= baseQuantity;
            }
            price += itemprice;
            }
         });
       
      var base = basePrice;
      if (basePriceScale) {
         $.each(basePriceScale, function(i, item) {
            i = parseFloat(i);
            if (baseQuantity >= i) {
               base = parseFloat(item);
            }
         });
      };

         price += base * baseQuantity;
         return price;
      };
      
      function getBasePrice() {
         if (parseFloat(baseUnit) > 0) {      
            var price = getPrice() / baseUnit;
            return price;
         }
         return 0;
      };
      
      function getPriceLocalized() {
         var price = getPrice();
         return gibPreis(new Number(price));
      };
      
      function getBasePriceLocalized() {
         var price = getBasePrice();
         return gibPreis(new Number(price)) + ' ' + baseName;
      };
      
      return {
         'groupCount': function(obj) {
            return groups.length;
         },
         'itemCount': function(obj) {
            return items.length;
         }
      };
   };
})(jQuery);
{/literal}

function init_config() {ldelim}
   var groups = [];
   var items = [];
   var vars = [];

   {foreach from=$Artikel->oKonfig_arr item=oGruppe}
      {if $oGruppe->getItemCount() > 0}
         {assign var=oSprache value=$oGruppe->getSprache()}     
         groups[{$oGruppe->getKonfiggruppe()}] = {ldelim} 'count' : {$oGruppe->getItemCount()}, 'id' : {$oGruppe->getKonfiggruppe()}, 'type' : {$oGruppe->getAuswahlTyp()}, 'img' : '{$oGruppe->getBildPfad()}', 'name' : '{$oSprache->getName()|escape:"quotes"}' {rdelim};
         {foreach from=$oGruppe->oItem_arr item=oItem}
            {assign var=oBildPfad value=$oItem->getBildPfad()}
            items[{$oItem->getKonfigitem()}] = {ldelim} 'id' : {$oItem->getKonfigitem()}, 'gid' : {$oGruppe->getKonfiggruppe()}, 'img' : ['{$oBildPfad->cPfadMini}', '{$oBildPfad->cPfadKlein}'], 'price' : {$oItem->getPreis(false, true)}, 'name' : '{$oItem->getName()|escape:"quotes"}', 'quantity' : '{$oItem->getInitial()}', 'min' : '{$oItem->getMin()}', 'max' : '{$oItem->getMax()}', multiplier: {if $oItem->ignoreMultiplier()}false{else}true{/if} {rdelim};
         {/foreach}
      {/if}
   {/foreach}

   var konfig = $.Konfig({ldelim}
      'items' : items,
      'groups' : groups,
      'basePrice' : {$Artikel->Preise->fVK[$NettoPreise]},
      'baseUnit' : '{$Artikel->fVPEWert}',
      'baseName' : '{lang key="vpePer"} {$Artikel->cVPEEinheit}',
     {if $Artikel->Preise->fPreis1>0 && $Artikel->Preise->nAnzahl1>0}
        'basePriceScale' : {ldelim} 
		   {if $Artikel->Preise->nAnzahl1>0}{$Artikel->Preise->nAnzahl1}:{$Artikel->Preise->fStaffelpreis1[$NettoPreise]}{/if}
		   {if $Artikel->Preise->nAnzahl2>0},{$Artikel->Preise->nAnzahl2}:{$Artikel->Preise->fStaffelpreis2[$NettoPreise]}{/if}
		   {if $Artikel->Preise->nAnzahl3>0},{$Artikel->Preise->nAnzahl3}:{$Artikel->Preise->fStaffelpreis3[$NettoPreise]}{/if}
		   {if $Artikel->Preise->nAnzahl4>0},{$Artikel->Preise->nAnzahl4}:{$Artikel->Preise->fStaffelpreis4[$NettoPreise]}{/if}
		   {if $Artikel->Preise->nAnzahl5>0},{$Artikel->Preise->nAnzahl5}:{$Artikel->Preise->fStaffelpreis5[$NettoPreise]}{/if}
		{rdelim},
     {/if}
      'itemInit' : [{foreach from=$nKonfigitem_arr name=konfigitem item=nKonfigitem}'{$nKonfigitem}'{if !$smarty.foreach.konfigitem.last},{/if}{/foreach}],
      'groupQuantity' : [{foreach from=$nKonfiggruppeAnzahl_arr name=konfiggruppeanzahl item=nAnzahl key=nKonfiggruppe}['{$nKonfiggruppe}', '{$nAnzahl}']{if !$smarty.foreach.konfiggruppeanzahl.last},{/if}{/foreach}]
   {rdelim});

   $('.config_tooltip').each(function() {ldelim}
      var hover = false;
      var width = $(this).outerWidth();
      var id = '#' + $(this).attr('ref');
      
      $(id).css('width', width);
      var offset = $(id).outerWidth();
      $(id).css('width', width - (offset - width));
      
      $(this).mouseenter(function() {ldelim}
         hover = true;
         $(this).oneTime(750, function() {ldelim}
            if (hover)
               $(id).fadeIn(500);
         {rdelim}).mouseleave(function() {ldelim}
            hover = false;
            $(id).stop(true, true);
            $(id).hide();
         {rdelim});
      {rdelim});
   {rdelim});
   
   $('.box_config').slideDown(500);
{rdelim}

$(document).ready(function() {ldelim}
   init_config();
{rdelim});
</script>