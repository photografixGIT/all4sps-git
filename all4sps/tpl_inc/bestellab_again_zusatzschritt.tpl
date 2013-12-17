{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<form id="form_payment_extra" class="form payment_extra" method="post" action="bestellab_again.php">
<fieldset class="outer">
    <input type="hidden" name="{$session_name}" value="{$session_id}" />
    <input type="hidden" name="zusatzschritt" value="1" />
    <input type="hidden" name="kBestellung" value="{$Bestellung->kBestellung}" />
   
    {include file=$Bestellung->Zahlungsart->cZusatzschrittTemplate}
    
    <p class="box_plain"><input type="submit" value="{lang key="completeOrder" section="shipping payment"}" class="submit" /></p>
</fieldset>
</form>