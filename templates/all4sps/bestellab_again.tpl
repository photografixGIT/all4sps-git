{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="orderCompleted" section=""}</h1>
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   <div class="bestellabschluss">
   {if $abschlussseite==1}
      {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
   {else}
      <p>{lang key="yourOrderId" section="checkout"}: {$Bestellung->cBestellNr}</p>
      <p>{lang key="yourChosenPaymentOption" section="checkout"}: {$Bestellung->cZahlungsartName}</p>
      <p>
         {if $Bestellung->Zahlungsart->cModulId=="za_ueberweisung_jtl"}
         <strong>{lang key="doFollowingBanktransfer" section="checkout"}</strong>:
         <table width="90%" cellpadding="0" cellspacing="0">
         <tr><td>{lang key="accountHolder" section="checkout"}:</td><td>{$Firma->cKontoinhaber}</td></tr>
         <tr><td>{lang key="bank" section="checkout"}:</td><td>{$Firma->cBank}</td></tr>
         <tr><td>{lang key="accountNo" section="shipping payment" alt_section="checkout,"}:</td><td>{$Firma->cKontoNr}</td></tr>
         <tr><td>{lang key="blz" section="shipping payment" alt_section="checkout,"}:</td><td>{$Firma->cBLZ}</td></tr>
         <tr><td>&nbsp;</td><td></td></tr>
         <tr><td><strong>{lang key="purpose" section="checkout"}</strong>:</td><td><strong>{$Bestellung->cBestellNr}</strong></td></tr>
         <tr><td><strong>{lang key="totalToPay" section="checkout"}</strong>:</td><td><strong>{$Bestellung->WarensummeLocalized[0]}</strong></td></tr>
         <tr><td>&nbsp;</td><td></td></tr>
         <tr><td colspan="2"><strong>{lang key="forInternationalBanktransfers" section="checkout"}</strong></td></tr>
         <tr><td>{lang key="bic" section="shipping payment" alt_section="checkout,"}:</td><td>{$Firma->cBIC}</td></tr>
         <tr><td>{lang key="iban" section="shipping payment" alt_section="checkout,"}:</td><td>{$Firma->cIBAN}</td></tr>
         </table><br>
         {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
         {elseif $Bestellung->Zahlungsart->cModulId=="za_nachnahme_jtl"}
         {lang key="cashOnDeliveryDesc" section="checkout"}
         {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
         {elseif $Bestellung->Zahlungsart->cModulId=="za_kreditkarte_jtl"}
         {lang key="creditcardDesc" section="checkout"}
         {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
         {elseif $Bestellung->Zahlungsart->cModulId=="za_rechnung_jtl"}
         {lang key="invoiceDesc" section="checkout"}
         {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
         {elseif $Bestellung->Zahlungsart->cModulId=="za_lastschrift_jtl"}
         {lang key="banktransferDesc" section="checkout"}
         {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
         {elseif $Bestellung->Zahlungsart->cModulId=="za_barzahlung_jtl"}
         {lang key="cashOnPickupDesc" section="checkout"}
         {include file='tpl_inc/bestellabschluss_trustedshops.tpl'}
         {elseif $Bestellung->Zahlungsart->cModulId=="za_paypal_jtl"}
         {lang key="paypalDesc" section="checkout"}
         <br><br>
         {$paypalform}
         <br>
         {elseif $Bestellung->Zahlungsart->cModulId=="za_eos_jtl"}
         {include file='tpl_inc/modules/eos/bestellabschluss.tpl'}
         {elseif (substr($Bestellung->Zahlungsart->cModulId, 0, 8) == "za_mbqc_")}
         {include file='tpl_inc/modules/moneybookers_qc/bestellabschluss.tpl'}
         {elseif $Bestellung->Zahlungsart->cModulId=="za_heidelpay_jtl"}
         {include file='tpl_inc/modules/heidelpay/bestellabschluss.tpl'}
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
         {lang key="clickpayDesc" section=""}
         <br><br>
         {$clickpay_cc_form}
         <br>
         {elseif $Bestellung->Zahlungsart->cModulId=="za_clickpay_dd_jtl"}
         {lang key="clickpayDesc" section=""}
         <br><br>
         {$clickpay_dd_form}
         <br>
         {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_cc_jtl"}
         {lang key="uosDesc" section=""}
         <br><br>
         {$uos_cc_form}
         <br>
         {elseif $Bestellung->Zahlungsart->cModulId=="za_uos_dd_jtl"}
         {lang key="uosDesc" section=""}
         <br><br>
         {$uos_dd_form}
         <br>
         {elseif $Bestellung->Zahlungsart->cModulId=="za_safetypay"}
         {lang key="safetypayDesc" section=""}
         <br><br>
         {$safetypay_form}
         <br>
         {/if}
      </p>
   {/if}
   </div>
</div>
{include file='tpl_inc/footer.tpl'}
