{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{*include file="tpl_inc/bestellvorgang_positionen.tpl"*}

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

<form id="form_payment_extra" class="form payment_extra" method="post" action="bestellvorgang.php">
<fieldset class="outer">
    <input type="hidden" name="{$session_name}" value="{$session_id}" />
    <input type="hidden" name="zahlungsartwahl" value="1" />
    <input type="hidden" name="zahlungsartzusatzschritt" value="1" />
    <input type="hidden" name="Zahlungsart" value="{$Zahlungsart->kZahlungsart}" />
   
    {include file=$Zahlungsart->cZusatzschrittTemplate}
    
    <p class="box_plain"><input type="submit" value="{lang key="continueOrder" section="account data"}" class="submit" /></p>
</fieldset>
</form>