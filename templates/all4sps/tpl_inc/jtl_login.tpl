{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{if $oRedirect->cName|count_characters > 0}{$oRedirect->cName}{else}{lang key="loginTitle" section="login"}{/if}</h1>
   
   {if !$bCookieErlaubt}
      <div class="box_error">
         <strong>{lang key="noCookieHeader" section="errorMessages"}</strong>
         <p>{lang key="noCookieDesc" section="errorMessages"}</p>
      </div>
   {else}
   
      {if !$hinweis}
      <p class="box_info">{lang key="loginDesc" section="login"} {if $oRedirect->cName}{lang key="redirectDesc1" section="global"} {$oRedirect->cName} {lang key="redirectDesc2" section="global"}.{/if}</p>
      {/if}
      
      {if $hinweis}
      <p class="box_error">{$hinweis}</p>
      {/if}
      
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   <form id="login_form" action="jtl.php" method="post" class="form">
      <fieldset>
         <legend>{lang key="customerInformation" section="global"}</legend>
         <ul class="input_block">
            <li>
               <label for="email">{lang key="emailadress" section="global"}<em>*</em>:</label>
               <input type="text" name="email" id="email" />
            </li>
            <li>
               <label for="password">{lang key="password" section="account data" alt_section="global,"}<em>*</em>:</label>
               <input type="password" name="passwort" id="password" />
            </li>
            <li class="clear">
               <input type="hidden" name="login" value="1" />
               <input type="hidden" name="{$session_name}" value="{$session_id}" />
               {if $oRedirect->cURL|count_characters > 0}
               {foreach name=parameter from=$oRedirect->oParameter_arr item=oParameter}
               <input type="hidden" name="{$oParameter->Name}" value="{$oParameter->Wert}" />
               {/foreach}
               <input type="hidden" name="r" value="{$oRedirect->nRedirect}" />
               <input type="hidden" name="cURL" value="{$oRedirect->cURL}" />
               {/if}
               <input type="submit" class="submit" value="{lang key="login" section="checkout" alt_section="global,"}" />
            </li>
            <li>
               <p>&bull; <a href="pass.php?{$SID}">{lang key="forgotPassword" section="global"}</a></p>
               <p>&bull; {lang key="newHere" section="global"} <a href="registrieren.php?{$SID}">{lang key="registerNow" section="global"}</a></p>
            </li>  
         </ul>
      </fieldset>
   </form>
   {include file='tpl_inc/inc_seite.tpl'}
</div>