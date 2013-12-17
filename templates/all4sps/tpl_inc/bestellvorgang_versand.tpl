{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{if $hinweis}
<p class="box_error">{$hinweis}</p>
{/if}

<ul class="hlist">
   <li class="p50">
      <h3 class="nospacing">{lang key="billingAdress" section="account data" alt_section="checkout,"}</h3>
      <p class="box_plain">{include file='tpl_inc/inc_rechnungsadresse.tpl'}</p>
      <p><a href="bestellvorgang.php?editRechnungsadresse=1&{$SID}">{lang key="modifyBillingAdress" section="global"}</a></p>
   </li>
   
   <li class="p50">
      <h3 class="nospacing">{lang key="shippingAdress" section="account data" alt_section="checkout,"}</h3>
      <p class="box_plain">{include file='tpl_inc/inc_lieferadresse.tpl'}</p>
      <p><a href="bestellvorgang.php?editLieferadresse=1&{$SID}">{lang key="modifyShippingAdress" section="checkout"}</a></p>
   </li>
</ul>

<div class="container">
<form method="post" action="bestellvorgang.php" class="form">
   <fieldset>
      <legend>{lang key="shippingOptions" section="global"}</legend>
      
      {if count($Versandarten) < 1}
         <p class="box_error">{lang key="noShippingMethodsAvailable" section="checkout"}</p>
      {else}
         <p class="box_info">{lang key="shippingOptionsDesc" section="shipping payment"}</p>
      {/if}

      <ul class="rowsel">
         {foreach name=versand from=$Versandarten item=versandart}
            <li id="shipment_{$versandart->kVersandart}">
               <div class="check">
                  <input name="Versandart" value="{$versandart->kVersandart}" type="radio" id="del{$versandart->kVersandart}" />
               </div>
               <div class="desc">
                  <label for="del{$versandart->kVersandart}" class="desc">
                     {if $versandart->cBild}
                        <img src="{$versandart->cBild}" alt="{$versandart->angezeigterName[$smarty.session.cISOSprache]}">
                     {else}
                        {$versandart->angezeigterName[$smarty.session.cISOSprache]}
                     {/if}
                     {if isset($versandart->angezeigterHinweistext[$smarty.session.cISOSprache]) && $versandart->angezeigterHinweistext[$smarty.session.cISOSprache]|count_characters > 0}
                        <p><small>{$versandart->angezeigterHinweistext[$smarty.session.cISOSprache]}</small></p>
                     {/if}
                     {if $versandart->Zuschlag->fZuschlag!=0}
                        <p><small>{$versandart->Zuschlag->angezeigterName[$smarty.session.cISOSprache]} (+{$versandart->Zuschlag->cPreisLocalized})</small></p>                     
                     {/if}
                
                     {if $versandart->cLieferdauer && isset($versandart->cLieferdauer[$smarty.session.cISOSprache]) && strlen($versandart->cLieferdauer[$smarty.session.cISOSprache]) > 0 && $Einstellungen.global.global_versandermittlung_lieferdauer_anzeigen == "Y"}
                        <p><small>{lang key="shippingTimeLP" section="global"}: {$versandart->cLieferdauer[$smarty.session.cISOSprache]}</small></p>
                     {/if}
                  </label>
               </div>
               <div class="amount">
                  {$versandart->cPreisLocalized}
               </div>
            </li>
         {/foreach}
      </ul>

      {if $Verpackungsarten|@count > 0}
         <ul class="rowsel">
         {foreach name=zusatzverpackungen from=$Verpackungsarten item=oVerpackung}
            <li>
               <div class="check">
                  <input name="kVerpackung[]" type="checkbox" value="{$oVerpackung->kVerpackung}" id="pac{$oVerpackung->kVerpackung}" /> 
               </div>
               <div class="desc">
                  <label for="pac{$oVerpackung->kVerpackung}">
                     {$oVerpackung->cName}
                     <p><small>{$oVerpackung->cBeschreibung}</small></p>
                  </label>
               </div>
               <div class="amount">
                  {if $oVerpackung->nKostenfrei == 1}{lang key="ExemptFromCharges" section="global"}{else}{$oVerpackung->fBruttoLocalized}{/if}
               </div>
            </li>
         {/foreach}
         </ul>
      {/if}
   </fieldset>
   <input type="hidden" name="{$session_name}" value="{$session_id}" />
   <input type="hidden" name="versandartwahl" value="1" />
   <div class="tright">
      <input type="submit" value="{lang key="continueOrder" section="account data"}" class="submit" />
   </div>
</form>
</div>