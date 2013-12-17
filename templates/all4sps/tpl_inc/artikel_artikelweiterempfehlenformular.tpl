{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<form id="article_recommendation" action="index.php" method="post" class="form tleft">
   <fieldset>
      <legend>{lang key="contactInformation" section="account data"}</legend>
      {* TODO *}
      {*{if $fehlendeAngaben_artikelweiterempfehlen.cEmail==1 || $fehlendeAngaben_artikelweiterempfehlen.cName==1 || $fehlendeAngaben_artikelweiterempfehlen.email == 3}*}
      {if isset($fehlendeAngaben_artikelweiterempfehlen) && $fehlendeAngaben_artikelweiterempfehlen|@count > 0}
         <p class="box_error">
         {if $fehlendeAngaben_artikelweiterempfehlen.cEmail==1 || $fehlendeAngaben_artikelweiterempfehlen.cName==1 || $fehlendeAngaben_artikelweiterempfehlen.cNameAbsender==1 || $fehlendeAngaben_artikelweiterempfehlen.cEmailAbsender==1}
            {lang key="fillOut" section="global"}
         {/if}
         {if $fehlendeAngaben_artikelweiterempfehlen.cEmail == 2 || $fehlendeAngaben_artikelweiterempfehlen.cEmailAbsender == 2}
            {lang key="blockedEmail" section="global"}
         {/if}
         </p>
      {/if}
      
      <ul class="input_block">
         <li{if $fehlendeAngaben_artikelweiterempfehlen.cNameAbsender} class="error_block"{/if}>
            <label for="nameabsender">{lang key="senderName" section="account data"}:<em>*</em></label>
            <input type="text" name="cNameAbsender" value="{if $cPost_arr.cNameAbsender}{$cPost_arr.cNameAbsender}{else}{$smarty.session.Kunde->cVorname} {$smarty.session.Kunde->cNachname}{/if}" id="nameabsender" />
         </li>
         
         <li{if $fehlendeAngaben_artikelweiterempfehlen.cEmailAbsender} class="error_block"{/if}>
            <label for="emailabsender">{lang key="senderEmail" section="account data"}:<em>*</em></label>
            <input type="text" name="cEmailAbsender" value="{if $cPost_arr.cEmailAbsender}{$cPost_arr.cEmailAbsender}{else}{$smarty.session.Kunde->cMail}{/if}" id="emailabsender" />
         </li>
      </ul>
      <ul class="input_block clear">
         <li{if $fehlendeAngaben_artikelweiterempfehlen.cName} class="error_block"{/if}>
            <label for="name">{lang key="receiverName" section="account data"}:<em>*</em></label>
            <input type="text" name="cName" value="{if $cPost_arr.cName}{$cPost_arr.cName}{/if}" id="name" />
         </li>
         
         <li{if $fehlendeAngaben_artikelweiterempfehlen.cEmail} class="error_block"{/if}>
            <label for="email">{lang key="receiverEmail" section="account data"}:<em>*</em></label>
            <input type="text" name="cEmail" value="{if $cPost_arr.cEmail}{$cPost_arr.cEmail}{/if}" id="email" />
         </li>
         
         {if isset($Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_captcha) && $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_captcha != "N"}
         {if $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_captcha == 4}
         <li class="clear {if $fehlendeAngaben_artikelweiterempfehlen.captcha>0}error_block{/if}">
            <label for="captcha">{lang key="code" section="global"}<em>*</em>: <b>{$code_weiterempfehlen->frage}</b></label>
            <input type="text" name="captcha" id="captcha" />
            {if $fehlendeAngaben_artikelweiterempfehlen.captcha > 0}
               <p class="error_text">
               {if $fehlendeAngaben_artikelweiterempfehlen.captcha==1}
                  {lang key="fillOut" section="global"}
               {elseif $fehlendeAngaben_artikelweiterempfehlen.captcha==2}
                  {lang key="invalidResult" section="global"}
               {/if}
               </p>
            {/if}
         </li>
         {else}
         <li class="clear {if $fehlendeAngaben_artikelweiterempfehlen.captcha>0}error_block{/if}">
            <label for="captcha"><p>{lang key="code" section="global"}<em>*</em>:</p><img src="{$code_weiterempfehlen->codeURL}" alt="{lang key="code" section="global"}" title="{lang key="code" section="global"}" /></label>
            <input type="text" name="captcha" id="captcha" />
            {if $fehlendeAngaben_artikelweiterempfehlen.captcha > 0}
               <p class="error_text">
               {if $fehlendeAngaben_artikelweiterempfehlen.captcha==1}
                  {lang key="fillOut" section="global"}
               {elseif $fehlendeAngaben_artikelweiterempfehlen.captcha==2}
                  {lang key="invalidResult" section="global"}
               {/if}
               </p>
            {/if}
         </li>
         {/if}
        {/if}
         <li class="clear">
            {if $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_anzeigen=="P" && $oSpezialseiten_arr[12] && $oSpezialseiten_arr[12]->cName}
               <p class="privacy right"><small><a href="{$oSpezialseiten_arr[12]->cURL}" onclick="return open_window('{$oSpezialseiten_arr[12]->cURL}?exclusive_content=1', 640, 640);">{$oSpezialseiten_arr[12]->cName}</a></small></p>
            {/if}
            <input type="hidden" name="a" value="{$Artikel->kArtikel}" />
            <input type="hidden" name="show" value="1" />
            <input type="hidden" name="artikelweiterempfehlen" value="1" />
            <input type="hidden" name="md5" value="{$code_weiterempfehlen->codemd5}" />
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            <input type="submit" value="{lang key="sendRecommendation" section="productDetails"}" class="submit" />
         </li>
      </ul>
   </fieldset>
</form>