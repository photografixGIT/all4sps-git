{if $billpay_message}
   <p class="box_{$billpay_message->cType}">{$billpay_message->cCustomerMessage}</p>
{/if}

{if isset($nPaymentType)}

   {*<p class="box_success">{lang key="yourOrderId" section="checkout"}: <strong>{$oOrder->cBestellNr}</strong></p>*}

   <div class="form">
      <fieldset id="billpay_form" class="final">

         <div class="logo">
            <img src="{$ShopURL}/gfx/Billpay/LogoMid1_0.png" alt="Billpay" title="Billpay" />
         </div>

         {if $nPaymentType == 1}
            <p class="box_plain"><strong>Bitte &uuml;berweisen Sie den Gesamtbetrag auf folgendes Konto</strong></p>
            <table>
               <tbody>
                  <tr>
                     <td class="p33">{lang key="accountHolder" section="checkout"}:</td><td>{$oPaymentInfo->cInhaber}</td>
                  </tr>
                  <tr>
                     <td class="p33">{lang key="bank" section="checkout"}:</td><td>{$oPaymentInfo->cBankName}</td>
                  </tr>
                  <tr>
                     <td class="p33">{lang key="blz" section="checkout"}:</td><td>{$oPaymentInfo->cBLZ}</td>
                  </tr>
                  <tr>
                     <td class="p33">{lang key="accountNo" section="checkout"}:</td><td>{$oPaymentInfo->cKontoNr}</td>
                  </tr>
                  <tr>
                     <td class="p33">{lang key="purpose" section="checkout"}:</td><td>{$oPaymentInfo->cReferenz}</td>
                  </tr>
               </tbody>
            </table>
         {elseif $nPaymentType == 2}
            <p class="box_plain">
               Vielen Dank, dass Sie sich f&uuml;r die Zahlung per Lastschrift mit Billpay entschieden haben. <br />
               Wir buchen den f&auml;lligen Betrag in den n&auml;chsten Tagen von dem bei der Bestellung angegebenen Konto ab.
            </p>
         {elseif $nPaymentType == 3}
            <p class="box_plain">
               Vielen Dank, dass Sie sich für die Zahlart Ratenkauf entschieden haben.<br />
               Die f&auml;lligen Betr&auml;ge werden monatlich von dem bei der Bestellung angegebenen Konto abgebucht.
            </p>
         {/if}
      </fieldset>
   </div>
{/if}
