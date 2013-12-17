{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}

{if $step == "umfrage_uebersicht"}
   {include file='tpl_inc/umfrage_uebersicht.tpl'}
{elseif $step == "umfrage_durchfuehren"}
   {include file='tpl_inc/umfrage_durchfuehren.tpl'}
{elseif $step == "umfrage_ergebnis"}
   {include file='tpl_inc/umfrage_ergebnis.tpl'}
{/if}

{include file='tpl_inc/footer.tpl'}