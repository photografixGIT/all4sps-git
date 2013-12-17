{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<div id="order_completed">
   <p class="box_info">{lang key="orderConfirmationPost" section="checkout"}</p>
   <p>{lang key="yourOrderId" section="checkout"}: {$Bestellung->cBestellNr}</p>
   <p>{lang key="yourChosenPaymentOption" section="checkout"}: {$Bestellung->cZahlungsartName}</p>
</div>