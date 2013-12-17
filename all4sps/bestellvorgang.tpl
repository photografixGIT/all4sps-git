{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{include file='tpl_inc/header.tpl'}

<script type="text/javascript">
if (top.location != self.location)
   top.location = self.location.href;
</script>

<div id="content">
{include file='tpl_inc/inc_breadcrumb.tpl'}
   
   <ol id="checkout_steps" class="clearall">
      <li class="step2 state{$bestellschritt[1]} first">{if $bestellschritt[1]==2}<a href="bestellvorgang.php?editRechnungsadresse=1&{$SID}">{lang key="billingAdress" section="checkout"}</a>{else}{lang key="billingAdress" section="checkout"}{/if}</li>
      <li class="step3 state{$bestellschritt[2]}">{if $bestellschritt[2]==2}<a href="bestellvorgang.php?editLieferadresse=1&{$SID}">{lang key="shippingAdress" section="checkout"}</a>{else}{lang key="shippingAdress" section="checkout"}{/if}</li>
      <li class="step4 state{$bestellschritt[3]}">{if $bestellschritt[3]==2}<a href="bestellvorgang.php?editVersandart=1&{$SID}">{lang key="shipmentMode" section="checkout"}</a>{else}{lang key="shipmentMode" section="checkout"}{/if}</li>
      <li class="step5 state{$bestellschritt[4]}">{if $bestellschritt[4]==2}<a href="bestellvorgang.php?editZahlungsart=1&{$SID}">{lang key="paymentMethod" section="checkout"}</a>{else}{lang key="paymentMethod" section="checkout"}{/if}</li>
      <li class="step6 state{$bestellschritt[5]}">{lang key="summary" section="checkout"}</li>
   </ol>
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   <div id="bestellvorgang">
      {if $step=='accountwahl'}
              {include file='tpl_inc/bestellvorgang_accountwahl.tpl'}
      {elseif $step=='unregistriert bestellen'}
              {include file='tpl_inc/bestellvorgang_unregistriert_formular.tpl'}
      {elseif $step=='Lieferadresse'}
              {include file='tpl_inc/bestellvorgang_lieferadresse.tpl'}
      {elseif $step=='Versand'}
              {include file='tpl_inc/bestellvorgang_versand.tpl'}
      {elseif $step=='Zahlung'}
              {include file='tpl_inc/bestellvorgang_zahlung.tpl'}
      {elseif $step=='ZahlungZusatzschritt'}
              {include file='tpl_inc/bestellvorgang_zahlung_zusatzschritt.tpl'}
      {elseif $step=='Bestaetigung'}
              {include file='tpl_inc/bestellvorgang_bestaetigung.tpl'}
      {/if}
   </div>
</div>
{include file='tpl_inc/footer.tpl'}