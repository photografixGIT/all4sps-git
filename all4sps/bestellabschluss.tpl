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
   
   {if $smarty.session.Zahlungsart->nWaehrendBestellung == 1}
   <h1>{lang key="orderCompletedPre" section="checkout"}</h1>
   {elseif $Bestellung->Zahlungsart->cModulId != 'za_kreditkarte_jtl' && $Bestellung->Zahlungsart->cModulId != 'za_lastschrift_jtl'}
   <h1>{lang key="orderCompletedPost" section="checkout"}</h1>
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   <div class="order_completed">
   {include file='tpl_inc/bestellabschluss_weiterleitung.tpl'}                                    
   {if $oTrustedShopsBewertenButton->cPicURL|count_characters > 0}
      <div class="container"><a href="{$oTrustedShopsBewertenButton->cURL}" target="_blank"><img src="{$oTrustedShopsBewertenButton->cPicURL}" /></a></div>
   {/if}
   {if isset($abschlussseite)}
      {include file='tpl_inc/bestellabschluss_fertig.tpl'}
   {/if}
   </div>
</div>
{include file='tpl_inc/footer.tpl'}