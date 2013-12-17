{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="deleteAccount" section="login"}</h1>
   
   {if !$hinweis}
   <p class="box_error">{lang key="reallyDeleteAccount" section="login"}</p>
   {else}
   <p class="box_error">{$hinweis}</p>
   {/if}
   
   <form id="delete_account" action="jtl.php" method="post">
   <input type="hidden" name="del_acc" value="1" />
   <input type="hidden" name="{$session_name}" value="{$session_id}" />
   <input type="submit" class="submit" value="{lang key="deleteAccount" section="login"}" />
   </form>
   {include file='tpl_inc/inc_seite.tpl'}
</div>
