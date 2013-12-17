{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<form id="new_customer" method="post" action="registrieren.php" class="form">
<fieldset class="outer">
   {if $hinweis}<p class="box_info">{$hinweis}</p>{/if}
   {if is_array($fehlendeAngaben) && $fehlendeAngaben|@count > 0 && !$hinweis}
      <p class="box_error">{lang key="yourDataDesc" section="account data"}</p>
   {/if}      

   {if $fehlendeAngaben.email_vorhanden==1}<p class="box_error">{lang key="emailAlreadyExists" section="account data"}</p>{/if}
   {if $fehlendeAngaben.formular_zeit==1}<p class="box_error">{lang key="formToFast" section="account data"}</p>{/if}
   
   {include file='tpl_inc/kundenformular.tpl'}
   
   {if !$editRechnungsadresse}
   <fieldset>
      <legend>{lang key="password" section="account data" alt_section="global,"}</legend>
      <ul class="input_block">
         <li {if $fehlendeAngaben.pass_zu_kurz>0 || $fehlendeAngaben.pass_ungleich>0}class="error_block"{/if}>
            <label for="password">{lang key="password" section="account data" alt_section="global,"}<em>*</em>:</label>
            <input type="password" name="pass" maxlength="20" id="password" />
            {if $fehlendeAngaben.pass_zu_kurz==1}<p class="error_text">{$warning_passwortlaenge}</p>{/if}
         </li>
         
         <li {if $fehlendeAngaben.pass_ungleich>0}class="error_block"{/if}>
            <label for="password2">{lang key="passwordRepeat" section="account data"}<em>*</em>:</label>
            <input type="password" name="pass2" maxlength="20" id="password2" />
            {if $fehlendeAngaben.pass_ungleich==1}<p class="error_text">{lang key="passwordsMustBeEqual" section="account data"}</p>{/if}
         </li>
         
         {*
         <li>
            <script type="text/javascript" src="{$currentTemplateDir}js/jquery.pstrength.1.1.js"></script>
            <script type="text/javascript">
               $('#password').pstrength({ldelim}verdects: ['{lang key="veryWeak" section="strength"}', '{lang key="weak" section="strength"}', '{lang key="medium" section="strength"}', '{lang key="strong" section="strength"}', '{lang key="stronger" section="strength"}']{rdelim});
            </script>
         </li>
         *}
      </ul>
   </fieldset>
   {/if}
   
   <p class="box_info tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
   
   <input type="hidden" name="checkout" value="{$checkout}" />
   <input type="hidden" name="{$session_name}" value="{$session_id}" />
   <input type="hidden" name="form" value="1" />
   <input type="hidden" name="editRechnungsadresse" value="{$editRechnungsadresse}" />
   <input type="submit" class="submit submit_once" value="{lang key="sendCustomerData" section="account data"}" />
</fieldset>
</form>
{include file='tpl_inc/inc_seite.tpl'}