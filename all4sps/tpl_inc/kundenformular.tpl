{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 

<fieldset>
   <legend>{lang key="address" section="account data"}</legend>
   <ul class="input_block">
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_anrede!="N"}
      <li {if $fehlendeAngaben.anrede>0}class="error_block"{/if}>
         <label for="salutation">{lang key="salutation" section="account data"}<em>*</em>:</label>
         <select name="anrede" id="salutation">
            <option value="" selected="selected">{lang key="pleaseChoose" section="global"}</option>
            <option value="w" {if $Kunde->cAnrede == "w"}selected="selected"{/if}>{$Anrede_w}</option>
            <option value="m" {if $Kunde->cAnrede == "m"}selected="selected"{/if}>{$Anrede_m}</option>
         </select>
         {if $fehlendeAngaben.anrede>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      {/if}
   
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_titel!="N"}
      <li {if $fehlendeAngaben.titel>0}class="error_block"{/if}>
         <label for="title">{lang key="title" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_titel=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="titel" value="{$Kunde->cTitel}" id="title" />
         {if $fehlendeAngaben.titel>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      {/if}
   </ul>

   <ul class="input_block">
      <li class="clear {if $fehlendeAngaben.vorname>0}error_block{/if}">
         <label for="firstName">{lang key="firstName" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_pflicht_vorname=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="vorname" value="{$Kunde->cVorname}" id="firstName" />
         {if $fehlendeAngaben.vorname>0} 
           {if $fehlendeAngaben.vorname==1}
               <p class="error_text">{lang key="fillOut" section="global"}</p>
            {elseif $fehlendeAngaben.vorname==2}
               <p class="error_text">{lang key="firstNameNotNumeric" section="account data"}</p>
            {/if}
         {/if}
      </li>
      
      <li {if $fehlendeAngaben.nachname>0}class="error_block"{/if}>
         <label for="lastName">{lang key="lastName" section="account data"}<em>*</em>:</label>
         <input type="text" name="nachname" value="{$Kunde->cNachname}" id="lastName" />
         {if $fehlendeAngaben.nachname>0}
            {if $fehlendeAngaben.nachname==1}
               <p class="error_text">{lang key="fillOut" section="global"}</p>
            {elseif $fehlendeAngaben.nachname==2}
               <p class="error_text">{lang key="lastNameNotNumeric" section="account data"}</p>
            {/if}
         {/if}
      </li>

      {if $Einstellungen.kunden.kundenregistrierung_abfragen_firma != 'N'}       
      <li class="clear {if $fehlendeAngaben.firma>0}error_block{/if}">
         <label for="firm">{lang key="firm" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_firma=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="firma" value="{$Kunde->cFirma}" id="firm" />
         {if $fehlendeAngaben.firma>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      {/if}
      
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_firmazusatz != 'N'}       
      <li class="clear {if $fehlendeAngaben.firmazusatz>0}error_block{/if}">
         <label for="firmext">{lang key="firmext" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_firmazusatz=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="firmazusatz" value="{$Kunde->cZusatz}" id="firm" />
         {if $fehlendeAngaben.firmazusatz>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      {/if}
   </ul>
      
   <ul class="input_block clear">
      <li {if $fehlendeAngaben.strasse>0}class="error_block"{/if}>
         <label for="street">{lang key="street" section="account data"}<em>*</em>:</label>
         <input type="text" name="strasse" value="{$Kunde->cStrasse}" id="street" />
         {if $fehlendeAngaben.strasse>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      
      <li {if $fehlendeAngaben.hausnummer>0}class="error_block"{/if}>
         <label for="streetnumber">{lang key="streetnumber" section="account data"}<em>*</em>:</label>
         <input type="text" name="hausnummer" value="{$Kunde->cHausnummer}" id="streetnumber" />
         {if $fehlendeAngaben.hausnummer>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_adresszusatz!="N"}
      <li class="clear{if $fehlendeAngaben.adresszusatz>0} error_block{/if}">
         <label for="street2">{lang key="street2" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_adresszusatz=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="adresszusatz" value="{$Kunde->cAdressZusatz}" id="street2" />
         {if $fehlendeAngaben.adresszusatz>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      {/if}
   </ul>
      
   <ul class="input_block clear">
      <li {if $fehlendeAngaben.plz>0}class="error_block"{/if}>
         <label for="plz">{lang key="plz" section="account data"}<em>*</em>:</label>
         <input type="text" name="plz" value="{$Kunde->cPLZ}" id="plz" class="plz_input" onkeyup="getPLZList();" />
         {if $fehlendeAngaben.plz>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
   
      <li {if $fehlendeAngaben.ort>0}class="error_block"{/if}>
         <label for="city">{lang key="city" section="account data"}<em>*</em>:</label>
         <input type="text" name="ort" value="{$Kunde->cOrt}" id="city" class="city_input" />
         {if $fehlendeAngaben.ort>0}
            {if $fehlendeAngaben.ort==3}
               <p class="error_text">{lang key="cityNotNumeric" section="account data"}</p>
            {else}
               <p class="error_text">{lang key="fillOut" section="global"}</p>
            {/if}
         {/if}
      </li>
      
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_bundesland!="N"}
      <li {if $fehlendeAngaben.bundesland>0}class="error_block"{/if}>
         <label for="state">{lang key="state" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_bundesland=="Y"}<em>*</em>{/if}:</label>
         <input type="text" title="{lang key=pleaseChoose}" name="bundesland" value="{$Kunde->cBundesland}" id="state" />
         {if $fehlendeAngaben.bundesland>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      {/if}
   
      <li>
         <label for="country">{lang key="country" section="account data"}<em>*</em>:</label>
         <select name="land" id="country" class="country_input">
            {foreach name=land from=$laender item=land}
            <option value="{$land->cISO}" {if ($Einstellungen.kunden.kundenregistrierung_standardland==$land->cISO && !$Kunde->cLand) || $Kunde->cLand==$land->cISO}selected="selected"{/if}>{$land->cName}</option>
            {/foreach}
         </select>
      </li>
   </ul>
      
   <ul class="input_block clear">
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_ustid!="N"}
      <li class="clear {if $fehlendeAngaben.ustid>0}error_block{/if}">
         <label for="ustid">{lang key="ustid" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_ustid=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="ustid" value="{$Kunde->cUSTID}" id="ustid" />
         {if $fehlendeAngaben.ustid>0}
         <p class="error_text">
            {if $fehlendeAngaben.ustid==1}{lang key="fillOut" section="global"}
            {elseif $fehlendeAngaben.ustid==2}{lang key="ustIDCaseTwo" section="global"}. {if $fehlendeAngaben.ustid_err|count > 0 && $fehlendeAngaben.ustid_err != false}{lang key="ustIDCaseTwoB" section="global"}: {$fehlendeAngaben.ustid_err}{/if}
            {elseif $fehlendeAngaben.ustid==5}{lang key="ustIDCaseFive" section="global"}.{/if}
         </p>
         {/if}
      </li>
      {/if}
   </ul>
</fieldset>

<fieldset>
   <legend>{lang key="contactInformation" section="account data"}</legend>
   <ul class="input_block clear">
      <li class="clear {if $fehlendeAngaben.email>0}error_block{/if}">
         <label for="email">{lang key="email" section="account data"}<em>*</em>:</label>
         <input type="text" name="email" value="{$Kunde->cMail}" id="email" />
         {if $fehlendeAngaben.email>0}
            <p class="error_text">
                {if $fehlendeAngaben.email==1}{lang key="fillOut" section="global"}
                {elseif $fehlendeAngaben.email==2}{lang key="invalidEmail" section="global"}
                {elseif $fehlendeAngaben.email==3}{lang key="blockedEmail" section="global"}
                {elseif $fehlendeAngaben.email==4}{lang key="noDnsEmail" section="account data"}{/if}
            </p>
         {/if}
      </li>
   
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_tel!="N"}
      <li class="clear {if $fehlendeAngaben.tel>0}error_block{/if}">
         <label for="tel">{lang key="tel" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_tel=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="tel" value="{$Kunde->cTel}" id="tel" />
         {if $fehlendeAngaben.tel>0}
         <p class="error_text">
            {if $fehlendeAngaben.tel==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.tel==2}{lang key="invalidTel" section="global"}{/if}
         </p>
         {/if}
      </li>
      {/if}
   </ul>
   
   <ul class="input_block clear">
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_fax!="N"}
      <li {if $fehlendeAngaben.fax>0}class="error_block"{/if}>
         <label for="fax">{lang key="fax" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_fax=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="fax" value="{$Kunde->cFax}" id="fax" />
         {if $fehlendeAngaben.fax>0}
         <p class="error_text">
            {if $fehlendeAngaben.fax==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.fax==2}{lang key="invalidTel" section="global"}{/if}
         </p>
         {/if}
      </li>
      {/if}
      
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_mobil!="N"}
      <li {if $fehlendeAngaben.mobil>0}class="error_block"{/if}>
         <label for="mobile">{lang key="mobile" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_mobil=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="mobil" value="{$Kunde->cMobil}" id="mobile" />
         {if $fehlendeAngaben.mobil>0}
         <p class="error_text">
            {if $fehlendeAngaben.mobil==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.mobil==2}{lang key="invalidTel" section="global"}{/if}
         </p>
         {/if}
      </li>
      {/if}

      {if $Einstellungen.kunden.kundenregistrierung_abfragen_www!="N"}
      <li class="clear {if $fehlendeAngaben.www>0}error_block{/if}">
         <label for="www">{lang key="www" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_www=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="www" value="{$Kunde->cWWW}" id="www" />
         {if $fehlendeAngaben.www>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      {/if}
   </ul>
   
   <ul class="input_block clear">
      {if $Einstellungen.kunden.kundenregistrierung_abfragen_geburtstag!="N"}
      <li class="clear {if $fehlendeAngaben.geburtstag>0}error_block{/if}">
         <label for="birthday">{lang key="birthday" section="account data"}{if $Einstellungen.kunden.kundenregistrierung_abfragen_geburtstag=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="geburtstag" value="{$Kunde->dGeburtstag}" id="birthday" class="birthday" />
         {if $fehlendeAngaben.geburtstag>0}
         <p class="error_text">
            {if $fehlendeAngaben.geburtstag==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.geburtstag==2}{lang key="invalidDateformat" section="global"}{elseif $fehlendeAngaben.geburtstag==3}{lang key="invalidDate" section="global"}{/if}
         </p>
         {/if}
      </li>
      
      <script type="text/javascript">
      jQuery(document).ready(function(){ldelim}
         $('input.birthday').simpleDatepicker({ldelim} startdate: '01.01.1900', chosendate: '{$Kunde->dGeburtstag}', x: 0, y: $('input.birthday').outerHeight(){rdelim});
      {rdelim});
      </script> 
      
      {/if}
   </ul>
</fieldset>

{*{if ($Einstellungen.kundenfeld.kundenfeld_anzeigen == "Y" && $oKundenfeld_arr|@count > 0) || ($Einstellungen.kunden.kundenregistrierung_newsletterabonnieren_anzeigen=="Y" && !$smarty.session.Kunde->kKunde) || $Einstellungen.kunden.kundenregistrierung_datenschutz_checkbox=="Y"}*}
{if $Einstellungen.kundenfeld.kundenfeld_anzeigen == "Y" && $oKundenfeld_arr|@count > 0}
<fieldset>
   <ul class="input_block">
   {foreach name=kundenfeld from=$oKundenfeld_arr item=oKundenfeld}
   {if $step == "formular" || $step == "unregistriert bestellen" || ($step == "rechnungsdaten" && $oKundenfeld->nEditierbar != 0)}
   {if ($oKundenfeld->nEditierbar >= 0 && $smarty.session.Kunde->kKunde == 0) || ($oKundenfeld->nEditierbar == 1 && $smarty.session.Kunde->kKunde > 0)}
      {assign var=kKundenfeld value=$oKundenfeld->kKundenfeld}
      <li class="clear {if $fehlendeAngaben.custom[$kKundenfeld]>0}error_block{/if}">
         <label for="custom_{$oKundenfeld->kKundenfeld}">{$oKundenfeld->cName}{if $oKundenfeld->nPflicht == 1}<em>*</em>{/if}:</label>
         {if $oKundenfeld->cTyp != "auswahl"}
         <input type="text" name="custom_{$oKundenfeld->kKundenfeld}" id="custom_{$oKundenfeld->kKundenfeld}" value="{if $step == 'formular' || 'unregistriert bestellen'}{$cKundenattribut_arr[$kKundenfeld]->cWert}{else}{$Kunde->cKundenattribut_arr[$kKundenfeld]->cWert}{/if}" />
         
         {if $fehlendeAngaben.custom[$kKundenfeld]>0}
         <p class="error_text">
         {if $fehlendeAngaben.custom[$kKundenfeld] == 1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.custom[$kKundenfeld] == 2}{lang key="invalidDateformat" section="global"}{elseif $fehlendeAngaben.custom[$kKundenfeld] == 3}{lang key="invalidDate" section="global"}{elseif $fehlendeAngaben.custom[$kKundenfeld] == 4}{lang key="invalidInteger" section="global"}{/if}
         </p>
         {/if}
         
         {else}
         <select name="custom_{$oKundenfeld->kKundenfeld}">
         {foreach name=select from=$oKundenfeld->oKundenfeldWert_arr item=oKundenfeldWert}
         <option value="{$oKundenfeldWert->cWert}" {if $step == 'formular'}{if $oKundenfeldWert->cWert == $cKundenattribut_arr[$kKundenfeld]->cWert}selected{/if}{else}{if $oKundenfeldWert->cWert == $Kunde->cKundenattribut_arr[$kKundenfeld]->cWert}selected{/if}{/if}>{$oKundenfeldWert->cWert}</option>
         {/foreach}
         </select>
         {/if}
      </li>
   {/if}
   {/if}
   {/foreach}
     
   {*   
   {if $Einstellungen.kunden.kundenregistrierung_datenschutz_checkbox=="Y"}
   <li class="clear {if $fehlendeAngaben.datenschutz>0}error_block{/if}">
      <label for="datenschutz">
         <input type="checkbox" name="datenschutz" value="Y" id="datenschutz" /> {lang key="privacyAccepted" section="account data"} (<a href="{$smarty.session.Link_Datenschutz[$smarty.session.cISOSprache]}" target="_blank">{lang key="read" section="account data"}</a>)
         {if $fehlendeAngaben.datenschutz>0}<p class="error_text">{lang key="pleasyAccept" section="account data"}</p>{/if}
      </label>
   </li>
   {/if}
   *}

   {*
   {if $Einstellungen.kunden.kundenregistrierung_newsletterabonnieren_anzeigen=="Y" && !$smarty.session.Kunde->kKunde}
   <li class="clear">
      <label for="newsletterabonnieren">
         <input type="checkbox" value="Y" id="newsletterabonnieren" /> {lang key="newsletterSubscribe" section="account data"}
      </label>
   </li>
   {/if}
   *}
   
   </ul>
</fieldset>
{/if}

{hasCheckBoxForLocation nAnzeigeOrt=$nAnzeigeOrt cPlausi_arr=$fehlendeAngaben cPost_arr=$cPost_arr bReturn="bHasCheckbox"}
{if $bHasCheckbox}
<fieldset>
    <ul class="input_block">
        {getCheckBoxForLocation nAnzeigeOrt=$nAnzeigeOrt cPlausi_arr=$fehlendeAngaben cPost_arr=$cPost_arr}
    </ul>
</fieldset>
{/if}

{if isset($Einstellungen.kunden.registrieren_captcha) && $Einstellungen.kunden.registrieren_captcha != "N" && (!isset($Kunde->kKunde) || $Kunde->kKunde == 0)}
<fieldset>
   <ul class="input_block">
   {if $Einstellungen.kunden.registrieren_captcha == 4}
      <li class="clear {if $fehlendeAngaben.captcha > 0}error_block{/if}">
           <label for="captcha">{lang key="code" section="global"}<em>*</em>: <b>{$code_registrieren->frage}</b></label>
           <input type="text" name="captcha" id="captcha" />
       {if $fehlendeAngaben.captcha > 0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
        </li>
    {else}
       <li class="clear {if $fehlendeAngaben.captcha > 0}error_block{/if}">
           <label for="captcha"><p>{lang key="code" section="global"}<em>*</em>:</p><img src="{$code_registrieren->codeURL}" alt="{lang key="code" section="global"}" title="{lang key="code" section="global"}"></label>
           <input type="text" name="captcha" id="captcha" />
       {if $fehlendeAngaben.captcha > 0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
        </li>
    {/if}
      </ul>
</fieldset>
<input type="hidden" name="md5" value="{$code_registrieren->codemd5}" />
{/if}