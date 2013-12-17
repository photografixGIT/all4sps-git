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
   <h1>{lang key="newsletter" section="newsletter" alt_section="account data,"}</h1>
   
   {if isset($hinweis) && $hinweis|count_characters > 0}
      <div class="box_success">
         {$hinweis}
      </div>
   {/if}
   {if isset($fehler) && $fehler|count_characters > 0}
      <div class="box_error">
         {$fehler}
      </div>
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   {if $cOption == "eintragen"}
      {if !$bBereitsAbonnent}
      <form method="post" action="newsletter.php" class="form">
         <fieldset>
            <legend>{lang key="newsletterSubscribe" section="newsletter" alt_section="account data,"}</legend>
            <p class="box_plain">{lang key="newsletterSubscribeDesc" section="newsletter"}</p>
            
            <ul class="input_block">
               <li>
                  <label for="newslettertitle">{lang key="newslettertitle" section="newsletter"}:</label>
                  <select id="newslettertitle" name="cAnrede">
                     <option value="w"{if $oPlausi->cPost_arr.cAnrede == "w" || $oKunde->cAnrede == "w"} selected="selected"{/if}>{$Anrede_w}</option>
                     <option value="m"{if $oPlausi->cPost_arr.cAnrede == "m" || $oKunde->cAnrede == "m"} selected="selected"{/if}>{$Anrede_m}</option>
                  </select>
               </li>
               <li class="clear {if $oPlausi->nPlausi_arr.cVorname}error_block{/if}">
                  <label for="newsletterfirstname">{lang key="newsletterfirstname" section="newsletter"}:</label>
                  <input type="text" name="cVorname" value="{if $oPlausi->cPost_arr.cVorname}{$oPlausi->cPost_arr.cVorname}{else}{$oKunde->cVorname}{/if}" id="newsletterfirstname" />
                  {if $oPlausi->nPlausi_arr.cVorname}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               <li {if $oPlausi->nPlausi_arr.cNachname}class="error_block"{/if}>
                  <label for="lastName">{lang key="newsletterlastname" section="newsletter"}:</label>
                  <input type="text" name="cNachname" value="{if $oPlausi->cPost_arr.cNachname}{$oPlausi->cPost_arr.cNachname}{else}{$oKunde->cNachname}{/if}" id="lastName" />
                  {if $oPlausi->nPlausi_arr.cNachname}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               <li class="clear {if $oPlausi->nPlausi_arr.cEmail}error_block{/if}">
                  <label for="email">{lang key="newsletteremail" section="newsletter"}<em>*</em>:</label>
                  <input type="text" name="cEmail" value="{if $oPlausi->cPost_arr.cEmail}{$oPlausi->cPost_arr.cEmail}{else}{$oKunde->cMail}{/if}" id="email" />
                  {if $oPlausi->nPlausi_arr.cEmail}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {if isset($Einstellungen.newsletter.newsletter_sicherheitscode) && $Einstellungen.newsletter.newsletter_sicherheitscode != "N"}
                  {if $Einstellungen.newsletter.newsletter_sicherheitscode == 4}
                  <li class="clear {if $oPlausi->nPlausi_arr.captcha}error_block{/if}">
                     <label for="captcha">{lang key="code" section="global"}<em>*</em>: <b>{$code_newsletter->frage}</b></label>
                     <input type="text" name="captcha" id="captcha" />
                     {if $oPlausi->nPlausi_arr.captcha}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                  </li>
                  {else}
                  <li class="clear {if $oPlausi->nPlausi_arr.captcha}error_block{/if}">
                     <label for="captcha"><p>{lang key="code" section="global"}<em>*</em>:</p><img src="{$code_newsletter->codeURL}" alt="{lang key="code" section="global"}" title="{lang key="code" section="global"}"></label>
                     <input type="text" name="captcha" id="captcha" />
                     {if $oPlausi->nPlausi_arr.captcha}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                  </li>
                  {/if}
               {/if}
                  
               {getCheckBoxForLocation nAnzeigeOrt=$nAnzeigeOrt cPlausi_arr=$oPlausi->nPlausi_arr cPost_arr=$cPost_arr}
                  
               <li class="clear">
                  <input type="hidden" name="abonnieren" value="1" />
                  <input type="hidden" name="{$session_name}" value="{$session_id}" />
                  <input type="hidden" name="md5" value="{$code_newsletter->codemd5}" />
                  <button type="submit" class="submit"><span>{lang key="newsletterSendSubscribe" section="newsletter"}</span></button>
               </li>
            </ul>         
         </fieldset>
      </form>
      {/if}
      
      <form method="post" action="newsletter.php" name="newsletterabmelden" class="form">
         <fieldset>
            <legend>{lang key="newsletterUnsubscribe" section="newsletter"}</legend>
            <p class="box_plain">{lang key="newsletterUnsubscribeDesc" section="newsletter"}</p>
            <ul class="input_block">
               <li>
                  <label for="checkOut">{lang key="newsletteremail" section="newsletter"}<em>*</em>:</label>
                  <input type="text" name="cEmail" value="{$oKunde->cMail}" id="checkOut" />
               </li>
               <li class="clear">
                  <input type="hidden" name="abmelden" value="1" />
                  <input type="hidden" name="{$session_name}" value="{$session_id}" />
                  <button type="submit" class="submit"><span>{lang key="newsletterSendUnsubscribe" section="newsletter"}</span></button>
               </li>
            </ul>
         </fieldset>
      </form>
      <p class="box_info tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
   
   {elseif $cOption == "anzeigen"}
         {if isset($oNewsletterHistory) && $oNewsletterHistory->kNewsletterHistory > 0}
         <h2>{lang key="newsletterhistory" section="global"}</h2>
         <p class="box_plain">{lang key="newsletterdesc" section=""}</p>
         
         <div id="newsletterContent">      
            <div class="newsletter">            
            <p class="newsletterSubject"><strong>{lang key="newsletterdraftsubject" section="newsletter"}:</strong> {$oNewsletterHistory->cBetreff}</p>
            <p class="newsletterReference smallfont">{lang key="newsletterdraftdate" section="newsletter"}: {$oNewsletterHistory->Datum}</p>
         </div>
            
         <fieldset id="newsletterHtml">
            <legend>{lang key="newsletterHtml" section="newsletter"}</legend>
            {$oNewsletterHistory->cHTMLStatic}   
         </fieldset>            
         </div>
       {else}
          <div class="box_error">{lang key="newsletterhistoryNoHistory" section="newsletter"}</div>
       {/if}
   {/if}

   {include file='tpl_inc/inc_seite.tpl'}
</div>

{include file='tpl_inc/footer.tpl'}