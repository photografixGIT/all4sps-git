{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<script type="text/javascript">
{literal}
function changeState(state) {
   var id = parseInt(state);
   if (id >= 0)
      $('#new_delivery_address').hide("slow");
   else
      $('#new_delivery_address').show("slow");
}
{/literal}
</script>

{* billing address
<div class="form">
   <fieldset>
      <legend>{lang key="billingAdress" section="account data" alt_section="checkout,"}</legend>
      {include file='tpl_inc/inc_rechnungsadresse.tpl'}
      <br /><br />
      <p><a href="bestellvorgang.php?editRechnungsadresse=1&{$SID}" class="submit">{lang key="modifyBillingAdress" section="global"}</a></p>
   </fieldset>
</div>
*}

<form id="lieferadresse" method="post" action="bestellvorgang.php" class="form address">
   <fieldset>
      <legend>{lang key="shippingAdress" section="account data" alt_section="checkout,"}</legend>

      <div>
         <p><input type="radio" name="kLieferadresse" onclick="changeState('0')" value="0" id="delivery0" {if $kLieferadresse==0}checked{/if}> <label class="desc" for="delivery0"> {lang key="shippingAdressEqualBillingAdress" section="account data"}</label></p>
         {foreach name=lieferad from=$Lieferadressen item=adresse}
            {if $adresse->kLieferadresse>0}
               <p><input type="radio" name="kLieferadresse" onclick="changeState('{$adresse->kLieferadresse}')" value="{$adresse->kLieferadresse}" id="delivery{$adresse->kLieferadresse}" {if $kLieferadresse==$adresse->kLieferadresse}checked{/if}> <label class="desc" for="delivery{$adresse->kLieferadresse}">{if $adresse->cFirma}{$adresse->cFirma},{/if} {$adresse->cVorname} {$adresse->cNachname}, {$adresse->cStrasse}, {$adresse->cPLZ} {$adresse->cOrt}, {$adresse->angezeigtesLand}</label></p>
            {/if}
         {/foreach}
         <p><input type="radio" name="kLieferadresse" onclick="changeState('-1')" value="-1" id="delivery_new" {if $kLieferadresse==-1}checked{/if}> <label class="desc" for="delivery_new"> {lang key="createNewShippingAdress" section="account data"}</label></p>
      </div>
      
      <div id="new_delivery_address" {if $kLieferadresse >= 0}class="hidden"{/if}>
         <ul class="input_block">
         
            {if $Einstellungen.kunden.lieferadresse_abfragen_anrede!="N"}
            <li>
               <label for="salutation">{lang key="salutation" section="account data"}<em>*</em>:</label>
               <select name="anrede" id="salutation">
                  <option value="w" {if $Lieferadresse->cAnrede == "w"}selected="selected"{/if}>{$Anrede_w}</option>
                  <option value="m" {if $Lieferadresse->cAnrede == "m"}selected="selected"{/if}>{$Anrede_m}</option>
               </select>
            </li>
            {/if}
         
            {if $Einstellungen.kunden.lieferadresse_abfragen_titel!="N"}
            <li {if $fehlendeAngaben.titel>0}class="error_block"{/if}>
               <label for="title">{lang key="title" section="account data"}{if $Einstellungen.kunden.lieferadresse_abfragen_titel=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="titel" value="{$Lieferadresse->cTitel}" id="title" />
               {if $fehlendeAngaben.titel>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            {/if}
         </ul>
         <ul class="input_block">
            
            <li class="clear {if $fehlendeAngaben.vorname>0}error_block{/if}">
               <label for="firstName">{lang key="firstName" section="account data"}:</label>
               <input type="text" name="vorname" value="{$Lieferadresse->cVorname}" id="firstName" />
               {if $fehlendeAngaben.vorname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
         
            <li {if $fehlendeAngaben.nachname>0}class="error_block"{/if}>
               <label for="lastName">{lang key="lastName" section="account data"}<em>*</em>:</label>
               <input type="text" name="nachname" value="{$Lieferadresse->cNachname}" id="lastName" />
               {if $fehlendeAngaben.nachname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            
            <li class="clear {if $fehlendeAngaben.firma>0}error_block{/if}">
               <label for="firm">{lang key="firm" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_firma=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="firma" value="{$Lieferadresse->cFirma}" id="firm" />
               {if $fehlendeAngaben.firma>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            
            <li class="clear {if $fehlendeAngaben.firmazusatz>0}error_block{/if}">
               <label for="firmext">{lang key="firmext" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_firmazusatz=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="firmazusatz" value="{$Lieferadresse->cZusatz}" id="firm" />
               {if $fehlendeAngaben.firmazusatz>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            
         </ul>
         <ul class="input_block">
            
            <li class="clear {if $fehlendeAngaben.strasse>0}error_block{/if}">
               <label for="street">{lang key="street" section="account data"}<em>*</em>:</label>
               <input type="text" name="strasse" value="{$Lieferadresse->cStrasse}" id="street" />
               {if $fehlendeAngaben.strasse>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            
            <li>
               <label for="streetnumber">{lang key="streetnumber" section="account data"}:</label>
               <input type="text" name="hausnummer" value="{$Lieferadresse->cHausnummer}" id="streetnumber" />
            </li>
            
            
            {if $Einstellungen.kunden.lieferadresse_abfragen_adresszusatz!="N"}
            <li {if $fehlendeAngaben.adresszusatz>0}class="error_block"{/if}>
               <label for="street2">{lang key="street2" section="account data"}{if $Einstellungen.kunden.lieferadresse_abfragen_adresszusatz=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="adresszusatz" value="{$Lieferadresse->cAdressZusatz}" id="street2" />
               {if $fehlendeAngaben.adresszusatz>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            {/if}
            
         </ul>
         <ul class="input_block">
            
            <li class="clear {if $fehlendeAngaben.plz>0}error_block{/if}">
               <label for="plz">{lang key="plz" section="forgot password" alt_section="account data,"}<em>*</em>:</label>
               <input type="text" name="plz" value="{$Lieferadresse->cPLZ}" id="plz" />
               {if $fehlendeAngaben.plz>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            
            <li {if $fehlendeAngaben.ort==1}class="error_block"{/if}>
               <label for="city">{lang key="city" section="account data"}<em>*</em>:</label>
               <input type="text" name="ort" value="{$Lieferadresse->cOrt}" id="city" />
               {if $fehlendeAngaben.ort==1}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            
         </ul>
         <ul class="input_block">
            
            {if $Einstellungen.kunden.lieferadresse_abfragen_bundesland!="N"}
            <li {if $fehlendeAngaben.bundesland>0}class="error_block"{/if}>
               <label for="state">{lang key="state" section="account data"}{if $Einstellungen.kunden.lieferadresse_abfragen_bundesland=="Y"}<em>*</em>{/if}:</label>
               <input type="text" title="{lang key="pleaseChoose"}" name="bundesland" value="{$Lieferadresse->cBundesland}" id="state" />
               {if $fehlendeAngaben.bundesland>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
            {/if}
         
            <li>
               <label for="country">{lang key="country" section="account data"}<em>*</em>:</label>
               <select name="land" id="country">
                  {foreach name=land from=$laender item=land}
                  <option value="{$land->cISO}" {if ($Einstellungen.kunden.lieferadresse_abfragen_standardland==$land->cISO && !$Lieferadresse->cLand) || $Lieferadresse->cLand==$land->cISO}selected="selected"{/if}>{$land->cName}</option>
                  {/foreach}
               </select>
            </li>
            
         </ul>
         <ul class="input_block">
            
            {if $Einstellungen.kunden.lieferadresse_abfragen_email!="N"}   
            <li class="clear {if $fehlendeAngaben.email>0}error_block{/if}">
               <label for="email">{lang key="email" section="account data"}{if $Einstellungen.kunden.lieferadresse_abfragen_email=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="email" value="{$Lieferadresse->cMail}" id="email" />
               {if $fehlendeAngaben.email>0}
               <p class="error_text">{if $fehlendeAngaben.email==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.email==2}{lang key="invalidEmail" section="global"}{elseif $fehlendeAngaben.email==3}{lang key="blockedEmail" section="global"}{/if}</p>
               {/if}
            </li>
            {/if}
            
         </ul>
         <ul class="input_block">
         
            {if $Einstellungen.kunden.lieferadresse_abfragen_tel!="N"}
            <li class="clear {if $fehlendeAngaben.tel>0}error_block{/if}">
               <label for="tel">{lang key="tel" section="account data"}{if $Einstellungen.kunden.lieferadresse_abfragen_tel=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="tel" value="{$Lieferadresse->cTel}" id="tel" />
               {if $fehlendeAngaben.tel>0}
               <p class="error_text">
                  {if $fehlendeAngaben.tel==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.tel==2}{lang key="invalidTel" section="global"}{/if}
               </p>
               {/if}
            </li>
            {/if}
            
            {if $Einstellungen.kunden.lieferadresse_abfragen_fax!="N"}
            <li {if $fehlendeAngaben.fax>0}class="error_block"{/if}>
               <label for="fax">{lang key="fax" section="account data"}{if $Einstellungen.kunden.lieferadresse_abfragen_fax=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="fax" value="{$Lieferadresse->cFax}" id="fax" />
               {if $fehlendeAngaben.fax>0}
               <p class="error_text">
                  {if $fehlendeAngaben.fax==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.fax==2}{lang key="invalidTel" section="global"}{/if}
               </p>
               {/if}
            </li>
            {/if}
            
            {if $Einstellungen.kunden.lieferadresse_abfragen_mobil!="N"}
            <li {if $fehlendeAngaben.mobil>0}class="error_block"{/if}>
               <label for="mobile">{lang key="mobile" section="account data"}{if $Einstellungen.kunden.lieferadresse_abfragen_mobil=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="mobil" value="{$Lieferadresse->cMobil}" id="mobile" />
               {if $fehlendeAngaben.mobil>0}
               <p class="error_text">
                  {if $fehlendeAngaben.mobil==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.mobil==2}{lang key="invalidTel" section="global"}{/if}
               </p>
               {/if}
            </li>
            {/if}

            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            <input type="hidden" name="lieferdaten" value="1" />
         </ul>
      </div>
   </fieldset>
   <p class="box_plain tright"><input type="submit" value="{lang key="continueOrder" section="account data"}" class="submit" /></p>
</form>

{if isset($nWarenkorb2PersMerge) && $nWarenkorb2PersMerge == 1}
<script type="text/javascript">
    var cAnwort = confirm('{lang key="basket2PersMerge" section="login"}');
    if(cAnwort)
        window.location = "bestellvorgang.php?basket2Pers=1";
</script>
{/if}