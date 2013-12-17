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
   <h1>{lang key="forgotPassword" section="global"}</h1>
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   {if $step=='formular'}
      
      {if !$hinweis}
      <p class="box_info">{lang key="forgotPasswordDesc" section="forgot password"}</p>
      {/if}
      
      {if $hinweis}
      <p class="box_error">{$hinweis}</p>
      {/if}
      
      <form id="passwort_vergessen" action="pass.php" method="post" class="form">
         <fieldset>
            <legend>{lang key="customerInformation" section="global"}</legend>
         
            <ul class="input_block">
               <li>
                  <label for="email">{lang key="emailadress" section="global"}<em>*</em>:</label>
                  <input type="text" name="email" id="email" />
               </li>
               <li>
                  <label for="plz">{lang key="plz" section="forgot password" alt_section="account data,"}<em>*</em>:</label>
                  <input type="text" name="plz" id="plz" />
               </li>
               <li class="clear">
                  <input type="hidden" name="passwort_vergessen" value="1" />
                  <input type="hidden" name="{$session_name}" value="{$session_id}" />
                  <input type="submit" class="submit submit_once" value="{lang key="createNewPassword" section="forgot password"}" />
               </li>      
         </fieldset>
      </form>
   {else}
      <p class="box_success">{lang key="newPasswortWasGenerated" section="forgot password"}</p>
   {/if}
</div>
{include file='tpl_inc/footer.tpl'}