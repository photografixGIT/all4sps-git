{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if $abschlussseite==1}
    {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
{else}
   {assign var=cModulId value=`$Bestellung->Zahlungsart->cModulId`}

   {if $Bestellung->Zahlungsart->cModulId != $oPlugin->oPluginZahlungsmethodeAssoc_arr[$cModulId]->cModulId && $Bestellung->Zahlungsart->cModulId != 'za_billpay_jtl'
          && $Bestellung->Zahlungsart->cModulId != 'za_kreditkarte_jtl' && $Bestellung->Zahlungsart->cModulId != 'za_lastschrift_jtl'}
      {if $smarty.session.Zahlungsart->nWaehrendBestellung == 1}
         <p class="box_info">{lang key="orderConfirmationPre" section="checkout"}</p>
      {else}
         <p class="box_info">{lang key="orderConfirmationPost" section="checkout"}</p>
      {/if}
   {/if}

   {if $smarty.session.Zahlungsart->nWaehrendBestellung != 1 && $Bestellung->Zahlungsart->cModulId != "za_billpay_jtl" && $Bestellung->Zahlungsart->cModulId != 'za_kreditkarte_jtl' && $Bestellung->Zahlungsart->cModulId != 'za_lastschrift_jtl'}
      <div class="container">
         <p>{lang key="yourOrderId" section="checkout"}: <strong>{$Bestellung->cBestellNr}</strong></p>
         <p>{lang key="yourChosenPaymentOption" section="checkout"}: <strong>{$Bestellung->cZahlungsartName}</strong></p>
      </div>
   {/if}

   <div class="container">
    {if $Bestellung->Zahlungsart->cModulId=="za_rechnung_jtl"}
            {lang key="invoiceDesc" section="checkout"}
            {*{include file='tpl_inc/bestellabschluss_trustedshops.tpl'}*}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_lastschrift_jtl"}
            {lang key="banktransferDesc" section="checkout"}            
            {*{include file='tpl_inc/bestellabschluss_trustedshops.tpl'}*}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_nachnahme_jtl"}
            {lang key="banktransferDesc" section="checkout"}
            {*{include file='tpl_inc/bestellabschluss_trustedshops.tpl'}*}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_barzahlung_jtl"}
            {lang key="cashOnPickupDesc" section="checkout"}
            {*{include file='tpl_inc/bestellabschluss_trustedshops.tpl'}*}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_paypal_jtl"}
           {include file='tpl_inc/modules/paypal/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_kreditkarte_jtl"}  
           {include file='tpl_inc/bestellab_again_zusatzschritt.tpl'}
        <!--
        {lang key="paypalDesc" section="checkout"}
        <br><br>
        {$paypalform}
        <br>
        -->
    {elseif $Bestellung->Zahlungsart->cModulId=="za_eos_jtl"}
        {include file='tpl_inc/modules/eos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_ut_stand_jtl"}
        {include file='tpl_inc/modules/ut/bestellabschluss.tpl'}
    {elseif (substr($Bestellung->Zahlungsart->cModulId, 0, 8) == "za_mbqc_")}
        {include file='tpl_inc/modules/moneybookers_qc/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_wirecard_jtl"}
        {include file='tpl_inc/modules/wirecard/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_postfinance_jtl"}
        {include file='tpl_inc/modules/postfinance/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_iclear_jtl"}
        {include file='tpl_inc/modules/iclear/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_paymentpartner_jtl"}
        {include file='tpl_inc/modules/paymentpartner/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_clickandbuy_jtl"}
        {include file='tpl_inc/modules/clickandbuy/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_saferpay_jtl"}
        {include file='tpl_inc/modules/saferpay/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_cc_jtl"}
        {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_dd_jtl"}
        {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
    {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_gi_jtl"}
        {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_gi_self_jtl"}
        {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_invoice_jtl"}
      {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_prepaid_jtl"}
      {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_dd_self_jtl"}
      {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_ebank_jtl"}
      {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_ebank_direct_jtl"}
      {include file='tpl_inc/modules/uos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_eos_dd_jtl"}
      {include file='tpl_inc/modules/eos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_eos_cc_jtl"}
      {include file='tpl_inc/modules/eos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_eos_direct_jtl"}
      {include file='tpl_inc/modules/eos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_eos_ewallet_jtl"}
      {include file='tpl_inc/modules/eos/bestellabschluss.tpl'}
   {elseif $Bestellung->Zahlungsart->cModulId=="za_billpay_jtl"}
      {include file='tpl_inc/modules/billpay/bestellabschluss.tpl'}

    {elseif $Bestellung->Zahlungsart->cModulId=="za_worldpay_jtl"}
        {lang key="worldpayDesc" section="checkout"}
        <br><br>
        {$worldpayform}
        <br>
    {elseif $Bestellung->Zahlungsart->cModulId=="za_moneybookers_jtl"}
        {lang key="moneybookersDesc" section="checkout"}
        <br><br>
        {$moneybookersform}
        <br>
    {elseif $Bestellung->Zahlungsart->cModulId=="za_ipayment_jtl"}
        {lang key="ipaymentDesc" section="checkout"}
        <br><br>
        {$ipaymentform}
        <br>
    {elseif $Bestellung->Zahlungsart->cModulId=="za_sofortueberweisung_jtl"}
        {lang key="sofortueberweisungDesc" section="checkout"}
        <br><br>
        {$sofortueberweisungform}
        <br>
    {elseif $Bestellung->Zahlungsart->cModulId=="za_clickpay_cc_jtl"}
        {lang key="clickpayDesc" section="checkout"}
        <br><br>
        {$clickpay_cc_form}
        <br>
   {elseif $Bestellung->Zahlungsart->cModulId=="za_dresdnercetelem_jtl"}
        {lang key="desdnercetelemDesc" section="checkout"}
        <br><br>
        <script type="text/javascript">
        function changeButton(elem) {ldelim}
            elem.disabled = true;
            elem.style.visibility = "hidden";
            
            return false;
        {rdelim}
        </script>
        {$dresdnercetelemform}
        <br>
    {elseif $Bestellung->Zahlungsart->cModulId=="za_clickpay_dd_jtl"}
        {lang key="clickpayDesc" section="checkout"}
        <br><br>
        {$clickpay_dd_form}
        <br>
    {elseif $Bestellung->Zahlungsart->cModulId=="za_safetypay"}
        {lang key="safetypayDesc" section="checkout"}
        <br><br>
        {$safetypay_form}
        <br>
    {elseif $Bestellung->Zahlungsart->cModulId == $oPlugin->oPluginZahlungsmethodeAssoc_arr[$cModulId]->cModulId}
      {include file=$oPlugin->oPluginZahlungsmethodeAssoc_arr[$cModulId]->cTemplateFileURL}
    {/if}
    <br>
   {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
    </div>
{/if}
