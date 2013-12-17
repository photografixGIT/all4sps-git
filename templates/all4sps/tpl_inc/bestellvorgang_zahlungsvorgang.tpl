{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}

<div id="content">
   {if $smarty.session.Zahlungsart->nWaehrendBestellung == 1}
      <h1>{lang key="orderCompletedPre" section="checkout"}</h1>
   {else}
      <h1>{lang key="orderCompletedPost" section="checkout"}</h1>
   {/if}
   <div class="order_process">
   {include file='tpl_inc/bestellvorgang_positionen.tpl'}
   {include file='tpl_inc/bestellabschluss_weiterleitung.tpl'}
   </div>
</div>

{include file='tpl_inc/footer.tpl'}