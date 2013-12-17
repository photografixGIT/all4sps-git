{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<form action="index.php" method="post" class="form tleft" id="article_question">
   <h1>{lang key="productQuestion" section="productDetails"}</h1>
   
   {if count($Artikelhinweise)>0}
   {foreach name=hinweise from=$Artikelhinweise item=Artikelhinweis}
      <p class="box_info">{$Artikelhinweis}</p>
   {/foreach}
   {/if}
   
   <fieldset>
      <legend>{lang key="contactInformation" section="account data"}</legend>
      
      <ul class="input_block">
         {if $Einstellungen.artikeldetails.produktfrage_abfragen_anrede!="N"}
         <li>
            <label for="salutation">{lang key="salutation" section="account data"}<em>*</em>:</label>
            <select name="anrede" id="salutation">
               <option value="w" {if $Anfrage->cAnrede == "w"}selected="selected"{/if}>{$Anrede_w}</option>
               <option value="m" {if $Anfrage->cAnrede == "m"}selected="selected"{/if}>{$Anrede_m}</option>
            </select>
         </li>
         {/if}
      
         {if $Einstellungen.artikeldetails.produktfrage_abfragen_vorname!="N"}
         <li class="clear {if $fehlendeAngaben_fragezumprodukt.vorname>0}error_block{/if}">
            <label for="firstName">{lang key="firstName" section="account data"}{if $Einstellungen.artikeldetails.produktfrage_abfragen_vorname=="Y"}<em>*</em>{/if}:</label>
            <input type="text" name="vorname" value="{$Anfrage->cVorname}" id="firstName" />
            {if $fehlendeAngaben_fragezumprodukt.vorname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
         </li>
         {/if}
         
         {if $Einstellungen.artikeldetails.produktfrage_abfragen_nachname!="N"}
         <li {if $fehlendeAngaben_fragezumprodukt.nachname>0}class="error_block"{/if}>
            <label for="lastName">{lang key="lastName" section="account data"}{if $Einstellungen.artikeldetails.produktfrage_abfragen_nachname=="Y"}<em>*</em>{/if}:</label>
            <input type="text" name="nachname" value="{$Anfrage->cNachname}" id="lastName" />
            {if $fehlendeAngaben_fragezumprodukt.nachname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
         </li>
         {/if}
         
         {if $Einstellungen.artikeldetails.produktfrage_abfragen_firma!="N"}
         <li class="clear {if $fehlendeAngaben_fragezumprodukt.firma>0}error_block{/if}">
            <label for="firm">{lang key="firm" section="account data"}{if $Einstellungen.artikeldetails.produktfrage_abfragen_firma=="Y"}<em>*</em>{/if}:</label>
            <input type="text" name="firma" value="{$Anfrage->cFirma}" id="firm" />
            {if $fehlendeAngaben_fragezumprodukt.firma>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
         </li>
         {/if}
      
         <li class="clear {if $fehlendeAngaben_fragezumprodukt.email>0}error_block{/if}">
            <label for="question_email">{lang key="email" section="account data"}<em>*</em>:</label>
            <input type="text" name="email" value="{$Anfrage->cMail}" id="question_email" />
            {if $fehlendeAngaben_fragezumprodukt.email>0}
            <p class="error_text">{if $fehlendeAngaben_fragezumprodukt.email==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_fragezumprodukt.email==2}{lang key="invalidEmail" section="global"}{elseif $fehlendeAngaben_fragezumprodukt.email==3}{lang key="blockedEmail" section="global"}{/if}</p>
            {/if}
         </li>
      
         {if $Einstellungen.artikeldetails.produktfrage_abfragen_tel!="N"}
         <li class="clear {if $fehlendeAngaben_fragezumprodukt.tel>0}error_block{/if}">
            <label for="tel">{lang key="tel" section="account data"}{if $Einstellungen.artikeldetails.produktfrage_abfragen_tel=="Y"}<em>*</em>{/if}:</label>
            <input type="text" name="tel" value="{$Anfrage->cTel}" id="tel" />
            {if $fehlendeAngaben_fragezumprodukt.tel>0}
            <p class="error_text">
               {if $fehlendeAngaben_fragezumprodukt.tel==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_fragezumprodukt.tel==2}{lang key="invalidTel" section="global"}{/if}
            </p>
            {/if}
         </li>
         {/if}
         
         {if $Einstellungen.artikeldetails.produktfrage_abfragen_mobil!="N"}
         <li {if $fehlendeAngaben_fragezumprodukt.mobil>0}class="error_block"{/if}>
            <label for="mobile">{lang key="mobile" section="account data"}{if $Einstellungen.artikeldetails.produktfrage_abfragen_mobil=="Y"}<em>*</em>{/if}:</label>
            <input type="text" name="mobil" value="{$Anfrage->cMobil}" id="mobile" />
            {if $fehlendeAngaben_fragezumprodukt.mobil>0}
            <p class="error_text">
               {if $fehlendeAngaben_fragezumprodukt.mobil==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_fragezumprodukt.mobil==2}{lang key="invalidTel" section="global"}{/if}
            </p>
            {/if}
         </li>
      {/if}

      {if $Einstellungen.artikeldetails.produktfrage_abfragen_fax!="N"}
      <li {if $fehlendeAngaben_fragezumprodukt.fax>0}class="error_block"{/if}>
         <label for="fax">{lang key="fax" section="account data"}{if $Einstellungen.artikeldetails.produktfrage_abfragen_fax=="Y"}<em>*</em>{/if}:</label>
         <input type="text" name="fax" value="{$Anfrage->cFax}" id="fax" />
         {if $fehlendeAngaben_fragezumprodukt.fax>0}
         <p class="error_text">
            {if $fehlendeAngaben_fragezumprodukt.fax==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_fragezumprodukt.fax==2}{lang key="invalidTel" section="global"}{/if}
         </p>
         {/if}
      </li>
      {/if}
      
      <li class="clear {if $fehlendeAngaben_fragezumprodukt.nachricht>0}error_block{/if}">
         <label for="question">{lang key="question" section="productDetails"}<em>*</em>:</label>
         <textarea name="nachricht" id="question" cols="80" rows="8">{$Anfrage->cNachricht}</textarea>
         {if $fehlendeAngaben_fragezumprodukt.nachricht>0}
         <p class="error_text">{if $fehlendeAngaben_fragezumprodukt.nachricht>0}{lang key="fillOut" section="global"}{/if}</p>
         {/if}
      </li>
      
      {if isset($Einstellungen.artikeldetails.produktfrage_abfragen_captcha) && $Einstellungen.artikeldetails.produktfrage_abfragen_captcha != "N"}
         {if $Einstellungen.artikeldetails.produktfrage_abfragen_captcha == 4}
         <li class="clear {if $fehlendeAngaben_fragezumprodukt.captcha>0}error_block{/if}">
            <label for="captcha">{lang key="code" section="global"}<em>*</em>: <b>{$code_fragezumprodukt->frage}</b></label>
            <input type="text" name="captcha" id="captcha" />
            {if $fehlendeAngaben_fragezumprodukt.captcha > 0}
               <p class="error_text">
               {if $fehlendeAngaben_fragezumprodukt.captcha==1}
                  {lang key="fillOut" section="global"}
               {elseif $fehlendeAngaben_fragezumprodukt.captcha==2}
                  {lang key="invalidResult" section="global"}
               {/if}
               </p>
            {/if}
         </li>
         {else}
         <li class="clear {if $fehlendeAngaben_fragezumprodukt.captcha>0}error_block{/if}">
            <label for="captcha"><p>{lang key="code" section="global"}<em>*</em>:</p><img src="{$code_fragezumprodukt->codeURL}" alt="{lang key="code" section="global"}" title="{lang key="code" section="global"}"></label>
            <input type="text" name="captcha" id="captcha" />
            {if $fehlendeAngaben_fragezumprodukt.captcha > 0}
               <p class="error_text">
               {if $fehlendeAngaben_fragezumprodukt.captcha==1}
                  {lang key="fillOut" section="global"}
               {elseif $fehlendeAngaben_fragezumprodukt.captcha==2}
                  {lang key="invalidResult" section="global"}
               {/if}
               </p>
            {/if}
         </li>
         {/if}
      {/if}

      <li class="clear">
         {if $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen=="P" && $oSpezialseiten_arr[12] && $oSpezialseiten_arr[12]->cName}
            <p class="privacy right"><small><a href="{$oSpezialseiten_arr[12]->cURL}" onclick="return open_window('{$oSpezialseiten_arr[12]->cURL}?exclusive_content=1', 640, 640);">{$oSpezialseiten_arr[12]->cName}</a></small></p>
         {/if}
         <input type="hidden" name="a" value="{$Artikel->kArtikel}" />
         <input type="hidden" name="show" value="1" />
         <input type="hidden" name="fragezumprodukt" value="1" />
         <input type="hidden" name="md5" value="{$code_fragezumprodukt->codemd5}" />
         <input type="hidden" name="{$session_name}" value="{$session_id}" />
         <input type="submit" value="{lang key="sendQuestion" section="productDetails"}" class="submit" />
      </li>
      </ul>
   </fieldset>
</form>