{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="changePassword" section="login"}</h1>

   {if !$hinweis}
   <p class="box_info">{lang key="changePasswordDesc" section="login"}</p>
   {else}
   <p class="box_error">{$hinweis}</p>
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}

   <form id="password" action="jtl.php" method="post" class="form">
      <fieldset>
         <ul class="input_block">
            <li>
               <label for="currentPassword">{lang key="currentPassword" section="login"}<em>*</em>:</label>
               <input type="password" name="altesPasswort" id="currentPassword" />
            </li>
            
            <li class="clear">
               <label for="newPassword">{lang key="newPassword" section="login"}<em>*</em>:</label>
               <input type="password" name="neuesPasswort1" id="newPassword" />
            </li>
            
            <li>
               <label for="newPasswordRpt">{lang key="newPasswordRpt" section="login"}<em>*</em>:</label>
               <input type="password" name="neuesPasswort2" id="newPasswordRpt" />
            </li>
            
            <li class="clear">
               <input type="hidden" name="pass_aendern" value="1" />
               <input type="hidden" name="{$session_name}" value="{$session_id}" />
               <input type="submit" value="{lang key="changePassword" section="login"}" class="submit" />
            </li>
         </ul>
      </fieldset>
   </form>
   {include file='tpl_inc/inc_seite.tpl'}
</div>
