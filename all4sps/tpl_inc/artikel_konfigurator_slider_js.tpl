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
      var baseUnit = options.baseUnit;
      var baseName = options.baseName;
      var itemQuantity = options.itemQuantity;
      
      $.each(items, function(idx, item) {
         if (typeof item == 'object') {
            $('#slider' + item.id).slider({
               value: 0,
               min: 0,
               max: 10,
               step: 1,
               
               slide: function( event, ui ) {
                  
                  var quantity = 0;
                  $.each(getSelectedItems(item.id), function(idx, item) {
                     quantity += item.quantity;
                  });
                  
                  var available = 10 - quantity;
                  
                  if (available < ui.value)
                     return false;
                  
               },
               
               change: function( event, ui ) {
                  
                  var quantity = 0;
                  $.each(getSelectedItems(item.id), function(idx, item) {
                     quantity += item.quantity;
                  });
                  
                  var available = 10 - quantity;
                  item.quantity = ui.value;
                  
                  $('#item_quantity' + item.id).val(item.quantity);
                  $('#item' + item.id).attr('checked', ui.value > 0);
                  
                  $('#slider_value' + item.id).text(ui.value * 10 + '%');
                  $('#slider_value' + item.id).removeClass('not_null');
                  $('#item_box' + item.id).removeClass('active');
                  
                  if (ui.value > 0) {
                     $('#item_box' + item.id).addClass('active');
                     $('#slider_value' + item.id).addClass('not_null');
                  }
                  
                  $('#slider' + item.id + ' .ui-slider-active').css('width', ui.value * 10 + '%');
                  
                  var count = available - ui.value;
                  if (count > 0) {
                     $('#article_buyfield_slider').slideUp();
                  }
                  else {
                     $('#article_buyfield_slider').slideDown();
                  }
                  
                  $.each(items, function(idx, item) {
                     if (typeof item == 'object') {
                        $('#item_box' + item.id).removeClass('disabled');
                        
                        if (count <= 0 && !isActive(item)) {
                           $('#item_box' + item.id).addClass('disabled');
                        }
                     }
                  });
                  
                  updateConfiguration();
               }
            });
            
            $('#slider' + item.id).slider({
               value: item.quantity
            });
            
         }
      });
     
      if (itemQuantity.length > 0) {
         $.each(itemQuantity, function(i, id) {
            var itemObj = $('#item_quantity' + id[0]);
            $(itemObj).val(id[1]);
            $.each(items, function(idx, item) {
               if (typeof item == 'object' && item.id == id[0]) {
                  item.quantity = id[1];
                  $('#slider' + item.id).slider({
                     value: item.quantity
                  });
               }
            });
         });
      }
      
      updateConfiguration();
      
      function getSelectedItems(id) {
         var selectedItems = [];
         $.each(items, function(idx, item) {
            if (typeof item == 'object' && item.id != id) {
               if (isActive(item))
                  selectedItems.push(item);
            }
         });
         return selectedItems;
      };
      
      function getTotalPercent() {
         var percent = 0;
         $.each(getSelectedItems(0), function(idx, item) {
            percent += item.quantity * 10;
         });
         return percent;
      }
      
      function updateConfiguration() {
         var html = $('<div />');
         var percent = getTotalPercent();
         
         if (percent > 0) {
            var glob = $('<div />').addClass('glob')
               .html($('<div />').addClass('overall_out')
               .append($('<p />').addClass('overall_value')
                  .append($('<span />').text(percent + '%'))
               )
               .append($('<div />').addClass('overall_in').css('width', percent + '%'))
            );
            $(html).append(glob);
         }
         
         $.each(groups, function(idx, group) {
            if (typeof group == 'object') {
               data = $('<ul />');
                  
               $.each(items, function(idx, item) {
                  if (typeof item == 'object' && item.gid == group.id) {
                     if ($('#item' + item.id).attr('checked') || $('#item' + item.id).attr('selected')) {
                        var qty = $('<p />').addClass('quantity').addClass('percent')
                           .html(
                              $('<div />').addClass('pro_out').
                                 append($('<div />').addClass('pro_in').css('width', item.quantity * 10 + '%'))
                           );
                        
                        data.append($('<li />').html(qty)
                           .append($('<p />').html(item.quantity * 10 + '% ' + item.name)));
                     }
                  }
               });
               
               if (data.find('li').length > 0)
                  html.append(data);
            }
         });
         
         var price = getPriceLocalized();
         $('.price.updateable').each(function(idx, item) {
            $(item).html(price);
         });
         
         var base = getBasePriceLocalized();
         $('.price_base.updateable').each(function(idx, item) {
            $(item).html(base);
         });
            
         if ($('#box_config_list').length > 0)   
            $('#box_config_list').html(html);
      };
      
      function isActive(item) {
         return item.quantity > 0;
      };
      
      function getPrice() {
         var price = basePrice;
         $.each(items, function(idx, item) {
            if (typeof item == 'object') {
               if (isActive(item))
                  price += item.price * item.quantity;
            }
         });

         if (parseInt(baseQuantity) > 0) {
            price = price * baseQuantity;
         }
         
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
         groups[{$oGruppe->getKonfiggruppe()}] = {ldelim} 'count' : {$oGruppe->getItemCount()}, 'id' : {$oGruppe->getKonfiggruppe()}, 'type' : {$oGruppe->getAuswahlTyp()}, 'img' : '{$oGruppe->getBildPfad()}', 'name' : '{$oSprache->getName()}' {rdelim};
         {foreach from=$oGruppe->oItem_arr item=oItem}
            {assign var=oBildPfad value=$oItem->getBildPfad()}
            items[{$oItem->getKonfigitem()}] = {ldelim} 'id' : {$oItem->getKonfigitem()}, 'gid' : {$oGruppe->getKonfiggruppe()}, 'img' : ['{$oBildPfad->cPfadMini}', '{$oBildPfad->cPfadKlein}'], 'price' : {$oItem->getPreis()}, 'name' : '{$oItem->getName()}', 'quantity' : '0', 'min' : '0', 'max' : '10' {rdelim};
         {/foreach}
      {/if}
   {/foreach}

   var konfig = $.Konfig({ldelim}
      'items' : items,
      'groups' : groups,
      'basePrice' : {$Artikel->Preise->fVK[$NettoPreise]},
      'baseUnit' : '{$Artikel->fVPEWert}',
      'baseName' : '{lang key="vpePer"} {$Artikel->cVPEEinheit}',
      'itemQuantity' : [{foreach from=$nKonfigitemAnzahl_arr name=konfigitemanzahl item=nAnzahl key=nKonfigitem}['{$nKonfigitem}', '{$nAnzahl}']{if !$smarty.foreach.konfigitemanzahl.last},{/if}{/foreach}]
   {rdelim});
   
   $('.box_config').slideDown(500);
{rdelim}

$(document).ready(function() {ldelim}
   init_config();
{rdelim});
</script>