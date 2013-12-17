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

<div class="container form">
   <fieldset>
      <legend>{lang key="shippingOptions" section="global"}</legend>
      <p class="box_plain">{$smarty.session.Versandart->angezeigterName[$smarty.session.cISOSprache]}</p>
    {if isset($smarty.session.Versandart->angezeigterHinweistext[$smarty.session.cISOSprache]) && $smarty.session.Versandart->angezeigterHinweistext[$smarty.session.cISOSprache]|count_characters > 0}
      <p><small>{$smarty.session.Versandart->angezeigterHinweistext[$smarty.session.cISOSprache]}</small></p><br />
      {/if}
      <a href="bestellvorgang.php?editVersandart=1&{$SID}">{lang key="modifyShippingOption" section="checkout"}</a>
   </fieldset>
</div>

<form id="zahlung" method="post" action="bestellvorgang.php" class="form">
   <fieldset>
      <legend>{lang key="paymentOptions" section="global"}</legend>
      
      {if $cFehler|count_characters == 0}
         <p class="box_info">{lang key="paymentOptionsDesc" section="shipping payment"}</p>
      {else}
         <p class="box_error">{$cFehler}</p>
      {/if}
      
      <ul class="rowsel">
         {foreach name=zahlung from=$Zahlungsarten item=zahlungsart}
            <li id="{$zahlungsart->cModulId}">
               <div class="check">
                  <input name="Zahlungsart" value="{$zahlungsart->kZahlungsart}" type="radio" id="payment{$zahlungsart->kZahlungsart}" />
               </div>
               <div class="desc">
                  <label for="payment{$zahlungsart->kZahlungsart}">
                     {if $zahlungsart->cBild}
                        <img src="{$zahlungsart->cBild}" alt="{$zahlungsart->angezeigterName[$smarty.session.cISOSprache]}" class="vmiddle" />
                     {else}
                        {$zahlungsart->angezeigterName[$smarty.session.cISOSprache]}                        
                     {/if}               
                     
                     {if $zahlungsart->cHinweisText[$smarty.session.cISOSprache]|count_characters > 0}
                        <p><small>{$zahlungsart->cHinweisText[$smarty.session.cISOSprache]}</small></p>
                     {/if}
                  </label>
               </div>
               
               <div class="amount">
                  {if $zahlungsart->fAufpreis!=0}
                        <span class="label">{$zahlungsart->cGebuehrname[$smarty.session.cISOSprache]} </span> 
                  {/if}
                  <span class="value">{$zahlungsart->cPreisLocalized}</span>
               </div>
            </li>
         {/foreach}
      </ul>
      
      {if $oTrustedShops->oKaeuferschutzProdukte->item|@count > 0 && $Einstellungen.trustedshops.trustedshops_nutzen == "Y"}
         {* TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO *}
         <table width="100%" border="0" cellspacing="0" cellpadding="5">
         <tr>                                               
         <td>
         {if $oTrustedShops->oKaeuferschutzProdukte->item|@count > 1}
         <input name="bTS" type="checkbox" value="1" /> <strong>{lang key="trustedShopsBuyerProtection" section="global"} ({lang key="trustedShopsRecommended" section="global"})</strong><br />
         <select name="cKaeuferschutzProdukt" class="combo">                                                                                                        
         {foreach name=kaeuferschutzprodukte from=$oTrustedShops->oKaeuferschutzProdukte->item item=oItem}
         <option value="{$oItem->tsProductID}"{if $oTrustedShops->cVorausgewaehltesProdukt == $oItem->tsProductID} selected{/if}>{lang key="trustedShopsBuyerProtection" section="global"} {lang key="trustedShopsTo" section="global"} {$oItem->protectedAmountDecimalLocalized} ({$oItem->grossFeeLocalized} {$oItem->cFeeTxt})</option>   
         {/foreach}                                       
         </select>
         {elseif $oTrustedShops->oKaeuferschutzProdukte->item|@count == 1}
         <input name="bTS" type="checkbox" value="1" /> <strong>{lang key="trustedShopsBuyerProtection" section="global"} {lang key="trustedShopsTo" section="global"} {$oTrustedShops->oKaeuferschutzProdukte->item[0]->protectedAmountDecimalLocalized} ({$oTrustedShops->oKaeuferschutzProdukte->item[0]->grossFeeLocalized} {$oTrustedShops->oKaeuferschutzProdukte->item[0]->cFeeTxt})</strong><br />
         <input name="cKaeuferschutzProdukt" type="hidden" value="{$oTrustedShops->oKaeuferschutzProdukte->item[0]->tsProductID}" />
         {/if}
         <br />
         {assign var=cISOSprache value=$oTrustedShops->cISOSprache}
         {if $oTrustedShops->cBoxText[$cISOSprache]|count_characters > 0}
         {$oTrustedShops->cBoxText[$cISOSprache]}
         {else}
         {assign var=cISOSprache value=`default`}
         {$oTrustedShops->cBoxText[$cISOSprache]}
         {/if}
         </td>
         <td valign="top">
         <a href="{$oTrustedShops->cLogoURL}" target="_blank"><img src="{$URL_SHOP}/{$PFAD_GFX_TRUSTEDSHOPS}ts_logo.jpg" alt="" /></a>
         </td>
         </tr>
         </table>
      {/if}
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      <input type="hidden" name="zahlungsartwahl" value="1" />
   </fieldset>
   <div class="tright">
      <input type="submit" value="{lang key="continueOrder" section="account data"}" class="submit" />
   </div>
</form>
