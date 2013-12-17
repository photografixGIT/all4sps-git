{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<form action="" method="post" class="form tleft p100" id="article_availability">
   <h1>{lang key="requestNotification" section="global"}</h1>

   {if count($Artikelhinweise)>0}
      {foreach name=hinweise from=$Artikelhinweise item=Artikelhinweis}
         <p class="box_info">{$Artikelhinweis}</p>
      {/foreach}
   {/if}
   
   <fieldset>
      <ul class="input_block">
         {if $Einstellungen.$scope.benachrichtigung_abfragen_vorname!="N"}
            <li {if $fehlendeAngaben_benachrichtigung.vorname>0}class="error_block"{/if}>
               <label for="firstName">{lang key="firstName" section="account data"}{if $Einstellungen.$scope.benachrichtigung_abfragen_vorname=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="vorname" value="{$Benachrichtigung->cVorname}" id="firstName" />
               {if $fehlendeAngaben_benachrichtigung.vorname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
         {/if}
         
         {if $Einstellungen.$scope.benachrichtigung_abfragen_nachname!="N"}
            <li {if $fehlendeAngaben_benachrichtigung.nachname>0}class="error_block"{/if}>
               <label for="lastName">{lang key="lastName" section="account data"}{if $Einstellungen.$scope.benachrichtigung_abfragen_nachname=="Y"}<em>*</em>{/if}:</label>
               <input type="text" name="nachname" value="{$Benachrichtigung->cNachname}" id="lastName" />
               {if $fehlendeAngaben_benachrichtigung.nachname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
            </li>
         {/if}
         
         <li class="clear {if $fehlendeAngaben_benachrichtigung.email>0}error_block{/if}">
            <label for="email">{lang key="email" section="account data"}<em>*</em>:</label>
            <input type="text" name="email" value="{$Lieferadresse->cMail}" id="email" />
            {if $fehlendeAngaben_benachrichtigung.email>0}
            <p class="error_text">{if $fehlendeAngaben_benachrichtigung.email==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_benachrichtigung.email==2}{lang key="invalidEmail" section="global"}{elseif $fehlendeAngaben_benachrichtigung.email==3}{lang key="blockedEmail" section="global"}{/if}</p>
            {/if}
         </li>
         
         {if isset($Einstellungen.$scope.benachrichtigung_abfragen_captcha) && $Einstellungen.$scope.benachrichtigung_abfragen_captcha != "N"}
            {if $Einstellungen.$scope.benachrichtigung_abfragen_captcha == 4}
            <li class="clear {if $oPlausi->nPlausi_arr.captcha}error_block{/if}">
               <label for="captcha">{lang key="code" section="global"}<em>*</em>: <b>{$code_benachrichtigung_verfuegbarkeit->frage}</b></label>
               <input type="text" name="captcha" id="captcha" />
               {if $fehlendeAngaben_benachrichtigung.captcha > 0}<p class="error_text">{if $fehlendeAngaben_benachrichtigung.captcha==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_benachrichtigung.captcha==2}{lang key="invalidResult" section="global"}{/if}</p>{/if}
            </li>
            {else}
            <li class="clear {if $oPlausi->nPlausi_arr.captcha}error_block{/if}">
               <label for="captcha"><p>{lang key="code" section="global"}<em>*</em>:</p><img src="{$code_benachrichtigung_verfuegbarkeit->codeURL}" alt="{lang key="code" section="global"}" title="{lang key="code" section="global"}"></label>
               <input type="text" name="captcha" id="captcha" />
               {if $fehlendeAngaben_benachrichtigung.captcha > 0}<p class="error_text">{if $fehlendeAngaben_benachrichtigung.captcha==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_benachrichtigung.captcha==2}{lang key="invalidResult" section="global"}{/if}</p>{/if}
            </li>
            {/if}
         {/if}
      </ul>
   </fieldset>
   
   <p class="box_info tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
   
   <input type="hidden" name="a" value="{if $Artikel->kVariKindArtikel}{$Artikel->kVariKindArtikel}{else}{$Artikel->kArtikel}{/if}" />
   <input type="hidden" name="show" value="1" />
   <input type="hidden" name="benachrichtigung_verfuegbarkeit" value="1" />
   <input type="hidden" name="md5" value="{$code_benachrichtigung_verfuegbarkeit->codemd5}" />
   <input type="hidden" name="{$session_name}" value="{$session_id}" />
   <input type="submit" value="{lang key="requestNotification" section="global"}" class="submit" />
</form>