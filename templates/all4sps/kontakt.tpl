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
    <h1>{$Spezialcontent->titel}</h1>
    
    {if $hinweis}
        <br>
        <div class="box_info">
            {$hinweis}
        </div>
    {/if}
    {if $fehler}
        <br>
        <div class="box_error">
            {$fehler}
        </div>
    {/if}
    <br>
    
    {include file="tpl_inc/inc_extension.tpl"}

   {if $step=="formular"}
      {if $Spezialcontent->oben|@strlen > 0}
      <div class="custom_content">
      {$Spezialcontent->oben}
      </div>
      {/if}

      <form class="form" name="contact" action="kontakt.php" method="post">
         <fieldset>
            <legend>{lang key="contact" section="global"}</legend>
            <ul class="input_block">
               {if $Einstellungen.kontakt.kontakt_abfragen_anrede!="N"}
               <li>
                  <label for="salutation">{lang key="salutation" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_anrede=="Y"}<em>*</em>{/if}:</label>
                  <select name="anrede" id="salutation">
                     <option value="m" {if $Vorgaben->cAnrede == "m"}selected="selected"{/if}>{$Anrede_m}</option>
                     <option value="w" {if $Vorgaben->cAnrede == "w"}selected="selected"{/if}>{$Anrede_w}</option>
                  </select>
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_vorname!="N"}
               <li class="clear {if $fehlendeAngaben.vorname>0}error_block{/if}">
                  <label for="firstName">{lang key="firstName" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_vorname=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="vorname" value="{$Vorgaben->cVorname}" id="firstName" />
                  {if $fehlendeAngaben.vorname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_nachname!="N"}
               <li {if $fehlendeAngaben.nachname>0}class="error_block"{/if}>
                  <label for="lastName">{lang key="lastName" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_nachname=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="nachname" value="{$Vorgaben->cNachname}" id="lastName" />
                  {if $fehlendeAngaben.nachname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_firma!="N"}
               <li class="clear {if $fehlendeAngaben.firma>0}error_block{/if}">
                  <label for="firm">{lang key="firm" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_firma=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="firma" value="{$Vorgaben->cFirma}" id="firm" />
                  {if $fehlendeAngaben.firma>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {/if}
               <li class="clear {if $fehlendeAngaben.email>0}error_block{/if}">
                  <label for="email">{lang key="email" section="account data"}<em>*</em>:</label>
                  <input type="text" name="email" value="{$Vorgaben->cMail}" id="email" />
                  {if $fehlendeAngaben.email>0}<p class="error_text">{if $fehlendeAngaben.email==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.email==2}{lang key="invalidEmail" section="global"}{elseif $fehlendeAngaben.email==3}{lang key="blockedEmail" section="global"}{/if}</p>{/if}
               </li>
               {if $Einstellungen.kontakt.kontakt_abfragen_tel!="N"}
               <li class="clear {if $fehlendeAngaben.tel>0}error_block{/if}">
                  <label for="tel">{lang key="tel" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_tel=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="tel" value="{$Vorgaben->cTel}" id="tel" />
                  {if $fehlendeAngaben.tel>0}<p class="error_text">{if $fehlendeAngaben.tel==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.tel==2}{lang key="invalidTel" section="global"}{/if}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_mobil!="N"}
               <li {if $fehlendeAngaben.mobil>0}class="error_block"{/if}>
                  <label for="mobile">{lang key="mobile" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_mobil=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="mobil" value="{$Vorgaben->cMobil}" id="mobile" />
                  {if $fehlendeAngaben.mobil>0}<p class="error_text">{if $fehlendeAngaben.mobil==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.mobil==2}{lang key="invalidTel" section="global"}{/if}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_fax!="N"}
               <li {if $fehlendeAngaben.fax>0}class="error_block"{/if}>
                  <label for="fax">{lang key="fax" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_fax=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="fax" value="{$Vorgaben->cFax}" id="fax" />
                  {if $fehlendeAngaben.fax>0}<p class="error_text">{if $fehlendeAngaben.fax==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.fax==2}{lang key="invalidTel" section="global"}{/if}</p>{/if}
               </li>
               {/if}
               
               {getCheckBoxForLocation nAnzeigeOrt=$nAnzeigeOrt cPlausi_arr=$fehlendeAngaben cPost_arr=$cPost_arr}
               
            </ul>
         </fieldset>
         
         <fieldset>
            <legend>{lang key="message" section="contact" alt_section="global,"}</legend>
            <ul class="input_block">
               {if $betreffs}
               <li>
                  <label for="subject">{lang key="subject" section="contact"}:</label>
                  <select name="subject" id="subject">
                     {foreach name=betreffs from=$betreffs item=betreff}
                     <option value="{$betreff->kKontaktBetreff}" {if $Vorgaben->kKontaktBetreff==$betreff->kKontaktBetreff}selected{/if}>{$betreff->AngezeigterName}</option>
                     {/foreach}
                  </select>
               </li>
               {/if}
               <li class="clear {if $fehlendeAngaben.nachricht>0}error_block{/if}">
                  <label for="message">{lang key="message" section="contact" alt_section="global,"}<em>*</em>:</label>
                  <textarea name="nachricht" class="frage" rows="10" cols="80" id="message">{$Vorgaben->cNachricht}</textarea>
                  {if $fehlendeAngaben.nachricht>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {if $Einstellungen.kontakt.kontakt_abfragen_captcha!="N"}
               {if $Einstellungen.kontakt.kontakt_abfragen_captcha==4}   
               <li class="clear {if $fehlendeAngaben.captcha>0}error_block{/if}">
                  <label for="code">{lang key="code" section="global"}<em>*</em>: <b>{$code->frage}</b></label>
                  <input type="text" name="captcha" id="code" />
                  {if $fehlendeAngaben.captcha>0}<p class="error_text">{if $fehlendeAngaben.captcha==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.captcha==2}{lang key="invalidResult" section="global"}{/if}</p>{/if}
               </li>
               {else}
               <li class="clear {if $fehlendeAngaben.captcha>0}error_block{/if}">
                  <label for="code"><p>{lang key="code" section="global"}<em>*</em>:</p><img src="{$code->codeURL}" alt="{lang key="code" section="global"}"></label>
                  <input type="text" name="captcha" id="code" />
                  {if $fehlendeAngaben.captcha>0}<p class="error_text">{if $fehlendeAngaben.captcha==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.captcha==2}{lang key="invalidResult" section="global"}{/if}</p>{/if}
               </li>
               {/if}
               {/if}
            </ul>
         </fieldset>
         
         {if $Spezialcontent->unten|@strlen > 0}
         <div class="custom_content">
         {$Spezialcontent->unten}
         </div>
         {/if}
        
         <input type="hidden" name="kontakt" value="1" />
         <input type="hidden" name="{$session_name}" value="{$session_id}" />
         <input type="hidden" name="md5" value="{$code->codemd5}" />
         
         <p class="box_info tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
         <button type="submit" class="submit submit_once"><span>{lang key="sendMessage" section="contact"}</span></button>
      </form>
      
   {elseif $step=="nachricht versendet"}
      <p class="box_success">{lang key="messageSent" section="contact"}</p>
   {elseif $step=="floodschutz"}
      <p class="box_error">{lang key="youSentUsAMessageShortTimeBefore" section="contact"}</p>
   {/if}
   
   {include file='tpl_inc/inc_seite.tpl'}
</div>
{include file='tpl_inc/footer.tpl'}