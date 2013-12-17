{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="editBillingAdress" section="account data"}</h1>

   {if !$hinweis}
   <p class="box_info">{lang key="editBillingAdressDesc" section="login"}</p>
   {else}
   <p class="box_error">{$hinweis}</p>
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}

   <form id="rechnungsdaten" action="jtl.php" method="post" class="form">
      <fieldset class="outer">
      {include file='tpl_inc/kundenformular.tpl'}

      <p class="box_info tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
      
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      <input type="hidden" name="editRechnungsadresse" value="1" />
      <input type="hidden" name="edit" value="1" />   
      <input type="submit" class="submit" value="{lang key="editBillingAdress" section="account data"}" />
      </fieldset>
   </form>
   {include file='tpl_inc/inc_seite.tpl'}
</div>
