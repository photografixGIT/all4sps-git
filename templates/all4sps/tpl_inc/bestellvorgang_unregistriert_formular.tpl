{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<h1>{lang key="orderUnregistered" section="checkout"}</h1>

{if $hinweis}
<p class="box_error">{$hinweis}</p>
{/if}

<form id="neukunde" method="post" action="bestellvorgang.php" class="form">
<fieldset class="outer">
   {include file='tpl_inc/kundenformular.tpl'}

   <p class="box_info tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
   
   <input type="hidden" name="{$session_name}" value="{$session_id}" />
   <input type="hidden" name="unreg_form" value="1" />
   <input type="hidden" name="editRechnungsadresse" value="{$editRechnungsadresse}" />
   <div class="tright">
      <input type="submit" class="submit" value="{lang key="sendCustomerData" section="account data"}" />
   </div>
</fieldset>
</form>
{include file='tpl_inc/inc_seite.tpl'}
